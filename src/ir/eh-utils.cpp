/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "ir/eh-utils.h"
#include "ir/branch-utils.h"
#include "ir/find_all.h"

namespace wasm {

namespace EHUtils {

// This returns three values, some of them as output parameters:
// - Return value: 'pop' expression (Expression*), when there is one in
//   first-descendant line. If there's no such pop, it returns null.
// - isPopNested: Whether the discovered 'pop' is nested within a block
// - popPtr: 'pop' expression's pointer (Expression**), when there is one found
//
// When 'catchBody' itself is a 'pop', 'pop''s pointer is null, because there is
// no way to get the given expression's address. But that's fine because pop's
// pointer is only necessary (in handleBlockNestedPops) to fix it up when it is
// nested, and if 'catchBody' itself is a pop, we don't need to fix it up.
static Expression*
getFirstPop(Expression* catchBody, bool& isPopNested, Expression**& popPtr) {
  Expression* firstChild = catchBody;
  isPopNested = false;
  popPtr = nullptr;
  // When there are multiple expressions within a catch body, an implicit
  // block is created within it for convenience purposes.
  auto* implicitBlock = catchBody->dynCast<Block>();

  // Go down the line for the first child until we reach a leaf. A pop should be
  // in that first-decendant line.
  Expression** firstChildPtr = nullptr;
  while (true) {
    if (firstChild->is<Pop>()) {
      popPtr = firstChildPtr;
      return firstChild;
    }

    if (Properties::isControlFlowStructure(firstChild)) {
      if (auto* iff = firstChild->dynCast<If>()) {
        // If's condition is a value child who comes before an 'if' instruction
        // in binary, it is fine if a 'pop' is in there. We don't allow a 'pop'
        // to be in an 'if''s then or else body because they are not first
        // descendants.
        firstChild = iff->condition;
        firstChildPtr = &iff->condition;
        continue;
      } else if (firstChild->is<Loop>()) {
        // We don't allow the pop to be included in a loop, because it cannot be
        // run more than once
        return nullptr;
      }
      if (firstChild->is<Block>()) {
        // If there are no branches that targets the implicit block, it will be
        // removed when written back. But if there are branches that target the
        // implicit block,
        // (catch $e
        //   (block $l0
        //     (pop i32) ;; within a block!
        //     (br $l0)
        //     ...
        //   )
        // This cannot be removed, so this is considered a nested pop (which we
        // should fix).
        if (firstChild == implicitBlock) {
          if (BranchUtils::BranchSeeker::has(implicitBlock,
                                             implicitBlock->name)) {
            isPopNested = true;
          }
        } else {
          isPopNested = true;
        }
      } else if (firstChild->is<Try>() || firstChild->is<TryTable>()) {
        isPopNested = true;
      } else {
        WASM_UNREACHABLE("Unexpected control flow expression");
      }
    }
    ChildIterator it(firstChild);
    if (it.getNumChildren() == 0) {
      return nullptr;
    }
    firstChildPtr = &*it.begin();
    firstChild = *firstChildPtr;
  }
}

bool containsValidDanglingPop(Expression* catchBody) {
  bool isPopNested = false;
  Expression** popPtr = nullptr;
  auto* pop = getFirstPop(catchBody, isPopNested, popPtr);
  return pop != nullptr && !isPopNested;
}

void handleBlockNestedPop(Try* try_, Function* func, Module& wasm) {
  Builder builder(wasm);
  for (Index i = 0; i < try_->catchTags.size(); i++) {
    Name tagName = try_->catchTags[i];
    auto* tag = wasm.getTag(tagName);
    if (tag->sig.params == Type::none) {
      continue;
    }

    auto* catchBody = try_->catchBodies[i];
    bool isPopNested = false;
    Expression** popPtr = nullptr;
    Expression* pop = getFirstPop(catchBody, isPopNested, popPtr);
    assert(pop && "Pop has not been found in this catch");

    // Change code like
    // (catch $e
    //   ...
    //   (block
    //     (pop i32)
    //   )
    // )
    // into
    // (catch $e
    //   (local.set $new
    //     (pop i32)
    //   )
    //   ...
    //   (block
    //     (local.get $new)
    //   )
    // )
    if (isPopNested) {
      assert(popPtr);
      Index newLocal = builder.addVar(func, pop->type);
      try_->catchBodies[i] =
        builder.makeSequence(builder.makeLocalSet(newLocal, pop), catchBody);
      *popPtr = builder.makeLocalGet(newLocal, pop->type);
    }
  }
}

void handleBlockNestedPops(Function* func, Module& wasm) {
  if (!wasm.features.hasExceptionHandling()) {
    return;
  }
  FindAll<Try> trys(func->body);
  for (auto* try_ : trys.list) {
    handleBlockNestedPop(try_, func, wasm);
  }
}

Pop* findPop(Expression* expr) {
  auto pops = findPops(expr);
  if (pops.size() == 0) {
    return nullptr;
  }
  assert(pops.size() == 1);
  return pops[0];
}

SmallVector<Pop*, 1> findPops(Expression* expr) {
  SmallVector<Pop*, 1> pops;
  SmallVector<Expression*, 8> work;
  work.push_back(expr);
  while (!work.empty()) {
    auto* curr = work.back();
    work.pop_back();
    if (auto* pop = curr->dynCast<Pop>()) {
      pops.push_back(pop);
    } else if (auto* try_ = curr->dynCast<Try>()) {
      // We don't go into inner catch bodies; pops in inner catch bodies
      // belong to the inner catches
      work.push_back(try_->body);
    } else {
      for (auto* child : ChildIterator(curr)) {
        work.push_back(child);
      }
    }
  }
  return pops;
};

} // namespace EHUtils

} // namespace wasm
