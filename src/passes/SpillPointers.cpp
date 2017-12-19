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
// To reduce the overhead of the extra operations added here, you
// should probably run optimizations after doing it.
// TODO: add a dead store elimination pass, which would help here
//

#include "wasm.h"
#include "pass.h"
#include "cfg/liveness-traversal.h"
#include "wasm-builder.h"
#include "abi/abi.h"
#include "abi/stack.h"

namespace wasm {

struct SpillPointers : public WalkerPass<LivenessWalker<SpillPointers, Visitor<SpillPointers>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SpillPointers; }

  // note calls in basic blocks
  void visitCall(Call* curr) {
     // if in unreachable code, ignore
    if (!currBasicBlock) return;
    currBasicBlock->contents.actions.emplace_back(getCurrentPointer());
  }

  // main entry point

  void doWalkFunction(Function* func) {
    super::doWalkFunction(func);
    spillPointers();
  }

  // map pointers to their offset in the spill area
  typedef std::unordered_map<Index, Index> PointerMap;
  
  void spillPointers() {
    // we only care about possible pointers
    auto* func = getFunction();
    PointerMap pointerMap;
    for (Index i = 0; i < func->getNumLocals(); i++) {
      if (func->getLocalType(i) == ABI::PointerType) {
        auto offset = pointerMap.size() * getWasmTypeSize(ABI::PointerType);
        pointerMap[i] = offset;
      }
    }
    // find calls and spill around them
    bool spilled = false;
    Index spillLocal;
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
      if (lastCall == Index(-1)) continue; // nothing to see here
      // scan through the block, spilling around the calls
      // TODO: we can filter on pointerMap everywhere
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
            if (pointerMap.count(index) > 0) {
              toSpill.push_back(index);
            }
          }
          if (!toSpill.empty()) {
            // we now have a call + the information about which locals
            // should be spilled
            if (!spilled) {
              // prepare stack support: get a pointer to stack space big enough for all our data
              spillLocal = ABI::getStackSpaceLocal(func, getWasmTypeSize(ABI::PointerType) * pointerMap.size(), *getModule());
              spilled = true;
            }
            spillPointersAroundCall(action.origin, toSpill, spillLocal, pointerMap, func, getModule());
          }
        } else {
          WASM_UNREACHABLE();
        }
      }
    }
  }

  void spillPointersAroundCall(Expression** origin, std::vector<Index>& toSpill, Index spillLocal, PointerMap& pointerMap, Function* func, Module* module) {
    auto* call = (*origin)->cast<Call>();
    if (call->type == unreachable) return; // the call is never reached anyhow, ignore
    Builder builder(*module);
    auto* block = builder.makeBlock();
    // move the operands into locals, as we must spill after they are executed
    for (auto*& operand : call->operands) {
      auto temp = builder.addVar(func, ABI::PointerType);
      block->list.push_back(builder.makeSetLocal(temp, operand));
      operand = builder.makeGetLocal(temp, ABI::PointerType);
    }
    // add the spills
    for (auto index : toSpill) {
      block->list.push_back(builder.makeStore(
        getWasmTypeSize(ABI::PointerType),
        pointerMap[index],
        getWasmTypeSize(ABI::PointerType),
        builder.makeGetLocal(spillLocal, ABI::PointerType),
        builder.makeGetLocal(index, ABI::PointerType),
        ABI::PointerType
      ));
    }
    // add the (modified) call
    block->list.push_back(call);
    block->finalize();
    *origin = block;
  }
};

Pass *createSpillPointersPass() {
  return new SpillPointers();
}

} // namespace wasm
