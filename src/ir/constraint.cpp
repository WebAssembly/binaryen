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

// Core comparison of two constraints.
//
// Returns a Result, or an empty option if we should keep working (i.e., a
// result of Unknown means we are certain we can just return Unknown).
std::optional<Result> checkPair(const Constraint& a, const Constraint& b) {
  // A thing always implies itself.
  if (a == b) {
    return True;
  }

  // Comparisons of two constants.
  if (auto* aConstant = std::get_if<Literal>(&a.value)) {
    if (auto* bConstant = std::get_if<Literal>(&b.value)) {
      switch (a.op) {
        case Abstract::Eq: {
          switch (b.op) {
            case Abstract::Eq: {
              // x == c vs x == c', and we already handled full equality
              // earlier, hence c != c', and we found a contradiction.
              assert(*aConstant != *bConstant);
              return False;
            }
            case Abstract::Ne: {
              // x == c vs x != c'. We can infer the result based on relating c
              // and c'.
              return *aConstant != *bConstant ? True : False;
            }
            default: {
            }
          }
        }
        case Abstract::Ne: {
          switch (b.op) {
            case Abstract::Eq: {
              // x != c vs x == c'. If c == c', we can infer.
              if (*aConstant == *bConstant) {
                return False;
              }
              return {};
            }
            case Abstract::Ne: {
              // x == c vs x == c', and we already handled full equality
              // earlier, hence c != c', and we can infer nothing.
              return {};
            }
            default: {
            }
          }
        }
        default: {
        }
      }
    }
  }

  return {};
}

} // anonymous namespace

Result AndedConstraintSet::check(const Constraint& condition) const {
  // Sometimes a single constraint is enough to determine the condition.
  for (auto& c : *this) {
    if (auto result = checkPair(c, condition)) {
      return *result;
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
  if (check(other) == True) {
    *this = other;
    return;
  }
  if (other.check(*this) == True) {
    return;
  }

  // TODO smarts

  // Otherwise, we don't know how to nicely OR these things, and expand to the
  // trivial set of no constraints (i.e., where everything is true, and we can
  // prove nothing).
  clear();
}

std::optional<LocalConstraint> LocalConstraint::parse(Expression* curr) {
  auto* binary = curr->dynCast<Binary>();
  if (!binary) {
    // TODO: unary etc.
    return {};
  }

  // The left must be a get.
  auto* leftGet = binary->left->dynCast<LocalGet>();
  if (!leftGet) {
    return {};
  }

  // The right must be a get or a constant.
  auto* rightGet = binary->right->dynCast<LocalGet>();
  std::optional<Literal> rightConstant;
  if (Properties::isSingleConstantExpression(binary->right)) {
    rightConstant = Properties::getLiteral(binary->right);
  }
  if (!rightGet && !rightConstant) {
    return {};
  }

  // The operation must be one we recognize.
  for (auto op : {Abstract::Eq, Abstract::Ne}) {
    if (Abstract::getBinary(binary->type, op) == binary->op) {
      auto value = rightGet ? Value(rightGet->index) : Value(*rightConstant);
      return LocalConstraint{leftGet->index, Constraint{op, value}};
    }
  }
  return {};
}

} // namespace wasm::constraint
