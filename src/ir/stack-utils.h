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

//
// stack-utils.h: Utilities for manipulating and analyzing stack machine code in
// the form of Stacky IR.
//
// Stacky IR represents stack machine code using normal Binaryen IR types by
// imposing the following structural constraints:
//
//  1. Function bodies and children of control flow (except If conditions) must
//     be blocks.
//
//  2. Blocks may have any Expressions except for Pops as children. The sequence
//     of instructions in a block follows the same validation rules as in
//     WebAssembly. That means that any expression may have a concrete type, not
//     just the final expression in the block.
//
//  3. All other children must be Pops, which are used to determine the input
//     stack type of each instruction. Pops may not have `unreachable` type.
//
// For example, the following Binaryen IR Function:
//
//   (func $foo (result i32)
//    (i32.add
//     (i32.const 42)
//     (i32.const 5)
//    )
//   )
//
// would look like this in Stacky IR:
//
//   (func $foo (result i32)
//    (block
//     (i32.const 42)
//     (i32.const 5)
//     (i32.add
//      (i32.pop)
//      (i32.pop)
//     )
//    )
//   )
//
// Notice that the sequence of instructions in the block is now identical to the
// sequence of instructions in raw WebAssembly.
//

#ifndef wasm_ir_stack_h
#define wasm_ir_stack_h

#include "ir/properties.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace StackUtils {

// Iterate through `block` and remove nops.
void removeNops(Block* block);

} // namespace StackUtils

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

  // Whether a block with this stack signature could be typed with `sig`.
  bool satisfies(Signature sig) const;

  // Compose stack signatures. Assumes they actually compose.
  StackSignature& operator+=(const StackSignature& next);
  StackSignature operator+(const StackSignature& next) const;

  bool operator==(const StackSignature& other) const {
    return params == other.params && results == other.results &&
           unreachable == other.unreachable;
  }
};

// Calculates stack machine data flow, associating the sources and destinations
// of all values in a block.
struct StackFlow {
  // The input (output) location at which a value of type `type` is consumed
  // (produced), representing the `index`th input into (output from) instruction
  // `expr`. `unreachable` is true iff the corresponding value is consumed
  // (produced) by the polymorphic behavior of an unreachable instruction
  // without being used by that instruction.
  struct Location {
    Expression* expr;
    Index index;
    Type type;
    bool unreachable;

    bool operator==(const Location& other) const {
      return expr == other.expr && index == other.index && type == other.type &&
             unreachable == other.unreachable;
    }
  };

  using LocationMap = std::unordered_map<Expression*, std::vector<Location>>;

  // Maps each instruction to the set of output locations producing its inputs.
  LocationMap srcs;

  // Maps each instruction to the set of input locations consuming its results.
  LocationMap dests;

  // Gets the effective stack signature of `expr`, which must be a child of the
  // block. If `expr` is unreachable, the returned signature will reflect the
  // values consumed and produced by its polymorphic unreachable behavior.
  StackSignature getSignature(Expression* expr);

  // Calculates `srcs` and `dests`.
  StackFlow(Block* curr);
};

} // namespace wasm

#endif // wasm_ir_stack_h
