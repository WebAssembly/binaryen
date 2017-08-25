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
// Removes duplicate functions. That can happen due to C++ templates,
// and also due to types being different at the source level, but
// identical when finally lowered into concrete wasm code.
//

#include "wasm.h"
#include "pass.h"
#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "wasm-builder.h"

namespace wasm {

const Name DYNAMICTOP_PTR_IMPORT("DYNAMICTOP_PTR"),
           SEGFAULT_IMPORT("segfault"),
           ALIGNFAULT_IMPORT("alignfault");

static Name getLoadName(Load* curr) {
  std::string ret = "SAFE_HEAP_LOAD_";
  ret += printWasmType(curr->type);
  ret += "_" + std::to_string(curr->bytes) + "_";
  if (!isWasmTypeFloat(curr->type) && !curr->signed_) {
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
  ret += printWasmType(curr->valueType);
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
    // instrument loads and stores
    PassRunner instrumenter(module);
    instrumenter.setIsNested(true);
    instrumenter.add<AccessInstrumenter>();
    instrumenter.run();
    // add helper checking funcs and imports
    addGlobals(module);
  }

  void addGlobals(Module* module) {
    // load funcs
    Load load;
    for (auto type : { i32, i64, f32, f64 }) {
      load.type = type;
      for (Index bytes : { 1, 2, 4, 8 }) {
        load.bytes = bytes;
        if (bytes > getWasmTypeSize(load.type)) continue;
        for (auto signed_ : { true, false }) {
          load.signed_ = signed_;
          if (isWasmTypeFloat(load.type) && load.signed_) continue; 
          for (Index align : { 1, 2, 4, 8 }) {
            load.align = align;
            if (align > bytes) continue;
            for (auto isAtomic : { true, false }) {
              load.isAtomic = isAtomic;
              if (load.isAtomic && align != bytes) continue;
              if (load.isAtomic && !module->memory.shared) continue;
              addLoadFunc(&load, module);
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
        if (bytes > getWasmTypeSize(store.valueType)) continue;
        for (Index align : { 1, 2, 4, 8 }) {
          store.align = align;
          if (align > bytes) continue;
          for (auto isAtomic : { true, false }) {
            store.isAtomic = isAtomic;
            if (store.isAtomic && align != bytes) continue;
            if (store.isAtomic && !module->memory.shared) continue;
            addStoreFunc(&store, module);
          }
        }
      }
    }
    // imports
    bool hasDynamicTop = false,
         hasSegfault = false,
         hasAlignfault = false;
    for (auto& import : module->imports) {
      if (import->kind == ExternalKind::Global) {
        if (import->module == ENV && import->base == DYNAMICTOP_PTR_IMPORT) {
          hasDynamicTop = true;
        }
      } else if (import->kind == ExternalKind::Function) {
        if (import->module == ENV) {
          if (import->base == SEGFAULT_IMPORT) {
            hasSegfault = true;
          } else if (import->base == ALIGNFAULT_IMPORT) {
            hasAlignfault = true;
          }
        }
      }
    }
    if (!hasDynamicTop) {
      auto* import = new Import;
      import->name = DYNAMICTOP_PTR_IMPORT;
      import->module = ENV;
      import->base = DYNAMICTOP_PTR_IMPORT;
      import->kind = ExternalKind::Global;
      import->globalType = i32;
      module->addImport(import);
    }
    if (!hasSegfault) {
      auto* import = new Import;
      import->name = SEGFAULT_IMPORT;
      import->module = ENV;
      import->base = SEGFAULT_IMPORT;
      import->kind = ExternalKind::Function;
      import->functionType = ensureFunctionType("v", module)->name;
      module->addImport(import);
    }
    if (!hasAlignfault) {
      auto* import = new Import;
      import->name = ALIGNFAULT_IMPORT;
      import->module = ENV;
      import->base = ALIGNFAULT_IMPORT;
      import->kind = ExternalKind::Function;
      import->functionType = ensureFunctionType("v", module)->name;
      module->addImport(import);
    }
  }

  void addLoadFunc(Load* curr, Module* module) {
    auto* func = new Function;
    func->name = getLoadName(curr);
    func->params.push_back(i32); // pointer
    func->params.push_back(i32); // offset
    func->vars.push_back(i32); // pointer + offset
    func->result = curr->type;
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
      makeBoundsCheck(curr->type, builder, 2)
    );
    // check proper alignment
    if (curr->align > 1) {
      block->list.push_back(
        makeAlignCheck(curr->align, builder, 2)
      );
    }
    // do the load
    auto* load = module->allocator.alloc<Load>();
    *load = *curr; // basically the same as the template we are given!
    load->ptr = builder.makeGetLocal(2, i32);
    block->list.push_back(load);
    block->finalize(curr->type);
    func->body = block;
    module->addFunction(func);
  }

  void addStoreFunc(Store* curr, Module* module) {
    auto* func = new Function;
    func->name = getStoreName(curr);
    func->params.push_back(i32); // pointer
    func->params.push_back(i32); // offset
    func->params.push_back(curr->valueType); // value
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
      makeBoundsCheck(curr->valueType, builder, 3)
    );
    // check proper alignment
    if (curr->align > 1) {
      block->list.push_back(
        makeAlignCheck(curr->align, builder, 3)
      );
    }
    // do the store
    auto* store = module->allocator.alloc<Store>();
    *store = *curr; // basically the same as the template we are given!
    store->ptr = builder.makeGetLocal(3, i32);
    store->value = builder.makeGetLocal(2, curr->valueType);
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
      builder.makeCallImport(ALIGNFAULT_IMPORT, {}, none)
    );
  }

  Expression* makeBoundsCheck(WasmType type, Builder& builder, Index local) {
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
            builder.makeConst(Literal(int32_t(getWasmTypeSize(type))))
          ),
          builder.makeLoad(4, false, 0, 4,
            builder.makeGetGlobal(DYNAMICTOP_PTR_IMPORT, i32), i32
          )
        )
      ),
      builder.makeCallImport(SEGFAULT_IMPORT, {}, none)
    );
  }
};

Pass *createSafeHeapPass() {
  return new SafeHeap();
}

} // namespace wasm
