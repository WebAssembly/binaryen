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
// that will be set equal to the expression they match.

#ifndef wasm_ir_match_h
#define wasm_ir_match_h

#include "ir/abstract.h"
#include "wasm.h"

namespace wasm {

namespace Match {

// The available matchers are:
//
//  i32, i64, f32, f64
//
//    Match constants of the corresponding type. Takes zero or one argument. The
//    argument can be a specific value to match or it can be a pointer to a
//    value, Literal, or Const* at which to store the matched entity.
//
//  ival, fval
//
//    Match any integer constant or any floating point constant. Takes neither,
//    either, or both of two possible arguments: first, a pointer to a value,
//    Literal, or Const* at which to store the matched entity and second, a
//    specific value to match.
//
//  constant
//
//    Matches any numeric Const expression. Takes neither, either, or both of
//    two possible arguments: first, a pointer to either Literal or Const* at
//    which to store the matched entity and second, a specific value (given as
//    an int32_t) to match..
//
//  any
//
//    Matches any Expression. Optionally takes as an argument a pointer to
//    Expression* at which to store the matched Expression*.
//
//  unary
//
//    Matches Unary expressions. Takes an optional pointer to Unary* at which to
//    store the matched Unary*, followed by either a UnaryOp or an Abstract::Op
//    describing which unary expressions to match, followed by a matcher to
//    apply to the unary expression's operand.
//
//  binary
//
//    Matches Binary expressions. Takes an optional pointer to Binary* at which
//    to store the matched Binary*, followed by either a BinaryOp or an
//    Abstract::Op describing which binary expresions to match, followed by
//    matchers to apply to the binary expression's left and right operands.
//
//  select
//
//    Matches Select expressions. Takes an optional pointer to Select* at which
//    to store the matched Select*, followed by matchers to apply to the ifTrue,
//    ifFalse, and condition operands.
//

// The main entrypoint for matching.
template<class Matcher> bool matches(Expression* expr, Matcher matcher) {
  return matcher.matches(expr);
}

namespace Internal {

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
// last. Uses a struct instead of a function because partial specialization of
// functions is not allowed.
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

// {I32,I64,Int,F32,F64,Float,Number}Lit: match `Literal` of the expected `Type`
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
struct NumberLitKind {};
template<> struct KindTypeRegistry<NumberLitKind> {
  using matched_t = Literal;
  using data_t = int32_t;
};
template<> struct MatchSelf<NumberLitKind> {
  bool operator()(Literal& lit, int32_t expected) {
    return lit.type.isNumber() &&
           Literal::makeFromInt32(expected, lit.type) == lit;
  }
};
template<> struct NumComponents<NumberLitKind> {
  static constexpr size_t value = 0;
};
decltype(auto) NumberLit(Literal* binder, int32_t expected) {
  return Matcher<NumberLitKind>(binder, expected);
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

// Public matching API

decltype(auto) i32() {
  return Internal::ConstMatcher(
    nullptr, Internal::I32Lit(nullptr, Internal::Any<int32_t>(nullptr)));
}
// Use int rather than int32_t to disambiguate literal 0
decltype(auto) i32(int x) {
  return Internal::ConstMatcher(
    nullptr, Internal::I32Lit(nullptr, Internal::Exact<int32_t>(nullptr, x)));
}
decltype(auto) i32(int32_t* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::I32Lit(nullptr, Internal::Any(binder)));
}
decltype(auto) i32(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::I32Lit(binder, Internal::Any<int32_t>(nullptr)));
}
decltype(auto) i32(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::I32Lit(nullptr, Internal::Any<int32_t>(nullptr)));
}

decltype(auto) i64() {
  return Internal::ConstMatcher(
    nullptr, Internal::I64Lit(nullptr, Internal::Any<int64_t>(nullptr)));
}
decltype(auto) i64(int64_t x) {
  return Internal::ConstMatcher(
    nullptr, Internal::I64Lit(nullptr, Internal::Exact<int64_t>(nullptr, x)));
}
// disambiguate literal 0
decltype(i64(std::declval<int64_t>())) i64(int x) { return i64(int32_t(x)); }
decltype(auto) i64(int64_t* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::I64Lit(nullptr, Internal::Any(binder)));
}
decltype(auto) i64(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::I64Lit(binder, Internal::Any<int64_t>(nullptr)));
}
decltype(auto) i64(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::I64Lit(nullptr, Internal::Any<int64_t>(nullptr)));
}

decltype(auto) f32() {
  return Internal::ConstMatcher(
    nullptr, Internal::F32Lit(nullptr, Internal::Any<float>(nullptr)));
}
decltype(auto) f32(float x) {
  return Internal::ConstMatcher(
    nullptr, Internal::F32Lit(nullptr, Internal::Exact<float>(nullptr, x)));
}
decltype(auto) f32(int x) { return f32(float(x)); } // disambiguate literal 0
decltype(auto) f32(float* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::F32Lit(nullptr, Internal::Any(binder)));
}
decltype(auto) f32(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::F32Lit(binder, Internal::Any<float>(nullptr)));
}
decltype(auto) f32(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::F32Lit(nullptr, Internal::Any<float>(nullptr)));
}

decltype(auto) f64() {
  return Internal::ConstMatcher(
    nullptr, Internal::F64Lit(nullptr, Internal::Any<double>(nullptr)));
}
decltype(auto) f64(double x) {
  return Internal::ConstMatcher(
    nullptr, Internal::F64Lit(nullptr, Internal::Exact<double>(nullptr, x)));
}
decltype(auto) f64(int x) { return f64(double(x)); } // disambiguate literal 0
decltype(auto) f64(double* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::F64Lit(nullptr, Internal::Any(binder)));
}
decltype(auto) f64(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::F64Lit(binder, Internal::Any<double>(nullptr)));
}
decltype(auto) f64(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::F64Lit(nullptr, Internal::Any<double>(nullptr)));
}

decltype(auto) ival() {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(nullptr, Internal::Any<int64_t>(nullptr)));
}
decltype(auto) ival(int64_t x) {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(nullptr, Internal::Exact<int64_t>(nullptr, x)));
}
decltype(auto) ival(int x) { return ival(int64_t(x)); } // disambiguate 0
decltype(auto) ival(int64_t* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(nullptr, Internal::Any(binder)));
}
decltype(auto) ival(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(binder, Internal::Any<int64_t>(nullptr)));
}
decltype(auto) ival(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::IntLit(nullptr, Internal::Any<int64_t>(nullptr)));
}
decltype(auto) ival(Literal* binder, int64_t x) {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(binder, Internal::Exact<int64_t>(nullptr, x)));
}
decltype(auto) ival(Const** binder, int64_t x) {
  return Internal::ConstMatcher(
    binder, Internal::IntLit(nullptr, Internal::Exact<int64_t>(nullptr, x)));
}

decltype(auto) fval() {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(nullptr, Internal::Any<double>(nullptr)));
}
decltype(auto) fval(double x) {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(nullptr, Internal::Exact<double>(nullptr, x)));
}
decltype(auto) fval(int x) { return fval(double(x)); } // disambiguate literal 0
decltype(auto) fval(double* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(nullptr, Internal::Any(binder)));
}
decltype(auto) fval(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(binder, Internal::Any<double>(nullptr)));
}
decltype(auto) fval(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::FloatLit(nullptr, Internal::Any<double>(nullptr)));
}
decltype(auto) fval(Literal* binder, double x) {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(binder, Internal::Exact<double>(nullptr, x)));
}
decltype(auto) fval(Const** binder, double x) {
  return Internal::ConstMatcher(
    binder, Internal::FloatLit(nullptr, Internal::Exact<double>(nullptr, x)));
}

decltype(auto) constant() {
  return Internal::ConstMatcher(nullptr, Internal::Any<Literal>(nullptr));
}
decltype(auto) constant(int x) {
  return Internal::ConstMatcher(nullptr, Internal::NumberLit(nullptr, x));
}
decltype(auto) constant(Literal* binder) {
  return Internal::ConstMatcher(nullptr, Internal::Any(binder));
}
decltype(auto) constant(Const** binder) {
  return Internal::ConstMatcher(binder, Internal::Any<Literal>(nullptr));
}
decltype(auto) constant(Literal* binder, int32_t x) {
  return Internal::ConstMatcher(nullptr, Internal::NumberLit(binder, x));
}
decltype(auto) constant(Const** binder, int32_t x) {
  return Internal::ConstMatcher(binder, Internal::NumberLit(nullptr, x));
}

decltype(auto) any() { return Internal::Any<Expression*>(nullptr); }
decltype(auto) any(Expression** binder) { return Internal::Any(binder); }

template<class S> decltype(auto) unary(UnaryOp op, S s) {
  return Internal::UnaryMatcher(nullptr, op, s);
}
template<class S> decltype(auto) unary(Abstract::Op op, S s) {
  return Internal::AbstractUnaryMatcher(nullptr, op, s);
}
template<class S> decltype(auto) unary(Unary** binder, UnaryOp op, S s) {
  return Internal::UnaryMatcher(binder, op, s);
}
template<class S> decltype(auto) unary(Unary** binder, Abstract::Op op, S s) {
  return Internal::AbstractUnaryMatcher(binder, op, s);
}

template<class S1, class S2> decltype(auto) binary(BinaryOp op, S1 s1, S2 s2) {
  return Internal::BinaryMatcher(nullptr, op, s1, s2);
}
template<class S1, class S2>
decltype(auto) binary(Abstract::Op op, S1 s1, S2 s2) {
  return Internal::AbstractBinaryMatcher(nullptr, op, s1, s2);
}
template<class S1, class S2>
decltype(auto) binary(Binary** binder, BinaryOp op, S1 s1, S2 s2) {
  return Internal::BinaryMatcher(binder, op, s1, s2);
}
template<class S1, class S2>
decltype(auto) binary(Binary** binder, Abstract::Op op, S1 s1, S2 s2) {
  return Internal::AbstractBinaryMatcher(binder, op, s1, s2);
}

template<class S1, class S2, class S3>
decltype(auto) select(S1 s1, S2 s2, S3 s3) {
  return Internal::SelectMatcher(nullptr, s1, s2, s3);
}
template<class S1, class S2, class S3>
decltype(auto) select(Select** binder, S1 s1, S2 s2, S3 s3) {
  return Internal::SelectMatcher(binder, s1, s2, s3);
}

} // namespace Match

} // namespace wasm

#endif // wasm_ir_match_h
