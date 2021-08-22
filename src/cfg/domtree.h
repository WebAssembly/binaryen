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

//
// Computes a dominator tree for a CFG graph, that is, for each block x we find
// the blocks y_i that must be reached before x on any path from the entry. Each
// block x has a single immediate dominator, the one closest to it, which forms
// a tree structure.
//

#ifndef domtree_h
#define domtree_h

#include "cfg-traversal.h"

namespace wasm {

//
// DomTree receives an input CFG which has a list of basic blocks in reverse
// postorder. It generates the dominator tree by representing it as a vector of
// indexes, for each block giving the index of its parent (the immediate
// dominator) in the tree, that is,
//
//  parents[0] = a nonsense value, as the entry node has no immediate dominator
//  parents[1] = the index of the immediate dominator of CFG.blocks[1]
//  parents[2] = the index of the immediate dominator of CFG.blocks[2]
//  etc.
//
template<typename CFG>
struct DomTree {
  std::vector<Index> parents;

  DomTree(CFG& cfg);
};

} // namespace wasm

#endif // domtree_h
