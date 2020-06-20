/*
 * Copyright 2020 WebAssembly Community Group participants
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

#ifndef wasm_ir_stack_h
#define wasm_ir_stack_h

#include "ir/properties.h"
#include "wasm.h"

namespace wasm {

namespace StackUtils {

// Iterate through `block` and remove nops.
void compact(Block* block);

// Compute the input and output types of an instruction. If the instruction does
// not return, the output type will be `unreachable`.
Signature getStackSignature(Expression* curr);

// Compute the input and output types of a sequence of instructions. If an
// instruction in the sequence does not return, the input type will represent
// all values consumed up to that point and the output type will be
// `unreachable`.
template<class InputIt>
Signature getStackSignature(InputIt first, InputIt last) {
  // The input types for this region, constructed in reverse
  std::vector<Type> inputs;
  std::vector<Type> stack;
  for (InputIt expr = first; expr != last; ++expr) {
    auto sig = getStackSignature(*expr);
    const auto& params = sig.params.expand();
    for (auto type = params.rbegin(); type != params.rend(); ++type) {
      if (stack.size() == 0) {
        inputs.push_back(*type);
      } else {
        assert(stack.back() == *type);
        stack.pop_back();
      }
    }
    if (sig.results == Type::unreachable) {
      std::reverse(inputs.begin(), inputs.end());
      return Signature(Type(inputs), Type::unreachable);
    }
    for (auto type : sig.results.expand()) {
      stack.push_back(type);
    }
  }
  std::reverse(inputs.begin(), inputs.end());
  return Signature(Type(inputs), Type(stack));
}

// Calculates stack machine data flow, associating the sources and destinations
// of all values in a block.
struct StackFlow {
  // Either an input location or an output location. An input location
  // represents the `index`th input into instruction `expr` and an ouput
  // location represents the `index`th output from instruction `expr`.
  struct Location {
    Expression* expr;
    Index index;
  };

  // Maps each instruction to the set of output locations supplying its inputs.
  std::unordered_map<Expression*, std::vector<Location>> srcs;

  // Maps each instruction to the set of input locations consuming its results.
  std::unordered_map<Expression*, std::vector<Location>> dests;

  // Calculates `srcs` and `dests`.
  StackFlow(Block* curr);
};

} // namespace StackUtils

} // namespace wasm

#endif // wasm_ir_stack_h
