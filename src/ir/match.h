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

#include "ir/abstract.h"
#include "wasm.h"

namespace wasm {

namespace Match {

// The available matchers are:
//
//  i32(x), i64(x), f32(x), f64(x)
//
//    Match constants of the exact corresponding type. Do not support building.
//
//  ival(x), fval(x)
//
//    Match any integer constant or any floating point constant. Do not support
//    building.
//
//  number(x)
//
//    Matches any integer or floating point constant equal to `x`. Does not
//    support building.
//
//  constant([e])
//
//    Matches any Const expression and binds it to `e`, if provided.
//
//  any([e])
//
//    Matches any expression and binds it to `e`, if provided.
//
//  unary([e], op, val)
//
//    Matches Unary expressions implementing `op`, which is either a UnaryOp or
//    an Abstract::Op, whose operand matches `val`. Binds the matched expression
//    to `e`, if provided.
//
//  binary([e], op, left, right)
//
//    Matches Binary expressions implementing `op`, which is either a BinaryOp
//    or an Abstract::Op, whose operands match `left` and `right`. Binds the
//    matched expression to `e`, if provided.
//
//  select([e], ifTrue, ifFalse, cond)
//
//    Matches Select expressions whose operands match `ifTrue`, `ifFalse`, and
//    `cond`. Binds the matched expression to `e`, if provided.
//

// The main entrypoint for matching.
template<class Matcher> bool matches(Expression* expr, Matcher matcher) {
  return matcher.matches(expr);
}

// The main entrypoint for building. The top-level matcher must point to an
// expression, which will be modified in place by inserting bound expressions at
// the locations corresponding to their position in the pattern. Matchers in the
// pattern that do not have bound expressions are assumed to match the output.
// Returns the top-level modified expression.
template<class Matcher> Expression* build(Matcher matcher) {
  Expression* expr = nullptr;
  matcher.build(&expr);
  return expr;
}

// Matchers

// TODO: Make this a template once we have C++20 (needs non-type class template
// arguments)
#define LITERAL_MATCHER(matcher, T, typePred, getValue)                        \
  struct matcher {                                                             \
    T val;                                                                     \
    matcher(T val) : val(val) {}                                               \
                                                                               \
    bool matches(Expression* expr) const {                                     \
      auto* c = expr->dynCast<Const>();                                        \
      return c && typePred && c->value.getValue() == val;                      \
    }                                                                          \
  }

LITERAL_MATCHER(i32, int32_t, c->type == Type::i32, geti32);
LITERAL_MATCHER(i64, int64_t, c->type == Type::i64, geti64);
LITERAL_MATCHER(ival, int64_t, c->type.isInteger(), getInteger);
LITERAL_MATCHER(f32, float, c->type == Type::f32, getf32);
LITERAL_MATCHER(f64, double, c->type == Type::f64, getf64);
LITERAL_MATCHER(fval, double, c->type.isFloat(), getFloat);
#undef LITERAL_MATCHER

struct number {
  int32_t val;
  number(int32_t val) : val(val) {}

  bool matches(Expression* expr) const {
    auto* c = expr->dynCast<Const>();
    return c && (c->type.isInteger() || c->type.isFloat()) &&
           c->value == Literal::makeFromInt32(val, c->type);
  }
};

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

struct constant {
  Const** curr;

  constant(Const** curr = nullptr) : curr(curr) {}

  bool matches(Expression* expr) const {
    if (auto* c = expr->dynCast<Const>()) {
      if (curr) {
        *curr = c;
      }
      return true;
    }
    return false;
  }

  void build(Expression** outp) const {
    if (curr) {
      *outp = *curr;
    }
  }
};

// UnOp can be either UnaryOp or Abstract::Op. We use CRTP to abstract over
// the differences in functionality they require.
template<class SubClass, class UnOp, class ValueMatcher> struct UnaryMatcher {
  Unary** curr;
  UnOp op;
  ValueMatcher value;

  UnaryMatcher(Unary** curr, UnOp op, ValueMatcher&& value)
    : curr(curr), op(op), value(std::move(value)) {}

  UnaryOp getOp(Type type) const {
    return static_cast<const SubClass*>(this)->getOp(type, op);
  }

  bool matches(Expression* expr) const {
    auto* unary = expr->dynCast<Unary>();
    if (unary && unary->op == getOp(unary->value->type)) {
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
    value.build(&out->value);
    out->op = getOp(out->value->type);
  }
};

template<class V>
struct PlainUnaryMatcher : UnaryMatcher<PlainUnaryMatcher<V>, UnaryOp, V> {
  UnaryOp getOp(Type, UnaryOp op) const { return op; }
};

template<class V>
struct AbstractUnaryMatcher
  : UnaryMatcher<AbstractUnaryMatcher<V>, Abstract::Op, V> {
  UnaryOp getOp(Type type, Abstract::Op op) const {
    if (type.isInteger() || type.isFloat()) {
      return Abstract::getUnary(type, op);
    } else {
      return InvalidUnary;
    }
  }
};

// Type-level mapping of UnOp (UnaryOp or Abstract::Op) to the corresponding
// CRTP UnaryMatcher subtype.
template<class UnOp, class V> struct UnaryMatcherOf {};

template<class V> struct UnaryMatcherOf<UnaryOp, V> {
  using type = PlainUnaryMatcher<V>;
};

template<class V> struct UnaryMatcherOf<Abstract::Op, V> {
  using type = AbstractUnaryMatcher<V>;
  ;
};

// TODO: Once we move to C++17, remove these wrapper functions and use the
// matcher constructors directly like we do with the leaf matchers already.
template<class UnOp, class V> decltype(auto) unary(UnOp op, V&& value) {
  return UnaryMatcher<typename UnaryMatcherOf<UnOp, V>::type, UnOp, V>(
    nullptr, op, std::move(value));
}

template<class UnOp, class V>
decltype(auto) unary(Unary** curr, UnOp op, V&& value) {
  return UnaryMatcher<typename UnaryMatcherOf<UnOp, V>::type, UnOp, V>(
    curr, op, std::move(value));
}

// BinOp can be either BinaryOp or Abstract::Op. We use CRTP to abstract over
// the differences in functionality they require.
template<class SubClass, class BinOp, class LeftMatcher, class RightMatcher>
struct BinaryMatcher {
  Binary** curr;
  BinOp op;
  LeftMatcher left;
  RightMatcher right;

  BinaryMatcher(Binary** curr,
                BinOp op,
                LeftMatcher&& left,
                RightMatcher&& right)
    : curr(curr), op(op), left(std::move(left)), right(std::move(right)) {}

  BinaryOp getOp(Type type) const {
    return static_cast<const SubClass*>(this)->getOp(type, op);
  }

  bool matches(Expression* expr) const {
    auto* binary = expr->dynCast<Binary>();
    if (binary && binary->op == getOp(binary->left->type)) {
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
    left.build(&out->left);
    right.build(&out->right);
    out->op = getOp(out->left->type);
  }
};

template<class L, class R>
struct PlainBinaryMatcher
  : BinaryMatcher<PlainBinaryMatcher<L, R>, BinaryOp, L, R> {
  BinaryOp getOp(Type, BinaryOp op) const { return op; }
};

template<class L, class R>
struct AbstractBinaryMatcher
  : BinaryMatcher<AbstractBinaryMatcher<L, R>, Abstract::Op, L, R> {
  BinaryOp getOp(Type type, Abstract::Op op) const {
    if (type.isInteger() || type.isFloat()) {
      return Abstract::getBinary(type, op);
    } else {
      return InvalidBinary;
    }
  }
};

// Type-level mapping of BinOp (BinaryOp or Abstract::Op) to the corresponding
// CRTP BinaryMatcher subtype.
template<class BinOp, class L, class R> struct BinaryMatcherOf {};

template<class L, class R> struct BinaryMatcherOf<BinaryOp, L, R> {
  using type = PlainBinaryMatcher<L, R>;
};

template<class L, class R> struct BinaryMatcherOf<Abstract::Op, L, R> {
  using type = AbstractBinaryMatcher<L, R>;
};

template<class BinOp, class L, class R>
decltype(auto) binary(BinOp op, L&& left, R&& right) {
  return BinaryMatcher<typename BinaryMatcherOf<BinOp, L, R>::type,
                       BinOp,
                       L,
                       R>(nullptr, op, std::move(left), std::move(right));
}

template<class BinOp, class L, class R>
decltype(auto) binary(Binary** curr, BinOp op, L&& left, R&& right) {
  return BinaryMatcher<typename BinaryMatcherOf<BinOp, L, R>::type,
                       BinOp,
                       L,
                       R>(curr, op, std::move(left), std::move(right));
}

template<class IfTrueMatcher, class IfFalseMatcher, class CondMatcher>
struct SelectMatcher {
  Select** curr;
  IfTrueMatcher ifTrue;
  IfFalseMatcher ifFalse;
  CondMatcher condition;

  SelectMatcher(Select** curr,
                IfTrueMatcher&& ifTrue,
                IfFalseMatcher&& ifFalse,
                CondMatcher&& condition)
    : curr(curr), ifTrue(ifTrue), ifFalse(ifFalse), condition(condition) {}

  bool matches(Expression* expr) const {
    if (auto* select = expr->dynCast<Select>()) {
      if (curr) {
        *curr = select;
      }
      return ifTrue.matches(select->ifTrue) &&
             ifFalse.matches(select->ifFalse) &&
             condition.matches(select->condition);
    }
    return false;
  }

  void build(Expression** outp) const {
    if (curr) {
      *outp = *curr;
    }
    auto* out = (*outp)->cast<Select>();
    ifTrue.build(&out->ifTrue);
    ifFalse.build(&out->ifFalse);
    condition.build(&out->condition);
  }
};

template<class T, class F, class C>
SelectMatcher<T, F, C> select(T&& ifTrue, F&& ifFalse, C&& condition) {
  return SelectMatcher<T, F, C>(
    nullptr, std::move(ifTrue), std::move(ifFalse), std::move(condition));
}

template<class T, class F, class C>
SelectMatcher<T, F, C>
select(Select** curr, T&& ifTrue, F&& ifFalse, C&& condition) {
  return SelectMatcher<T, F, C>(
    curr, std::move(ifTrue), std::move(ifFalse), std::move(condition));
}

} // namespace Match

} // namespace wasm

#endif // wasm_ir_match_h
