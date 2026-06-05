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

Result AndedConstraintSet::check(const Constraint& condition) {
  for (auto& c : *this) {
    // If the condition is among our constraints exactly, it is definitely true.
    if (c == condition) {
      return True;
    }
  }

  // Comparisons of two constants.
  if (auto* constant = std::get_if<Literal>(&condition.value)) {
    for (auto& c : *this) {
      if (auto* cConstant = std::get_if<Literal>(&c.value)) {
        switch (c.op) {
          case Abstract::Eq: {
            switch (condition.op) {
              case Abstract::Eq: {
                // The condition is x == c and constraint is x == c', and we
                // already looked for full equality earlier, c != c', and we
                // found a contradiction.
                assert(*constant != *cConstant);
                return False;
              }
              default: {}
            }
          }
          default: {}
        }
      }
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

