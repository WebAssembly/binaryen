/*
 * Copyright 2016 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
// Inlining.
//
// This uses some simple heuristics to decide when to inline.
//
// Two versions are provided: inlining and inlining-optimizing. You
// probably want the optimizing version, which will optimize locations
// we inlined into, as inlining by itself creates a block to house the
// inlined code, some temp locals, etc., which can usually be removed
// by optimizations. Note that the two versions use the same heuristics,
// so we don't take into account the overhead if you don't optimize
// afterwards. The non-optimizing version is mainly useful for debugging,
// or if you intend to run a full set of optimizations anyhow on
// everything later.
//

#include <atomic>

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "ir/literal-utils.h"
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "parsing.h"
#include "passes/opt-utils.h"

namespace wasm {

// A limit on how big a function to inline when being careful about size
static const int CAREFUL_SIZE_LIMIT = 15;

// A limit on how big a function to inline when being more flexible. In
// particular it's nice that with this limit we can inline the clamp
// functions (i32s-div, f64-to-int, etc.), that can affect perf.
static const int FLEXIBLE_SIZE_LIMIT = 20;

// A size so small that after optimizations, the inlined code will be
// smaller than the call instruction itself. 2 is a safe number because
// there is no risk of things like
//  (func $reverse (param $x i32) (param $y i32)
//   (call $something (get_local $y) (get_local $x))
//  )
// in which case the reversing of the params means we'll possibly need
// a block and a temp local. But that takes at least 3 nodes, and 2 < 3.
// More generally, with 2 items we may have a get_local, but no way to
// require it to be saved instead of directly consumed.
static const int INLINING_OPTIMIZING_WILL_DECREASE_SIZE_LIMIT = 2;

// Useful into on a function, helping us decide if we can inline it
struct FunctionInfo {
  std::atomic<Index> calls;
  Index size;
  std::atomic<bool> lightweight;
  bool usedGlobally; // in a table or export

  FunctionInfo() {
    calls = 0;
    size = 0;
    lightweight = true;
    usedGlobally = false;
  }

  bool worthInlining(PassOptions& options) {
    // if it's big, it's just not worth doing (TODO: investigate more)
    if (size > FLEXIBLE_SIZE_LIMIT) return false;
    // if it's so small we have a guarantee that after we optimize the
    // size will not increase, inline it
    if (size <= INLINING_OPTIMIZING_WILL_DECREASE_SIZE_LIMIT) return true;
    // if it has one use, then inlining it would likely reduce code size
    // since we are just moving code around, + optimizing, so worth it
    // if small enough that we are pretty sure its ok
    if (calls == 1 && !usedGlobally && size <= CAREFUL_SIZE_LIMIT) return true;
    // more than one use, so we can't eliminate it after inlining,
    // so only worth it if we really care about speed and don't care
    // about size, and if it's lightweight so a good candidate for
    // speeding us up.
    return options.optimizeLevel >= 3 && options.shrinkLevel == 0 && lightweight;
  }
};

typedef std::unordered_map<Name, FunctionInfo> NameInfoMap;

struct FunctionInfoScanner : public WalkerPass<PostWalker<FunctionInfoScanner>> {
  bool isFunctionParallel() override { return true; }

  FunctionInfoScanner(NameInfoMap* infos) : infos(infos) {}

  FunctionInfoScanner* create() override {
    return new FunctionInfoScanner(infos);
  }

  void visitLoop(Loop* curr) {
    // having a loop is not lightweight
    (*infos)[getFunction()->name].lightweight = false;
  }

  void visitCall(Call* curr) {
    assert(infos->count(curr->target) > 0); // can't add a new element in parallel
    (*infos)[curr->target].calls++;
    // having a call is not lightweight
    (*infos)[getFunction()->name].lightweight = false;
  }

  void visitFunction(Function* curr) {
    (*infos)[curr->name].size = Measurer::measure(curr->body);
  }

private:
  NameInfoMap* infos;
};

struct InliningAction {
  Expression** callSite;
  Function* contents;

  InliningAction(Expression** callSite, Function* contents) : callSite(callSite), contents(contents) {}
};

struct InliningState {
  std::unordered_set<Name> worthInlining;
  std::unordered_map<Name, std::vector<InliningAction>> actionsForFunction; // function name => actions that can be performed in it
};

struct Planner : public WalkerPass<PostWalker<Planner>> {
  bool isFunctionParallel() override { return true; }

  Planner(InliningState* state) : state(state) {}

  Planner* create() override {
    return new Planner(state);
  }

  void visitCall(Call* curr) {
    // plan to inline if we know this is valid to inline, and if the call is
    // actually performed - if it is dead code, it's pointless to inline.
    // we also cannot inline ourselves.
    if (state->worthInlining.count(curr->target) &&
        curr->type != unreachable &&
        curr->target != getFunction()->name) {
      // nest the call in a block. that way the location of the pointer to the call will not
      // change even if we inline multiple times into the same function, otherwise
      // call1(call2()) might be a problem
      auto* block = Builder(*getModule()).makeBlock(curr);
      replaceCurrent(block);
      assert(state->actionsForFunction.count(getFunction()->name) > 0); // can't add a new element in parallel
      state->actionsForFunction[getFunction()->name].emplace_back(&block->list[0], getModule()->getFunction(curr->target));
    }
  }

  void doWalkFunction(Function* func) {
    walk(func->body);
  }

private:
  InliningState* state;
};

// Core inlining logic. Modifies the outside function (adding locals as
// needed), and returns the inlined code.
static Expression* doInlining(Module* module, Function* into, InliningAction& action) {
  Function* from = action.contents;
  auto* call = (*action.callSite)->cast<Call>();
  Builder builder(*module);
  auto* block = Builder(*module).makeBlock();
  block->name = Name(std::string("__inlined_func$") + from->name.str);
  *action.callSite = block;
  // set up a locals mapping
  struct Updater : public PostWalker<Updater> {
    std::map<Index, Index> localMapping;
    Name returnName;
    Builder* builder;

    void visitReturn(Return* curr) {
      replaceCurrent(builder->makeBreak(returnName, curr->value));
    }
    void visitGetLocal(GetLocal* curr) {
      curr->index = localMapping[curr->index];
    }
    void visitSetLocal(SetLocal* curr) {
      curr->index = localMapping[curr->index];
    }
  } updater;
  updater.returnName = block->name;
  updater.builder = &builder;
  for (Index i = 0; i < from->getNumLocals(); i++) {
    updater.localMapping[i] = builder.addVar(into, from->getLocalType(i));
  }
  // assign the operands into the params
  for (Index i = 0; i < from->params.size(); i++) {
    block->list.push_back(builder.makeSetLocal(updater.localMapping[i], call->operands[i]));
  }
  // zero out the vars (as we may be in a loop, and may depend on their zero-init value
  for (Index i = 0; i < from->vars.size(); i++) {
    block->list.push_back(builder.makeSetLocal(updater.localMapping[from->getVarIndexBase() + i], LiteralUtils::makeZero(from->vars[i], *module)));
  }
  // generate and update the inlined contents
  auto* contents = ExpressionManipulator::copy(from->body, *module);
  updater.walk(contents);
  block->list.push_back(contents);
  block->type = call->type;
  // if the function returned a value, we just set the block containing the
  // inlined code to have that type. or, if the function was void and
  // contained void, that is fine too. a bad case is a void function in which
  // we have unreachable code, so we would be replacing a void call with an
  // unreachable; we need to handle
  if (contents->type == unreachable && block->type == none) {
    // make the block reachable by adding a break to it
    block->list.push_back(builder.makeBreak(block->name));
  }
  return block;
}

struct Inlining : public Pass {
  // whether to optimize where we inline
  bool optimize = false;

  // the information for each function. recomputed in each iteraction
  NameInfoMap infos;

  Index iterationNumber;

  void run(PassRunner* runner, Module* module) override {
    Index numFunctions = module->functions.size();
    // keep going while we inline, to handle nesting. TODO: optimize
    iterationNumber = 0;
    // no point to do more iterations than the number of functions, as
    // it means we infinitely recursing (which should
    // be very rare in practice, but it is possible that a recursive call
    // can look like it is worth inlining)
    while (iterationNumber <= numFunctions) {
#ifdef INLINING_DEBUG
      std::cout << "inlining loop iter " << iterationNumber << " (numFunctions: " << numFunctions << ")\n";
#endif
      calculateInfos(module);
      if (!iteration(runner, module)) {
        return;
      }
      iterationNumber++;
    }
  }

  void calculateInfos(Module* module) {
    infos.clear();
    // fill in info, as we operate on it in parallel (each function to its own entry)
    for (auto& func : module->functions) {
      infos[func->name];
    }
    PassRunner runner(module);
    runner.setIsNested(true);
    runner.add<FunctionInfoScanner>(&infos);
    runner.run();
    // fill in global uses
    // anything exported or used in a table should not be inlined
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        infos[ex->value].usedGlobally = true;
      }
    }
    for (auto& segment : module->table.segments) {
      for (auto name : segment.data) {
        infos[name].usedGlobally = true;
      }
    }
  }

  bool iteration(PassRunner* runner, Module* module) {
    // decide which to inline
    InliningState state;
    ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
      if (infos[func->name].worthInlining(runner->options)) {
        state.worthInlining.insert(func->name);
      }
    });
    if (state.worthInlining.size() == 0) return false;
    // fill in actionsForFunction, as we operate on it in parallel (each function to its own entry)
    for (auto& func : module->functions) {
      state.actionsForFunction[func->name];
    }
    // find and plan inlinings
    {
      PassRunner runner(module);
      runner.setIsNested(true);
      runner.add<Planner>(&state);
      runner.run();
    }
    // perform inlinings TODO: parallelize
    std::unordered_map<Name, Index> inlinedUses; // how many uses we inlined
    std::unordered_set<Function*> inlinedInto; // which functions were inlined into
    for (auto& func : module->functions) {
      // if we've inlined a function, don't inline into it in this iteration,
      // avoid risk of races
      // note that we do not risk stalling progress, as each iteration() will
      // inline at least one call before hitting this
      if (inlinedUses.count(func->name)) continue;
      for (auto& action : state.actionsForFunction[func->name]) {
        auto* inlinedFunction = action.contents;
        // if we've inlined into a function, don't inline it in this iteration,
        // avoid risk of races
        // note that we do not risk stalling progress, as each iteration() will
        // inline at least one call before hitting this
        if (inlinedInto.count(inlinedFunction)) continue;
        Name inlinedName = inlinedFunction->name;
#ifdef INLINING_DEBUG
        std::cout << "inline " << inlinedName << " into " << func->name << '\n';
#endif
        doInlining(module, func.get(), action);
        inlinedUses[inlinedName]++;
        inlinedInto.insert(func.get());
        assert(inlinedUses[inlinedName] <= infos[inlinedName].calls);
      }
    }
    // anything we inlined into may now have non-unique label names, fix it up
    for (auto func : inlinedInto) {
      wasm::UniqueNameMapper::uniquify(func->body);
    }
    if (optimize && inlinedInto.size() > 0) {
      OptUtils::optimizeAfterInlining(inlinedInto, module, runner);
    }
    // remove functions that we no longer need after inlining
    auto& funcs = module->functions;
    funcs.erase(std::remove_if(funcs.begin(), funcs.end(), [&](const std::unique_ptr<Function>& curr) {
      auto name = curr->name;
      auto& info = infos[name];
      bool canRemove = inlinedUses.count(name) && inlinedUses[name] == info.calls && !info.usedGlobally;
#ifdef INLINING_DEBUG
      if (canRemove) std::cout << "removing " << name << '\n';
#endif
      return canRemove;
    }), funcs.end());
    // return whether we did any work
    return inlinedUses.size() > 0;
  }
};

Pass *createInliningPass() {
  return new Inlining();
}

Pass *createInliningOptimizingPass() {
  auto* ret = new Inlining();
  ret->optimize = true;
  return ret;
}

} // namespace wasm

