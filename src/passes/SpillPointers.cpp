/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Spills values that might be pointers to the C stack. This allows
// Boehm-style GC to see them properly.
//


#include "wasm.h"
#include "pass.h"
#include "cfg/liveness-traversal.h"
#include "wasm-builder.h"

namespace wasm {

struct SpillPointers : public WalkerPass<LivenessWalker<SpillPointers, Visitor<SpillPointers>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SpillPointers; }

  // note calls in basic blocks
  static void visitCall(Call* curr) {
     // if in unreachable code, ignore
    if (!currBasicBlock) return;
    currBasicBlock->contents.actions.emplace_back(Action::Other, getCurrLocation());
  }

  // main entry point

  void doWalkFunction(Function* func) {
    super::doWalkFunction(func);
    spillPointers();
  }

  void spillPointers() {
    // we only care about possible pointers
    auto* func = getFunction();
    std::unordered_set<Index> possiblePointers;
    for (Index i = 0; i < func->getNumLocals(); i++) {
      if (func->getLocalType(i) == i32) { // XXX wasm64
        possiblePointers.insert(i);
      }
    }
    // find calls and spill around them
    for (auto& curr : basicBlocks) {
      if (liveBlocks.count(curr.get()) == 0) continue; // ignore dead blocks
      auto& liveness = curr->contents;
      auto& actions = liveness.actions;
      Index lastCall = -1;
      for (Index i = 0; i < actions.size(); i++) {
        auto& action = liveness.actions[i];
        if (action.isOther()) {
          lastCall = i;
        }
      }
      if (lastCall == -1) continue; // nothing to see here
      // scan through the block, spilling around the calls
      // TODO: we can filter on possiblePointers everywhere
      LocalSet live = liveness.end;
      for (int i = int(actions.size()) - 1; i >= 0; i--) {
        auto& action = actions[i];
        if (action.isGet()) {
          live.insert(action.index);
        } else if (action.isSet()) {
          live.erase(action.index);
        } else if (action.isOther()) {
          std::vector<Index> toSpill;
          for (auto index : live) {
            if (possiblePointers.count(index) > 0) {
              toSpill.push_back(index);
            }
          }
          // we now have a call + the information about which locals
          // should be spilled
          spillPointersAroundCall(action.origin, toSpill);
        } else {
          WASM_UNREACHABLE();
        }
      }
    }
  }

  void spillPointersAroundCall(Expression** origin, std::vector<Index>& toSpill) {
    auto* call = (*origin)->cast<Call>();

  }
};

Pass *createSpillPointersPass() {
  return new SpillPointers();
}

} // namespace wasm
