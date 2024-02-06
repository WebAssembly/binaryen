/*
 * Copyright 2019 WebAssembly Community Group participants
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

//
// String helpers.
//

#ifndef wasm_support_string_h
#define wasm_support_string_h

#include "support/utilities.h"
#include <algorithm>
#include <cctype>
#include <ostream>
#include <string>
#include <vector>

namespace wasm::String {

// Creates a vector of the split parts of a string, by a delimiter.
class Split : public std::vector<std::string> {
private:
  // If we split on newlines then we do not need to handle bracketing at all.
  // Otherwise, splitting on say "," does require us to understanding the
  // scoping of brackets, e.g., "foo(x, y),bar" should be split as "foo(x, y)",
  // "bar".
  bool needToHandleBracketingOperations = true;

  void split(const std::string& input, const std::string& delim) {
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
  friend String::Split handleBracketingOperators(String::Split split);

public:
  // This can be used when we want to split on newlines if there are any, and if
  // there are not, then using the given delimiter.
  struct NewLineOr {
    const std::string delim;
    explicit NewLineOr(const std::string& delim) : delim(delim) {}
  };

  Split() = default;

  Split(const std::string& input, const NewLineOr& newLineOrDelim) {
    auto first = input.find("\n", 0);
    if (first != std::string::npos && first != input.length() - 1) {
      split(input, "\n");
    } else {
      split(input, newLineOrDelim.delim);
    }
  }

  Split(const std::string& input, const std::string& delim) {
    split(input, delim);
  }
};

// Handles bracketing in a list initially split by ",", but the list may
// contain nested ","s. For example,
//   void foo(int, double)
// must be kept together because of the "(". Likewise, "{", "<", "[" are
// handled.
inline String::Split handleBracketingOperators(String::Split split) {
  if (!split.needToHandleBracketingOperations) {
    return split;
  }

  String::Split ret;
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

// Does a simple '*' wildcard match between a pattern and a value.
inline bool wildcardMatch(const std::string& pattern,
                          const std::string& value) {
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

// Removes any extra whitespace or \0.
inline std::string trim(const std::string& input) {
  size_t size = input.size();
  while (size > 0 && (isspace(input[size - 1]) || input[size - 1] == '\0')) {
    size--;
  }
  return input.substr(0, size);
}

inline bool isNumber(const std::string& str) {
  return !str.empty() && std::all_of(str.begin(), str.end(), ::isdigit);
}

inline std::ostream& printEscaped(std::ostream& os, std::string_view str) {
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

} // namespace wasm::String

#endif // wasm_support_string_h
