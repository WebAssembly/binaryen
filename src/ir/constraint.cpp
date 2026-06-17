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

// Evaluate whether a => b, where a and b are operations on constants.
Result provesConstantPair(Abstract::Op aOp,
                          const Literal& aConstant,
                          Abstract::Op bOp,
                          const Literal& bConstant) {
  // x == X =?=> x == Y. True iff X == Y.
  if (aOp == Abstract::Eq && bOp == Abstract::Eq) {
    return aConstant == bConstant ? True : False;
  }

  // x == X =?=> x != Y. True iff X != Y.
  if (aOp == Abstract::Eq && bOp == Abstract::Ne) {
    return aConstant == bConstant ? False : True;
  }

  // x != X =?=> x == Y. False if X = Y, else unknown.
  if (aOp == Abstract::Ne && bOp == Abstract::Eq) {
    if (aConstant == bConstant) {
      return False;
    }
  }

  // x != X =?=> x != Y. True if X = Y, else unknown.
  if (aOp == Abstract::Ne && bOp == Abstract::Ne) {
    if (aConstant == bConstant) {
      return True;
    }
  }

  // TODO: handle >, >=, <, and <=
  return Unknown;
}

// Core comparison of two constraints: whether a => b
Result provesPair(const Constraint& a, const Constraint& b) {
  // A thing always implies itself.
  if (a == b) {
    return True;
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
  if (other.empty()) {
    // The empty set of constraints is always true.
    return True;
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
  if (size() < MaxConstraints) {
    push_back(c);
    return;
  }

  // Otherwise, just do not add this one.
  // TODO: We could try to be clever and see if one of the existing ones makes
  //       more sense to drop.
}

void AndedConstraintSet::approximateOr(const AndedConstraintSet& other) {
  // If one is empty (no constraints, everything is true, and we can prove
  // nothing useful) then it does not add anything to the other.
  if (empty()) {
    *this = other;
    return;
  }
  if (other.empty()) {
    return;
  }

  // If this is already implied by current constraints, then it is redundant.
  // E.g. if we are { x = 10 } and other is { x >= 0 } then all we need is
  // { x >= 0 } as the result of the OR.
  if (proves(other) == True) {
    *this = other;
    return;
  }
  if (other.proves(*this) == True) {
    return;
  }

  // TODO smarts: handle <= > and so forth

  // Otherwise, we don't know how to nicely OR these things, and expand to the
  // trivial set of no constraints.
  clear();
}

std::optional<LocalConstraint> LocalConstraint::parse(Expression* curr) {
  auto parseEqZ = [&](Expression* value) -> std::optional<LocalConstraint> {
    if (auto* get = value->dynCast<LocalGet>()) {
      // Canonicalize EqZ to Eq of 0.
      auto value = Literal::makeZero(get->type);
      return LocalConstraint{get->index, Constraint{Abstract::Eq, {value}}};
    }
    return {};
  };

  if (auto* unary = curr->dynCast<Unary>()) {
    if (Abstract::getUnary(unary->type, Abstract::EqZ) == unary->op) {
      return parseEqZ(unary->value);
    }
    return {};
  }

  if (auto* refIsNull = curr->dynCast<RefIsNull>()) {
    return parseEqZ(refIsNull->value);
  }

  // Parse a get or a constant.
  auto parseTerm = [&](Expression* expr) -> std::optional<Term> {
    if (auto* get = expr->dynCast<LocalGet>()) {
      return Term(get->index);
    }
    if (Properties::isSingleConstantExpression(expr)) {
      return Term(Properties::getLiteral(expr));
    }
    return {};
  };

  auto parseBinary = [&](Abstract::Op op,
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
    for (auto op : {Abstract::Eq, Abstract::Ne}) {
      if (Abstract::getBinary(binary->type, op) == binary->op) {
        return parseBinary(op, binary->left, binary->right);
      }
    }
    return {};
  }

  if (auto* refEq = curr->dynCast<RefEq>()) {
    return parseBinary(Abstract::Eq, refEq->left, refEq->right);
  }

  return {};
}

void LocalConstraintMap::approximateOr(const LocalConstraintMap& other) {
  // Find things in both, and OR them.
  for (auto& [local, constraints] : other) {
    if (auto iter = find(local); iter != end()) {
      iter->second.approximateOr(constraints);
    }
  }

  // Remove things only in us.
  std::erase_if(*this, [&](const auto& item) {
    const auto& [local, constraints] = item;
    return !other.contains(local);
  });
}

} // namespace wasm::constraint
