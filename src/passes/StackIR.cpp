/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Operations on Stack IR.
//

#include "wasm.h"
#include "pass.h"
#include "wasm-stack.h"
#include "ir/iteration.h"
#include "ir/local-graph.h"

namespace wasm {

// Generate Stack IR from Binaryen IR

struct GenerateStackIR : public WalkerPass<PostWalker<GenerateStackIR>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new GenerateStackIR; }

  bool modifiesBinaryenIR() override { return false; }

  void doWalkFunction(Function* func) {
    BufferWithRandomAccess buffer;
    // a shim for the parent that a stackWriter expects - we don't need
    // it to do anything, as we are just writing to Stack IR
    struct Parent {
      Module* module;
      Parent(Module* module) : module(module) {}

      Module* getModule() {
        return module;
      }
      void writeDebugLocation(Expression* curr, Function* func) {
        WASM_UNREACHABLE();
      }
      Index getFunctionIndex(Name name) {
        WASM_UNREACHABLE();
      }
      Index getFunctionTypeIndex(Name name) {
        WASM_UNREACHABLE();
      }
      Index getGlobalIndex(Name name) {
        WASM_UNREACHABLE();
      }
    } parent(getModule());
    StackWriter<StackWriterMode::Binaryen2Stack, Parent> stackWriter(parent, buffer, false);
    stackWriter.setFunction(func);
    stackWriter.visitPossibleBlockContents(func->body);
    func->stackIR = make_unique<StackIR>();
    func->stackIR->swap(stackWriter.stackIR);
  }
};

Pass* createGenerateStackIRPass() {
  return new GenerateStackIR();
}

// Optimize

class StackIROptimizer {
  Function* func;
  PassOptions& passOptions;
  StackIR& insts;

public:
  StackIROptimizer(Function* func, PassOptions& passOptions) :
    func(func), passOptions(passOptions), insts(*func->stackIR.get()) {
    assert(func->stackIR);
  }

  void run() {
    dce();
    // FIXME: local2Stack is currently rather slow (due to localGraph),
    //        so for now run it only when really optimizing
    if (passOptions.optimizeLevel >= 3 || passOptions.shrinkLevel >= 1) {
      local2Stack();
    }
    removeUnneededBlocks();
    dce();
  }

private:
  // Passes.

  // Remove unreachable code.
  void dce() {
    bool inUnreachableCode = false;
    for (Index i = 0; i < insts.size(); i++) {
      auto* inst = insts[i];
      if (!inst) continue;
      if (inUnreachableCode) {
        // Does the unreachable code end here?
        if (isControlFlowBarrier(inst)) {
          inUnreachableCode = false;
        } else {
          // We can remove this.
          removeAt(i);
        }
      } else if (inst->type == unreachable) {
        inUnreachableCode = true;
      }
    }
  }

  // If ordered properly, we can avoid a set_local/get_local pair,
  // and use the value directly from the stack, for example
  //    [..produce a value on the stack..]
  //    set_local $x
  //    [..much code..]
  //    get_local $x
  //    call $foo ;; use the value, foo(value)
  // As long as the code in between does not modify $x, and has
  // no control flow branching out, we can remove both the set
  // and the get.
  void local2Stack() {
    // We use the localGraph to tell us if a get-set pair is indeed
    // a set that is read by that get, and only that get. Note that we run
    // this on the Binaryen IR, so we are assuming that no previous opt
    // has changed the interaction of local operations.
    // TODO: we can do this a lot faster, as we just care about linear
    //       control flow.
    LocalGraph localGraph(func);
    localGraph.computeInfluences();
    // We maintain a stack of relevant values. This contains:
    //  * a null for each actual value that the value stack would have
    //  * an index of each SetLocal that *could* be on the value
    //    stack at that location.
    const Index null = -1;
    std::vector<Index> values;
    // We also maintain a stack of values vectors for control flow,
    // saving the stack as we enter and restoring it when we exit.
    std::vector<std::vector<Index>> savedValues;
#ifdef STACK_OPT_DEBUG
    std::cout << "func: " << func->name << '\n' << insts << '\n';
#endif
    for (Index i = 0; i < insts.size(); i++) {
      auto* inst = insts[i];
      if (!inst) continue;
      // First, consume values from the stack as required.
      auto consumed = getNumConsumedValues(inst);
#ifdef STACK_OPT_DEBUG
      std::cout << "  " << i << " : " << *inst << ", " << values.size() << " on stack, will consume " << consumed << "\n    ";
      for (auto s : values) std::cout << s << ' ';
      std::cout << '\n';
#endif
      // TODO: currently we run dce before this, but if we didn't, we'd need
      //       to handle unreachable code here - it's ok to pop multiple values
      //       there even if the stack is at size 0.
      while (consumed > 0) {
        assert(values.size() > 0);
        // Whenever we hit a possible stack value, kill it - it would
        // be consumed here, so we can never optimize to it.
        while (values.back() != null) {
          values.pop_back();
          assert(values.size() > 0);
        }
        // Finally, consume the actual value that is consumed here.
        values.pop_back();
        consumed--;
      }
      // After consuming, we can see what to do with this. First, handle
      // control flow.
      if (isControlFlowBegin(inst)) {
        // Save the stack for when we end this control flow.
        savedValues.push_back(values); // TODO: optimize copies
        values.clear();
      } else if (isControlFlowEnd(inst)) {
        assert(!savedValues.empty());
        values = savedValues.back();
        savedValues.pop_back();
      } else if (isControlFlow(inst)) {
        // Otherwise, in the middle of control flow, just clear it
        values.clear();
      }
      // This is something we should handle, look into it.
      if (isConcreteType(inst->type)) {
        bool optimized = false;
        if (auto* get = inst->origin->dynCast<GetLocal>()) {
          // This is a potential optimization opportunity! See if we
          // can reach the set.
          if (values.size() > 0) {
            Index j = values.size() - 1;
            while (1) {
              // If there's an actual value in the way, we've failed.
              auto index = values[j];
              if (index == null) break;
              auto* set = insts[index]->origin->cast<SetLocal>();
              if (set->index == get->index) {
                // This might be a proper set-get pair, where the set is
                // used by this get and nothing else, check that.
                auto& sets = localGraph.getSetses[get];
                if (sets.size() == 1 && *sets.begin() == set) {
                  auto& setInfluences = localGraph.setInfluences[set];
                  if (setInfluences.size() == 1) {
                    assert(*setInfluences.begin() == get);
                    // Do it! The set and the get can go away, the proper
                    // value is on the stack.
#ifdef STACK_OPT_DEBUG
                    std::cout << "  stackify the get\n";
#endif
                    insts[index] = nullptr;
                    insts[i] = nullptr;
                    // Continuing on from here, replace this on the stack
                    // with a null, representing a regular value. We
                    // keep possible values above us active - they may
                    // be optimized later, as they would be pushed after
                    // us, and used before us, so there is no conflict.
                    values[j] = null;
                    optimized = true;
                    break;
                  }
                }
              }
              // We failed here. Can we look some more?
              if (j == 0) break;
              j--;
            }
          }
        }
        if (!optimized) {
          // This is an actual regular value on the value stack.
          values.push_back(null);
        }
      } else if (inst->origin->is<SetLocal>() && inst->type == none) {
        // This set is potentially optimizable later, add to stack.
        values.push_back(i);
      }
    }
  }

  // There may be unnecessary blocks we can remove: blocks
  // without branches to them are always ok to remove.
  // TODO: a branch to a block in an if body can become
  //       a branch to that if body
  void removeUnneededBlocks() {
    for (auto*& inst : insts) {
      if (!inst) continue;
      if (auto* block = inst->origin->dynCast<Block>()) {
        if (!BranchUtils::BranchSeeker::hasNamed(block, block->name)) {
          // TODO optimize, maybe run remove-unused-names
          inst = nullptr;
        }
      }
    }
  }

  // Utilities.

  // A control flow "barrier" - a point where stack machine
  // unreachability ends.
  bool isControlFlowBarrier(StackInst* inst) {
    switch (inst->op) {
      case StackInst::BlockEnd:
      case StackInst::IfElse:
      case StackInst::IfEnd:
      case StackInst::LoopEnd: {
        return true;
      }
      default: {
        return false;
      }
    }
  }

  // A control flow beginning.
  bool isControlFlowBegin(StackInst* inst) {
    switch (inst->op) {
      case StackInst::BlockBegin:
      case StackInst::IfBegin:
      case StackInst::LoopBegin: {
        return true;
      }
      default: {
        return false;
      }
    }
  }

  // A control flow ending.
  bool isControlFlowEnd(StackInst* inst) {
    switch (inst->op) {
      case StackInst::BlockEnd:
      case StackInst::IfEnd:
      case StackInst::LoopEnd: {
        return true;
      }
      default: {
        return false;
      }
    }
  }

  bool isControlFlow(StackInst* inst) {
    return inst->op != StackInst::Basic;
  }

  // Remove the instruction at index i. If the instruction
  // is control flow, and so has been expanded to multiple
  // instructions, remove them as well.
  void removeAt(Index i) {
    auto* inst = insts[i];
    insts[i] = nullptr;
    if (inst->op == StackInst::Basic) {
      return; // that was it
    }
    auto* origin = inst->origin;
    while (1) {
      i++;
      assert(i < insts.size());
      inst = insts[i];
      insts[i] = nullptr;
      if (inst && inst->origin == origin && isControlFlowEnd(inst)) {
        return; // that's it, we removed it all
      }
    }
  }

  Index getNumConsumedValues(StackInst* inst) {
    if (isControlFlow(inst)) {
      // If consumes 1; that's it.
      if (inst->op == StackInst::IfBegin) {
        return 1;
      }
      return 0;
    }
    // Otherwise, for basic instructions, just count the expression children.
    return ChildIterator(inst->origin).children.size();
  }
};

struct OptimizeStackIR : public WalkerPass<PostWalker<OptimizeStackIR>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new OptimizeStackIR; }

  bool modifiesBinaryenIR() override { return false; }

  void doWalkFunction(Function* func) {
    if (!func->stackIR) {
      return;
    }
    StackIROptimizer(func, getPassOptions()).run();
  }
};

Pass* createOptimizeStackIRPass() {
  return new OptimizeStackIR();
}

} // namespace wasm

