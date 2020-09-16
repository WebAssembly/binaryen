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

namespace Internal {
// Generic matcher implementation

struct unused_t {};

// Each matcher has a `Kind`, which controls how candidate values are
// destructured and inspected. For most matchers, `Kind` is a pointer to the
// matched subtype of Expression, but when there are multiple matchers for the
// same kind of expression, they are disambiguated by having different `Kind`s.
// In this case, or if the matcher matches something besides a pointer to a
// subtype of Expression, or if the matcher requires additional state, the
// matched type and the type of additional state must be associated with the
// `Kind` via a specialization of `KindTypeRegistry`.
template<class Kind> struct KindTypeRegistry {
  // The matched type
  using matched_t = void;
  // Type type of additional state needed to perform a match. Can be set to
  // `unused_t` if it's not needed.
  using data_t = unused_t;
};

// Given a `Kind`, produce the type `matched_t` that is matched by that Kind and
// the type `candidate_t` that is the type of the parameter of the `matches`
// method. These types are only different if `val_t` is a pointer to a subtype
// of Expression, in which case `candidate_t` is Expression*.
template<class Kind> struct MatchTypes {
  using matched_t = typename std::conditional_t<
    std::is_base_of<Expression, std::remove_pointer_t<Kind>>::value,
    Kind,
    typename KindTypeRegistry<Kind>::matched_t>;

  static constexpr bool isExpr =
    std::is_base_of<Expression, std::remove_pointer_t<matched_t>>::value;

  using candidate_t =
    typename std::conditional_t<isExpr, Expression*, matched_t>;
};

template<class Kind> using matched_t = typename MatchTypes<Kind>::matched_t;
template<class Kind> using candidate_t = typename MatchTypes<Kind>::candidate_t;
template<class Kind> using data_t = typename KindTypeRegistry<Kind>::data_t;

// Defined if the matched type is a specific expression pointer, so can be
// `dynCast`ed to from Expression*.
template<class Kind>
using enable_if_castable_t = typename std::enable_if<
  std::is_base_of<Expression, std::remove_pointer_t<matched_t<Kind>>>::value &&
    !std::is_same<Expression*, matched_t<Kind>>::value,
  int>::type;

// Opposite of above
template<class Kind>
using enable_if_not_castable_t = typename std::enable_if<
  !std::is_base_of<Expression, std::remove_pointer_t<matched_t<Kind>>>::value ||
    std::is_same<Expression*, matched_t<Kind>>::value,
  int>::type;

// Do a normal dynCast from Expression* to the subtype, storing the result in
// `out` and returning `true` iff the cast succeeded.
template<class Kind, enable_if_castable_t<Kind> = 0>
static bool dynCastCandidate(candidate_t<Kind> candidate,
                             matched_t<Kind>& out) {
  out = candidate->template dynCast<std::remove_pointer_t<matched_t<Kind>>>();
  return out != nullptr;
}

// Otherwise we are not matching an Expression, so this is infallible.
template<class Kind, enable_if_not_castable_t<Kind> = 0>
bool dynCastCandidate(candidate_t<Kind> candidate, matched_t<Kind>& out) {
  out = candidate;
  return true;
}

// Matchers can optionally specialize this to perform custom matching logic
// before recursing into submatchers, potentially short-circuiting the match.
// Uses a struct because partial specialization of functions is not allowed.
template<class Kind> struct MatchSelf {
  bool operator()(matched_t<Kind>&, data_t<Kind>&) { return true; }
};

// This needs to be specialized for each kind of matcher. Each specialization
// should define
//
//   static constexpr size_t value;
//
// This serves a sanity check to ensure that every matcher has the correct
// number of submatchers. Uses a struct instead of a function because partial
// specialization of functions is not allowed.
template<class Kind> struct NumComponents;

// Every kind of matcher needs to partially specialize this for each of its
// components. Each specialization should define
//
//   const T& operator()(matched_t<Kind>)
//
// where T is the component's type. Components will be matched from first to
// last and built in reverse order. Uses a struct instead of a function because
// partial specialization of functions is not allowed.
template<class Kind, int pos> struct GetComponent;

// A type-level linked list to hold an arbitrary number of matchers.
template<class...> struct SubMatchers {};
template<class CurrMatcher, class... NextMatchers>
struct SubMatchers<CurrMatcher, NextMatchers...> {
  CurrMatcher curr;
  SubMatchers<NextMatchers...> next;
  SubMatchers(CurrMatcher curr, NextMatchers... next)
    : curr(curr), next(next...){};
};

// Iterates through the components of the candidate, applying a submatcher to
// each component. Uses a struct instead of a function because partial
// specialization of functions is not allowed.
template<class Kind, int pos, class CurrMatcher = void, class... NextMatchers>
struct Components {
  static bool match(matched_t<Kind>& candidate,
                    SubMatchers<CurrMatcher, NextMatchers...>& matchers) {
    return matchers.curr.matches(GetComponent<Kind, pos>{}(candidate)) &&
           Components<Kind, pos + 1, NextMatchers...>::match(candidate,
                                                             matchers.next);
  }
};
template<class Kind, int pos> struct Components<Kind, pos> {
  static_assert(pos == NumComponents<Kind>::value,
                "Unexpected number of submatchers");
  static bool match(matched_t<Kind>&, SubMatchers<>&) {
    // Base case when there are no components left; trivially true.
    return true;
  }
};

template<class Kind, class... Matchers> struct Matcher {
  matched_t<Kind>* binder;
  data_t<Kind> data;
  SubMatchers<Matchers...> submatchers;

  Matcher(matched_t<Kind>* binder, data_t<Kind> data, Matchers... submatchers)
    : binder(binder), data(data), submatchers(submatchers...) {}

  bool matches(candidate_t<Kind> candidate) {
    matched_t<Kind> casted;
    if (dynCastCandidate<Kind>(candidate, casted)) {
      if (binder != nullptr) {
        *binder = casted;
      }
      return MatchSelf<Kind>{}(casted, data) &&
             Components<Kind, 0, Matchers...>::match(casted, submatchers);
    }
    return false;
  }
};

// Concrete low-level matcher implementations. Not intended for direct external
// use.

// Any<T>: matches any value of the expected type
template<class T> struct AnyKind {};
template<class T> struct KindTypeRegistry<AnyKind<T>> {
  using matched_t = T;
  using data_t = unused_t;
};
template<class T> struct NumComponents<AnyKind<T>> {
  static constexpr size_t value = 0;
};
template<class T> decltype(auto) Any(T* binder) {
  return Matcher<AnyKind<T>>(binder, {});
}

// Exact<T>: matches exact values of the expected type
template<class T> struct ExactKind {};
template<class T> struct KindTypeRegistry<ExactKind<T>> {
  using matched_t = T;
  using data_t = T;
};
template<class T> struct MatchSelf<ExactKind<T>> {
  bool operator()(T& self, T& expected) { return self == expected; }
};
template<class T> struct NumComponents<ExactKind<T>> {
  static constexpr size_t value = 0;
};
template<class T> decltype(auto) Exact(T* binder, T data) {
  return Matcher<ExactKind<T>>(binder, data);
}

// {I32,I64,Int,F32,F64,Float}Lit: match `Literal` of the expected `Type`
struct I32LK {
  static bool matchType(Literal& lit) { return lit.type == Type::i32; }
  static int32_t getVal(Literal& lit) { return lit.geti32(); }
};
struct I64LK {
  static bool matchType(Literal& lit) { return lit.type == Type::i64; }
  static int64_t getVal(Literal& lit) { return lit.geti64(); }
};
struct IntLK {
  static bool matchType(Literal& lit) { return lit.type.isInteger(); }
  static int64_t getVal(Literal& lit) { return lit.getInteger(); }
};
struct F32LK {
  static bool matchType(Literal& lit) { return lit.type == Type::f32; }
  static float getVal(Literal& lit) { return lit.getf32(); }
};
struct F64LK {
  static bool matchType(Literal& lit) { return lit.type == Type::f64; }
  static double getVal(Literal& lit) { return lit.getf64(); }
};
struct FloatLK {
  static bool matchType(Literal& lit) { return lit.type.isFloat(); }
  static double getVal(Literal& lit) { return lit.getFloat(); }
};
template<class T> struct LitKind {};
template<class T> struct KindTypeRegistry<LitKind<T>> {
  using matched_t = Literal;
  using data_t = unused_t;
};
template<class T> struct MatchSelf<LitKind<T>> {
  bool operator()(Literal& lit, unused_t) { return T::matchType(lit); }
};
template<class T> struct NumComponents<LitKind<T>> {
  static constexpr size_t value = 1;
};
template<class T> struct GetComponent<LitKind<T>, 0> {
  decltype(auto) operator()(Literal lit) { return T::getVal(lit); }
};
template<class S> decltype(auto) I32Lit(Literal* binder, S s) {
  return Matcher<LitKind<I32LK>, S>(binder, {}, s);
}
template<class S> decltype(auto) I64Lit(Literal* binder, S s) {
  return Matcher<LitKind<I64LK>, S>(binder, {}, s);
}
template<class S> decltype(auto) IntLit(Literal* binder, S s) {
  return Matcher<LitKind<IntLK>, S>(binder, {}, s);
}
template<class S> decltype(auto) F32Lit(Literal* binder, S s) {
  return Matcher<LitKind<F32LK>, S>(binder, {}, s);
}
template<class S> decltype(auto) F64Lit(Literal* binder, S s) {
  return Matcher<LitKind<F64LK>, S>(binder, {}, s);
}
template<class S> decltype(auto) FloatLit(Literal* binder, S s) {
  return Matcher<LitKind<FloatLK>, S>(binder, {}, s);
}

// Const
template<> struct NumComponents<Const*> { static constexpr size_t value = 1; };
template<> struct GetComponent<Const*, 0> {
  Literal& operator()(Const* c) { return c->value; }
};
template<class S> decltype(auto) ConstMatcher(Const** binder, S s) {
  return Matcher<Const*, S>(binder, {}, s);
}

// Unary and AbstractUnary
struct UnaryK {
  using Op = UnaryOp;
  static UnaryOp getOp(Type, Op op) { return op; }
};
struct AbstractUnaryK {
  using Op = Abstract::Op;
  static UnaryOp getOp(Type type, Abstract::Op op) {
    return Abstract::getUnary(type, op);
  }
};
template<class T> struct UnaryKind {};
template<class T> struct KindTypeRegistry<UnaryKind<T>> {
  using matched_t = Unary*;
  using data_t = typename T::Op;
};
template<class T> struct MatchSelf<UnaryKind<T>> {
  bool operator()(Unary* curr, typename T::Op op) {
    return curr->op == T::getOp(curr->value->type, op);
  }
};
template<class T> struct NumComponents<UnaryKind<T>> {
  static constexpr size_t value = 1;
};
template<class T> struct GetComponent<UnaryKind<T>, 0> {
  Expression*& operator()(Unary* curr) { return curr->value; }
};
template<class S> decltype(auto) UnaryMatcher(Unary** binder, UnaryOp op, S s) {
  return Matcher<UnaryKind<UnaryK>, S>(binder, op, s);
}
template<class S>
decltype(auto) AbstractUnaryMatcher(Unary** binder, Abstract::Op op, S s) {
  return Matcher<UnaryKind<AbstractUnaryK>, S>(binder, op, s);
}

// Binary and AbstractBinary
struct BinaryK {
  using Op = BinaryOp;
  static BinaryOp getOp(Type, Op op) { return op; }
};
struct AbstractBinaryK {
  using Op = Abstract::Op;
  static BinaryOp getOp(Type type, Abstract::Op op) {
    return Abstract::getBinary(type, op);
  }
};
template<class T> struct BinaryKind {};
template<class T> struct KindTypeRegistry<BinaryKind<T>> {
  using matched_t = Binary*;
  using data_t = typename T::Op;
};
template<class T> struct MatchSelf<BinaryKind<T>> {
  bool operator()(Binary* curr, typename T::Op op) {
    return curr->op == T::getOp(curr->left->type, op);
  }
};
template<class T> struct NumComponents<BinaryKind<T>> {
  static constexpr size_t value = 2;
};
template<class T> struct GetComponent<BinaryKind<T>, 0> {
  Expression*& operator()(Binary* curr) { return curr->left; }
};
template<class T> struct GetComponent<BinaryKind<T>, 1> {
  Expression*& operator()(Binary* curr) { return curr->right; }
};
template<class S1, class S2>
decltype(auto) BinaryMatcher(Binary** binder, BinaryOp op, S1 s1, S2 s2) {
  return Matcher<BinaryKind<BinaryK>, S1, S2>(binder, op, s1, s2);
}
template<class S1, class S2>
decltype(auto)
AbstractBinaryMatcher(Binary** binder, Abstract::Op op, S1 s1, S2 s2) {
  return Matcher<BinaryKind<AbstractBinaryK>, S1, S2>(binder, op, s1, s2);
}

// Select
template<> struct NumComponents<Select*> { static constexpr size_t value = 3; };
template<> struct GetComponent<Select*, 0> {
  Expression*& operator()(Select* curr) { return curr->ifTrue; }
};
template<> struct GetComponent<Select*, 1> {
  Expression*& operator()(Select* curr) { return curr->ifFalse; }
};
template<> struct GetComponent<Select*, 2> {
  Expression*& operator()(Select* curr) { return curr->condition; }
};
template<class S1, class S2, class S3>
decltype(auto) SelectMatcher(Select** binder, S1 s1, S2 s2, S3 s3) {
  return Matcher<Select*, S1, S2, S3>(binder, {}, s1, s2, s3);
}

} // namespace Internal

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
