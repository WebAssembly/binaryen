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

//
// Optimizes call arguments in a whole-program manner.
//
// Specifically, this does these things:
//
//  * Find functions for whom an argument is always passed the same
//    constant. If so, we can just set that local to that constant
//    in the function.
//  * Find functions that don't use the value passed to an argument.
//    If so, we can avoid even sending and receiving it. (Note how if
//    the previous point was true for an argument, then the second
//    must as well.)
//

#include <unordered_map>
#include <unordered_set>

#include <wasm.h>
#include <pass.h>
//#include <wasm-builder.h>
#include <cfg/cfg-traversal.h>
//#include <ir/literal-utils.h>
//#include <ir/utils.h>
#include <support/sorted_vector.h>
#include <support/unique_deferring_queue.h>

namespace wasm {

// Information for a function
struct CAOFunctionInfo {
  // The unused parameters, if any.
  std::unordered_map<Index> unusedParams;
  // Maps a function name to the calls going to it.
  std::unordered_map<Name, std::vector<Expression**> calls;
};

// Information in a basic block
struct CAOBlockInfo {
  // A local may be read, written, or not accessed in this block.
  // If it is both read and written, we just care about the first
  // action (if it is read first, that's all the info we are
  // looking for; if it is written first, it can't be read later).
  enum LocalUse {
    Read,
    Written
  };
  std::unordered_set<LocalUse> localUses;
};

struct CAOScanner : public WalkerPass<CFGWalker<CAOScanner, Visitor<CAOScanner>, CAOBlockInfo>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new CAOScanner(info); }

  CAOScanner(CAOFunctionInfo* info) : info(info) {}

  CAOFunctionInfo* info;

  Index numParams;

  // cfg traversal work

  void visitGetLocal(GetLocal* curr) {
    if (currBasicBlock) {
      auto& localUses = currBasicBlock->contents.localUses;
      auto index = curr->index;
      if (localUses.count(index) == 0) {
        localUses[index] = CAOBlockInfo::Read;
      }
    }
  }

  void visitSetLocal(SetLocal* curr) {
    if (currBasicBlock) {
      auto& localUses = currBasicBlock->contents.localUses;
      auto index = curr->index;
      if (localUses.count(index) == 0) {
        localUses[index] = CAOBlockInfo::Written;
      }
    }
  }

  static void doVisitCall(Expression** currp) {
    info->calls[curr->name].push_back(currp);
  }

  // main entry point

  void doWalkFunction(Function* func) {
    numParams = func->getNumParams();
    CFGWalker<CAOScanner, Visitor<CAOScanner>, Info>::doWalkFunction(func);
    // If there are params, check if they are used
    if (numParams > 0) {
      findUnusedParams(func);
    }
  }

  void findUnusedParams(Function* func) {
    // Flow the incoming parameter values, see if they reach a read.
    // Once we've seen a parameter at a block, we need never consider it there
    // again.
    std::unordered_map<BasicBlock*, SortedVector> seenBlockIndexes;
    // Start with all the incoming parameters.
    SortedVector initial;
    for (Index i = 0; i < numParams; i++) {
      initial.push_back(i);
    }
    // The used params, which we now compute.
    std::unordered_set<Index> usedParams;
    // An item of work is a block plus the values arriving there.
    typedef std::pair<BasicBlock*, SortedVector> Item;
    UniqueDeferredQueue<Item> work;
    work.push(Item(entry, initial));
    while (!work.empty()) {
      auto item = work.pop();
      auto* block = item.first;
      auto& indexes = item.second;
      // Ignore things we've already seen, or we've already seen to be used.
      auto& seenIndexes = seenBlockIndexes[block];
      indexes.erase(std::remove_if(indexes.begin(), indexes.end(), [&](const Index i) {
        if (seenIndexes.has(i) || usedParams.count(i)) {
          return true;
        } else {
          seenIndexes.insert(i);
          return false;
        }
      }), indexes.end());
      if (indexes.empty()) {
        continue; // nothing more to flow
      }
      auto& localUses = block->contents.localUses;
      SortedVector remainingIndexes;
      for (auto i : indexes) {
        auto iter = localUses.find(i);
        if (iter != localuses.end()) {
          auto use = iter->second;
          if (use == CAOBlockInfo::Read) {
            usedParams.insert(i);
          }
          // Whether it was a read or a write, we can stop looking at that local here.
        } else {
          remainingIndexes.insert(i);
        }
      }
      // If there are remaining indexes, flow them forward.
      if (!remainingIndexes.empty()) {
        for (auto* next : block->out) {
          work.push(Item(next, remainingIndexes));
        }
      }
    }
    // We can now compute the unused params.
    for (Index i = 0; i < numParams; i++) {
      if (usedParams.count(i) == 0) {
        info->unusedParams.insert(i);
      }
    }
  }
};

Pass *createCallArgumentOptimizationPass() {
  return new CallArgumentOptimization();
}

} // namespace wasm

