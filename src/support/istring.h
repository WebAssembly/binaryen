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
  static const char* interned(std::string_view s);

public:
  struct View {
    const char* internal = nullptr;
    const char* data() const { return internal; }
    size_t size() const {
      return internal ? *(const uint32_t*)(internal - 4) : 0;
    }
    char operator[](size_t x) const { return internal[x]; }
    operator std::string_view() const { return {internal, size()}; }

    bool operator==(std::string_view other) const {
      return std::string_view(*this) == other;
    }
    bool operator!=(std::string_view other) const { return !(*this == other); }
    bool operator<(std::string_view other) const {
      return std::string_view(*this) < other;
    }
    bool operator<=(std::string_view other) const {
      return std::string_view(*this) <= other;
    }
    bool operator>(std::string_view other) const {
      return std::string_view(*this) > other;
    }
    bool operator>=(std::string_view other) const {
      return std::string_view(*this) >= other;
    }

    friend bool operator==(const View& a, const std::string& b) {
      return std::string_view(a) == b;
    }
    friend bool operator!=(const View& a, const std::string& b) {
      return !(a == b);
    }
    friend bool operator==(const std::string& a, const View& b) {
      return a == std::string_view(b);
    }
    friend bool operator!=(const std::string& a, const View& b) {
      return !(a == b);
    }

    friend bool operator==(const View& a, const char* b) {
      return std::string_view(a) == b;
    }
    friend bool operator!=(const View& a, const char* b) { return !(a == b); }
    friend bool operator==(const char* a, const View& b) {
      return a == std::string_view(b);
    }
    friend bool operator!=(const char* a, const View& b) { return !(a == b); }

    std::string_view substr(size_t pos,
                            size_t len = std::string_view::npos) const {
      return std::string_view(*this).substr(pos, len);
    }
    size_t find(std::string_view s, size_t pos = 0) const {
      return std::string_view(*this).find(s, pos);
    }
    size_t find_last_of(char c, size_t pos = std::string_view::npos) const {
      return std::string_view(*this).find_last_of(c, pos);
    }
    const char* begin() const { return data(); }
    const char* end() const { return data() + size(); }

    friend std::ostream& operator<<(std::ostream& os, const View& view) {
      return os << std::string_view(view);
    }
  };
  const View str;

  IString() = default;

  IString(View v) : str(v) {}

  IString(std::string_view s, bool reuse = true) : str{interned(s)} {}

  // But other C strings generally do need to be copied.
  IString(const char* str) : str{interned(str)} {}
  IString(const std::string& str) : str{interned(str)} {}

  IString(const IString& other) = default;

  IString& operator=(const IString& other) {
    return *(new (this) IString(other));
  }

  bool operator==(const IString& other) const {
    // Fast! No need to compare contents due to interning
    return str.internal == other.str.internal;
  }
  bool operator!=(const IString& other) const { return !(*this == other); }
  bool operator<(const IString& other) const {
    if (str.internal == other.str.internal) {
      return false;
    }
    return std::string_view(str) < std::string_view(other.str);
  }
  bool operator<=(const IString& other) const {
    return *this == other || *this < other;
  }
  bool operator>(const IString& other) const { return !(*this <= other); }
  bool operator>=(const IString& other) const { return !(*this < other); }

  char operator[](int x) const { return str[x]; }

  explicit operator bool() const { return str.internal != nullptr; }

  // TODO: deprecate?
  bool is() const { return bool(*this); }
  bool isNull() const { return !bool(*this); }

  std::string toString() const { return {str.data(), str.size()}; }

  bool equals(std::string_view other) const { return str == other; }

  bool startsWith(std::string_view prefix) const {
    // TODO: Use C++20 `starts_with`.
    return str.substr(0, prefix.size()) == prefix;
  }
  bool startsWith(IString other) const {
    return startsWith(std::string_view(other.str));
  }

  // Disambiguate for string literals.
  template<int N> bool startsWith(const char (&str)[N]) const {
    return startsWith(std::string_view(str));
  }

  bool endsWith(std::string_view suffix) const {
    // TODO: Use C++20 `ends_with`.
    if (suffix.size() > str.size()) {
      return false;
    }
    return str.substr(str.size() - suffix.size()) == suffix;
  }
  bool endsWith(IString other) const {
    return endsWith(std::string_view(other.str));
  }

  // Disambiguate for string literals.
  template<int N> bool endsWith(const char (&str)[N]) const {
    return endsWith(std::string_view(str));
  }

  IString substr(size_t pos, size_t len = std::string_view::npos) const {
    return IString(str.substr(pos, len));
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
