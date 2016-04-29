/*
 * Copyright 2015 WebAssembly Community Group participants
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

// Interned String type, 100% interned on creation. Comparisons are always just a pointer comparison

#ifndef wasm_istring_h
#define wasm_istring_h

#include <unordered_set>
#include <unordered_map>
#include <set>

#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "support/threads.h"

namespace cashew {

struct IString {
  const char *str;

  static size_t hash_c(const char *str) { // see http://www.cse.yorku.ca/~oz/hash.html
    unsigned int hash = 5381;
    int c;
    while ((c = *str++)) {
      hash = ((hash << 5) + hash) ^ c;
    }
    return (size_t)hash;
  }

  class CStringHash : public std::hash<const char *> {
  public:
    size_t operator()(const char *str) const {
      return IString::hash_c(str);
    }
  };
  class CStringEqual : public std::equal_to<const char *> {
  public:
    bool operator()(const char *x, const char *y) const {
      return strcmp(x, y) == 0;
    }
  };

  IString() : str(nullptr) {}
  IString(const char *s, bool reuse=true) { // if reuse=true, then input is assumed to remain alive; not copied
    assert(s);
    set(s, reuse);
  }

  void set(const char *s, bool reuse=true) {
    typedef std::unordered_set<const char *, CStringHash, CStringEqual> StringSet;
    static StringSet* strings = new StringSet();

    auto existing = strings->find(s);

    if (existing == strings->end()) {
      // the StringSet cache is a global shared structure, which should
      // not be modified by multiple threads at once.
      assert(!wasm::ThreadPool::isRunning());
      if (!reuse) {
        size_t len = strlen(s) + 1;
        char *copy = (char*)malloc(len); // XXX leaked
        strncpy(copy, s, len);
        s = copy;
      }
      strings->insert(s);
    } else {
      s = *existing;
    }

    str = s;
  }

  void set(const IString &s) {
    str = s.str;
  }

  void clear() {
    str = nullptr;
  }

  bool operator==(const IString& other) const {
    //assert((str == other.str) == !strcmp(str, other.str));
    return str == other.str; // fast!
  }
  bool operator!=(const IString& other) const {
    //assert((str == other.str) == !strcmp(str, other.str));
    return str != other.str; // fast!
  }
  bool operator<(const IString& other) const {
    return strcmp(str ? str : "", other.str ? other.str : "") < 0;
  }

  char operator[](int x) const {
    return str[x];
  }

  bool operator!() const { // no string, or empty string
    return !str || str[0] == 0;
  }

  const char *c_str() const { return str; }
  bool equals(const char *other) const { return !strcmp(str, other); }

  bool is() const     { return str != nullptr; }
  bool isNull() const { return str == nullptr; }
};

} // namespace cashew

// Utilities for creating hashmaps/sets over IStrings

namespace std {

template <> struct hash<cashew::IString> : public unary_function<cashew::IString, size_t> {
  size_t operator()(const cashew::IString& str) const {
    size_t hash = size_t(str.str);
    return hash = ((hash << 5) + hash) ^ 5381; /* (hash * 33) ^ c */
  }
};

template <> struct equal_to<cashew::IString> : public binary_function<cashew::IString, cashew::IString, bool> {
  bool operator()(const cashew::IString& x, const cashew::IString& y) const {
    return x == y;
  }
};

} // namespace std

namespace cashew {

// IStringSet

class IStringSet : public std::unordered_set<IString> {
  std::vector<char> data;
public:
  IStringSet() {}
  IStringSet(const char *init) { // comma-delimited list
    int size = strlen(init) + 1;
    data.resize(size);
    char *curr = &data[0];
    strncpy(curr, init, size);
    while (1) {
      char *end = strchr(curr, ' ');
      if (end) *end = 0;
      insert(curr);
      if (!end) break;
      curr = end + 1;
    }
  }

  bool has(const IString& str) {
    return count(str) > 0;
  }
};

class IOrderedStringSet : public std::set<IString> {
public:
  bool has(const IString& str) {
    return count(str) > 0;
  }
};

} // namespace cashew

#endif // wasm_istring_h
