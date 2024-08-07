/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_support_disjoint_sets_h
#define wasm_support_disjoint_sets_h

#include <cassert>
#include <cstddef>
#include <vector>

namespace wasm {

// A disjoint set forest (a.k.a. union-find) implementation. See
// https://en.wikipedia.org/wiki/Disjoint-set_data_structure.
struct DisjointSets {
  struct ElemInfo {
    // The index of the parent element, or the index of the element itself if it
    // has no parent.
    size_t parent;
    // An upper bound on the height of the tree rooted at this element.
    size_t rank;
  };
  std::vector<ElemInfo> info;

  // Add an element and return its index.
  size_t addSet() {
    size_t ret = info.size();
    info.push_back({ret, 0});
    return ret;
  }

  // Get the representative element of the set to which `elem` belongs.
  size_t getRoot(size_t elem) {
    assert(elem < info.size());
    size_t root = elem;
    // Follow parent pointers up to the root.
    for (; info[root].parent != root; root = info[root].parent) {
    }
    // Compress the path to make subsequent getRoots of this set faster.
    while (elem != root) {
      size_t parent = info[elem].parent;
      info[elem].parent = root;
      elem = parent;
    }
    return root;
  }

  // Join the sets to which the elements belong and return the representative
  // element of the union.
  size_t getUnion(size_t elem1, size_t elem2) {
    assert(elem1 < info.size() && elem2 < info.size());
    size_t root1 = getRoot(elem1);
    size_t root2 = getRoot(elem2);
    if (root1 == root2) {
      // Already in the same set.
      return root1;
    }
    // Canonicalize so that root1 has the greater rank.
    if (info[root1].rank < info[root2].rank) {
      std::swap(root1, root2);
    }
    // Merge the trees, smaller into larger.
    info[root2].parent = root1;
    // If the ranks were equal, the new root has a larger rank.
    if (info[root1].rank == info[root2].rank) {
      ++info[root1].rank;
    }
    return root1;
  }
};

} // namespace wasm

#endif // wasm_support_disjoint_sets_h
