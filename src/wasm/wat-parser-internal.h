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

#include <cctype>
#include <optional>
#include <variant>

using namespace std::string_view_literals;

namespace wasm::WATParser {

namespace {

// ================
// Lexical Analysis
// ================

struct LexCtx {
protected:
  std::string_view original;
  size_t index;

public:
  LexCtx(std::string_view str) : original(str), index(0) {}

  // What has been lexed so far.
  std::string_view lexed() const { return original.substr(0, index); }

  // The next input that has not already been lexed.
  std::string_view next() const { return original.substr(index); }

  // The size of the unlexed input.
  size_t size() const { return original.size() - index; }

  // Whether there is no more input.
  bool empty() const { return size() == 0; }

  // Tokens must be separated by spaces or parentheses.
  bool can_finish() const;

  // Whether the unlexed input starts with prefix `sv`.
  size_t starts_with(std::string_view sv) const {
    return next().substr(0, sv.size()) == sv;
  }

  // Consume the prefix and return true if possible.
  bool take_prefix(std::string_view sv) {
    if (starts_with(sv)) {
      *this += sv.size();
      return true;
    }
    return false;
  }

  // Consume the rest of the input.
  void take_all() { index = original.size(); }

  // Whether we have lexed anything.
  operator bool() const { return index > 0; }

  // Consume the next `n` characters.
  LexCtx& operator+=(size_t n) {
    index += n;
    return *this;
  }

  // Consume the result of lexing the unlexed input.
  LexCtx& operator+=(const LexCtx& other) { return *this += other.index; }
};

struct LexIntCtx : LexCtx {
  uint64_t n = 0;
  LexIntCtx(std::string_view str) : LexCtx(str) {}

  LexIntCtx& operator+=(const LexIntCtx& other) {
    index += other.index;
    n = other.n;
    return *this;
  }

  bool take_digit() {
    if (!empty()) {
      if (char d = next()[0]; std::isdigit(d)) {
        n = n * 10 + (d - '0');
        index += 1;
        return true;
      }
    }
    return false;
  }

  bool take_hexdigit() {
    if (!empty()) {
      if (char h = next()[0]; std::isxdigit(h)) {
        n *= 16;
        if (h >= 'a') {
          n += 10 + h - 'a';
        } else if (h >= 'A') {
          n += 10 + h - 'A';
        } else {
          n += h - '0';
        }
        index += 1;
        return true;
      }
    }
    return false;
  }
};

std::optional<LexCtx> lparen(LexCtx ctx) {
  if (ctx.take_prefix("("sv)) {
    return ctx;
  }
  return {};
}

std::optional<LexCtx> rparen(LexCtx ctx) {
  if (ctx.take_prefix(")"sv)) {
    return ctx;
  }
  return {};
}

// comment      ::= linecomment | blockcomment
// linecomment  ::= ';;' linechar* ('\n' | eof)
// linechar     ::= c:char                      (if c != '\n')
// blockcomment ::= '(;' blockchar* ';)'
// blockchar    ::= c:char                      (if c != ';' and c != '(')
//                | ';'                         (if the next char is not ')')
//                | '('                         (if the next char is not ';')
//                | blockcomment
std::optional<LexCtx> comment(LexCtx ctx) {
  if (ctx.size() < 2) {
    return {};
  }

  // Line comment
  if (ctx.take_prefix(";;"sv)) {
    if (auto size = ctx.next().find('\n'); size != ""sv.npos) {
      ctx += size;
    } else {
      ctx.take_all();
    }
    return {ctx};
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
        ctx += 1;
      }
    }
    if (depth > 0) {
      // TODO: Add error production for non-terminated block comment.
      return {};
    }
    return {ctx};
  }

  return {};
}

// space  ::= (' ' | format | comment)*
// format ::= '\t' | '\n' | '\r'
std::optional<LexCtx> space(LexCtx ctx) {
  while (ctx.size()) {
    if (ctx.take_prefix(" "sv) || ctx.take_prefix("\n"sv) ||
        ctx.take_prefix("\r"sv) || ctx.take_prefix("\t"sv)) {
      continue;
    }
    if (auto lexed = comment(ctx.next())) {
      ctx += *lexed;
    } else {
      break;
    }
  }
  if (!ctx) {
    return {};
  }
  return {ctx};
}

bool LexCtx::can_finish() const {
  return empty() || lparen(next()) || rparen(next()) || space(next());
}

// num   ::= d:digit => d
//         |  n:num '_'? d:digit => 10*n + d
// digit ::= '0' => 0 | ... | '9' => 9
std::optional<LexIntCtx> num(LexIntCtx ctx) {
  if (!ctx.take_digit()) {
    return {};
  }
  while (ctx.take_digit() || ctx.take_prefix("_"sv)) {
  }
  if (ctx.can_finish()) {
    return {ctx};
  }
  return {};
}

// hexnum   ::= h:hexdigit => h
//            | n:hexnum '_'? h:hexdigit => 16*n + h
// hexdigit ::= d:digit => d
//            | 'A' => 10 | ... | 'F' => 15
//            | 'a' => 10 | ... | 'f' => 15
std::optional<LexIntCtx> hexnum(LexIntCtx ctx) {
  if (!ctx.take_hexdigit()) {
    return {};
  }
  while (ctx.take_hexdigit() || ctx.take_prefix("_"sv)) {
  }
  if (ctx.can_finish()) {
    return {ctx};
  }
  return {};
}

// uN ::= n:num         => n (if n < 2^N)
//      | '0x' n:hexnum => n (if n < 2^N)
// Note: Defer bounds checking until parsing when we know what N is.
std::optional<LexIntCtx> uN(LexIntCtx ctx) {
  if (ctx.take_prefix("0x"sv)) {
    if (auto lexed = hexnum(ctx.next())) {
      ctx += *lexed;
      return {ctx};
    }
    // TODO: Add error production for unrecognized hexnum.
    return {};
  }
  return num(ctx.next());
}

// sN ::= s:sign n:num         => [s]n (if -2^(N-1) <= [s]n < 2^(N-1))
//      | s:sign '0x' n:hexnum => [s]n (if -2^(N-1) <= [s]n < 2^(N-1))
// sign ::= {} => + | '+' => + | '-' => -
// Note: Defer bounds checking until parsing when we know what N is.
std::optional<LexIntCtx> sN(LexIntCtx ctx) {
  enum Sign { Pos, Neg };
  Sign sign = Pos;
  if (ctx.take_prefix("+"sv)) {
    // nop
  } else if (ctx.take_prefix("-"sv)) {
    sign = Neg;
  }
  std::optional<LexIntCtx> lexed;
  if (ctx.take_prefix("0x"sv)) {
    lexed = hexnum(ctx.next());
    if (!lexed) {
      // TODO: Add error production for unrecognized hexnum.
      return {};
    }
  } else {
    lexed = num(ctx.next());
  }
  if (lexed) {
    ctx += *lexed;
    if (sign == Neg) {
      ctx.n = -ctx.n;
    }
    return {ctx};
  }
  return {};
}

// ======
// Tokens
// ======

struct KeywordTok {};
struct UnsignedTok {
  uint64_t n;
};
struct SignedTok {
  uint64_t n;
};
struct FloatTok {};
struct StringTok {};
struct IdTok {};
struct LParenTok {};
struct RParenTok {};

using TokenData = std::variant<KeywordTok,
                               UnsignedTok,
                               SignedTok,
                               FloatTok,
                               StringTok,
                               IdTok,
                               LParenTok,
                               RParenTok>;

struct Token {
  std::string_view span;
  TokenData data;
};

// A forward iterator over a string_view that produces tokens.
struct Lexer {
  using difference_type = std::ptrdiff_t;
  using value_type = Token;
  using pointer = const Token*;
  using reference = const Token&;
  using iterator_category = std::forward_iterator_tag;

  std::string_view buffer;
  size_t index = 0;
  std::optional<Token> currTok;

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
      index += ctx->lexed().size();
    }
  }

  void lexToken() {
    // TODO: Ensure we're getting the longest possible match.
    if (auto ctx = lparen(next())) {
      currTok = {Token{ctx->lexed(), LParenTok{}}};
    } else if (auto ctx = rparen(next())) {
      currTok = {Token{ctx->lexed(), RParenTok{}}};
    } else if (auto ctx = uN(next())) {
      currTok = {Token{ctx->lexed(), UnsignedTok{ctx->n}}};
    } else if (auto ctx = sN(next())) {
      currTok = {Token{ctx->lexed(), SignedTok{ctx->n}}};
    } else {
      // TODO: Do something about lexing errors.
      currTok = {};
    }
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
    (*this)++;
    return ret;
  }

  const Token& operator*() { return *currTok; }

  bool operator==(const Lexer& other) const {
    // The iterator is equal to the end sentinel when there is no current token.
    if (!currTok && !other.currTok) {
      return true;
    }
    // Otherwise they are equivalent when they are at the same position.
    return index == other.index;
  }

  bool operator!=(const Lexer& other) const { return !(*this == other); }
};

} // anonymous namespace

} // namespace wasm::WATParser
