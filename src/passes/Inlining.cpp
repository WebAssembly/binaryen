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
// For now, this does a conservative inlining of all functions that have
// exactly one use, and are fairly small. That should not increase code
// size, and may have speed benefits.
//

#include <atomic>

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <ast_utils.h>
#include <ast/literal-utils.h>
#include <parsing.h>

namespace wasm {

// A limit on how big a function to inline.
static const int INLINING_SIZE_LIMIT = 15;

// We only inline a function with a single use.
static const int SINGLE_USE = 1;

// A number of uses of a function that is too high for us to
// inline it to all those locations.
static const int TOO_MANY_USES_TO_INLINE = SINGLE_USE + 1;

// Map of function name => number of uses. We build the values in
// parallel, using atomic increments. This is safe because we never
// update the map itself in parallel, we only update the values,
// and so the map never allocates or moves values which could be
// a problem with atomics (in fact it would be a problem in general
// as well, not just with atomics, as we don't use a lock in
// parallel access, we depend on the map itself being constant
// when running multiple threads).
typedef std::map<Name, std::atomic<Index>> NameToAtomicIndexMap;

struct FunctionUseCounter : public WalkerPass<PostWalker<FunctionUseCounter>> {
  bool isFunctionParallel() override { return true; }

  FunctionUseCounter(NameToAtomicIndexMap* uses) : uses(uses) {}

  FunctionUseCounter* create() override {
    return new FunctionUseCounter(uses);
  }

  void visitCall(Call *curr) {
    assert(uses->count(curr->target) > 0); // can't add a new element in parallel
    (*uses)[curr->target]++;
  }

private:
  NameToAtomicIndexMap* uses;
};

struct InliningAction {
  Expression** callSite;
  Function* contents;

  InliningAction(Expression** callSite, Function* contents) : callSite(callSite), contents(contents) {}
};

struct InliningState {
  std::set<Name> canInline;
  std::map<Name, std::vector<InliningAction>> actionsForFunction; // function name => actions that can be performed in it
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
    if (state->canInline.count(curr->target) &&
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
    if (state->canInline.count(func->name) == 0) {
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
  block->type = call->type;
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
  return block;
}

struct Inlining : public Pass {
  // whether to optimize where we inline
  bool optimize = false;

  NameToAtomicIndexMap uses;

  void run(PassRunner* runner, Module* module) override {
    // keep going while we inline, to handle nesting. TODO: optimize
    calculateUses(module);
    while (iteration(runner, module)) {}
  }

  void calculateUses(Module* module) {
    // fill in uses, as we operate on it in parallel (each function to its own entry)
    for (auto& func : module->functions) {
      uses[func->name].store(0);
    }
    PassRunner runner(module);
    runner.setIsNested(true);
    runner.add<FunctionUseCounter>(&uses);
    runner.run();
    // anything exported or used in a table should not be inlined
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        uses[ex->value].store(TOO_MANY_USES_TO_INLINE);
      }
    }
    for (auto& segment : module->table.segments) {
      for (auto name : segment.data) {
        if (module->getFunctionOrNull(name)) {
          uses[name].store(TOO_MANY_USES_TO_INLINE);
        }
      }
    }
  }

  bool iteration(PassRunner* runner, Module* module) {
    // decide which to inline
    InliningState state;
    for (auto& func : module->functions) {
      auto name = func->name;
      auto numUses = uses[name].load();
      if (canInline(numUses) && worthInlining(module->getFunction(name))) {
        state.canInline.insert(name);
      }
    }
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
    // perform inlinings
    std::set<Name> inlined;
    std::set<Function*> inlinedInto;
    for (auto& func : module->functions) {
      for (auto& action : state.actionsForFunction[func->name]) {
        Name inlinedName = action.contents->name;
        doInlining(module, func.get(), action);
        inlined.insert(inlinedName);
        inlinedInto.insert(func.get());
        uses[inlinedName]--;
        assert(uses[inlinedName].load() == 0);
      }
    }
    // anything we inlined into may now have non-unique label names, fix it up
    for (auto func : inlinedInto) {
      wasm::UniqueNameMapper::uniquify(func->body);
    }
    if (optimize && inlinedInto.size() > 0) {
      doOptimize(inlinedInto, module, runner);
    }
    // remove functions that we managed to inline, their one use is gone
    auto& funcs = module->functions;
    funcs.erase(std::remove_if(funcs.begin(), funcs.end(), [&inlined](const std::unique_ptr<Function>& curr) {
      return inlined.count(curr->name) > 0;
    }), funcs.end());
    // return whether we did any work
    return inlined.size() > 0;
  }

  bool canInline(int numUses) {
    return numUses == SINGLE_USE;
  }

  bool worthInlining(Function* func) {
    return Measurer::measure(func->body) <= INLINING_SIZE_LIMIT;
  }

  // Run useful optimizations after inlining, things like removing
  // unnecessary new blocks, sharing variables, etc.
  void doOptimize(std::set<Function*>& funcs, Module* module, PassRunner* parentRunner) {
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

