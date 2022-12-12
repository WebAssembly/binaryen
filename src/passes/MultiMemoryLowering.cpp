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
// Condensing a module with multiple memories into a module with a single memory
// for browsers that don’t support multiple memories.
//
// This pass also disables multi-memories so that the target features section in
// the emitted module does not report the use of MultiMemories. Disabling the
// multi-memories feature also prevents later passes from adding additional
// memories.
//
// The offset computation in function maybeMakeBoundsCheck is not precise
// according to the spec. In the spec offsets do not overflow as
// twos-complement, but i32.add does. Concretely, a load from address 1000 with
// offset 0xffffffff should actually trap, as the combined number is greater
// than 32 bits. But with an add, 1000 + 0xffffffff = 999 due to overflow, which
// would not trap. In theory we could compute like the spec, by expanding the
// i32s to i64s and adding there (where we won't overflow), but we don't have
// i128s to handle i64 overflow.

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
  Type pointerType;
  // Used to indicate the type of the single memory when creating instructions
  // (memory.grow, memory.size) for that memory
  Builder::MemoryInfo memoryInfo;
  // If the combined memory is shared
  bool isShared;
  // The initial page size of the combined memory
  Address totalInitialPages;
  // The max page size of the combined memory
  Address totalMaxPages;
  // There is no offset for the first memory, so offsetGlobalNames will always
  // have a size that is one less than the count of memories at the time this
  // pass is run. Use helper getOffsetGlobal(Index) to index the vector
  // conveniently without having to manipulate the index directly
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

  bool checkBounds = false;

  MultiMemoryLowering(bool checkBounds) : checkBounds(checkBounds) {}

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
      auto idx = parent.memoryIdxMap.at(curr->memory);
      Name funcName = parent.memoryGrowNames[idx];
      replaceCurrent(builder.makeCall(funcName, {curr->delta}, curr->type));
    }

    void visitMemorySize(MemorySize* curr) {
      auto idx = parent.memoryIdxMap.at(curr->memory);
      Name funcName = parent.memorySizeNames[idx];
      replaceCurrent(builder.makeCall(funcName, {}, curr->type));
    }

    template<typename T>
    Expression* getPtr(T* curr, Function* func, Index bytes) {
      auto memoryIdx = parent.memoryIdxMap.at(curr->memory);
      auto offsetGlobal = parent.getOffsetGlobal(memoryIdx);
      Expression* ptrValue;
      if (offsetGlobal) {
        ptrValue = builder.makeBinary(
          Abstract::getBinary(parent.pointerType, Abstract::Add),
          builder.makeGlobalGet(offsetGlobal, parent.pointerType),
          curr->ptr);
      } else {
        ptrValue = curr->ptr;
      }

      if (parent.checkBounds) {
        Index ptrIdx = Builder::addVar(getFunction(), parent.pointerType);
        Expression* ptrSet = builder.makeLocalSet(ptrIdx, ptrValue);
        Expression* boundsCheck =
          makeBoundsCheck(curr, ptrIdx, memoryIdx, bytes);
        Expression* ptrGet = builder.makeLocalGet(ptrIdx, parent.pointerType);
        return builder.makeBlock({ptrSet, boundsCheck, ptrGet});
      }

      return ptrValue;
    }

    template<typename T>
    Expression*
    makeBoundsCheck(T* curr, Index ptrIdx, Index memoryIdx, Index bytes) {
      Name memorySizeFunc = parent.memorySizeNames[memoryIdx];
      Expression* boundsCheck = builder.makeIf(
        builder.makeBinary(
          Abstract::getBinary(parent.pointerType, Abstract::GtU),
          builder.makeBinary(
            // ptr + offset (ea from wasm spec) + bit width
            // two builder Adds, we'll add the first two operands in the first
            // add and then add the third operand in the second add
            Abstract::getBinary(parent.pointerType, Abstract::Add),
            builder.makeBinary(
              Abstract::getBinary(parent.pointerType, Abstract::Add),
              builder.makeLocalGet(ptrIdx, parent.pointerType),
              builder.makeConstPtr(curr->offset, parent.pointerType)),
            builder.makeConstPtr(bytes, parent.pointerType)),
          builder.makeCall(memorySizeFunc, {}, parent.pointerType)),
        builder.makeUnreachable());
      return boundsCheck;
    }

    template<typename T> void setMemory(T* curr) {
      curr->memory = parent.combinedMemory;
    }

    void visitLoad(Load* curr) {
      curr->ptr = getPtr(curr, getFunction(), curr->bytes);
      setMemory(curr);
    }

    void visitStore(Store* curr) {
      curr->ptr = getPtr(curr, getFunction(), curr->bytes);
      setMemory(curr);
    }

    void visitSIMDLoad(SIMDLoad* curr) {
      curr->ptr = getPtr(curr, getFunction(), curr->getMemBytes());
      setMemory(curr);
    }

    void visitSIMDLoadSplat(SIMDLoad* curr) {
      curr->ptr = getPtr(curr, getFunction(), curr->getMemBytes());
      setMemory(curr);
    }

    void visitSIMDLoadExtend(SIMDLoad* curr) {
      curr->ptr = getPtr(curr, getFunction(), curr->getMemBytes());
      setMemory(curr);
    }

    void visitSIMDLoadZero(SIMDLoad* curr) {
      curr->ptr = getPtr(curr, getFunction(), curr->getMemBytes());
      setMemory(curr);
    }

    void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
      curr->ptr = getPtr(curr, getFunction(), curr->getMemBytes());
      setMemory(curr);
    }
  };

  void run(Module* module) override {
    module->features.disable(FeatureSet::MultiMemories);

    // If there are no memories or 1 memory, skip this pass
    if (module->memories.size() <= 1) {
      return;
    }

    this->wasm = module;

    prepCombinedMemory();
    addOffsetGlobals();
    adjustActiveDataSegmentOffsets();
    createMemorySizeFunctions();
    createMemoryGrowFunctions();
    removeExistingMemories();
    addCombinedMemory();

    Replacer(*this, *wasm).run(getPassRunner(), wasm);
  }

  // Returns the global name for the given idx. There is no global for the first
  // idx, so an empty name is returned
  Name getOffsetGlobal(Index idx) {
    // There is no offset global for the first memory
    if (idx == 0) {
      return Name();
    }

    // Since there is no offset global for the first memory, we need to
    // subtract one when indexing into the offsetGlobalName vector
    return offsetGlobalNames[idx - 1];
  }

  // Whether the idx represents the last memory. Since there is no offset global
  // for the first memory, the last memory is represented by the size of
  // offsetGlobalNames
  bool isLastMemory(Index idx) { return idx == offsetGlobalNames.size(); }

  void prepCombinedMemory() {
    pointerType = wasm->memories[0]->indexType;
    memoryInfo = pointerType == Type::i32 ? Builder::MemoryInfo::Memory32
                                          : Builder::MemoryInfo::Memory64;
    isShared = wasm->memories[0]->shared;
    for (auto& memory : wasm->memories) {
      // We are assuming that each memory is configured the same as the first
      // and assert if any of the memories does not match this configuration
      assert(memory->shared == isShared);
      assert(memory->indexType == pointerType);

      // Calculating the total initial and max page size for the combined memory
      // by totaling the initial and max page sizes for the memories in the
      // module
      totalInitialPages = totalInitialPages + memory->initial;
      if (memory->hasMax()) {
        totalMaxPages = totalMaxPages + memory->max;
      }
    }
    // Ensuring valid initial and max page sizes that do not exceed the number
    // of pages addressable by the pointerType
    Address maxSize =
      pointerType == Type::i32 ? Memory::kMaxSize32 : Memory::kMaxSize64;
    if (totalMaxPages > maxSize || totalMaxPages == 0) {
      totalMaxPages = Memory::kUnlimitedSize;
    }
    if (totalInitialPages > totalMaxPages) {
      totalInitialPages = totalMaxPages;
    }

    // Creating the combined memory name so we can reference the combined memory
    // in subsequent instructions before it is added to the module
    combinedMemory = Names::getValidMemoryName(*wasm, "combined_memory");
  }

  void addOffsetGlobals() {
    auto addGlobal = [&](Name name, size_t offset) {
      auto global = Builder::makeGlobal(
        name,
        pointerType,
        Builder(*wasm).makeConst(Literal::makeFromInt64(offset, pointerType)),
        Builder::Mutable);
      wasm->addGlobal(std::move(global));
    };

    size_t offsetRunningTotal = 0;
    for (Index i = 0; i < wasm->memories.size(); i++) {
      auto& memory = wasm->memories[i];
      memoryIdxMap[memory->name] = i;
      // We don't need a page offset global for the first memory as it's always
      // 0
      if (i != 0) {
        Name name = Names::getValidGlobalName(
          *wasm, memory->name.toString() + "_byte_offset");
        offsetGlobalNames.push_back(std::move(name));
        addGlobal(name, offsetRunningTotal * Memory::kPageSize);
      }
      offsetRunningTotal += memory->initial;
    }
  }

  void adjustActiveDataSegmentOffsets() {
    Builder builder(*wasm);
    ModuleUtils::iterActiveDataSegments(*wasm, [&](DataSegment* dataSegment) {
      assert(dataSegment->offset->is<Const>() &&
             "TODO: handle non-const segment offsets");
      auto idx = memoryIdxMap.at(dataSegment->memory);
      dataSegment->memory = combinedMemory;
      // No need to update the offset of data segments for the first memory
      if (idx != 0) {
        auto offsetGlobalName = getOffsetGlobal(idx);
        assert(wasm->features.hasExtendedConst());
        dataSegment->offset = builder.makeBinary(
          Abstract::getBinary(pointerType, Abstract::Add),
          builder.makeGlobalGet(offsetGlobalName, pointerType),
          dataSegment->offset);
      }
    });
  }

  void createMemorySizeFunctions() {
    for (Index i = 0; i < wasm->memories.size(); i++) {
      auto function = memorySize(i, wasm->memories[i]->name);
      memorySizeNames.push_back(function->name);
      wasm->addFunction(std::move(function));
    }
  }

  void createMemoryGrowFunctions() {
    for (Index i = 0; i < wasm->memories.size(); i++) {
      auto function = memoryGrow(i, wasm->memories[i]->name);
      memoryGrowNames.push_back(function->name);
      wasm->addFunction(std::move(function));
    }
  }

  // This function replaces memory.grow instruction calls in the wasm module.
  // Because the multiple discrete memories are lowered into a single memory,
  // we need to adjust offsets as a particular memory receives an
  // instruction to grow.
  std::unique_ptr<Function> memoryGrow(Index memIdx, Name memoryName) {
    Builder builder(*wasm);
    Name name = memoryName.toString() + "_grow";
    Name functionName = Names::getValidFunctionName(*wasm, name);
    auto function = Builder::makeFunction(
      functionName, Signature(pointerType, pointerType), {});
    function->setLocalName(0, "page_delta");
    auto pageSizeConst = [&]() {
      return builder.makeConst(Literal(Memory::kPageSize));
    };
    auto getOffsetDelta = [&]() {
      return builder.makeBinary(Abstract::getBinary(pointerType, Abstract::Mul),
                                builder.makeLocalGet(0, pointerType),
                                pageSizeConst());
    };
    auto getMoveSource = [&](Name global) {
      return builder.makeGlobalGet(global, pointerType);
    };
    Expression* functionBody;
    Index sizeLocal = -1;

    Index returnLocal =
      Builder::addVar(function.get(), "return_size", pointerType);
    functionBody = builder.blockify(builder.makeLocalSet(
      returnLocal, builder.makeCall(memorySizeNames[memIdx], {}, pointerType)));

    if (!isLastMemory(memIdx)) {
      sizeLocal = Builder::addVar(function.get(), "memory_size", pointerType);
      functionBody = builder.blockify(
        functionBody,
        builder.makeLocalSet(
          sizeLocal, builder.makeMemorySize(combinedMemory, memoryInfo)));
    }

    // Attempt to grow the combinedMemory. If -1 returns, enough memory could
    // not be allocated, so return -1.
    functionBody = builder.blockify(
      functionBody,
      builder.makeIf(
        builder.makeBinary(
          EqInt32,
          builder.makeMemoryGrow(
            builder.makeLocalGet(0, pointerType), combinedMemory, memoryInfo),
          builder.makeConst(-1)),
        builder.makeReturn(builder.makeConst(-1))));

    // If we are not growing the last memory, then we need to copy data,
    // shifting it over to accomodate the increase from page_delta
    if (!isLastMemory(memIdx)) {
      // This offset is the starting pt for copying
      auto offsetGlobalName = getOffsetGlobal(memIdx + 1);
      functionBody = builder.blockify(
        functionBody,
        builder.makeMemoryCopy(
          // destination
          builder.makeBinary(Abstract::getBinary(pointerType, Abstract::Add),
                             getMoveSource(offsetGlobalName),
                             getOffsetDelta()),
          // source
          getMoveSource(offsetGlobalName),
          // size
          builder.makeBinary(
            Abstract::getBinary(pointerType, Abstract::Sub),
            builder.makeBinary(Abstract::getBinary(pointerType, Abstract::Mul),
                               builder.makeLocalGet(sizeLocal, pointerType),
                               pageSizeConst()),
            getMoveSource(offsetGlobalName)),
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
          builder.makeBinary(Abstract::getBinary(pointerType, Abstract::Add),
                             getMoveSource(offsetGlobalName),
                             getOffsetDelta())));
    }

    functionBody = builder.blockify(
      functionBody, builder.makeLocalGet(returnLocal, pointerType));

    function->body = functionBody;
    return function;
  }

  // This function replaces memory.size instructions with a function that can
  // return the size of each memory as if each was discrete and separate.
  std::unique_ptr<Function> memorySize(Index memIdx, Name memoryName) {
    Builder builder(*wasm);
    Name name = memoryName.toString() + "_size";
    Name functionName = Names::getValidFunctionName(*wasm, name);
    auto function = Builder::makeFunction(
      functionName, Signature(Type::none, pointerType), {});
    Expression* functionBody;
    auto pageSizeConst = [&]() {
      return builder.makeConst(Literal(Memory::kPageSize));
    };
    auto getOffsetInPageUnits = [&](Name global) {
      return builder.makeBinary(
        Abstract::getBinary(pointerType, Abstract::DivU),
        builder.makeGlobalGet(global, pointerType),
        pageSizeConst());
    };

    // offsetGlobalNames does not keep track of a global for the offset of
    // wasm->memories[0] because it's always 0. As a result, the below
    // calculations that involve offsetGlobalNames are intrinsically "offset".
    // Thus, offsetGlobalNames[0] is the offset for wasm->memories[1] and
    // the size of wasm->memories[0].
    if (memIdx == 0) {
      auto offsetGlobalName = getOffsetGlobal(1);
      functionBody = builder.blockify(
        builder.makeReturn(getOffsetInPageUnits(offsetGlobalName)));
    } else if (isLastMemory(memIdx)) {
      auto offsetGlobalName = getOffsetGlobal(memIdx);
      functionBody = builder.blockify(builder.makeReturn(
        builder.makeBinary(Abstract::getBinary(pointerType, Abstract::Sub),
                           builder.makeMemorySize(combinedMemory, memoryInfo),
                           getOffsetInPageUnits(offsetGlobalName))));
    } else {
      auto offsetGlobalName = getOffsetGlobal(memIdx);
      auto nextOffsetGlobalName = getOffsetGlobal(memIdx + 1);
      functionBody = builder.blockify(builder.makeReturn(
        builder.makeBinary(Abstract::getBinary(pointerType, Abstract::Sub),
                           getOffsetInPageUnits(nextOffsetGlobalName),
                           getOffsetInPageUnits(offsetGlobalName))));
    }

    function->body = functionBody;
    return function;
  }

  void removeExistingMemories() {
    wasm->removeMemories([&](Memory* curr) { return true; });
  }

  void addCombinedMemory() {
    auto memory = Builder::makeMemory(combinedMemory);
    memory->shared = isShared;
    memory->indexType = pointerType;
    memory->initial = totalInitialPages;
    memory->max = totalMaxPages;
    wasm->addMemory(std::move(memory));
  }
};

Pass* createMultiMemoryLoweringPass() { return new MultiMemoryLowering(false); }

Pass* createMultiMemoryLoweringWithBoundsChecksPass() {
  return new MultiMemoryLowering(true);
}

} // namespace wasm
