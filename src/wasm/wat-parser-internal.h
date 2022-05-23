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

// Usage note
// ----------
//
// This parser is a work in progress and this file should not yet be included
// anywhere except for in its own tests. Once the parser is usable, we will add
// wat-parser.h to declare the public parsing API and wat-parser.cpp to
// implement the public parsing functions in terms of the private API in this
// header. The private API will stay in this header rather than moving to
// wat-parser.cpp so that we can continue to unit test it.

#include <cassert>
#include <cctype>
#include <iostream>
#include <optional>
#include <variant>

using namespace std::string_view_literals;

namespace wasm::WATParser {

namespace {

// ================
// Lexical Analysis
// ================

// The result of lexing a token fragment.
struct LexResult {
  std::string_view span;
};

// Lexing context that accumulates lexed input to produce a token fragment.
struct LexCtx {
private:
  // The input we are lexing.
  std::string_view input;

  // How much of the input we have already lexed.
  size_t lexedSize = 0;

public:
  explicit LexCtx(std::string_view in) : input(in) {}

  // Return the fragment that has been lexed so far.
  std::optional<LexResult> lexed() const {
    if (lexedSize > 0) {
      return {LexResult{input.substr(0, lexedSize)}};
    }
    return {};
  }

  // The next input that has not already been lexed.
  std::string_view next() const { return input.substr(lexedSize); }

  // The size of the unlexed input.
  size_t size() const { return input.size() - lexedSize; }

  // Whether there is no more input.
  bool empty() const { return size() == 0; }

  // Tokens must be separated by spaces or parentheses.
  bool can_finish() const;

  // Whether the unlexed input starts with prefix `sv`.
  size_t starts_with(std::string_view sv) const {
    return next().substr(0, sv.size()) == sv;
  }

  // Consume the next `n` characters.
  void take(size_t n) { lexedSize += n; }

  // Consume an additional lexed fragment.
  void take(const LexResult& res) { lexedSize += res.span.size(); }

  // Consume the prefix and return true if possible.
  bool take_prefix(std::string_view sv) {
    if (starts_with(sv)) {
      take(sv.size());
      return true;
    }
    return false;
  }

  // Consume the rest of the input.
  void take_all() { lexedSize = input.size(); }
};

// The result of lexing an integer token fragment.
struct LexIntResult : LexResult {
  uint64_t n;
  bool hasSign;
};

// Lexing context that accumulates lexed input to produce an integer token
// fragment.
struct LexIntCtx : LexCtx {
  using LexCtx::take;

private:
  uint64_t n = 0;
  bool hasSign = false;
  bool negative = false;
  bool overflow = false;

  std::optional<int> getDigit(char c) {
    if ('0' <= c && c <= '9') {
      return {c - '0'};
    }
    return {};
  }

  std::optional<int> getHexDigit(char c) {
    if ('0' <= c && c <= '9') {
      return {c - '0'};
    }
    if ('A' <= c && c <= 'F') {
      return {10 + c - 'A'};
    }
    if ('a' <= c && c <= 'f') {
      return {10 + c - 'a'};
    }
    return {};
  }

public:
  explicit LexIntCtx(std::string_view in) : LexCtx(in) {}

  std::optional<LexIntResult> lexed() {
    // Check most significant bit for underflow if we will have to negate.
    if (overflow || (negative && (n & (1ull << 63)))) {
      return {};
    }
    if (auto basic = LexCtx::lexed()) {
      return {LexIntResult{*basic, negative ? -n : n, hasSign}};
    }
    return {};
  }

  void take_sign() {
    if (take_prefix("+"sv)) {
      hasSign = true;
    } else if (take_prefix("-"sv)) {
      hasSign = true;
      negative = true;
    }
  }

  bool take_digit() {
    if (!empty()) {
      if (auto d = getDigit(next()[0])) {
        take(1);
        uint64_t newN = n * 10 + *d;
        if (newN < n) {
          overflow = true;
        }
        n = newN;
        return true;
      }
    }
    return false;
  }

  bool take_hexdigit() {
    if (!empty()) {
      if (auto h = getHexDigit(next()[0])) {
        take(1);
        uint64_t newN = n * 16 + *h;
        if (newN < n) {
          overflow = true;
        }
        n = newN;
        return true;
      }
    }
    return false;
  }

  void take(const LexIntResult& res) {
    LexCtx::take(res);
    n = res.n;
  }
};

std::optional<LexResult> lparen(std::string_view in) {
  LexCtx ctx(in);
  ctx.take_prefix("("sv);
  return ctx.lexed();
}

std::optional<LexResult> rparen(std::string_view in) {
  LexCtx ctx(in);
  ctx.take_prefix(")"sv);
  return ctx.lexed();
}

// comment      ::= linecomment | blockcomment
// linecomment  ::= ';;' linechar* ('\n' | eof)
// linechar     ::= c:char                      (if c != '\n')
// blockcomment ::= '(;' blockchar* ';)'
// blockchar    ::= c:char                      (if c != ';' and c != '(')
//                | ';'                         (if the next char is not ')')
//                | '('                         (if the next char is not ';')
//                | blockcomment
std::optional<LexResult> comment(std::string_view in) {
  LexCtx ctx(in);
  if (ctx.size() < 2) {
    return {};
  }

  // Line comment
  if (ctx.take_prefix(";;"sv)) {
    if (auto size = ctx.next().find('\n'); size != ""sv.npos) {
      ctx.take(size);
    } else {
      ctx.take_all();
    }
    return ctx.lexed();
  }

  // Block comment (possibly nested!)
  if (ctx.take_prefix("(;"sv)) {
    size_t depth = 1;
    while (depth > 0 && ctx.size() >= 2) {
      if (ctx.take_prefix("(;"sv)) {
        ++depth;
      } else if (ctx.take_prefix(";)"sv)) {
        --depth;
      } else {
        ctx.take(1);
      }
    }
    if (depth > 0) {
      // TODO: Add error production for non-terminated block comment.
      return {};
    }
    return ctx.lexed();
  }

  return {};
}

std::optional<LexResult> spacechar(std::string_view in) {
  LexCtx ctx(in);
  ctx.take_prefix(" "sv) || ctx.take_prefix("\n"sv) ||
    ctx.take_prefix("\r"sv) || ctx.take_prefix("\t"sv);
  return ctx.lexed();
}

// space  ::= (' ' | format | comment)*
// format ::= '\t' | '\n' | '\r'
std::optional<LexResult> space(std::string_view in) {
  LexCtx ctx(in);
  while (ctx.size()) {
    if (auto lexed = spacechar(ctx.next())) {
      ctx.take(*lexed);
    } else if (auto lexed = comment(ctx.next())) {
      ctx.take(*lexed);
    } else {
      break;
    }
  }
  return ctx.lexed();
}

bool LexCtx::can_finish() const {
  // Logically we want to check for eof, parens, and space. But we don't
  // actually want to parse more than a couple characters of space, so check for
  // individual space chars or comment starts instead.
  return empty() || lparen(next()) || rparen(next()) || spacechar(next()) ||
         starts_with(";;"sv);
}

// num   ::= d:digit => d
//         |  n:num '_'? d:digit => 10*n + d
// digit ::= '0' => 0 | ... | '9' => 9
std::optional<LexIntResult> num(std::string_view in) {
  LexIntCtx ctx(in);
  if (!ctx.take_digit()) {
    return {};
  }
  while (true) {
    bool under = ctx.take_prefix("_"sv);
    if (!ctx.take_digit()) {
      if (!under && ctx.can_finish()) {
        return ctx.lexed();
      }
      return {};
    }
  }
}

// hexnum   ::= h:hexdigit => h
//            | n:hexnum '_'? h:hexdigit => 16*n + h
// hexdigit ::= d:digit => d
//            | 'A' => 10 | ... | 'F' => 15
//            | 'a' => 10 | ... | 'f' => 15
std::optional<LexIntResult> hexnum(std::string_view in) {
  LexIntCtx ctx(in);
  if (!ctx.take_hexdigit()) {
    return {};
  }
  while (true) {
    bool under = ctx.take_prefix("_"sv);
    if (!ctx.take_hexdigit()) {
      if (!under && ctx.can_finish()) {
        return ctx.lexed();
      }
      return {};
    }
  }
}

// uN ::= n:num         => n (if n < 2^N)
//      | '0x' n:hexnum => n (if n < 2^N)
// sN ::= s:sign n:num         => [s]n (if -2^(N-1) <= [s]n < 2^(N-1))
//      | s:sign '0x' n:hexnum => [s]n (if -2^(N-1) <= [s]n < 2^(N-1))
// sign ::= {} => + | '+' => + | '-' => -
//
// Note: Defer bounds and sign checking until we know what kind of integer we
// expect.
std::optional<LexIntResult> integer(std::string_view in) {
  LexIntCtx ctx(in);
  ctx.take_sign();
  if (ctx.take_prefix("0x"sv)) {
    if (auto lexed = hexnum(ctx.next())) {
      ctx.take(*lexed);
      return ctx.lexed();
    }
    // TODO: Add error production for unrecognized hexnum.
    return {};
  }
  if (auto lexed = num(ctx.next())) {
    ctx.take(*lexed);
    return ctx.lexed();
  }
  return {};
}

// ======
// Tokens
// ======

struct LParenTok {
  friend std::ostream& operator<<(std::ostream& os, const LParenTok&) {
    return os << "'('";
  }
};

struct RParenTok {
  friend std::ostream& operator<<(std::ostream& os, const RParenTok&) {
    return os << "')'";
  }
};

struct IntTok {
  uint64_t n;
  bool hasSign;
  friend std::ostream& operator<<(std::ostream& os, const IntTok& tok) {
    return os << tok.n << " sign: " << tok.hasSign;
  }
};

struct Token {
  using Data = std::variant<LParenTok, RParenTok, IntTok>;

  std::string_view span;
  Data data;

  bool operator==(const Token& other) const { return span == other.span; }
  bool operator!=(const Token& other) const { return !(*this == other); }

  // Suppress clang-tidy false positive about unused functions.
  [[maybe_unused]] friend std::ostream& operator<<(std::ostream& os,
                                                   const Token& tok) {
    std::visit([&](const auto& t) { os << t; }, tok.data);
    return os << " \"" << tok.span << "\"";
  }
};

struct TextPos {
  size_t line;
  size_t col;

  bool operator==(const TextPos& other) const {
    return line == other.line && col == other.col;
  }
  bool operator!=(const TextPos& other) const { return !(*this == other); }

  // Suppress clang-tidy false positive about unused functions.
  [[maybe_unused]] friend std::ostream& operator<<(std::ostream& os,
                                                   const TextPos& pos) {
    return os << pos.line << ":" << pos.col;
  }
};

// Lexer's purpose is twofold. First, it wraps a buffer to provide a tokenizing
// iterator over it. Second, it implements that iterator itself. Also provides
// utilities for locating the text position of tokens within the buffer. Text
// positions are computed on demand rather than eagerly because they are
// typically only needed when there is an error to report.
struct Lexer {
  using iterator = Lexer;
  using difference_type = std::ptrdiff_t;
  using value_type = Token;
  using pointer = const Token*;
  using reference = const Token&;
  using iterator_category = std::forward_iterator_tag;

  std::string_view buffer;
  size_t index = 0;
  std::optional<Token> curr;

  // The end sentinel.
  Lexer() = default;

  Lexer(std::string_view buffer) : buffer(buffer) {
    skipSpace();
    lexToken();
    skipSpace();
  }

  std::string_view next() const { return buffer.substr(index); }

  void skipSpace() {
    if (auto ctx = space(next())) {
      index += ctx->span.size();
    }
  }

  void lexToken() {
    // TODO: Ensure we're getting the longest possible match.
    Token tok;
    if (auto t = lparen(next())) {
      tok = Token{t->span, LParenTok{}};
    } else if (auto t = rparen(next())) {
      tok = Token{t->span, RParenTok{}};
    } else if (auto t = integer(next())) {
      tok = Token{t->span, IntTok{t->n, t->hasSign}};
    } else {
      // TODO: Do something about lexing errors.
      curr = std::nullopt;
      return;
    }
    index += tok.span.size();
    curr = {tok};
  }

  Lexer& operator++() {
    // Preincrement
    lexToken();
    skipSpace();
    return *this;
  }

  Lexer operator++(int) {
    // Postincrement
    Lexer ret = *this;
    ++(*this);
    return ret;
  }

  const Token& operator*() { return *curr; }
  const Token& operator->() { return *curr; }

  bool operator==(const Lexer& other) const {
    // The iterator is equal to the end sentinel when there is no current token.
    if (!curr && !other.curr) {
      return true;
    }
    // Otherwise they are equivalent when they are at the same position.
    return index == other.index;
  }

  bool operator!=(const Lexer& other) const { return !(*this == other); }

  Lexer begin() { return *this; }

  Lexer end() { return Lexer(); }

  TextPos position(const char* c) {
    assert(size_t(c - buffer.data()) < buffer.size());
    TextPos pos{1, 0};
    for (const char* p = buffer.data(); p != c; ++p) {
      if (*p == '\n') {
        pos.line++;
        pos.col = 0;
      } else {
        pos.col++;
      }
    }
    return pos;
  }

  TextPos position(std::string_view span) { return position(span.data()); }

  TextPos position(Token tok) { return position(tok.span); }
};

} // anonymous namespace

} // namespace wasm::WATParser
