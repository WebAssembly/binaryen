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
// the form of Poppy IR. See src/passes/Poppify.cpp for Poppy IR documentation.
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

// Whether `expr` may be unreachable in Poppy IR. True for control flow
// structures and polymorphic unreachable instructions.
bool mayBeUnreachable(Expression* expr);

} // namespace StackUtils

// Stack signatures are like regular function signatures, but they are used to
// represent the stack parameters and results of arbitrary sequences of stack
// machine instructions. Stack signatures that represent instruction sequences
// including unreachable instructions are `Polymorphic` and otherwise they are
// `Fixed`. For example, the following instruction sequences both have params
// {i32, i32} and results {f32}, but sequence A is `Fixed` while sequence B is
// `Polymorphic.`
//
//  A:
//    i32.add
//    drop
//    f32.const 42
//
//  B:
//    i32.add
//    unreachable
//    f32.const 42
//
// Notice that this distinction is important because sequence B can be the body
// of the blocks below but sequence A cannot. In other words, the stack
// signature of sequence B is a subtype of the signatures of these blocks, but
// the stack signature of sequence A is not.
//
//  (block (param f64 i32 i32) (result f32) ... )
//  (block (param i32 i32) (result f64 f32) ... )
//  (block (param f64 i32 i32) (result f64 f32) ... )
//
struct StackSignature {
  Type params;
  Type results;
  enum Kind {
    Fixed,
    Polymorphic,
  } kind;

  StackSignature() : params(Type::none), results(Type::none), kind(Fixed) {}
  StackSignature(Type params, Type results, Kind kind)
    : params(params), results(results), kind(kind) {}

  StackSignature(const StackSignature&) = default;
  StackSignature& operator=(const StackSignature&) = default;

  // Get the stack signature of `expr`
  explicit StackSignature(Expression* expr);

  // Get the stack signature of the range of instructions [first, last). The
  // sequence of instructions is assumed to be valid, i.e. their signatures
  // compose.
  template<class InputIt>
  explicit StackSignature(InputIt first, InputIt last)
    : params(Type::none), results(Type::none), kind(Fixed) {
    // TODO: It would be more efficient to build the signature directly and
    // construct the params in reverse to avoid quadratic behavior.
    while (first != last) {
      *this += StackSignature(*first++);
    }
  }

  // Return `true` iff `next` composes after this stack signature.
  bool composes(const StackSignature& next) const;

  // Compose stack signatures. Assumes they actually compose.
  StackSignature& operator+=(const StackSignature& next);
  StackSignature operator+(const StackSignature& next) const;

  bool operator==(const StackSignature& other) const {
    return params == other.params && results == other.results &&
           kind == other.kind;
  }

  // Whether a block whose contents have stack signature `a` could be typed with
  // stack signature `b`, i.e. whether it could be used in a context that
  // expects signature `b`. Formally, where `a` is the LHS and `b` the RHS:
  //
  // [t1*] -> [t2*] <: [s1* t1'*] -> [s2* t2'*] iff
  //
  //  - t1' <: t1
  //  - t2 <: t2'
  //  - s1 <: s2
  //
  //  Note that neither signature is polymorphic in this rule and that the
  //  cardinalities of t1* and t1'*, t2* and t2'*, and s1* and s2* must match.
  //
  // [t1*] -> [t2*] {poly} <: [s1* t1'*] -> [s2* t2'*] {poly?} iff
  //
  //  - [t1*] -> [t2*] <: [t1'*] -> [t2'*]
  //
  //  Note that s1* and s2* can have different cardinalities and arbitrary types
  //  in this rule.
  //
  // As an example of the first rule, consider this instruction sequence:
  //
  //   ref.cast (ref i31)
  //   drop
  //   i32.add
  //
  // The most specific type you could give this sequence is [i32, i32, anyref]
  // -> [i32]. But it could also be used in a context that expects [i32, i32,
  // structref] -> [i32] because ref.cast can accept structref or any other
  // subtype of anyref. That's where the contravariance comes from. This
  // instruction sequence could also be used anywhere that expects [f32, i32,
  // i32, anyref] -> [f32, i32] because the f32 simply stays on the stack
  // throughout the sequence. That's where the the prefix extension comes from.
  //
  // For the second rule, consider this sequence:
  //
  //   ref.cast (ref i31)
  //   drop
  //   i32.add
  //   unreachable
  //   i32.const 0
  //
  // This instruction sequence has the specific type [i32, i32, anyref] -> [i32]
  // {poly}. It can be used in any situation the previous block can be used in,
  // but can additionally be used in contexts that expect something like [f32,
  // i32, i32, anyref] -> [v128, i32]. Because of the polymorphism, the
  // additional prefixes on the params and results do not need to match.
  //
  // Note that a fixed stack signature (without a {poly}) is never a subtype of
  // any polymorphic stack signature (with a {poly}). This makes sense because a
  // sequence of instructions that has no polymorphic behavior cannot be given a
  // type that says it does have polymorphic behavior.
  //
  // Also, [] -> [] {poly} is the bottom type here; it is a subtype of every
  // other stack signature. This corresponds to the `unreachable` instruction
  // being able to be given any stack signature.
  static bool isSubType(StackSignature a, StackSignature b);

  // Returns true iff `a` and `b` have a LUB, i.e. a minimal StackSignature that
  // could type block contents of either type `a` or type `b`.
  static bool haveLeastUpperBound(StackSignature a, StackSignature b);

  // Returns the LUB of `a` and `b`. Assumes that the LUB exists.
  static StackSignature getLeastUpperBound(StackSignature a, StackSignature b);
};

// Calculates stack machine data flow, associating the sources and destinations
// of all values in a block.
struct StackFlow {
  // The destination (source) location at which a value of type `type` is
  // consumed (produced), corresponding to the `index`th value consumed by
  // (produced by) instruction `expr`. For destination locations, `unreachable`
  // is true iff the corresponding value is consumed by the polymorphic behavior
  // of an unreachable instruction rather than being used directly. For source
  // locations, `unreachable` is true iff the corresponding value is produced by
  // an unreachable instruction. For produced values that are not consumed
  // within the block (TODO: also for consumed values that are not produced
  // within the block), `expr` will be the enclosing block.
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

  // Maps each instruction to the set of source locations producing its inputs.
  LocationMap srcs;

  // Maps each instruction to the set of output locations consuming its results.
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
