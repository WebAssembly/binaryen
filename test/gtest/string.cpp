#include <sstream>

#include "support/string.h"
#include "gtest/gtest.h"

using namespace wasm;

using StringTest = ::testing::Test;

namespace {

std::string escapeJS(std::string_view str) {
  std::stringstream ss;
  String::printEscapedJS(ss, str);
  return ss.str();
}

} // anonymous namespace

TEST_F(StringTest, PrintEscapedJSPlain) {
  EXPECT_EQ(escapeJS(""), "");
  EXPECT_EQ(escapeJS("env"), "env");
  EXPECT_EQ(escapeJS("wasi_snapshot_preview1"), "wasi_snapshot_preview1");
}

TEST_F(StringTest, PrintEscapedJSQuotes) {
  // Both quote characters are escaped so the result is safe in either a
  // single- or double-quoted literal.
  EXPECT_EQ(escapeJS("it's"), "it\\'s");
  EXPECT_EQ(escapeJS("say \"hi\""), "say \\\"hi\\\"");
  EXPECT_EQ(escapeJS("mixed'and\"quotes"), "mixed\\'and\\\"quotes");
}

TEST_F(StringTest, PrintEscapedJSBackslash) {
  EXPECT_EQ(escapeJS("a\\b"), "a\\\\b");
  // A backslash followed by a quote must not collapse into a lone escape.
  EXPECT_EQ(escapeJS("\\'"), "\\\\\\'");
}

TEST_F(StringTest, PrintEscapedJSNewlines) {
  EXPECT_EQ(escapeJS("line1\nline2"), "line1\\nline2");
  EXPECT_EQ(escapeJS("line1\r\nline2"), "line1\\r\\nline2");
}

TEST_F(StringTest, PrintEscapedJSLineSeparators) {
  // U+2028 and U+2029 are valid unescaped in JSON strings but are line
  // terminators in JavaScript, so they must be escaped.
  EXPECT_EQ(escapeJS("a\xE2\x80\xA8"
                     "b"),
            "a\\u2028b");
  EXPECT_EQ(escapeJS("a\xE2\x80\xA9"
                     "b"),
            "a\\u2029b");
  // Other characters in the same UTF-8 range pass through unchanged.
  EXPECT_EQ(escapeJS("a\xE2\x80\xA6"
                     "b"),
            "a\xE2\x80\xA6"
            "b");
  // A truncated sequence at the end of the string is passed through
  // byte-by-byte rather than read out of bounds.
  EXPECT_EQ(escapeJS("\xE2\x80"), "\xE2\x80");
}

TEST_F(StringTest, PrintEscapedJSNonASCII) {
  // Non-ASCII UTF-8 is passed through unmodified.
  EXPECT_EQ(escapeJS("m\xC3\xB3"
                     "dulo"),
            "m\xC3\xB3"
            "dulo");
}
