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

#include "ir/load-utils.h"
#include "ir/utils.h"

namespace wasm::ExpressionManipulator {

Expression*
flexibleCopy(Expression* original, Module& wasm, CustomCopier custom) {
  // Perform the copy using a stack of tasks (avoiding recusion).
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

// Allocate a new expression of the right type, and create cast versions of it
// for later operations.
#define DELEGATE_START(id)                                                     \
  copy = wasm.allocator.alloc<id>();                                           \
  [[maybe_unused]] auto* castOriginal = original->cast<id>();                  \
  [[maybe_unused]] auto* castCopy = copy->cast<id>();

// Handle each type of field, copying it appropriately.
#define DELEGATE_FIELD_CHILD(id, field)                                        \
  tasks.push_back({castOriginal->field, &castCopy->field});

// Iterate in reverse order here so we visit children in normal order.
#define DELEGATE_FIELD_CHILD_VECTOR(id, field)                                 \
  castCopy->field.resize(castOriginal->field.size());                          \
  for (auto i = int64_t(castOriginal->field.size()) - 1; i >= 0; i--) {        \
    tasks.push_back({castOriginal->field[i], &castCopy->field[i]});            \
  }

#define COPY_FIELD(field) castCopy->field = castOriginal->field;

#define DELEGATE_FIELD_INT(id, field) COPY_FIELD(field)
#define DELEGATE_FIELD_LITERAL(id, field) COPY_FIELD(field)
#define DELEGATE_FIELD_NAME(id, field) COPY_FIELD(field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field) COPY_FIELD(field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field) COPY_FIELD(field)
#define DELEGATE_FIELD_TYPE(id, field) COPY_FIELD(field)
#define DELEGATE_FIELD_HEAPTYPE(id, field) COPY_FIELD(field)
#define DELEGATE_FIELD_ADDRESS(id, field) COPY_FIELD(field)

#define COPY_FIELD_LIST(field)                                                 \
  for (Index i = 0; i < castOriginal->field.size(); i++) {                     \
    castCopy->field[i] = castOriginal->field[i];                               \
  }

#define COPY_VECTOR(field)                                                     \
  castCopy->field.resize(castOriginal->field.size());                          \
  COPY_FIELD_LIST(field)

#define COPY_ARRAY(field)                                                      \
  assert(castCopy->field.size() == castOriginal->field.size());                \
  COPY_FIELD_LIST(field)

#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field) COPY_VECTOR(field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field) COPY_VECTOR(field)
#define DELEGATE_FIELD_TYPE_VECTOR(id, field) COPY_VECTOR(field)

#define DELEGATE_FIELD_INT_ARRAY(id, field) COPY_ARRAY(field)
#define DELEGATE_FIELD_INT_VECTOR(id, field) COPY_VECTOR(field)

#include "wasm-delegations-fields.def"

    // The type can be simply copied.
    copy->type = original->type;

    // Write the copy to where it should be referred to.
    *task.destPointer = copy;
  }
  return ret;
}

// Splice an item into the middle of a block's list
void spliceIntoBlock(Block* block, Index index, Expression* add) {
  block->list.insertAt(index, add);
  block->finalize(block->type);
}

} // namespace wasm::ExpressionManipulator
