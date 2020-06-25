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
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace StackUtils {

// Iterate through `block` and remove nops.
void compact(Block* block);

// Stack signatures are like regular function signatures, but they are used to
// represent the stack parameters and results of arbitrary sequences of stacky
// instructions. They have to record whether they cover an unreachable
// instruction because their composition takes into account the polymorphic
// results of unreachable instructions.
struct StackSignature {
  Type params;
  Type results;
  bool unreachable;

  StackSignature()
    : params(Type::none), results(Type::none), unreachable(false) {}
  StackSignature(Type params, Type results, bool unreachable = false)
    : params(params), results(results), unreachable(unreachable) {}

  StackSignature(const StackSignature&) = default;
  StackSignature& operator=(const StackSignature&) = default;

  // Get the stack signature of `expr`
  explicit StackSignature(Expression* expr);

  // Get the stack signature of the range of instructions [first, last). The
  // sequence of instructions is assumed to be valid, i.e. their signatures
  // compose.
  template<class InputIt>
  explicit StackSignature(InputIt first, InputIt last)
    : params(Type::none), results(Type::none), unreachable(false) {
    // TODO: It would be more efficient to build the params in reverse order
    while (first != last) {
      *this += StackSignature(*first++);
    }
  }

  // Return `true` iff `next` composes after this stack signature.
  bool composes(const StackSignature& next) const;

  // Compose stack signatures. Assumes they actually compose.
  StackSignature& operator+=(const StackSignature& next);
  StackSignature operator+(const StackSignature& next) const;
};

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
