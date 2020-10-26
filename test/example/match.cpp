#include <cassert>
#include <iostream>

#include "literal.h"
#include "wasm-builder.h"
#include <ir/match.h>

using namespace wasm;
using namespace wasm::Match;

Module module;
Builder builder(module);

void test_internal_any() {
  std::cout << "Testing Internal::Any\n";

  assert(Internal::Any<int32_t>(nullptr).matches(0));
  assert(Internal::Any<int32_t>(nullptr).matches(1));
  assert(Internal::Any<int32_t>(nullptr).matches(-1));
  assert(Internal::Any<int32_t>(nullptr).matches(42LL));
  assert(Internal::Any<int32_t>(nullptr).matches(4.2f));

  assert(Internal::Any<int64_t>(nullptr).matches(0));
  assert(Internal::Any<int64_t>(nullptr).matches(1));
  assert(Internal::Any<int64_t>(nullptr).matches(-1));
  assert(Internal::Any<int64_t>(nullptr).matches(42LL));
  assert(Internal::Any<int64_t>(nullptr).matches(4.2f));

  assert(Internal::Any<float>(nullptr).matches(0));
  assert(Internal::Any<float>(nullptr).matches(1));
  assert(Internal::Any<float>(nullptr).matches(-1));
  assert(Internal::Any<float>(nullptr).matches(42LL));
  assert(Internal::Any<float>(nullptr).matches(4.2f));

  assert(Internal::Any<double>(nullptr).matches(0));
  assert(Internal::Any<double>(nullptr).matches(1));
  assert(Internal::Any<double>(nullptr).matches(-1));
  assert(Internal::Any<double>(nullptr).matches(42LL));
  assert(Internal::Any<double>(nullptr).matches(4.2f));

  // Working as intended: cannot convert `const char [6]' to double
  // assert(Internal::Any<double>(nullptr).matches("hello"));

  {
    int32_t val = 0xffffffff;
    assert(Internal::Any<int32_t>(&val).matches(0));
    assert(val == 0);
    assert(Internal::Any<int32_t>(&val).matches(1));
    assert(val == 1);
    assert(Internal::Any<int32_t>(&val).matches(-1));
    assert(val == -1);
    assert(Internal::Any<int32_t>(&val).matches(42LL));
    assert(val == 42);
    assert(Internal::Any<int32_t>(&val).matches(4.2f));
    assert(val == 4);
  }

  {
    Expression* expr = nullptr;
    Nop* nop = nullptr;

    Expression* builtExpr = builder.makeNop();
    Nop* builtNop = builder.makeNop();
    AtomicFence* builtFence = builder.makeAtomicFence();

    assert(Internal::Any(&expr).matches(builtExpr));
    assert(expr == builtExpr);

    assert(Internal::Any(&expr).matches(builtNop));
    assert(expr == builtNop);

    assert(Internal::Any(&expr).matches(builtFence));
    assert(expr == builtFence);

    assert(Internal::Any(&nop).matches(builtExpr));
    assert(nop == builtExpr);

    assert(Internal::Any(&nop).matches(builtNop));
    assert(nop == builtNop);

    // Does NOT match sibling expression types. Bound variable unchanged.
    assert(!Internal::Any(&nop).matches(builtFence));
    assert(nop == builtNop);

    // Working as intended: invalid conversion from Expression** to Nop**
    // assert(Internal::Any<Nop*>(&expr).matches(builtExpr));
  }
}

void test_internal_exact() {
  std::cout << "Testing Internal::Exact\n";

  assert(Internal::Exact<int32_t>(nullptr, 0).matches(0));
  assert(Internal::Exact<int32_t>(nullptr, 1).matches(1));
  assert(Internal::Exact<int32_t>(nullptr, -1).matches(-1));
  assert(Internal::Exact<int32_t>(nullptr, 42).matches(42LL));
  assert(Internal::Exact<int32_t>(nullptr, 4).matches(4.2f));

  assert(!Internal::Exact<int32_t>(nullptr, 1).matches(0));
  assert(!Internal::Exact<int32_t>(nullptr, -1).matches(1));
  assert(!Internal::Exact<int32_t>(nullptr, 42).matches(-1));
  assert(!Internal::Exact<int32_t>(nullptr, 4).matches(42LL));
  assert(!Internal::Exact<int32_t>(nullptr, 0).matches(4.2f));

  {
    Expression* expr = nullptr;
    Nop* nop = nullptr;

    Nop* builtNop = builder.makeNop();
    Expression* builtExpr = builtNop;

    assert(!Internal::Exact(&expr, expr).matches(builtExpr));
    assert(Internal::Exact(&expr, builtExpr).matches(builtExpr));
    assert(expr == builtExpr);

    assert(!Internal::Exact(&nop, nop).matches(builtNop));
    assert(Internal::Exact(&nop, builtNop).matches(builtNop));
    assert(nop == builtNop);
    nop = nullptr;
    assert(Internal::Exact(&nop, builtNop).matches(builtExpr));
    assert(nop == builtNop);
  }
}

void test_internal_literal() {
  std::cout << "Testing Internal::{I32,I64,Int,F32,F64,Float}Lit\n";

  Literal i32Zero(int32_t(0));
  Literal i32One(int32_t(1));
  Literal f32Zero(float(0));
  Literal f32One(float(1));
  Literal i64Zero(int64_t(0));
  Literal i64One(int64_t(1));
  Literal f64Zero(double(0));
  Literal f64One(double(1));

  auto anyi32 = Internal::I32Lit(nullptr, Internal::Any<int32_t>(nullptr));
  assert(anyi32.matches(i32Zero));
  assert(anyi32.matches(i32One));
  assert(!anyi32.matches(f32Zero));
  assert(!anyi32.matches(f32One));
  assert(!anyi32.matches(i64Zero));
  assert(!anyi32.matches(i64One));
  assert(!anyi32.matches(f64Zero));
  assert(!anyi32.matches(f64One));

  auto onei32 = Internal::I32Lit(nullptr, Internal::Exact<int32_t>(nullptr, 1));
  assert(!onei32.matches(i32Zero));
  assert(onei32.matches(i32One));
  assert(!onei32.matches(f32Zero));
  assert(!onei32.matches(f32One));
  assert(!onei32.matches(i64Zero));
  assert(!onei32.matches(i64One));
  assert(!onei32.matches(f64Zero));
  assert(!onei32.matches(f64One));

  auto anyi64 = Internal::I64Lit(nullptr, Internal::Any<int64_t>(nullptr));
  assert(!anyi64.matches(i32Zero));
  assert(!anyi64.matches(i32One));
  assert(!anyi64.matches(f32Zero));
  assert(!anyi64.matches(f32One));
  assert(anyi64.matches(i64Zero));
  assert(anyi64.matches(i64One));
  assert(!anyi64.matches(f64Zero));
  assert(!anyi64.matches(f64One));

  auto onei64 = Internal::I64Lit(nullptr, Internal::Exact<int64_t>(nullptr, 1));
  assert(!onei64.matches(i32Zero));
  assert(!onei64.matches(i32One));
  assert(!onei64.matches(f32Zero));
  assert(!onei64.matches(f32One));
  assert(!onei64.matches(i64Zero));
  assert(onei64.matches(i64One));
  assert(!onei64.matches(f64Zero));
  assert(!onei64.matches(f64One));

  auto anyint = Internal::IntLit(nullptr, Internal::Any<int64_t>(nullptr));
  assert(anyint.matches(i32Zero));
  assert(anyint.matches(i32One));
  assert(!anyint.matches(f32Zero));
  assert(!anyint.matches(f32One));
  assert(anyint.matches(i64Zero));
  assert(anyint.matches(i64One));
  assert(!anyint.matches(f64Zero));
  assert(!anyint.matches(f64One));

  auto oneint = Internal::IntLit(nullptr, Internal::Exact<int64_t>(nullptr, 1));
  assert(!oneint.matches(i32Zero));
  assert(oneint.matches(i32One));
  assert(!oneint.matches(f32Zero));
  assert(!oneint.matches(f32One));
  assert(!oneint.matches(i64Zero));
  assert(oneint.matches(i64One));
  assert(!oneint.matches(f64Zero));
  assert(!oneint.matches(f64One));

  auto anyf32 = Internal::F32Lit(nullptr, Internal::Any<float>(nullptr));
  assert(!anyf32.matches(i32Zero));
  assert(!anyf32.matches(i32One));
  assert(anyf32.matches(f32Zero));
  assert(anyf32.matches(f32One));
  assert(!anyf32.matches(i64Zero));
  assert(!anyf32.matches(i64One));
  assert(!anyf32.matches(f64Zero));
  assert(!anyf32.matches(f64One));

  auto onef32 = Internal::F32Lit(nullptr, Internal::Exact<float>(nullptr, 1));
  assert(!onef32.matches(i32Zero));
  assert(!onef32.matches(i32One));
  assert(!onef32.matches(f32Zero));
  assert(onef32.matches(f32One));
  assert(!onef32.matches(i64Zero));
  assert(!onef32.matches(i64One));
  assert(!onef32.matches(f64Zero));
  assert(!onef32.matches(f64One));

  auto anyf64 = Internal::F64Lit(nullptr, Internal::Any<double>(nullptr));
  assert(!anyf64.matches(i32Zero));
  assert(!anyf64.matches(i32One));
  assert(!anyf64.matches(f32Zero));
  assert(!anyf64.matches(f32One));
  assert(!anyf64.matches(i64Zero));
  assert(!anyf64.matches(i64One));
  assert(anyf64.matches(f64Zero));
  assert(anyf64.matches(f64One));

  auto onef64 = Internal::F64Lit(nullptr, Internal::Exact<double>(nullptr, 1));
  assert(!onef64.matches(i32Zero));
  assert(!onef64.matches(i32One));
  assert(!onef64.matches(f32Zero));
  assert(!onef64.matches(f32One));
  assert(!onef64.matches(i64Zero));
  assert(!onef64.matches(i64One));
  assert(!onef64.matches(f64Zero));
  assert(onef64.matches(f64One));

  auto anyfp = Internal::FloatLit(nullptr, Internal::Any<double>(nullptr));
  assert(!anyfp.matches(i32Zero));
  assert(!anyfp.matches(i32One));
  assert(anyfp.matches(f32Zero));
  assert(anyfp.matches(f32One));
  assert(!anyfp.matches(i64Zero));
  assert(!anyfp.matches(i64One));
  assert(anyfp.matches(f64Zero));
  assert(anyfp.matches(f64One));

  auto onefp = Internal::FloatLit(nullptr, Internal::Exact<double>(nullptr, 1));
  assert(!onefp.matches(i32Zero));
  assert(!onefp.matches(i32One));
  assert(!onefp.matches(f32Zero));
  assert(onefp.matches(f32One));
  assert(!onefp.matches(i64Zero));
  assert(!onefp.matches(i64One));
  assert(!onefp.matches(f64Zero));
  assert(onefp.matches(f64One));

  auto number = Internal::NumberLit(nullptr, 1);
  assert(!number.matches(i32Zero));
  assert(number.matches(i32One));
  assert(!number.matches(f32Zero));
  assert(number.matches(f32One));
  assert(!number.matches(i64Zero));
  assert(number.matches(i64One));
  assert(!number.matches(f64Zero));
  assert(number.matches(f64One));

  int64_t x = 0;
  Literal xLit;
  Literal imatched(int32_t(42));
  assert(Internal::IntLit(&xLit, Internal::Any(&x)).matches(imatched));
  assert(xLit == imatched);
  assert(x == 42);

  double f = 0;
  Literal fLit;
  Literal fmatched(double(42));
  assert(Internal::FloatLit(&fLit, Internal::Any(&f)).matches(fmatched));
  assert(fLit == fmatched);
  assert(f == 42.0);

  Literal numLit;
  Literal numMatched(1.0f);
  assert(Internal::NumberLit(&numLit, 1).matches(numMatched));
  assert(numLit == numMatched);
}

void test_internal_const() {
  std::cout << "Testing Internal::ConstantMatcher\n";

  Const* c = builder.makeConst(Literal(int32_t(42)));
  Expression* constExpr = builder.makeConst(Literal(int32_t(43)));
  Expression* nop = builder.makeNop();

  Const* extractedConst = nullptr;
  Literal extractedLit;
  int32_t extractedInt = 0;

  auto matcher = Internal::ConstMatcher(
    &extractedConst,
    Internal::I32Lit(&extractedLit, Internal::Any(&extractedInt)));

  assert(matcher.matches(c));
  assert(extractedConst == c);
  assert(extractedLit == Literal(int32_t(42)));
  assert(extractedInt == 42);

  assert(matcher.matches(constExpr));
  assert(extractedConst == constExpr);
  assert(extractedLit == Literal(int32_t(43)));
  assert(extractedInt == 43);

  assert(!matcher.matches(nop));
}

void test_internal_unary() {
  Expression* eqz32 =
    builder.makeUnary(EqZInt32, builder.makeConst(Literal(int32_t(0))));
  Expression* eqz64 =
    builder.makeUnary(EqZInt64, builder.makeConst(Literal(int64_t(0))));
  Expression* clz =
    builder.makeUnary(ClzInt32, builder.makeConst(Literal(int32_t(0))));
  Expression* nop = builder.makeNop();

  std::cout << "Testing Internal::UnaryMatcher\n";

  Unary* out = nullptr;
  UnaryOp op;

  auto unMatcher = Internal::UnaryMatcher(
    &out, Internal::Any<UnaryOp>(&op), Internal::Any<Expression*>(nullptr));
  assert(unMatcher.matches(eqz32));
  assert(out == eqz32);
  assert(op == EqZInt32);
  assert(unMatcher.matches(eqz64));
  assert(out == eqz64);
  assert(op == EqZInt64);
  assert(unMatcher.matches(clz));
  assert(out == clz);
  assert(op == ClzInt32);
  assert(!unMatcher.matches(nop));

  assert(matches(clz, unary(any())));
  assert(matches(eqz64, unary(&out, any())));
  assert(out == eqz64);
  assert(matches(eqz32, unary(&op, any())));
  assert(op == EqZInt32);

  std::cout << "Testing Internal::UnaryOpMatcher\n";

  out = nullptr;

  auto eqz32Matcher = Internal::UnaryOpMatcher(
    &out, EqZInt32, Internal::Any<Expression*>(nullptr));
  assert(eqz32Matcher.matches(eqz32));
  assert(out == eqz32);
  assert(!eqz32Matcher.matches(eqz64));
  assert(!eqz32Matcher.matches(clz));
  assert(!eqz32Matcher.matches(nop));

  std::cout << "Testing Internal::AbstractUnaryOpMatcher\n";

  out = nullptr;

  auto eqzMatcher = Internal::AbstractUnaryOpMatcher(
    &out, Abstract::EqZ, Internal::Any<Expression*>(nullptr));
  assert(eqzMatcher.matches(eqz32));
  assert(out == eqz32);
  assert(eqzMatcher.matches(eqz64));
  assert(out == eqz64);
  assert(!eqzMatcher.matches(clz));
  assert(!eqzMatcher.matches(nop));
}

void test_internal_binary() {
  Expression* eq32 = builder.makeBinary(EqInt32,
                                        builder.makeConst(Literal(int32_t(0))),
                                        builder.makeConst(Literal(int32_t(0))));
  Expression* eq64 = builder.makeBinary(EqInt64,
                                        builder.makeConst(Literal(int64_t(0))),
                                        builder.makeConst(Literal(int64_t(0))));
  Expression* add = builder.makeBinary(AddInt32,
                                       builder.makeConst(Literal(int32_t(0))),
                                       builder.makeConst(Literal(int32_t(0))));
  Expression* nop = builder.makeNop();

  std::cout << "Testing Internal::BinaryMatcher\n";

  Binary* out = nullptr;
  BinaryOp op;

  auto binMatcher =
    Internal::BinaryMatcher(&out,
                            Internal::Any<BinaryOp>(&op),
                            Internal::Any<Expression*>(nullptr),
                            Internal::Any<Expression*>(nullptr));
  assert(binMatcher.matches(eq32));
  assert(out == eq32);
  assert(op == EqInt32);
  assert(binMatcher.matches(eq64));
  assert(out == eq64);
  assert(op == EqInt64);
  assert(binMatcher.matches(add));
  assert(out == add);
  assert(op == AddInt32);
  assert(!binMatcher.matches(nop));

  assert(matches(add, binary(any(), any())));
  assert(matches(eq64, binary(&out, any(), any())));
  assert(out == eq64);
  assert(matches(eq32, binary(&op, any(), any())));
  assert(op == EqInt32);

  std::cout << "Testing Internal::BinaryOpMatcher\n";

  out = nullptr;

  auto eq32Matcher =
    Internal::BinaryOpMatcher(&out,
                              EqInt32,
                              Internal::Any<Expression*>(nullptr),
                              Internal::Any<Expression*>(nullptr));
  assert(eq32Matcher.matches(eq32));
  assert(out == eq32);
  assert(!eq32Matcher.matches(eq64));
  assert(!eq32Matcher.matches(add));
  assert(!eq32Matcher.matches(nop));

  std::cout << "Testing Internal::AbstractBinaryOpMatcher\n";

  out = nullptr;

  auto eqMatcher =
    Internal::AbstractBinaryOpMatcher(&out,
                                      Abstract::Eq,
                                      Internal::Any<Expression*>(nullptr),
                                      Internal::Any<Expression*>(nullptr));
  assert(eqMatcher.matches(eq32));
  assert(out == eq32);
  assert(eqMatcher.matches(eq64));
  assert(out == eq64);
  assert(!eqMatcher.matches(add));
  assert(!eqMatcher.matches(nop));
}

void test_internal_select() {
  std::cout << "Testing Internal::SelectMatcher\n";

  auto zero = [&]() { return builder.makeConst(Literal(int32_t(0))); };
  auto one = [&]() { return builder.makeConst(Literal(int32_t(1))); };

  auto constMatcher = [](int32_t c) {
    return Internal::ConstMatcher(
      nullptr, Internal::I32Lit(nullptr, Internal::Exact<int32_t>(nullptr, c)));
  };

  // NB: `makeSelect` takes the condition first for some reason
  Expression* leftOne = builder.makeSelect(zero(), one(), zero());
  Expression* rightOne = builder.makeSelect(zero(), zero(), one());
  Expression* condOne = builder.makeSelect(one(), zero(), zero());

  Select* out = nullptr;

  auto zeroesMatcher = Internal::SelectMatcher(
    &out, constMatcher(0), constMatcher(0), constMatcher(0));
  assert(!zeroesMatcher.matches(leftOne));
  assert(!zeroesMatcher.matches(rightOne));
  assert(!zeroesMatcher.matches(condOne));

  auto leftMatcher = Internal::SelectMatcher(
    &out, constMatcher(1), constMatcher(0), constMatcher(0));
  assert(leftMatcher.matches(leftOne));
  assert(out == leftOne);
  assert(!leftMatcher.matches(rightOne));
  assert(!leftMatcher.matches(condOne));

  auto rightMatcher = Internal::SelectMatcher(
    &out, constMatcher(0), constMatcher(1), constMatcher(0));
  assert(!rightMatcher.matches(leftOne));
  assert(rightMatcher.matches(rightOne));
  assert(out == rightOne);
  assert(!rightMatcher.matches(condOne));

  auto condMatcher = Internal::SelectMatcher(
    &out, constMatcher(0), constMatcher(0), constMatcher(1));
  assert(!condMatcher.matches(leftOne));
  assert(!condMatcher.matches(rightOne));
  assert(condMatcher.matches(condOne));
  assert(out == condOne);
}

int main() {
  test_internal_any();
  test_internal_exact();
  test_internal_literal();
  test_internal_const();
  test_internal_unary();
  test_internal_binary();
  test_internal_select();
}
