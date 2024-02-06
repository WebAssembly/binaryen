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

  void split(const std::string& input, const std::string& delim);
  friend Split handleBracketingOperators(Split split);

public:
  // This can be used when we want to split on newlines if there are any, and if
  // there are not, then using the given delimiter.
  struct NewLineOr {
    const std::string delim;
    explicit NewLineOr(const std::string& delim) : delim(delim) {}
  };

  Split() = default;

  Split(const std::string& input, const NewLineOr& newLineOrDelim);
  Split(const std::string& input, const std::string& delim) {
    split(input, delim);
  }
};

// Handles bracketing in a list initially split by ",", but the list may
// contain nested ","s. For example,
//   void foo(int, double)
// must be kept together because of the "(". Likewise, "{", "<", "[" are
// handled.
Split handleBracketingOperators(Split split);

// Does a simple '*' wildcard match between a pattern and a value.
bool wildcardMatch(const std::string& pattern, const std::string& value);

// Removes any extra whitespace or \0.
std::string trim(const std::string& input);

inline bool isNumber(const std::string& str) {
  return !str.empty() && std::all_of(str.begin(), str.end(), ::isdigit);
}

std::ostream& printEscaped(std::ostream& os, std::string_view str);

} // namespace wasm::String

#endif // wasm_support_string_h
