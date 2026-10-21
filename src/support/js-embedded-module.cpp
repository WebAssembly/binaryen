/*
 * Copyright 2026 WebAssembly Community Group participants
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

#include "support/js-embedded-module.h"

#include <cctype>
#include <cstdint>

namespace wasm {

namespace {

// Advances `pos` past a `//` single-line comment (leaving `pos` at the newline
// character or end of `js`). Assumes `js.substr(pos, 2) == "//"`.
void skipSingleLineComment(std::string_view js, size_t& pos) {
  pos += 2;
  while (pos < js.size() && js[pos] != '\n') {
    ++pos;
  }
}

// Advances `pos` past a `/* ... */` multi-line comment (or to the end of `js`
// if the comment is unterminated). Assumes `js.substr(pos, 2) == "/*"`.
void skipMultiLineComment(std::string_view js, size_t& pos) {
  pos += 2;
  while (pos + 1 < js.size() && !(js[pos] == '*' && js[pos + 1] == '/')) {
    ++pos;
  }
  if (pos + 1 < js.size()) {
    pos += 2;
  } else {
    pos = js.size();
  }
}

// Advances `pos` past any contiguous ASCII whitespace, single-line comments,
// and multi-line comments.
void skipWhitespaceAndComments(std::string_view js, size_t& pos) {
  while (pos < js.size()) {
    if (std::isspace(static_cast<unsigned char>(js[pos]))) {
      ++pos;
    } else if (pos + 1 < js.size() && js[pos] == '/' && js[pos + 1] == '/') {
      skipSingleLineComment(js, pos);
    } else if (pos + 1 < js.size() && js[pos] == '/' && js[pos + 1] == '*') {
      skipMultiLineComment(js, pos);
    } else {
      break;
    }
  }
}

// Parses a single integer literal representing an 8-bit byte at `pos` (in
// decimal, `0x` hex, `0o` octal, or `0b` binary, with optional `+`/`-` sign and
// `_` numeric separators). Accepts unsigned values in [0, 255] and signed
// negative values in [-128, -1]. On success, advances `pos` past the literal,
// writes the byte to `outByte`, and returns true.
bool parseByteLiteral(std::string_view js, size_t& pos, char& outByte) {
  if (pos >= js.size()) {
    return false;
  }

  bool negative = false;
  if (js[pos] == '-' || js[pos] == '+') {
    negative = (js[pos] == '-');
    ++pos;
    if (pos >= js.size()) {
      return false;
    }
  }

  int base = 10;
  if (js[pos] == '0' && pos + 1 < js.size()) {
    char next = js[pos + 1];
    if (next == 'x' || next == 'X') {
      base = 16;
      pos += 2;
    } else if (next == 'o' || next == 'O') {
      base = 8;
      pos += 2;
    } else if (next == 'b' || next == 'B') {
      base = 2;
      pos += 2;
    }
  }

  uint32_t value = 0;
  bool hasDigits = false;
  while (pos < js.size()) {
    char c = js[pos];
    if (c == '_') {
      ++pos;
      continue;
    }
    int digit = -1;
    if (c >= '0' && c <= '9') {
      digit = c - '0';
    } else if (c >= 'a' && c <= 'f') {
      digit = 10 + (c - 'a');
    } else if (c >= 'A' && c <= 'F') {
      digit = 10 + (c - 'A');
    } else {
      break;
    }
    if (digit >= base) {
      return false;
    }
    hasDigits = true;
    value = value * base + digit;
    if ((!negative && value > 255) || (negative && value > 128)) {
      return false;
    }
    ++pos;
  }

  if (!hasDigits) {
    return false;
  }

  // Ensure the literal is not immediately followed by an identifier character.
  if (pos < js.size() &&
      (std::isalnum(static_cast<unsigned char>(js[pos])) || js[pos] == '_')) {
    return false;
  }

  if (negative) {
    outByte = static_cast<char>(static_cast<uint8_t>(-static_cast<int>(value)));
  } else {
    outByte = static_cast<char>(static_cast<uint8_t>(value));
  }
  return true;
}

// Attempts to parse a JavaScript array literal starting at index `start`
// (`js[start] == '['`) as an embedded WebAssembly module. Rejects early if the
// first 4 elements do not match the `\0asm` magic bytes (`0x00, 0x61, 0x73,
// 0x6d`) or if any element is not a valid byte literal.
bool tryParseWasmByteArray(std::string_view js,
                           size_t start,
                           EmbeddedModule& outModule) {
  static constexpr uint8_t WasmMagic[4] = {0x00, 0x61, 0x73, 0x6d};

  size_t pos = start + 1;
  std::vector<char> bytes;

  while (true) {
    skipWhitespaceAndComments(js, pos);
    if (pos >= js.size()) {
      return false;
    }
    if (js[pos] == ']') {
      if (bytes.size() < 4) {
        return false;
      }
      outModule = EmbeddedModule{start, pos + 1, std::move(bytes)};
      return true;
    }

    char byteVal = 0;
    if (!parseByteLiteral(js, pos, byteVal)) {
      return false;
    }

    // Early rejection if the first 4 bytes do not match \0asm.
    if (bytes.size() < 4 &&
        static_cast<uint8_t>(byteVal) != WasmMagic[bytes.size()]) {
      return false;
    }

    bytes.push_back(byteVal);

    skipWhitespaceAndComments(js, pos);
    if (pos >= js.size()) {
      return false;
    }
    if (js[pos] == ',') {
      ++pos;
    } else if (js[pos] != ']') {
      return false;
    }
  }
}

} // namespace

std::vector<EmbeddedModule> findEmbeddedModules(std::string_view js) {
  std::vector<EmbeddedModule> modules;
  size_t pos = 0;

  while (pos < js.size()) {
    char c = js[pos];

    // Skip single-line and multi-line comments.
    if (c == '/' && pos + 1 < js.size()) {
      if (js[pos + 1] == '/') {
        skipSingleLineComment(js, pos);
        continue;
      }
      if (js[pos + 1] == '*') {
        skipMultiLineComment(js, pos);
        continue;
      }
    }

    // Skip string and template literals.
    if (c == '\'' || c == '"' || c == '`') {
      char quote = c;
      ++pos;
      while (pos < js.size()) {
        if (js[pos] == '\\') {
          pos += 2;
          continue;
        }
        if (js[pos] == quote) {
          ++pos;
          break;
        }
        if (quote != '`' && (js[pos] == '\n' || js[pos] == '\r')) {
          // Single- and double-quoted JS strings cannot span unescaped lines.
          ++pos;
          break;
        }
        ++pos;
      }
      continue;
    }

    if (c == '[') {
      EmbeddedModule mod;
      if (tryParseWasmByteArray(js, pos, mod)) {
        pos = mod.end;
        modules.push_back(std::move(mod));
        continue;
      }
    }

    ++pos;
  }

  return modules;
}

std::string formatByteArray(const std::vector<char>& bytes) {
  if (bytes.empty()) {
    return "[]";
  }

  static constexpr char HexDigits[] = "0123456789abcdef";
  std::string out = "[\n";
  // Each byte takes ~6 chars ("0x00, "), plus indentation and brackets.
  out.reserve(bytes.size() * 6 + (bytes.size() / 16 + 1) * 4 + 4);

  for (size_t i = 0; i < bytes.size(); ++i) {
    if (i % 16 == 0) {
      out += "  ";
    }
    uint8_t b = static_cast<uint8_t>(bytes[i]);
    out += "0x";
    out += HexDigits[b >> 4];
    out += HexDigits[b & 0x0f];
    if (i + 1 < bytes.size()) {
      if ((i + 1) % 16 == 0) {
        out += ",\n";
      } else {
        out += ", ";
      }
    } else {
      out += "\n]";
    }
  }

  return out;
}

} // namespace wasm
