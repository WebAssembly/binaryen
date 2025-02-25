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

// uInt32
TEST(InterpreterTest, AddI32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(1))).getErr());
  ASSERT_FALSE(builder.makeConst(Literal(uint32_t(2))).getErr());
  ASSERT_FALSE(builder.makeBinary(AddInt32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
  std::vector<Literal> expected{Literal(uint32_t(2))};

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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
  std::vector<Literal> expected{Literal(float(2.5))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, SqrtF32) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(float(5.0))).getErr());
  ASSERT_FALSE(builder.makeUnary(SqrtFloat32).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
  std::vector<Literal> expected{Literal(double(2.5))};

  EXPECT_EQ(results, expected);
}

TEST(InterpreterTest, SqrtF64) {
  Module wasm;
  IRBuilder builder(wasm);

  ASSERT_FALSE(builder.makeConst(Literal(double(5.0))).getErr());
  ASSERT_FALSE(builder.makeUnary(SqrtFloat64).getErr());

  auto expr = builder.build();
  ASSERT_FALSE(expr.getErr());

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
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

  auto results = Interpreter{}.run(*expr);
  std::vector<Literal> expected{Literal(double(2.0))};

  EXPECT_EQ(results, expected);
}
