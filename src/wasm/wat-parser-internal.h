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
#include <sstream>
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

  // Get the next character without consuming it.
  uint8_t peek() const { return next()[0]; }

  // The size of the unlexed input.
  size_t size() const { return input.size() - lexedSize; }

  // Whether there is no more input.
  bool empty() const { return size() == 0; }

  // Tokens must be separated by spaces or parentheses.
  bool canFinish() const;

  // Whether the unlexed input starts with prefix `sv`.
  size_t startsWith(std::string_view sv) const {
    return next().substr(0, sv.size()) == sv;
  }

  // Consume the next `n` characters.
  void take(size_t n) { lexedSize += n; }

  // Consume an additional lexed fragment.
  void take(const LexResult& res) { lexedSize += res.span.size(); }

  // Consume the prefix and return true if possible.
  bool takePrefix(std::string_view sv) {
    if (startsWith(sv)) {
      take(sv.size());
      return true;
    }
    return false;
  }

  // Consume the rest of the input.
  void takeAll() { lexedSize = input.size(); }
};

enum Signedness { Unsigned, Signed };

// The result of lexing an integer token fragment.
struct LexIntResult : LexResult {
  uint64_t n;
  Signedness signedness;
};

// Lexing context that accumulates lexed input to produce an integer token
// fragment.
struct LexIntCtx : LexCtx {
  using LexCtx::take;

private:
  uint64_t n = 0;
  Signedness signedness = Unsigned;
  bool negative = false;
  bool overflow = false;

  std::optional<int> getDigit(char c) {
    if ('0' <= c && c <= '9') {
      return {c - '0'};
    }
    return std::nullopt;
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
    return std::nullopt;
  }

public:
  explicit LexIntCtx(std::string_view in) : LexCtx(in) {}

  std::optional<LexIntResult> lexed() {
    // Check most significant bit for overflow of signed numbers.
    if (overflow) {
      return {};
    }
    auto basic = LexCtx::lexed();
    if (!basic) {
      return {};
    }
    if (signedness == Signed) {
      if (negative) {
        if (n > (1ull << 63)) {
          // TODO: Add error production for signed underflow.
          return {};
        }
      } else {
        if (n > (1ull << 63) - 1) {
          // TODO: Add error production for signed overflow.
          return {};
        }
      }
    }
    return {LexIntResult{*basic, negative ? -n : n, signedness}};
  }

  void takeSign() {
    if (takePrefix("+"sv)) {
      signedness = Signed;
    } else if (takePrefix("-"sv)) {
      signedness = Signed;
      negative = true;
    }
  }

  bool takeDigit() {
    if (!empty()) {
      if (auto d = getDigit(peek())) {
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

  bool takeHexdigit() {
    if (!empty()) {
      if (auto h = getHexDigit(peek())) {
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

struct LexStrResult : LexResult {
  // Allocate a string only if there are escape sequences, otherwise just use
  // the original string_view.
  std::optional<std::string> str;
};

struct LexStrCtx : LexCtx {
private:
  // Whether we are building a string due to the presence of escape
  // sequences.
  bool building = false;
  std::stringstream ss;

public:
  LexStrCtx(std::string_view in) : LexCtx(in) {}

  std::optional<LexStrResult> lexed() {
    if (auto basic = LexCtx::lexed()) {
      auto str = building ? std::optional<std::string>{ss.str()} : std::nullopt;
      return {LexStrResult{*basic, str}};
    }
    return {};
  }

  void takeChar() {
    if (building) {
      ss << peek();
    }
    LexCtx::take(1);
  }

  void ensureBuilding() {
    if (building) {
      return;
    }
    // Drop the opening '"'.
    ss << LexCtx::lexed()->span.substr(1);
    building = true;
  }

  void appendEscaped(char c) { ss << c; }

  bool appendUnicode(uint64_t u) {
    if ((0xd800 <= u && u < 0xe000) || 0x110000 <= u) {
      return false;
    }
    if (u < 0x80) {
      // 0xxxxxxx
      ss << uint8_t(u);
    } else if (u < 0x800) {
      // 110xxxxx 10xxxxxx
      ss << uint8_t(0b11000000 | ((u >> 6) & 0b00011111));
      ss << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
    } else if (u < 0x10000) {
      // 1110xxxx 10xxxxxx 10xxxxxx
      ss << uint8_t(0b11100000 | ((u >> 12) & 0b00001111));
      ss << uint8_t(0b10000000 | ((u >> 6) & 0b00111111));
      ss << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
    } else {
      // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
      ss << uint8_t(0b11110000 | ((u >> 18) & 0b00000111));
      ss << uint8_t(0b10000000 | ((u >> 12) & 0b00111111));
      ss << uint8_t(0b10000000 | ((u >> 6) & 0b00111111));
      ss << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
    }
    return true;
  }
};

std::optional<LexResult> lparen(std::string_view in) {
  LexCtx ctx(in);
  ctx.takePrefix("("sv);
  return ctx.lexed();
}

std::optional<LexResult> rparen(std::string_view in) {
  LexCtx ctx(in);
  ctx.takePrefix(")"sv);
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
  if (ctx.takePrefix(";;"sv)) {
    if (auto size = ctx.next().find('\n'); size != ""sv.npos) {
      ctx.take(size);
    } else {
      ctx.takeAll();
    }
    return ctx.lexed();
  }

  // Block comment (possibly nested!)
  if (ctx.takePrefix("(;"sv)) {
    size_t depth = 1;
    while (depth > 0 && ctx.size() >= 2) {
      if (ctx.takePrefix("(;"sv)) {
        ++depth;
      } else if (ctx.takePrefix(";)"sv)) {
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
  ctx.takePrefix(" "sv) || ctx.takePrefix("\n"sv) || ctx.takePrefix("\r"sv) ||
    ctx.takePrefix("\t"sv);
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

bool LexCtx::canFinish() const {
  // Logically we want to check for eof, parens, and space. But we don't
  // actually want to parse more than a couple characters of space, so check for
  // individual space chars or comment starts instead.
  return empty() || lparen(next()) || rparen(next()) || spacechar(next()) ||
         startsWith(";;"sv);
}

// num   ::= d:digit => d
//         |  n:num '_'? d:digit => 10*n + d
// digit ::= '0' => 0 | ... | '9' => 9
std::optional<LexIntResult> num(std::string_view in) {
  LexIntCtx ctx(in);
  if (!ctx.takeDigit()) {
    return {};
  }
  while (true) {
    bool under = ctx.takePrefix("_"sv);
    if (!ctx.takeDigit()) {
      if (!under) {
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
  if (!ctx.takeHexdigit()) {
    return {};
  }
  while (true) {
    bool under = ctx.takePrefix("_"sv);
    if (!ctx.takeHexdigit()) {
      if (!under) {
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
  ctx.takeSign();
  if (ctx.takePrefix("0x"sv)) {
    if (auto lexed = hexnum(ctx.next())) {
      ctx.take(*lexed);
      if (ctx.canFinish()) {
        return ctx.lexed();
      }
    }
    // TODO: Add error production for unrecognized hexnum.
    return {};
  }
  if (auto lexed = num(ctx.next())) {
    ctx.take(*lexed);
    if (ctx.canFinish()) {
      return ctx.lexed();
    }
  }
  return {};
}

// idchar ::= '0' | ... | '9'
//          | 'A' | ... | 'Z'
//          | 'a' | ... | 'z'
//          | '!' | '#' | '$' | '%' | '&' | ''' | '*' | '+'
//          | '-' | '.' | '/' | ':' | '<' | '=' | '>' | '?'
//          | '@' | '\' | '^' | '_' | '`' | '|' | '~'
std::optional<LexResult> idchar(std::string_view in) {
  LexCtx ctx(in);
  if (ctx.empty()) {
    return {};
  }
  uint8_t c = ctx.peek();
  if (('0' <= c && c <= '9') || ('A' <= c && c <= 'Z') ||
      ('a' <= c && c <= 'z')) {
    ctx.take(1);
  } else {
    switch (c) {
      case '!':
      case '#':
      case '$':
      case '%':
      case '&':
      case '\'':
      case '*':
      case '+':
      case '-':
      case '.':
      case '/':
      case ':':
      case '<':
      case '=':
      case '>':
      case '?':
      case '@':
      case '\\':
      case '^':
      case '_':
      case '`':
      case '|':
      case '~':
        ctx.take(1);
    }
  }
  return ctx.lexed();
}

// id ::= '$' idchar+
std::optional<LexResult> ident(std::string_view in) {
  LexCtx ctx(in);
  if (!ctx.takePrefix("$"sv)) {
    return {};
  }
  if (auto lexed = idchar(ctx.next())) {
    ctx.take(*lexed);
  } else {
    return {};
  }
  while (auto lexed = idchar(ctx.next())) {
    ctx.take(*lexed);
  }
  if (ctx.canFinish()) {
    return ctx.lexed();
  }
  return {};
}

// string     ::= '"' (b*:stringelem)* '"'  => concat((b*)*)
//                    (if |concat((b*)*)| < 2^32)
// stringelem ::= c:stringchar              => utf8(c)
//              | '\' n:hexdigit m:hexdigit => 16*n + m
// stringchar ::= c:char                    => c
//                    (if c >= U+20 && c != U+7f && c != '"' && c != '\')
//              | '\t' => \t | '\n' => \n | '\r' => \r
//              | '\\' => \ | '\"' => " | '\'' => '
//              | '\u{' n:hexnum '}'        => U+(n)
//                    (if n < 0xD800 and 0xE000 <= n <= 0x110000)
std::optional<LexStrResult> str(std::string_view in) {
  LexStrCtx ctx(in);
  if (!ctx.takePrefix("\""sv)) {
    return {};
  }
  while (!ctx.takePrefix("\""sv)) {
    if (ctx.empty()) {
      // TODO: Add error production for unterminated string.
      return {};
    }
    if (ctx.startsWith("\\"sv)) {
      // Escape sequences
      ctx.ensureBuilding();
      ctx.take(1);
      if (ctx.takePrefix("t"sv)) {
        ctx.appendEscaped('\t');
      } else if (ctx.takePrefix("n"sv)) {
        ctx.appendEscaped('\n');
      } else if (ctx.takePrefix("r"sv)) {
        ctx.appendEscaped('\r');
      } else if (ctx.takePrefix("\\"sv)) {
        ctx.appendEscaped('\\');
      } else if (ctx.takePrefix("\""sv)) {
        ctx.appendEscaped('"');
      } else if (ctx.takePrefix("'"sv)) {
        ctx.appendEscaped('\'');
      } else if (ctx.takePrefix("u{"sv)) {
        auto lexed = hexnum(ctx.next());
        if (!lexed) {
          // TODO: Add error production for malformed unicode escapes.
          return {};
        }
        ctx.take(*lexed);
        if (!ctx.takePrefix("}"sv)) {
          // TODO: Add error production for malformed unicode escapes.
          return {};
        }
        if (!ctx.appendUnicode(lexed->n)) {
          // TODO: Add error production for invalid unicode values.
          return {};
        }
      } else {
        LexIntCtx ictx(ctx.next());
        if (!ictx.takeHexdigit() || !ictx.takeHexdigit()) {
          // TODO: Add error production for unrecognized escape sequence.
          return {};
        }
        auto lexed = *ictx.lexed();
        ctx.take(lexed);
        ctx.appendEscaped(char(lexed.n));
      }
    } else {
      // Normal characters
      if (uint8_t c = ctx.peek(); c >= 0x20 && c != 0x7F) {
        ctx.takeChar();
      } else {
        // TODO: Add error production for unescaped control characters.
        return {};
      }
    }
  }
  return ctx.lexed();
}

// keyword ::= ( 'a' | ... | 'z' ) idchar* (if literal terminal in grammar)
// reserved ::= idchar+
//
// The "keyword" token we lex here covers both keywords as well as any reserved
// tokens that match the keyword format. This saves us from having to enumerate
// all the valid keywords here. These invalid keywords will still produce
// errors, just at a higher level of the parser.
std::optional<LexResult> keyword(std::string_view in) {
  LexCtx ctx(in);
  if (ctx.empty()) {
    return {};
  }
  uint8_t start = ctx.peek();
  if ('a' <= start && start <= 'z') {
    ctx.take(1);
  } else {
    return {};
  }
  while (auto lexed = idchar(ctx.next())) {
    ctx.take(*lexed);
  }
  return ctx.lexed();
}

// ======
// Tokens
// ======

struct LParenTok {
  friend std::ostream& operator<<(std::ostream& os, const LParenTok&) {
    return os << "'('";
  }

  friend bool operator==(const LParenTok&, const LParenTok&) { return true; }
};

struct RParenTok {
  friend std::ostream& operator<<(std::ostream& os, const RParenTok&) {
    return os << "')'";
  }

  friend bool operator==(const RParenTok&, const RParenTok&) { return true; }
};

struct IntTok {
  uint64_t n;
  Signedness signedness;

  friend std::ostream& operator<<(std::ostream& os, const IntTok& tok) {
    return os << tok.n << (tok.signedness == Signed ? " signed" : " unsigned");
  }

  friend bool operator==(const IntTok& t1, const IntTok& t2) {
    return t1.n == t2.n && t1.signedness == t2.signedness;
  }
};

struct IdTok {
  friend std::ostream& operator<<(std::ostream& os, const IdTok&) {
    return os << "id";
  }

  friend bool operator==(const IdTok&, const IdTok&) { return true; }
};

struct StringTok {
  std::optional<std::string> str;

  friend std::ostream& operator<<(std::ostream& os, const StringTok& tok) {
    if (tok.str) {
      os << '"' << *tok.str << '"';
    } else {
      os << "(raw string)";
    }
    return os;
  }

  friend bool operator==(const StringTok& t1, const StringTok& t2) {
    return t1.str == t2.str;
  }
};

struct KeywordTok {
  friend std::ostream& operator<<(std::ostream& os, const KeywordTok&) {
    return os << "keyword";
  }

  friend bool operator==(const KeywordTok&, const KeywordTok&) { return true; }
};

struct Token {
  using Data =
    std::variant<LParenTok, RParenTok, IntTok, IdTok, StringTok, KeywordTok>;

  std::string_view span;
  Data data;

  // Suppress clang-tidy false positive about unused functions.
  [[maybe_unused]] friend std::ostream& operator<<(std::ostream& os,
                                                   const Token& tok) {
    std::visit([&](const auto& t) { os << t; }, tok.data);
    return os << " \"" << tok.span << "\"";
  }

  [[maybe_unused]] friend bool operator==(const Token& t1, const Token& t2) {
    return t1.span == t2.span &&
           std::visit(
             [](auto& d1, auto& d2) {
               if constexpr (std::is_same_v<decltype(d1), decltype(d2)>) {
                 return d1 == d2;
               } else {
                 return false;
               }
             },
             t1.data,
             t2.data);
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
    } else if (auto t = ident(next())) {
      tok = Token{t->span, IdTok{}};
    } else if (auto t = integer(next())) {
      tok = Token{t->span, IntTok{t->n, t->signedness}};
    } else if (auto t = str(next())) {
      tok = Token{t->span, StringTok{t->str}};
    } else if (auto t = keyword(next())) {
      tok = Token{t->span, KeywordTok{}};
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
  const Token* operator->() { return &*curr; }

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
