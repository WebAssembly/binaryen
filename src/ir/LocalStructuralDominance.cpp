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
#include "support/small_set.h"
#include "support/small_vector.h"

namespace wasm {

LocalStructuralDominance::LocalStructuralDominance(Function* func,
                                                   Module& wasm,
                                                   Mode mode) {
  if (!wasm.features.hasReferenceTypes()) {
    // No references, so nothing to look at.
    return;
  }

  auto num = func->getNumLocals();

  bool hasRefVar = false;
  for (Index i = func->getNumParams(); i < num; i++) {
    if (func->getLocalType(i).isRef()) {
      hasRefVar = true;
      break;
    }
  }
  if (!hasRefVar) {
    return;
  }

  if (mode == IgnoreNullable) {
    bool hasNonNullableVar = false;
    for (auto var : func->vars) {
      // Check if we have any non-nullable vars at all.
      if (var.isNonNullable()) {
        hasNonNullableVar = true;
        break;
      }
    }
    if (!hasNonNullableVar) {
      return;
    }
  }

  struct Scanner : public PostWalker<Scanner> {
    std::set<Index>& nonDominatingIndexes;

    Scanner(Function* func, Mode mode, std::set<Index>& nonDominatingIndexes)
      : nonDominatingIndexes(nonDominatingIndexes) {
      auto num = func->getNumLocals();
      localsSet.resize(num);

      // Parameters always dominate.
      for (Index i = 0; i < func->getNumParams(); i++) {
        localsSet[i] = true;
      }

      for (Index i = func->getNumParams(); i < func->getNumLocals(); i++) {
        auto type = func->getLocalType(i);
        // Mark locals we don't need to care about as "set". We never do any
        // work for such a local.
        if (!type.isRef() || (mode == IgnoreNullable && type.isNullable())) {
          localsSet[i] = true;
        }
      }

      // We begin with a new scope for the function, and then we start on the
      // body. (Note that we don't need to exit that scope, that work would not
      // do anything useful.)
      doBeginScope(this, nullptr);

      walk(func->body);
    }

    // The locals that have been set, and so at the current time, they
    // structurally dominate.
    std::vector<bool> localsSet;

    using Locals = SmallVector<Index, 5>;

    // When we exit a control flow structure, we must undo the locals that it
    // set.
    std::vector<Locals> cleanupStack;

    static void doBeginScope(Scanner* self, Expression** currp) {
      // TODO: could push one only when first needed. Set a pointer to know.
      self->cleanupStack.emplace_back();
    }

    static void doEndScope(Scanner* self, Expression** currp) {
      assert(!self->cleanupStack.empty());
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
        self->cleanupStack.back().push_back(index);
      }
    }

    static void scan(Scanner* self, Expression** currp) {
      Expression* curr = *currp;

      switch (curr->_id) {
        case Expression::Id::InvalidId:
          WASM_UNREACHABLE("bad id");

        // local.get can just be visited immediately, as it has no children.
        case Expression::Id::LocalGetId: {
          auto index = curr->cast<LocalGet>()->index;
          if (!self->localsSet[index]) {
            self->nonDominatingIndexes.insert(index);
          }
          break;
        }
        case Expression::Id::LocalSetId: {
          auto* set = curr->cast<LocalSet>();
          if (!self->localsSet[set->index]) {
            self->pushTask(doLocalSet, currp);
          }
          self->pushTask(Scanner::scan, &set->value);
          break;
        }

        // Control flow structures.
        case Expression::Id::BlockId: {
          self->pushTask(Scanner::doEndScope, currp);
          auto& list = curr->cast<Block>()->list;
          for (int i = int(list.size()) - 1; i >= 0; i--) {
            self->pushTask(Scanner::scan, &list[i]);
          }
          self->pushTask(Scanner::doBeginScope, currp);
          break;
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
          self->pushTask(Scanner::scan, &curr->cast<If>()->condition);
          break;
        }
        case Expression::Id::LoopId: {
          self->pushTask(Scanner::doEndScope, currp);
          self->pushTask(Scanner::scan, &curr->cast<Loop>()->body);
          self->pushTask(Scanner::doBeginScope, currp);
          break;
        }
        case Expression::Id::TryId: {
          auto& list = curr->cast<Try>()->catchBodies;
          for (int i = int(list.size()) - 1; i >= 0; i--) {
            self->pushTask(Scanner::doEndScope, currp);
            self->pushTask(Scanner::scan, &list[i]);
            self->pushTask(Scanner::doBeginScope, currp);
          }
          self->pushTask(Scanner::doEndScope, currp);
          self->pushTask(Scanner::scan, &curr->cast<Try>()->body);
          self->pushTask(Scanner::doBeginScope, currp);
          break;
        }

        default: {
          // Control flow structures have been handled. This is an expression,
          // which we scan normally.
          assert(!Properties::isControlFlowStructure(curr));
          PostWalker<Scanner>::scan(self, currp);
        }
      }
    }

    // Only local.set needs to be visited.
    void pushTask(TaskFunc func, Expression** currp) {
      // Visits to anything but a set can be ignored, so only very specific
      // tasks need to actually be pushed here.
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

  Scanner(func, mode, nonDominatingIndexes);
}

} // namespace wasm
