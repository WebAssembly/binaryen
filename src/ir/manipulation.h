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

#ifndef wasm_ir_manipulation_h
#define wasm_ir_manipulation_h

#include "wasm.h"

namespace wasm::ExpressionManipulator {

// Re-use a node's memory. This helps avoid allocation when optimizing.
template<typename InputType, typename OutputType>
inline OutputType* convert(InputType* input) {
  static_assert(sizeof(OutputType) <= sizeof(InputType),
                "Can only convert to a smaller size Expression node");
  input->~InputType(); // arena-allocaed, so no destructor, but avoid UB.
  OutputType* output = (OutputType*)(input);
  new (output) OutputType;
  return output;
}

// Convenience methods for certain instructions, which are common conversions
template<typename InputType> inline Nop* nop(InputType* target) {
  auto* ret = convert<InputType, Nop>(target);
  ret->finalize();
  return ret;
}

template<typename InputType>
inline RefNull* refNull(InputType* target, Type type) {
  assert(type.isNullable() && type.getHeapType().isBottom());
  auto* ret = convert<InputType, RefNull>(target);
  ret->finalize(type);
  return ret;
}

template<typename InputType>
inline Unreachable* unreachable(InputType* target) {
  auto* ret = convert<InputType, Unreachable>(target);
  ret->finalize();
  return ret;
}

// Convert a node that allocates
template<typename InputType, typename OutputType>
inline OutputType* convert(InputType* input, MixedArena& allocator) {
  assert(sizeof(OutputType) <= sizeof(InputType));
  input->~InputType(); // arena-allocaed, so no destructor, but avoid UB.
  OutputType* output = (OutputType*)(input);
  new (output) OutputType(allocator);
  return output;
}

// Copy using a flexible custom copy function. This function is called on each
// expression before copying it. If it returns a non-null value then that is
// used (effectively overriding the normal copy), and if it is null then we do a
// normal copy.
//
// The order of iteration here is *pre*-order, that is, parents before children,
// so that it is possible to override an expression and all its children.
// Children themselves are visited in normal order. For example, this is the
// order of the following expression:
//
//  (i32.add     ;; visited first (and children not visited, if overridden)
//    (call $a)  ;; visited second
//    (call $b)  ;; visited third
//  )
//
using CustomCopier = std::function<Expression*(Expression*)>;
Expression*
flexibleCopy(Expression* original, Module& wasm, CustomCopier custom);

inline Expression* copy(Expression* original, Module& wasm) {
  auto copy = [](Expression* curr) { return nullptr; };
  return flexibleCopy(original, wasm, copy);
}

// Splice an item into the middle of a block's list
void spliceIntoBlock(Block* block, Index index, Expression* add);
} // namespace wasm::ExpressionManipulator

#endif // wams_ir_manipulation_h
