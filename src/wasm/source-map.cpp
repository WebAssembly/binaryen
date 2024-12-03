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

#include "source-map.h"
#include "support/colors.h"

namespace wasm {

std::vector<char> defaultEmptySourceMap;

void MapParseException::dump(std::ostream& o) const {
  Colors::magenta(o);
  o << "[";
  Colors::red(o);
  o << "map parse exception: ";
  Colors::green(o);
  o << text;
  Colors::magenta(o);
  o << "]";
  Colors::normal(o);
}

void SourceMapReader::readHeader(Module& wasm) {
  assert(pos == 0);
  if (buffer.empty()) {
    return;
  }

  auto skipWhitespace = [&]() {
    while (pos < buffer.size() && (buffer[pos] == ' ' || buffer[pos] == '\n')) {
      ++pos;
    }
  };

  auto findField = [&](const char* name) {
    bool matching = false;
    size_t len = strlen(name);
    size_t index = 0;
    while (1) {
      char ch = get();
      if (ch == '\"') {
        if (matching) {
          if (index == len) {
            // We matched a terminating quote.
            break;
          }
          matching = false;
        } else {
          // Beginning of a new potential match.
          matching = true;
          index = 0;
        }
      } else if (matching && name[index] == ch) {
        ++index;
      } else if (matching) {
        matching = false;
      }
    }
    skipWhitespace();
    expect(':');
    skipWhitespace();
    return true;
  };

  auto readString = [&](std::string& str) {
    std::vector<char> vec;
    skipWhitespace();
    expect('\"');
    while (1) {
      if (maybeGet('\"')) {
        break;
      }
      vec.push_back(get());
    }
    skipWhitespace();
    str = std::string(vec.begin(), vec.end());
  };

  if (!findField("sources")) {
    throw MapParseException("cannot find the 'sources' field in map");
  }

  skipWhitespace();
  expect('[');
  if (!maybeGet(']')) {
    do {
      std::string file;
      readString(file);
      wasm.debugInfoFileNames.push_back(file);
    } while (maybeGet(','));
    expect(']');
  }

  if (findField("names")) {
    skipWhitespace();
    expect('[');
    if (!maybeGet(']')) {
      do {
        std::string symbol;
        readString(symbol);
        wasm.debugInfoSymbolNames.push_back(symbol);
      } while (maybeGet(','));
      expect(']');
    }
  }

  if (!findField("mappings")) {
    throw MapParseException("cannot find the 'mappings' field in map");
  }

  expect('\"');
  if (maybeGet('\"')) {
    // There are no mappings.
    location = 0;
    return;
  }

  // Read the location of the first debug location.
  location = readBase64VLQ();
}

std::optional<Function::DebugLocation>
SourceMapReader::readDebugLocationAt(size_t currLocation) {
  if (pos >= buffer.size()) {
    return std::nullopt;
  }

  while (location && location <= currLocation) {
    do {
      char next = peek();
      if (next == ',' || next == '\"') {
        // This is a 1-length entry, so the next location has no debug info.
        hasInfo = false;
        break;
      }

      hasInfo = true;
      file += readBase64VLQ();
      line += readBase64VLQ();
      col += readBase64VLQ();

      next = peek();
      if (next == ',' || next == '\"') {
        hasSymbol = false;
        break;
      }

      hasSymbol = true;
      symbol += readBase64VLQ();

    } while (false);

    // Check whether there is another record to read the position for.
    char next = get();
    if (next == '\"') {
      // End of records.
      location = 0;
      break;
    }
    if (next != ',') {
      throw MapParseException("Expected delimiter");
    }

    // Set up for the next record.
    location += readBase64VLQ();
  }

  if (!hasInfo) {
    return std::nullopt;
  }

  auto sym = hasSymbol ? symbol : std::optional<uint32_t>{};
  return Function::DebugLocation{file, line, col, sym};
}

int32_t SourceMapReader::readBase64VLQ() {
  uint32_t value = 0;
  uint32_t shift = 0;
  while (1) {
    auto ch = get();
    if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch < 'g')) {
      // last number digit
      uint32_t digit = ch < 'a' ? ch - 'A' : ch - 'a' + 26;
      value |= digit << shift;
      break;
    }
    if (!(ch >= 'g' && ch <= 'z') && !(ch >= '0' && ch <= '9') && ch != '+' &&
        ch != '/') {
      throw MapParseException("invalid VLQ digit");
    }
    uint32_t digit =
      ch > '9' ? ch - 'g' : (ch >= '0' ? ch - '0' + 20 : (ch == '+' ? 30 : 31));
    value |= digit << shift;
    shift += 5;
  }
  return value & 1 ? -int32_t(value >> 1) : int32_t(value >> 1);
}

} // namespace wasm
