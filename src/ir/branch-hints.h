/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef wasm_ir_branch_hint_h
#define wasm_ir_branch_hint_h

#include "wasm.h"

//
// Branch hint utilities to get them, set, flip, etc.
//

namespace wasm::BranchHints {

// Get the branch hint for an expression.
inline std::optional<bool> get(Expression* expr, Function* func) {
  auto iter = func->codeAnnotations.find(expr);
  if (iter == func->codeAnnotations.end()) {
    // No annotations at all.
    return {};
  }
  return iter->second.branchLikely;
}

// Set the branch hint for an expression, trampling anything existing before.
inline void set(Expression* expr, std::optional<bool> likely, Function* func) {
  // When we are writing an empty hint, do not create an empty annotation if one
  // did not exist.
  if (!likely && !func->codeAnnotations.count(expr)) {
    return;
  }
  func->codeAnnotations[expr].branchLikely = likely;
}

// Clear the branch hint for an expression.
inline void clear(Expression* expr, Function* func) {
  // Do not create an empty annotation if one did not exist.
  auto iter = func->codeAnnotations.find(expr);
  if (iter == func->codeAnnotations.end()) {
    return;
  }
  iter->second.branchLikely = {};
}

// Copy the branch hint for an expression to another, trampling anything
// existing before for the latter.
inline void copyTo(Expression* from, Expression* to, Function* func) {
  auto fromLikely = get(from, func);
  set(to, fromLikely, func);
}

// Flip the branch hint for an expression (if it exists).
inline void flip(Expression* expr, Function* func) {
  if (auto likely = get(expr, func)) {
    set(expr, !*likely, func);
  }
}

// Copy the branch hint for an expression to another, flipping it while we do
// so.
inline void copyFlippedTo(Expression* from, Expression* to, Function* func) {
  copyTo(from, to, func);
  flip(to, func);
}

// Given two expressions to read from, apply the AND hint to a target. That is,
// the target will be true when both inputs are true. |to| may be equal to
// |from1| or |from2|. The hint of |to| is trampled.
inline void applyAndTo(Expression* from1,
                       Expression* from2,
                       Expression* to,
                       Function* func) {
  // If from1 and from2 are both likely, then from1 && from2 is slightly less
  // likely, but we assume our hints are nearly certain, so we apply it. And,
  // converse, if from1 and from2 and both unlikely, then from1 && from2 is even
  // less likely, so we can once more apply a hint. If the hints differ, then
  // one is unlikely or unknown, and we can't say anything about from1 && from2.
  auto from1Hint = BranchHints::get(from1, func);
  auto from2Hint = BranchHints::get(from2, func);
  if (from1Hint == from2Hint) {
    set(to, from1Hint, func);
  } else {
    // The hints do not even match.
    BranchHints::clear(to, func);
  }
}

// As |applyAndTo|, but now the condition on |to| the OR of |from1| and |from2|.
inline void applyOrTo(Expression* from1,
                      Expression* from2,
                      Expression* to,
                      Function* func) {
  // If one is likely then so is from1 || from2. If both are unlikely then
  // from1 || from2 is slightly more likely, but we assume our hints are nearly
  // certain, so we apply it.
  auto from1Hint = BranchHints::get(from1, func);
  auto from2Hint = BranchHints::get(from2, func);
  if ((from1Hint && *from1Hint) || (from2Hint && *from2Hint)) {
    set(to, true, func);
  } else if (from1Hint && from2Hint) {
    // We ruled out that either one is present and true, so if both are present,
    // both must be false.
    assert(!*from1Hint && !*from2Hint);
    set(to, false, func);
  } else {
    // We don't know.
    BranchHints::clear(to, func);
  }
}

} // namespace wasm::BranchHints

#endif // wasm_ir_branch_hint_h
