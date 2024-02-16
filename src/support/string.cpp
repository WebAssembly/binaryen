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

enum EscapeMode { Normal, JSON };

std::ostream&
printEscapedInternal(std::ostream& os, std::string_view str, EscapeMode mode) {
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
          if (mode == EscapeMode::Normal) {
            os << std::hex << '\\' << (c / 16) << (c % 16) << std::dec;
          } else if (mode == EscapeMode::JSON) {
            os << std::hex << "\\u00" << (c / 16) << (c % 16) << std::dec;
          } else {
            WASM_UNREACHABLE("bad mode");
          }
        }
      }
    }
  }
  return os << '"';
}

std::ostream& printEscaped(std::ostream& os, std::string_view str) {
  return printEscapedInternal(os, str, EscapeMode::Normal);
}

std::ostream& printEscapedJSON(std::ostream& os, std::string_view str) {
  return printEscapedInternal(os, str, EscapeMode::JSON);
}

} // namespace wasm::String
