/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include "lexer.h"
#include "support/bits.h"
#include "support/string.h"

using namespace std::string_view_literals;

namespace wasm::WATParser {

Name srcAnnotationKind("src");

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

enum Sign { NoSign, Pos, Neg };

// The result of lexing an integer token fragment.
struct LexIntResult : LexResult {
  uint64_t n;
  Sign sign;

  template<typename T> bool isUnsigned() {
    static_assert(std::is_integral_v<T> && std::is_unsigned_v<T>);
    return sign == NoSign && n <= std::numeric_limits<T>::max();
  }

  template<typename T> bool isSigned() {
    static_assert(std::is_integral_v<T> && std::is_signed_v<T>);
    if (sign == Neg) {
      return uint64_t(std::numeric_limits<T>::min()) <= n || n == 0;
    }
    return n <= uint64_t(std::numeric_limits<T>::max());
  }
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
    const double posNan = std::copysign(NAN, 1.0);
    const double negNan = std::copysign(NAN, -1.0);
    assert(!std::signbit(posNan) && "expected positive NaN to be positive");
    assert(std::signbit(negNan) && "expected negative NaN to be negative");
    auto basic = LexCtx::lexed();
    if (!basic) {
      return {};
    }
    // strtod does not return NaNs with the expected signs on all platforms.
    // TODO: use starts_with once we have C++20.
    if (basic->span.substr(0, 3) == "nan"sv ||
        basic->span.substr(0, 4) == "+nan"sv) {
      return LexFloatResult{*basic, nanPayload, posNan};
    }
    if (basic->span.substr(0, 4) == "-nan"sv) {
      return LexFloatResult{*basic, nanPayload, negNan};
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
    String::writeWTF8CodePoint(*escapeBuilder, u);
    return true;
  }
};

struct LexIdResult : LexResult {
  bool isStr = false;
  std::optional<std::string> str;
};

struct LexIdCtx : LexCtx {
  bool isStr = false;
  std::optional<std::string> str;

  LexIdCtx(std::string_view in) : LexCtx(in) {}

  std::optional<LexIdResult> lexed() {
    if (auto basic = LexCtx::lexed()) {
      return LexIdResult{*basic, isStr, str};
    }
    return {};
  }
};

struct LexAnnotationResult : LexResult {
  Annotation annotation;
};

struct LexAnnotationCtx : LexCtx {
  std::string_view kind;
  size_t kindSize = 0;
  std::string_view contents;
  size_t contentsSize = 0;

  explicit LexAnnotationCtx(std::string_view in) : LexCtx(in) {}

  void startKind() { kind = next(); }

  void takeKind(size_t size) {
    kindSize += size;
    take(size);
  }

  void setKind(std::string_view kind) {
    this->kind = kind;
    kindSize = kind.size();
  }

  void startContents() { contents = next(); }

  void takeContents(size_t size) {
    contentsSize += size;
    take(size);
  }

  std::optional<LexAnnotationResult> lexed() {
    if (auto basic = LexCtx::lexed()) {
      return LexAnnotationResult{
        *basic,
        {Name(kind.substr(0, kindSize)), contents.substr(0, contentsSize)}};
    }
    return std::nullopt;
  }
};

std::optional<LexResult> idchar(std::string_view);
std::optional<LexResult> space(std::string_view);
std::optional<LexResult> keyword(std::string_view);
std::optional<LexIntResult> integer(std::string_view);
std::optional<LexFloatResult> float_(std::string_view);
std::optional<LexStrResult> str(std::string_view);
std::optional<LexIdResult> ident(std::string_view);

// annotation ::= ';;@' [^\n]* | '(@'idchar+ annotelem* ')'
// annotelem  ::= keyword | reserved | uN | sN | fN | string | id
//              | '(' annotelem* ')' | '(@'idchar+ annotelem* ')'
std::optional<LexAnnotationResult> annotation(std::string_view in) {
  LexAnnotationCtx ctx(in);
  if (ctx.takePrefix(";;@"sv)) {
    ctx.setKind(srcAnnotationKind.str);
    ctx.startContents();
    if (auto size = ctx.next().find('\n'); size != ""sv.npos) {
      ctx.takeContents(size);
    } else {
      ctx.takeContents(ctx.next().size());
    }
  } else if (ctx.takePrefix("(@"sv)) {
    ctx.startKind();
    bool hasIdchar = false;
    while (auto lexed = idchar(ctx.next())) {
      ctx.takeKind(1);
      hasIdchar = true;
    }
    if (!hasIdchar) {
      return std::nullopt;
    }
    ctx.startContents();
    size_t depth = 1;
    while (true) {
      if (ctx.empty()) {
        return std::nullopt;
      }
      if (auto lexed = space(ctx.next())) {
        ctx.takeContents(lexed->span.size());
        continue;
      }
      if (auto lexed = keyword(ctx.next())) {
        ctx.takeContents(lexed->span.size());
        continue;
      }
      if (auto lexed = integer(ctx.next())) {
        ctx.takeContents(lexed->span.size());
        continue;
      }
      if (auto lexed = float_(ctx.next())) {
        ctx.takeContents(lexed->span.size());
        continue;
      }
      if (auto lexed = str(ctx.next())) {
        ctx.takeContents(lexed->span.size());
        continue;
      }
      if (auto lexed = ident(ctx.next())) {
        ctx.takeContents(lexed->span.size());
        continue;
      }
      if (ctx.startsWith("(@"sv)) {
        ctx.takeContents(2);
        bool hasIdchar = false;
        while (auto lexed = idchar(ctx.next())) {
          ctx.takeContents(1);
          hasIdchar = true;
        }
        if (!hasIdchar) {
          return std::nullopt;
        }
        ++depth;
        continue;
      }
      if (ctx.startsWith("("sv)) {
        ctx.takeContents(1);
        ++depth;
        continue;
      }
      if (ctx.startsWith(")"sv)) {
        --depth;
        if (depth == 0) {
          ctx.take(1);
          break;
        }
        ctx.takeContents(1);
        continue;
      }
      // Unrecognized token.
      return std::nullopt;
    }
  }
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
  if (!ctx.startsWith(";;@"sv) && ctx.takePrefix(";;"sv)) {
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
  return empty() || startsWith("("sv) || startsWith(")"sv) ||
         spacechar(next()) || startsWith(";;"sv);
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
  // All the allowed characters lie in the range '!' to '~', and within that
  // range the vast majority of characters are allowed, so it is significantly
  // faster to check for the disallowed characters instead.
  if (c < '!' || c > '~') {
    return ctx.lexed();
  }
  switch (c) {
    case '"':
    case '(':
    case ')':
    case ',':
    case ';':
    case '[':
    case ']':
    case '{':
    case '}':
      return ctx.lexed();
  }
  ctx.take(1);
  return ctx.lexed();
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

// id ::= '$' idchar+ | '$' str
std::optional<LexIdResult> ident(std::string_view in) {
  LexIdCtx ctx(in);
  if (!ctx.takePrefix("$"sv)) {
    return {};
  }
  if (auto s = str(ctx.next())) {
    ctx.isStr = true;
    ctx.str = s->str;
    ctx.take(*s);
  } else if (auto lexed = idchar(ctx.next())) {
    ctx.take(*lexed);
    while (auto lexed = idchar(ctx.next())) {
      ctx.take(*lexed);
    }
  } else {
    return {};
  }
  if (ctx.canFinish()) {
    return ctx.lexed();
  }
  return {};
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

void Lexer::skipSpace() {
  while (true) {
    if (auto ctx = annotation(next())) {
      pos += ctx->span.size();
      annotations.push_back(ctx->annotation);
      continue;
    }
    if (auto ctx = space(next())) {
      pos += ctx->span.size();
      continue;
    }
    break;
  }
}

bool Lexer::takeLParen() {
  if (LexCtx(next()).startsWith("("sv)) {
    ++pos;
    advance();
    return true;
  }
  return false;
}

bool Lexer::takeRParen() {
  if (LexCtx(next()).startsWith(")"sv)) {
    ++pos;
    advance();
    return true;
  }
  return false;
}

std::optional<std::string> Lexer::takeString() {
  if (auto result = str(next())) {
    pos += result->span.size();
    advance();
    if (result->str) {
      return result->str;
    }
    // Remove quotes.
    return std::string(result->span.substr(1, result->span.size() - 2));
  }
  return std::nullopt;
}

std::optional<Name> Lexer::takeID() {
  if (auto result = ident(next())) {
    pos += result->span.size();
    advance();
    if (result->str) {
      return Name(*result->str);
    }
    if (result->isStr) {
      // Remove '$' and quotes.
      return Name(result->span.substr(2, result->span.size() - 3));
    }
    // Remove '$'.
    return Name(result->span.substr(1));
  }
  return std::nullopt;
}

std::optional<std::string_view> Lexer::takeKeyword() {
  if (auto result = keyword(next())) {
    pos += result->span.size();
    advance();
    return result->span;
  }
  return std::nullopt;
}

bool Lexer::takeKeyword(std::string_view expected) {
  if (auto result = keyword(next()); result && result->span == expected) {
    pos += expected.size();
    advance();
    return true;
  }
  return false;
}

std::optional<uint64_t> Lexer::takeOffset() {
  if (auto result = keyword(next())) {
    if (result->span.substr(0, 7) != "offset="sv) {
      return std::nullopt;
    }
    Lexer subLexer(result->span.substr(7));
    if (auto o = subLexer.takeU64()) {
      pos += result->span.size();
      advance();
      return o;
    }
  }
  return std::nullopt;
}

std::optional<uint32_t> Lexer::takeAlign() {
  if (auto result = keyword(next())) {
    if (result->span.substr(0, 6) != "align="sv) {
      return std::nullopt;
    }
    Lexer subLexer(result->span.substr(6));
    if (auto o = subLexer.takeU32()) {
      if (Bits::popCount(*o) != 1) {
        return std::nullopt;
      }
      pos += result->span.size();
      advance();
      return o;
    }
  }
  return std::nullopt;
}

template<typename T> std::optional<T> Lexer::takeU() {
  static_assert(std::is_integral_v<T> && std::is_unsigned_v<T>);
  if (auto result = integer(next()); result && result->isUnsigned<T>()) {
    pos += result->span.size();
    advance();
    return T(result->n);
  }
  // TODO: Add error production for unsigned overflow.
  return std::nullopt;
}

template<typename T> std::optional<T> Lexer::takeS() {
  static_assert(std::is_integral_v<T> && std::is_signed_v<T>);
  if (auto result = integer(next()); result && result->isSigned<T>()) {
    pos += result->span.size();
    advance();
    return T(result->n);
  }
  return std::nullopt;
}

template<typename T> std::optional<T> Lexer::takeI() {
  static_assert(std::is_integral_v<T> && std::is_unsigned_v<T>);
  if (auto result = integer(next())) {
    if (result->isUnsigned<T>() || result->isSigned<std::make_signed_t<T>>()) {
      pos += result->span.size();
      advance();
      return T(result->n);
    }
  }
  return std::nullopt;
}

template std::optional<uint64_t> Lexer::takeU<uint64_t>();
template std::optional<int64_t> Lexer::takeS<int64_t>();
template std::optional<uint64_t> Lexer::takeI<uint64_t>();
template std::optional<uint32_t> Lexer::takeU<uint32_t>();
template std::optional<int32_t> Lexer::takeS<int32_t>();
template std::optional<uint32_t> Lexer::takeI<uint32_t>();
template std::optional<uint16_t> Lexer::takeU<uint16_t>();
template std::optional<int16_t> Lexer::takeS<int16_t>();
template std::optional<uint16_t> Lexer::takeI<uint16_t>();
template std::optional<uint8_t> Lexer::takeU<uint8_t>();
template std::optional<int8_t> Lexer::takeS<int8_t>();
template std::optional<uint8_t> Lexer::takeI<uint8_t>();

std::optional<double> Lexer::takeF64() {
  constexpr int signif = 52;
  constexpr uint64_t payloadMask = (1ull << signif) - 1;
  constexpr uint64_t nanDefault = 1ull << (signif - 1);
  if (auto result = float_(next())) {
    double d = result->d;
    if (std::isnan(d)) {
      // Inject payload.
      uint64_t payload = result->nanPayload ? *result->nanPayload : nanDefault;
      if (payload == 0 || payload > payloadMask) {
        // TODO: Add error production for out-of-bounds payload.
        return std::nullopt;
      }
      uint64_t bits;
      static_assert(sizeof(bits) == sizeof(d));
      memcpy(&bits, &d, sizeof(bits));
      bits = (bits & ~payloadMask) | payload;
      memcpy(&d, &bits, sizeof(bits));
    }
    pos += result->span.size();
    advance();
    return d;
  }
  if (auto result = integer(next())) {
    pos += result->span.size();
    advance();
    if (result->sign == Neg) {
      if (result->n == 0) {
        return -0.0;
      }
      return double(int64_t(result->n));
    }
    return double(result->n);
  }
  return std::nullopt;
}

std::optional<float> Lexer::takeF32() {
  constexpr int signif = 23;
  constexpr uint32_t payloadMask = (1u << signif) - 1;
  constexpr uint64_t nanDefault = 1ull << (signif - 1);
  if (auto result = float_(next())) {
    float f = result->d;
    if (std::isnan(f)) {
      // Validate and inject payload.
      uint64_t payload = result->nanPayload ? *result->nanPayload : nanDefault;
      if (payload == 0 || payload > payloadMask) {
        // TODO: Add error production for out-of-bounds payload.
        return std::nullopt;
      }
      uint32_t bits;
      static_assert(sizeof(bits) == sizeof(f));
      memcpy(&bits, &f, sizeof(bits));
      bits = (bits & ~payloadMask) | payload;
      memcpy(&f, &bits, sizeof(bits));
    }
    pos += result->span.size();
    advance();
    return f;
  }
  if (auto result = integer(next())) {
    pos += result->span.size();
    advance();
    if (result->sign == Neg) {
      if (result->n == 0) {
        return -0.0f;
      }
      return float(int64_t(result->n));
    }
    return float(result->n);
  }
  return std::nullopt;
}

TextPos Lexer::position(const char* c) const {
  assert(size_t(c - buffer.data()) <= buffer.size());
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

std::ostream& operator<<(std::ostream& os, const TextPos& pos) {
  return os << pos.line << ":" << pos.col;
}

} // namespace wasm::WATParser
