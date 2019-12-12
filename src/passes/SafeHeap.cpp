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

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ir/bits.h"
#include "ir/import-utils.h"
#include "ir/load-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

static const Name DYNAMICTOP_PTR_IMPORT("DYNAMICTOP_PTR");
static const Name GET_SBRK_PTR_IMPORT("emscripten_get_sbrk_ptr");
static const Name GET_SBRK_PTR_EXPORT("_emscripten_get_sbrk_ptr");
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
  bool isFunctionParallel() override { return true; }

  AccessInstrumenter* create() override { return new AccessInstrumenter; }

  void visitLoad(Load* curr) {
    if (curr->type == unreachable) {
      return;
    }
    Builder builder(*getModule());
    replaceCurrent(
      builder.makeCall(getLoadName(curr),
                       {
                         curr->ptr,
                         builder.makeConst(Literal(int32_t(curr->offset))),
                       },
                       curr->type));
  }

  void visitStore(Store* curr) {
    if (curr->type == unreachable) {
      return;
    }
    Builder builder(*getModule());
    replaceCurrent(
      builder.makeCall(getStoreName(curr),
                       {
                         curr->ptr,
                         builder.makeConst(Literal(int32_t(curr->offset))),
                         curr->value,
                       },
                       none));
  }
};

struct SafeHeap : public Pass {
  PassOptions options;

  void run(PassRunner* runner, Module* module) override {
    options = runner->options;
    // add imports
    addImports(module);
    // instrument loads and stores
    AccessInstrumenter().run(runner, module);
    // add helper checking funcs and imports
    addGlobals(module, module->features);
  }

  Name dynamicTopPtr, getSbrkPtr, sbrk, segfault, alignfault;

  void addImports(Module* module) {
    ImportInfo info(*module);
    // Older emscripten imports env.DYNAMICTOP_PTR.
    // Newer emscripten imports emscripten_get_sbrk_ptr(), which is later
    // optimized to have the number in the binary (or in the case of fastcomp,
    // emscripten_get_sbrk_ptr is an asm.js library function so it is inside
    // the wasm, and discoverable via an export).
    if (auto* existing = info.getImportedGlobal(ENV, DYNAMICTOP_PTR_IMPORT)) {
      dynamicTopPtr = existing->name;
    } else if (auto* existing =
                 info.getImportedFunction(ENV, GET_SBRK_PTR_IMPORT)) {
      getSbrkPtr = existing->name;
    } else if (auto* existing = module->getExportOrNull(GET_SBRK_PTR_EXPORT)) {
      getSbrkPtr = existing->value;
    } else if (auto* existing = info.getImportedFunction(ENV, SBRK)) {
      sbrk = existing->name;
    } else {
      auto* import = new Function;
      import->name = getSbrkPtr = GET_SBRK_PTR_IMPORT;
      import->module = ENV;
      import->base = GET_SBRK_PTR_IMPORT;
      import->sig = Signature(Type::none, Type::i32);
      module->addFunction(import);
    }
    if (auto* existing = info.getImportedFunction(ENV, SEGFAULT_IMPORT)) {
      segfault = existing->name;
    } else {
      auto* import = new Function;
      import->name = segfault = SEGFAULT_IMPORT;
      import->module = ENV;
      import->base = SEGFAULT_IMPORT;
      import->sig = Signature(Type::none, Type::none);
      module->addFunction(import);
    }
    if (auto* existing = info.getImportedFunction(ENV, ALIGNFAULT_IMPORT)) {
      alignfault = existing->name;
    } else {
      auto* import = new Function;
      import->name = alignfault = ALIGNFAULT_IMPORT;
      import->module = ENV;
      import->base = ALIGNFAULT_IMPORT;
      import->sig = Signature(Type::none, Type::none);
      module->addFunction(import);
    }
  }

  bool
  isPossibleAtomicOperation(Index align, Index bytes, bool shared, Type type) {
    return align == bytes && shared && type.isInteger();
  }

  void addGlobals(Module* module, FeatureSet features) {
    // load funcs
    Load load;
    for (auto type : {i32, i64, f32, f64, v128}) {
      if (type == v128 && !features.hasSIMD()) {
        continue;
      }
      load.type = type;
      for (Index bytes : {1, 2, 4, 8, 16}) {
        load.bytes = bytes;
        if (bytes > getTypeSize(type) || (type == f32 && bytes != 4) ||
            (type == f64 && bytes != 8) || (type == v128 && bytes != 16)) {
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
              if (isAtomic && !isPossibleAtomicOperation(
                                align, bytes, module->memory.shared, type)) {
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
    for (auto valueType : {i32, i64, f32, f64, v128}) {
      if (valueType == v128 && !features.hasSIMD()) {
        continue;
      }
      store.valueType = valueType;
      store.type = none;
      for (Index bytes : {1, 2, 4, 8, 16}) {
        store.bytes = bytes;
        if (bytes > getTypeSize(valueType) ||
            (valueType == f32 && bytes != 4) ||
            (valueType == f64 && bytes != 8) ||
            (valueType == v128 && bytes != 16)) {
          continue;
        }
        for (Index align : {1, 2, 4, 8, 16}) {
          store.align = align;
          if (align > bytes) {
            continue;
          }
          for (auto isAtomic : {true, false}) {
            store.isAtomic = isAtomic;
            if (isAtomic && !isPossibleAtomicOperation(
                              align, bytes, module->memory.shared, valueType)) {
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
    auto* func = new Function;
    func->name = name;
    // pointer, offset
    func->sig = Signature({Type::i32, Type::i32}, style.type);
    func->vars.push_back(i32);   // pointer + offset
    Builder builder(*module);
    auto* block = builder.makeBlock();
    block->list.push_back(builder.makeLocalSet(
      2,
      builder.makeBinary(
        AddInt32, builder.makeLocalGet(0, i32), builder.makeLocalGet(1, i32))));
    // check for reading past valid memory: if pointer + offset + bytes
    block->list.push_back(makeBoundsCheck(style.type, builder, 2, style.bytes));
    // check proper alignment
    if (style.align > 1) {
      block->list.push_back(makeAlignCheck(style.align, builder, 2));
    }
    // do the load
    auto* load = module->allocator.alloc<Load>();
    *load = style; // basically the same as the template we are given!
    load->ptr = builder.makeLocalGet(2, i32);
    Expression* last = load;
    if (load->isAtomic && load->signed_) {
      // atomic loads cannot be signed, manually sign it
      last = Bits::makeSignExt(load, load->bytes, *module);
      load->signed_ = false;
    }
    block->list.push_back(last);
    block->finalize(style.type);
    func->body = block;
    module->addFunction(func);
  }

  // creates a function for a particular type of store
  void addStoreFunc(Store style, Module* module) {
    auto name = getStoreName(&style);
    if (module->getFunctionOrNull(name)) {
      return;
    }
    auto* func = new Function;
    func->name = name;
    // pointer, offset, value
    func->sig = Signature({Type::i32, Type::i32, style.valueType}, Type::none);
    func->vars.push_back(i32);               // pointer + offset
    Builder builder(*module);
    auto* block = builder.makeBlock();
    block->list.push_back(builder.makeLocalSet(
      3,
      builder.makeBinary(
        AddInt32, builder.makeLocalGet(0, i32), builder.makeLocalGet(1, i32))));
    // check for reading past valid memory: if pointer + offset + bytes
    block->list.push_back(
      makeBoundsCheck(style.valueType, builder, 3, style.bytes));
    // check proper alignment
    if (style.align > 1) {
      block->list.push_back(makeAlignCheck(style.align, builder, 3));
    }
    // do the store
    auto* store = module->allocator.alloc<Store>();
    *store = style; // basically the same as the template we are given!
    store->ptr = builder.makeLocalGet(3, i32);
    store->value = builder.makeLocalGet(2, style.valueType);
    block->list.push_back(store);
    block->finalize(none);
    func->body = block;
    module->addFunction(func);
  }

  Expression* makeAlignCheck(Address align, Builder& builder, Index local) {
    return builder.makeIf(
      builder.makeBinary(AndInt32,
                         builder.makeLocalGet(local, i32),
                         builder.makeConst(Literal(int32_t(align - 1)))),
      builder.makeCall(alignfault, {}, none));
  }

  Expression*
  makeBoundsCheck(Type type, Builder& builder, Index local, Index bytes) {
    auto upperOp = options.lowMemoryUnused ? LtUInt32 : EqInt32;
    auto upperBound = options.lowMemoryUnused ? PassOptions::LowMemoryBound : 0;
    Expression* brkLocation;
    if (sbrk.is()) {
      brkLocation =
        builder.makeCall(sbrk, {builder.makeConst(Literal(int32_t(0)))}, i32);
    } else {
      Expression* sbrkPtr;
      if (dynamicTopPtr.is()) {
        sbrkPtr = builder.makeGlobalGet(dynamicTopPtr, i32);
      } else {
        sbrkPtr = builder.makeCall(getSbrkPtr, {}, i32);
      }
      brkLocation = builder.makeLoad(4, false, 0, 4, sbrkPtr, i32);
    }
    return builder.makeIf(
      builder.makeBinary(
        OrInt32,
        builder.makeBinary(upperOp,
                           builder.makeLocalGet(local, i32),
                           builder.makeConst(Literal(int32_t(upperBound)))),
        builder.makeBinary(
          GtUInt32,
          builder.makeBinary(AddInt32,
                             builder.makeLocalGet(local, i32),
                             builder.makeConst(Literal(int32_t(bytes)))),
          brkLocation)),
      builder.makeCall(segfault, {}, none));
  }
};

Pass* createSafeHeapPass() { return new SafeHeap(); }

} // namespace wasm
