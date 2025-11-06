/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Instruments code to check for incorrect heap access. This checks
// for dereferencing 0 (null pointer access), reading past the valid
// top of sbrk()-addressible memory, and incorrect alignment notation.
//

#include "asmjs/shared-constants.h"
#include "ir/bits.h"
#include "ir/find_all.h"
#include "ir/import-utils.h"
#include "ir/load-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

static const Name GET_SBRK_PTR("emscripten_get_sbrk_ptr");
static const Name SBRK("sbrk");
static const Name SEGFAULT_IMPORT("segfault");
static const Name ALIGNFAULT_IMPORT("alignfault");

static Name getLoadName(Load* curr) {
  std::string ret = "SAFE_HEAP_LOAD_";
  ret += curr->type.toString();
  ret += "_" + std::to_string(curr->bytes) + "_";
  if (LoadUtils::isSignRelevant(curr) && !curr->signed_) {
    ret += "U_";
  }
  if (curr->isAtomic) {
    ret += "A";
  } else {
    ret += std::to_string(curr->align);
  }
  return ret;
}

static Name getStoreName(Store* curr) {
  std::string ret = "SAFE_HEAP_STORE_";
  ret += curr->valueType.toString();
  ret += "_" + std::to_string(curr->bytes) + "_";
  if (curr->isAtomic) {
    ret += "A";
  } else {
    ret += std::to_string(curr->align);
  }
  return ret;
}

struct AccessInstrumenter : public WalkerPass<PostWalker<AccessInstrumenter>> {
  // A set of function that we should ignore (not instrument).
  std::set<Name> ignoreFunctions;

  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<AccessInstrumenter>(ignoreFunctions);
  }

  AccessInstrumenter(std::set<Name> ignoreFunctions)
    : ignoreFunctions(ignoreFunctions) {}

  void visitLoad(Load* curr) {
    if (ignoreFunctions.count(getFunction()->name) != 0 ||
        curr->type == Type::unreachable) {
      return;
    }
    Builder builder(*getModule());
    auto memory = getModule()->getMemory(curr->memory);
    replaceCurrent(builder.makeCall(
      getLoadName(curr),
      {curr->ptr, builder.makeConstPtr(curr->offset.addr, memory->addressType)},
      curr->type));
  }

  void visitStore(Store* curr) {
    if (ignoreFunctions.count(getFunction()->name) != 0 ||
        curr->type == Type::unreachable) {
      return;
    }
    Builder builder(*getModule());
    auto memory = getModule()->getMemory(curr->memory);
    replaceCurrent(builder.makeCall(
      getStoreName(curr),
      {curr->ptr,
       builder.makeConstPtr(curr->offset.addr, memory->addressType),
       curr->value},
      Type::none));
  }
};

static std::set<Name> findCalledFunctions(Module* module, Name startFunc) {
  std::set<Name> called;
  std::vector<Name> toVisit;

  auto addFunction = [&](Name name) {
    if (called.insert(name).second) {
      toVisit.push_back(name);
    }
  };

  if (startFunc.is()) {
    addFunction(startFunc);
    while (!toVisit.empty()) {
      auto next = toVisit.back();
      toVisit.pop_back();
      auto* func = module->getFunction(next);
      for (auto* call : FindAll<Call>(func->body).list) {
        addFunction(call->target);
      }
    }
  }

  return called;
}

struct SafeHeap : public Pass {
  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    assert(!module->memories.empty());
    // add imports
    addImports(module);
    // instrument loads and stores
    // We avoid instrumenting the module start function of any function that it
    // directly calls.  This is because in some cases the linker generates
    // `__wasm_init_memory` (either as the start function or a function directly
    // called from it) and this function is used in shared memory builds to load
    // the passive memory segments, which in turn means that value of sbrk() is
    // not available until after it has run.
    std::set<Name> ignoreFunctions = findCalledFunctions(module, module->start);
    ignoreFunctions.insert(getSbrkPtr);
    AccessInstrumenter(ignoreFunctions).run(getPassRunner(), module);
    // add helper checking funcs and imports
    addGlobals(module, module->features);
  }

  Name getSbrkPtr, dynamicTopPtr, sbrk, segfault, alignfault;

  void addImports(Module* module) {
    ImportInfo info(*module);
    auto addressType = module->memories[0]->addressType;
    if (auto* existing = info.getImportedFunction(ENV, GET_SBRK_PTR)) {
      getSbrkPtr = existing->name;
    } else if (auto* existing = module->getExportOrNull(GET_SBRK_PTR);
               existing && existing->kind == ExternalKind::Function) {
      getSbrkPtr = *existing->getInternalName();
    } else if (auto* existing = info.getImportedFunction(ENV, SBRK)) {
      sbrk = existing->name;
    } else {
      auto import = Builder::makeFunction(
        GET_SBRK_PTR,
        Type(Signature(Type::none, addressType), NonNullable, Inexact),
        {});
      getSbrkPtr = GET_SBRK_PTR;
      import->module = ENV;
      import->base = GET_SBRK_PTR;
      module->addFunction(std::move(import));
    }
    if (auto* existing = info.getImportedFunction(ENV, SEGFAULT_IMPORT)) {
      segfault = existing->name;
    } else {
      auto import = Builder::makeFunction(
        SEGFAULT_IMPORT,
        Type(Signature(Type::none, Type::none), NonNullable, Inexact),
        {});
      segfault = SEGFAULT_IMPORT;
      import->module = ENV;
      import->base = SEGFAULT_IMPORT;
      module->addFunction(std::move(import));
    }
    if (auto* existing = info.getImportedFunction(ENV, ALIGNFAULT_IMPORT)) {
      alignfault = existing->name;
    } else {
      auto import = Builder::makeFunction(
        ALIGNFAULT_IMPORT,
        Type(Signature(Type::none, Type::none), NonNullable, Inexact),
        {});

      alignfault = ALIGNFAULT_IMPORT;
      import->module = ENV;
      import->base = ALIGNFAULT_IMPORT;
      module->addFunction(std::move(import));
    }
  }

  bool
  isPossibleAtomicOperation(Index align, Index bytes, bool shared, Type type) {
    return align == bytes && shared && type.isInteger();
  }

  void addGlobals(Module* module, FeatureSet features) {
    // load funcs
    Load load;
    for (Type type : {Type::i32, Type::i64, Type::f32, Type::f64, Type::v128}) {
      if (type == Type::v128 && !features.hasSIMD()) {
        continue;
      }
      load.type = type;
      load.memory = module->memories[0]->name;
      for (Index bytes : {1, 2, 4, 8, 16}) {
        load.bytes = bytes;
        if (bytes > type.getByteSize() || (type == Type::f32 && bytes != 4) ||
            (type == Type::f64 && bytes != 8) ||
            (type == Type::v128 && bytes != 16)) {
          continue;
        }
        for (auto signed_ : {true, false}) {
          load.signed_ = signed_;
          if (type.isFloat() && signed_) {
            continue;
          }
          for (Index align : {1, 2, 4, 8, 16}) {
            load.align = align;
            if (align > bytes) {
              continue;
            }
            for (auto isAtomic : {true, false}) {
              load.isAtomic = isAtomic;
              if (isAtomic &&
                  !isPossibleAtomicOperation(
                    align, bytes, module->memories[0]->shared, type)) {
                continue;
              }
              addLoadFunc(load, module);
            }
          }
        }
      }
    }
    // store funcs
    Store store;
    for (Type valueType :
         {Type::i32, Type::i64, Type::f32, Type::f64, Type::v128}) {
      if (valueType == Type::v128 && !features.hasSIMD()) {
        continue;
      }
      store.valueType = valueType;
      store.type = Type::none;
      store.memory = module->memories[0]->name;
      for (Index bytes : {1, 2, 4, 8, 16}) {
        store.bytes = bytes;
        if (bytes > valueType.getByteSize() ||
            (valueType == Type::f32 && bytes != 4) ||
            (valueType == Type::f64 && bytes != 8) ||
            (valueType == Type::v128 && bytes != 16)) {
          continue;
        }
        for (Index align : {1, 2, 4, 8, 16}) {
          store.align = align;
          if (align > bytes) {
            continue;
          }
          for (auto isAtomic : {true, false}) {
            store.isAtomic = isAtomic;
            if (isAtomic &&
                !isPossibleAtomicOperation(
                  align, bytes, module->memories[0]->shared, valueType)) {
              continue;
            }
            addStoreFunc(store, module);
          }
        }
      }
    }
  }

  // creates a function for a particular style of load
  void addLoadFunc(Load style, Module* module) {
    auto name = getLoadName(&style);
    if (module->getFunctionOrNull(name)) {
      return;
    }
    // pointer, offset
    auto memory = module->getMemory(style.memory);
    auto addressType = memory->addressType;
    auto funcSig = Signature({addressType, addressType}, style.type);
    auto func = Builder::makeFunction(name, funcSig, {addressType});
    Builder builder(*module);
    auto* block = builder.makeBlock();
    // stash the sum of the pointer (0) and the size (1) in a local (2)
    block->list.push_back(builder.makeLocalSet(
      2,
      builder.makeBinary(memory->is64() ? AddInt64 : AddInt32,
                         builder.makeLocalGet(0, addressType),
                         builder.makeLocalGet(1, addressType))));
    // check for reading past valid memory: if pointer + offset + bytes
    block->list.push_back(makeBoundsCheck(style.type,
                                          builder,
                                          0,
                                          2,
                                          style.bytes,
                                          module,
                                          memory->addressType,
                                          memory->is64(),
                                          memory->name));
    // check proper alignment
    if (style.align > 1) {
      block->list.push_back(
        makeAlignCheck(style.align, builder, 2, module, memory->name));
    }
    // do the load
    auto* load = module->allocator.alloc<Load>();
    *load = style; // basically the same as the template we are given!
    load->ptr = builder.makeLocalGet(2, addressType);
    Expression* last = load;
    if (load->isAtomic && load->signed_) {
      // atomic loads cannot be signed, manually sign it
      last = Bits::makeSignExt(load, load->bytes, *module);
      load->signed_ = false;
    }
    block->list.push_back(last);
    block->finalize(style.type);
    func->body = block;
    module->addFunction(std::move(func));
  }

  // creates a function for a particular type of store
  void addStoreFunc(Store style, Module* module) {
    auto name = getStoreName(&style);
    if (module->getFunctionOrNull(name)) {
      return;
    }
    auto memory = module->getMemory(style.memory);
    auto addressType = memory->addressType;
    bool is64 = memory->is64();
    // pointer, offset, value
    auto funcSig =
      Signature({addressType, addressType, style.valueType}, Type::none);
    auto func = Builder::makeFunction(name, funcSig, {addressType});
    Builder builder(*module);
    auto* block = builder.makeBlock();
    block->list.push_back(builder.makeLocalSet(
      3,
      builder.makeBinary(is64 ? AddInt64 : AddInt32,
                         builder.makeLocalGet(0, addressType),
                         builder.makeLocalGet(1, addressType))));
    // check for reading past valid memory: if pointer + offset + bytes
    block->list.push_back(makeBoundsCheck(style.valueType,
                                          builder,
                                          0,
                                          3,
                                          style.bytes,
                                          module,
                                          addressType,
                                          is64,
                                          memory->name));
    // check proper alignment
    if (style.align > 1) {
      block->list.push_back(
        makeAlignCheck(style.align, builder, 3, module, memory->name));
    }
    // do the store
    auto* store = module->allocator.alloc<Store>();
    *store = style; // basically the same as the template we are given!
    store->memory = memory->name;
    store->ptr = builder.makeLocalGet(3, addressType);
    store->value = builder.makeLocalGet(2, style.valueType);
    block->list.push_back(store);
    block->finalize(Type::none);
    func->body = block;
    module->addFunction(std::move(func));
  }

  Expression* makeAlignCheck(Address align,
                             Builder& builder,
                             Index local,
                             Module* module,
                             Name memoryName) {
    auto memory = module->getMemory(memoryName);
    auto addressType = memory->addressType;
    Expression* ptrBits = builder.makeLocalGet(local, addressType);
    if (memory->is64()) {
      ptrBits = builder.makeUnary(WrapInt64, ptrBits);
    }
    return builder.makeIf(
      builder.makeBinary(
        AndInt32, ptrBits, builder.makeConst(int32_t(align - 1))),
      builder.makeCall(alignfault, {}, Type::none));
  }

  // Constructs a bounds check. This receives the indexes of two locals: the
  // pointer local, which contains the pointer we are checking, and the sum
  // local which contains the pointer added to the number of bytes being
  // accessed.
  Expression* makeBoundsCheck(Type type,
                              Builder& builder,
                              Index ptrLocal,
                              Index sumLocal,
                              Index bytes,
                              Module* module,
                              Type addressType,
                              bool is64,
                              Name memory) {
    bool lowMemUnused = getPassOptions().lowMemoryUnused;
    auto upperOp = is64 ? lowMemUnused ? LtUInt64 : EqInt64
                        : lowMemUnused ? LtUInt32 : EqInt32;
    auto upperBound = lowMemUnused ? PassOptions::LowMemoryBound : 0;
    Expression* brkLocation;
    if (sbrk.is()) {
      brkLocation = builder.makeCall(
        sbrk, {builder.makeConstPtr(0, addressType)}, addressType);
    } else {
      Expression* sbrkPtr;
      if (dynamicTopPtr.is()) {
        sbrkPtr = builder.makeGlobalGet(dynamicTopPtr, addressType);
      } else {
        sbrkPtr = builder.makeCall(getSbrkPtr, {}, addressType);
      }
      auto size = is64 ? 8 : 4;
      brkLocation =
        builder.makeLoad(size, false, 0, size, sbrkPtr, addressType, memory);
    }
    auto gtuOp = is64 ? GtUInt64 : GtUInt32;
    auto addOp = is64 ? AddInt64 : AddInt32;
    auto* upperCheck =
      builder.makeBinary(upperOp,
                         builder.makeLocalGet(sumLocal, addressType),
                         builder.makeConstPtr(upperBound, addressType));
    auto* lowerCheck = builder.makeBinary(
      gtuOp,
      builder.makeBinary(addOp,
                         builder.makeLocalGet(sumLocal, addressType),
                         builder.makeConstPtr(bytes, addressType)),
      brkLocation);
    // Check for an overflow when adding the pointer and the size, using the
    // rule that for any unsigned x and y,
    //    x + y < x    <=>   x + y overflows
    auto* overflowCheck =
      builder.makeBinary(is64 ? LtUInt64 : LtUInt32,
                         builder.makeLocalGet(sumLocal, addressType),
                         builder.makeLocalGet(ptrLocal, addressType));
    // Add an unreachable right after the call to segfault for performance
    // reasons: the call never returns, and this helps optimizations benefit
    // from that.
    return builder.makeIf(
      builder.makeBinary(
        OrInt32,
        upperCheck,
        builder.makeBinary(OrInt32, lowerCheck, overflowCheck)),
      builder.makeSequence(builder.makeCall(segfault, {}, Type::none),
                           builder.makeUnreachable()));
  }
};

Pass* createSafeHeapPass() { return new SafeHeap(); }

} // namespace wasm
