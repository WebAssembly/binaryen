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
// Utilities for manipulating and analyzing stack machine code.
//

#ifndef wasm_ir_stack_h
#define wasm_ir_stack_h

#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

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
// TODO: Replace StackSignature with PrincipalType.
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

} // namespace wasm

#endif // wasm_ir_stack_h
