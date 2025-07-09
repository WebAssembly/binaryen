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
  if (!likely) {
    // We are writing an empty hint. Do not create an empty annotation if one
    // did not exist.
    if (!func->codeAnnotations.count(expr)) {
      return;
    }
  }
  func->codeAnnotations[expr].branchLikely = likely;
}

// Clear the branch hint for an expression.
inline void clear(Expression* expr, Function* func) {
  func->codeAnnotations[expr].branchLikely = {};
}

// Copy the branch hint for an expression to another, trampling anything
// existing before.
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

} // namespace wasm::BranchHints

#endif // wasm_ir_branch_hint_h
