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

#include "wasm.h"
#include "pass.h"
#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "wasm-builder.h"
#include "ir/bits.h"
#include "ir/function-type-utils.h"
#include "ir/import-utils.h"

namespace wasm {

const Name DYNAMICTOP_PTR_IMPORT("DYNAMICTOP_PTR"),
           SEGFAULT_IMPORT("segfault"),
           ALIGNFAULT_IMPORT("alignfault");

static Name getLoadName(Load* curr) {
  std::string ret = "SAFE_HEAP_LOAD_";
  ret += printType(curr->type);
  ret += "_" + std::to_string(curr->bytes) + "_";
  if (!isFloatType(curr->type) && !curr->signed_) {
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
  ret += printType(curr->valueType);
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
    if (curr->type == unreachable) return;
    Builder builder(*getModule());
    replaceCurrent(
      builder.makeCall(
        getLoadName(curr),
        {
          curr->ptr,
          builder.makeConst(Literal(int32_t(curr->offset))),
        },
        curr->type
      )
    );
  }

  void visitStore(Store* curr) {
    if (curr->type == unreachable) return;
    Builder builder(*getModule());
    replaceCurrent(
      builder.makeCall(
        getStoreName(curr),
        {
          curr->ptr,
          builder.makeConst(Literal(int32_t(curr->offset))),
          curr->value,
        },
        none
      )
    );
  }
};

struct SafeHeap : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // add imports
    addImports(module);
    // instrument loads and stores
    PassRunner instrumenter(module);
    instrumenter.setIsNested(true);
    instrumenter.add<AccessInstrumenter>();
    instrumenter.run();
    // add helper checking funcs and imports
    addGlobals(module);
  }

  Name dynamicTopPtr, segfault, alignfault;

  void addImports(Module* module) {
    ImportInfo info(*module);
    if (auto* existing = info.getImportedGlobal(ENV, DYNAMICTOP_PTR_IMPORT)) {
      dynamicTopPtr = existing->name;
    } else {
      auto* import = new Global;
      import->name = dynamicTopPtr = DYNAMICTOP_PTR_IMPORT;
      import->module = ENV;
      import->base = DYNAMICTOP_PTR_IMPORT;
      import->type = i32;
      module->addGlobal(import);
    }
    if (auto* existing = info.getImportedFunction(ENV, SEGFAULT_IMPORT)) {
      segfault = existing->name;
    } else {
      auto* import = new Function;
      import->name = segfault = SEGFAULT_IMPORT;
      import->module = ENV;
      import->base = SEGFAULT_IMPORT;
      auto* functionType = ensureFunctionType("v", module);
      import->type = functionType->name;
      FunctionTypeUtils::fillFunction(import, functionType);
      module->addFunction(import);
    }
    if (auto* existing = info.getImportedFunction(ENV, ALIGNFAULT_IMPORT)) {
      alignfault = existing->name;
    } else {
      auto* import = new Function;
      import->name = alignfault = ALIGNFAULT_IMPORT;
      import->module = ENV;
      import->base = ALIGNFAULT_IMPORT;
      auto* functionType = ensureFunctionType("v", module);
      import->type = functionType->name;
      FunctionTypeUtils::fillFunction(import, functionType);
      module->addFunction(import);
    }
  }

  bool isPossibleAtomicOperation(Index align, Index bytes, bool shared, Type type) {
    return align == bytes && shared && isIntegerType(type);
  }

  void addGlobals(Module* module) {
    // load funcs
    Load load;
    for (auto type : { i32, i64, f32, f64 }) {
      load.type = type;
      for (Index bytes : { 1, 2, 4, 8 }) {
        load.bytes = bytes;
        if (bytes > getTypeSize(type)) continue;
        for (auto signed_ : { true, false }) {
          load.signed_ = signed_;
          if (isFloatType(type) && signed_) continue;
          for (Index align : { 1, 2, 4, 8 }) {
            load.align = align;
            if (align > bytes) continue;
            for (auto isAtomic : { true, false }) {
              load.isAtomic = isAtomic;
              if (isAtomic &&
                  !isPossibleAtomicOperation(align, bytes, module->memory.shared, type)) {
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
    for (auto valueType : { i32, i64, f32, f64 }) {
      store.valueType = valueType;
      store.type = none;
      for (Index bytes : { 1, 2, 4, 8 }) {
        store.bytes = bytes;
        if (bytes > getTypeSize(valueType)) continue;
        for (Index align : { 1, 2, 4, 8 }) {
          store.align = align;
          if (align > bytes) continue;
          for (auto isAtomic : { true, false }) {
            store.isAtomic = isAtomic;
            if (isAtomic &&
                !isPossibleAtomicOperation(align, bytes, module->memory.shared, valueType)) {
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
    auto* func = new Function;
    func->name = getLoadName(&style);
    func->params.push_back(i32); // pointer
    func->params.push_back(i32); // offset
    func->vars.push_back(i32); // pointer + offset
    func->result = style.type;
    Builder builder(*module);
    auto* block = builder.makeBlock();
    block->list.push_back(
      builder.makeSetLocal(
        2,
        builder.makeBinary(
          AddInt32,
          builder.makeGetLocal(0, i32),
          builder.makeGetLocal(1, i32)
        )
      )
    );
    // check for reading past valid memory: if pointer + offset + bytes
    block->list.push_back(
      makeBoundsCheck(style.type, builder, 2, style.bytes)
    );
    // check proper alignment
    if (style.align > 1) {
      block->list.push_back(
        makeAlignCheck(style.align, builder, 2)
      );
    }
    // do the load
    auto* load = module->allocator.alloc<Load>();
    *load = style; // basically the same as the template we are given!
    load->ptr = builder.makeGetLocal(2, i32);
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
    auto* func = new Function;
    func->name = getStoreName(&style);
    func->params.push_back(i32); // pointer
    func->params.push_back(i32); // offset
    func->params.push_back(style.valueType); // value
    func->vars.push_back(i32); // pointer + offset
    func->result = none;
    Builder builder(*module);
    auto* block = builder.makeBlock();
    block->list.push_back(
      builder.makeSetLocal(
        3,
        builder.makeBinary(
          AddInt32,
          builder.makeGetLocal(0, i32),
          builder.makeGetLocal(1, i32)
        )
      )
    );
    // check for reading past valid memory: if pointer + offset + bytes
    block->list.push_back(
      makeBoundsCheck(style.valueType, builder, 3, style.bytes)
    );
    // check proper alignment
    if (style.align > 1) {
      block->list.push_back(
        makeAlignCheck(style.align, builder, 3)
      );
    }
    // do the store
    auto* store = module->allocator.alloc<Store>();
    *store = style; // basically the same as the template we are given!
    store->ptr = builder.makeGetLocal(3, i32);
    store->value = builder.makeGetLocal(2, style.valueType);
    block->list.push_back(store);
    block->finalize(none);
    func->body = block;
    module->addFunction(func);
  }

  Expression* makeAlignCheck(Address align, Builder& builder, Index local) {
    return builder.makeIf(
      builder.makeBinary(
        AndInt32,
        builder.makeGetLocal(local, i32),
        builder.makeConst(Literal(int32_t(align - 1)))
      ),
      builder.makeCall(alignfault, {}, none)
    );
  }

  Expression* makeBoundsCheck(Type type, Builder& builder, Index local, Index bytes) {
    return builder.makeIf(
      builder.makeBinary(
        OrInt32,
        builder.makeBinary(
          EqInt32,
          builder.makeGetLocal(local, i32),
          builder.makeConst(Literal(int32_t(0)))
        ),
        builder.makeBinary(
          GtUInt32,
          builder.makeBinary(
            AddInt32,
            builder.makeGetLocal(local, i32),
            builder.makeConst(Literal(int32_t(bytes)))
          ),
          builder.makeLoad(4, false, 0, 4,
            builder.makeGetGlobal(dynamicTopPtr, i32), i32
          )
        )
      ),
      builder.makeCall(segfault, {}, none)
    );
  }
};

Pass *createSafeHeapPass() {
  return new SafeHeap();
}

} // namespace wasm
