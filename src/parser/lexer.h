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

#ifndef parser_lexer_h
#define parser_lexer_h

#include <cassert>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <optional>
#include <ostream>
#include <sstream>
#include <string_view>
#include <variant>
#include <vector>

#include "support/bits.h"
#include "support/name.h"
#include "support/result.h"
#include "support/string.h"

namespace wasm::WATParser {

struct TextPos {
  size_t line;
  size_t col;

  bool operator==(const TextPos& other) const {
    return line == other.line && col == other.col;
  }
  bool operator!=(const TextPos& other) const { return !(*this == other); }
};

inline std::ostream& operator<<(std::ostream& os, const TextPos& pos) {
  return os << pos.line << ":" << pos.col;
}

// ===========
// Annotations
// ===========

struct Annotation {
  Name kind;
  std::string_view contents;
};

// =====
// Lexer
// =====

struct Lexer {
private:
  size_t pos = 0;
  std::vector<Annotation> annotations;
  std::optional<std::string> file;

public:
  std::string_view buffer;

  Lexer(std::string_view buffer,
        std::optional<std::string> file = std::nullopt);

  size_t getPos() const { return pos; }

  void setPos(size_t i) {
    pos = i;
    advance();
  }

  std::optional<char> peekChar() const;

  bool peekLParen() { return !empty() && peek() == '('; }

  bool takeLParen();

  bool peekRParen() { return !empty() && peek() == ')'; }

  bool takeRParen();

  bool takeUntilParen();

  std::optional<Name> takeID();

  std::optional<std::string_view> peekKeyword();

  std::optional<std::string_view> takeKeyword();
  bool takeKeyword(std::string_view expected);

  std::optional<uint64_t> takeOffset();
  std::optional<uint32_t> takeAlign();

  std::optional<uint64_t> takeU64() { return takeU<uint64_t>(); }
  std::optional<uint64_t> takeI64() { return takeI<uint64_t>(); }
  std::optional<uint32_t> takeU32() { return takeU<uint32_t>(); }
  std::optional<uint32_t> takeI32() { return takeI<uint32_t>(); }
  std::optional<uint16_t> takeI16() { return takeI<uint16_t>(); }
  std::optional<uint8_t> takeU8() { return takeU<uint8_t>(); }
  std::optional<uint8_t> takeI8() { return takeI<uint8_t>(); }

  std::optional<float> takeF32();
  std::optional<double> takeF64();

  std::optional<std::string> takeString();

  std::optional<Name> takeName();

  bool takeSExprStart(std::string_view expected);

  bool peekSExprStart(std::string_view expected);

  std::string_view next() const { return buffer.substr(pos); }

  uint8_t peek() const { return buffer[pos]; }

  void advance() {
    annotations.clear();
    skipSpace();
  }

  bool empty() const { return pos == buffer.size(); }
  size_t remaining() const { return buffer.size() - pos; }

  TextPos position(const char* c) const;

  TextPos position(size_t i) const { return position(buffer.data() + i); }
  TextPos position(std::string_view span) const {
    return position(span.data());
  }
  TextPos position() const { return position(getPos()); }

  [[nodiscard]] Err err(size_t pos, std::string reason);

  [[nodiscard]] Err err(std::string reason) { return err(getPos(), reason); }

  const std::vector<Annotation> getAnnotations() { return annotations; }
  std::vector<Annotation> takeAnnotations() { return std::move(annotations); }

  void setAnnotations(std::vector<Annotation> annotations) {
    this->annotations = std::move(annotations);
  }

private:
  // Whether the unlexed input starts with prefix `sv`.
  size_t startsWith(std::string_view sv) const {
    return next().starts_with(sv);
  }

  // Consume the next `n` characters.
  void take(size_t n) { pos += n; }
  void takeAll() { pos = buffer.size(); }

  std::optional<int> getDigit(char c);

  std::optional<int> getHexDigit(char c);

  // Consume the prefix and return true if possible.
  bool takePrefix(std::string_view sv);

  std::optional<int> takeDigit();

  std::optional<int> takeHexdigit();

  enum OverflowBehavior { DisallowOverflow, IgnoreOverflow };

  std::optional<uint64_t> takeNum(OverflowBehavior behavior = DisallowOverflow);

  std::optional<uint64_t>
  takeHexnum(OverflowBehavior behavior = DisallowOverflow);

  enum Sign { NoSign, Pos, Neg };

  Sign takeSign();

  struct LexedInteger {
    uint64_t n;
    Sign sign;

    template<typename T> bool isUnsigned();
    template<typename T> bool isSigned();
  };

  std::optional<LexedInteger> takeInteger();

  template<typename T> std::optional<T> takeU();

  template<typename T> std::optional<T> takeS();

  template<typename T> std::optional<T> takeI();

  std::optional<std::string_view> takeDecfloat();

  std::optional<std::string_view> takeHexfloat();

  struct LexedFloat {
    std::optional<uint64_t> nanPayload;
    double d;
  };

  std::optional<LexedFloat> takeFloat();

  struct StringOrView : std::variant<std::string, std::string_view> {
    using std::variant<std::string, std::string_view>::variant;
    std::string_view str() const {
      return std::visit([](auto& s) -> std::string_view { return s; }, *this);
    }
  };

  std::optional<StringOrView> takeStr();

  bool idchar();

  std::optional<StringOrView> takeIdent();

  bool spacechar();

  bool takeSpacechar();

  bool takeComment();

  bool takeSpace();

  std::optional<Annotation> takeAnnotation();

  void skipSpace();

  bool canFinish();
};

inline Lexer::Lexer(std::string_view buffer, std::optional<std::string> file)
  : file(file), buffer(buffer) {
  setPos(0);
}

inline std::optional<char> Lexer::peekChar() const {
  if (!empty()) {
    return peek();
  }
  return std::nullopt;
}

inline bool Lexer::takeLParen() {
  if (peekLParen()) {
    take(1);
    advance();
    return true;
  }
  return false;
}

inline bool Lexer::takeRParen() {
  if (peekRParen()) {
    take(1);
    advance();
    return true;
  }
  return false;
}

inline bool Lexer::takeUntilParen() {
  while (true) {
    if (empty()) {
      return false;
    }
    if (peekLParen() || peekRParen()) {
      return true;
    }
    // Do not count the parentheses in strings.
    if (takeString()) {
      continue;
    }
    ++pos;
    advance();
  }
}

inline std::optional<Name> Lexer::takeID() {
  if (auto result = takeIdent()) {
    auto name = Name(result->str());
    advance();
    return name;
  }
  return std::nullopt;
}

inline std::optional<std::string_view> Lexer::peekKeyword() {
  if (empty()) {
    return std::nullopt;
  }
  auto startPos = pos;
  uint8_t start = peek();
  if ('a' <= start && start <= 'z') {
    take(1);
  } else {
    return std::nullopt;
  }
  while (idchar()) {
    take(1);
  }
  auto ret = buffer.substr(startPos, pos - startPos);
  pos = startPos;
  return ret;
}

inline std::optional<std::string_view> Lexer::takeKeyword() {
  auto keyword = peekKeyword();
  if (keyword) {
    take(keyword->size());
    advance();
  }
  return keyword;
}

inline bool Lexer::takeKeyword(std::string_view expected) {
  if (!startsWith(expected)) {
    return false;
  }
  auto startPos = pos;
  take(expected.size());
  if (canFinish()) {
    advance();
    return true;
  }
  pos = startPos;
  return false;
}

inline std::optional<uint64_t> Lexer::takeOffset() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  if (auto offset = takeKeyword()) {
    if (!offset->starts_with("offset="sv)) {
      pos = startPos;
      return std::nullopt;
    }
    Lexer subLexer(offset->substr(7));
    if (auto o = subLexer.takeU64()) {
      advance();
      return o;
    }
  }
  return std::nullopt;
}

inline std::optional<uint32_t> Lexer::takeAlign() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  if (auto result = takeKeyword()) {
    if (!result->starts_with("align="sv)) {
      pos = startPos;
      return std::nullopt;
    }
    Lexer subLexer(result->substr(6));
    if (auto o = subLexer.takeU32()) {
      if (Bits::popCount(*o) != 1) {
        pos = startPos;
        return std::nullopt;
      }
      advance();
      return o;
    }
  }
  return std::nullopt;
}

inline std::optional<float> Lexer::takeF32() {
  constexpr int signif = 23;
  constexpr uint32_t payloadMask = (1u << signif) - 1;
  constexpr uint64_t nanDefault = 1ull << (signif - 1);
  auto startPos = pos;
  if (auto result = takeFloat()) {
    float f = result->d;
    if (std::isnan(f)) {
      // Validate and inject payload.
      uint64_t payload = result->nanPayload ? *result->nanPayload : nanDefault;
      if (payload == 0 || payload > payloadMask) {
        // TODO: Add error production for out-of-bounds payload.
        pos = startPos;
        return std::nullopt;
      }
      uint32_t bits;
      static_assert(sizeof(bits) == sizeof(f));
      memcpy(&bits, &f, sizeof(bits));
      bits = (bits & ~payloadMask) | payload;
      memcpy(&f, &bits, sizeof(bits));
    }
    advance();
    return f;
  }
  if (auto result = takeInteger()) {
    advance();
    if (result->sign == Neg) {
      if (result->n == 0) {
        return -0.0f;
      }
      return static_cast<float>(static_cast<int64_t>(result->n));
    }
    return static_cast<float>(result->n);
  }
  return std::nullopt;
}

inline std::optional<double> Lexer::takeF64() {
  constexpr int signif = 52;
  constexpr uint64_t payloadMask = (1ull << signif) - 1;
  constexpr uint64_t nanDefault = 1ull << (signif - 1);
  auto startPos = pos;
  if (auto result = takeFloat()) {
    double d = result->d;
    if (std::isnan(d)) {
      // Inject payload.
      uint64_t payload = result->nanPayload ? *result->nanPayload : nanDefault;
      if (payload == 0 || payload > payloadMask) {
        // TODO: Add error production for out-of-bounds payload.
        pos = startPos;
        return std::nullopt;
      }
      uint64_t bits;
      static_assert(sizeof(bits) == sizeof(d));
      memcpy(&bits, &d, sizeof(bits));
      bits = (bits & ~payloadMask) | payload;
      memcpy(&d, &bits, sizeof(bits));
    }
    advance();
    return d;
  }
  if (auto result = takeInteger()) {
    advance();
    if (result->sign == Neg) {
      if (result->n == 0) {
        return -0.0;
      }
      return static_cast<double>(static_cast<int64_t>(result->n));
    }
    return static_cast<double>(result->n);
  }
  return std::nullopt;
}

inline std::optional<std::string> Lexer::takeString() {
  if (auto str = takeStr()) {
    advance();
    if (auto* s = std::get_if<std::string>(&*str)) {
      return std::move(*s);
    }
    auto view = std::get<std::string_view>(*str);
    return std::string(view);
  }
  return std::nullopt;
}

inline std::optional<Name> Lexer::takeName() {
  auto str = takeString();
  if (!str || !String::isUTF8(*str)) {
    return std::nullopt;
  }
  return Name(*str);
}

inline bool Lexer::takeSExprStart(std::string_view expected) {
  auto original = *this;
  if (takeLParen() && takeKeyword(expected)) {
    return true;
  }
  *this = original;
  return false;
}

inline bool Lexer::peekSExprStart(std::string_view expected) {
  auto original = *this;
  if (!takeLParen()) {
    return false;
  }
  bool ret = takeKeyword(expected);
  *this = original;
  return ret;
}

inline TextPos Lexer::position(const char* c) const {
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

inline Err Lexer::err(size_t pos, std::string reason) {
  std::stringstream msg;
  if (file) {
    msg << *file << ":";
  }
  msg << position(pos) << ": error: " << reason;
  return Err{msg.str()};
}

inline std::optional<int> Lexer::getDigit(char c) {
  if ('0' <= c && c <= '9') {
    return c - '0';
  }
  return std::nullopt;
}

inline std::optional<int> Lexer::getHexDigit(char c) {
  if (auto d = getDigit(c)) {
    return d;
  }
  if ('A' <= c && c <= 'F') {
    return 10 + c - 'A';
  }
  if ('a' <= c && c <= 'f') {
    return 10 + c - 'a';
  }
  return std::nullopt;
}

inline bool Lexer::takePrefix(std::string_view sv) {
  if (startsWith(sv)) {
    take(sv.size());
    return true;
  }
  return false;
}

inline std::optional<int> Lexer::takeDigit() {
  if (empty()) {
    return std::nullopt;
  }
  if (auto d = getDigit(peek())) {
    take(1);
    return d;
  }
  return std::nullopt;
}

inline std::optional<int> Lexer::takeHexdigit() {
  if (empty()) {
    return std::nullopt;
  }
  if (auto h = getHexDigit(peek())) {
    take(1);
    return h;
  }
  return std::nullopt;
}

inline std::optional<uint64_t> Lexer::takeNum(OverflowBehavior behavior) {
  using namespace std::string_view_literals;
  auto startPos = pos;
  bool overflow = false;
  uint64_t n = 0;
  if (auto d = takeDigit()) {
    n = *d;
  } else {
    return std::nullopt;
  }
  while (true) {
    bool under = takePrefix("_"sv);
    if (auto d = takeDigit()) {
      uint64_t newN = n * 10 + *d;
      if (newN < n) {
        overflow = true;
      }
      n = newN;
      continue;
    }
    if (!under && (!overflow || behavior == IgnoreOverflow)) {
      return n;
    }
    // TODO: Add error productions for trailing underscore and overflow.
    pos = startPos;
    return std::nullopt;
  }
}

inline std::optional<uint64_t> Lexer::takeHexnum(OverflowBehavior behavior) {
  using namespace std::string_view_literals;
  auto startPos = pos;
  bool overflow = false;
  uint64_t n = 0;
  if (auto d = takeHexdigit()) {
    n = *d;
  } else {
    return std::nullopt;
  }
  while (true) {
    bool under = takePrefix("_"sv);
    if (auto d = takeHexdigit()) {
      uint64_t newN = n * 16 + *d;
      if (newN < n) {
        overflow = true;
      }
      n = newN;
      continue;
    }
    if (!under && (!overflow || behavior == IgnoreOverflow)) {
      return n;
    }
    // TODO: Add error productions for trailing underscore and overflow.
    pos = startPos;
    return std::nullopt;
  }
}

inline Lexer::Sign Lexer::takeSign() {
  auto c = peek();
  if (c == '+') {
    take(1);
    return Pos;
  }
  if (c == '-') {
    take(1);
    return Neg;
  }
  return NoSign;
}

template<typename T> bool Lexer::LexedInteger::isUnsigned() {
  static_assert(std::is_integral_v<T> && std::is_unsigned_v<T>);
  return sign == NoSign && n <= std::numeric_limits<T>::max();
}

template<typename T> bool Lexer::LexedInteger::isSigned() {
  static_assert(std::is_integral_v<T> && std::is_signed_v<T>);
  if (sign == Neg) {
    // Absolute value of min() for two's complement integers is max() + 1.
    uint64_t absMin = uint64_t(std::numeric_limits<T>::max()) + 1;
    return n <= absMin;
  }
  return n <= uint64_t(std::numeric_limits<T>::max());
}

inline std::optional<Lexer::LexedInteger> Lexer::takeInteger() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  auto sign = takeSign();
  if (takePrefix("0x"sv)) {
    if (auto n = takeHexnum()) {
      if (canFinish()) {
        return LexedInteger{*n, sign};
      }
    }
    // TODO: Add error production for unrecognized hexnum.
    pos = startPos;
    return std::nullopt;
  }
  if (auto n = takeNum()) {
    if (canFinish()) {
      return LexedInteger{*n, sign};
    }
  }
  pos = startPos;
  return std::nullopt;
}

template<typename T> std::optional<T> Lexer::takeU() {
  static_assert(std::is_integral_v<T> && std::is_unsigned_v<T>);
  auto startPos = pos;
  if (auto result = takeInteger(); result && result->isUnsigned<T>()) {
    advance();
    return static_cast<T>(result->n);
  }
  // TODO: Add error production for unsigned overflow.
  pos = startPos;
  return std::nullopt;
}

template<typename T> std::optional<T> Lexer::takeS() {
  static_assert(std::is_integral_v<T> && std::is_signed_v<T>);
  auto startPos = pos;
  if (auto result = takeInteger(); result && result->isSigned<T>()) {
    advance();
    if (result->sign == Neg) {
      return static_cast<T>(-result->n);
    }
    return static_cast<T>(result->n);
  }
  pos = startPos;
  return std::nullopt;
}

template<typename T> std::optional<T> Lexer::takeI() {
  static_assert(std::is_integral_v<T> && std::is_unsigned_v<T>);
  auto startPos = pos;
  if (auto result = takeInteger()) {
    if (result->isUnsigned<T>() || result->isSigned<std::make_signed_t<T>>()) {
      advance();
      if (result->sign == Neg) {
        return static_cast<T>(-result->n);
      }
      return static_cast<T>(result->n);
    }
  }
  pos = startPos;
  return std::nullopt;
}

inline std::optional<std::string_view> Lexer::takeDecfloat() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  if (!takeNum(IgnoreOverflow)) {
    return std::nullopt;
  }
  // Optional '.' followed by optional frac
  if (takePrefix("."sv)) {
    takeNum(IgnoreOverflow);
  }
  if (takePrefix("E"sv) || takePrefix("e"sv)) {
    // Optional sign
    takeSign();
    if (!takeNum(IgnoreOverflow)) {
      // TODO: Add error production for missing exponent.
      pos = startPos;
      return std::nullopt;
    }
  }
  return buffer.substr(startPos, pos - startPos);
}

inline std::optional<std::string_view> Lexer::takeHexfloat() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  if (!takePrefix("0x"sv)) {
    return std::nullopt;
  }
  if (!takeHexnum(IgnoreOverflow)) {
    pos = startPos;
    return std::nullopt;
  }
  // Optional '.' followed by optional hexfrac
  if (takePrefix("."sv)) {
    takeHexnum(IgnoreOverflow);
  }
  if (takePrefix("P"sv) || takePrefix("p"sv)) {
    // Optional sign
    takeSign();
    if (!takeNum(IgnoreOverflow)) {
      // TODO: Add error production for missing exponent.
      pos = startPos;
      return std::nullopt;
    }
  }
  return buffer.substr(startPos, pos - startPos);
}

inline std::optional<Lexer::LexedFloat> Lexer::takeFloat() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  std::optional<uint64_t> nanPayload;
  bool isNan = false;
  // Optional sign
  auto sign = takeSign();
  if (takeHexfloat() || takeDecfloat() || takePrefix("inf"sv)) {
    // nop.
  } else if (takePrefix("nan"sv)) {
    isNan = true;
    if (takePrefix(":0x"sv)) {
      if (auto n = takeHexnum()) {
        nanPayload = n;
      } else {
        // TODO: Add error production for malformed NaN payload.
        pos = startPos;
        return std::nullopt;
      }
    } else {
      // No explicit payload necessary; we will inject the default payload
      // later.
    }
  } else {
    pos = startPos;
    return std::nullopt;
  }
  if (!canFinish()) {
    pos = startPos;
    return std::nullopt;
  }
  // strtod does not return NaNs with the expected signs on all platforms.
  if (isNan) {
    if (sign == Neg) {
      const double negNan = std::copysign(NAN, -1.0);
      assert(std::signbit(negNan) && "expected negative NaN to be negative");
      return LexedFloat{nanPayload, negNan};
    } else {
      const double posNan = std::copysign(NAN, 1.0);
      assert(!std::signbit(posNan) && "expected positive NaN to be positive");
      return LexedFloat{nanPayload, posNan};
    }
  }
  // Do not try to implement fully general and precise float parsing
  // ourselves. Instead, call out to std::strtod to do our parsing. This means
  // we need to strip any underscores since `std::strtod` does not understand
  // them.
  std::stringstream ss;
  for (const char *curr = &buffer[startPos], *end = &buffer[pos]; curr != end;
       ++curr) {
    if (*curr != '_') {
      ss << *curr;
    }
  }
  std::string str = ss.str();
  char* last;
  double d = std::strtod(str.data(), &last);
  assert(last == str.data() + str.size() && "could not parse float");
  return LexedFloat{std::nullopt, d};
}

inline std::optional<Lexer::StringOrView> Lexer::takeStr() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  if (!takePrefix("\""sv)) {
    return std::nullopt;
  }
  // Used to build a string with resolved escape sequences. Only used when the
  // parsed string contains escape sequences, otherwise we can just use the
  // parsed string directly.
  std::optional<std::stringstream> escapeBuilder;
  auto ensureBuildingEscaped = [&]() {
    if (escapeBuilder) {
      return;
    }
    // Drop the opening '"'.
    escapeBuilder = std::stringstream{};
    *escapeBuilder << buffer.substr(startPos + 1, pos - startPos - 1);
  };
  while (!takePrefix("\""sv)) {
    if (empty()) {
      // TODO: Add error production for unterminated string.
      pos = startPos;
      return std::nullopt;
    }
    if (startsWith("\\"sv)) {
      // Escape sequences
      ensureBuildingEscaped();
      take(1);
      auto c = peek();
      take(1);
      switch (c) {
        case 't':
          *escapeBuilder << '\t';
          break;
        case 'n':
          *escapeBuilder << '\n';
          break;
        case 'r':
          *escapeBuilder << '\r';
          break;
        case '\\':
          *escapeBuilder << '\\';
          break;
        case '"':
          *escapeBuilder << '"';
          break;
        case '\'':
          *escapeBuilder << '\'';
          break;
        case 'u': {
          if (!takePrefix("{"sv)) {
            pos = startPos;
            return std::nullopt;
          }
          auto code = takeHexnum();
          if (!code) {
            // TODO: Add error production for malformed unicode escapes.
            pos = startPos;
            return std::nullopt;
          }
          if (!takePrefix("}"sv)) {
            // TODO: Add error production for malformed unicode escapes.
            pos = startPos;
            return std::nullopt;
          }
          if ((0xd800 <= *code && *code < 0xe000) || 0x110000 <= *code) {
            // TODO: Add error production for invalid unicode values.
            pos = startPos;
            return std::nullopt;
          }
          String::writeWTF8CodePoint(*escapeBuilder, *code);
          break;
        }
        default: {
          // Byte escape: \hh
          // We already took the first h as c.
          auto first = getHexDigit(c);
          auto second = takeHexdigit();
          if (!first || !second) {
            // TODO: Add error production for unrecognized escape sequence.
            pos = startPos;
            return std::nullopt;
          }
          *escapeBuilder << char(*first * 16 + *second);
        }
      }
    } else {
      // Normal characters
      if (uint8_t c = peek(); c >= 0x20 && c != 0x7F) {
        if (escapeBuilder) {
          *escapeBuilder << c;
        }
        take(1);
      } else {
        // TODO: Add error production for unescaped control characters.
        pos = startPos;
        return std::nullopt;
      }
    }
  }
  if (escapeBuilder) {
    return escapeBuilder->str();
  }
  // Drop the quotes.
  return buffer.substr(startPos + 1, pos - startPos - 2);
}

inline bool Lexer::idchar() {
  if (empty()) {
    return false;
  }
  uint8_t c = peek();
  // All the allowed characters lie in the range '!' to '~', and within that
  // range the vast majority of characters are allowed, so it is significantly
  // faster to check for the disallowed characters instead.
  if (c < '!' || c > '~') {
    return false;
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
      return false;
  }
  return true;
}

inline std::optional<Lexer::StringOrView> Lexer::takeIdent() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  if (!takePrefix("$"sv)) {
    return {};
  }
  // Quoted identifier e.g. $"foo"
  std::optional<StringOrView> str;
  if ((str = takeStr())) {
    if (str->str().empty() || !String::isUTF8(str->str())) {
      pos = startPos;
      return std::nullopt;
    }
  } else if (idchar()) {
    take(1);
    while (idchar()) {
      take(1);
    }
  } else {
    pos = startPos;
    return std::nullopt;
  }
  if (canFinish()) {
    if (str) {
      return str;
    }
    // Drop the "$".
    return buffer.substr(startPos + 1, pos - startPos - 1);
  }
  pos = startPos;
  return std::nullopt;
}

inline bool Lexer::spacechar() {
  if (empty()) {
    return false;
  }
  switch (peek()) {
    case ' ':
    case '\n':
    case '\r':
    case '\t':
      return true;
    default:
      return false;
  }
}

inline bool Lexer::takeSpacechar() {
  if (spacechar()) {
    take(1);
    return true;
  }
  return false;
}

inline bool Lexer::takeComment() {
  using namespace std::string_view_literals;

  if (remaining() < 2) {
    return false;
  }

  // Line comment
  if (!startsWith(";;@"sv) && takePrefix(";;"sv)) {
    if (auto size = next().find('\n'); size != ""sv.npos) {
      take(size);
    } else {
      takeAll();
    }
    return true;
  }

  // Block comment (possibly nested!)
  if (takePrefix("(;"sv)) {
    size_t depth = 1;
    while (depth > 0 && remaining() >= 2) {
      if (takePrefix("(;"sv)) {
        ++depth;
      } else if (takePrefix(";)"sv)) {
        --depth;
      } else {
        take(1);
      }
    }
    if (depth > 0) {
      // TODO: Add error production for non-terminated block comment.
      return false;
    }
    return true;
  }

  return false;
}

inline bool Lexer::takeSpace() {
  bool taken = false;
  while (remaining() && (takeSpacechar() || takeComment())) {
    taken = true;
    continue;
  }
  return taken;
}

inline std::optional<Annotation> Lexer::takeAnnotation() {
  using namespace std::string_view_literals;
  auto startPos = pos;
  std::string_view kind;
  std::string_view contents;
  if (takePrefix(";;@"sv)) {
    kind = "src"sv;
    auto contentPos = pos;
    if (auto size = next().find('\n'); size != ""sv.npos) {
      take(size);
    } else {
      takeAll();
    }
    contents = buffer.substr(contentPos, pos - contentPos);
  } else if (takePrefix("(@"sv)) {
    auto kindPos = pos;
    bool hasIdchar = false;
    while (idchar()) {
      take(1);
      hasIdchar = true;
    }
    if (!hasIdchar) {
      pos = startPos;
      return std::nullopt;
    }
    kind = buffer.substr(kindPos, pos - kindPos);
    auto contentPos = pos;
    size_t depth = 1;
    while (true) {
      if (empty()) {
        pos = startPos;
        return std::nullopt;
      }
      if (takeSpace() || takeKeyword() || takeInteger() || takeFloat() ||
          takeStr() || takeIdent()) {
        continue;
      }
      if (takePrefix("(@"sv)) {
        bool hasIdchar = false;
        while (idchar()) {
          take(1);
          hasIdchar = true;
        }
        if (!hasIdchar) {
          pos = startPos;
          return std::nullopt;
        }
        ++depth;
        continue;
      }
      if (takeLParen()) {
        ++depth;
        continue;
      }
      if (takePrefix(")"sv)) {
        --depth;
        if (depth == 0) {
          break;
        }
        continue;
      }
      // Unrecognized token.
      pos = startPos;
      return std::nullopt;
    }
    contents = buffer.substr(contentPos, pos - contentPos - 1);
  } else {
    return std::nullopt;
  }
  return Annotation{Name(kind), contents};
}

inline void Lexer::skipSpace() {
  while (true) {
    if (auto annotation = takeAnnotation()) {
      annotations.emplace_back(*std::move(annotation));
      continue;
    }
    if (takeSpace()) {
      continue;
    }
    break;
  }
}

inline bool Lexer::canFinish() {
  // Logically we want to check for eof, parens, and space. But we don't
  // actually want to parse more than a couple characters of space, so check
  // for individual space chars or comment starts instead.
  using namespace std::string_view_literals;
  return empty() || spacechar() || peek() == '(' || peek() == ')' ||
         startsWith(";;"sv);
}

} // namespace wasm::WATParser

#endif // parser_lexer_h
