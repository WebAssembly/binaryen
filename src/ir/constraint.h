/*
 * Copyright 2026 WebAssembly Community Group participants
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

// Constraints on the values of locals, things like x >=0, x < 42, and x == y.

#ifndef wasm_ir_constraint_h
#define wasm_ir_constraint_h

#include <variant>

#include "ir/abstract.h"
#include "support/utilities.h"
#include "wasm.h"

namespace wasm::constraint {

// TODO: constraint => condition?

// A value in a constraint, either a local index or literal value.
struct Value : public std::variant<Index, Literal> {
  bool operator==(const Value&) const = default;
};

// A constraint.
struct Constraint {
  // The operation relating two values, and the values.
  Abstract::Op op == Abstract::Invalid;
  Value left;
  Value right;

  bool operator==(const Constraint&) const = default;

  operator bool() const { return op != Abstract::Invalid; }
};

// We limit constraints to a low number to ensure good performance even with
// simple brute-force solving.
// TODO: use a generic constraint solver..?
using MaxConstraints = 3;

// What a constraint is known to be: true/false, or unknown.
enum Result {
  True,
  False,
  Unknown
};

// A set of constraints connected by the logical "and" operation. That is, all
// the constraints are simultaneously true.
struct AndedConstraintSet : std::inplace_vector<Constraint, MaxConstraints> {
  // Check a condition against this set, that is, whether the existing
  // constraints prove that it must be true, false, or unknown.
  Result check(const Constraint& condition);

  // Add a constraint to the set, ANDed with the others. The caller must make
  // sure not to add too many.
  void and_(const Constraint& c) {
    push_back(c);
  }

  // Add a constraint that is ORed. We cannot represent such a thing directly
  // (we only use AND), so we approximate it in a fuzzy way. For example,
  //
  //   fuzzyOr({ x == 5 }, { x == 10 })  =>  { x >= 5 && x <= 10 }
  //
  // Note how the result here still accepts the values 5 and 10, but it also
  // allows more. Formally, this has the following mathematical property:
  //
  //   (X || Y) => fuzzyOr(X, Y)
  //
  // That is, if X or Y is true, the result of fuzzOr is also true. (But the
  // reverse is not always the case: fuzzyOr may be true without X || Y being
  // true.)
  //
  // Returning to the example above, we can use this to optimize as follows: if
  // two code paths reaching a location have x == 5 and x == 10, so the value in
  // the merge location is either 5 or 10, then if we see some i32.ge_s that
  // does x >= 0 then we can evaluate it with check():
  //
  //   { x >= 5 && x <= 10 }.check({ x >= 0 }) == True
  //
  // And it is valid to optimize that i32.ge_s into a constant 1, since
  //
  //   { x == 5 || x == 10 } =>
  //   { x >= 5 && x <= 10 } =>
  //   { x >= 0 }
  //
  void fuzzyOr(const Constraint& c);
};

bool Span::includes(const Value& value) {
  // In most cases, we don't know enough.
  bool ret = false;
  std::visit(overloaded{
               [&](const Literal& lit) {
                 // The value is a literal. We can infer something here if the
                 // span is a range of literals, checking if value is within
                 // [min, max].
                 const Literal* minLit = std::get_if<Literal>(&min);
                 if (minLit && *minLit == lit) {
                   ret = true;
                   return;
                 }
                 const Literal* maxLit = std::get_if<Literal>(&max);
                 if (maxLit && *maxLit == lit) {
                   ret = true;
                   return;
                 }
                 if (lit.type.isNumber() && minLit && maxLit) {
                   // Numbers can be ordered.
                   assert(minLit->type == lit.type);
                   assert(maxLit->type == lit.type);
                   if (minLit->le(lit).getUnsigned() &&
                       maxLit->ge(lit).getUnsigned()) {
                     ret = true;
                   }
                 }
               },
               [&](const Index& local) {
                 // A local index can be compared to others.
                 const Index* minLocal = std::get_if<Index>(&min);
                 if (minLocal && *minLocal == local) {
                   ret = true;
                   return;
                 }
                 const Index* maxLocal = std::get_if<Index>(&max);
                 if (maxLocal && *maxLocal == local) {
                   ret = true;
                 }
               },
               [&](const Unknown& unknown) {},
             },
             value);
  return ret;
}

bool Span::lessThan(const Value& value) { abort(); }

bool Span::greaterThan(const Value& value) { abort(); }

} // namespace wasm::constraint

#endif // wasm_ir_constraint_h
