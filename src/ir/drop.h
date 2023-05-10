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

#ifndef wasm_ir_drop_h
#define wasm_ir_drop_h

#include "wasm.h"

namespace wasm {

struct PassOptions;

// Given an expression, returns a new expression that drops the given
// expression's unconditional children that cannot be removed outright due to
// their side effects. This is useful if we know the node is not needed but may
// need to keep the children around; this utility will automatically remove any
// children we do not actually need to keep, based on their effects.
//
// The caller must also pass in a last item to append to the output (which is
// typically what the original expression is replaced with).
//
// This function only operates on children that executes unconditionally. That
// is the case in almost all expressions, except for those with conditional
// execution, like if, which unconditionally executes the condition but then
// conditionally executes one of the two arms. The above function simply returns
// all children in order, so it does this to if:
//
//  (if
//    (condition)
//    (arm-A)
//    (arm-B)
//  )
// =>
//  (drop
//    (condition)
//  )
//  (drop
//    (arm-A)
//  )
//  (drop
//    (arm-B)
//  )
//  (appended last item)
//
// This is dangerous as it executes what were conditional children in an
// unconditional way. To avoid that issue, this function will only operate on
// unconditional children, and keep conditional ones as they were. That means
// it will not split up and drop the children of an if, for example. All we do
// in that case is drop the entire if and append the last item:
//
//  (drop
//    (if
//      (condition)
//      (arm-A)
//      (arm-B)
//    )
//  )
//  (appended last item)
//
// Also this function preserves other unremovable expressions like trys, pops,
// and named blocks.
//
// We can run in two modes: where we notice parent effects, and in that case we
// won't remove effects there (we'll keep a drop of the parent too), or we can
// ignore parent effects.
enum class DropMode { NoticeParentEffects, IgnoreParentEffects };
Expression*
getDroppedChildrenAndAppend(Expression* parent,
                            Module& wasm,
                            const PassOptions& options,
                            Expression* last,
                            DropMode mode = DropMode::NoticeParentEffects);

} // namespace wasm

#endif // wasm_ir_drop_h
