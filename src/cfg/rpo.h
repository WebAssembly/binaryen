/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Utilities for reverse-postorder queue management.
//

#ifndef rpo_h
#define rpo_h

#include <queue>

#include "wasm.h"

namespace wasm {

//
// Given a CFG in reverse postorder (e.g. from cfg-traversal), implement a priority queue
// working in reverse postorder. BasicBlock indexes indicate the block's position
// in RPO, and by processing the ones with lower indexes first, we can ensure
// that we fully process loops and diamonds before proceeding onward to flow
// data elsewhere in the CFG. This avoids the wasted work problem where we have,
// say, an If, and process one arm, then look at the rest of a massive function,
// then process the other If arm, and the entire massive function must be
// recomputed.
//
// The BasicBlock of the CFG must contain two fields:
//
//   bool inQueue; // whether already in the queue
//   Index index;  // basic block index
//
template<typename CFG>
struct RPOQueue : public std::priority_queue<Index, std::vector<Index>, std::greater<Index>> {
  CFG& cfg;
  
  RPOQueue(CFG& cfg) : cfg(cfg) {
    // Initialize the block indexes and queue booleans.
    auto& basicBlocks = cfg.basicBlocks;
    for (Index i = 0; i < basicBlocks.size(); ++i) {
      auto& contents = basicBlocks[i]->contents;
      contents.inQueue = false;
      contents.index = i;
    }
  }

  void push(CFG::BasicBlock* block) {
    // Push if ont already in the queue.
    if (!block->contents.inQueue) {
      block->contents.inQueue = true;
      work.push(block->contents.index);
    }
  }

  CFG::BasicBlock* pop() {
    // Pop the smallest element (next in RPO), which is at the top.
    auto* block = cfg.basicBlocks[work.top()].get();
    work.pop();
    block->contents.inQueue = false;
    return block;
  }
};

} // namespace wasm

#endif // rpo_h

// TODO: use in moar passes
