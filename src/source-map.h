/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_source_map_h
#define wasm_source_map_h

#include <optional>
#include <unordered_map>

#include "wasm.h"

namespace wasm {

struct MapParseException {
  std::string text;

  MapParseException(std::string text) : text(text) {}
  void dump(std::ostream& o) const;
};

class SourceMapReader {
  const std::vector<char>& buffer;

  // Current position in the source map buffer.
  size_t pos = 0;

  // The location in the binary the next debug location will correspond to. 0
  // iff there are no more debug locations.
  size_t location = 0;

  // The file index, line, column, and symbol index the next debug location will
  // be offset from.
  uint32_t file = 0;
  uint32_t line = 1;
  uint32_t col = 0;
  uint32_t symbol = 0;

  // Whether the last read record had position and symbol information.
  bool hasInfo = false;
  bool hasSymbol = false;

public:
  SourceMapReader(const std::vector<char>& buffer) : buffer(buffer) {}

  void readHeader(Module& wasm);

  std::optional<Function::DebugLocation>
  readDebugLocationAt(size_t currLocation);

  // Do not reuse debug info across function boundaries.
  void finishFunction() { hasInfo = false; }

private:
  char peek() {
    if (pos >= buffer.size()) {
      throw MapParseException("unexpected end of source map");
    }
    return buffer[pos];
  }

  char get() {
    char c = peek();
    ++pos;
    return c;
  }

  bool maybeGet(char c) {
    if (pos < buffer.size() && peek() == c) {
      ++pos;
      return true;
    }
    return false;
  }

  void expect(char c) {
    using namespace std::string_literals;
    char got = get();
    if (got != c) {
      throw MapParseException("expected '"s + c + "', got '" + got + "'");
    }
  }

  int32_t readBase64VLQ();
};

} // namespace wasm

#endif // wasm_source_map_h
