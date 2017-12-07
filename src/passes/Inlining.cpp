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
// By default, this does a conservative inlining of all functions that have
// exactly one use, and are fairly small. That should not increase code
// size, and may have speed benefits.
//
// When opt level is 3+ (-O3 or above), we more aggressively inline
// even functions with more than one use, that seem to be "lightweight"
// (no loops or calls etc.), so inlining them may get rid of call overhead
// that would be noticeable otherwise
//

#include <atomic>

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <ir/utils.h>
#include <ir/literal-utils.h>
#include <parsing.h>

namespace wasm {

// A limit on how big a function to inline when being careful about size
static const int CAREFUL_SIZE_LIMIT = 15;

// A limit on how big a function to inline when being more flexible. In
// particular it's nice that with this limit we can inline the clamp
// functions (i32s-div, f64-to-int, etc.), that can affect perf.
static const int FLEXIBLE_SIZE_LIMIT = 20;

// Useful into on a function, helping us decide if we can inline it
struct FunctionInfo {
  std::atomic<Index> calls;
  Index size;
  bool lightweight = true;
  bool usedGlobally = false; // in a table or export
  bool alwaysInline = false;

  bool worthInlining(PassOptions& options, bool allowMultipleInliningsPerFunction) {
    // if it's explicitly set to be inlined, just do it
    if (alwaysInline) return true;
    // if it's big, it's just not worth doing (TODO: investigate more)
    if (size > FLEXIBLE_SIZE_LIMIT) return false;
    // if it has one use, then inlining it would likely reduce code size
    // since we are just moving code around, + optimizing, so worth it
    // if small enough that we are pretty sure its ok
    if (calls == 1 && !usedGlobally && size <= CAREFUL_SIZE_LIMIT) return true;
    if (!allowMultipleInliningsPerFunction) return false;
    // more than one use, so we can't eliminate it after inlining,
    // so only worth it if we really care about speed and don't care
    // about size, and if it's lightweight so a good candidate for
    // speeding us up
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
    if (curr->flags & Function::Flags::AlwaysInline)
      (*infos)[curr->name].alwaysInline = true;
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
    // actually performed - if it is dead code, it's pointless to inline
    if (state->worthInlining.count(curr->target) &&
        curr->type != unreachable) {
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
    // we shouldn't inline into us if we are to be inlined
    // ourselves - that has the risk of cycles
    if (state->worthInlining.count(func->name) == 0) {
      walk(func->body);
    }
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

  NameInfoMap infos;

  bool firstIteration;

  void run(PassRunner* runner, Module* module) override {
    // keep going while we inline, to handle nesting. TODO: optimize
    firstIteration = true;
    while (1) {
      calculateInfos(module);
      if (!iteration(runner, module)) {
        return;
      }
      firstIteration = false;
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
        if (module->getFunctionOrNull(name)) {
          infos[name].usedGlobally = true;
        }
      }
    }
  }

  bool iteration(PassRunner* runner, Module* module) {
    // decide which to inline
    InliningState state;
    for (auto& func : module->functions) {
      // on the first iteration, allow multiple inlinings per function
      if (infos[func->name].worthInlining(runner->options, firstIteration /* allowMultipleInliningsPerFunction */)) {
        state.worthInlining.insert(func->name);
      }
    }
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
      for (auto& action : state.actionsForFunction[func->name]) {
        Name inlinedName = action.contents->name;
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
      doOptimize(inlinedInto, module, runner);
    }
    // remove functions that we no longer need after inlining
    auto& funcs = module->functions;
    funcs.erase(std::remove_if(funcs.begin(), funcs.end(), [&](const std::unique_ptr<Function>& curr) {
      auto name = curr->name;
      auto& info = infos[name];
      return inlinedUses.count(name) && inlinedUses[name] == info.calls && !info.usedGlobally;
    }), funcs.end());
    // return whether we did any work
    return inlinedUses.size() > 0;
  }

  // Run useful optimizations after inlining, things like removing
  // unnecessary new blocks, sharing variables, etc.
  void doOptimize(std::unordered_set<Function*>& funcs, Module* module, PassRunner* parentRunner) {
    // save the full list of functions on the side
    std::vector<std::unique_ptr<Function>> all;
    all.swap(module->functions);
    module->updateMaps();
    for (auto& func : funcs) {
      module->addFunction(func);
    }
    PassRunner runner(module, parentRunner->options);
    runner.setIsNested(true);
    runner.setValidateGlobally(false); // not a full valid module
    runner.add("precompute-propagate");
    runner.add("remove-unused-brs");
    runner.add("remove-unused-names");
    runner.add("coalesce-locals");
    runner.add("simplify-locals");
    runner.add("vacuum");
    runner.add("reorder-locals");
    runner.add("remove-unused-brs");
    runner.add("merge-blocks");
    runner.run();
    // restore all the funcs
    for (auto& func : module->functions) {
      func.release();
    }
    all.swap(module->functions);
    module->updateMaps();
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

