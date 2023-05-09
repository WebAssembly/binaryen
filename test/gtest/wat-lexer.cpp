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

#include "wat-lexer.h"
#include "gtest/gtest.h"

using namespace wasm::WATParser;
using namespace std::string_view_literals;

TEST(LexerTest, LexWhitespace) {
  Token one{"1"sv, IntTok{1, NoSign}};
  Token two{"2"sv, IntTok{2, NoSign}};
  Token three{"3"sv, IntTok{3, NoSign}};
  Token four{"4"sv, IntTok{4, NoSign}};
  Token five{"5"sv, IntTok{5, NoSign}};

  Lexer lexer(" 1\t2\n3\r4 \n\n\t 5 "sv);

  auto it = lexer.begin();
  ASSERT_NE(it, lexer.end());
  Token t1 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t2 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t3 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t4 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t5 = *it++;
  EXPECT_EQ(it, lexer.end());

  EXPECT_EQ(t1, one);
  EXPECT_EQ(t2, two);
  EXPECT_EQ(t3, three);
  EXPECT_EQ(t4, four);
  EXPECT_EQ(t5, five);

  EXPECT_EQ(lexer.position(t1), (TextPos{1, 1}));
  EXPECT_EQ(lexer.position(t2), (TextPos{1, 3}));
  EXPECT_EQ(lexer.position(t3), (TextPos{2, 0}));
  EXPECT_EQ(lexer.position(t4), (TextPos{2, 2}));
  EXPECT_EQ(lexer.position(t5), (TextPos{4, 2}));
}

TEST(LexerTest, LexLineComment) {
  Token one{"1"sv, IntTok{1, NoSign}};
  Token six{"6"sv, IntTok{6, NoSign}};

  Lexer lexer("1;; whee! 2 3\t4\r5\n6"sv);

  auto it = lexer.begin();
  Token t1 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t2 = *it++;
  EXPECT_EQ(it, lexer.end());

  EXPECT_EQ(t1, one);
  EXPECT_EQ(t2, six);

  EXPECT_EQ(lexer.position(t1), (TextPos{1, 0}));
  EXPECT_EQ(lexer.position(t2), (TextPos{2, 0}));
}

TEST(LexerTest, LexBlockComment) {
  Token one{"1"sv, IntTok{1, NoSign}};
  Token six{"6"sv, IntTok{6, NoSign}};

  Lexer lexer("1(; whoo! 2\n (; \n3\n ;) 4 (;) 5 ;) \n;)6"sv);

  auto it = lexer.begin();
  Token t1 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t2 = *it++;
  EXPECT_EQ(it, lexer.end());

  EXPECT_EQ(t1, one);
  EXPECT_EQ(t2, six);

  EXPECT_EQ(lexer.position(t1), (TextPos{1, 0}));
  EXPECT_EQ(lexer.position(t2), (TextPos{5, 2}));
}

TEST(LexerTest, LexParens) {
  Token left{"("sv, LParenTok{}};
  Token right{")"sv, RParenTok{}};

  Lexer lexer("(())"sv);

  auto it = lexer.begin();
  ASSERT_NE(it, lexer.end());
  Token t1 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t2 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t3 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t4 = *it++;
  EXPECT_EQ(it, lexer.end());

  EXPECT_EQ(t1, left);
  EXPECT_EQ(t2, left);
  EXPECT_EQ(t3, right);
  EXPECT_EQ(t4, right);
  EXPECT_TRUE(left.isLParen());
  EXPECT_TRUE(right.isRParen());
}

TEST(LexerTest, LexInt) {
  {
    Lexer lexer("0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0"sv, IntTok{0, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+0"sv, IntTok{0, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-0"sv, IntTok{0, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"1"sv, IntTok{1, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+1"sv, IntTok{1, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-1"sv, IntTok{-1ull, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0010"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0010"sv, IntTok{10, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0010"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+0010"sv, IntTok{10, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0010"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-0010"sv, IntTok{-10ull, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("9999"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"9999"sv, IntTok{9999, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+9999"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+9999"sv, IntTok{9999, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-9999"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-9999"sv, IntTok{-9999ull, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("12_34"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"12_34"sv, IntTok{1234, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("1_2_3_4"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"1_2_3_4"sv, IntTok{1234, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("_1234"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("1234_"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("12__34"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("12cd56"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("18446744073709551615"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"18446744073709551615"sv, IntTok{-1ull, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // 64-bit unsigned overflow!
    Lexer lexer("18446744073709551616"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"18446744073709551616"sv,
                   FloatTok{{}, 18446744073709551616.}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+9223372036854775807"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+9223372036854775807"sv, IntTok{INT64_MAX, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+9223372036854775808"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+9223372036854775808"sv,
                   IntTok{uint64_t(INT64_MAX) + 1, Pos}};
    ;
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-9223372036854775808"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-9223372036854775808"sv, IntTok{uint64_t(INT64_MIN), Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-9223372036854775809"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-9223372036854775809"sv,
                   IntTok{uint64_t(INT64_MIN) - 1, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
}

TEST(LexerTest, LexHexInt) {
  {
    Lexer lexer("0x0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x0"sv, IntTok{0, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+0x0"sv, IntTok{0, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-0x0"sv, IntTok{0, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x1"sv, IntTok{1, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+0x1"sv, IntTok{1, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-0x1"sv, IntTok{-1ull, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x0010"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x0010"sv, IntTok{16, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x0010"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+0x0010"sv, IntTok{16, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x0010"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-0x0010"sv, IntTok{-16ull, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0xabcdef"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0xabcdef"sv, IntTok{0xabcdef, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0xABCDEF"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+0xABCDEF"sv, IntTok{0xabcdef, Pos}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0xAbCdEf"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-0xAbCdEf"sv, IntTok{-0xabcdefull, Neg}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x12_34"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x12_34"sv, IntTok{0x1234, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x1_2_3_4"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x1_2_3_4"sv, IntTok{0x1234, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("_0x1234"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x_1234"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x1234_"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x12__34"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0xg"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x120x34"sv);
    EXPECT_TRUE(lexer.empty());
  }
}

TEST(LexerTest, ClassifyInt) {
  {
    Lexer lexer("0"sv);
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    ASSERT_TRUE(lexer->getU32());
    ASSERT_TRUE(lexer->getS32());
    ASSERT_TRUE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getU64(), 0ull);
    EXPECT_EQ(*lexer->getS64(), 0ll);
    EXPECT_EQ(*lexer->getI64(), 0ull);
    EXPECT_EQ(*lexer->getU32(), 0u);
    EXPECT_EQ(*lexer->getS32(), 0);
    EXPECT_EQ(*lexer->getI32(), 0u);
    EXPECT_EQ(*lexer->getF64(), 0.0);
    EXPECT_EQ(*lexer->getF32(), 0.0);
    EXPECT_FALSE(std::signbit(*lexer->getF64()));
    EXPECT_FALSE(std::signbit(*lexer->getF32()));
  }
  {
    Lexer lexer("+0"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    ASSERT_TRUE(lexer->getS32());
    ASSERT_TRUE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), 0ll);
    EXPECT_EQ(*lexer->getI64(), 0ull);
    EXPECT_EQ(*lexer->getS32(), 0);
    EXPECT_EQ(*lexer->getI32(), 0u);
    EXPECT_EQ(*lexer->getF64(), 0.0);
    EXPECT_EQ(*lexer->getF32(), 0.0);
    EXPECT_FALSE(std::signbit(*lexer->getF64()));
    EXPECT_FALSE(std::signbit(*lexer->getF32()));
  }
  {
    Lexer lexer("-0"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    ASSERT_TRUE(lexer->getS32());
    ASSERT_TRUE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), 0ll);
    EXPECT_EQ(*lexer->getI64(), 0ull);
    EXPECT_EQ(*lexer->getS32(), 0);
    EXPECT_EQ(*lexer->getI32(), 0u);
    EXPECT_EQ(*lexer->getF64(), -0.0);
    EXPECT_EQ(*lexer->getF32(), -0.0);
    ASSERT_TRUE(std::signbit(*lexer->getF64()));
    ASSERT_TRUE(std::signbit(*lexer->getF32()));
  }
  {
    Lexer lexer("0x7fff_ffff"sv);
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    ASSERT_TRUE(lexer->getU32());
    ASSERT_TRUE(lexer->getS32());
    ASSERT_TRUE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getU64(), 0x7fffffffull);
    EXPECT_EQ(*lexer->getS64(), 0x7fffffffll);
    EXPECT_EQ(*lexer->getI64(), 0x7fffffffull);
    EXPECT_EQ(*lexer->getU32(), 0x7fffffffu);
    EXPECT_EQ(*lexer->getS32(), 0x7fffffff);
    EXPECT_EQ(*lexer->getI32(), 0x7fffffffu);
    EXPECT_EQ(*lexer->getF64(), 0x7fffffff.p0);
    EXPECT_EQ(*lexer->getF32(), 0x7fffffff.p0f);
  }
  {
    Lexer lexer("0x8000_0000"sv);
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    ASSERT_TRUE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    ASSERT_TRUE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getU64(), 0x80000000ull);
    EXPECT_EQ(*lexer->getS64(), 0x80000000ll);
    EXPECT_EQ(*lexer->getI64(), 0x80000000ull);
    EXPECT_EQ(*lexer->getU32(), 0x80000000u);
    EXPECT_EQ(*lexer->getI32(), 0x80000000u);
    EXPECT_EQ(*lexer->getF64(), 0x80000000.p0);
    EXPECT_EQ(*lexer->getF32(), 0x80000000.p0f);
  }
  {
    Lexer lexer("+0x7fff_ffff"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    ASSERT_TRUE(lexer->getS32());
    ASSERT_TRUE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), 0x7fffffffll);
    EXPECT_EQ(*lexer->getI64(), 0x7fffffffull);
    EXPECT_EQ(*lexer->getS32(), 0x7fffffff);
    EXPECT_EQ(*lexer->getI32(), 0x7fffffffu);
    EXPECT_EQ(*lexer->getF64(), 0x7fffffff.p0);
    EXPECT_EQ(*lexer->getF32(), 0x7fffffff.p0f);
  }
  {
    Lexer lexer("+0x8000_0000"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), 0x80000000ll);
    EXPECT_EQ(*lexer->getI64(), 0x80000000ull);
    EXPECT_EQ(*lexer->getF64(), 0x80000000.p0);
    EXPECT_EQ(*lexer->getF32(), 0x80000000.p0f);
  }
  {
    Lexer lexer("-0x8000_0000"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    ASSERT_TRUE(lexer->getS32());
    ASSERT_TRUE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), -0x80000000ll);
    EXPECT_EQ(*lexer->getI64(), -0x80000000ull);
    EXPECT_EQ(*lexer->getS32(), -0x7fffffffll - 1);
    EXPECT_EQ(*lexer->getI32(), -0x80000000u);
    EXPECT_EQ(*lexer->getF64(), -0x80000000.p0);
    EXPECT_EQ(*lexer->getF32(), -0x80000000.p0f);
  }
  {
    Lexer lexer("-0x8000_0001"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), -0x80000001ll);
    EXPECT_EQ(*lexer->getI64(), -0x80000001ull);
    EXPECT_EQ(*lexer->getF64(), -0x80000001.p0);
    EXPECT_EQ(*lexer->getF32(), -0x80000001.p0f);
  }
  {
    Lexer lexer("0xffff_ffff"sv);
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    ASSERT_TRUE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    ASSERT_TRUE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getU64(), 0xffffffffull);
    EXPECT_EQ(*lexer->getS64(), 0xffffffffll);
    EXPECT_EQ(*lexer->getI64(), 0xffffffffull);
    EXPECT_EQ(*lexer->getU32(), 0xffffffffu);
    EXPECT_EQ(*lexer->getI32(), 0xffffffffu);
    EXPECT_EQ(*lexer->getF64(), 0xffffffff.p0);
    EXPECT_EQ(*lexer->getF32(), 0xffffffff.p0f);
  }
  {
    Lexer lexer("0x1_0000_0000"sv);
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getU64(), 0x100000000ull);
    EXPECT_EQ(*lexer->getS64(), 0x100000000ll);
    EXPECT_EQ(*lexer->getI64(), 0x100000000ull);
    EXPECT_EQ(*lexer->getF64(), 0x100000000.p0);
    EXPECT_EQ(*lexer->getF32(), 0x100000000.p0f);
  }
  {
    Lexer lexer("+0xffff_ffff"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), 0xffffffffll);
    EXPECT_EQ(*lexer->getI64(), 0xffffffffull);
    EXPECT_EQ(*lexer->getF64(), 0xffffffff.p0);
    EXPECT_EQ(*lexer->getF32(), 0xffffffff.p0f);
  }
  {
    Lexer lexer("+0x1_0000_0000"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), 0x100000000ll);
    EXPECT_EQ(*lexer->getI64(), 0x100000000ull);
    EXPECT_EQ(*lexer->getF64(), 0x100000000.p0);
    EXPECT_EQ(*lexer->getF32(), 0x100000000.p0f);
  }
  {
    Lexer lexer("0x7fff_ffff_ffff_ffff"sv);
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getU64(), 0x7fffffffffffffffull);
    EXPECT_EQ(*lexer->getS64(), 0x7fffffffffffffffll);
    EXPECT_EQ(*lexer->getI64(), 0x7fffffffffffffffull);
    EXPECT_EQ(*lexer->getF64(), 0x7fffffffffffffff.p0);
    EXPECT_EQ(*lexer->getF32(), 0x7fffffffffffffff.p0f);
  }
  {
    Lexer lexer("+0x7fff_ffff_ffff_ffff"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), 0x7fffffffffffffffll);
    EXPECT_EQ(*lexer->getI64(), 0x7fffffffffffffffull);
    EXPECT_EQ(*lexer->getF64(), 0x7fffffffffffffff.p0);
    EXPECT_EQ(*lexer->getF32(), 0x7fffffffffffffff.p0f);
  }
  {
    Lexer lexer("-0x8000_0000_0000_0000"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    ASSERT_TRUE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getS64(), -0x7fffffffffffffffll - 1);
    EXPECT_EQ(*lexer->getI64(), -0x8000000000000000ull);
    EXPECT_EQ(*lexer->getF64(), -0x8000000000000000.p0);
    EXPECT_EQ(*lexer->getF32(), -0x8000000000000000.p0f);
  }
  {
    Lexer lexer("0xffff_ffff_ffff_ffff"sv);
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getU64());
    EXPECT_FALSE(lexer->getS64());
    ASSERT_TRUE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getU64(), 0xffffffffffffffffull);
    EXPECT_EQ(*lexer->getI64(), 0xffffffffffffffffull);
    EXPECT_EQ(*lexer->getF64(), 0xffffffffffffffff.p0);
    EXPECT_EQ(*lexer->getF32(), 0xffffffffffffffff.p0f);
  }
  {
    Lexer lexer("+0xffff_ffff_ffff_ffff"sv);
    ASSERT_FALSE(lexer.empty());

    EXPECT_FALSE(lexer->getU64());
    EXPECT_FALSE(lexer->getS64());
    EXPECT_FALSE(lexer->getI64());
    EXPECT_FALSE(lexer->getU32());
    EXPECT_FALSE(lexer->getS32());
    EXPECT_FALSE(lexer->getI32());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());

    EXPECT_EQ(*lexer->getF64(), 0xffffffffffffffff.p0);
    EXPECT_EQ(*lexer->getF32(), 0xffffffffffffffff.p0f);
  }
}

TEST(LexerTest, LexFloat) {
  {
    Lexer lexer("42"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42"sv, IntTok{42, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42."sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42."sv, FloatTok{{}, 42.}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42.5"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42.5"sv, FloatTok{{}, 42.5}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42e0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42e0"sv, FloatTok{{}, 42e0}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42.e1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42.e1"sv, FloatTok{{}, 42.e1}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42E1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42E1"sv, FloatTok{{}, 42E1}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42e+2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42e+2"sv, FloatTok{{}, 42e+2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42.E-02"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42.E-02"sv, FloatTok{{}, 42.E-02}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42.0e0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42.0e0"sv, FloatTok{{}, 42.0e0}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42.0E1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42.0E1"sv, FloatTok{{}, 42.0E1}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42.0e+2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42.0e+2"sv, FloatTok{{}, 42.0e+2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("42.0E-2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"42.0E-2"sv, FloatTok{{}, 42.0E-2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+42.0e+2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+42.0e+2"sv, FloatTok{{}, +42.0e+2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-42.0e+2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-42.0e+2"sv, FloatTok{{}, -42.0e+2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("4_2.0_0e+0_2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"4_2.0_0e+0_2"sv, FloatTok{{}, 42.00e+02}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42.junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42.0junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42.Ejunk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42.e-junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42.e-10junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("+"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42e"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42eABC"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42e0xABC"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("+-42"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("-+42"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42e+-0"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42e-+0"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42p0"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("42P0"sv);
    EXPECT_TRUE(lexer.empty());
  }
}

TEST(LexerTest, LexHexFloat) {
  {
    Lexer lexer("0x4B"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B"sv, IntTok{0x4B, NoSign}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4B."sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B."sv, FloatTok{{}, 0x4Bp0}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4B.5"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B.5"sv, FloatTok{{}, 0x4B.5p0}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4Bp0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4Bp0"sv, FloatTok{{}, 0x4Bp0}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4B.p1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B.p1"sv, FloatTok{{}, 0x4B.p1}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4BP1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4BP1"sv, FloatTok{{}, 0x4BP1}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4Bp+2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4Bp+2"sv, FloatTok{{}, 0x4Bp+2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4B.P-02"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B.P-02"sv, FloatTok{{}, 0x4B.P-02}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4B.0p0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B.0p0"sv, FloatTok{{}, 0x4B.0p0}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4B.0P1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B.0P1"sv, FloatTok{{}, 0x4B.0P1}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4B.0p+2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B.0p+2"sv, FloatTok{{}, 0x4B.0p+2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4B.0P-2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4B.0P-2"sv, FloatTok{{}, 0x4B.0P-2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x4B.0p+2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+0x4B.0p+2"sv, FloatTok{{}, +0x4B.0p+2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x4B.0p+2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-0x4B.0p+2"sv, FloatTok{{}, -0x4B.0p+2}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4_2.0_0p+0_2"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"0x4_2.0_0p+0_2"sv, FloatTok{{}, 0x42.00p+02}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x4Bjunk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4B.junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4B.0junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4B.Pjunk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4B.p-junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4B.p-10junk"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("+0x"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4Bp"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4BpABC"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4Bp0xABC"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x+0"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("+-0x4B"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("-+0x4B"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4Bp+-0"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4Bp-+0"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4B.e+0"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("0x4B.E-0"sv);
    EXPECT_TRUE(lexer.empty());
  }
}

TEST(LexerTest, LexInfinity) {
  {
    Lexer lexer("inf"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"inf"sv, FloatTok{{}, INFINITY}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+inf"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+inf"sv, FloatTok{{}, INFINITY}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-inf"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-inf"sv, FloatTok{{}, -INFINITY}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("infjunk"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"infjunk"sv, KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("Inf"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("INF"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("infinity"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"infinity"sv, KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
}

TEST(LexerTest, LexNan) {
  const double posNan = std::copysign(NAN, 1.0);
  const double negNan = std::copysign(NAN, -1.0);
  {
    Lexer lexer("nan"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan"sv, FloatTok{{}, posNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+nan"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+nan"sv, FloatTok{{}, posNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-nan"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-nan"sv, FloatTok{{}, negNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:0x01"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:0x01"sv, FloatTok{{1}, posNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+nan:0x01"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"+nan:0x01"sv, FloatTok{{1}, posNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-nan:0x01"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"-nan:0x01"sv, FloatTok{{1}, negNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:0x1234"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:0x1234"sv, FloatTok{{0x1234}, posNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:0xf_ffff_ffff_ffff"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:0xf_ffff_ffff_ffff"sv,
                   FloatTok{{0xfffffffffffff}, posNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nanjunk"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nanjunk", KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:"sv, KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:0x"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:0x"sv, KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:0xjunk"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:0xjunk"sv, KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:-0x1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:-0x1"sv, KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:+0x1"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:+0x1"sv, KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:0x0"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:0x0"sv, FloatTok{{0}, posNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:0x10_0000_0000_0000"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:0x10_0000_0000_0000"sv,
                   FloatTok{{0x10000000000000}, posNan}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("nan:0x1_0000_0000_0000_0000"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"nan:0x1_0000_0000_0000_0000"sv, KeywordTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("NAN"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("NaN"sv);
    EXPECT_TRUE(lexer.empty());
  }
}

TEST(LexerTest, ClassifyFloat) {
  constexpr int signif64 = 52;
  constexpr int signif32 = 23;
  constexpr uint64_t payloadMask64 = (1ull << signif64) - 1;
  constexpr uint32_t payloadMask32 = (1u << signif32) - 1;
  constexpr uint64_t dnanDefault = 1ull << (signif64 - 1);
  constexpr uint32_t fnanDefault = 1u << (signif32 - 1);
  {
    Lexer lexer("340282346638528859811704183484516925440."sv);
    ASSERT_FALSE(lexer.empty());
    ASSERT_TRUE(lexer->getF64());
    EXPECT_TRUE(lexer->getF32());
    EXPECT_EQ(*lexer->getF64(), FLT_MAX);
    EXPECT_EQ(*lexer->getF32(), FLT_MAX);
  }
  {
    Lexer lexer("17976931348623157081452742373170435679807056752584499659891747"
                "68031572607800285387605895586327668781715404589535143824642343"
                "21326889464182768467546703537516986049910576551282076245490090"
                "38932894407586850845513394230458323690322294816580855933212334"
                "8274797826204144723168738177180919299881250404026184124858368"
                "."sv);
    ASSERT_FALSE(lexer.empty());
    ASSERT_TRUE(lexer->getF64());
    ASSERT_TRUE(lexer->getF32());
    EXPECT_EQ(*lexer->getF64(), DBL_MAX);
    EXPECT_EQ(*lexer->getF32(), INFINITY);
  }
  {
    Lexer lexer("nan");
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getF64());
    double d = *lexer->getF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_FALSE(std::signbit(d));
    uint64_t dbits;
    memcpy(&dbits, &d, sizeof(dbits));
    EXPECT_EQ(dbits & payloadMask64, dnanDefault);

    ASSERT_TRUE(lexer->getF32());
    float f = *lexer->getF32();
    EXPECT_TRUE(std::isnan(f));
    EXPECT_FALSE(std::signbit(f));
    uint32_t fbits;
    memcpy(&fbits, &f, sizeof(fbits));
    EXPECT_EQ(fbits & payloadMask32, fnanDefault);
  }
  {
    Lexer lexer("-nan");
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getF64());
    double d = *lexer->getF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_TRUE(std::signbit(d));
    uint64_t dbits;
    memcpy(&dbits, &d, sizeof(dbits));
    EXPECT_EQ(dbits & payloadMask64, dnanDefault);

    ASSERT_TRUE(lexer->getF32());
    float f = *lexer->getF32();
    EXPECT_TRUE(std::isnan(f));
    EXPECT_TRUE(std::signbit(f));
    uint32_t fbits;
    memcpy(&fbits, &f, sizeof(fbits));
    EXPECT_EQ(fbits & payloadMask32, fnanDefault);
  }
  {
    Lexer lexer("+nan");
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getF64());
    double d = *lexer->getF64();
    EXPECT_TRUE(std::isnan(d));
    EXPECT_FALSE(std::signbit(d));
    uint64_t dbits;
    memcpy(&dbits, &d, sizeof(dbits));
    EXPECT_EQ(dbits & payloadMask64, dnanDefault);

    ASSERT_TRUE(lexer->getF32());
    float f = *lexer->getF32();
    EXPECT_TRUE(std::isnan(f));
    EXPECT_FALSE(std::signbit(f));
    uint32_t fbits;
    memcpy(&fbits, &f, sizeof(fbits));
    EXPECT_EQ(fbits & payloadMask32, fnanDefault);
  }
  {
    Lexer lexer("nan:0x1234");
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getF64());
    double d = *lexer->getF64();
    EXPECT_TRUE(std::isnan(d));
    uint64_t dbits;
    memcpy(&dbits, &d, sizeof(dbits));
    EXPECT_EQ(dbits & payloadMask64, 0x1234ull);

    ASSERT_TRUE(lexer->getF32());
    float f = *lexer->getF32();
    EXPECT_TRUE(std::isnan(f));
    uint32_t fbits;
    memcpy(&fbits, &f, sizeof(fbits));
    EXPECT_EQ(fbits & payloadMask32, 0x1234u);
  }
  {
    Lexer lexer("nan:0x7FFFFF");
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getF64());
    double d = *lexer->getF64();
    EXPECT_TRUE(std::isnan(d));
    uint64_t dbits;
    memcpy(&dbits, &d, sizeof(dbits));
    EXPECT_EQ(dbits & payloadMask64, 0x7fffffull);

    ASSERT_TRUE(lexer->getF32());
    float f = *lexer->getF32();
    EXPECT_TRUE(std::isnan(f));
    uint32_t fbits;
    memcpy(&fbits, &f, sizeof(fbits));
    EXPECT_EQ(fbits & payloadMask32, 0x7fffffu);
  }
  {
    Lexer lexer("nan:0x800000");
    ASSERT_FALSE(lexer.empty());

    ASSERT_TRUE(lexer->getF64());
    double d = *lexer->getF64();
    EXPECT_TRUE(std::isnan(d));
    uint64_t dbits;
    memcpy(&dbits, &d, sizeof(dbits));
    EXPECT_EQ(dbits & payloadMask64, 0x800000ull);

    ASSERT_FALSE(lexer->getF32());
  }
  {
    Lexer lexer("nan:0x0");
    ASSERT_FALSE(lexer.empty());

    ASSERT_FALSE(lexer->getF64());
    ASSERT_FALSE(lexer->getF32());
  }
}

TEST(LexerTest, LexIdent) {
  {
    Lexer lexer("$09azAZ!#$%&'*+-./:<=>?@\\^_`|~"sv);
    ASSERT_FALSE(lexer.empty());
    Token expected{"$09azAZ!#$%&'*+-./:<=>?@\\^_`|~"sv, IdTok{}};
    EXPECT_EQ(*lexer, expected);
    EXPECT_TRUE(lexer->getID());
    EXPECT_EQ(*lexer->getID(), "09azAZ!#$%&'*+-./:<=>?@\\^_`|~"sv);
  }
  {
    Lexer lexer("$[]{}"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("$abc[]"sv);
    EXPECT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("$"sv);
    EXPECT_TRUE(lexer.empty());
  }
}

TEST(LexerTest, LexString) {
  {
    auto pangram = "\"The quick brown fox jumps over the lazy dog\""sv;
    Lexer lexer(pangram);
    ASSERT_FALSE(lexer.empty());
    Token expected{pangram, StringTok{{}}};
    EXPECT_EQ(*lexer, expected);
    EXPECT_TRUE(lexer->getString());
    EXPECT_EQ(*lexer->getString(),
              "The quick brown fox jumps over the lazy dog"sv);
  }
  {
    auto chars = "\"`~!@#$%^&*()_-+0123456789|,.<>/?;:'\""sv;
    Lexer lexer(chars);
    ASSERT_FALSE(lexer.empty());
    Token expected{chars, StringTok{{}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    auto escapes = "\"_\\t_\\n_\\r_\\\\_\\\"_\\'_\""sv;
    Lexer lexer(escapes);
    ASSERT_FALSE(lexer.empty());
    Token expected{escapes, StringTok{{"_\t_\n_\r_\\_\"_'_"}}};
    EXPECT_EQ(*lexer, expected);
    EXPECT_TRUE(lexer->getString());
    EXPECT_EQ(*lexer->getString(), "_\t_\n_\r_\\_\"_'_"sv);
  }
  {
    auto escapes = "\"_\\00_\\07_\\20_\\5A_\\7F_\\ff_\\ffff_\""sv;
    Lexer lexer(escapes);
    ASSERT_FALSE(lexer.empty());
    std::string escaped{"_\0_\7_ _Z_\x7f_\xff_\xff"
                        "ff_"sv};
    Token expected{escapes, StringTok{{escaped}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // _$_£_€_𐍈_
    auto unicode = "\"_\\u{24}_\\u{00a3}_\\u{20AC}_\\u{10348}_\""sv;
    Lexer lexer(unicode);
    ASSERT_FALSE(lexer.empty());
    std::string escaped{"_$_\xC2\xA3_\xE2\x82\xAC_\xF0\x90\x8D\x88_"};
    Token expected{unicode, StringTok{{escaped}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // _$_£_€_𐍈_
    auto unicode = "\"_$_\xC2\xA3_\xE2\x82\xAC_\xF0\x90\x8D\x88_\""sv;
    Lexer lexer(unicode);
    ASSERT_FALSE(lexer.empty());
    Token expected{unicode, StringTok{{}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("\"unterminated"sv);
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"unescaped nul\0\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"unescaped U+19\x19\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"unescaped U+7f\x7f\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"\\ stray backslash\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"short \\f hex escape\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"bad hex \\gg\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"empty unicode \\u{}\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"not unicode \\u{abcdefg}\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"extra chars \\u{123(}\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"unpaired surrogate unicode crimes \\u{d800}\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"more surrogate unicode crimes \\u{dfff}\"");
    ASSERT_TRUE(lexer.empty());
  }
  {
    Lexer lexer("\"too big \\u{110000}\"");
    ASSERT_TRUE(lexer.empty());
  }
}

TEST(LexerTest, LexKeywords) {
  Token module{"module"sv, KeywordTok{}};
  Token type{"type"sv, KeywordTok{}};
  Token func{"func"sv, KeywordTok{}};
  Token import{"import"sv, KeywordTok{}};
  Token reserved{"rEsErVeD"sv, KeywordTok{}};

  Lexer lexer("module type func import rEsErVeD");

  auto it = lexer.begin();
  ASSERT_NE(it, lexer.end());
  Token t1 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t2 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t3 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t4 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t5 = *it++;
  EXPECT_EQ(it, lexer.end());

  EXPECT_EQ(t1, module);
  EXPECT_EQ(t2, type);
  EXPECT_EQ(t3, func);
  EXPECT_EQ(t4, import);
  EXPECT_EQ(t5, reserved);

  EXPECT_TRUE(t1.getKeyword());
  EXPECT_EQ(*t1.getKeyword(), "module"sv);
}
