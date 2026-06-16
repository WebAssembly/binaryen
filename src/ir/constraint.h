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

//
// Constraints on the values of things, like x >=0, x < 42, and x == y. Allows
// inference whether other things are true given a set of constraints, like
// { x == 10 } => { x >= 5 }.
//

#ifndef wasm_ir_constraint_h
#define wasm_ir_constraint_h

#include <variant>

#include "ir/abstract.h"
#include "support/inplace_vector.h"
#include "support/utilities.h"
#include "wasm.h"

namespace wasm::constraint {

// A term in a constraint, either a local index or literal value.
struct Term : public std::variant<Index, Literal> {
  bool operator==(const Term&) const = default;
};

// A constraint: some operation and some value, like "is equal to 17" or "is
// less than local 6".
struct Constraint {
  Abstract::Op op;
  Term term;

  bool operator==(const Constraint&) const = default;
};

// We limit constraints to a low number to ensure good performance even with
// simple brute-force solving.
// TODO: use a generic constraint solver..?
inline constexpr std::size_t MaxConstraints = 3;

// What we infer from one thing about another: true/false, or unknown.
enum Result { True, False, Unknown };

// A set of constraints connected by the logical "and" operation. That is, all
// the constraints are simultaneously true about some value. In the examples in
// the comments below, `x` is used for the thing all the constraints are talking
// about, which looks like a local, but it could be a global or a struct field
// or anything else in general.
struct AndedConstraintSet : inplace_vector<Constraint, MaxConstraints> {
  // Check a condition against this set, that is, whether the existing
  // constraints prove that it must be true, false, or unknown: whether
  //
  //   { this } => { condition }
  //
  // https://en.wikipedia.org/wiki/Material_conditional#Truth_table
  Result proves(const Constraint& condition) const;

  // Check an entire other set.
  Result proves(const AndedConstraintSet& other) const;

  // Add a constraint to the set, ANDed with the others. This is an approximate
  // operation because our capacity is bounded - we cannot have more than
  // MaxConstraints. If too many are added, we will drop some, which means we
  // will be able to prove less things (but we will never prove anything
  // incorrectly).
  void approximateAnd(const Constraint& c);

  // Merge constraints using OR. We cannot always represent such a thing directly
  // (we only use AND), so we approximate it. For example,
  // this would be valid:
  //
  //   approximateOr({ x == 5 }, { x == 10 }) == { x >= 5 && x <= 10 }
  //
  // Note how the result here still accepts the values 5 and 10, but it also
  // allows more. Formally, this has the following mathematical property:
  //
  //   (X || Y) => approximateOr(X, Y)
  //
  // That is, if X or Y is true, the result of approximateOr is also true. But the
  // reverse is not always so: approximateOr may be true without X || Y being
  // true (see the truth table linked above, and the value 8 in the example).
  //
  // Returning to the example, we can use this to optimize as follows: if
  // two code paths reaching a location have x == 5 and x == 10, so the value in
  // the merge location is either 5 or 10, then if we see some i32.ge_s that
  // does x >= 0 then we can evaluate it with proves():
  //
  //   { x >= 5 && x <= 10 }.proves({ x >= 0 }) == True
  //
  // And it is valid to optimize that i32.ge_s into a constant 1, since
  //
  //   { x == 5 || x == 10 } =>
  //   { x >= 5 && x <= 10 } =>
  //   { x >= 0 }
  //
  // I.e. the constraints imply the truth of the thing we are evaluating.
  //
  // Note that the fuzziness here means that approximateOr() can do a better /
  // worse job. It is always valid for approximateOr to return { } or any other
  // always-true thing (see the truth table linked above). But then:
  //
  //   { x == 5 || x == 10 }  =>
  //   { }                   =!!>
  //   { x >= 0 }
  //
  // If we become too imprecise, we lose the ability to imply anything useful.
  void approximateOr(const AndedConstraintSet& other);
};

} // namespace wasm::constraint

#endif // wasm_ir_constraint_h
