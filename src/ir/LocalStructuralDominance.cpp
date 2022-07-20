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

namespace wasm {

LocalStructuralDominance::LocalStructuralDominance(Function* func) {
  auto num = func->getNumLocals();

  bool hasRef = false;
  for (Index i = 0; i < num; i++) {
    if (func->getLocalType(i).isRef()) {
      hasRef = true;
      break;
    }
  }
  if (!hasRef) {
    return;
  }

  // The locals that have been set, and so at the current time, they
  // structurally dominate.
  std::vector<bool> localsSet(num);

  // Parameters always dominate.
  for (Index i = 0; i < func->getNumParams(); i++) {
    localsSet[i] = true;
  }

  using Locals = SmallUnorderedSet<Index, 10>;

  // When we exit a control flow structure, we must undo the locals that it set.
  std::vector<Locals> cleanupStack;

  // Our main work stack.
  struct WorkItem {
    enum {
      // When we first see an expression we scan it and add work items for it
      // and its children.
      Scan,
      // Visit a specific instruction.
      Visit,
      // Enter or exit a scope
      EnterScope,
      ExitScope
    } op;

    Expression* curr;
  };
  std::vector<WorkItem> workStack;

  // The stack begins with a new scope for the function, and then we start on
  // the body. (Note that we don't need to exit that scope, that work would not
  // do anything useful.)
  workStack.push_back(WorkItem{WorkItem::Scan, func->body});
  workStack.push_back(WorkItem{WorkItem::EnterScope, nullptr});

  // A special marker for "start or finis/cleanup a scope". When we scan a block
  // we'll add its children to the stack + cleanup at the end. When we get to
  // the marker we'll pop the control flow stack and do any undoing we need to.
  // This could be anything, so Nop is arbitrary, it just needs to not collide
  // with anything else.
  Nop scopeStart, scopeEnd;

  while (!workStack.empty()) {
    auto item = workStack.back();
    workStack.pop_back();

    if (item.op == WorkItem::Scan) {
      if (!Properties::isControlFlowStructure(item.curr)) {
        // Simply scan the children and prepare to visit here afterwards.
        workStack.push_back(WorkItem{WorkItem::Visit, item.curr});
        for (auto* child : ChildIterator(item.curr).children) {
          workStack.push_back(WorkItem{WorkItem::Scan, *child});
        }
        continue;
      }

      // For a control flow instruction, we must handle scoping properly. First,
      // handle value children, as they are not involved in structuring (like
      // the If condition).
      for (auto* child : ValueChildIterator(item.curr)) {
        workStack.push_back(WorkItem{WorkItem::Scan, child});
      }

      // Next, go through the structure children. Blocks are special in that all
      // their children go in a single scope.
      if (item.curr->is<Block>()) {
        workStack.push_back(WorkItem{WorkItem::ExitScope, nullptr});
        for (auto* child : StructuralChildIterator(item.curr).children) {
          workStack.push_back(WorkItem{WorkItem::Scan, *child});
        }
        workStack.push_back(WorkItem{WorkItem::EnterScope, nullptr});
      } else {
        for (auto* child : StructuralChildIterator(item.curr).children) {
          workStack.push_back(WorkItem{WorkItem::ExitScope, nullptr});
          workStack.push_back(WorkItem{WorkItem::Scan, *child});
          workStack.push_back(WorkItem{WorkItem::EnterScope, nullptr});
        }
      }
    } else if (item.op == WorkItem::Visit) {
      if (auto* set = item.curr->dynCast<LocalSet>()) {
        auto index = set->index;
        if (func->getLocalType(index).isRef()) {
          if (!localsSet[index]) {
            // This local is now set until the end of this scope.
            localsSet[index] = true;
            cleanupStack.back().insert(index);
          }
        }
      } else if (auto* get = item.curr->dynCast<LocalGet>()) {
        auto index = get->index;
        if (func->getLocalType(index).isRef()) {
          if (!localsSet[index]) {
            nonDominatingIndexes.insert(index);
          }
        }
      }
    } else if (item.op == WorkItem::EnterScope) {
      cleanupStack.emplace_back();
    } else if (item.op == WorkItem::ExitScope) {
      assert(!cleanupStack.empty());
      for (auto index : cleanupStack.back()) {
        assert(localsSet[index]);
        localsSet[index] = false;
      }
      cleanupStack.pop_back();
    } else {
      WASM_UNREACHABLE("bad op");
    }
  }
}

} // namespace wasm
