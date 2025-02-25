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
