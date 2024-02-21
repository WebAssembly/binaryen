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

#ifndef parser_input_h
#define parser_input_h

#include "lexer.h"
#include "support/result.h"
#include "wasm.h"

namespace wasm::WATParser {

using namespace std::string_view_literals;

// Wraps a lexer and provides utilities for consuming tokens.
struct ParseInput {
  Lexer lexer;

  explicit ParseInput(std::string_view in) : lexer(in) {}

  ParseInput(std::string_view in, size_t index) : lexer(in) {
    lexer.setIndex(index);
  }

  ParseInput(const ParseInput& other, size_t index) : lexer(other.lexer) {
    lexer.setIndex(index);
  }

  bool empty() { return lexer.empty(); }

  // TODO: Remove this useless layer of abstraction between the Lexer and
  // Parser.
  std::optional<Token> peek() { return lexer.peek(); }
  bool takeLParen() { return lexer.takeLParen(); }
  bool takeRParen() { return lexer.takeRParen(); }
  bool takeUntilParen() { return lexer.takeUntilParen(); }
  std::optional<Name> takeID() { return lexer.takeID(); }
  std::optional<std::string_view> takeKeyword() { return lexer.takeKeyword(); }
  bool takeKeyword(std::string_view expected) {
    return lexer.takeKeyword(expected);
  }
  std::optional<uint64_t> takeOffset() { return lexer.takeOffset(); }
  std::optional<uint32_t> takeAlign() { return lexer.takeAlign(); }
  std::optional<uint64_t> takeU64() { return lexer.takeU64(); }
  std::optional<uint64_t> takeI64() { return lexer.takeI64(); }
  std::optional<uint32_t> takeU32() { return lexer.takeU32(); }
  std::optional<uint32_t> takeI32() { return lexer.takeI32(); }
  std::optional<uint16_t> takeI16() { return lexer.takeI16(); }
  std::optional<uint8_t> takeU8() { return lexer.takeU8(); }
  std::optional<uint8_t> takeI8() { return lexer.takeI8(); }
  std::optional<double> takeF64() { return lexer.takeF64(); }
  std::optional<float> takeF32() { return lexer.takeF32(); }
  std::optional<std::string> takeString() { return lexer.takeString(); }
  std::optional<Name> takeName() { return lexer.takeName(); }
  bool takeSExprStart(std::string_view expected) {
    return lexer.takeSExprStart(expected);
  }
  bool peekSExprStart(std::string_view expected) {
    return lexer.peekSExprStart(expected);
  }

  Index getPos() { return lexer.getPos(); }

  [[nodiscard]] Err err(Index pos, std::string reason) {
    std::stringstream msg;
    msg << lexer.position(pos) << ": error: " << reason;
    return Err{msg.str()};
  }

  [[nodiscard]] Err err(std::string reason) { return err(getPos(), reason); }
};

} // namespace wasm::WATParser

#endif // parser_input_h
