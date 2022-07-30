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

  // The locals that have been set, and so at the current time, they
  // structurally dominate.
  std::vector<bool> localsSet(num);

  // Mark locals we don't need to care about as "set". We never do any work for
  // such a local.
  bool hasNonNullableVar = false;
  for (Index i = func->getNumParams(); i < func->getNumLocals(); i++) {
    auto type = func->getLocalType(i);
    if (!type.isRef() || (mode == IgnoreNullable && type.isNullable())) {
      localsSet[i] = true;
    }
    if (type.isNonNullable()) {
      hasNonNullableVar = true;
    }
  }
  if (mode == IgnoreNullable && !hasNonNullableVar) {
    return;
  }

  // Parameters always dominate.
  for (Index i = 0; i < func->getNumParams(); i++) {
    localsSet[i] = true;
  }

  using Locals = SmallUnorderedSet<Index, 5>;

  // When we exit a control flow structure, we must undo the locals that it set.
  std::vector<Locals> cleanupStack;

  // Our main work stack.
  struct WorkItem {
    enum {
      // When we first see an expression we scan it and add work items for it
      // and its children.
      Scan,
      // Visit a specific instruction. This is only ever called on a LocalSet
      // due to the optimizations below.
      Visit,
      // Enter or exit a scope
      EnterScope,
      ExitScope
    } op;

    Expression* curr;
  };
  SmallVector<WorkItem, 5> workStack;

  // The stack begins with a new scope for the function, and then we start on
  // the body. (Note that we don't need to exit that scope, that work would not
  // do anything useful.)
  workStack.push_back(WorkItem{WorkItem::Scan, func->body});
  workStack.push_back(WorkItem{WorkItem::EnterScope, nullptr});

  while (!workStack.empty()) {
    auto item = workStack.back();
    workStack.pop_back();

    if (item.op == WorkItem::Scan) {
      if (!Properties::isControlFlowStructure(item.curr)) {
#if 0
        auto childIterator = ChildIterator(item.curr);
        auto& children = childIterator.children;
        if (children.empty()) {
          // No children, so just visit here right now.
          //
          // The only such instruction we care about is a (relevant) local.get.
          if (auto* get = item.curr->dynCast<LocalGet>()) {
            auto index = get->index;
            if (!localsSet[index]) {
              nonDominatingIndexes.insert(index);
            }
          }

          continue;
        }

        // Otherwise, prepare to visit here after our children.
        //
        // The only such instruction we need to visit is a (relevant) local.set.
        if (auto* set = item.curr->dynCast<LocalSet>()) {
          auto index = set->index;
          if (!localsSet[index]) {
            workStack.push_back(WorkItem{WorkItem::Visit, set});
          }
        }
        for (auto* child : children) {
          workStack.push_back(WorkItem{WorkItem::Scan, *child});
        }

#else

        auto* curr = item.curr; // TODO move up

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id)                                                     \
  auto* cast = curr->cast<id>();                                               \
  WASM_UNUSED(cast); \
  if (DELEGATE_ID == Expression::LocalSetId) { /* type check here? */ \
    auto* set = cast->cast<LocalSet>(); \
    auto index = set->index; \
    if (!localsSet[index]) { \
      workStack.push_back(WorkItem{WorkItem::Visit, set}); \
    } \
  } else if (DELEGATE_ID == Expression::LocalGetId) { /* type check here? */ \
    /* no children, so just visit it right now */ \
    auto* get = cast->cast<LocalGet>(); \
    auto index = get->index; \
    if (!localsSet[index]) { \
      nonDominatingIndexes.insert(index); \
    } \
  }

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_CHILD(id, field)                                        \
  workStack.push_back(WorkItem{WorkItem::Scan, cast->field});

#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  if (cast->field) { workStack.push_back(WorkItem{WorkItem::Scan, cast->field}); }

#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"

#endif

        continue;
      }


      // First, go through the structure children. Blocks are special in that
      // all their children go in a single scope.
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

      // Next handle value children, which are not involved in structuring (like
      // the If condition).
      for (auto* child : ValueChildIterator(item.curr).children) {
        workStack.push_back(WorkItem{WorkItem::Scan, *child});
      }
    } else if (item.op == WorkItem::Visit) {
      auto* set = item.curr->cast<LocalSet>();
      auto index = set->index;
      if (!localsSet[index]) {
        // This local is now set until the end of this scope.
        localsSet[index] = true;
        cleanupStack.back().insert(index);
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
