/*
 * Copyright 2025 WebAssembly Community Group participants
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

// TODO: Replace this test file with spec tests as soon as possible.

#include "interpreter/interpreter.h"
#include "literal.h"
#include "wasm-ir-builder.h"
#include "wasm.h"

#include "gtest/gtest.h"

using namespace wasm;

// Int32

TEST(InterpreterTest, AddI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(AddInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(3))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, SubI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(SubInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(-1))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, MulI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(MulInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(2))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, EqI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(EqInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, AndI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(AndInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, OrI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(4))).getErr());
  ASSERT_FALSE(builder.makeBinary(OrInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(6))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, XorI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(3))).getErr());
  ASSERT_FALSE(builder.makeBinary(XorInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(2))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, ShlI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(3))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(4))).getErr());
  ASSERT_FALSE(builder.makeBinary(ShlInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(48))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, RotLI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(4))).getErr());
  ASSERT_FALSE(builder.makeBinary(RotLInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(16))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, RotRI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(3))).getErr());
  ASSERT_FALSE(builder.makeBinary(RotRInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(1073741824))};

  EXPECT_EQ(results, expected);
}

// uInt32

TEST(InterpreterTest, LtUI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(LtUInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(1))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, GtUI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(GtUInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, ShrUI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(ShrUInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

// sInt32

TEST(InterpreterTest, LtSI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(int32_t(-1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(int32_t(-2))).getErr());
  ASSERT_FALSE(builder.makeBinary(LtSInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(int32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, GtSI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(int32_t(-3))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(int32_t(-4))).getErr());
  ASSERT_FALSE(builder.makeBinary(GtSInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(int32_t(1))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, ShrSI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(ShrSInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

// Int64

TEST(InterpreterTest, AddI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(AddInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(3))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, SubI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(SubInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(-1))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, MulI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(MulInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(2))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, EqI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(EqInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, AndI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(AndInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, OrI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(OrInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(3))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, XorI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(XorInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(3))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, ShlI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(ShlInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(4))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, RotLI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(RotLInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(4))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, RotRI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(RotRInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(4611686018427387904))};

  EXPECT_EQ(results, expected);
}

// uInt64

TEST(InterpreterTest, LtUI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(LtSInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(1))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, GtUI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(GtSInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, ShrUI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(ShrUInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(0))};

  EXPECT_EQ(results, expected);
}

// sInt64

TEST(InterpreterTest, LtSI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(int64_t(-1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(int64_t(-2))).getErr());
  ASSERT_FALSE(builder.makeBinary(LtSInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(int32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, GtSI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(int64_t(-3))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(int64_t(-4))).getErr());
  ASSERT_FALSE(builder.makeBinary(GtSInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(int32_t(1))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, ShrSI64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint64_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(ShrSInt64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint64_t(0))};

  EXPECT_EQ(results, expected);
}

// Float32

TEST(InterpreterTest, AddF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(0.0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(float(1.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(AddFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(1.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, SubF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(1.0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(float(2.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(SubFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(-1.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, MulF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(1.5))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(float(2.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(MulFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(3.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, DivF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(5.0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(float(2.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(DivFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(2.5))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, EqF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(1.0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(float(2.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(EqFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, SqrtF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(5.0))).getErr());
  ASSERT_FALSE(builder.makeUnary(SqrtFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(2.2360679775))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, CeilF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(1.5))).getErr());
  ASSERT_FALSE(builder.makeUnary(CeilFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(2.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, FloorF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(1.5))).getErr());
  ASSERT_FALSE(builder.makeUnary(FloorFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(1.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, TruncF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(2.017281))).getErr());
  ASSERT_FALSE(builder.makeUnary(TruncFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(2.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, NearF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(2.5))).getErr());
  ASSERT_FALSE(builder.makeUnary(NearestFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(float(2.0))};

  EXPECT_EQ(results, expected);
}

// Float 64

TEST(InterpreterTest, AddF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(0.0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(double(1.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(AddFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(1.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, SubF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(1.0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(double(2.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(SubFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(-1.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, MulF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(1.5))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(double(2.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(MulFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(3.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, DivF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(5.0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(double(2.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(DivFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(2.5))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, EqF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(1.0))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(double(2.0))).getErr());
  ASSERT_FALSE(builder.makeBinary(EqFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(uint32_t(0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, SqrtF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(5.0))).getErr());
  ASSERT_FALSE(builder.makeUnary(SqrtFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(2.23606797749979))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, CeilF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(1.5))).getErr());
  ASSERT_FALSE(builder.makeUnary(CeilFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(2.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, FloorF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(1.5))).getErr());
  ASSERT_FALSE(builder.makeUnary(FloorFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(1.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, TruncF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(2.017281))).getErr());
  ASSERT_FALSE(builder.makeUnary(TruncFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(2.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, NearF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(2.5))).getErr());
  ASSERT_FALSE(builder.makeUnary(NearestFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.runTest(*expr);
  std::vector<Literal> expected{Literal(double(2.0))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, GlobalI32) {
  auto wasm = std::make_shared<Module>();
  Builder builder(*wasm);
  IRBuilder irBuilder(*wasm);
  wasm->addGlobal(
    builder.makeGlobal("global",
                       Type::i32,
                       builder.makeConst(Literal::makeZero(Type::i32)),
                       Builder::Mutable));

  ASSERT_FALSE(
    irBuilder.makeBlock(Name{}, Signature(Type::none, Type::i32)).getErr());
  ASSERT_FALSE(irBuilder.makeConst(Literal(int32_t(5))).getErr());
  ASSERT_FALSE(irBuilder.makeGlobalSet("global").getErr());
  ASSERT_FALSE(irBuilder.makeGlobalGet("global").getErr());
  ASSERT_FALSE(irBuilder.visitEnd().getErr());

  auto expr = irBuilder.build();
  ASSERT_FALSE(expr.getErr());

  Interpreter interpreter;
  auto result = interpreter.addInstance(wasm);
  auto results = interpreter.runTest(*expr);
  std::vector<Literal> expected{Literal(int32_t(5))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, GlobalInitI32) {
  auto wasm = std::make_shared<Module>();
  Builder builder(*wasm);
  IRBuilder irBuilder(*wasm);
  wasm->addGlobal(builder.makeGlobal(
    "global",
    Type::i32,
    builder.makeBinary(
      AddInt32, builder.makeConst(int32_t(2)), builder.makeConst(int32_t(3))),
    Builder::Mutable));

  ASSERT_FALSE(
    irBuilder.makeBlock(Name{}, Signature(Type::none, Type::i32)).getErr());
  ASSERT_FALSE(irBuilder.makeGlobalGet("global").getErr());
  ASSERT_FALSE(irBuilder.visitEnd().getErr());

  auto expr = irBuilder.build();
  ASSERT_FALSE(expr.getErr());

  Interpreter interpreter;
  auto result = interpreter.addInstance(wasm);
  auto results = interpreter.runTest(*expr);
  std::vector<Literal> expected{Literal(int32_t(5))};

  EXPECT_EQ(results, expected);
}
