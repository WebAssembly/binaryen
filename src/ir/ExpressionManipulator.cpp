/*
 * Copyright 2017 WebAssembly Community Group participants
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

#include "ir/immediates.h"
#include "ir/load-utils.h"
#include "ir/utils.h"

namespace wasm {

namespace ExpressionManipulator {

Expression*
flexibleCopy(Expression* original, Module& wasm, CustomCopier custom) {
  struct CopyTask {
    // The thing to copy.
    Expression* original;
    // The location of the pointer to write the copy to.
    Expression** destPointer;
  };
  std::vector<CopyTask> tasks;
  Expression* ret;
  tasks.push_back({original, &ret});
  while (!tasks.empty()) {
    auto task = tasks.back();
    tasks.pop_back();
    // If the custom copier handled this one, we have nothing to do.
    auto* copy = custom(task.original);
    if (copy) {
      *task.destPointer = copy;
      continue;
    }
    // If the original is a null, just copy that. (This can happen for an
    // optional child.)
    auto* original = task.original;
    if (original == nullptr) {
      *task.destPointer = nullptr;
      continue;
    }
    // Allocate a new copy.
    switch (original->_id) {
      case Expression::Id::InvalidId:
      case Expression::Id::NumExpressionIds:
        WASM_UNREACHABLE("Invalid id");

#define DELEGATE(CLASS_TO_VISIT)                                               \
  case Expression::Id::CLASS_TO_VISIT##Id:                                     \
    copy = wasm.allocator.alloc<CLASS_TO_VISIT>(); \
    break;

#include "wasm-delegations.h"

#undef DELEGATE

    }

    // Point to the copy.
    *task.destPointer = copy;

    // Scan all the existing children (including nullptr ones).
    std::vector<Expression*> originalChildren;
    for (auto** child : ChildPointerIterator(original)) {
      originalChildren.push_back(*child);
    }
    std::vector<Expression**> copyPointers;
    for (auto** child : ChildPointerIterator(copy)) {
      copyPointers.push_back(child);
    }
    assert(originalChildren.size() == copyPointers.size());
    for (Index i = 0; i < originalChildren.size(); i++) {
      tasks.push_back({originalChildren[i], copyPointers[i]});
    }
    Immediates originalImmediates;
    visitImmediates(original, originalImmediates);
    ImmediatePointers copyImmediates;
    visitImmediates(copy, copyImmediates);
    #define COPY_IMMEDIATES(what) \
      assert(originalImmediates.what.size() == copyImmediates.what.size()); \
      for (Index i = 0; i < originalImmediates.what.size(); i++) { \
        *copyImmediates.what[i] = originalImmediates.what[i]; \
      }
    COPY_IMMEDIATES(scopeNames);
    COPY_IMMEDIATES(nonScopeNames);
    COPY_IMMEDIATES(bools);
    COPY_IMMEDIATES(uint8s);
    COPY_IMMEDIATES(ints);
    COPY_IMMEDIATES(uint64s);
    COPY_IMMEDIATES(literals);
    COPY_IMMEDIATES(types);
    COPY_IMMEDIATES(indexes);
    COPY_IMMEDIATES(addresses);
  }
  return ret;
}

// Splice an item into the middle of a block's list
void spliceIntoBlock(Block* block, Index index, Expression* add) {
  auto& list = block->list;
  if (index == list.size()) {
    list.push_back(add); // simple append
  } else {
    // we need to make room
    list.push_back(nullptr);
    for (Index i = list.size() - 1; i > index; i--) {
      list[i] = list[i - 1];
    }
    list[index] = add;
  }
  block->finalize(block->type);
}

} // namespace ExpressionManipulator

} // namespace wasm
