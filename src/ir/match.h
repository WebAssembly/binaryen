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
// match.h: Convenience structs for matching Binaryen IR patterns
//

#ifndef wasm_ir_match_h
#define wasm_ir_match_h

#include "wasm.h"

namespace wasm {

namespace Match {

struct any {
  Expression** e;

  any(Expression** e = nullptr) : e(e) {}

  bool matches(Expression* expr) const {
    if (e) {
      *e = expr;
    }
    return true;
  }
};

struct i32 {
  int32_t val;

  i32(int32_t val) : val(val) {}

  bool matches(Expression* expr) const {
    auto* c = expr->dynCast<Const>();
    return c && c->value.geti32() == val;
  }
};

template<class ValueMatcher> struct unary {
  Unary** curr;
  UnaryOp op;
  ValueMatcher value;

  unary(UnaryOp op, ValueMatcher&& value)
    : curr(nullptr), op(op), value(value) {}
  unary(Unary** curr, UnaryOp op, ValueMatcher&& value)
    : curr(curr), op(op), value(value) {}

  bool matches(Expression* expr) const {
    auto* unary = expr->dynCast<Unary>();
    if (unary && unary->op == op) {
      if (curr) {
        *curr = unary;
      }
      return value.matches(unary->value);
    }
    return false;
  }
};

template<class LeftMatcher, class RightMatcher> struct binary {
  Binary** curr;
  BinaryOp op;
  LeftMatcher left;
  RightMatcher right;

  binary(BinaryOp op, LeftMatcher&& left, RightMatcher&& right)
    : curr(nullptr), op(op), left(left), right(right) {}
  binary(Binary** curr, BinaryOp op, LeftMatcher&& left, RightMatcher&& right)
    : curr(curr), op(op), left(left), right(right) {}

  bool matches(Expression* expr) const {
    auto* binary = expr->dynCast<Binary>();
    if (binary && binary->op == op) {
      if (curr) {
        *curr = binary;
      }
      return left.matches(binary->left) && right.matches(binary->right);
    }
    return false;
  }
};

template<class Matcher> bool matches(Expression* expr, Matcher matcher) {
  return matcher.matches(expr);
}

} // namespace Match

} // namespace wasm

#endif // wasm_ir_match_h
