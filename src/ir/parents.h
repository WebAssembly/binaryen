/*
 * Copyright 2019 WebAssembly Community Group participants
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

#ifndef wasm_ir_parents_h
#define wasm_ir_parents_h

#include "parsing.h"

namespace wasm {

struct Parents {
  Parents(Expression* expr) { inner.walk(expr); }

  Expression* getParent(Expression* curr) const {
    auto iter = inner.parentMap.find(curr);
    if (iter != inner.parentMap.end()) {
      return iter->second;
    }
    return nullptr;
  }

private:
  struct Inner
    : public ExpressionStackWalker<Inner, UnifiedExpressionVisitor<Inner>> {
    void visitExpression(Expression* curr) { parentMap[curr] = getParent(); }

    std::map<Expression*, Expression*> parentMap;
  } inner;
};

} // namespace wasm

#endif // wasm_ir_parents_h
