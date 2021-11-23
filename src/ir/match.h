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
// match.h - Provides an easily extensible layered API for matching expression
// patterns and extracting their components. The low-level API provides modular
// building blocks for creating matchers for any data type and the high-level
// API provides a succinct and flexible interface for matching expressions and
// extracting useful information from them.

#ifndef wasm_ir_match_h
#define wasm_ir_match_h

#include "ir/abstract.h"
#include "wasm.h"

namespace wasm::Match {

// The available matchers are:
//
//  i32, i64, f32, f64
//
//    Match constants of the corresponding type. Takes zero or one argument. The
//    argument can be a specific value to match or it can be a pointer to a
//    value, Literal, or Const* at which to store the matched entity.
//
//  bval, ival, fval
//
//    Match any boolean, any integer or any floating point constant. Takes
//    neither, either, or both of two possible arguments: first, a pointer to a
//    value, Literal, or Const* at which to store the matched entity and second,
//    a specific value to match.
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
//
// How to create new matchers:
//
//  Lets add a matcher for an expression type that is declared in wasm.h:
//
//    class Frozzle : public SpecificExpression<Expression::FrozzleId> {
//    public:
//      Expression* foo;
//      Expression* bar;
//      Expression* baz;
//    };
//
//  This expression is very simple; in order to match it, all we need to do is
//  apply other matchers to its subexpressions. The matcher infrastructure will
//  handle this automatically once we tell it how to access the subexpressions.
//  To tell the matcher infrastructure how many subexpressions there are we need
//  to specialize `NumComponents`.
//
//    template<> struct NumComponents<Frozzle*> {
//      static constexpr size_t value = 3;
//    };
//
//  And to tell the matcher infrastructure how to access those three
//  subexpressions, we need to specialize `GetComponent` three times.
//
//    template<> struct GetComponent<Frozzle*, 0> {
//      Expression* operator()(Frozzle* curr) { return curr->foo; }
//    };
//    template<> struct GetComponent<Frozzle*, 1> {
//      Expression* operator()(Frozzle* curr) { return curr->bar; }
//    };
//    template<> struct GetComponent<Frozzle*, 2> {
//      Expression* operator()(Frozzle* curr) { return curr->baz; }
//    };
//
//  For simple expressions, that's all we need to do to get a fully functional
//  matcher that we can construct and use like this, where S1, S2, and S3 are
//  the types of the submatchers to use and s1, s2, and s3 are instances of
//  those types:
//
//    Frozzle* extracted;
//    auto matcher = Matcher<Frozzle*, S1, S2, S3>(&extracted, {}, s1, s2, s3);
//    if (matches(expr, matcher)) {
//      // `extracted` set to `expr` here
//    }
//
//  It's annoying to have to write out the types S1, S2, and S3 and we don't get
//  class template argument deduction (CTAD) until C++17, so it's useful to
//  create a wrapper function so can take advantage of function template
//  argument deduction. We can also take this opportunity to make the interface
//  more compact.
//
//    template<class S1, class S2, class S3>
//    inline decltype(auto) frozzle(Frozzle** binder,
//                                  S1&& s1, S2&& s2, S3&& s3) {
//      return Matcher<Frozzle*, S1, S2, S3>(binder, {}, s1, s2, s3);
//    }
//    template<class S1, class S2, class S3>
//    inline decltype(auto) frozzle(S1&& s1, S2&& s2, S3&& s3) {
//      return Matcher<Frozzle*, S1, S2, S3>(nullptr, {}, s1, s2, s3);
//    }
//
//  Notice that we make the interface more compact by providing overloads with
//  and without the binder. Here is the final matcher usage:
//
//    Frozzle* extracted;
//    if (matches(expr, frozzle(&extracted, s1, s2, s3))) {
//      // `extracted` set to `expr` here
//    }
//
//  Some matchers are more complicated, though, because they need to do
//  something besides just applying submatchers to the components of an
//  expression. These matchers require slightly more work.
//
//
// Complex matchers:
//
//  Lets add a matcher that will match calls to functions whose names start with
//  certain prefixes. Since this is not a normal matcher for Call expressions,
//  we can't identify it by the Call* type. Instead, we have to create a new
//  identifier type, called a "Kind" for it.
//
//    struct PrefixCallKind {};
//
//  Next, since we're not in the common case of using a specific expression
//  pointer as our kind, we have to tell the matcher infrastructure what type of
//  thing this matcher matches. Since we want this matcher to be able to match
//  any given prefix, we also need the matcher to contain the given prefix as
//  state, and we need to tell the matcher infrastructure what type that state
//  is as well. To specify these types, we need to specialize
//  `KindTypeRegistry` for `PrefixCallKind`.
//
//    template<> struct KindTypeRegistry<PrefixCallKind> {
//      using matched_t = Call*;
//      using data_t = Name;
//    };
//
//  Note that because `matched_t` is set to a specific expression pointer, this
//  matcher will automatically be able to be applied to any `Expression*`, not
//  just `Call*`. If `matched_t` were not a specific expression pointer, this
//  matcher would only be able to be applied to types compatible with
//  `matched_t`. Also note that if a matcher does not need to store any state,
//  its `data_t` should be set to `unused_t`.
//
//  Now we need to tell the matcher infrastructure what custom logic to apply
//  for this matcher. We do this by specializing `MatchSelf`.
//
//    template<> struct MatchSelf<PrefixCallKind> {
//      bool operator()(Call* curr, Name prefix) {
//        return curr->name.startsWith(prefix);
//      }
//    };
//
//  Note that the first parameter to `MatchSelf<Kind>::operator()` will be that
//  kind's `matched_t` and the second parameter will be that kind's `data_t`,
//  which may be `unused_t`. (TODO: detect if `data_t` is `unused_t` and don't
//  expose it in the Matcher interface if so.)
//
//  After this, everything is the same as in the simple matcher case. This
//  particular matcher doesn't need to recurse into any subcomponents, so we can
//  skip straight to creating the wrapper function.
//
//    decltype(auto) prefixCall(Call** binder, Name prefix) {
//      return Matcher<PrefixCallKind>(binder, prefix);
//    }
//
//  Now we can use the new matcher:
//
//    Call* call;
//    if (matches(expr, prefixCall(&call, "__foo"))) {
//      // `call` set to `expr` here
//    }
//

// The main entrypoint for matching. If the match succeeds, all variables bound
// in the matcher will be set to their corresponding matched values. Otherwise,
// the value of the bound variables is unspecified and may have changed.
template<class Matcher> inline bool matches(Expression* expr, Matcher matcher) {
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
  // The type of additional state needed to perform a match. Can be set to
  // `unused_t` if it's not needed.
  using data_t = unused_t;
};

// Given a `Kind`, produce the type `matched_t` that is matched by that Kind and
// the type `candidate_t` that is the type of the parameter of the `matches`
// method. These types are only different if `matched_t` is a pointer to a
// subtype of Expression, in which case `candidate_t` is Expression*.
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
inline bool dynCastCandidate(candidate_t<Kind> candidate,
                             matched_t<Kind>& out) {
  out = candidate->template dynCast<std::remove_pointer_t<matched_t<Kind>>>();
  return out != nullptr;
}

// Otherwise we are not matching an Expression, so this is infallible.
template<class Kind, enable_if_not_castable_t<Kind> = 0>
inline bool dynCastCandidate(candidate_t<Kind> candidate,
                             matched_t<Kind>& out) {
  out = candidate;
  return true;
}

// Matchers can optionally specialize this to perform custom matching logic
// before recursing into submatchers, potentially short-circuiting the match.
// Uses a struct because partial specialization of functions is not allowed.
template<class Kind> struct MatchSelf {
  bool operator()(matched_t<Kind>, data_t<Kind>) { return true; }
};

// Used to statically ensure that each matcher has the correct number of
// submatchers. This needs to be specialized for each kind of matcher that has
// submatchers.
template<class Kind> struct NumComponents {
  static constexpr size_t value = 0;
};

// Every kind of matcher needs to partially specialize this for each of its
// components. Each specialization should define
//
//   T operator()(matched_t<Kind>)
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
  static inline bool
  match(matched_t<Kind> candidate,
        SubMatchers<CurrMatcher, NextMatchers...>& matchers) {
    return matchers.curr.matches(GetComponent<Kind, pos>{}(candidate)) &&
           Components<Kind, pos + 1, NextMatchers...>::match(candidate,
                                                             matchers.next);
  }
};
template<class Kind, int pos> struct Components<Kind, pos> {
  static_assert(pos == NumComponents<Kind>::value,
                "Unexpected number of submatchers");
  static inline bool match(matched_t<Kind>, SubMatchers<>) {
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

  inline bool matches(candidate_t<Kind> candidate) {
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
template<class T> inline decltype(auto) Any(T* binder) {
  return Matcher<AnyKind<T>>(binder, {});
}

// Exact<T>: matches exact values of the expected type
template<class T> struct ExactKind {};
template<class T> struct KindTypeRegistry<ExactKind<T>> {
  using matched_t = T;
  using data_t = T;
};
template<class T> struct MatchSelf<ExactKind<T>> {
  bool operator()(T self, T expected) { return self == expected; }
};
template<class T> inline decltype(auto) Exact(T* binder, T data) {
  return Matcher<ExactKind<T>>(binder, data);
}

// {Bool,I32,I64,Int,F32,F64,Float,Number}Lit:
// match `Literal` of the expected `Type`
struct BoolLK {
  static bool matchType(Literal lit) {
    return lit.type == Type::i32 && (uint32_t)lit.geti32() <= 1U;
  }
  static int32_t getVal(Literal lit) { return lit.geti32(); }
};
struct I32LK {
  static bool matchType(Literal lit) { return lit.type == Type::i32; }
  static int32_t getVal(Literal lit) { return lit.geti32(); }
};
struct I64LK {
  static bool matchType(Literal lit) { return lit.type == Type::i64; }
  static int64_t getVal(Literal lit) { return lit.geti64(); }
};
struct IntLK {
  static bool matchType(Literal lit) { return lit.type.isInteger(); }
  static int64_t getVal(Literal lit) { return lit.getInteger(); }
};
struct F32LK {
  static bool matchType(Literal lit) { return lit.type == Type::f32; }
  static float getVal(Literal lit) { return lit.getf32(); }
};
struct F64LK {
  static bool matchType(Literal lit) { return lit.type == Type::f64; }
  static double getVal(Literal lit) { return lit.getf64(); }
};
struct FloatLK {
  static bool matchType(Literal lit) { return lit.type.isFloat(); }
  static double getVal(Literal lit) { return lit.getFloat(); }
};
template<class T> struct LitKind {};
template<class T> struct KindTypeRegistry<LitKind<T>> {
  using matched_t = Literal;
  using data_t = unused_t;
};
template<class T> struct MatchSelf<LitKind<T>> {
  bool operator()(Literal lit, unused_t) { return T::matchType(lit); }
};
template<class T> struct NumComponents<LitKind<T>> {
  static constexpr size_t value = 1;
};
template<class T> struct GetComponent<LitKind<T>, 0> {
  decltype(auto) operator()(Literal lit) { return T::getVal(lit); }
};
template<class S> inline decltype(auto) BoolLit(Literal* binder, S&& s) {
  return Matcher<LitKind<BoolLK>, S>(binder, {}, s);
}
template<class S> inline decltype(auto) I32Lit(Literal* binder, S&& s) {
  return Matcher<LitKind<I32LK>, S>(binder, {}, s);
}
template<class S> inline decltype(auto) I64Lit(Literal* binder, S&& s) {
  return Matcher<LitKind<I64LK>, S>(binder, {}, s);
}
template<class S> inline decltype(auto) IntLit(Literal* binder, S&& s) {
  return Matcher<LitKind<IntLK>, S>(binder, {}, s);
}
template<class S> inline decltype(auto) F32Lit(Literal* binder, S&& s) {
  return Matcher<LitKind<F32LK>, S>(binder, {}, s);
}
template<class S> inline decltype(auto) F64Lit(Literal* binder, S&& s) {
  return Matcher<LitKind<F64LK>, S>(binder, {}, s);
}
template<class S> inline decltype(auto) FloatLit(Literal* binder, S&& s) {
  return Matcher<LitKind<FloatLK>, S>(binder, {}, s);
}
struct NumberLitKind {};
template<> struct KindTypeRegistry<NumberLitKind> {
  using matched_t = Literal;
  using data_t = int32_t;
};
template<> struct MatchSelf<NumberLitKind> {
  bool operator()(Literal lit, int32_t expected) {
    return lit.type.isNumber() &&
           Literal::makeFromInt32(expected, lit.type) == lit;
  }
};
inline decltype(auto) NumberLit(Literal* binder, int32_t expected) {
  return Matcher<NumberLitKind>(binder, expected);
}

// Const
template<> struct NumComponents<Const*> { static constexpr size_t value = 1; };
template<> struct GetComponent<Const*, 0> {
  Literal operator()(Const* c) { return c->value; }
};
template<class S> inline decltype(auto) ConstMatcher(Const** binder, S&& s) {
  return Matcher<Const*, S>(binder, {}, s);
}

// Unary, UnaryOp and AbstractUnaryOp
template<> struct NumComponents<Unary*> { static constexpr size_t value = 2; };
template<> struct GetComponent<Unary*, 0> {
  UnaryOp operator()(Unary* curr) { return curr->op; }
};
template<> struct GetComponent<Unary*, 1> {
  Expression* operator()(Unary* curr) { return curr->value; }
};
struct UnaryOpK {
  using Op = UnaryOp;
  static UnaryOp getOp(Type, Op op) { return op; }
};
struct AbstractUnaryOpK {
  using Op = Abstract::Op;
  static UnaryOp getOp(Type type, Abstract::Op op) {
    return Abstract::getUnary(type, op);
  }
};
template<class T> struct UnaryOpKind {};
template<class T> struct KindTypeRegistry<UnaryOpKind<T>> {
  using matched_t = Unary*;
  using data_t = typename T::Op;
};
template<class T> struct MatchSelf<UnaryOpKind<T>> {
  bool operator()(Unary* curr, typename T::Op op) {
    return curr->op == T::getOp(curr->value->type, op);
  }
};
template<class T> struct NumComponents<UnaryOpKind<T>> {
  static constexpr size_t value = 1;
};
template<class T> struct GetComponent<UnaryOpKind<T>, 0> {
  Expression* operator()(Unary* curr) { return curr->value; }
};
template<class S1, class S2>
inline decltype(auto) UnaryMatcher(Unary** binder, S1&& s1, S2&& s2) {
  return Matcher<Unary*, S1, S2>(binder, {}, s1, s2);
}
template<class S>
inline decltype(auto) UnaryOpMatcher(Unary** binder, UnaryOp op, S&& s) {
  return Matcher<UnaryOpKind<UnaryOpK>, S>(binder, op, s);
}
template<class S>
inline decltype(auto)
AbstractUnaryOpMatcher(Unary** binder, Abstract::Op op, S&& s) {
  return Matcher<UnaryOpKind<AbstractUnaryOpK>, S>(binder, op, s);
}

// Binary, BinaryOp and AbstractBinaryOp
template<> struct NumComponents<Binary*> { static constexpr size_t value = 3; };
template<> struct GetComponent<Binary*, 0> {
  BinaryOp operator()(Binary* curr) { return curr->op; }
};
template<> struct GetComponent<Binary*, 1> {
  Expression* operator()(Binary* curr) { return curr->left; }
};
template<> struct GetComponent<Binary*, 2> {
  Expression* operator()(Binary* curr) { return curr->right; }
};
struct BinaryOpK {
  using Op = BinaryOp;
  static BinaryOp getOp(Type, Op op) { return op; }
};
struct AbstractBinaryOpK {
  using Op = Abstract::Op;
  static BinaryOp getOp(Type type, Abstract::Op op) {
    return Abstract::getBinary(type, op);
  }
};
template<class T> struct BinaryOpKind {};
template<class T> struct KindTypeRegistry<BinaryOpKind<T>> {
  using matched_t = Binary*;
  using data_t = typename T::Op;
};
template<class T> struct MatchSelf<BinaryOpKind<T>> {
  bool operator()(Binary* curr, typename T::Op op) {
    return curr->op == T::getOp(curr->left->type, op);
  }
};
template<class T> struct NumComponents<BinaryOpKind<T>> {
  static constexpr size_t value = 2;
};
template<class T> struct GetComponent<BinaryOpKind<T>, 0> {
  Expression* operator()(Binary* curr) { return curr->left; }
};
template<class T> struct GetComponent<BinaryOpKind<T>, 1> {
  Expression* operator()(Binary* curr) { return curr->right; }
};
template<class S1, class S2, class S3>
inline decltype(auto)
BinaryMatcher(Binary** binder, S1&& s1, S2&& s2, S3&& s3) {
  return Matcher<Binary*, S1, S2, S3>(binder, {}, s1, s2, s3);
}
template<class S1, class S2>
inline decltype(auto)
BinaryOpMatcher(Binary** binder, BinaryOp op, S1&& s1, S2&& s2) {
  return Matcher<BinaryOpKind<BinaryOpK>, S1, S2>(binder, op, s1, s2);
}
template<class S1, class S2>
inline decltype(auto)
AbstractBinaryOpMatcher(Binary** binder, Abstract::Op op, S1&& s1, S2&& s2) {
  return Matcher<BinaryOpKind<AbstractBinaryOpK>, S1, S2>(binder, op, s1, s2);
}

// Select
template<> struct NumComponents<Select*> { static constexpr size_t value = 3; };
template<> struct GetComponent<Select*, 0> {
  Expression* operator()(Select* curr) { return curr->ifTrue; }
};
template<> struct GetComponent<Select*, 1> {
  Expression* operator()(Select* curr) { return curr->ifFalse; }
};
template<> struct GetComponent<Select*, 2> {
  Expression* operator()(Select* curr) { return curr->condition; }
};
template<class S1, class S2, class S3>
inline decltype(auto)
SelectMatcher(Select** binder, S1&& s1, S2&& s2, S3&& s3) {
  return Matcher<Select*, S1, S2, S3>(binder, {}, s1, s2, s3);
}

} // namespace Internal

// Public matching API

inline decltype(auto) bval() {
  return Internal::ConstMatcher(
    nullptr, Internal::BoolLit(nullptr, Internal::Any<bool>(nullptr)));
}
inline decltype(auto) bval(bool x) {
  return Internal::ConstMatcher(
    nullptr, Internal::BoolLit(nullptr, Internal::Exact<bool>(nullptr, x)));
}
inline decltype(auto) bval(bool* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::BoolLit(nullptr, Internal::Any(binder)));
}
inline decltype(auto) bval(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::BoolLit(binder, Internal::Any<bool>(nullptr)));
}
inline decltype(auto) bval(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::BoolLit(nullptr, Internal::Any<bool>(nullptr)));
}

inline decltype(auto) i32() {
  return Internal::ConstMatcher(
    nullptr, Internal::I32Lit(nullptr, Internal::Any<int32_t>(nullptr)));
}
// Use int rather than int32_t to disambiguate literal 0, which otherwise could
// be resolved to either the int32_t overload or any of the pointer overloads.
inline decltype(auto) i32(int x) {
  return Internal::ConstMatcher(
    nullptr, Internal::I32Lit(nullptr, Internal::Exact<int32_t>(nullptr, x)));
}
inline decltype(auto) i32(int32_t* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::I32Lit(nullptr, Internal::Any(binder)));
}
inline decltype(auto) i32(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::I32Lit(binder, Internal::Any<int32_t>(nullptr)));
}
inline decltype(auto) i32(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::I32Lit(nullptr, Internal::Any<int32_t>(nullptr)));
}

inline decltype(auto) i64() {
  return Internal::ConstMatcher(
    nullptr, Internal::I64Lit(nullptr, Internal::Any<int64_t>(nullptr)));
}
inline decltype(auto) i64(int64_t x) {
  return Internal::ConstMatcher(
    nullptr, Internal::I64Lit(nullptr, Internal::Exact<int64_t>(nullptr, x)));
}
// Disambiguate literal 0, which could otherwise be interpreted as a pointer
inline decltype(auto) i64(int x) { return i64(int64_t(x)); }
inline decltype(auto) i64(int64_t* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::I64Lit(nullptr, Internal::Any(binder)));
}
inline decltype(auto) i64(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::I64Lit(binder, Internal::Any<int64_t>(nullptr)));
}
inline decltype(auto) i64(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::I64Lit(nullptr, Internal::Any<int64_t>(nullptr)));
}

inline decltype(auto) f32() {
  return Internal::ConstMatcher(
    nullptr, Internal::F32Lit(nullptr, Internal::Any<float>(nullptr)));
}
inline decltype(auto) f32(float x) {
  return Internal::ConstMatcher(
    nullptr, Internal::F32Lit(nullptr, Internal::Exact<float>(nullptr, x)));
}
// Disambiguate literal 0, which could otherwise be interpreted as a pointer
inline decltype(auto) f32(int x) { return f32(float(x)); }
inline decltype(auto) f32(float* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::F32Lit(nullptr, Internal::Any(binder)));
}
inline decltype(auto) f32(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::F32Lit(binder, Internal::Any<float>(nullptr)));
}
inline decltype(auto) f32(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::F32Lit(nullptr, Internal::Any<float>(nullptr)));
}

inline decltype(auto) f64() {
  return Internal::ConstMatcher(
    nullptr, Internal::F64Lit(nullptr, Internal::Any<double>(nullptr)));
}
inline decltype(auto) f64(double x) {
  return Internal::ConstMatcher(
    nullptr, Internal::F64Lit(nullptr, Internal::Exact<double>(nullptr, x)));
}
// Disambiguate literal 0, which could otherwise be interpreted as a pointer
inline decltype(auto) f64(int x) { return f64(double(x)); }
inline decltype(auto) f64(double* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::F64Lit(nullptr, Internal::Any(binder)));
}
inline decltype(auto) f64(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::F64Lit(binder, Internal::Any<double>(nullptr)));
}
inline decltype(auto) f64(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::F64Lit(nullptr, Internal::Any<double>(nullptr)));
}

inline decltype(auto) ival() {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(nullptr, Internal::Any<int64_t>(nullptr)));
}
inline decltype(auto) ival(int64_t x) {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(nullptr, Internal::Exact<int64_t>(nullptr, x)));
}
// Disambiguate literal 0, which could otherwise be interpreted as a pointer
inline decltype(auto) ival(int x) { return ival(int64_t(x)); }
inline decltype(auto) ival(int64_t* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(nullptr, Internal::Any(binder)));
}
inline decltype(auto) ival(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(binder, Internal::Any<int64_t>(nullptr)));
}
inline decltype(auto) ival(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::IntLit(nullptr, Internal::Any<int64_t>(nullptr)));
}
inline decltype(auto) ival(Literal* binder, int64_t x) {
  return Internal::ConstMatcher(
    nullptr, Internal::IntLit(binder, Internal::Exact<int64_t>(nullptr, x)));
}
inline decltype(auto) ival(Const** binder, int64_t x) {
  return Internal::ConstMatcher(
    binder, Internal::IntLit(nullptr, Internal::Exact<int64_t>(nullptr, x)));
}

inline decltype(auto) fval() {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(nullptr, Internal::Any<double>(nullptr)));
}
inline decltype(auto) fval(double x) {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(nullptr, Internal::Exact<double>(nullptr, x)));
}
// Disambiguate literal 0, which could otherwise be interpreted as a pointer
inline decltype(auto) fval(int x) { return fval(double(x)); }
inline decltype(auto) fval(double* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(nullptr, Internal::Any(binder)));
}
inline decltype(auto) fval(Literal* binder) {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(binder, Internal::Any<double>(nullptr)));
}
inline decltype(auto) fval(Const** binder) {
  return Internal::ConstMatcher(
    binder, Internal::FloatLit(nullptr, Internal::Any<double>(nullptr)));
}
inline decltype(auto) fval(Literal* binder, double x) {
  return Internal::ConstMatcher(
    nullptr, Internal::FloatLit(binder, Internal::Exact<double>(nullptr, x)));
}
inline decltype(auto) fval(Const** binder, double x) {
  return Internal::ConstMatcher(
    binder, Internal::FloatLit(nullptr, Internal::Exact<double>(nullptr, x)));
}

inline decltype(auto) constant() {
  return Internal::ConstMatcher(nullptr, Internal::Any<Literal>(nullptr));
}
inline decltype(auto) constant(int x) {
  return Internal::ConstMatcher(nullptr, Internal::NumberLit(nullptr, x));
}
inline decltype(auto) constant(Literal* binder) {
  return Internal::ConstMatcher(nullptr, Internal::Any(binder));
}
inline decltype(auto) constant(Const** binder) {
  return Internal::ConstMatcher(binder, Internal::Any<Literal>(nullptr));
}
inline decltype(auto) constant(Literal* binder, int32_t x) {
  return Internal::ConstMatcher(nullptr, Internal::NumberLit(binder, x));
}
inline decltype(auto) constant(Const** binder, int32_t x) {
  return Internal::ConstMatcher(binder, Internal::NumberLit(nullptr, x));
}

inline decltype(auto) any() { return Internal::Any<Expression*>(nullptr); }
inline decltype(auto) any(Expression** binder) { return Internal::Any(binder); }

template<class S> inline decltype(auto) unary(S&& s) {
  return Internal::UnaryMatcher(nullptr, Internal::Any<UnaryOp>(nullptr), s);
}
template<class S> inline decltype(auto) unary(Unary** binder, S&& s) {
  return Internal::UnaryMatcher(binder, Internal::Any<UnaryOp>(nullptr), s);
}
template<class S> inline decltype(auto) unary(UnaryOp* binder, S&& s) {
  return Internal::UnaryMatcher(nullptr, Internal::Any<UnaryOp>(binder), s);
}
template<class S> inline decltype(auto) unary(UnaryOp op, S&& s) {
  return Internal::UnaryOpMatcher(nullptr, op, s);
}
template<class S> inline decltype(auto) unary(Abstract::Op op, S&& s) {
  return Internal::AbstractUnaryOpMatcher(nullptr, op, s);
}
template<class S>
inline decltype(auto) unary(Unary** binder, UnaryOp op, S&& s) {
  return Internal::UnaryOpMatcher(binder, op, s);
}
template<class S>
inline decltype(auto) unary(Unary** binder, Abstract::Op op, S&& s) {
  return Internal::AbstractUnaryOpMatcher(binder, op, s);
}
template<class S1, class S2> inline decltype(auto) binary(S1&& s1, S2&& s2) {
  return Internal::BinaryMatcher(
    nullptr, Internal::Any<BinaryOp>(nullptr), s1, s2);
}
template<class S1, class S2>
inline decltype(auto) binary(Binary** binder, S1&& s1, S2&& s2) {
  return Internal::BinaryMatcher(
    binder, Internal::Any<BinaryOp>(nullptr), s1, s2);
}
template<class S1, class S2>
inline decltype(auto) binary(BinaryOp* binder, S1&& s1, S2&& s2) {
  return Internal::BinaryMatcher(
    nullptr, Internal::Any<BinaryOp>(binder), s1, s2);
}
template<class S1, class S2>
inline decltype(auto) binary(BinaryOp op, S1&& s1, S2&& s2) {
  return Internal::BinaryOpMatcher(nullptr, op, s1, s2);
}
template<class S1, class S2>
inline decltype(auto) binary(Abstract::Op op, S1&& s1, S2&& s2) {
  return Internal::AbstractBinaryOpMatcher(nullptr, op, s1, s2);
}
template<class S1, class S2>
inline decltype(auto) binary(Binary** binder, BinaryOp op, S1&& s1, S2&& s2) {
  return Internal::BinaryOpMatcher(binder, op, s1, s2);
}
template<class S1, class S2>
inline decltype(auto)
binary(Binary** binder, Abstract::Op op, S1&& s1, S2&& s2) {
  return Internal::AbstractBinaryOpMatcher(binder, op, s1, s2);
}

template<class S1, class S2, class S3>
inline decltype(auto) select(S1&& s1, S2&& s2, S3&& s3) {
  return Internal::SelectMatcher(nullptr, s1, s2, s3);
}
template<class S1, class S2, class S3>
inline decltype(auto) select(Select** binder, S1&& s1, S2&& s2, S3&& s3) {
  return Internal::SelectMatcher(binder, s1, s2, s3);
}

} // namespace wasm::Match

#endif // wasm_ir_match_h
