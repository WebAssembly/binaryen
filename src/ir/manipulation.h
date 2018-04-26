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

namespace wasm {

namespace ExpressionManipulator {
  // Re-use a node's memory. This helps avoid allocation when optimizing.
  template<typename InputType, typename OutputType>
  inline OutputType* convert(InputType *input) {
    static_assert(sizeof(OutputType) <= sizeof(InputType),
                  "Can only convert to a smaller size Expression node");
    input->~InputType(); // arena-allocaed, so no destructor, but avoid UB.
    OutputType* output = (OutputType*)(input);
    new (output) OutputType;
    return output;
  }

  // Convenience method for nop, which is a common conversion
  template<typename InputType>
  inline Nop* nop(InputType* target) {
    return convert<InputType, Nop>(target);
  }

  // Convert a node that allocates
  template<typename InputType, typename OutputType>
  inline OutputType* convert(InputType *input, MixedArena& allocator) {
    assert(sizeof(OutputType) <= sizeof(InputType));
    input->~InputType(); // arena-allocaed, so no destructor, but avoid UB.
    OutputType* output = (OutputType*)(input);
    new (output) OutputType(allocator);
    return output;
  }

  using CustomCopier = std::function<Expression*(Expression*)>;
  Expression* flexibleCopy(Expression* original, Module& wasm, CustomCopier custom);

  inline Expression* copy(Expression* original, Module& wasm) {
    auto copy = [](Expression* curr) {
        return nullptr;
    };
    return flexibleCopy(original, wasm, copy);
  }

  // Splice an item into the middle of a block's list
  void spliceIntoBlock(Block* block, Index index, Expression* add);
}

} // wasm

#endif // wams_ir_manipulation_h

