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

std::ostream& printEscaped(std::ostream& os, const std::string_view str) {
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

std::ostream& printEscapedJSON(std::ostream& os, const std::string_view str) {
  os << '"';
  constexpr uint32_t replacementCharacter = 0xFFFD;
  bool lastWasLeadingSurrogate = false;
  for (size_t i = 0; i < str.size();) {
    // Decode from WTF-8 into a unicode code point.
    uint8_t leading = str[i];
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
      std::cerr << "warning: Bad WTF-8 leading byte (" << std::hex << leading
                << std::dec << "). Replacing.\n";
      trailingBytes = 0;
      u = replacementCharacter;
    }

    ++i;

    if (i + trailingBytes > str.size()) {
      std::cerr << "warning: Unexpected end of string. Replacing.\n";
      u = replacementCharacter;
    } else {
      for (size_t j = 0; j < trailingBytes; ++j) {
        uint8_t trailing = str[i + j];
        if ((trailing & 0b11000000) != 0b10000000) {
          std::cerr << "warning: Bad WTF-8 trailing byte (" << std::hex
                    << trailing << std::dec << "). Replacing.\n";
          u = replacementCharacter;
          break;
        }
        // Shift 6 bits for every remaining trailing byte after this one.
        u |= (trailing & 0b00111111) << (6 * (trailingBytes - j - 1));
      }
    }

    i += trailingBytes;

    bool isLeadingSurrogate = 0xD800 <= u && u <= 0xDBFF;
    bool isTrailingSurrogate = 0xDC00 <= u && u <= 0xDFFF;
    if (lastWasLeadingSurrogate && isTrailingSurrogate) {
      std::cerr << "warning: Invalid surrogate sequence in WTF-8.\n";
    }
    lastWasLeadingSurrogate = isLeadingSurrogate;

    // Encode unicode code point into JSON.
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
