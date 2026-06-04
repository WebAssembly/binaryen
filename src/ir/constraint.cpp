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

#include "ir/constraint.h"
#include "wasm.h"

namespace wasm::constraint {

namespace {

// Parses a constraint of the form of a local on the left and a constant on the
// right.
std::tuple<const Index*, const Literal*> getLocalConstant(const Constraint& c) {
  if (const Index* local = std::get_if<Index>(&c.left)) {
    if (const Literal* literal = std::get_if<Literal>(&c.right)) {
      return {local, literal};
    }
  }
  return {nullptr, nullptr};
}

} // anonymous namespace

Result AndedConstraintSet::check(const Constraint& condition) {
  for (auto& constraint : *this) {
    // If the condition is among our constraints exactly, it is definitely true.
    if (constraint == condition) {
      return True;
    }
  }

  if (condition.op == Abstract::Eq) {
    auto [conditionLocal, conditionConstant] = getLocalConstant(condition);
    if (conditionLocal) {
      // $x == c. If one of our constraints is $x == c', then we found a
      // contradiction.
      for (auto& constraint : *this) {
        auto [constraintLocal, constraintConstant] = getLocalConstant(constraint);
        if (constraintLocal && *conditionLocal == *constraintLocal) {
          // We already looked for full equality earlier, so some difference
          // must be here.
          assert(*conditionConstant != *constraintConstant);
          return False;
        }
      }
    }
  }

  // TODO smarts
  return Unknown;
}

void AndedConstraintSet::fuzzyOr(const Constraint& c) {
  // TODO
}

} // namespace wasm::constraint

