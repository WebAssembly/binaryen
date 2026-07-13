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
  bool operator<(const Term& other) const {
    if (index() != other.index()) {
      return index() < other.index();
    }
    if (index() == 0) {
      return std::get<Index>(*this) < std::get<Index>(other);
    }
    return std::get<Literal>(*this) < std::get<Literal>(other);
  }
};

// A constraint: some operation and some value, like "is equal to 17" or "is
// less than local 6".
struct Constraint {
  Abstract::Op op;
  Term term;

  bool operator==(const Constraint&) const = default;
  bool operator<(const Constraint& other) const {
    if (op != other.op) {
      return op < other.op;
    }
    return term < other.term;
  }

  Constraint negate() const {
    return Constraint{Abstract::negateRelational(op), term};
  }
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
  // We could represent a contradiction using two constraints that contradict
  // each other (== 0 && != 0), but for simplicity we mark this explicitly.
  //
  // A contradiction is the default value here, because it represents
  // unreachable code: if (x == 0 && x != 0) { .. unreachable ..}. That is, we
  // assume we represent the constraints in code that has not been reached,
  // until something changes.
  bool isContradiction = true;

  // Proving everything (even contradictions) is equivalent to being a
  // contradiction. (This and provesNothing can be seen as the top/bottom of a
  // poset, if one wants to think of things that way.)
  bool provesEverything() const { return isContradiction; }

  void setProvesEverything() {
    clear();
    isContradiction = true;
    assert(provesEverything());
  }

  // An empty set of contradictions means we know nothing, and so anything is
  // possible, and we can prove nothing.
  bool provesNothing() const { return empty(); }

  void setProvesNothing() {
    clear();
    isContradiction = false;
    assert(provesNothing());
  }

  static AndedConstraintSet makeProvesNothing() {
    AndedConstraintSet ret;
    ret.setProvesNothing();
    return ret;
  }

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

  // Merge constraints using OR. We cannot always represent such a thing
  // directly (we only use AND), so we approximate it. For example, this would
  // be valid:
  //
  //   approximateOr({ x == 5 }, { x == 10 }) == { x >= 5 && x <= 10 }
  //
  // Note how the result here still accepts the values 5 and 10, but it also
  // allows more. Formally, this has the following mathematical property:
  //
  //   (X || Y) => approximateOr(X, Y)
  //
  // That is, if X or Y is true, the result of approximateOr is also true. But
  // the reverse is not always so: approximateOr may be true without X || Y
  // being true (see the truth table linked above, and the value 8 in the
  // example).
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
  // Note that the approximation here means that approximateOr() can do a better
  // / worse job. It is always valid for approximateOr to return { } or any
  // other always-true thing (see the truth table linked above). But then:
  //
  //   { x == 5 || x == 10 }  =>
  //   { }                   =!!>
  //   { x >= 0 }
  //
  // If we become too imprecise, we lose the ability to imply anything useful.
  void approximateOr(const AndedConstraintSet& other);

  // Set a constraint, replacing all previous state.
  void set(const Constraint& c) {
    setProvesNothing();
    push_back(c);
  }

private:
  // While we are a vector, the order of constraints does not logically matter.
  // We keep ourselves sorted in a canonical form, so that simple ==, != etc.
  // comparisons work. The canonical order also makes debug printing nicer.
  void sort();
};

// A local plus a constraint on it.
struct LocalConstraint {
  Index local;
  Constraint constraint;

  // Try to parse BinaryenIR into a local to which a constraint is applied. For
  // example
  //
  //   (i32.eq (local.get $r) (i32.const 10))
  //
  // parses into
  //
  //   LocalConstraint($r, { x == 10 })
  //
  static std::optional<LocalConstraint> parse(Expression* curr);

  // Parse in a condition context, i.e., where (local.get $x) is the same as
  // $x != 0 (e.g., in an if condition, or a br_on ref).
  static std::optional<LocalConstraint> parseCondition(Expression* curr);

  // Reverse the constraint. The constraint's term must, of course, be another
  // local.
  void flip();
};

// A map of locals and their constraints, representing the state at a basic
// block. We use the following representation:
//
//  * When the basic block is unreachable, we mark ourselves so, and clear the
//    map.
//  * If any local is in a contradiction, we know we are unreachable, and mark
//    ourselves so.
//  * When we can prove nothing about a local - the common case - we leave it
//    out of the map.
//  * If a local is unusable - a non-nullable local before any set - then it is
//    marked as being able to prove nothing. (We could also mark this as a
//    contradiction, but both apply - we can indeed prove nothing, as the IR
//    disallows any uses of it - and avoiding a contradiction avoids confusion
//    with the case of the basic block being unreachable.)
//
// As a result, the map only contains interesting things, where we can prove
// something (but not everything).
//
// Cross-local constraints (like x == y) are duplicated, that is, they appear in
// the constraints for both x and y. This makes things simple by having all
// constraints related to a local in the same place.
struct BasicBlockConstraintMap {
  // Blocks begin unreachable, like AndedConstraintSet.
  bool unreachable = true;

  void setReachable() {
    unreachable = false;
    assert(map.empty());
  }

  // Apply a constraint to a local.
  void set(Index index, const Constraint& c);

  // Mark a local as unknown and able to prove nothing.
  void setProvesNothing(Index index);

  // Get the constraints for a local.
  AndedConstraintSet get(Index index) const {
    // We should not be called in unreachable code.
    assert(!unreachable);

    if (auto iter = map.find(index); iter != map.end()) {
      auto& constraints = iter->second;
      // If we can prove nothing, we should have removed it from the map.
      assert(!constraints.provesNothing());
      // If we can prove everything, we should be entirely unreachable.
      assert(!constraints.provesEverything());
      return constraints;
    }
    return AndedConstraintSet::makeProvesNothing();
  }

  // Perform an OR as above. When a local only appears in one map, we treat it
  // as if it contains a contradiction there, that is, as if the code is
  // unreachable.
  void approximateOr(const BasicBlockConstraintMap& other);

  // Perform an AND as above, on a particular index.
  void approximateAnd(Index index, const Constraint& c) {
    approximateAndInternal(index, c);
  }

  // TODO: Add proves() here, which could do things like: if asked x == y, we
  // can answer False if we see x == c1, y == c2, and the constants c1, c2
  // differ.

  bool operator!=(const BasicBlockConstraintMap& other) {
    return unreachable != other.unreachable || map != other.map;
  }

  friend std::ostream& operator<<(std::ostream& o,
                                  const BasicBlockConstraintMap& map);

private:
  std::unordered_map<Index, AndedConstraintSet> map;

  // Maps an index to the locals that have constraints referring to it. When a
  // local is modified, we need to wipe all those constraints, which become
  // stale.
  //
  // It is ok (but unoptimal in efficiency) if we have stale refs here, e.g. due
  // to approximation removing a constraint. Whenever there is a reference,
  // however, it must be noted here, so that when things get stale we can remove
  // them.
  std::unordered_map<Index, std::unordered_set<Index>> refs;

  // Given a constraint on a local, note refs.
  void noteRefs(Index index, const Constraint& c);

  // Given an index, erase constraints referring to it.
  void eraseStaleRefs(Index index);

  // Internal version, with a flag to flip the constraint. Whenever we apply
  // e.g. x == y, we also apply y == x to y, to maintain the invariant described
  // above. When flip is true, we flip the constraint and apply it to the other
  // index (y == x, in this example). When isCopy is true, we are a copied
  // constraint from another local, and we do not need to add new copies of it.
  void approximateAndInternal(Index index,
                              const Constraint& c,
                              bool flip = false,
                              bool isCopy = false);
};

std::ostream& operator<<(std::ostream& o, const Constraint& c);
std::ostream& operator<<(std::ostream& o, const AndedConstraintSet& set);

} // namespace wasm::constraint

#endif // wasm_ir_constraint_h
