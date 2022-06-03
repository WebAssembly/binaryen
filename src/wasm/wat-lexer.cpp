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

#include <cassert>
#include <cctype>
#include <cmath>
#include <iostream>
#include <optional>
#include <sstream>
#include <variant>

#include "wat-lexer.h"

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

enum OverflowBehavior { DisallowOverflow, IgnoreOverflow };

std::optional<int> getDigit(char c) {
  if ('0' <= c && c <= '9') {
    return c - '0';
  }
  return {};
}

std::optional<int> getHexDigit(char c) {
  if ('0' <= c && c <= '9') {
    return c - '0';
  }
  if ('A' <= c && c <= 'F') {
    return 10 + c - 'A';
  }
  if ('a' <= c && c <= 'f') {
    return 10 + c - 'a';
  }
  return {};
}

// The result of lexing an integer token fragment.
struct LexIntResult : LexResult {
  uint64_t n;
  Sign sign;
};

// Lexing context that accumulates lexed input to produce an integer token
// fragment.
struct LexIntCtx : LexCtx {
  using LexCtx::take;

private:
  uint64_t n = 0;
  Sign sign = NoSign;
  bool overflow = false;

public:
  explicit LexIntCtx(std::string_view in) : LexCtx(in) {}

  // Lex only the underlying span, ignoring the overflow and value.
  std::optional<LexIntResult> lexedRaw() {
    if (auto basic = LexCtx::lexed()) {
      return LexIntResult{*basic, 0, NoSign};
    }
    return {};
  }

  std::optional<LexIntResult> lexed() {
    if (overflow) {
      return {};
    }
    if (auto basic = LexCtx::lexed()) {
      return LexIntResult{*basic, sign == Neg ? -n : n, sign};
    }
    return {};
  }

  void takeSign() {
    if (takePrefix("+"sv)) {
      sign = Pos;
    } else if (takePrefix("-"sv)) {
      sign = Neg;
    } else {
      sign = NoSign;
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

struct LexFloatResult : LexResult {
  // The payload if we lexed a nan with payload. We cannot store the payload
  // directly in `d` because we do not know at this point whether we are parsing
  // an f32 or f64 and therefore we do not know what the allowable payloads are.
  // No payload with NaN means to use the default payload for the expected float
  // width.
  std::optional<uint64_t> nanPayload;
  double d;
};

struct LexFloatCtx : LexCtx {
  std::optional<uint64_t> nanPayload;

  LexFloatCtx(std::string_view in) : LexCtx(in) {}

  std::optional<LexFloatResult> lexed() {
    assert(!std::signbit(NAN) && "Expected NAN to be positive");
    auto basic = LexCtx::lexed();
    if (!basic) {
      return {};
    }
    if (nanPayload) {
      double nan = basic->span[0] == '-' ? -NAN : NAN;
      return LexFloatResult{*basic, nanPayload, nan};
    }
    // strtod does not return -NAN for "-nan" on all platforms.
    if (basic->span == "-nan"sv) {
      return LexFloatResult{*basic, nanPayload, -NAN};
    }
    // Do not try to implement fully general and precise float parsing
    // ourselves. Instead, call out to std::strtod to do our parsing. This means
    // we need to strip any underscores since `std::strtod` does not understand
    // them.
    std::stringstream ss;
    for (const char *curr = basic->span.data(),
                    *end = curr + basic->span.size();
         curr != end;
         ++curr) {
      if (*curr != '_') {
        ss << *curr;
      }
    }
    std::string str = ss.str();
    char* last;
    double d = std::strtod(str.data(), &last);
    assert(last == str.data() + str.size() && "could not parse float");
    return LexFloatResult{*basic, {}, d};
  }
};

struct LexStrResult : LexResult {
  // Allocate a string only if there are escape sequences, otherwise just use
  // the original string_view.
  std::optional<std::string> str;
};

struct LexStrCtx : LexCtx {
private:
  // Used to build a string with resolved escape sequences. Only used when the
  // parsed string contains escape sequences, otherwise we can just use the
  // parsed string directly.
  std::optional<std::stringstream> escapeBuilder;

public:
  LexStrCtx(std::string_view in) : LexCtx(in) {}

  std::optional<LexStrResult> lexed() {
    if (auto basic = LexCtx::lexed()) {
      if (escapeBuilder) {
        return LexStrResult{*basic, {escapeBuilder->str()}};
      } else {
        return LexStrResult{*basic, {}};
      }
    }
    return {};
  }

  void takeChar() {
    if (escapeBuilder) {
      *escapeBuilder << peek();
    }
    LexCtx::take(1);
  }

  void ensureBuildingEscaped() {
    if (escapeBuilder) {
      return;
    }
    // Drop the opening '"'.
    escapeBuilder = std::stringstream{};
    *escapeBuilder << LexCtx::lexed()->span.substr(1);
  }

  void appendEscaped(char c) { *escapeBuilder << c; }

  bool appendUnicode(uint64_t u) {
    if ((0xd800 <= u && u < 0xe000) || 0x110000 <= u) {
      return false;
    }
    if (u < 0x80) {
      // 0xxxxxxx
      *escapeBuilder << uint8_t(u);
    } else if (u < 0x800) {
      // 110xxxxx 10xxxxxx
      *escapeBuilder << uint8_t(0b11000000 | ((u >> 6) & 0b00011111));
      *escapeBuilder << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
    } else if (u < 0x10000) {
      // 1110xxxx 10xxxxxx 10xxxxxx
      *escapeBuilder << uint8_t(0b11100000 | ((u >> 12) & 0b00001111));
      *escapeBuilder << uint8_t(0b10000000 | ((u >> 6) & 0b00111111));
      *escapeBuilder << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
    } else {
      // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
      *escapeBuilder << uint8_t(0b11110000 | ((u >> 18) & 0b00000111));
      *escapeBuilder << uint8_t(0b10000000 | ((u >> 12) & 0b00111111));
      *escapeBuilder << uint8_t(0b10000000 | ((u >> 6) & 0b00111111));
      *escapeBuilder << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
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
std::optional<LexIntResult> num(std::string_view in,
                                OverflowBehavior overflow = DisallowOverflow) {
  LexIntCtx ctx(in);
  if (ctx.empty()) {
    return {};
  }
  if (!ctx.takeDigit()) {
    return {};
  }
  while (true) {
    bool under = ctx.takePrefix("_"sv);
    if (!ctx.takeDigit()) {
      if (!under) {
        return overflow == DisallowOverflow ? ctx.lexed() : ctx.lexedRaw();
      }
      // TODO: Add error production for trailing underscore.
      return {};
    }
  }
}

// hexnum   ::= h:hexdigit => h
//            | n:hexnum '_'? h:hexdigit => 16*n + h
// hexdigit ::= d:digit => d
//            | 'A' => 10 | ... | 'F' => 15
//            | 'a' => 10 | ... | 'f' => 15
std::optional<LexIntResult>
hexnum(std::string_view in, OverflowBehavior overflow = DisallowOverflow) {
  LexIntCtx ctx(in);
  if (!ctx.takeHexdigit()) {
    return {};
  }
  while (true) {
    bool under = ctx.takePrefix("_"sv);
    if (!ctx.takeHexdigit()) {
      if (!under) {
        return overflow == DisallowOverflow ? ctx.lexed() : ctx.lexedRaw();
      }
      // TODO: Add error production for trailing underscore.
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

// float   ::= p:num '.'?                              => p
//           | p:num '.' q:frac                        => p + q
//           | p:num '.'? ('E'|'e') s:sign e:num       => p * 10^([s]e)
//           | p:num '.' q:frac ('E'|'e') s:sign e:num => (p + q) * 10^([s]e)
// frac    ::= d:digit                                 => d/10
//           | d:digit '_'? p:frac                     => (d + p/10) / 10
std::optional<LexResult> decfloat(std::string_view in) {
  LexCtx ctx(in);
  if (auto lexed = num(ctx.next(), IgnoreOverflow)) {
    ctx.take(*lexed);
  } else {
    return {};
  }
  // Optional '.' followed by optional frac
  if (ctx.takePrefix("."sv)) {
    if (auto lexed = num(ctx.next(), IgnoreOverflow)) {
      ctx.take(*lexed);
    }
  }
  if (ctx.takePrefix("E"sv) || ctx.takePrefix("e"sv)) {
    // Optional sign
    ctx.takePrefix("+"sv) || ctx.takePrefix("-"sv);
    if (auto lexed = num(ctx.next(), IgnoreOverflow)) {
      ctx.take(*lexed);
    } else {
      // TODO: Add error production for missing exponent.
      return {};
    }
  }
  return ctx.lexed();
}

// hexfloat ::= '0x' p:hexnum '.'?                        => p
//            | '0x' p:hexnum '.' q:hexfrac               => p + q
//            | '0x' p:hexnum '.'? ('P'|'p') s:sign e:num => p * 2^([s]e)
//            | '0x' p:hexnum '.' q:hexfrac ('P'|'p') s:sign e:num
//                   => (p + q) * 2^([s]e)
// hexfrac ::= h:hexdigit                              => h/16
//           | h:hexdigit '_'? p:hexfrac               => (h + p/16) / 16
std::optional<LexResult> hexfloat(std::string_view in) {
  LexCtx ctx(in);
  if (!ctx.takePrefix("0x"sv)) {
    return {};
  }
  if (auto lexed = hexnum(ctx.next(), IgnoreOverflow)) {
    ctx.take(*lexed);
  } else {
    return {};
  }
  // Optional '.' followed by optional hexfrac
  if (ctx.takePrefix("."sv)) {
    if (auto lexed = hexnum(ctx.next(), IgnoreOverflow)) {
      ctx.take(*lexed);
    }
  }
  if (ctx.takePrefix("P"sv) || ctx.takePrefix("p"sv)) {
    // Optional sign
    ctx.takePrefix("+"sv) || ctx.takePrefix("-"sv);
    if (auto lexed = num(ctx.next(), IgnoreOverflow)) {
      ctx.take(*lexed);
    } else {
      // TODO: Add error production for missing exponent.
      return {};
    }
  }
  return ctx.lexed();
}

// fN    ::= s:sign z:fNmag => [s]z
// fNmag ::= z:float        => float_N(z) (if float_N(z) != +/-infinity)
//         | z:hexfloat     => float_N(z) (if float_N(z) != +/-infinity)
//         | 'inf'          => infinity
//         | 'nan'          => nan(2^(signif(N)-1))
//         | 'nan:0x' n:hexnum => nan(n) (if 1 <= n < 2^signif(N))
std::optional<LexFloatResult> float_(std::string_view in) {
  LexFloatCtx ctx(in);
  // Optional sign
  ctx.takePrefix("+"sv) || ctx.takePrefix("-"sv);
  if (auto lexed = hexfloat(ctx.next())) {
    ctx.take(*lexed);
  } else if (auto lexed = decfloat(ctx.next())) {
    ctx.take(*lexed);
  } else if (ctx.takePrefix("inf"sv)) {
    // nop
  } else if (ctx.takePrefix("nan"sv)) {
    if (ctx.takePrefix(":0x"sv)) {
      if (auto lexed = hexnum(ctx.next())) {
        ctx.take(*lexed);
        ctx.nanPayload = lexed->n;
      } else {
        // TODO: Add error production for malformed NaN payload.
        return {};
      }
    } else {
      // No explicit payload necessary; we will inject the default payload
      // later.
    }
  } else {
    return {};
  }
  if (ctx.canFinish()) {
    return ctx.lexed();
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
      ctx.ensureBuildingEscaped();
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

} // anonymous namespace

std::optional<uint64_t> Token::getU64() const {
  if (auto* tok = std::get_if<IntTok>(&data)) {
    if (tok->sign == NoSign) {
      return tok->n;
    }
  }
  return {};
}

std::optional<int64_t> Token::getS64() const {
  if (auto* tok = std::get_if<IntTok>(&data)) {
    if (tok->sign == Neg) {
      if (uint64_t(INT64_MIN) <= tok->n || tok->n == 0) {
        return int64_t(tok->n);
      }
      // TODO: Add error production for signed underflow.
    } else {
      if (tok->n <= uint64_t(INT64_MAX)) {
        return int64_t(tok->n);
      }
      // TODO: Add error production for signed overflow.
    }
  }
  return {};
}

std::optional<uint64_t> Token::getI64() const {
  if (auto n = getU64()) {
    return *n;
  }
  if (auto n = getS64()) {
    return *n;
  }
  return {};
}

std::optional<uint32_t> Token::getU32() const {
  if (auto* tok = std::get_if<IntTok>(&data)) {
    if (tok->sign == NoSign && tok->n <= UINT32_MAX) {
      return int32_t(tok->n);
    }
    // TODO: Add error production for unsigned overflow.
  }
  return {};
}

std::optional<int32_t> Token::getS32() const {
  if (auto* tok = std::get_if<IntTok>(&data)) {
    if (tok->sign == Neg) {
      if (uint64_t(INT32_MIN) <= tok->n || tok->n == 0) {
        return int32_t(tok->n);
      }
    } else {
      if (tok->n <= uint64_t(INT32_MAX)) {
        return int32_t(tok->n);
      }
    }
  }
  return {};
}

std::optional<uint32_t> Token::getI32() const {
  if (auto n = getU32()) {
    return *n;
  }
  if (auto n = getS32()) {
    return uint32_t(*n);
  }
  return {};
}

std::optional<double> Token::getF64() const {
  constexpr int signif = 52;
  constexpr uint64_t payloadMask = (1ull << signif) - 1;
  constexpr uint64_t nanDefault = 1ull << (signif - 1);
  if (auto* tok = std::get_if<FloatTok>(&data)) {
    double d = tok->d;
    if (std::isnan(d)) {
      // Inject payload.
      uint64_t payload = tok->nanPayload ? *tok->nanPayload : nanDefault;
      if (payload == 0 || payload > payloadMask) {
        // TODO: Add error production for out-of-bounds payload.
        return {};
      }
      uint64_t bits;
      static_assert(sizeof(bits) == sizeof(d));
      memcpy(&bits, &d, sizeof(bits));
      bits = (bits & ~payloadMask) | payload;
      memcpy(&d, &bits, sizeof(bits));
    }
    return d;
  }
  if (auto* tok = std::get_if<IntTok>(&data)) {
    if (tok->sign == Neg) {
      if (tok->n == 0) {
        return -0.0;
      }
      return double(int64_t(tok->n));
    }
    return double(tok->n);
  }
  return {};
}

std::optional<float> Token::getF32() const {
  constexpr int signif = 23;
  constexpr uint32_t payloadMask = (1u << signif) - 1;
  constexpr uint64_t nanDefault = 1ull << (signif - 1);
  if (auto* tok = std::get_if<FloatTok>(&data)) {
    float f = tok->d;
    if (std::isnan(f)) {
      // Validate and inject payload.
      uint64_t payload = tok->nanPayload ? *tok->nanPayload : nanDefault;
      if (payload == 0 || payload > payloadMask) {
        // TODO: Add error production for out-of-bounds payload.
        return {};
      }
      uint32_t bits;
      static_assert(sizeof(bits) == sizeof(f));
      memcpy(&bits, &f, sizeof(bits));
      bits = (bits & ~payloadMask) | payload;
      memcpy(&f, &bits, sizeof(bits));
    }
    return f;
  }
  if (auto* tok = std::get_if<IntTok>(&data)) {
    if (tok->sign == Neg) {
      if (tok->n == 0) {
        return -0.0f;
      }
      return float(int64_t(tok->n));
    }
    return float(tok->n);
  }
  return {};
}

std::optional<std::string_view> Token::getString() const {
  if (auto* tok = std::get_if<StringTok>(&data)) {
    if (tok->str) {
      return std::string_view(*tok->str);
    }
    return span.substr(1, span.size() - 2);
  }
  return {};
}

void Lexer::skipSpace() {
  if (auto ctx = space(next())) {
    index += ctx->span.size();
  }
}

void Lexer::lexToken() {
  // TODO: Ensure we're getting the longest possible match.
  Token tok;
  if (auto t = lparen(next())) {
    tok = Token{t->span, LParenTok{}};
  } else if (auto t = rparen(next())) {
    tok = Token{t->span, RParenTok{}};
  } else if (auto t = ident(next())) {
    tok = Token{t->span, IdTok{}};
  } else if (auto t = integer(next())) {
    tok = Token{t->span, IntTok{t->n, t->sign}};
  } else if (auto t = float_(next())) {
    tok = Token{t->span, FloatTok{t->nanPayload, t->d}};
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

TextPos Lexer::position(const char* c) {
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

bool TextPos::operator==(const TextPos& other) const {
  return line == other.line && col == other.col;
}

bool IntTok::operator==(const IntTok& other) const {
  return n == other.n && sign == other.sign;
}

bool FloatTok::operator==(const FloatTok& other) const {
  return std::signbit(d) == std::signbit(other.d) &&
         (d == other.d || (std::isnan(d) && std::isnan(other.d) &&
                           nanPayload == other.nanPayload));
}

bool Token::operator==(const Token& other) const {
  return span == other.span &&
         std::visit(
           [](auto& t1, auto& t2) {
             if constexpr (std::is_same_v<decltype(t1), decltype(t2)>) {
               return t1 == t2;
             } else {
               return false;
             }
           },
           data,
           other.data);
}

std::ostream& operator<<(std::ostream& os, const TextPos& pos) {
  return os << pos.line << ":" << pos.col;
}

std::ostream& operator<<(std::ostream& os, const LParenTok&) {
  return os << "'('";
}

std::ostream& operator<<(std::ostream& os, const RParenTok&) {
  return os << "')'";
}

std::ostream& operator<<(std::ostream& os, const IdTok&) { return os << "id"; }

std::ostream& operator<<(std::ostream& os, const IntTok& tok) {
  return os << (tok.sign == Pos ? "+" : tok.sign == Neg ? "-" : "") << tok.n;
}

std::ostream& operator<<(std::ostream& os, const FloatTok& tok) {
  if (std::isnan(tok.d)) {
    os << (std::signbit(tok.d) ? "+" : "-");
    if (tok.nanPayload) {
      return os << "nan:0x" << std::hex << *tok.nanPayload << std::dec;
    }
    return os << "nan";
  }
  return os << tok.d;
}

std::ostream& operator<<(std::ostream& os, const StringTok& tok) {
  if (tok.str) {
    os << '"' << *tok.str << '"';
  } else {
    os << "(raw string)";
  }
  return os;
}

std::ostream& operator<<(std::ostream& os, const KeywordTok&) {
  return os << "keyword";
}

std::ostream& operator<<(std::ostream& os, const Token& tok) {
  std::visit([&](const auto& t) { os << t; }, tok.data);
  return os << " \"" << tok.span << "\"";
}

} // namespace wasm::WATParser
