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

#include <list>
#include <stddef.h>
#include <unordered_map>

#include "support/utilities.h"

// like std::set, except that begin() -> end() iterates in the
// order that elements were added to the set (not in the order
// of operator<(T, T))
template<typename T> struct InsertOrderedSet {
  std::unordered_map<T, typename std::list<T>::iterator> Map;
  std::list<T> List;

  typedef typename std::list<T>::iterator iterator;
  iterator begin() { return List.begin(); }
  iterator end() { return List.end(); }

  void erase(const T& val) {
    auto it = Map.find(val);
    if (it != Map.end()) {
      List.erase(it->second);
      Map.erase(it);
    }
  }

  void erase(iterator position) {
    Map.erase(*position);
    List.erase(position);
  }

  // cheating a bit, not returning the iterator
  void insert(const T& val) {
    auto it = Map.find(val);
    if (it == Map.end()) {
      List.push_back(val);
      Map.insert(std::make_pair(val, --List.end()));
    }
  }

  size_t size() const { return Map.size(); }
  bool empty() const { return Map.empty(); }

  void clear() {
    Map.clear();
    List.clear();
  }

  size_t count(const T& val) const { return Map.count(val); }

  InsertOrderedSet() = default;
  InsertOrderedSet(const InsertOrderedSet& other) { *this = other; }
  InsertOrderedSet& operator=(const InsertOrderedSet& other) {
    clear();
    for (auto i : other.List) {
      insert(i); // inserting manually creates proper iterators
    }
    return *this;
  }
};

// like std::map, except that begin() -> end() iterates in the
// order that elements were added to the map (not in the order
// of operator<(Key, Key))
template<typename Key, typename T> struct InsertOrderedMap {
  std::unordered_map<Key, typename std::list<std::pair<Key, T>>::iterator> Map;
  std::list<std::pair<Key, T>> List;

  T& operator[](const Key& k) {
    auto it = Map.find(k);
    if (it == Map.end()) {
      List.push_back(std::make_pair(k, T()));
      auto e = --List.end();
      Map.insert(std::make_pair(k, e));
      return e->second;
    }
    return it->second->second;
  }

  typedef typename std::list<std::pair<Key, T>>::iterator iterator;
  iterator begin() { return List.begin(); }
  iterator end() { return List.end(); }

  void erase(const Key& k) {
    auto it = Map.find(k);
    if (it != Map.end()) {
      List.erase(it->second);
      Map.erase(it);
    }
  }

  void erase(iterator position) { erase(position->first); }

  void clear() {
    Map.clear();
    List.clear();
  }

  void swap(InsertOrderedMap<Key, T>& Other) {
    Map.swap(Other.Map);
    List.swap(Other.List);
  }

  size_t size() const { return Map.size(); }
  bool empty() const { return Map.empty(); }
  size_t count(const Key& k) const { return Map.count(k); }

  InsertOrderedMap() = default;
  InsertOrderedMap(InsertOrderedMap& other) {
    // TODO, watch out for iterators.
    WASM_UNREACHABLE("unimp");
  }
  InsertOrderedMap& operator=(const InsertOrderedMap& other) {
    // TODO, watch out for iterators.
    WASM_UNREACHABLE("unimp");
  }
  bool operator==(const InsertOrderedMap& other) {
    return Map == other.Map && List == other.List;
  }
  bool operator!=(const InsertOrderedMap& other) { return !(*this == other); }
};
