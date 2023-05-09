/*
 * Copyright 2022 WebAssembly Community Group participants
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

// Interned String type, 100% interned on creation. Comparisons are always just
// a pointer comparison

#ifndef wasm_support_istring_h
#define wasm_support_istring_h

#include <set>
#include <string_view>
#include <unordered_set>

#include <assert.h>

#include "threads.h"
#include "utilities.h"

namespace wasm {

struct IString {
private:
  static std::string_view interned(std::string_view s, bool reuse = true);

public:
  const std::string_view str;

  IString() = default;

  // TODO: This is a wildly unsafe default inherited from the previous
  // implementation. Change it?
  IString(std::string_view str, bool reuse = true)
    : str(interned(str, reuse)) {}

  // But other C strings generally do need to be copied.
  IString(const char* str) : str(interned(str, false)) {}
  IString(const std::string& str) : str(interned(str, false)) {}

  IString(const IString& other) = default;

  IString& operator=(const IString& other) {
    return *(new (this) IString(other));
  }

  bool operator==(const IString& other) const {
    // Fast! No need to compare contents due to interning
    return str.data() == other.str.data();
  }
  bool operator!=(const IString& other) const { return !(*this == other); }
  bool operator<(const IString& other) const { return str < other.str; }
  bool operator<=(const IString& other) const { return str <= other.str; }
  bool operator>(const IString& other) const { return str > other.str; }
  bool operator>=(const IString& other) const { return str >= other.str; }

  char operator[](int x) const { return str[x]; }

  explicit operator bool() const { return str.data() != nullptr; }

  // TODO: deprecate?
  bool is() const { return bool(*this); }
  bool isNull() const { return !bool(*this); }

  std::string toString() const { return {str.data(), str.size()}; }

  bool equals(std::string_view other) const { return str == other; }

  bool startsWith(std::string_view prefix) const {
    // TODO: Use C++20 `starts_with`.
    return str.substr(0, prefix.size()) == prefix;
  }
  bool startsWith(IString str) const { return startsWith(str.str); }

  // Disambiguate for string literals.
  template<int N> bool startsWith(const char (&str)[N]) {
    return startsWith(std::string_view(str));
  }

  size_t size() const { return str.size(); }
};

} // namespace wasm

namespace std {

template<> struct hash<wasm::IString> {
  size_t operator()(const wasm::IString& str) const {
    return std::hash<size_t>{}(uintptr_t(str.str.data()));
  }
};

inline std::ostream& operator<<(std::ostream& os, const wasm::IString& str) {
  return os << str.str;
}

} // namespace std

#endif // wasm_support_istring_h
