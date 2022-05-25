#include "gtest/gtest.h"

#include "wat-parser-internal.h"

using namespace wasm::WATParser;

TEST(ParserTest, LexWhitespace) {
  Token one{"1"sv, IntTok{1, Unsigned}};
  Token two{"2"sv, IntTok{2, Unsigned}};
  Token three{"3"sv, IntTok{3, Unsigned}};
  Token four{"4"sv, IntTok{4, Unsigned}};
  Token five{"5"sv, IntTok{5, Unsigned}};

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

TEST(ParserTest, LexLineComment) {
  Token one{"1"sv, IntTok{1, Unsigned}};
  Token six{"6"sv, IntTok{6, Unsigned}};

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

TEST(ParserTest, LexBlockComment) {
  Token one{"1"sv, IntTok{1, Unsigned}};
  Token six{"6"sv, IntTok{6, Unsigned}};

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

TEST(ParserTest, LexParens) {
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
}

TEST(ParserTest, LexInt) {
  {
    Lexer lexer("0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0"sv, IntTok{0, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0"sv, IntTok{0, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0"sv, IntTok{0, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"1"sv, IntTok{1, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+1"sv, IntTok{1, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-1"sv, IntTok{-1ull, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0010"sv, IntTok{10, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0010"sv, IntTok{10, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0010"sv, IntTok{-10ull, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("9999"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"9999"sv, IntTok{9999, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+9999"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+9999"sv, IntTok{9999, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-9999"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-9999"sv, IntTok{-9999ull, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("12_34"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"12_34"sv, IntTok{1234, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("1_2_3_4"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"1_2_3_4"sv, IntTok{1234, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("_1234"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("1234_"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("12__34"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("12cd56"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("18446744073709551615"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"18446744073709551615"sv, IntTok{-1ull, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // 64-bit unsigned overflow!
    Lexer lexer("18446744073709551616");
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("+9223372036854775807"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+9223372036854775807"sv, IntTok{~(1ull << 63), Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // 64-bit signed overflow!
    Lexer lexer("+9223372036854775808"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("-9223372036854775808"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-9223372036854775808"sv, IntTok{1ull << 63, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // 64-bit signed underflow!
    Lexer lexer("-9223372036854775809"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
}

TEST(ParserTest, LexHexInt) {
  {
    Lexer lexer("0x0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x0"sv, IntTok{0, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0x0"sv, IntTok{0, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0x0"sv, IntTok{0, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x1"sv, IntTok{1, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0x1"sv, IntTok{1, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0x1"sv, IntTok{-1ull, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x0010"sv, IntTok{16, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0x0010"sv, IntTok{16, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0x0010"sv, IntTok{-16ull, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0xabcdef"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0xabcdef"sv, IntTok{0xabcdef, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0xABCDEF"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0xABCDEF"sv, IntTok{0xabcdef, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0xAbCdEf"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0xAbCdEf"sv, IntTok{-0xabcdefull, Signed}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x12_34"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x12_34"sv, IntTok{0x1234, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x1_2_3_4"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x1_2_3_4"sv, IntTok{0x1234, Unsigned}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("_0x1234"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("0x_1234"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("0x1234_"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("0x12__34"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("0xg"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("0x120x34"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
}
