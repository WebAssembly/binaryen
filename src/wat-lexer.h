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

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iterator>
#include <optional>
#include <ostream>
#include <string_view>
#include <variant>

#ifndef wasm_wat_lexer_h
#define wasm_wat_lexer_h

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

  std::optional<std::string_view> getID() const {
    if (std::get_if<IdTok>(&data)) {
      // Drop leading '$'.
      return span.substr(1);
    }
    return {};
  }

  std::optional<std::string_view> getKeyword() const {
    if (std::get_if<KeywordTok>(&data)) {
      return span;
    }
    return {};
  }
  std::optional<uint64_t> getU64() const;
  std::optional<int64_t> getS64() const;
  std::optional<uint64_t> getI64() const;
  std::optional<uint32_t> getU32() const;
  std::optional<int32_t> getS32() const;
  std::optional<uint32_t> getI32() const;
  std::optional<double> getF64() const;
  std::optional<float> getF32() const;
  std::optional<std::string_view> getString() const;

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
  using iterator = Lexer;
  using difference_type = std::ptrdiff_t;
  using value_type = Token;
  using pointer = const Token*;
  using reference = const Token&;
  using iterator_category = std::forward_iterator_tag;

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
    skipSpace();
    lexToken();
  }

  std::string_view next() const { return buffer.substr(index); }
  Lexer& operator++() {
    // Preincrement
    skipSpace();
    lexToken();
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

  Lexer end() const { return Lexer(); }

  bool empty() const { return *this == end(); }

  TextPos position(const char* c) const;
  TextPos position(size_t i) const { return position(buffer.data() + i); }
  TextPos position(std::string_view span) const {
    return position(span.data());
  }
  TextPos position(Token tok) const { return position(tok.span); }

private:
  void skipSpace();
  void lexToken();
};

} // namespace wasm::WATParser

#endif // wasm_wat_lexer_h
