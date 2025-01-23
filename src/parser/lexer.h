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
#include "support/string.h"

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

// ===========
// Annotations
// ===========

struct Annotation {
  Name kind;
  std::string_view contents;
};

extern Name srcAnnotationKind;

// =====
// Lexer
// =====

struct Lexer {
private:
  size_t pos = 0;
  std::vector<Annotation> annotations;

public:
  std::string_view buffer;

  Lexer(std::string_view buffer) : buffer(buffer) { setPos(0); }

  size_t getPos() const { return pos; }

  void setPos(size_t i) {
    pos = i;
    advance();
  }

  bool takeLParen();

  bool peekLParen() { return Lexer(*this).takeLParen(); }

  bool takeRParen();

  bool peekRParen() { return Lexer(*this).takeRParen(); }

  bool takeUntilParen() {
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

  std::optional<Name> takeID();

  std::optional<std::string_view> takeKeyword();
  bool takeKeyword(std::string_view expected);

  std::optional<std::string_view> peekKeyword() {
    return Lexer(*this).takeKeyword();
  }

  std::optional<uint64_t> takeOffset();
  std::optional<uint32_t> takeAlign();

  std::optional<uint64_t> takeU64() { return takeU<uint64_t>(); }
  std::optional<uint64_t> takeI64() { return takeI<uint64_t>(); }
  std::optional<uint32_t> takeU32() { return takeU<uint32_t>(); }
  std::optional<uint32_t> takeI32() { return takeI<uint32_t>(); }
  std::optional<uint16_t> takeI16() { return takeI<uint16_t>(); }
  std::optional<uint8_t> takeU8() { return takeU<uint8_t>(); }
  std::optional<uint8_t> takeI8() { return takeI<uint8_t>(); }

  std::optional<double> takeF64();
  std::optional<float> takeF32();

  std::optional<std::string> takeString();

  std::optional<Name> takeName() {
    auto str = takeString();
    if (!str || !String::isUTF8(*str)) {
      return std::nullopt;
    }
    return Name(*str);
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

  std::string_view next() const { return buffer.substr(pos); }

  void advance() {
    annotations.clear();
    skipSpace();
  }

  bool empty() const { return pos == buffer.size(); }

  TextPos position(const char* c) const;
  TextPos position(size_t i) const { return position(buffer.data() + i); }
  TextPos position(std::string_view span) const {
    return position(span.data());
  }
  TextPos position() const { return position(getPos()); }

  [[nodiscard]] Err err(size_t pos, std::string reason) {
    std::stringstream msg;
    msg << position(pos) << ": error: " << reason;
    return Err{msg.str()};
  }

  [[nodiscard]] Err err(std::string reason) { return err(getPos(), reason); }

  const std::vector<Annotation> getAnnotations() { return annotations; }
  std::vector<Annotation> takeAnnotations() { return std::move(annotations); }

  void setAnnotations(std::vector<Annotation>&& annotations) {
    this->annotations = std::move(annotations);
  }

private:
  template<typename T> std::optional<T> takeU();
  template<typename T> std::optional<T> takeS();
  template<typename T> std::optional<T> takeI();

  void skipSpace();
};

} // namespace wasm::WATParser

#endif // parser_lexer_h
