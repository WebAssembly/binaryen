/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include <cmath>

#include "parser/lexer.h"
#include "gtest/gtest.h"

using namespace wasm::WATParser;
using namespace std::string_view_literals;

TEST(LexerTest, LexWhitespace) {
  Lexer lexer(" 1\t2\n3\r4 \n\n\t 5 "sv);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{1, 1}));
  EXPECT_EQ(lexer.takeI32(), 1);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{1, 3}));
  EXPECT_EQ(lexer.takeI32(), 2);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{2, 0}));
  EXPECT_EQ(lexer.takeI32(), 3);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{2, 2}));
  EXPECT_EQ(lexer.takeI32(), 4);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{4, 2}));
  EXPECT_EQ(lexer.takeI32(), 5);

  ASSERT_TRUE(lexer.empty());
}

TEST(LexerTest, LexLineComment) {
  Lexer lexer("1;; whee! 2 3\t4\r5\n6"sv);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{1, 0}));
  EXPECT_EQ(lexer.takeI32(), 1);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{2, 0}));
  EXPECT_EQ(lexer.takeI32(), 6);

  EXPECT_TRUE(lexer.empty());
}

TEST(LexerTest, LexBlockComment) {
  Lexer lexer("1(; whoo! 2\n (; \n3\n ;) 4 (;) 5 ;) \n;)6"sv);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{1, 0}));
  EXPECT_EQ(lexer.takeI32(), 1);

  ASSERT_FALSE(lexer.empty());
  EXPECT_EQ(lexer.position(), (TextPos{5, 2}));
  EXPECT_EQ(lexer.takeI32(), 6);

  EXPECT_TRUE(lexer.empty());
}

TEST(LexerTest, LexParens) {
  Lexer lexer("(())"sv);

  ASSERT_FALSE(lexer.empty());
  EXPECT_TRUE(lexer.takeLParen());

  ASSERT_FALSE(lexer.empty());
  EXPECT_TRUE(lexer.takeLParen());

  ASSERT_FALSE(lexer.empty());
  EXPECT_TRUE(lexer.takeRParen());

  ASSERT_FALSE(lexer.empty());
  EXPECT_TRUE(lexer.takeRParen());

  EXPECT_TRUE(lexer.empty());
}

TEST(LexerTest, LexInt) {
  EXPECT_EQ(Lexer("0"sv).takeU8(), uint8_t(0));
  EXPECT_EQ(Lexer("0"sv).takeI8(), uint8_t(0));
  EXPECT_EQ(Lexer("0"sv).takeI16(), uint16_t(0));
  EXPECT_EQ(Lexer("0"sv).takeU32(), uint32_t(0));
  EXPECT_EQ(Lexer("0"sv).takeI32(), uint32_t(0));
  EXPECT_EQ(Lexer("0"sv).takeU64(), uint64_t(0));
  EXPECT_EQ(Lexer("0"sv).takeI64(), uint64_t(0));

  EXPECT_FALSE(Lexer("+0"sv).takeU8());
  EXPECT_EQ(Lexer("+0"sv).takeI8(), uint8_t(0));

  EXPECT_FALSE(Lexer("-0"sv).takeU8());
  EXPECT_EQ(Lexer("-0"sv).takeI8(), uint8_t(0));

  EXPECT_EQ(Lexer("1"sv).takeU8(), uint8_t(1));
  EXPECT_EQ(Lexer("1"sv).takeI8(), uint8_t(1));

  EXPECT_FALSE(Lexer("+1"sv).takeU8());
  EXPECT_EQ(Lexer("+1"sv).takeI8(), uint8_t(1));

  EXPECT_FALSE(Lexer("-1"sv).takeU8());
  EXPECT_EQ(Lexer("-1").takeI8(), uint8_t(-1));

  EXPECT_EQ(Lexer("0010"sv).takeU8(), uint8_t(10));
  EXPECT_EQ(Lexer("0010"sv).takeI8(), uint8_t(10));

  EXPECT_FALSE(Lexer("+0010"sv).takeU8());
  EXPECT_EQ(Lexer("+0010"sv).takeI8(), uint8_t(10));

  EXPECT_FALSE(Lexer("-0010"sv).takeU8());
  EXPECT_EQ(Lexer("-0010"sv).takeI8(), uint8_t(-10));

  EXPECT_FALSE(Lexer("9999"sv).takeU8());
  EXPECT_EQ(Lexer("9999"sv).takeI16(), uint16_t(9999));
  EXPECT_EQ(Lexer("9999"sv).takeU32(), uint32_t(9999));
  EXPECT_EQ(Lexer("9999"sv).takeI32(), uint32_t(9999));

  EXPECT_FALSE(Lexer("+9999"sv).takeU32());
  EXPECT_EQ(Lexer("+9999"sv).takeI32(), uint32_t(9999));

  EXPECT_FALSE(Lexer("-9999"sv).takeU32());
  EXPECT_EQ(Lexer("-9999"sv).takeI32(), uint32_t(-9999));

  EXPECT_EQ(Lexer("12_34"sv).takeU32(), uint32_t(1234));
  EXPECT_EQ(Lexer("12_34"sv).takeI32(), uint32_t(1234));

  EXPECT_EQ(Lexer("1_2_3_4"sv).takeU32(), uint32_t(1234));
  EXPECT_EQ(Lexer("1_2_3_4"sv).takeI32(), uint32_t(1234));

  EXPECT_FALSE(Lexer("_1234"sv).takeU32());
  EXPECT_FALSE(Lexer("_1234"sv).takeI32());

  EXPECT_FALSE(Lexer("1234_"sv).takeU32());
  EXPECT_FALSE(Lexer("1234_"sv).takeI32());

  EXPECT_FALSE(Lexer("12__34"sv).takeU32());
  EXPECT_FALSE(Lexer("12__34"sv).takeI32());

  EXPECT_FALSE(Lexer("12cd56"sv).takeU32());
  EXPECT_FALSE(Lexer("12cd56"sv).takeI32());

  EXPECT_EQ(Lexer("18446744073709551615"sv).takeU64(), uint64_t(-1));
  EXPECT_EQ(Lexer("18446744073709551615"sv).takeI64(), uint64_t(-1));

  // 64-bit overflow!
  EXPECT_FALSE(Lexer("18446744073709551616"sv).takeU64());
  EXPECT_FALSE(Lexer("18446744073709551616"sv).takeI64());

  EXPECT_FALSE(Lexer("+9223372036854775807"sv).takeU64());
  EXPECT_EQ(Lexer("+9223372036854775807"sv).takeI64(), INT64_MAX);

  EXPECT_EQ(Lexer("9223372036854775808"sv).takeU64(), uint64_t(INT64_MAX) + 1);
  EXPECT_EQ(Lexer("9223372036854775808"sv).takeI64(), uint64_t(INT64_MAX) + 1);

  EXPECT_FALSE(Lexer("+9223372036854775808"sv).takeU64());
  EXPECT_FALSE(Lexer("+9223372036854775808"sv).takeI64());

  EXPECT_FALSE(Lexer("-9223372036854775808"sv).takeU64());
  EXPECT_EQ(Lexer("-9223372036854775808"sv).takeI64(), uint64_t(INT64_MIN));

  EXPECT_FALSE(Lexer("-9223372036854775809"sv).takeU64());
  EXPECT_FALSE(Lexer("-9223372036854775809"sv).takeI64());
}

TEST(LexerTest, LexHexInt) {
  EXPECT_EQ(Lexer("0x0"sv).takeU8(), uint8_t(0));
  EXPECT_EQ(Lexer("0x0"sv).takeI8(), uint8_t(0));
  EXPECT_EQ(Lexer("0x0"sv).takeI16(), uint16_t(0));
  EXPECT_EQ(Lexer("0x0"sv).takeU32(), uint32_t(0));
  EXPECT_EQ(Lexer("0x0"sv).takeI32(), uint32_t(0));
  EXPECT_EQ(Lexer("0x0"sv).takeU64(), uint64_t(0));
  EXPECT_EQ(Lexer("0x0"sv).takeI64(), uint64_t(0));

  EXPECT_FALSE(Lexer("+0x0"sv).takeU8());
  EXPECT_EQ(Lexer("+0x0"sv).takeI8(), uint8_t(0));

  EXPECT_FALSE(Lexer("-0x0"sv).takeU8());
  EXPECT_EQ(Lexer("-0x0"sv).takeI8(), uint8_t(0));

  EXPECT_EQ(Lexer("0x1"sv).takeU8(), uint8_t(1));
  EXPECT_EQ(Lexer("0x1"sv).takeI8(), uint8_t(1));

  EXPECT_FALSE(Lexer("+0x1"sv).takeU8());
  EXPECT_EQ(Lexer("+0x1"sv).takeI8(), uint8_t(1));

  EXPECT_FALSE(Lexer("-0x1"sv).takeU8());
  EXPECT_EQ(Lexer("-0x1").takeI8(), uint8_t(-1));

  EXPECT_EQ(Lexer("0x0010"sv).takeU8(), uint8_t(16));
  EXPECT_EQ(Lexer("0x0010"sv).takeI8(), uint8_t(16));

  EXPECT_FALSE(Lexer("+0x0010"sv).takeU8());
  EXPECT_EQ(Lexer("+0x0010"sv).takeI8(), uint8_t(16));

  EXPECT_FALSE(Lexer("-0x0010"sv).takeU8());
  EXPECT_EQ(Lexer("-0x0010"sv).takeI8(), uint8_t(-16));

  EXPECT_FALSE(Lexer("0xabcdef"sv).takeU8());
  EXPECT_EQ(Lexer("0xabcdef"sv).takeU32(), uint32_t(0xabcdef));
  EXPECT_EQ(Lexer("0xabcdef"sv).takeI32(), uint32_t(0xabcdef));

  EXPECT_FALSE(Lexer("+0xABCDEF"sv).takeU32());
  EXPECT_EQ(Lexer("+0xABCDEF"sv).takeI32(), uint32_t(0xabcdef));

  EXPECT_FALSE(Lexer("-0xAbCdEf"sv).takeU32());
  EXPECT_EQ(Lexer("-0xAbCdEf"sv).takeI32(), uint32_t(-0xabcdef));

  EXPECT_EQ(Lexer("0x12_34"sv).takeU32(), uint32_t(0x1234));
  EXPECT_EQ(Lexer("0x12_34"sv).takeI32(), uint32_t(0x1234));

  EXPECT_EQ(Lexer("0x1_2_3_4"sv).takeU32(), uint32_t(0x1234));
  EXPECT_EQ(Lexer("0x1_2_3_4"sv).takeI32(), uint32_t(0x1234));

  EXPECT_FALSE(Lexer("_0x1234"sv).takeU32());
  EXPECT_FALSE(Lexer("_0x1234"sv).takeI32());

  EXPECT_FALSE(Lexer("0x_1234"sv).takeU32());
  EXPECT_FALSE(Lexer("0x_1234"sv).takeI32());

  EXPECT_FALSE(Lexer("0x1234_"sv).takeU32());
  EXPECT_FALSE(Lexer("0x1234_"sv).takeI32());

  EXPECT_FALSE(Lexer("0x12__34"sv).takeU32());
  EXPECT_FALSE(Lexer("0x12__34"sv).takeI32());

  EXPECT_FALSE(Lexer("0xg"sv).takeU32());
  EXPECT_FALSE(Lexer("0xg"sv).takeI32());

  EXPECT_FALSE(Lexer("0x120x34"sv).takeU32());
  EXPECT_FALSE(Lexer("0x120x34"sv).takeI32());
}

TEST(LexerTest, ClassifyInt) {
  ASSERT_FALSE(Lexer("0"sv).empty());
  ASSERT_TRUE(Lexer("0"sv).takeU64());
  ASSERT_TRUE(Lexer("0"sv).takeI64());
  ASSERT_TRUE(Lexer("0"sv).takeU32());
  ASSERT_TRUE(Lexer("0"sv).takeI32());
  ASSERT_TRUE(Lexer("0"sv).takeF64());
  ASSERT_TRUE(Lexer("0"sv).takeF32());
  EXPECT_EQ(*Lexer("0"sv).takeU64(), 0ull);
  EXPECT_EQ(*Lexer("0"sv).takeI64(), 0ull);
  EXPECT_EQ(*Lexer("0"sv).takeU32(), 0u);
  EXPECT_EQ(*Lexer("0"sv).takeI32(), 0u);
  EXPECT_EQ(*Lexer("0"sv).takeF64(), 0.0);
  EXPECT_EQ(*Lexer("0"sv).takeF32(), 0.0);
  EXPECT_FALSE(std::signbit(*Lexer("0"sv).takeF64()));
  EXPECT_FALSE(std::signbit(*Lexer("0"sv).takeF32()));

  ASSERT_FALSE(Lexer("+0"sv).empty());
  EXPECT_FALSE(Lexer("+0"sv).takeU64());
  ASSERT_TRUE(Lexer("+0"sv).takeI64());
  EXPECT_FALSE(Lexer("+0"sv).takeU32());
  ASSERT_TRUE(Lexer("+0"sv).takeI32());
  ASSERT_TRUE(Lexer("+0"sv).takeF64());
  ASSERT_TRUE(Lexer("+0"sv).takeF32());
  EXPECT_EQ(*Lexer("+0"sv).takeI64(), 0ull);
  EXPECT_EQ(*Lexer("+0"sv).takeI32(), 0u);
  EXPECT_EQ(*Lexer("+0"sv).takeF64(), 0.0);
  EXPECT_EQ(*Lexer("+0"sv).takeF32(), 0.0);
  EXPECT_FALSE(std::signbit(*Lexer("+0"sv).takeF64()));
  EXPECT_FALSE(std::signbit(*Lexer("+0"sv).takeF32()));

  ASSERT_FALSE(Lexer("-0"sv).empty());
  EXPECT_FALSE(Lexer("-0"sv).takeU64());
  ASSERT_TRUE(Lexer("-0"sv).takeI64());
  EXPECT_FALSE(Lexer("-0"sv).takeU32());
  ASSERT_TRUE(Lexer("-0"sv).takeI32());
  ASSERT_TRUE(Lexer("-0"sv).takeF64());
  ASSERT_TRUE(Lexer("-0"sv).takeF32());
  EXPECT_EQ(*Lexer("-0"sv).takeI64(), 0ull);
  EXPECT_EQ(*Lexer("-0"sv).takeI32(), 0u);
  EXPECT_EQ(*Lexer("-0"sv).takeF64(), -0.0);
  EXPECT_EQ(*Lexer("-0"sv).takeF32(), -0.0);
  ASSERT_TRUE(std::signbit(*Lexer("-0"sv).takeF64()));
  ASSERT_TRUE(std::signbit(*Lexer("-0"sv).takeF32()));

  ASSERT_FALSE(Lexer("0x7fff_ffff"sv).empty());
  ASSERT_TRUE(Lexer("0x7fff_ffff"sv).takeU64());
  ASSERT_TRUE(Lexer("0x7fff_ffff"sv).takeI64());
  ASSERT_TRUE(Lexer("0x7fff_ffff"sv).takeU32());
  ASSERT_TRUE(Lexer("0x7fff_ffff"sv).takeI32());
  ASSERT_TRUE(Lexer("0x7fff_ffff"sv).takeF64());
  ASSERT_TRUE(Lexer("0x7fff_ffff"sv).takeF32());
  EXPECT_EQ(*Lexer("0x7fff_ffff"sv).takeU64(), 0x7fffffffull);
  EXPECT_EQ(*Lexer("0x7fff_ffff"sv).takeI64(), 0x7fffffffull);
  EXPECT_EQ(*Lexer("0x7fff_ffff"sv).takeU32(), 0x7fffffffu);
  EXPECT_EQ(*Lexer("0x7fff_ffff"sv).takeI32(), 0x7fffffffu);
  EXPECT_EQ(*Lexer("0x7fff_ffff"sv).takeF64(), 0x7fffffff.p0);
  EXPECT_EQ(*Lexer("0x7fff_ffff"sv).takeF32(), 0x7fffffff.p0f);

  ASSERT_FALSE(Lexer("0x8000_0000"sv).empty());
  ASSERT_TRUE(Lexer("0x8000_0000"sv).takeU64());
  ASSERT_TRUE(Lexer("0x8000_0000"sv).takeI64());
  ASSERT_TRUE(Lexer("0x8000_0000"sv).takeU32());
  ASSERT_TRUE(Lexer("0x8000_0000"sv).takeI32());
  ASSERT_TRUE(Lexer("0x8000_0000"sv).takeF64());
  ASSERT_TRUE(Lexer("0x8000_0000"sv).takeF32());
  EXPECT_EQ(*Lexer("0x8000_0000"sv).takeU64(), 0x80000000ull);
  EXPECT_EQ(*Lexer("0x8000_0000"sv).takeI64(), 0x80000000ull);
  EXPECT_EQ(*Lexer("0x8000_0000"sv).takeU32(), 0x80000000u);
  EXPECT_EQ(*Lexer("0x8000_0000"sv).takeI32(), 0x80000000u);
  EXPECT_EQ(*Lexer("0x8000_0000"sv).takeF64(), 0x80000000.p0);
  EXPECT_EQ(*Lexer("0x8000_0000"sv).takeF32(), 0x80000000.p0f);

  ASSERT_FALSE(Lexer("+0x7fff_ffff"sv).empty());
  EXPECT_FALSE(Lexer("+0x7fff_ffff"sv).takeU64());
  ASSERT_TRUE(Lexer("+0x7fff_ffff"sv).takeI64());
  EXPECT_FALSE(Lexer("+0x7fff_ffff"sv).takeU32());
  ASSERT_TRUE(Lexer("+0x7fff_ffff"sv).takeI32());
  ASSERT_TRUE(Lexer("+0x7fff_ffff"sv).takeF64());
  ASSERT_TRUE(Lexer("+0x7fff_ffff"sv).takeF32());
  EXPECT_EQ(*Lexer("+0x7fff_ffff"sv).takeI64(), 0x7fffffffull);
  EXPECT_EQ(*Lexer("+0x7fff_ffff"sv).takeI32(), 0x7fffffffu);
  EXPECT_EQ(*Lexer("+0x7fff_ffff"sv).takeF64(), 0x7fffffff.p0);
  EXPECT_EQ(*Lexer("+0x7fff_ffff"sv).takeF32(), 0x7fffffff.p0f);

  ASSERT_FALSE(Lexer("+0x8000_0000"sv).empty());
  EXPECT_FALSE(Lexer("+0x8000_0000"sv).takeU64());
  ASSERT_TRUE(Lexer("+0x8000_0000"sv).takeI64());
  EXPECT_FALSE(Lexer("+0x8000_0000"sv).takeU32());
  EXPECT_FALSE(Lexer("+0x8000_0000"sv).takeI32());
  ASSERT_TRUE(Lexer("+0x8000_0000"sv).takeF64());
  ASSERT_TRUE(Lexer("+0x8000_0000"sv).takeF32());
  EXPECT_EQ(*Lexer("+0x8000_0000"sv).takeI64(), 0x80000000ull);
  EXPECT_EQ(*Lexer("+0x8000_0000"sv).takeF64(), 0x80000000.p0);
  EXPECT_EQ(*Lexer("+0x8000_0000"sv).takeF32(), 0x80000000.p0f);

  ASSERT_FALSE(Lexer("-0x8000_0000"sv).empty());
  EXPECT_FALSE(Lexer("-0x8000_0000"sv).takeU64());
  ASSERT_TRUE(Lexer("-0x8000_0000"sv).takeI64());
  EXPECT_FALSE(Lexer("-0x8000_0000"sv).takeU32());
  ASSERT_TRUE(Lexer("-0x8000_0000"sv).takeI32());
  ASSERT_TRUE(Lexer("-0x8000_0000"sv).takeF64());
  ASSERT_TRUE(Lexer("-0x8000_0000"sv).takeF32());
  EXPECT_EQ(*Lexer("-0x8000_0000"sv).takeI64(), -0x80000000ull);
  EXPECT_EQ(*Lexer("-0x8000_0000"sv).takeI32(), -0x80000000u);
  EXPECT_EQ(*Lexer("-0x8000_0000"sv).takeF64(), -0x80000000.p0);
  EXPECT_EQ(*Lexer("-0x8000_0000"sv).takeF32(), -0x80000000.p0f);

  ASSERT_FALSE(Lexer("-0x8000_0001"sv).empty());
  EXPECT_FALSE(Lexer("-0x8000_0001"sv).takeU64());
  ASSERT_TRUE(Lexer("-0x8000_0001"sv).takeI64());
  EXPECT_FALSE(Lexer("-0x8000_0001"sv).takeU32());
  EXPECT_FALSE(Lexer("-0x8000_0001"sv).takeI32());
  ASSERT_TRUE(Lexer("-0x8000_0001"sv).takeF64());
  ASSERT_TRUE(Lexer("-0x8000_0001"sv).takeF32());
  EXPECT_EQ(*Lexer("-0x8000_0001"sv).takeI64(), -0x80000001ull);
  EXPECT_EQ(*Lexer("-0x8000_0001"sv).takeF64(), -0x80000001.p0);
  EXPECT_EQ(*Lexer("-0x8000_0001"sv).takeF32(), -0x80000001.p0f);

  ASSERT_FALSE(Lexer("0xffff_ffff"sv).empty());
  ASSERT_TRUE(Lexer("0xffff_ffff"sv).takeU64());
  ASSERT_TRUE(Lexer("0xffff_ffff"sv).takeI64());
  ASSERT_TRUE(Lexer("0xffff_ffff"sv).takeU32());
  ASSERT_TRUE(Lexer("0xffff_ffff"sv).takeI32());
  ASSERT_TRUE(Lexer("0xffff_ffff"sv).takeF64());
  ASSERT_TRUE(Lexer("0xffff_ffff"sv).takeF32());
  EXPECT_EQ(*Lexer("0xffff_ffff"sv).takeU64(), 0xffffffffull);
  EXPECT_EQ(*Lexer("0xffff_ffff"sv).takeI64(), 0xffffffffull);
  EXPECT_EQ(*Lexer("0xffff_ffff"sv).takeU32(), 0xffffffffu);
  EXPECT_EQ(*Lexer("0xffff_ffff"sv).takeI32(), 0xffffffffu);
  EXPECT_EQ(*Lexer("0xffff_ffff"sv).takeF64(), 0xffffffff.p0);
  EXPECT_EQ(*Lexer("0xffff_ffff"sv).takeF32(), 0xffffffff.p0f);

  ASSERT_FALSE(Lexer("0x1_0000_0000"sv).empty());
  ASSERT_TRUE(Lexer("0x1_0000_0000"sv).takeU64());
  ASSERT_TRUE(Lexer("0x1_0000_0000"sv).takeI64());
  EXPECT_FALSE(Lexer("0x1_0000_0000"sv).takeU32());
  EXPECT_FALSE(Lexer("0x1_0000_0000"sv).takeI32());
  ASSERT_TRUE(Lexer("0x1_0000_0000"sv).takeF64());
  ASSERT_TRUE(Lexer("0x1_0000_0000"sv).takeF32());
  EXPECT_EQ(*Lexer("0x1_0000_0000"sv).takeU64(), 0x100000000ull);
  EXPECT_EQ(*Lexer("0x1_0000_0000"sv).takeI64(), 0x100000000ull);
  EXPECT_EQ(*Lexer("0x1_0000_0000"sv).takeF64(), 0x100000000.p0);
  EXPECT_EQ(*Lexer("0x1_0000_0000"sv).takeF32(), 0x100000000.p0f);

  ASSERT_FALSE(Lexer("+0xffff_ffff"sv).empty());
  EXPECT_FALSE(Lexer("+0xffff_ffff"sv).takeU64());
  ASSERT_TRUE(Lexer("+0xffff_ffff"sv).takeI64());
  EXPECT_FALSE(Lexer("+0xffff_ffff"sv).takeU32());
  EXPECT_FALSE(Lexer("+0xffff_ffff"sv).takeI32());
  ASSERT_TRUE(Lexer("+0xffff_ffff"sv).takeF64());
  ASSERT_TRUE(Lexer("+0xffff_ffff"sv).takeF32());
  EXPECT_EQ(*Lexer("+0xffff_ffff"sv).takeI64(), 0xffffffffull);
  EXPECT_EQ(*Lexer("+0xffff_ffff"sv).takeF64(), 0xffffffff.p0);
  EXPECT_EQ(*Lexer("+0xffff_ffff"sv).takeF32(), 0xffffffff.p0f);

  ASSERT_FALSE(Lexer("+0x1_0000_0000"sv).empty());
  EXPECT_FALSE(Lexer("+0x1_0000_0000"sv).takeU64());
  ASSERT_TRUE(Lexer("+0x1_0000_0000"sv).takeI64());
  EXPECT_FALSE(Lexer("+0x1_0000_0000"sv).takeU32());
  EXPECT_FALSE(Lexer("+0x1_0000_0000"sv).takeI32());
  ASSERT_TRUE(Lexer("+0x1_0000_0000"sv).takeF64());
  ASSERT_TRUE(Lexer("+0x1_0000_0000"sv).takeF32());
  EXPECT_EQ(*Lexer("+0x1_0000_0000"sv).takeI64(), 0x100000000ull);
  EXPECT_EQ(*Lexer("+0x1_0000_0000"sv).takeF64(), 0x100000000.p0);
  EXPECT_EQ(*Lexer("+0x1_0000_0000"sv).takeF32(), 0x100000000.p0f);

  ASSERT_FALSE(Lexer("0x7fff_ffff_ffff_ffff"sv).empty());
  ASSERT_TRUE(Lexer("0x7fff_ffff_ffff_ffff"sv).takeU64());
  ASSERT_TRUE(Lexer("0x7fff_ffff_ffff_ffff"sv).takeI64());
  EXPECT_FALSE(Lexer("0x7fff_ffff_ffff_ffff"sv).takeU32());
  EXPECT_FALSE(Lexer("0x7fff_ffff_ffff_ffff"sv).takeI32());
  ASSERT_TRUE(Lexer("0x7fff_ffff_ffff_ffff"sv).takeF64());
  ASSERT_TRUE(Lexer("0x7fff_ffff_ffff_ffff"sv).takeF32());
  EXPECT_EQ(*Lexer("0x7fff_ffff_ffff_ffff"sv).takeU64(), 0x7fffffffffffffffull);
  EXPECT_EQ(*Lexer("0x7fff_ffff_ffff_ffff"sv).takeI64(), 0x7fffffffffffffffull);
  EXPECT_EQ(*Lexer("0x7fff_ffff_ffff_ffff"sv).takeF64(), 0x7fffffffffffffff.p0);
  EXPECT_EQ(*Lexer("0x7fff_ffff_ffff_ffff"sv).takeF32(),
            0x7fffffffffffffff.p0f);

  ASSERT_FALSE(Lexer("+0x7fff_ffff_ffff_ffff"sv).empty());
  EXPECT_FALSE(Lexer("+0x7fff_ffff_ffff_ffff"sv).takeU64());
  ASSERT_TRUE(Lexer("+0x7fff_ffff_ffff_ffff"sv).takeI64());
  EXPECT_FALSE(Lexer("+0x7fff_ffff_ffff_ffff"sv).takeU32());
  EXPECT_FALSE(Lexer("+0x7fff_ffff_ffff_ffff"sv).takeI32());
  ASSERT_TRUE(Lexer("+0x7fff_ffff_ffff_ffff"sv).takeF64());
  ASSERT_TRUE(Lexer("+0x7fff_ffff_ffff_ffff"sv).takeF32());
  EXPECT_EQ(*Lexer("+0x7fff_ffff_ffff_ffff"sv).takeI64(),
            0x7fffffffffffffffull);
  EXPECT_EQ(*Lexer("+0x7fff_ffff_ffff_ffff"sv).takeF64(),
            0x7fffffffffffffff.p0);
  EXPECT_EQ(*Lexer("+0x7fff_ffff_ffff_ffff"sv).takeF32(),
            0x7fffffffffffffff.p0f);

  ASSERT_FALSE(Lexer("-0x8000_0000_0000_0000"sv).empty());
  EXPECT_FALSE(Lexer("-0x8000_0000_0000_0000"sv).takeU64());
  ASSERT_TRUE(Lexer("-0x8000_0000_0000_0000"sv).takeI64());
  EXPECT_FALSE(Lexer("-0x8000_0000_0000_0000"sv).takeU32());
  EXPECT_FALSE(Lexer("-0x8000_0000_0000_0000"sv).takeI32());
  ASSERT_TRUE(Lexer("-0x8000_0000_0000_0000"sv).takeF64());
  ASSERT_TRUE(Lexer("-0x8000_0000_0000_0000"sv).takeF32());
  EXPECT_EQ(*Lexer("-0x8000_0000_0000_0000"sv).takeI64(),
            -0x8000000000000000ull);
  EXPECT_EQ(*Lexer("-0x8000_0000_0000_0000"sv).takeF64(),
            -0x8000000000000000.p0);
  EXPECT_EQ(*Lexer("-0x8000_0000_0000_0000"sv).takeF32(),
            -0x8000000000000000.p0f);

  ASSERT_FALSE(Lexer("0xffff_ffff_ffff_ffff"sv).empty());
  ASSERT_TRUE(Lexer("0xffff_ffff_ffff_ffff"sv).takeU64());
  ASSERT_TRUE(Lexer("0xffff_ffff_ffff_ffff"sv).takeI64());
  EXPECT_FALSE(Lexer("0xffff_ffff_ffff_ffff"sv).takeU32());
  EXPECT_FALSE(Lexer("0xffff_ffff_ffff_ffff"sv).takeI32());
  ASSERT_TRUE(Lexer("0xffff_ffff_ffff_ffff"sv).takeF64());
  ASSERT_TRUE(Lexer("0xffff_ffff_ffff_ffff"sv).takeF32());
  EXPECT_EQ(*Lexer("0xffff_ffff_ffff_ffff"sv).takeU64(), 0xffffffffffffffffull);
  EXPECT_EQ(*Lexer("0xffff_ffff_ffff_ffff"sv).takeI64(), 0xffffffffffffffffull);
  EXPECT_EQ(*Lexer("0xffff_ffff_ffff_ffff"sv).takeF64(), 0xffffffffffffffff.p0);
  EXPECT_EQ(*Lexer("0xffff_ffff_ffff_ffff"sv).takeF32(),
            0xffffffffffffffff.p0f);

  ASSERT_FALSE(Lexer("+0xffff_ffff_ffff_ffff"sv).empty());
  EXPECT_FALSE(Lexer("+0xffff_ffff_ffff_ffff"sv).takeU64());
  EXPECT_FALSE(Lexer("+0xffff_ffff_ffff_ffff"sv).takeI64());
  EXPECT_FALSE(Lexer("+0xffff_ffff_ffff_ffff"sv).takeU32());
  EXPECT_FALSE(Lexer("+0xffff_ffff_ffff_ffff"sv).takeI32());
  ASSERT_TRUE(Lexer("+0xffff_ffff_ffff_ffff"sv).takeF64());
  ASSERT_TRUE(Lexer("+0xffff_ffff_ffff_ffff"sv).takeF32());
  EXPECT_EQ(*Lexer("+0xffff_ffff_ffff_ffff"sv).takeF64(),
            0xffffffffffffffff.p0);
  EXPECT_EQ(*Lexer("+0xffff_ffff_ffff_ffff"sv).takeF32(),
            0xffffffffffffffff.p0f);
}

TEST(LexerTest, LexFloat) {
  EXPECT_EQ(Lexer("42"sv).takeF32(), 42.0f);
  EXPECT_EQ(Lexer("42"sv).takeF64(), 42.0);

  EXPECT_EQ(Lexer("42.5"sv).takeF32(), 42.5f);
  EXPECT_EQ(Lexer("42.5"sv).takeF64(), 42.5);

  EXPECT_EQ(Lexer("42e0"sv).takeF32(), 42e0f);
  EXPECT_EQ(Lexer("42e0"sv).takeF64(), 42e0);

  EXPECT_EQ(Lexer("42.e1"sv).takeF32(), 42.e1f);
  EXPECT_EQ(Lexer("42.e1"sv).takeF64(), 42.e1);

  EXPECT_EQ(Lexer("42E1"sv).takeF32(), 42E1f);
  EXPECT_EQ(Lexer("42E1"sv).takeF64(), 42E1);

  EXPECT_EQ(Lexer("42e+2"sv).takeF32(), 42e+2f);
  EXPECT_EQ(Lexer("42e+2"sv).takeF64(), 42e+2);

  EXPECT_EQ(Lexer("42.E-02"sv).takeF32(), 42.E-02f);
  EXPECT_EQ(Lexer("42.E-02"sv).takeF64(), 42.E-02);

  EXPECT_EQ(Lexer("42.0e0"sv).takeF32(), 42.0e0f);
  EXPECT_EQ(Lexer("42.0e0"sv).takeF64(), 42.0e0);

  EXPECT_EQ(Lexer("42.0E1"sv).takeF32(), 42.0E1f);
  EXPECT_EQ(Lexer("42.0E1"sv).takeF64(), 42.0E1);

  EXPECT_EQ(Lexer("42.0e+2"sv).takeF32(), 42.0e+2f);
  EXPECT_EQ(Lexer("42.0e+2"sv).takeF64(), 42.0e+2);

  EXPECT_EQ(Lexer("42.0E-2"sv).takeF32(), 42.0E-2f);
  EXPECT_EQ(Lexer("42.0E-2"sv).takeF64(), 42.0E-2);

  EXPECT_EQ(Lexer("+42.0e+2"sv).takeF32(), +42.0e+2f);
  EXPECT_EQ(Lexer("+42.0e+2"sv).takeF64(), +42.0e+2);

  EXPECT_EQ(Lexer("-42.0e+2"sv).takeF32(), -42.0e+2f);
  EXPECT_EQ(Lexer("-42.0e+2"sv).takeF64(), -42.0e+2);

  EXPECT_EQ(Lexer("4_2.0_0e+0_2"sv).takeF32(), 42.00e+02f);
  EXPECT_EQ(Lexer("4_2.0_0e+0_2"sv).takeF64(), 42.00e+02);

  EXPECT_FALSE(Lexer("+junk"sv).takeF32());
  EXPECT_FALSE(Lexer("+junk"sv).takeF64());

  EXPECT_FALSE(Lexer("42junk"sv).takeF32());
  EXPECT_FALSE(Lexer("42junk"sv).takeF64());

  EXPECT_FALSE(Lexer("42.junk"sv).takeF32());
  EXPECT_FALSE(Lexer("42.junk"sv).takeF64());

  EXPECT_FALSE(Lexer("42.0junk"sv).takeF32());
  EXPECT_FALSE(Lexer("42.0junk"sv).takeF64());

  EXPECT_FALSE(Lexer("42.Ejunk"sv).takeF32());
  EXPECT_FALSE(Lexer("42.Ejunk"sv).takeF64());

  EXPECT_FALSE(Lexer("42.e-junk"sv).takeF32());
  EXPECT_FALSE(Lexer("42.e-junk"sv).takeF64());

  EXPECT_FALSE(Lexer("42.e-10junk"sv).takeF32());
  EXPECT_FALSE(Lexer("42.e-10junk"sv).takeF64());

  EXPECT_FALSE(Lexer("+"sv).takeF32());
  EXPECT_FALSE(Lexer("+"sv).takeF64());

  EXPECT_FALSE(Lexer("42e"sv).takeF32());
  EXPECT_FALSE(Lexer("42e"sv).takeF64());

  EXPECT_FALSE(Lexer("42eABC"sv).takeF32());
  EXPECT_FALSE(Lexer("42eABC"sv).takeF64());

  EXPECT_FALSE(Lexer("42e0xABC"sv).takeF32());
  EXPECT_FALSE(Lexer("42e0xABC"sv).takeF64());

  EXPECT_FALSE(Lexer("+-42"sv).takeF32());
  EXPECT_FALSE(Lexer("+-42"sv).takeF64());

  EXPECT_FALSE(Lexer("-+42"sv).takeF32());
  EXPECT_FALSE(Lexer("-+42"sv).takeF64());

  EXPECT_FALSE(Lexer("42e+-0"sv).takeF32());
  EXPECT_FALSE(Lexer("42e+-0"sv).takeF64());

  EXPECT_FALSE(Lexer("42e-+0"sv).takeF32());
  EXPECT_FALSE(Lexer("42e-+0"sv).takeF64());

  EXPECT_FALSE(Lexer("42p0"sv).takeF32());
  EXPECT_FALSE(Lexer("42p0"sv).takeF64());

  EXPECT_FALSE(Lexer("42P0"sv).takeF32());
  EXPECT_FALSE(Lexer("42P0"sv).takeF64());
}

TEST(LexerTest, LexHexFloat) {

  EXPECT_EQ(Lexer("0x4B"sv).takeF32(), 0x4Bp0f);
  EXPECT_EQ(Lexer("0x4B"sv).takeF64(), 0x4Bp0);

  EXPECT_EQ(Lexer("0x4B."sv).takeF32(), 0x4B.p0f);
  EXPECT_EQ(Lexer("0x4B."sv).takeF64(), 0x4B.p0);

  EXPECT_EQ(Lexer("0x4B.5"sv).takeF32(), 0x4B.5p0f);
  EXPECT_EQ(Lexer("0x4B.5"sv).takeF64(), 0x4B.5p0);

  EXPECT_EQ(Lexer("0x4Bp0"sv).takeF32(), 0x4Bp0f);
  EXPECT_EQ(Lexer("0x4Bp0"sv).takeF64(), 0x4Bp0);

  EXPECT_EQ(Lexer("0x4B.p1"sv).takeF32(), 0x4B.p1f);
  EXPECT_EQ(Lexer("0x4B.p1"sv).takeF64(), 0x4B.p1);

  EXPECT_EQ(Lexer("0x4BP1"sv).takeF32(), 0x4BP1f);
  EXPECT_EQ(Lexer("0x4BP1"sv).takeF64(), 0x4BP1);

  EXPECT_EQ(Lexer("0x4Bp+2"sv).takeF32(), 0x4Bp+2f);
  EXPECT_EQ(Lexer("0x4Bp+2"sv).takeF64(), 0x4Bp+2);

  EXPECT_EQ(Lexer("0x4B.P-02"sv).takeF32(), 0x4B.P-02f);
  EXPECT_EQ(Lexer("0x4B.P-02"sv).takeF64(), 0x4B.P-02);

  EXPECT_EQ(Lexer("0x4B.0p0"sv).takeF32(), 0x4B.0p0f);
  EXPECT_EQ(Lexer("0x4B.0p0"sv).takeF64(), 0x4B.0p0);

  EXPECT_EQ(Lexer("0x4B.0P1"sv).takeF32(), 0x4B.0P1f);
  EXPECT_EQ(Lexer("0x4B.0P1"sv).takeF64(), 0x4B.0P1);

  EXPECT_EQ(Lexer("0x4B.0p+2"sv).takeF32(), 0x4B.0p+2f);
  EXPECT_EQ(Lexer("0x4B.0p+2"sv).takeF64(), 0x4B.0p+2);

  EXPECT_EQ(Lexer("0x4B.0P-2"sv).takeF32(), 0x4B.0P-2f);
  EXPECT_EQ(Lexer("0x4B.0P-2"sv).takeF64(), 0x4B.0P-2);

  EXPECT_EQ(Lexer("+0x4B.0p+2"sv).takeF32(), +0x4B.0p+2f);
  EXPECT_EQ(Lexer("+0x4B.0p+2"sv).takeF64(), +0x4B.0p+2);

  EXPECT_EQ(Lexer("-0x4B.0p+2"sv).takeF32(), -0x4B.0p+2f);
  EXPECT_EQ(Lexer("-0x4B.0p+2"sv).takeF64(), -0x4B.0p+2);

  EXPECT_EQ(Lexer("0x4_2.0_0p+0_2"sv).takeF32(), 0x42.00p+02f);
  EXPECT_EQ(Lexer("0x4_2.0_0p+0_2"sv).takeF64(), 0x42.00p+02);

  EXPECT_FALSE(Lexer("0x4Bjunk"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4Bjunk"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4B.junk"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4B.junk"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4B.0junk"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4B.0junk"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4B.Pjunk"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4B.Pjunk"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4B.p-junk"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4B.p-junk"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4B.p-10junk"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4B.p-10junk"sv).takeF64());

  EXPECT_FALSE(Lexer("+0x"sv).takeF32());
  EXPECT_FALSE(Lexer("+0x"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4Bp"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4Bp"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4BpABC"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4BpABC"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4Bp0xABC"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4Bp0xABC"sv).takeF64());

  EXPECT_FALSE(Lexer("0x+0"sv).takeF32());
  EXPECT_FALSE(Lexer("0x+0"sv).takeF64());

  EXPECT_FALSE(Lexer("+-0x4B"sv).takeF32());
  EXPECT_FALSE(Lexer("+-0x4B"sv).takeF64());

  EXPECT_FALSE(Lexer("-+0x4B"sv).takeF32());
  EXPECT_FALSE(Lexer("-+0x4B"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4Bp+-0"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4Bp+-0"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4Bp-+0"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4Bp-+0"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4B.e+0"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4B.e+0"sv).takeF64());

  EXPECT_FALSE(Lexer("0x4B.E-0"sv).takeF32());
  EXPECT_FALSE(Lexer("0x4B.E-0"sv).takeF64());
}

TEST(LexerTest, LexInfinity) {
  EXPECT_EQ(Lexer("inf"sv).takeF32(), INFINITY);
  EXPECT_EQ(Lexer("inf"sv).takeF64(), INFINITY);

  EXPECT_EQ(Lexer("+inf"sv).takeF32(), INFINITY);
  EXPECT_EQ(Lexer("+inf"sv).takeF64(), INFINITY);

  EXPECT_EQ(Lexer("-inf"sv).takeF32(), -INFINITY);
  EXPECT_EQ(Lexer("-inf"sv).takeF64(), -INFINITY);

  EXPECT_FALSE(Lexer("infjunk"sv).takeF32());
  EXPECT_FALSE(Lexer("infjunk"sv).takeF64());

  EXPECT_FALSE(Lexer("Inf"sv).takeF32());
  EXPECT_FALSE(Lexer("Inf"sv).takeF64());

  EXPECT_FALSE(Lexer("INF"sv).takeF32());
  EXPECT_FALSE(Lexer("INF"sv).takeF64());

  EXPECT_FALSE(Lexer("infinity"sv).takeF32());
  EXPECT_FALSE(Lexer("infinity"sv).takeF64());
}

TEST(LexerTest, LexNan) {
  ASSERT_TRUE(Lexer("nan"sv).takeF32());
  ASSERT_TRUE(Lexer("nan"sv).takeF64());

  ASSERT_TRUE(Lexer("+nan"sv).takeF32());
  ASSERT_TRUE(Lexer("+nan"sv).takeF64());

  ASSERT_TRUE(Lexer("-nan"sv).takeF32());
  ASSERT_TRUE(Lexer("-nan"sv).takeF64());

  ASSERT_TRUE(Lexer("nan:0x01"sv).takeF32());
  ASSERT_TRUE(Lexer("nan:0x01"sv).takeF64());

  ASSERT_TRUE(Lexer("+nan:0x01"sv).takeF32());
  ASSERT_TRUE(Lexer("+nan:0x01"sv).takeF64());

  ASSERT_TRUE(Lexer("-nan:0x01"sv).takeF64());
  ASSERT_TRUE(Lexer("-nan:0x01"sv).takeF64());

  ASSERT_TRUE(Lexer("nan:0x1234"sv).takeF64());
  ASSERT_TRUE(Lexer("nan:0x1234"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:0xf_ffff_ffff_ffff"sv).takeF32());
  EXPECT_TRUE(Lexer("nan:0xf_ffff_ffff_ffff"sv).takeF64());

  EXPECT_FALSE(Lexer("nanjunk"sv).takeF32());
  EXPECT_FALSE(Lexer("nanjunk"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:"sv).takeF32());
  EXPECT_FALSE(Lexer("nan:"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:0x"sv).takeF32());
  EXPECT_FALSE(Lexer("nan:0x"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:0xjunk"sv).takeF32());
  EXPECT_FALSE(Lexer("nan:0xjunk"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:-0x1"sv).takeF32());
  EXPECT_FALSE(Lexer("nan:-0x1"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:+0x1"sv).takeF32());
  EXPECT_FALSE(Lexer("nan:+0x1"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:0x0"sv).takeF32());
  EXPECT_FALSE(Lexer("nan:0x0"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:0x10_0000_0000_0000"sv).takeF32());
  EXPECT_FALSE(Lexer("nan:0x10_0000_0000_0000"sv).takeF64());

  EXPECT_FALSE(Lexer("nan:0x1_0000_0000_0000_0000"sv).takeF32());
  EXPECT_FALSE(Lexer("nan:0x1_0000_0000_0000_0000"sv).takeF64());

  EXPECT_FALSE(Lexer("NAN"sv).takeF32());
  EXPECT_FALSE(Lexer("NAN"sv).takeF64());

  EXPECT_FALSE(Lexer("NaN"sv).takeF32());
  EXPECT_FALSE(Lexer("NaN"sv).takeF64());
}

constexpr int signif32 = 23;
constexpr int signif64 = 52;

uint32_t payload(float f) {
  uint32_t x;
  static_assert(sizeof(f) == sizeof(x));
  memcpy(&x, &f, sizeof(f));
  return x & ((1u << signif32) - 1);
}

uint64_t payload(double d) {
  uint64_t x;
  static_assert(sizeof(d) == sizeof(x));
  memcpy(&x, &d, sizeof(d));
  return x & ((1ull << signif64) - 1);
}

constexpr uint32_t fnanDefault = 1u << (signif32 - 1);
constexpr uint64_t dnanDefault = 1ull << (signif64 - 1);

TEST(LexerTest, ClassifyFloat) {
  auto flt_max = "340282346638528859811704183484516925440."sv;
  EXPECT_EQ(Lexer(flt_max).takeF32(), FLT_MAX);
  EXPECT_EQ(Lexer(flt_max).takeF64(), FLT_MAX);

  auto dbl_max =
    "17976931348623157081452742373170435679807056752584499659891747"
    "68031572607800285387605895586327668781715404589535143824642343"
    "21326889464182768467546703537516986049910576551282076245490090"
    "38932894407586850845513394230458323690322294816580855933212334"
    "8274797826204144723168738177180919299881250404026184124858368"
    "."sv;
  EXPECT_EQ(Lexer(dbl_max).takeF32(), INFINITY);
  EXPECT_EQ(Lexer(dbl_max).takeF64(), DBL_MAX);

  {
    auto nan = "nan"sv;
    ASSERT_TRUE(Lexer(nan).takeF32());
    float f = *Lexer(nan).takeF32();
    EXPECT_TRUE(std::isnan(f));
    EXPECT_FALSE(std::signbit(f));
    EXPECT_EQ(payload(f), fnanDefault);

    ASSERT_TRUE(Lexer(nan).takeF64());
    double d = *Lexer(nan).takeF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_FALSE(std::signbit(d));
    EXPECT_EQ(payload(d), dnanDefault);
  }
  {
    auto nan = "-nan"sv;
    ASSERT_TRUE(Lexer(nan).takeF32());
    float f = *Lexer(nan).takeF32();
    EXPECT_TRUE(std::isnan(f));
    EXPECT_TRUE(std::signbit(f));
    EXPECT_EQ(payload(f), fnanDefault);

    ASSERT_TRUE(Lexer(nan).takeF64());
    double d = *Lexer(nan).takeF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_TRUE(std::signbit(d));
    EXPECT_EQ(payload(d), dnanDefault);
  }
  {
    auto nan = "+nan"sv;
    ASSERT_TRUE(Lexer(nan).takeF32());
    float f = *Lexer(nan).takeF32();
    EXPECT_TRUE(std::isnan(f));
    EXPECT_FALSE(std::signbit(f));
    EXPECT_EQ(payload(f), fnanDefault);

    ASSERT_TRUE(Lexer(nan).takeF64());
    double d = *Lexer(nan).takeF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_FALSE(std::signbit(d));
    EXPECT_EQ(payload(d), dnanDefault);
  }
  {
    auto nan = "nan:0x1234"sv;
    ASSERT_TRUE(Lexer(nan).takeF32());
    float f = *Lexer(nan).takeF32();
    EXPECT_TRUE(std::isnan(f));
    EXPECT_FALSE(std::signbit(f));
    EXPECT_EQ(payload(f), uint32_t(0x1234));

    ASSERT_TRUE(Lexer(nan).takeF64());
    double d = *Lexer(nan).takeF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_FALSE(std::signbit(d));
    EXPECT_EQ(payload(d), uint64_t(0x1234));
  }
  {
    auto nan = "nan:0x7FFFFF"sv;
    ASSERT_TRUE(Lexer(nan).takeF32());
    float f = *Lexer(nan).takeF32();
    EXPECT_TRUE(std::isnan(f));
    EXPECT_FALSE(std::signbit(f));
    EXPECT_EQ(payload(f), uint32_t(0x7FFFFF));

    ASSERT_TRUE(Lexer(nan).takeF64());
    double d = *Lexer(nan).takeF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_FALSE(std::signbit(d));
    EXPECT_EQ(payload(d), uint64_t(0x7FFFFF));
  }
  {
    auto nan = "nan:0x800000"sv;
    EXPECT_FALSE(Lexer(nan).takeF32());

    ASSERT_TRUE(Lexer(nan).takeF64());
    double d = *Lexer(nan).takeF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_FALSE(std::signbit(d));
    EXPECT_EQ(payload(d), uint64_t(0x800000));
  }

  {
    auto nan = "nan:0x0"sv;
    EXPECT_FALSE(Lexer(nan).takeF32());
    EXPECT_FALSE(Lexer(nan).takeF64());
  }
}

TEST(LexerTest, LexIdent) {
  EXPECT_EQ(Lexer("$09azAZ!#$%&'*+-./:<=>?@\\^_`|~"sv).takeID(),
            wasm::Name("09azAZ!#$%&'*+-./:<=>?@\\^_`|~"sv));
  EXPECT_FALSE(Lexer("$[]{}"sv).takeID());
  EXPECT_FALSE(Lexer("$abc[]"sv).takeID());
  EXPECT_FALSE(Lexer("$"sv).takeID());

  // String IDs
  EXPECT_EQ(Lexer("$\"\""sv).takeID(), wasm::Name(""sv));
  EXPECT_EQ(Lexer("$\"hello\""sv).takeID(), wasm::Name("hello"sv));
  // _$_£_€_𐍈_
  EXPECT_EQ(Lexer("$\"_\\u{24}_\\u{00a3}_\\u{20AC}_\\u{10348}_\""sv).takeID(),
            wasm::Name("_$_\xC2\xA3_\xE2\x82\xAC_\xF0\x90\x8D\x88_"sv));
}

TEST(LexerTest, LexString) {
  using namespace std::string_literals;
  EXPECT_EQ(
    Lexer("\"The quick brown fox jumps over the lazy dog\""sv).takeString(),
    "The quick brown fox jumps over the lazy dog");
  EXPECT_EQ(Lexer("\"`~!@#$%^&*()_-+0123456789|,.<>/?;:'\""sv).takeString(),
            "`~!@#$%^&*()_-+0123456789|,.<>/?;:'");
  EXPECT_EQ(Lexer("\"_\\t_\\n_\\r_\\\\_\\\"_\\'_\""sv).takeString(),
            "_\t_\n_\r_\\_\"_\'_");
  EXPECT_EQ(Lexer("\"_\\00_\\07_\\20_\\5A_\\7F_\\ff_\\ffff_\""sv).takeString(),
            "_\0_\7_ _Z_\x7f_\xff_\xff"s + "ff_"s);
  // _$_£_€_𐍈_
  EXPECT_EQ(
    Lexer("\"_\\u{24}_\\u{00a3}_\\u{20AC}_\\u{10348}_\""sv).takeString(),
    "_$_\xC2\xA3_\xE2\x82\xAC_\xF0\x90\x8D\x88_"s);
  EXPECT_EQ(
    Lexer("\"_$_\xC2\xA3_\xE2\x82\xAC_\xF0\x90\x8D\x88_\""sv).takeString(),
    "_$_\xC2\xA3_\xE2\x82\xAC_\xF0\x90\x8D\x88_"s);

  EXPECT_FALSE(Lexer("\"unterminated"sv).takeString());
  EXPECT_FALSE(Lexer("\"unescaped nul\0\""sv).takeString());
  EXPECT_FALSE(Lexer("\"unescaped U+19\x19\""sv).takeString());
  EXPECT_FALSE(Lexer("\"unescaped U+7f\x7f\""sv).takeString());
  EXPECT_FALSE(Lexer("\"\\ stray backslash\""sv).takeString());
  EXPECT_FALSE(Lexer("\"short \\f hex escape\""sv).takeString());
  EXPECT_FALSE(Lexer("\"bad hex \\gg\""sv).takeString());
  EXPECT_FALSE(Lexer("\"empty unicode \\u{}\""sv).takeString());
  EXPECT_FALSE(Lexer("\"not unicode \\u{abcdefg}\""sv).takeString());
  EXPECT_FALSE(Lexer("\"extra chars \\u{123(}\""sv).takeString());
  EXPECT_FALSE(
    Lexer("\"unpaired surrogate unicode crimes \\u{d800}\""sv).takeString());
  EXPECT_FALSE(
    Lexer("\"more surrogate unicode crimes \\u{dfff}\""sv).takeString());
  EXPECT_FALSE(Lexer("\"too big \\u{110000}\""sv).takeString());
}

TEST(LexerTest, LexKeywords) {
  Lexer lexer("module type func import rEsErVeD");
  ASSERT_EQ(lexer.takeKeyword(), "module"sv);
  ASSERT_EQ(lexer.takeKeyword(), "type"sv);
  ASSERT_EQ(lexer.takeKeyword(), "func"sv);
  ASSERT_EQ(lexer.takeKeyword(), "import"sv);
  ASSERT_EQ(lexer.takeKeyword(), "rEsErVeD"sv);
  ASSERT_TRUE(lexer.empty());
}
