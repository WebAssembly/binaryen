/*
 * Copyright 2022 WebAssembly Community Group participants
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
// Condensing Multi-Memories into a single memory for browsers that don’t
// support multiple memories.
//

#include "ir/module-utils.h"
#include "ir/names.h"
#include "wasm-builder.h"
#include <pass.h>
#include <wasm.h>

namespace wasm {

struct MultiMemoryLowering : public Pass {
  Module* wasm = nullptr;
  // The name of the single memory that exists after this pass is run
  Name combinedMemory;
  // The type of the single memory
  Type pointerType = Type::i32;
  // There is no offset for the first memory, so offsetGlobalNames will always
  // have a size that is one less than the count of memories at the time this
  // pass is run
  std::vector<Name> offsetGlobalNames;
  // Maps from the name of the memory to its index as seen in the
  // module->memories vector
  std::unordered_map<Name, Index> memoryIdxMap;
  // A vector of the memory size function names that were created proactively
  // for each memory
  std::vector<Name> memorySizeNames;
  // A vector of the memory grow functions that were created proactively for
  // each memory
  std::vector<Name> memoryGrowNames;

  void run(Module* module) override {
    // If there are no memories or 1 memory, skip this pass
    if (module->memories.size() <= 1) {
      return;
    }

    this->wasm = module;

    addCombinedMemory();
    addOffsetGlobals();
    adjustActiveDataSegmentOffsets();
    createMemorySizeFunctions();
    createMemoryGrowFunctions();
    removeExistingMemories();

    struct Replacer : public WalkerPass<PostWalker<Replacer>> {
      MultiMemoryLowering& parent;
      Builder builder;
      Replacer(MultiMemoryLowering& parent, Module& wasm)
        : parent(parent), builder(wasm) {}
      // Avoid visiting the custom functions added by the parent pass
      // MultiMemoryLowering
      void walkFunction(Function* func) {
        for (Name funcName : parent.memorySizeNames) {
          if (funcName == func->name) {
            return;
          }
        }
        for (Name funcName : parent.memoryGrowNames) {
          if (funcName == func->name) {
            return;
          }
        }
        super::walkFunction(func);
      }

      void visitMemoryGrow(MemoryGrow* curr) {
        auto iter = parent.memoryIdxMap.find(curr->memory);
        assert(iter != parent.memoryIdxMap.end());
        Name funcName = parent.memoryGrowNames[iter->second];
        replaceCurrent(builder.makeCall(funcName, {curr->delta}, curr->type));
      }

      void visitMemorySize(MemorySize* curr) {
        auto iter = parent.memoryIdxMap.find(curr->memory);
        assert(iter != parent.memoryIdxMap.end());
        Name funcName = parent.memorySizeNames[iter->second];
        replaceCurrent(builder.makeCall(funcName, {}, curr->type));
      }

      // We diverge from the spec here and are not trapping if the offset +
      // write size is larger than the length of the memory's data. Warning,
      // out-of-bounds loads and stores can read junk out of or corrupt other
      // memories instead of trapping.
      // TODO: Add an option to add bounds checks.
      void visitLoad(Load* curr) {
        curr->memory = parent.combinedMemory;
        auto iter = parent.memoryIdxMap.find(curr->memory);
        assert(iter != parent.memoryIdxMap.end());
        // No need to change the offset for the first memory
        if (iter->second == 0) {
          return;
        }
        // There is no offset global for the first memory, so we need to
        // subtract one when indexing into the offsetGlobalName vector
        Index idx = iter->second - 1;
        curr->ptr = builder.makeGlobalGet(parent.offsetGlobalNames[idx],
                                          parent.pointerType);
      }

      // We diverge from the spec here and are not trapping if the offset + type
      // / 8 is larger than the length of the memory's data. Warning,
      // out-of-bounds loads and stores can read junk out of or corrupt other
      // memories instead of trapping
      void visitStore(Store* curr) {
        curr->memory = parent.combinedMemory;
        auto iter = parent.memoryIdxMap.find(curr->memory);
        assert(iter != parent.memoryIdxMap.end());
        // No need to change the offset for the first memory
        if (iter->second == 0) {
          return;
        }
        // There is no offset global for the first memory, so we need to
        // subtract one when indexing into the offsetGlobalName vector
        Index idx = iter->second - 1;
        curr->ptr = builder.makeGlobalGet(parent.offsetGlobalNames[idx],
                                          parent.pointerType);
      }
    };
    Replacer(*this, *wasm).run(getPassRunner(), wasm);
  }

  void addCombinedMemory() {
    // We are assuming that each memory is configured the same as the first
    pointerType = wasm->memories[0]->indexType;

    size_t totalInitialPages = 0;
    for (auto& memory : wasm->memories) {
      totalInitialPages += memory->initial;
    }

    // Create the new combined memory
    combinedMemory = Names::getValidMemoryName(*wasm, "combined_memory");
    auto memory = Builder::makeMemory(combinedMemory);
    // We are assuming that each memory is configured the same as the first
    memory->shared = wasm->memories[0]->shared;
    memory->indexType = pointerType;
    memory->initial = totalInitialPages;
    wasm->addMemory(std::move(memory));
  }

  void addOffsetGlobals() {
    auto addGlobal = [&](Name name, size_t offset) {
      auto global =
        Builder::makeGlobal(name,
                            pointerType,
                            Builder(*wasm).makeConst(
                              pointerType == Type::i32
                                ? Literal::makeFromInt32(offset, pointerType)
                                : Literal::makeFromInt64(offset, pointerType)),
                            Builder::Mutable);
      global->hasExplicitName = true;
      wasm->addGlobal(std::move(global));
    };

    size_t offsetRunningTotal = 0;
    // We don't need a page offset global for the first memory as it's always 0
    // We also don't need a page offset global for the last memory as it's the
    // combinedMemory we just created
    for (Index i = 0; i < wasm->memories.size() - 1; i++) {
      auto& memory = wasm->memories[i];
      memoryIdxMap[memory->name] = i;
      if (i != 0) {
        Name name = Names::getValidGlobalName(
          *wasm, std::string(memory->name.c_str()) + "_page_offset");
        offsetGlobalNames.push_back(std::move(name));
        addGlobal(name, offsetRunningTotal);
      }
      offsetRunningTotal += memory->initial;
    }
  }

  void adjustActiveDataSegmentOffsets() {
    Builder builder(*wasm);
    ModuleUtils::iterActiveDataSegments(*wasm, [&](DataSegment* dataSegment) {
      assert(dataSegment->offset->is<Const>() &&
             "TODO: handle non-const segment offsets");
      auto iter = memoryIdxMap.find(dataSegment->memory);
      assert(iter != memoryIdxMap.end());
      dataSegment->memory = combinedMemory;
      // No need to update the offset of data segments for the first memory
      if (iter->second != 0) {
        // We need to subtract 1 here because there is no offsetGlobal for the
        // first memory
        auto offsetGlobalName = offsetGlobalNames[iter->second - 1];
        dataSegment->offset = builder.makeBinary(
          Abstract::getBinary(pointerType, Abstract::Add),
          builder.makeGlobalGet(offsetGlobalName, pointerType),
          dataSegment->offset);
      }
    });
  }

  void createMemorySizeFunctions() {
    // Don't create a memory size function for the last memory in the vector as
    // its the combinedMemory we just added
    for (Index i = 0; i < wasm->memories.size() - 1; i++) {
      auto function = memorySize(i);
      memorySizeNames.push_back(function->name);
      wasm->addFunction(std::move(function));
    }
  }

  void createMemoryGrowFunctions() {
    // Don't create a memory size function for the last memory in the vector as
    // its the combinedMemory we just added
    for (Index i = 0; i < wasm->memories.size() - 1; i++) {
      auto function = memoryGrow(i);
      memoryGrowNames.push_back(function->name);
      wasm->addFunction(std::move(function));
    }
  }

  // This function replaces memory.grow instruction calls in the wasm module.
  // Because the multiple discrete memories are lowered into a single memory,
  // we need to adjust offsets as a particular memory receives an
  // instruction to grow.
  std::unique_ptr<Function> memoryGrow(Index memIdx) {
    Builder builder(*wasm);
    Name functionName =
      Names::getValidFunctionName(*wasm, "adjust_memory_offsets");
    auto function = Builder::makeFunction(
      functionName, Signature(pointerType, pointerType), {});
    function->setLocalName(0, "page_delta");
    auto getPageDelta = [&]() { return builder.makeLocalGet(0, pointerType); };
    Expression* functionBody;

    Index returnLocal = Builder::addVar(function.get(), pointerType);
    functionBody = builder.blockify(builder.makeLocalSet(
      returnLocal, builder.makeCall(memorySizeNames[memIdx], {}, pointerType)));

    functionBody = builder.blockify(
      functionBody,
      builder.makeDrop(builder.makeMemoryGrow(getPageDelta(), combinedMemory)));

    // If we are not growing the last memory, then we need to copy data,
    // shifting it over to accomodate the increase from page_delta
    if (memIdx != offsetGlobalNames.size()) {
      // This offset is the starting pt for copying
      auto& offsetGlobalName = offsetGlobalNames[memIdx];
      functionBody = builder.blockify(
        functionBody,
        builder.makeMemoryCopy(
          // destination
          builder.makeBinary(
            Abstract::getBinary(pointerType, Abstract::Add),
            builder.makeGlobalGet(offsetGlobalName, pointerType),
            getPageDelta()),
          // source
          builder.makeGlobalGet(offsetGlobalName, pointerType),
          // size
          builder.makeBinary(
            Abstract::getBinary(pointerType, Abstract::Sub),
            builder.makeMemorySize(combinedMemory),
            builder.makeGlobalGet(offsetGlobalName, pointerType)),
          combinedMemory,
          combinedMemory));
    }

    // Adjust the offsets of the globals impacted by the memory.grow call
    for (Index i = memIdx; i < offsetGlobalNames.size(); i++) {
      auto& offsetGlobalName = offsetGlobalNames[i];
      functionBody = builder.blockify(
        functionBody,
        builder.makeGlobalSet(
          offsetGlobalName,
          builder.makeBinary(
            Abstract::getBinary(pointerType, Abstract::Add),
            builder.makeGlobalGet(offsetGlobalName, pointerType),
            getPageDelta())));
    }

    functionBody = builder.blockify(
      functionBody, builder.makeLocalGet(returnLocal, pointerType));

    function->body = functionBody;
    return function;
  }

  // This function replaces memory.size instructions with a function that can
  // return the size of each memory as if each was discrete and separate.
  std::unique_ptr<Function> memorySize(Index memIdx) {
    Builder builder(*wasm);
    Name functionName = Names::getValidFunctionName(*wasm, "multi_memory_size");
    auto function = Builder::makeFunction(
      functionName, Signature(Type::none, pointerType), {});
    Expression* functionBody;

    // offsetGlobalNames does not keep track of a global for the offset of
    // wasm->memories[0] because it's always 0. As a result, the below
    // calculations that involve offsetGlobalNames are intrinsically "offset".
    // Thus, offsetGlobalNames[0] is the offset for wasm->memories[1] and
    // the size of wasm->memories[0].
    if (memIdx == 0) {
      auto& offsetGlobalName = offsetGlobalNames[0];
      functionBody = builder.makeReturn(
        builder.makeGlobalGet(offsetGlobalName, pointerType));
    } else if (memIdx == offsetGlobalNames.size()) {
      auto& offsetGlobalName = offsetGlobalNames[memIdx - 1];
      functionBody = builder.makeReturn(builder.makeBinary(
        Abstract::getBinary(pointerType, Abstract::Sub),
        builder.makeMemorySize(combinedMemory),
        builder.makeGlobalGet(offsetGlobalName, pointerType)));
    } else {
      auto& offsetGlobalName = offsetGlobalNames[memIdx];
      auto& nextOffsetGlobalName = offsetGlobalNames[memIdx + 1];
      functionBody = builder.makeReturn(builder.makeBinary(
        Abstract::getBinary(pointerType, Abstract::Sub),
        builder.makeGlobalGet(nextOffsetGlobalName, pointerType),
        builder.makeGlobalGet(offsetGlobalName, pointerType)));
    }

    function->body = functionBody;
    return function;
  }

  void removeExistingMemories() {
    wasm->removeMemories([&](Memory* curr) {
      if (curr->name != combinedMemory) {
        return true;
      }
      return false;
    });
  }
};

Pass* createMultiMemoryLoweringPass() { return new MultiMemoryLowering(); }

} // namespace wasm
