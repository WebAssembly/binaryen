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

  std::optional<Token> peek();
  bool takeLParen();
  bool takeRParen();
  bool takeUntilParen();
  std::optional<Name> takeID();
  std::optional<std::string_view> takeKeyword();
  bool takeKeyword(std::string_view expected);
  std::optional<uint64_t> takeOffset();
  std::optional<uint32_t> takeAlign();
  std::optional<uint64_t> takeU64();
  std::optional<int64_t> takeS64();
  std::optional<int64_t> takeI64();
  std::optional<uint32_t> takeU32();
  std::optional<int32_t> takeS32();
  std::optional<int32_t> takeI32();
  std::optional<uint8_t> takeU8();
  std::optional<double> takeF64();
  std::optional<float> takeF32();
  std::optional<std::string_view> takeString();
  std::optional<Name> takeName();
  bool takeSExprStart(std::string_view expected);
  bool peekSExprStart(std::string_view expected);

  Index getPos();
  [[nodiscard]] Err err(Index pos, std::string reason);
  [[nodiscard]] Err err(std::string reason) { return err(getPos(), reason); }
};

#include "input-impl.h"

} // namespace wasm::WATParser

#endif // parser_input_h
