#include "gtest/gtest.h"

#include "wat-parser-internal.h"

using namespace wasm::WATParser;
using namespace std::string_view_literals;

TEST(ParserTest, Basic) {
  Lexer lexer("(; comment! );");
  EXPECT_EQ(lexer, Lexer{});
}
