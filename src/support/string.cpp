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
  for (size_t i = 0; i < str.size(); i++) {
    int u0 = str[i];
    switch (u0) {
      case '\t':
        os << "\\t";
        continue;
      case '\n':
        os << "\\n";
        continue;
      case '\r':
        os << "\\r";
        continue;
      case '"':
        os << "\\\"";
        continue;
      case '\'':
        os << "'";
        continue;
      case '\\':
        os << "\\\\";
        continue;
      default: {
        // Emit something like \u006e, the JSON escaping of a 16-bit number.
        auto uEscape = [&](uint32_t v) {
          if (v > 0xffff) {
            std::cerr << "warning: Bad 16-bit escapee " << int(u0) << '\n';
          }
          os << std::hex;
          os << "\\u";
          os << ((v >> 12) & 0xf);
          os << ((v >> 8) & 0xf);
          os << ((v >> 4) & 0xf);
          os << (v & 0xf);
          os << std::dec;
        };

        // Based off of
        // https://github.com/emscripten-core/emscripten/blob/59e6b8f1262d75585d8416b728e8cbb3db176fe2/src/library_strings.js#L72-L91
        if (!(u0 & 0x80)) {
          if (u0 >= 32 && u0 < 127) {
            // This requires no escaping at all.
            os << char(u0);
          } else {
            uEscape(u0);
          }
          continue;
        }

        // This uses 2 bytes.
        i++;
        int u1 = str[i] & 63;
        if ((u0 & 0xE0) == 0xC0) {
          uEscape((((u0 & 31) << 6) | u1));
          continue;
        }

        // This uses 3 bytes.
        i++;
        int u2 = str[i] & 63;
        if ((u0 & 0xF0) == 0xE0) {
          u0 = ((u0 & 15) << 12) | (u1 << 6) | u2;
        } else {
          // This uses 4 bytes.
          if ((u0 & 0xF8) != 0xF0) {
            std::cerr << "warning: Bad UTF-8 leading byte " << int(u0) << '\n';
          }
          i++;
          u0 = ((u0 & 7) << 18) | (u1 << 12) | (u2 << 6) | (str[i] & 63);
        }

        if (u0 < 0x10000) {
          uEscape(u0);
        } else {
          // There are two separate code points here.
          auto ch = u0 - 0x10000;
          uEscape(0xD800 | (ch >> 10));
          uEscape(0xDC00 | (ch & 0x3FF));
        }
      }
    }
  }
  return os << '"';
}

} // namespace wasm::String
