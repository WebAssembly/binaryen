/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef _wasm_ast_hashed_h

#include "support/hash.h"
#include "wasm.h"
#include "ast_utils.h"

namespace wasm {

// An expression with a cached hash value
struct HashedExpression {
  Expression* expr;
  size_t hash;

  HashedExpression(Expression* expr) : expr(expr) {
    if (expr) {
      hash = ExpressionAnalyzer::hash(expr);
    }
  }

  HashedExpression(const HashedExpression& other) : expr(other.expr), hash(other.hash) {}
};

struct ExpressionHasher {
  size_t operator()(const HashedExpression value) const {
    return value.hash;
  }
};

struct ExpressionComparer {
  bool operator()(const HashedExpression a, const HashedExpression b) const {
    if (a.hash != b.hash) return false;
    return ExpressionAnalyzer::equal(a.expr, b.expr);
  }
};

template<typename T>
class HashedExpressionMap : public std::unordered_map<HashedExpression, T, ExpressionHasher, ExpressionComparer> {
};

} // namespace wasm

#endif // _wasm_ast_hashed_h

