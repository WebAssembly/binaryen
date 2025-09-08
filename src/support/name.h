/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_support_name_h
#define wasm_support_name_h

#include "support/istring.h"

namespace wasm {

// We use a Name for all of the identifiers. These are IStrings, so they are
// all interned - comparisons etc are just pointer comparisons, so there is no
// perf loss. Having names everywhere makes using the AST much nicer (for
// example, block names are strings and not offsets, which makes composition
// - adding blocks, removing blocks - easy). One exception is local variables,
// where we do use indices, as they are a large proportion of the AST,
// perf matters a lot there, and compositionality is not a problem.
// TODO: as an optimization, IString values < some threshold could be considered
//       numerical indices directly.

struct Name : public IString {
  Name() : IString() {}
  Name(std::string_view str) : IString(str, false) {}
  Name(const char* str) : IString(str, false) {}
  Name(IString str) : IString(str) {}
  Name(const std::string& str) : IString(str) {}

  // String literals do not need to be copied. Note: Not safe to construct from
  // temporary char arrays! Take their address first.
  template<size_t N> Name(const char (&str)[N]) : IString(str) {}

  friend std::ostream& operator<<(std::ostream& o, Name name) {
    if (name) {
      return o << name.str;
    } else {
      return o << "(null Name)";
    }
  }

  static Name fromInt(size_t i) {
    return IString(std::to_string(i).c_str(), false);
  }

  bool hasSubstring(IString substring) {
    // TODO: Use C++23 `contains`.
    return str.find(substring.str) != std::string_view::npos;
  }

  std::ostream& print(std::ostream& o) const;

private:
  static bool isIDChar(char c);
};

} // namespace wasm

namespace std {

template<> struct hash<wasm::Name> : hash<wasm::IString> {};

} // namespace std

#endif // wasm_support_name_h
