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
Result evalConstantPair(Abstract::Op aOp,
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

  return Unknown;
}

// Core comparison of two constraints: whether a => b
Result evalPair(const Constraint& a, const Constraint& b) {
  // A thing always implies itself.
  if (a == b) {
    return True;
  }

  // Comparisons of two constants.
  auto* aConstant = std::get_if<Literal>(&a.term);
  auto* bConstant = std::get_if<Literal>(&b.term);
  if (aConstant && bConstant) {
    return evalConstantPair(a.op, *aConstant, b.op, *bConstant);
  }

  return Unknown;
}

} // anonymous namespace

Result AndedConstraintSet::eval(const Constraint& condition) const {
  // Sometimes a single constraint is enough to determine the condition.
  for (auto& c : *this) {
    auto result = evalPair(c, condition);
    if (result != Unknown) {
      return result;
    }
  }

  // TODO smarts for multiple constraints

  // Otherwise, who knows.
  return Unknown;
}

void AndedConstraintSet::fuzzyOr(const AndedConstraintSet& other) {
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
  if (eval(other) == True) {
    *this = other;
    return;
  }
  if (other.eval(*this) == True) {
    return;
  }

  // TODO smarts

  // Otherwise, we don't know how to nicely OR these things, and expand to the
  // trivial set of no constraints.
  clear();
}

} // namespace wasm::constraint
