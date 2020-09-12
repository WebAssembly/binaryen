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
// match.h: Convenience structs for matching and transforming Binaryen IR
// patterns. Most matchers take an optional pointer to an Expression* variable
// that will be set equal to the expression they match. When building a pattern,
// the matchers will instead insert the optional Expression* at their location
// in the pattern.
//

#ifndef wasm_ir_match_h
#define wasm_ir_match_h

#include "wasm.h"

namespace wasm {

namespace Match {

// The main entrypoint for matching.
template<class Matcher> bool matches(Expression* expr, Matcher matcher) {
  return matcher.matches(expr);
}

// The main entrypoint for building. The top-level matcher must point to an
// expression. Matchers in the pattern that do not point to expressions are
// assumed to match.
template<class Matcher> Expression* build(Matcher matcher) {
  Expression* expr = nullptr;
  matcher.build(&expr);
  return expr;
}

// Matchers

struct any {
  Expression** curr;

  any(Expression** curr = nullptr) : curr(curr) {}

  bool matches(Expression* expr) const {
    if (curr) {
      *curr = expr;
    }
    return true;
  }

  void build(Expression** outp) const {
    if (curr) {
      *outp = *curr;
    }
  }
};

struct i32 {
  int32_t val;

  i32(int32_t val) : val(val) {}

  bool matches(Expression* expr) const {
    auto* c = expr->dynCast<Const>();
    return c && c->value.geti32() == val;
  }

  // Does not support building
};

template<class ValueMatcher> struct UnaryMatcher {
  Unary** curr;
  UnaryOp op;
  ValueMatcher value;

  UnaryMatcher(Unary** curr, UnaryOp op, ValueMatcher&& value)
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

  void build(Expression** outp) const {
    if (curr) {
      *outp = *curr;
    }
    auto* out = (*outp)->cast<Unary>();
    out->op = op;
    value.build(&out->value);
  }
};

// TODO: Once we move to C++17, remove these wrapper functions and use the
// matcher constructors directly like we do with the leaf matchers already.
template<class ValueMatcher>
UnaryMatcher<ValueMatcher> unary(UnaryOp op, ValueMatcher&& value) {
  return UnaryMatcher<ValueMatcher>(nullptr, op, std::move(value));
}

template<class ValueMatcher>
UnaryMatcher<ValueMatcher>
unary(Unary** curr, UnaryOp op, ValueMatcher&& value) {
  return UnaryMatcher<ValueMatcher>(curr, op, std::move(value));
}

template<class LeftMatcher, class RightMatcher> struct BinaryMatcher {
  Binary** curr;
  BinaryOp op;
  LeftMatcher left;
  RightMatcher right;

  BinaryMatcher(Binary** curr,
                BinaryOp op,
                LeftMatcher&& left,
                RightMatcher&& right)
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

  void build(Expression** outp) const {
    if (curr) {
      *outp = *curr;
    }
    auto* out = (*outp)->cast<Binary>();
    out->op = op;
    left.build(&out->left);
    right.build(&out->right);
  }
};

template<class LeftMatcher, class RightMatcher>
BinaryMatcher<LeftMatcher, RightMatcher>
binary(BinaryOp op, LeftMatcher&& left, RightMatcher&& right) {
  return BinaryMatcher<LeftMatcher, RightMatcher>(
    nullptr, op, std::move(left), std::move(right));
}

template<class LeftMatcher, class RightMatcher>
BinaryMatcher<LeftMatcher, RightMatcher>
binary(Binary** curr, BinaryOp op, LeftMatcher&& left, RightMatcher&& right) {
  return BinaryMatcher<LeftMatcher, RightMatcher>(
    curr, op, std::move(left), std::move(right));
}

} // namespace Match

} // namespace wasm

#endif // wasm_ir_match_h
