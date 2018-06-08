/*
 * Copyright 2018 WebAssembly Community Group participants
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

#ifndef wasm_ir_equivalent_sets_h
#define wasm_ir_equivalent_sets_h

#include <wasm.h>

namespace wasm {

//
// A map of each index to all those it is equivalent to, and some helpers.
//
struct EquivalentSets {
  // A set of indexes.
  typedef std::unordered_set<Index> Set;

  std::unordered_map<Index, std::shared_ptr<Set>> indexSets;

  // Clears the state completely, removing all equivalences.
  void clear() {
    indexSets.clear();
  }

  // Resets an index, removing any equivalences between it and others.
  void reset(Index index) {
    auto iter = indexSets.find(index);
    if (iter != indexSets.end()) {
      auto& set = iter->second;
      assert(!set->empty()); // can't be empty - we are equal to ourselves!
      if (set->size() > 1) {
        // We are not the last item, fix things up
        set->erase(index);
      }
      indexSets.erase(iter);
    }
  }

  // Adds a new equivalence between two indexes.
  // `justReset` is an index that was just reset, and has no
  // equivalences. `other` may have existing equivalences.
  void add(Index justReset, Index other) {
    auto iter = indexSets.find(other);
    if (iter != indexSets.end()) {
      auto& set = iter->second;
      set->insert(justReset);
      indexSets[justReset] = set;
    } else {
      auto set = std::make_shared<Set>();
      set->insert(justReset);
      set->insert(other);
      indexSets[justReset] = set;
      indexSets[other] = set;
    }
  }

  // Checks whether two indexes contain the same data.
  bool check(Index a, Index b) {
    if (a == b) return true;
    if (auto* set = getEquivalents(a)) {
      if (set->find(b) != set->end()) {
        return true;
      }
    }
    return false;
  }

  // Returns the equivalent set, or nullptr
  Set* getEquivalents(Index index) {
    auto iter = indexSets.find(index);
    if (iter != indexSets.end()) {
      return iter->second.get();
    }
    return nullptr;
  }
};

} // namespace wasm

#endif // wasm_ir_equivalent_sets_h

