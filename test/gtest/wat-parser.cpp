#include "gtest/gtest.h"

#include "wat-parser-internal.h"

using namespace wasm::WATParser;

TEST(ParserTest, LexWhitespace) {
  Token expected{"42"sv, IntTok{42, false}};

  Lexer lexer(" 42\t42\n42\r42 \n\n\t 42 "sv);

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

  EXPECT_EQ(t1, expected);
  EXPECT_EQ(t2, expected);
  EXPECT_EQ(t3, expected);
  EXPECT_EQ(t4, expected);
  EXPECT_EQ(t5, expected);

  EXPECT_EQ(lexer.position(t1), (TextPos{1, 1}));
  EXPECT_EQ(lexer.position(t2), (TextPos{1, 4}));
  EXPECT_EQ(lexer.position(t3), (TextPos{2, 0}));
  EXPECT_EQ(lexer.position(t4), (TextPos{2, 3}));
  EXPECT_EQ(lexer.position(t5), (TextPos{4, 2}));
}

TEST(ParserTest, LexLineComment) {
  Token expected{"42"sv, IntTok{42, false}};

  Lexer lexer("42;; whee! 42 42\t42\r42\n42"sv);

  auto it = lexer.begin();
  Token t1 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t2 = *it++;
  EXPECT_EQ(it, lexer.end());

  EXPECT_EQ(t1, expected);
  EXPECT_EQ(t2, expected);

  EXPECT_EQ(lexer.position(t1), (TextPos{1, 0}));
  EXPECT_EQ(lexer.position(t2), (TextPos{2, 0}));
}

TEST(ParserTest, LexBlockComment) {
  Token expected{"42"sv, IntTok{42, false}};

  Lexer lexer("42(; whoo! 42\n (; \n42\n ;) 42 (;) 42 ;) \n;)42"sv);

  auto it = lexer.begin();
  Token t1 = *it++;
  ASSERT_NE(it, lexer.end());
  Token t2 = *it++;
  EXPECT_EQ(it, lexer.end());

  EXPECT_EQ(t1, expected);
  EXPECT_EQ(t2, expected);

  EXPECT_EQ(lexer.position(t1), (TextPos{1, 0}));
  EXPECT_EQ(lexer.position(t2), (TextPos{5, 2}));
}

TEST(ParserTest, LexInt) {
  {
    Lexer lexer("0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0"sv, IntTok{0, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0"sv, IntTok{0, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0"sv, IntTok{0, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"1"sv, IntTok{1, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+1"sv, IntTok{1, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-1"sv, IntTok{-1ull, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0010"sv, IntTok{10, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0010"sv, IntTok{10, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0010"sv, IntTok{-10ull, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("9999"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"9999"sv, IntTok{9999, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+9999"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+9999"sv, IntTok{9999, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-9999"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-9999"sv, IntTok{-9999ull, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("12_34"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"12_34"sv, IntTok{1234, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("1_2_3_4"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"1_2_3_4"sv, IntTok{1234, false}};
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
    Token expected{"18446744073709551615"sv, IntTok{-1ull, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // 64-bit overflow!
    Lexer lexer("18446744073709551616");
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("-9223372036854775807"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-9223372036854775807"sv, IntTok{(1ull << 63) + 1, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // 64-bit underflow!
    Lexer lexer("-9223372036854775808"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
}

TEST(ParserTest, LexHexInt) {
  {
    Lexer lexer("0x0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x0"sv, IntTok{0, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0x0"sv, IntTok{0, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x0"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0x0"sv, IntTok{0, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x1"sv, IntTok{1, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0x1"sv, IntTok{1, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x1"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0x1"sv, IntTok{-1ull, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x0010"sv, IntTok{16, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0x0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0x0010"sv, IntTok{16, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0x0010"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0x0010"sv, IntTok{-16ull, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0xabcdef"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0xabcdef"sv, IntTok{0xabcdef, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("+0xABCDEF"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"+0xABCDEF"sv, IntTok{0xabcdef, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("-0xAbCdEf"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"-0xAbCdEf"sv, IntTok{-0xabcdefull, true}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x12_34"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x12_34"sv, IntTok{0x1234, false}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("0x1_2_3_4"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"0x1_2_3_4"sv, IntTok{0x1234, false}};
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
    Lexer lexer("0x120x34"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
}
