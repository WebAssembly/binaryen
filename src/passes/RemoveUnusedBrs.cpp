/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Removes branches for which we go to where they go anyhow
//

#include <wasm.h>
#include <pass.h>
#include <ast_utils.h>

namespace wasm {

struct RemoveUnusedBrs : public WalkerPass<PostWalker<RemoveUnusedBrs, Visitor<RemoveUnusedBrs>>> {
  bool isFunctionParallel() { return true; }

  bool anotherCycle;

  // Whether a value can flow in the current path. If so, then a br with value
  // can be turned into a value, which will flow through blocks/ifs to the right place
  bool valueCanFlow;

  typedef std::vector<Expression**> Flows;

  // list of breaks that are currently flowing. if they reach their target without
  // interference, they can be removed (or their value forwarded TODO)
  Flows flows;

  // a stack for if-else contents, we merge their outputs
  std::vector<Flows> ifStack;

  static void visitAny(RemoveUnusedBrs* self, Expression** currp) {
    auto* curr = *currp;
    auto& flows = self->flows;

    if (curr->is<Break>()) {
      flows.clear();
      auto* br = curr->cast<Break>();
      if (!br->condition) { // TODO: optimize?
        // a break, let's see where it flows to
        flows.push_back(currp);
        self->valueCanFlow = true; // start optimistic
      } else {
        self->valueCanFlow = false;
      }
    } else if (curr->is<Return>()) {
      flows.clear();
      flows.push_back(currp);
      self->valueCanFlow = true; // start optimistic
    } else if (curr->is<If>()) {
      auto* iff = curr->cast<If>();
      if (iff->ifFalse) {
        assert(self->ifStack.size() > 0);
        for (auto* flow : self->ifStack.back()) {
          flows.push_back(flow);
        }
        self->ifStack.pop_back();
      }
    } else if (curr->is<Block>()) {
      // any breaks flowing to here are unnecessary, as we get here anyhow
      auto* block = curr->cast<Block>();
      auto name = block->name;
      if (name.is()) {
        size_t size = flows.size();
        size_t skip = 0;
        for (size_t i = 0; i < size; i++) {
          auto* flow = (*flows[i])->dynCast<Break>();
          if (flow && flow->name == name) {
            if (!flow->value || self->valueCanFlow) {
              if (!flow->value) {
                // br => nop
                ExpressionManipulator::nop<Break>(flow);
              } else {
                // br with value => value
                *flows[i] = flow->value;
              }
              skip++;
              self->anotherCycle = true;
            }
          } else if (skip > 0) {
            flows[i - skip] = flows[i];
          }
        }
        if (skip > 0) {
          flows.resize(size - skip);
        }
        // drop a nop at the end of a block, which prevents a value flowing
        while (block->list.size() > 0 && block->list.back()->is<Nop>()) {
          block->list.resize(block->list.size() - 1);
          self->anotherCycle = true;
        }
      }
    } else if (curr->is<Nop>()) {
      // ignore (could be result of a previous cycle)
      self->valueCanFlow = false;
    } else {
      // anything else stops the flow TODO: optimize loops?
      flows.clear();
      self->valueCanFlow = false;
    }
  }

  static void clear(RemoveUnusedBrs* self, Expression** currp) {
    self->flows.clear();
  }

  static void saveIfTrue(RemoveUnusedBrs* self, Expression** currp) {
    self->ifStack.push_back(std::move(self->flows));
  }

  void visitIf(If* curr) {
    if (!curr->ifFalse) {
      // if without an else. try to reduce   if (condition) br  =>  br_if (condition)
      Break* br = curr->ifTrue->dynCast<Break>();
      if (br && !br->condition) { // TODO: if there is a condition, join them
        br->condition = curr->condition;
        replaceCurrent(br);
        anotherCycle = true;
      }
    }
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(RemoveUnusedBrs* self, Expression** currp) {
    self->pushTask(visitAny, currp);

    auto* iff = (*currp)->dynCast<If>();

    if (iff) {
      self->pushTask(doVisitIf, currp);
      if (iff->ifFalse) {
      // we need to join up if-else control flow, and clear after the condition
        self->pushTask(scan, &iff->ifFalse);
        self->pushTask(saveIfTrue, currp); // safe the ifTrue flow, we'll join it later
      }
      self->pushTask(scan, &iff->ifTrue);
      self->pushTask(clear, currp); // clear all flow after the condition
      self->pushTask(scan, &iff->condition);
    } else {
      WalkerPass<PostWalker<RemoveUnusedBrs, Visitor<RemoveUnusedBrs>>>::scan(self, currp);
    }
  }

  void walk(Expression*& root) {
    // multiple cycles may be needed
    bool worked = false;
    do {
      anotherCycle = false;
      WalkerPass<PostWalker<RemoveUnusedBrs, Visitor<RemoveUnusedBrs>>>::walk(root);
      assert(ifStack.empty());
      // flows may contain returns, which are flowing out and so can be optimized
      for (size_t i = 0; i < flows.size(); i++) {
        auto* flow = (*flows[i])->cast<Return>(); // cannot be a break
        if (!flow->value) {
          // return => nop
          ExpressionManipulator::nop(flow);
          anotherCycle = true;
        } else if (valueCanFlow) {
          // return with value => value
          *flows[i] = flow->value;
          anotherCycle = true;
        }
      }
      flows.clear();
      if (anotherCycle) worked = true;
    } while (anotherCycle);
    // finally, we may have simplified ifs enough to turn them into selects
    struct Selectifier : public WalkerPass<PostWalker<Selectifier, Visitor<Selectifier>>> {
      void visitIf(If* curr) {
        if (curr->ifFalse) {
          // if with else, consider turning it into a select if there is no control flow
          // TODO: estimate cost
          EffectAnalyzer condition(curr->condition);
          if (!condition.hasSideEffects()) {
            EffectAnalyzer ifTrue(curr->ifTrue);
            if (!ifTrue.hasSideEffects()) {
              EffectAnalyzer ifFalse(curr->ifFalse);
              if (!ifFalse.hasSideEffects()) {
                auto* select = getModule()->allocator.alloc<Select>();
                select->condition = curr->condition;
                select->ifTrue = curr->ifTrue;
                select->ifFalse = curr->ifFalse;
                select->finalize();
                replaceCurrent(select);
              }
            }
          }
        }
      }
    };
    Selectifier selectifier;
    selectifier.setModule(getModule());
    selectifier.walk(root);
    if (worked) {
      // Our work may alter block and if types, they may now return
      struct TypeUpdater : public WalkerPass<PostWalker<TypeUpdater, Visitor<TypeUpdater>>> {
        void visitBlock(Block* curr) {
          curr->finalize();
        }
        void visitLoop(Loop* curr) {
          curr->finalize();
        }
        void visitIf(If* curr) {
          curr->finalize();
        }
      };
      TypeUpdater typeUpdater;
      typeUpdater.walk(root);
    }
  }
};

static RegisterPass<RemoveUnusedBrs> registerPass("remove-unused-brs", "removes breaks from locations that are not needed");

} // namespace wasm
