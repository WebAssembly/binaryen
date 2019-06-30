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

#include <string>
#include <vector>

namespace wasm {

namespace String {

// Creates a vector of the split parts of a string, by a delimiter.
class Split : public std::vector<std::string> {
public:
  Split(const std::string& input, const std::string& delim) {
    size_t lastEnd = 0;
    while (lastEnd < input.size()) {
      auto nextDelim = input.find(delim, lastEnd);
      if (nextDelim == std::string::npos) {
        nextDelim = input.size();
      }
      (*this).push_back(input.substr(lastEnd, nextDelim - lastEnd));
      lastEnd = nextDelim + delim.size();
    }
  }
};

// Does a simple wildcard match between a pattern and a value. Currently
// supports a '*' at the end of the pattern.
inline bool wildcardMatch(const std::string& pattern,
                          const std::string& value) {
  for (size_t i = 0; i < pattern.size(); i++) {
    if (i >= value.size()) {
      return false;
    }
    if (pattern[i] == '*') {
      return true;
    }
    if (pattern[i] != value[i]) {
      return false;
    }
  }
  return value.size() == pattern.size();
}

} // namespace String

} // namespace wasm

#endif // wasm_support_string_h
