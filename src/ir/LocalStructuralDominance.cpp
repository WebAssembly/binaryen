/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include "ir/iteration.h"
#include "ir/local-structural-dominance.h"
#include "support/small_vector.h"

namespace wasm {

LocalStructuralDominance::LocalStructuralDominance(Function* func,
                                                   Module& wasm,
                                                   Mode mode) {
  if (!wasm.features.hasReferenceTypes()) {
    // No references, so nothing to look at.
    return;
  }

  bool hasRefVar = false;
  for (auto var : func->vars) {
    for (auto type : var) {
      if (type.isRef()) {
        hasRefVar = true;
        break;
      }
    }
  }
  if (!hasRefVar) {
    return;
  }

  if (mode == NonNullableOnly) {
    bool hasNonNullableVar = false;
    for (auto var : func->vars) {
      for (auto type : var) {
        // Check if we have any non-nullable vars (or tuple vars with
        // non-nullable elements) at all.
        if (type.isNonNullable()) {
          hasNonNullableVar = true;
          break;
        }
      }
    }
    if (!hasNonNullableVar) {
      return;
    }
  }

  struct Scanner : public PostWalker<Scanner> {
    std::set<Index>& nonDominatingIndices;

    // The locals that have been set, and so at the current time, they
    // structurally dominate.
    std::vector<bool> localsSet;

    Scanner(Function* func, Mode mode, std::set<Index>& nonDominatingIndices)
      : nonDominatingIndices(nonDominatingIndices) {
      localsSet.resize(func->getNumLocals());

      // Parameters always dominate.
      for (Index i = 0; i < func->getNumParams(); i++) {
        localsSet[i] = true;
      }

      for (Index i = func->getNumParams(); i < func->getNumLocals(); i++) {
        auto localType = func->getLocalType(i);
        bool interesting = false;
        for (auto type : localType) {
          if (type.isRef() && (mode == All || type.isNonNullable())) {
            interesting = true;
            break;
          }
        }
        // Mark locals we don't need to care about as "set". We never do any
        // work for such a local.
        if (!interesting) {
          localsSet[i] = true;
        }
      }

      // Note that we do not need to start a scope for the function body.
      // Logically there is a scope there, but there is no code after it, so
      // there is nothing to clean up when that scope exits, so we may as well
      // not even create a scope. Just start walking the body now.
      walk(func->body);
    }

    using Locals = SmallVector<Index, 5>;

    // When we exit a control flow scope, we must undo the locals that it set.
    std::vector<Locals> cleanupStack;

    static void doBeginScope(Scanner* self, Expression** currp) {
      self->cleanupStack.emplace_back();
    }

    static void doEndScope(Scanner* self, Expression** currp) {
      for (auto index : self->cleanupStack.back()) {
        assert(self->localsSet[index]);
        self->localsSet[index] = false;
      }
      self->cleanupStack.pop_back();
    }

    static void doLocalSet(Scanner* self, Expression** currp) {
      auto index = (*currp)->cast<LocalSet>()->index;
      if (!self->localsSet[index]) {
        // This local is now set until the end of this scope.
        self->localsSet[index] = true;
        // If we are not in the topmost scope, note this for later cleanup.
        if (!self->cleanupStack.empty()) {
          self->cleanupStack.back().push_back(index);
        }
      }
    }

    static void scan(Scanner* self, Expression** currp) {
      // Use a loop to avoid recursing on the last child - we can just go
      // straight into a loop iteration for it.
      while (1) {
        Expression* curr = *currp;

        switch (curr->_id) {
          case Expression::Id::InvalidId:
            WASM_UNREACHABLE("bad id");

          // local.get can just be visited immediately, as it has no children.
          case Expression::Id::LocalGetId: {
            auto index = curr->cast<LocalGet>()->index;
            if (!self->localsSet[index]) {
              self->nonDominatingIndices.insert(index);
            }
            return;
          }
          case Expression::Id::LocalSetId: {
            auto* set = curr->cast<LocalSet>();
            if (!self->localsSet[set->index]) {
              self->pushTask(doLocalSet, currp);
            }
            // Immediately continue in the loop.
            currp = &set->value;
            continue;
          }

          // Control flow structures.
          case Expression::Id::BlockId: {
            auto* block = curr->cast<Block>();
            // Blocks with no name are never emitted in the binary format, so do
            // not create a scope for them.
            if (block->name.is()) {
              self->pushTask(Scanner::doEndScope, currp);
            }
            auto& list = block->list;
            for (int i = int(list.size()) - 1; i >= 0; i--) {
              self->pushTask(Scanner::scan, &list[i]);
            }
            if (block->name.is()) {
              // Just call the task immediately.
              doBeginScope(self, currp);
            }
            return;
          }
          case Expression::Id::IfId: {
            if (curr->cast<If>()->ifFalse) {
              self->pushTask(Scanner::doEndScope, currp);
              self->maybePushTask(Scanner::scan, &curr->cast<If>()->ifFalse);
              self->pushTask(Scanner::doBeginScope, currp);
            }
            self->pushTask(Scanner::doEndScope, currp);
            self->pushTask(Scanner::scan, &curr->cast<If>()->ifTrue);
            self->pushTask(Scanner::doBeginScope, currp);
            // Immediately continue in the loop.
            currp = &curr->cast<If>()->condition;
            continue;
          }
          case Expression::Id::LoopId: {
            self->pushTask(Scanner::doEndScope, currp);
            // Just call the task immediately.
            doBeginScope(self, currp);
            // Immediately continue in the loop.
            currp = &curr->cast<Loop>()->body;
            continue;
          }
          case Expression::Id::TryId: {
            auto& list = curr->cast<Try>()->catchBodies;
            for (int i = int(list.size()) - 1; i >= 0; i--) {
              self->pushTask(Scanner::doEndScope, currp);
              self->pushTask(Scanner::scan, &list[i]);
              self->pushTask(Scanner::doBeginScope, currp);
            }
            self->pushTask(Scanner::doEndScope, currp);
            // Just call the task immediately.
            doBeginScope(self, currp);
            // Immediately continue in the loop.
            currp = &curr->cast<Try>()->body;
            continue;
          }
          case Expression::Id::TryTableId: {
            self->pushTask(Scanner::doEndScope, currp);
            // Just call the task immediately.
            doBeginScope(self, currp);
            // Immediately continue in the try_table.
            currp = &curr->cast<TryTable>()->body;
            continue;
          }

          default: {
            // Control flow structures have been handled. This is an expression,
            // which we scan normally.
            assert(!Properties::isControlFlowStructure(curr));
            PostWalker<Scanner>::scan(self, currp);
            return;
          }
        }
      }
    }

    // Only local.set needs to be visited.
    void pushTask(TaskFunc func, Expression** currp) {
      // Visits to anything but a set can be ignored, so only very specific
      // tasks need to actually be pushed here. In particular, we don't want to
      // push tasks to call doVisit* when those callbacks do nothing.
      if (func == scan || func == doLocalSet || func == doBeginScope ||
          func == doEndScope) {
        PostWalker<Scanner>::pushTask(func, currp);
      }
    }
    void maybePushTask(TaskFunc func, Expression** currp) {
      if (*currp) {
        pushTask(func, currp);
      }
    }
  };

  Scanner(func, mode, nonDominatingIndices);
}

} // namespace wasm
