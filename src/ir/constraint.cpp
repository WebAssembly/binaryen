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
#include "wasm.h"

namespace wasm::constraint {

namespace {

// Core comparison of two constraints. To keep it simple, this is not
// symmetrical - it leaves handling of parallel cases to another call of this
// function with inputs reversed.
//
// Returns a Result, or an empty option if we should keep working (i.e., a
// result of Unknown means we are certain we can just return Unknown).
std::optional<Result> checkPairInternal(const Constraint& a, const Constraint& b) {
  // Comparisons of two constants.
  if (auto* aConstant = std::get_if<Literal>(&a.value)) {
    if (auto* bConstant = std::get_if<Literal>(&b.value)) {
      switch (a.op) {
        case Abstract::Eq: {
          switch (b.op) {
            case Abstract::Eq: {
              // The condition is x == c and constraint is x == c', and we
              // already looked for full equality earlier, c != c', and we
              // found a contradiction.
              assert(*aConstant != *bConstant);
              return False;
            }
            case Abstract::Ne: {
              // The condition is x == c and constraint is x != c'. We can
              // infer the result based on relating c and c'.
              return *aConstant != *bConstant ? True : False;
            }
            default: {}
          }
        }
        default: {}
      }
    }
  }

  return {};
}

std::optional<Result> checkPair(const Constraint& a, const Constraint& b) {
  if (auto result = checkPairInternal(a, b)) {
    return *result;
  }
  return checkPairInternal(b, a);
}

} // anonymous namespace

Result AndedConstraintSet::check(const Constraint& condition) {
  for (auto& c : *this) {
    // If the condition is among our constraints exactly, it is definitely true.
    if (c == condition) {
      return True;
    }
  }

  // Sometimes a single constraint is enough to determine the condition.
  for (auto& c : *this) {
    if (auto result = checkPair(c, condition)) {
      return *result;
    }
  }

  // TODO smarts

  // Otherwise, who knows.
  return Unknown;
}

void AndedConstraintSet::fuzzyOr(const Constraint& c) {
  // If this is already implied by current constraints, then it is redundant.
  if (check(c) == True) {
    return;
  }

#if 0
  // Otherwise, it either contradicts us (e.g. we were x == 5 and this is
  // x == 10) or we can't infer anything about it (e.g. we were x == 5 and this
  // is z == 99) XXX
      ...
    case Unknown:
      // This is an interesting case, which we analyze.
  }
#endif

// fuzzyOr with a set, not a constriant...

  // TODO smarts
}

} // namespace wasm::constraint

