/*
 * Copyright 2021 WebAssembly Community Group participants
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

// Near drop-in replacements for std::unordered_set and std::unordered_map that
// provides deterministic iteration based on insertion order. Useful for
// imposing an arbitrary deterministic order on values that are not inherently
// ordered.

#ifndef wasm_support_insertion_order_h
#define wasm_support_insertion_order_h

#include <algorithm>
#include <functional>
#include <unordered_map>
#include <vector>

#include "support/utilities.h"

namespace wasm {

template<typename Key,
         typename Hash = std::hash<Key>,
         typename KeyEqual = std::equal_to<Key>>
class ordered_set {
  std::unordered_map<Key, size_t, Hash, KeyEqual> indices;
  std::vector<Key> vec;

public:
  // Do not allow modification of items.
  using iterator = typename std::vector<Key>::const_iterator;

  iterator begin() { return vec.cbegin(); }
  iterator end() { return vec.cend(); }

  bool empty() const { return vec.empty(); }

  size_t size() const { return vec.size(); }

  void clear() {
    indices.clear();
    vec.clear();
  }

  std::pair<iterator, bool> insert(const Key& key) {
    auto result = indices.insert({key, size()});
    if (result.second) {
      vec.push_back(key);
      return {end() - 1, true};
    }
    return {begin() + result.first->second, false};
  }

  iterator erase(iterator pos) {
    for (auto it = pos; it != end(); ++it) {
      --indices[*it];
    }
    indices.erase(*pos);
    return vec.erase(pos);
  }

  size_t count(const Key& key) const { return indices.count(key); }

  iterator find(const Key& key) {
    auto it = indices.find(key);
    if (it != indices.end()) {
      return begin() + it->second;
    }
    return end();
  }
};

template<typename Key,
         typename T,
         typename Hash = std::hash<Key>,
         typename KeyEqual = std::equal_to<Key>>
class ordered_map {
  std::unordered_map<Key, size_t, Hash, KeyEqual> indices;
  std::vector<std::pair<const Key, T>> vec;

public:
  using value_type = std::pair<const Key, T>;
  using iterator = typename std::vector<value_type>::iterator;

  iterator begin() { return vec.begin(); }
  iterator end() { return vec.end(); }

  bool empty() const { return vec.empty(); }

  size_t size() const { return vec.size(); }

  void clear() {
    indices.clear();
    vec.clear();
  }

  std::pair<iterator, bool> insert(const value_type& value) {
    auto result = indices.insert({value.first, size()});
    if (result.second) {
      vec.push_back(value);
      return {end() - 1, true};
    }
    return {begin() + result.first->second, false};
  }

  iterator erase(iterator pos) {
    for (auto it = pos + 1; it != end(); ++it) {
      --indices[*it];
    }
    indices.erase(pos->first);
    return vec.erase(pos);
  }

  void swap(ordered_map<Key, T, Hash, KeyEqual>& other) {
    indices.swap(other.indices);
    vec.swap(other.vec);
  }

  size_t count(const Key& key) const { return indices.count(key); }

  iterator find(const Key& key) {
    auto it = indices.find(key);
    if (it != indices.end()) {
      return begin() + it->second;
    }
    return end();
  }

  T& at(const Key& key) {
    iterator it = find(key);
    if (it == end()) {
      WASM_UNREACHABLE("Key not in ordered_map");
    }
    return it->second;
  }

  T& operator[](const Key& key) { return insert({key, T()}).first->second; }
};

} // namespace wasm

#endif // wasm_support_insertion_order_h
