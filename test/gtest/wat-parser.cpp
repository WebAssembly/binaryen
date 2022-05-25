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

TEST(ParserTest, LexIdent) {
  {
    Lexer lexer("$09azAZ!#$%&'*+-./:<=>?@\\^_`|~"sv);
    ASSERT_NE(lexer, lexer.end());
    Token expected{"$09azAZ!#$%&'*+-./:<=>?@\\^_`|~"sv, IdTok{}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("$[]{}"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("$abc[]"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("$"sv);
    EXPECT_EQ(lexer, lexer.end());
  }
}

TEST(ParserTest, LexString) {
  {
    auto pangram = "\"The quick brown fox jumps over the lazy dog\""sv;
    Lexer lexer(pangram);
    ASSERT_NE(lexer, lexer.end());
    Token expected{pangram, StringTok{{}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    auto chars = "\"`~!@#$%^&*()_-+0123456789|,.<>/?;:'\""sv;
    Lexer lexer(chars);
    ASSERT_NE(lexer, lexer.end());
    Token expected{chars, StringTok{{}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    auto escapes = "\"_\\t_\\n_\\r_\\\\_\\\"_\\'_\""sv;
    Lexer lexer(escapes);
    ASSERT_NE(lexer, lexer.end());
    Token expected{escapes, StringTok{{"_\t_\n_\r_\\_\"_'_"}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    auto escapes = "\"_\\00_\\07_\\20_\\5A_\\7F_\\ff_\\ffff_\""sv;
    Lexer lexer(escapes);
    ASSERT_NE(lexer, lexer.end());
    std::string escaped{"_\0_\7_ _Z_\x7f_\xff_\xff"
                        "ff_"sv};
    Token expected{escapes, StringTok{{escaped}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // _$_£_€_𐍈_
    auto unicode = "\"_\\u{24}_\\u{00a3}_\\u{20AC}_\\u{10348}_\""sv;
    Lexer lexer(unicode);
    ASSERT_NE(lexer, lexer.end());
    std::string escaped{"_$_\xC2\xA3_\xE2\x82\xAC_\xF0\x90\x8D\x88_"};
    Token expected{unicode, StringTok{{escaped}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    // _$_£_€_𐍈_
    auto unicode = "\"_$_\xC2\xA3_\xE2\x82\xAC_\xF0\x90\x8D\x88_\""sv;
    Lexer lexer(unicode);
    ASSERT_NE(lexer, lexer.end());
    Token expected{unicode, StringTok{{}}};
    EXPECT_EQ(*lexer, expected);
  }
  {
    Lexer lexer("\"unterminated"sv);
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"unescaped nul\0\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"unescaped U+19\x19\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"unescaped U+7f\x7f\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"\\ stray backslash\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"short \\f hex escape\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"bad hex \\gg\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"empty unicode \\u{}\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"not unicode \\u{abcdefg}\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"extra chars \\u{123(}\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"unpaired surrogate unicode crimes \\u{d800}\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"more surrogate unicode crimes \\u{dfff}\"");
    ASSERT_EQ(lexer, lexer.end());
  }
  {
    Lexer lexer("\"too big \\u{110000}\"");
    ASSERT_EQ(lexer, lexer.end());
  }
}

TEST(ParserTest, LexKeywords) {
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
}
