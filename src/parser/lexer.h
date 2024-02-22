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

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iterator>
#include <optional>
#include <ostream>
#include <string_view>
#include <variant>

#include "support/name.h"
#include "support/result.h"

#ifndef parser_lexer_h
#define parser_lexer_h

namespace wasm::WATParser {

struct TextPos {
  size_t line;
  size_t col;

  bool operator==(const TextPos& other) const;
  bool operator!=(const TextPos& other) const { return !(*this == other); }

  friend std::ostream& operator<<(std::ostream& os, const TextPos& pos);
};

// ======
// Tokens
// ======

struct LParenTok {
  bool operator==(const LParenTok&) const { return true; }
  friend std::ostream& operator<<(std::ostream&, const LParenTok&);
};

struct RParenTok {
  bool operator==(const RParenTok&) const { return true; }
  friend std::ostream& operator<<(std::ostream&, const RParenTok&);
};

struct IdTok {
  // Whether this ID has `$"..."` format
  bool isStr;

  // If the ID is a string ID and contains escapes, this is its contents.
  std::optional<std::string> str;

  bool operator==(const IdTok&) const { return true; }
  friend std::ostream& operator<<(std::ostream&, const IdTok&);
};

enum Sign { NoSign, Pos, Neg };

struct IntTok {
  uint64_t n;
  Sign sign;

  bool operator==(const IntTok&) const;
  friend std::ostream& operator<<(std::ostream&, const IntTok&);
};

struct FloatTok {
  // The payload if we lexed a nan with payload. We cannot store the payload
  // directly in `d` because we do not know at this point whether we are parsing
  // an f32 or f64 and therefore we do not know what the allowable payloads are.
  // No payload with NaN means to use the default payload for the expected float
  // width.
  std::optional<uint64_t> nanPayload;
  double d;

  bool operator==(const FloatTok&) const;
  friend std::ostream& operator<<(std::ostream&, const FloatTok&);
};

struct StringTok {
  // If the string contains escapes, this is its contents.
  std::optional<std::string> str;

  bool operator==(const StringTok& other) const { return str == other.str; }
  friend std::ostream& operator<<(std::ostream&, const StringTok&);
};

struct KeywordTok {
  bool operator==(const KeywordTok&) const { return true; }
  friend std::ostream& operator<<(std::ostream&, const KeywordTok&);
};

struct Token {
  using Data = std::variant<LParenTok,
                            RParenTok,
                            IdTok,
                            IntTok,
                            FloatTok,
                            StringTok,
                            KeywordTok>;
  std::string_view span;
  Data data;

  // ====================
  // Token classification
  // ====================

  bool isLParen() const { return std::get_if<LParenTok>(&data); }

  bool isRParen() const { return std::get_if<RParenTok>(&data); }

  std::optional<std::string_view> getKeyword() const {
    if (std::get_if<KeywordTok>(&data)) {
      return span;
    }
    return {};
  }

  template<typename T> std::optional<T> getU() const;
  template<typename T> std::optional<T> getS() const;
  template<typename T> std::optional<T> getI() const;
  std::optional<double> getF64() const;
  std::optional<float> getF32() const;
  std::optional<std::string_view> getString() const;
  std::optional<std::string_view> getID() const;

  bool operator==(const Token&) const;
  friend std::ostream& operator<<(std::ostream& os, const Token&);
};

// =====
// Lexer
// =====

// Lexer's purpose is twofold. First, it wraps a buffer to provide a tokenizing
// iterator over it. Second, it implements that iterator itself. Also provides
// utilities for locating the text position of tokens within the buffer. Text
// positions are computed on demand rather than eagerly because they are
// typically only needed when there is an error to report.
struct Lexer {
private:
  std::string_view buffer;
  size_t index = 0;
  std::optional<Token> curr;

public:
  // The end sentinel.
  Lexer() = default;

  Lexer(std::string_view buffer) : buffer(buffer) { setIndex(0); }

  size_t getIndex() const { return index; }

  void setIndex(size_t i) {
    index = i;
    advance();
  }

  bool takeLParen() {
    if (!curr || !curr->isLParen()) {
      return false;
    }
    advance();
    return true;
  }

  bool peekLParen() { return Lexer(*this).takeLParen(); }

  bool takeRParen() {
    if (!curr || !curr->isRParen()) {
      return false;
    }
    advance();
    return true;
  }

  bool peekRParen() { return Lexer(*this).takeRParen(); }

  bool takeUntilParen() {
    while (true) {
      if (!curr) {
        return false;
      }
      if (curr->isLParen() || curr->isRParen()) {
        return true;
      }
      advance();
    }
  }

  std::optional<Name> takeID() {
    if (curr) {
      if (auto id = curr->getID()) {
        advance();
        // See comment on takeName.
        return Name(std::string(*id));
      }
    }
    return {};
  }

  std::optional<std::string_view> takeKeyword() {
    if (curr) {
      if (auto keyword = curr->getKeyword()) {
        advance();
        return *keyword;
      }
    }
    return {};
  }

  std::optional<std::string_view> peekKeyword() {
    return Lexer(*this).takeKeyword();
  }

  bool takeKeyword(std::string_view expected) {
    if (curr) {
      if (auto keyword = curr->getKeyword()) {
        if (*keyword == expected) {
          advance();
          return true;
        }
      }
    }
    return false;
  }

  std::optional<uint64_t> takeOffset() {
    using namespace std::string_view_literals;
    if (curr) {
      if (auto keyword = curr->getKeyword()) {
        if (keyword->substr(0, 7) != "offset="sv) {
          return {};
        }
        Lexer subLexer(keyword->substr(7));
        if (subLexer.empty()) {
          return {};
        }
        if (auto o = subLexer.curr->getU<uint64_t>()) {
          subLexer.advance();
          if (subLexer.empty()) {
            advance();
            return o;
          }
        }
      }
    }
    return std::nullopt;
  }

  std::optional<uint32_t> takeAlign() {
    using namespace std::string_view_literals;
    if (curr) {
      if (auto keyword = curr->getKeyword()) {
        if (keyword->substr(0, 6) != "align="sv) {
          return {};
        }
        Lexer subLexer(keyword->substr(6));
        if (subLexer.empty()) {
          return {};
        }
        if (auto a = subLexer.curr->getU<uint32_t>()) {
          subLexer.advance();
          if (subLexer.empty()) {
            advance();
            return a;
          }
        }
      }
    }
    return {};
  }

  template<typename T> std::optional<T> takeU() {
    if (curr) {
      if (auto n = curr->getU<T>()) {
        advance();
        return n;
      }
    }
    return std::nullopt;
  }

  template<typename T> std::optional<T> takeI() {
    if (curr) {
      if (auto n = curr->getI<T>()) {
        advance();
        return n;
      }
    }
    return std::nullopt;
  }

  std::optional<uint64_t> takeU64() { return takeU<uint64_t>(); }

  std::optional<uint64_t> takeI64() { return takeI<uint64_t>(); }

  std::optional<uint32_t> takeU32() { return takeU<uint32_t>(); }

  std::optional<uint32_t> takeI32() { return takeI<uint32_t>(); }

  std::optional<uint16_t> takeI16() { return takeI<uint16_t>(); }

  std::optional<uint8_t> takeU8() { return takeU<uint8_t>(); }

  std::optional<uint8_t> takeI8() { return takeI<uint8_t>(); }

  std::optional<double> takeF64() {
    if (curr) {
      if (auto d = curr->getF64()) {
        advance();
        return d;
      }
    }
    return std::nullopt;
  }

  std::optional<float> takeF32() {
    if (curr) {
      if (auto f = curr->getF32()) {
        advance();
        return f;
      }
    }
    return std::nullopt;
  }

  std::optional<std::string> takeString() {
    if (curr) {
      if (auto s = curr->getString()) {
        std::string ret(*s);
        advance();
        return ret;
      }
    }
    return {};
  }

  std::optional<Name> takeName() {
    // TODO: Move this to lexer and validate UTF.
    if (auto str = takeString()) {
      // Copy to a std::string to make sure we have a null terminator, otherwise
      // the `Name` constructor won't work correctly.
      // TODO: Update `Name` to use string_view instead of char* and/or to take
      // rvalue strings to avoid this extra copy.
      return Name(std::string(*str));
    }
    return {};
  }

  bool takeSExprStart(std::string_view expected) {
    auto original = *this;
    if (takeLParen() && takeKeyword(expected)) {
      return true;
    }
    *this = original;
    return false;
  }

  bool peekSExprStart(std::string_view expected) {
    auto original = *this;
    if (!takeLParen()) {
      return false;
    }
    bool ret = takeKeyword(expected);
    *this = original;
    return ret;
  }

  std::string_view next() const { return buffer.substr(index); }

  void advance() {
    skipSpace();
    lexToken();
  }

  bool empty() const { return !curr; }

  TextPos position(const char* c) const;
  TextPos position(size_t i) const { return position(buffer.data() + i); }
  TextPos position(std::string_view span) const {
    return position(span.data());
  }
  TextPos position() const { return position(getPos()); }

  size_t getPos() const {
    if (curr) {
      return getIndex() - curr->span.size();
    }
    return getIndex();
  }

  [[nodiscard]] Err err(size_t pos, std::string reason) {
    std::stringstream msg;
    msg << position(pos) << ": error: " << reason;
    return Err{msg.str()};
  }

  [[nodiscard]] Err err(std::string reason) { return err(getPos(), reason); }

private:
  void skipSpace();
  void lexToken();
};

} // namespace wasm::WATParser

#endif // parser_lexer_h
