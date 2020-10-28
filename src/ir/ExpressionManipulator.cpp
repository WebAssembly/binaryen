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
    // Allocate a new copy, and copy the fields.

#define DELEGATE_ID original->_id

#define DELEGATE_START(id) \
  copy = wasm.allocator.alloc<id>(); \
  auto* castOriginal = original->cast<id>(); \
  WASM_UNUSED(castOriginal); \
  auto* castCopy = copy->cast<id>(); \
  WASM_UNUSED(castCopy);

#define DELEGATE_FIELD_CHILD(id, name) \
  tasks.push_back({ castOriginal->name, &castCopy->name });

#define DELEGATE_FIELD_CHILD_LIST(id, name) \
  castCopy->name.resize(castOriginal->name.size()); \
  for (Index i = 0; i < castOriginal->name.size(); i++) { \
    tasks.push_back({ castOriginal->name[i], &castCopy->name[i] }); \
  }

#define DELEGATE_FIELD_INT(id, name) \
  castCopy->name = castOriginal->name;

#define DELEGATE_FIELD_INT_ARRAY(id, name) \
  assert(castCopy->name.size() == castOriginal->name.size()); \
  for (Index i = 0; i < castOriginal->name.size(); i++) { \
    castCopy->name[i] = castOriginal->name[i]; \
  }

#define DELEGATE_FIELD_LITERAL(id, name) \
  castCopy->name = castOriginal->name;

#define DELEGATE_FIELD_NAME(id, name) \
  castCopy->name = castOriginal->name;

#define DELEGATE_FIELD_SCOPE_NAME(id, name) \
  castCopy->name = castOriginal->name;

#define DELEGATE_FIELD_SCOPE_NAME_LIST(id, name) \
  castCopy->name.resize(castOriginal->name.size()); \
  for (Index i = 0; i < castOriginal->name.size(); i++) { \
    castCopy->name[i] = castOriginal->name[i]; \
  }

#define DELEGATE_FIELD_SIGNATURE(id, name) \
  castCopy->name = castOriginal->name;

#define DELEGATE_FIELD_TYPE(id, name) \
  castCopy->name = castOriginal->name;

#define DELEGATE_FIELD_ADDRESS(id, name) \
  castCopy->name = castOriginal->name;

#include "wasm-delegations-fields.h"

    // The type can be simply copied.
    copy->type = original->type;

    // Write the copy to where it should be referred to.
    *task.destPointer = copy;
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
