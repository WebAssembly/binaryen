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

#include <optional>

#include "ir/constraint.h"
#include "ir/properties.h"
#include "wasm.h"

namespace wasm::constraint {

namespace {

Result TrueFalse(bool x) { return x ? True : False; }

Result TrueFalse(Literal x) { return TrueFalse(x.getUnsigned()); }

// Evaluate whether a => b, where a and b are operations on constants.
Result provesConstantPair(Abstract::Op aOp,
                          const Literal& aConstant,
                          Abstract::Op bOp,
                          const Literal& bConstant,
                          bool recursing = false) {
  // a == A =?=> a op B. Simply apply A to the operation against B.
  if (aOp == Abstract::Eq) {
    switch (bOp) {
      case Abstract::Eq:
        return TrueFalse(aConstant == bConstant);
      case Abstract::Ne:
        return TrueFalse(aConstant != bConstant);
      case Abstract::LtS:
        return TrueFalse(aConstant.ltS(bConstant));
      case Abstract::LeS:
        return TrueFalse(aConstant.leS(bConstant));
      case Abstract::GtS:
        return TrueFalse(aConstant.gtS(bConstant));
      case Abstract::GeS:
        return TrueFalse(aConstant.geS(bConstant));
      case Abstract::LtU:
        return TrueFalse(aConstant.ltU(bConstant));
      case Abstract::LeU:
        return TrueFalse(aConstant.leU(bConstant));
      case Abstract::GtU:
        return TrueFalse(aConstant.gtU(bConstant));
      case Abstract::GeU:
        return TrueFalse(aConstant.geU(bConstant));
      default: {
      }
    }
  }

  // a != A =?=> a == B. False if A = B, else unknown.
  if (aOp == Abstract::Ne && bOp == Abstract::Eq) {
    if (aConstant == bConstant) {
      return False;
    }
  }

  // a != A =?=> a != B. True if A = B, else unknown.
  if (aOp == Abstract::Ne && bOp == Abstract::Ne) {
    if (aConstant == bConstant) {
      return True;
    }
  }

  if (!recursing) {
    // The flipped operation may tell us something:  y ==> !x  implies
    // x ==> y  is false (because if not, then x would prove y, and y would
    // prove !x, a contradiction).
    if (provesConstantPair(bOp, bConstant, aOp, aConstant, true) == False) {
      return False;
    }
  }

  // TODO: handle all the rest of >, >=, <, and <=
  return Unknown;
}

// Core comparison of two constraints: whether a => b
Result provesPair(const Constraint& a, const Constraint& b) {
  // A thing always implies itself.
  if (a == b) {
    return True;
  }

  // A thing always implies its negation is false.
  if (a == b.negate()) {
    return False;
  }

  // Comparisons of two constants.
  auto* aConstant = std::get_if<Literal>(&a.term);
  auto* bConstant = std::get_if<Literal>(&b.term);
  if (aConstant && bConstant) {
    return provesConstantPair(a.op, *aConstant, b.op, *bConstant);
  }

  return Unknown;
}

} // anonymous namespace

Result AndedConstraintSet::proves(const Constraint& condition) const {
  if (provesEverything()) {
    return True;
  }
  // Note we do not need to handle the provesNothing case in a special way: the
  // loop below finds nothing.

  // Sometimes a single constraint is enough to determine the condition.
  for (auto& c : *this) {
    auto result = provesPair(c, condition);
    if (result != Unknown) {
      return result;
    }
  }

  // TODO smarts for multiple constraints

  // Otherwise, who knows.
  return Unknown;
}

Result AndedConstraintSet::proves(const AndedConstraintSet& other) const {
  if (provesEverything()) {
    return True;
  }

  if (other.provesEverything()) {
    // We are not a contradiction, but other is, so we prove it false.
    return False;
  }

  bool hasUnknown = false;

  for (auto& c : other) {
    auto result = proves(c);
    if (result == False) {
      // The entire conjunction is proven false.
      return False;
    }
    if (result == Unknown) {
      hasUnknown = true;
    }
  }

  return hasUnknown ? Unknown : True;
}

void AndedConstraintSet::approximateAnd(const Constraint& c) {
  if (provesEverything()) {
    // Nothing to add.
    return;
  }

  auto result = proves(c);
  if (result == True) {
    // We already prove c to be true, so it adds nothing.
    return;
  } else if (result == False) {
    // We are now a contradiction.
    isContradiction = true;
    return;
  }

  // If c proves something already present to be true, it can just replace it.
  for (auto& existing : *this) {
    auto result = provesPair(c, existing);
    if (result == True) {
      existing = c;

      // Sort to ensure we are in the right place.
      std::sort(begin(), end());

      return;
    }

    // There cannot be a contradiction here, because we checked for that above.
    assert(result != False);
  }

  if (size() < MaxConstraints) {
    // Insert into the right place, keeping us sorted.
    insert(std::upper_bound(begin(), end(), c), c);
    return;
  }

  // Otherwise, just do not add this one.
  // TODO: We could try to be clever and see if one of the existing ones makes
  //       more sense to drop. In particular, we should prefer "better" ones
  //       like > over >= and so forth (sorting more precise ones earlier may be
  //       useful to implement that).
}

namespace {

// A variable in a match. If we see the same Var - identified by address - in
// two places, it must be equal in them. We can also perform checks on different
// Vars afterwards, e.g., whether one is greater than the other.
// TODO: optimize all this, if it matters
struct Var {};

// A matcher constraint: an abstraction over a normal Constraint, which can also
// contain Vars.
struct MatcherConstraint {
  Abstract::Op op;
  Var* term = nullptr;

  MatcherConstraint() = default;
  MatcherConstraint(Abstract::Op op, Var& term) : op(op), term(&term) {}

  bool operator==(const MatcherConstraint&) const = default;
  bool operator<(const MatcherConstraint& other) const {
    // Ordered in a parallel way to Constraints, so that when we compare, things
    // line up.
    if (op != other.op) {
      return op < other.op;
    }
    return term < other.term;
  }
};

// A matcher AndedConstraintSet, which abstracts over the normal one to support
// MatcherConstraints.
using MatcherSet = inplace_vector<MatcherConstraint, MaxConstraints>;

// A matcher object. This pattern-matches over AndedConstraintSets, in a way
// that follows the rules of logic.
struct Matcher {
  // Set up a pattern containing two sets of constraints.
  Matcher(const MatcherSet& ms1_, const MatcherSet& ms2_);

  // Add a requirement on this pattern, a demand on the Vars.
  //
  // For convenience, return this Matcher object (i.e. the builder pattern).
  Matcher& require(Var& a, Abstract::Op op, Var& b);

  // When a match succeeds, we return a map of Vars to Terms, allowing the user
  // to find out what each Var matched against.
  struct VarTermMap : public std::unordered_map<Var*, Term> {
    // As a convenience, allow using the object instead of the pointer.
    Term& operator[](Var& var) {
      return std::unordered_map<Var*, Term>::operator[](&var);
    }
  };

  // Check if the pattern matches given inputs. The order of the inputs does not
  // matter. Returns the address of the input that matches the first of the
  // patterns (that is, if a matches ms1 in the constructor, we return &a, and
  // otherwise &b), or nullptr of the match failed.
  std::optional<VarTermMap> checkUnordered(const AndedConstraintSet& a,
                                           const AndedConstraintSet& b) {
    return checkUnorderedInternal(a, b);
  }

private:
  std::optional<VarTermMap> checkUnorderedInternal(const AndedConstraintSet& a,
                                                   const AndedConstraintSet& b,
                                                   bool flipped = false);

  MatcherSet ms1;
  MatcherSet ms2;

  struct Requirement {
    Var* a;
    Abstract::Op op;
    Var* b;
  };

  SmallVector<Requirement, 2> requirements;
};

Matcher::Matcher(const MatcherSet& ms1_, const MatcherSet& ms2_)
  : ms1(ms1_), ms2(ms2_) {
  // Sort the sets like Constraints are sorted, so that when we compare, things
  // line up.
  std::sort(ms1.begin(), ms1.end());
  std::sort(ms2.begin(), ms2.end());
}

Matcher& Matcher::require(Var& a, Abstract::Op op, Var& b) {
  requirements.push_back({&a, op, &b});
  return *this;
}

std::optional<Matcher::VarTermMap> Matcher::checkUnorderedInternal(
  const AndedConstraintSet& a, const AndedConstraintSet& b, bool flipped) {

  auto fail = [&]() -> std::optional<Matcher::VarTermMap> {
    // We failed, but try the flipped inputs if we haven't already.
    if (!flipped) {
      return checkUnorderedInternal(b, a, true);
    }
    return {};
  };

  if (a.size() != ms1.size() || b.size() != ms2.size()) {
    return fail();
  }

  // The sizes match, at least. Parse in more detail, building up a mapping of
  // Vars to concrete Terms
  VarTermMap varTermMap;

  auto parse = [&](const AndedConstraintSet& input, const MatcherSet& pattern) {
    for (Index i = 0; i < input.size(); i++) {
      // The operation must match.
      if (input[i].op != pattern[i].op) {
        return false;
      }

      // The term must match, or define a new unknown value.
      auto [iter, inserted] =
        varTermMap.insert({pattern[i].term, input[i].term});
      if (inserted) {
        // The Var in the pattern is already mapped and known. The input here
        // must match the prior appearance.
        if (input[i].term != iter->second) {
          return false;
        }
      }
    }
    return true;
  };

  if (!parse(a, ms1) || !parse(b, ms2)) {
    return fail();
  }

  // Check requirements on the vars.
  for (auto& [a, op, b] : requirements) {
    auto aTerm = varTermMap[*a];
    auto bTerm = varTermMap[*b];

    // Check if { x == a } proves { x op b } is true.
    if (provesPair(Constraint{Abstract::Eq, aTerm}, Constraint{op, bTerm}) !=
        True) {
      return fail();
    }
  }

  return varTermMap;
}

// Do an approximate OR on two inputs that are disjoint, that is, each proves
// the other false.
//
// If we recognize a pattern, we update |self| and return whether anything
// changed (otherwise, we return nullopt).
std::optional<bool> approximateOrDisjoint(AndedConstraintSet& self,
                                          const AndedConstraintSet& other) {
  using MC = MatcherConstraint;
  using namespace Abstract;

  // Simple range fusing, add an equality to turn > into >= :
  //
  //   { x == A } || { x > A && x <= B } , A <= B   ===   { x >= A && X <= B }
  //
  Var A, B;
  if (auto result = Matcher({MC(Eq, A)}, {MC(GtS, A), MC(LeS, B)})
                      .require(A, LeS, B)
                      .checkUnordered(self, other)) {
    Term aValue = (*result)[A];
    Term bValue = (*result)[B];
    self = AndedConstraintSet({{GeS, aValue}, {LeS, bValue}});
    return true;
  }

  // Otherwise, we have no idea.
  return {};
}

} // anonymous namespace

bool AndedConstraintSet::approximateOr(const AndedConstraintSet& other) {
  // If one proves everything, the only thing that matters is the other.
  if (other.provesEverything()) {
    return false;
  }
  if (provesEverything()) {
    *this = other;
    return true;
  }

  // If this is already implied by current constraints, then it is redundant.
  // E.g. if we are { x = 10 } and other is { x >= 0 } then all we need is
  // { x >= 0 } as the result of the OR.
  auto otherProves = other.proves(*this);
  if (otherProves == True) {
    return false;
  }
  auto thisProves = proves(other);
  if (thisProves == True) {
    *this = other;
    return true;
  }

  if (otherProves == False && thisProves == False) {
    if (auto result = approximateOrDisjoint(*this, other)) {
      return *result;
    }
  }
  // TODO more smarts: handle <= > and so forth

  // Otherwise, we don't know how to nicely OR these things, and expand to the
  // trivial set of no constraints.
  // TODO: We could keep constraints that appear on both sides and only drop the
  //       others. In fact, we could do that first, and leave smarts only to the
  //       others.
  clear();
  return true;
}

std::optional<LocalConstraint> LocalConstraint::parse(Expression* curr) {
  auto parseEqZArgument =
    [&](Expression* value) -> std::optional<LocalConstraint> {
    if (auto* get = value->dynCast<LocalGet>()) {
      // Canonicalize EqZ to Eq of 0.
      auto value = Literal::makeZero(get->type);
      return LocalConstraint{get->index, Constraint{Abstract::Eq, {value}}};
    }
    // TODO: Recursively parse and reverse a constraint
    return {};
  };

  if (auto* unary = curr->dynCast<Unary>()) {
    if (Abstract::getUnary(unary->type, Abstract::EqZ) == unary->op) {
      return parseEqZArgument(unary->value);
    }
    return {};
  }

  if (auto* refIsNull = curr->dynCast<RefIsNull>()) {
    return parseEqZArgument(refIsNull->value);
  }

  // Parse a get or a constant.
  auto parseTerm = [&](Expression* expr) -> std::optional<Term> {
    if (auto* get = expr->dynCast<LocalGet>()) {
      return Term{get->index};
    }
    if (Properties::isSingleConstantExpression(expr)) {
      return Term{Properties::getLiteral(expr)};
    }
    return {};
  };

  auto parseBinaryArguments =
    [&](Abstract::Op op,
        Expression* left,
        Expression* right) -> std::optional<LocalConstraint> {
    // The left must be a get.
    if (auto* get = left->dynCast<LocalGet>()) {
      // The right can be any term.
      if (auto value = parseTerm(right)) {
        return LocalConstraint{get->index, Constraint{op, *value}};
      }
    }
    return {};
  };

  if (auto* binary = curr->dynCast<Binary>()) {
    // The operation must be one we recognize.
    for (auto op : {Abstract::Eq,
                    Abstract::Ne,
                    Abstract::LtS,
                    Abstract::LtU,
                    Abstract::LeS,
                    Abstract::LeU,
                    Abstract::GtS,
                    Abstract::GtU,
                    Abstract::GeS,
                    Abstract::GeU}) {
      if (Abstract::getBinary(binary->type, op) == binary->op) {
        return parseBinaryArguments(op, binary->left, binary->right);
      }
    }
    return {};
  }

  if (auto* refEq = curr->dynCast<RefEq>()) {
    return parseBinaryArguments(Abstract::Eq, refEq->left, refEq->right);
  }

  return {};
}

std::optional<LocalConstraint>
LocalConstraint::parseCondition(Expression* curr) {
  // A get by itself is a check for not being null.
  if (auto* get = curr->dynCast<LocalGet>()) {
    auto value = Literal::makeZero(get->type);
    return LocalConstraint{get->index, Constraint{Abstract::Ne, {value}}};
  }

  // Otherwise, parse normally.
  return parse(curr);
};

void LocalConstraint::flip() {
  auto other = std::get<Index>(constraint.term);
  constraint.term = Term{local};
  local = other;
  if (Abstract::isRelationalAntisymmetric(constraint.op)) {
    constraint.op = Abstract::negateRelational(constraint.op);
  } else {
    // All we support for now are symmetric and antisymmetric operations.
    assert(Abstract::isRelationalSymmetric(constraint.op));
  }
}

void BasicBlockConstraintMap::set(Index index, const Constraint& c) {
  // We should not set values in unreachable code.
  assert(!unreachable);

  // Clear the old state.
  eraseStaleRefs(index);
  map.erase(index);

  // Apply the constraint.
  approximateAnd(index, c);
}

void BasicBlockConstraintMap::setProvesNothing(Index index) {
  assert(!unreachable);
  eraseStaleRefs(index);
  map.erase(index);
}

bool BasicBlockConstraintMap::approximateOr(
  const BasicBlockConstraintMap& other) {
  // If one is unreachable, it adds nothing to the other.
  if (other.unreachable) {
    return false;
  }
  if (unreachable) {
    *this = other;
    return true;
  }

  // We only need to loop on our locals, as any local that is missing in us is
  // one that would end up proving nothing (and get removed).
  bool changed = false;
  for (auto& [local, constraints] : map) {
    changed |= constraints.approximateOr(other.get(local));
  }

  // Anything that became trivial after the OR must be removed.
  std::erase_if(map, [&](const auto& item) {
    const auto& [local, constraints] = item;
    // We do not store contradictions.
    assert(!constraints.provesEverything());
    if (constraints.provesNothing()) {
      changed = true;
      return true;
    }
    return false;
  });

  return changed;
}

void BasicBlockConstraintMap::approximateAndInternal(Index index,
                                                     const Constraint& c,
                                                     bool flip,
                                                     bool isCopy) {
  // We should not be applying constraints when already unreachable.
  assert(!unreachable);

  Constraint actual = c;
  if (flip) {
    LocalConstraint flipped{index, c};
    flipped.flip();
    index = flipped.local;
    actual = flipped.constraint;
  }

  // Never add constraints to ourselves (x == x, etc., which can happen due to
  // copying/flipping).
  if (auto* other = std::get_if<Index>(&actual.term)) {
    if (*other == index) {
      return;
    }
  }

  // Refer to the constraints for this index. If this is the first access of
  // the local, then we insert a new item into the map, which has a default of
  // proxesEverything, which we need to flip (provesEverything cannot otherwise
  // be found in the map, as we never store it).
  auto [iter, _] = map.insert({index, AndedConstraintSet::makeProvesNothing()});
  auto& indexConstraints = iter->second;
  // As in ::set(), this makes the map temporarily invalid until the
  // approximateAnd, as we don't store proves-nothing in the map, normally.

  indexConstraints.approximateAnd(actual);

  if (indexConstraints.provesEverything()) {
    // We just proved we are in unreachable code.
    unreachable = true;
    map.clear();
    return;
  }

  // We just added a constraint, so we can prove something (we may lose some
  // information as this is an approximate AND, but we cannot lose it all).
  assert(!indexConstraints.provesNothing());

  // Add a ref of what we are adding. Note that the approximation above may end
  // up not actually adding this, or adding only part of this, but it is safe to
  // always add a ref (at the cost of minor wasted work).
  noteRefs(index, actual);

  // If this is not the flipped version, and it refers to a local, add the
  // flipped one too.
  if (!flip && std::holds_alternative<Index>(actual.term)) {
    approximateAndInternal(index, actual, true, isCopy);
    if (unreachable) {
      // We just found a contradiction.
      return;
    }
  }

  // If this constraint is simply "== x", then we are equal to that other local
  // x, and can copy its constraints (if we are not already such a copy).
  if (!isCopy) {
    if (auto* other = std::get_if<Index>(&actual.term)) {
      if (actual.op == Abstract::Eq) {
        for (auto& otherC : get(*other)) {
          approximateAndInternal(index, otherC, false, true);
          if (unreachable) {
            return;
          }
        }
      }
    }
  }
}

void BasicBlockConstraintMap::noteRefs(Index index, const Constraint& c) {
  if (auto* i = std::get_if<Index>(&c.term)) {
    refs[*i].insert(index);
  }
}

void BasicBlockConstraintMap::eraseStaleRefs(Index index) {
  auto iter = refs.find(index);
  if (iter == refs.end()) {
    return;
  }

  auto& refIndexes = iter->second;

  for (auto refIndex : refIndexes) {
    if (auto iter = map.find(refIndex); iter != map.end()) {
      auto& refConstraints = iter->second;
      std::erase_if(refConstraints, [&](const auto& c) {
        if (auto* i = std::get_if<Index>(&c.term)) {
          if (*i == index) {
            return true;
          }
        }
        return false;
      });
      if (refConstraints.empty()) {
        // This became trivial.
        map.erase(iter);
      }
    }
  }
}

std::ostream& operator<<(std::ostream& o, const Constraint& c) {
  o << "Constraint{" << c.op << ", ";
  if (auto* cc = std::get_if<Literal>(&c.term)) {
    o << *cc;
  } else if (auto* i = std::get_if<Index>(&c.term)) {
    o << "Index(" << *i << ')';
  }
  o << '}';
  return o;
}

std::ostream& operator<<(std::ostream& o, const AndedConstraintSet& set) {
  if (set.provesEverything()) {
    o << "AndedConstraintSet(contradiction)";
    return o;
  }
  o << "AndedConstraintSet{";
  bool first = true;
  for (auto& constraint : set) {
    if (first) {
      first = false;
    } else {
      o << ", ";
    }
    o << constraint;
  }
  o << '}';
  return o;
}

std::ostream& operator<<(std::ostream& o, const BasicBlockConstraintMap& map) {
  if (map.unreachable) {
    o << "BasicBlockConstraintMap(unreachable)";
    return o;
  }
  o << "BasicBlockConstraintMap{";
  bool first = true;
  for (auto& [local, constraints] : map.map) {
    if (first) {
      first = false;
    } else {
      o << ", ";
    }
    o << local << ": " << constraints;
  }
  o << '}';
  return o;
}

} // namespace wasm::constraint
