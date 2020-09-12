/*
 * Copyright 2020 WebAssembly Community Group participants
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

//
// match.h: Convenience structes for matching Binaryen IR patterns
//

#ifndef wasm_ir_match_h
#define wasm_ir_match_h

#include "wasm.h"

namespace wasm {

namespace Match {

struct Matcher {
  virtual bool matches(Expression*) const = 0;
};

using matcher_ptr = std::unique_ptr<Matcher>;

struct AnyMatcher : Matcher {
  Expression** e;
  AnyMatcher(Expression** e) : e(e) {}
  bool matches(Expression* expr) const override {
    if (e) {
      *e = expr;
    }
    return true;
  }
};

matcher_ptr any(Expression** e = nullptr) {
  return std::make_unique<AnyMatcher>(e);
}

struct UnaryMatcher : Matcher {
  UnaryOp op;
  matcher_ptr value;
  Unary** curr;
  UnaryMatcher(UnaryOp op, matcher_ptr value, Unary** curr)
    : op(op), value(std::move(value)), curr(curr) {}
  bool matches(Expression* expr) const override {
    auto* unary = expr->dynCast<Unary>();
    if (unary && unary->op == op) {
      if (curr) {
        *curr = unary;
      }
      return value->matches(unary->value);
    }
    return false;
  }
};

matcher_ptr unary(UnaryOp op, matcher_ptr value, Unary** curr = nullptr) {
  return std::make_unique<UnaryMatcher>(op, std::move(value), curr);
}

bool matches(Expression* expr, matcher_ptr&& matcher) {
  return matcher->matches(expr);
}

} // namespace Match

} // namespace wasm

#endif // wasm_ir_match_h
