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

#include <optional>
#include <ostream>

#include "support/string.h"

namespace wasm::String {

Split::Split(const std::string& input, const NewLineOr& newLineOrDelim) {
  auto first = input.find("\n", 0);
  if (first != std::string::npos && first != input.length() - 1) {
    split(input, "\n");
  } else {
    split(input, newLineOrDelim.delim);
  }
}

void Split::split(const std::string& input, const std::string& delim) {
  size_t lastEnd = 0;
  while (lastEnd < input.size()) {
    auto nextDelim = input.find(delim, lastEnd);
    if (nextDelim == std::string::npos) {
      nextDelim = input.size();
    }
    (*this).push_back(input.substr(lastEnd, nextDelim - lastEnd));
    lastEnd = nextDelim + delim.size();
  }
  needToHandleBracketingOperations = delim != "\n";
}

Split handleBracketingOperators(Split split) {
  if (!split.needToHandleBracketingOperations) {
    return split;
  }

  Split ret;
  std::string last;
  int nesting = 0;
  auto handlePart = [&](std::string part) {
    if (part.empty()) {
      return;
    }
    for (const char c : part) {
      if (c == '(' || c == '<' || c == '[' || c == '{') {
        nesting++;
      } else if (c == ')' || c == '>' || c == ']' || c == '}') {
        nesting--;
      }
    }
    if (last.empty()) {
      last = part;
    } else {
      last += ',' + part;
    }
    if (nesting == 0) {
      ret.push_back(last);
      last.clear();
    }
  };
  for (auto& part : split) {
    handlePart(part);
  }
  handlePart("");
  if (nesting != 0) {
    Fatal() << "Asyncify: failed to parse lists";
  }
  return ret;
}

bool wildcardMatch(const std::string& pattern, const std::string& value) {
  for (size_t i = 0; i < pattern.size(); i++) {
    if (pattern[i] == '*') {
      return wildcardMatch(pattern.substr(i + 1), value.substr(i)) ||
             (value.size() > 0 &&
              wildcardMatch(pattern.substr(i), value.substr(i + 1)));
    }
    if (i >= value.size()) {
      return false;
    }
    if (pattern[i] != value[i]) {
      return false;
    }
  }
  return value.size() == pattern.size();
}

std::string trim(const std::string& input) {
  size_t size = input.size();
  while (size > 0 && (isspace(input[size - 1]) || input[size - 1] == '\0')) {
    size--;
  }
  return input.substr(0, size);
}

std::ostream& printEscaped(std::ostream& os, std::string_view str) {
  os << '"';
  for (unsigned char c : str) {
    switch (c) {
      case '\t':
        os << "\\t";
        break;
      case '\n':
        os << "\\n";
        break;
      case '\r':
        os << "\\r";
        break;
      case '"':
        os << "\\\"";
        break;
      case '\'':
        os << "\\'";
        break;
      case '\\':
        os << "\\\\";
        break;
      default: {
        if (c >= 32 && c < 127) {
          os << c;
        } else {
          os << std::hex << '\\' << (c / 16) << (c % 16) << std::dec;
        }
      }
    }
  }
  return os << '"';
}

namespace {

std::optional<uint32_t> takeWTF8CodePoint(std::string_view& str) {
  bool valid = true;

  if (str.size() == 0) {
    return std::nullopt;
  }

  uint8_t leading = str[0];
  size_t trailingBytes;
  uint32_t u;
  if ((leading & 0b10000000) == 0b00000000) {
    // 0xxxxxxx
    trailingBytes = 0;
    u = leading;
  } else if ((leading & 0b11100000) == 0b11000000) {
    // 110xxxxx 10xxxxxx
    trailingBytes = 1;
    u = (leading & 0b00011111) << 6;
  } else if ((leading & 0b11110000) == 0b11100000) {
    // 1110xxxx 10xxxxxx 10xxxxxx
    trailingBytes = 2;
    u = (leading & 0b00001111) << 12;
  } else if ((leading & 0b11111000) == 0b11110000) {
    // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
    trailingBytes = 3;
    u = (leading & 0b00000111) << 18;
  } else {
    // Bad WTF-8 leading byte.
    trailingBytes = 0;
    valid = false;
  }

  if (str.size() <= trailingBytes) {
    // Unexpected end of string.
    str = str.substr(str.size());
    return std::nullopt;
  }

  if (valid) {
    for (size_t j = 0; j < trailingBytes; ++j) {
      uint8_t trailing = str[1 + j];
      if ((trailing & 0b11000000) != 0b10000000) {
        // Bad WTF-8 trailing byte.
        valid = false;
        break;
      }
      // Shift 6 bits for every remaining trailing byte after this one.
      u |= (trailing & 0b00111111) << (6 * (trailingBytes - j - 1));
    }
  }

  str = str.substr(1 + trailingBytes);
  if (!valid) {
    return std::nullopt;
  }
  return u;
}

std::optional<uint16_t> takeWTF16CodeUnit(std::string_view& str) {
  if (str.size() < 2) {
    str = str.substr(str.size());
    return std::nullopt;
  }

  // Use a little-endian encoding.
  uint16_t u = uint8_t(str[0]) | (uint8_t(str[1]) << 8);
  str = str.substr(2);
  return u;
}

std::optional<uint32_t> takeWTF16CodePoint(std::string_view& str,
                                           bool allowWTF = true) {
  auto u = takeWTF16CodeUnit(str);
  if (!u) {
    return std::nullopt;
  }

  if (0xD800 <= *u && *u < 0xDC00) {
    // High surrogate; take the next low surrogate if it exists.
    auto next = str;
    auto low = takeWTF16CodeUnit(next);
    if (low && 0xDC00 <= *low && *low < 0xE000) {
      str = next;
      uint16_t highBits = *u - 0xD800;
      uint16_t lowBits = *low - 0xDC00;
      return 0x10000 + ((highBits << 10) | lowBits);
    } else if (!allowWTF) {
      // Unpaired high surrogate.
      return std::nullopt;
    }
  } else if (!allowWTF && 0xDC00 <= *u && *u < 0xE000) {
    // Unpaired low surrogate.
    return std::nullopt;
  }

  return *u;
}

void writeWTF16CodeUnit(std::ostream& os, uint16_t u) {
  // Little-endian encoding.
  os << uint8_t(u & 0xFF);
  os << uint8_t(u >> 8);
}

constexpr uint32_t replacementCharacter = 0xFFFD;

bool doConvertWTF16ToWTF8(std::ostream& os,
                          std::string_view str,
                          bool allowWTF) {
  bool valid = true;

  while (str.size()) {
    auto u = takeWTF16CodePoint(str, allowWTF);
    if (!u) {
      valid = false;
      u = replacementCharacter;
    }
    writeWTF8CodePoint(os, *u);
  }

  return valid;
}

} // anonymous namespace

std::ostream& writeWTF8CodePoint(std::ostream& os, uint32_t u) {
  assert(u < 0x110000);
  if (u < 0x80) {
    // 0xxxxxxx
    os << uint8_t(u);
  } else if (u < 0x800) {
    // 110xxxxx 10xxxxxx
    os << uint8_t(0b11000000 | ((u >> 6) & 0b00011111));
    os << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
  } else if (u < 0x10000) {
    // 1110xxxx 10xxxxxx 10xxxxxx
    os << uint8_t(0b11100000 | ((u >> 12) & 0b00001111));
    os << uint8_t(0b10000000 | ((u >> 6) & 0b00111111));
    os << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
  } else {
    // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
    os << uint8_t(0b11110000 | ((u >> 18) & 0b00000111));
    os << uint8_t(0b10000000 | ((u >> 12) & 0b00111111));
    os << uint8_t(0b10000000 | ((u >> 6) & 0b00111111));
    os << uint8_t(0b10000000 | ((u >> 0) & 0b00111111));
  }
  return os;
}

std::ostream& writeWTF16CodePoint(std::ostream& os, uint32_t u) {
  assert(u < 0x110000);
  if (u < 0x10000) {
    writeWTF16CodeUnit(os, u);
  } else {
    // Encode with a surrogate pair.
    uint16_t high = 0xD800 + ((u - 0x10000) >> 10);
    uint16_t low = 0xDC00 + ((u - 0x10000) & 0x3FF);
    writeWTF16CodeUnit(os, high);
    writeWTF16CodeUnit(os, low);
  }
  return os;
}

bool convertWTF8ToWTF16(std::ostream& os, std::string_view str) {
  bool valid = true;
  bool lastWasLeadingSurrogate = false;

  while (str.size()) {
    auto u = takeWTF8CodePoint(str);
    if (!u) {
      valid = false;
      u = replacementCharacter;
    }

    bool isLeadingSurrogate = 0xD800 <= *u && *u < 0xDC00;
    bool isTrailingSurrogate = 0xDC00 <= *u && *u < 0xE000;
    if (lastWasLeadingSurrogate && isTrailingSurrogate) {
      // Invalid surrogate sequence.
      valid = false;
    }
    lastWasLeadingSurrogate = isLeadingSurrogate;

    writeWTF16CodePoint(os, *u);
  }

  return valid;
}

bool convertWTF16ToWTF8(std::ostream& os, std::string_view str) {
  return doConvertWTF16ToWTF8(os, str, true);
}

bool convertUTF16ToUTF8(std::ostream& os, std::string_view str) {
  return doConvertWTF16ToWTF8(os, str, false);
}

std::ostream& printEscapedJSON(std::ostream& os, std::string_view str) {
  os << '"';
  while (str.size()) {
    auto u = *takeWTF16CodePoint(str);

    // Use escape sequences mandated by the JSON spec.
    switch (u) {
      case '"':
        os << "\\\"";
        continue;
      case '\\':
        os << "\\\\";
        continue;
      case '\b':
        os << "\\b";
        continue;
      case '\f':
        os << "\\f";
        continue;
      case '\n':
        os << "\\n";
        continue;
      case '\r':
        os << "\\r";
        continue;
      case '\t':
        os << "\\t";
        continue;
      default:
        break;
    }

    // TODO: To minimize size, consider additionally escaping only other control
    // characters (u <= 0x1F) and surrogates, emitting everything else directly
    // assuming a UTF-8 encoding of the JSON text. We don't do this now because
    // Print.cpp would consider the contents unprintable, messing up our test.
    bool isNaivelyPrintable = 32 <= u && u < 127;
    if (isNaivelyPrintable) {
      assert(u < 0x80 && "need additional logic to emit valid UTF-8");
      os << uint8_t(u);
      continue;
    }

    // Escape as '\uXXXX` for code points less than 0x10000 or as a
    // '\uXXXX\uYYYY' surrogate pair otherwise.
    auto printEscape = [&os](uint32_t codePoint) {
      assert(codePoint < 0x10000);
      os << std::hex << "\\u";
      os << ((codePoint & 0xF000) >> 12);
      os << ((codePoint & 0x0F00) >> 8);
      os << ((codePoint & 0x00F0) >> 4);
      os << (codePoint & 0x000F);
      os << std::dec;
    };
    if (u < 0x10000) {
      printEscape(u);
    } else {
      assert(u <= 0x10FFFF && "unexpectedly high code point");
      printEscape(0xD800 + ((u - 0x10000) >> 10));
      printEscape(0xDC00 + ((u - 0x10000) & 0x3FF));
    }
  }
  return os << '"';
}

} // namespace wasm::String
