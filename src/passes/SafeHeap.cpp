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
#include "wasm-builder.h"

namespace wasm {

static Name getLoadName(Load* curr) {
  std::string ret = "SAFE_HEAP_LOAD_";
  ret += printWasmType(curr->type);
  ret += std::to_string(curr->bytes) + "_";
  ret += std::to_string(curr->signed_) + "_";
  ret += std::to_string(curr->align) + "_";
  ret += std::to_string(curr->isAtomic);
  return ret;
}

static Name getStoreName(Store* curr) {
  std::string ret = "SAFE_HEAP_STORE_";
  ret += printWasmType(curr->type);
  ret += std::to_string(curr->bytes) + "_";
  ret += std::to_string(curr->align) + "_";
  ret += std::to_string(curr->isAtomic);
  return ret;
}

struct AccessInstrumenter : public WalkerPass<PostWalker<AccessInstrumenter>> {
  bool isFunctionParallel() override { return true; }

  AccessInstrumenter* create() override { return new AccessInstrumenter; }

  void visitLoad(Load* curr) {
    if (curr->type == unreachable) return;
    Builder builder(*getModule());
    replaceCurrent(
      builder.makeCallImport(
        getLoadName(curr),
        {
          curr->ptr,
          builder.makeConst(Literal(int32_t(curr->offset))),
        }
      )
    );
  }

  void visitStore(Store* curr) {
    if (curr->type == unreachable) return;
    Builder builder(*getModule());
    replaceCurrent(
      builder.makeCallImport(
        getStoreName(curr),
        {
          curr->ptr,
          curr->value,
          builder.makeConst(Literal(int32_t(curr->offset))),
        }
      )
    );
  }
};

struct SafeHeap : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // add helper checking funcs
    addFuncs(module);
    // instrument loads and stores
    PassRunner runner(module);
    runner.setIsNested(true);
    runner.add<AccessInstrumenter>();
    runner.run();
  }

  void addFuncs(Module* module) {
    Load load;
    for (load.type : { i32, i64, f32, f64 }) {
      for (load.bytes : { 1, 2, 4, 8 }) {
        if (bytes > getWasmTypeSize(load.type)) continue;
        for (load.signed_ : { true, false }) {
          if (isWasmTypeFloat(load.type) && load.signed_) continue; 
          for (load.align : { 1, 2, 4, 8 }) {
            if (align > getWasmTypeSize(load.type)) continue;
            for (load.isAtomic : { true, false }) {
              addLoadFunc(&load, module);
            }
          }
        }
      }
    }
  }

  void addLoadFunc(Load* curr, Module* module) {
    auto* func = new Function;
    func->name = getLoadName(curr);
    func->params.push_back(i32); // pointer
    func->params.push_back(i32); // offset
    func->vars.push_back(i32); // pointer + offset
    func->result = curr->type;
    auto size = getWasmTypeSize(curr->type);
    Builder builder(*module);
    auto* block = builder->makeBlock();
    block->list.push_back(
      builder->makeSetLocal(
        2,
        builder->makeBinary(
          AddInt32,
          builder->makeGetLocal(0, i32),
          builder->makeGetLocal(1, i32)
        )
      )
    );
    // check for reading past valid memory: if pointer + offset + bytes
    block->list.push_back(
      builder->makeIf(
        builder->makeBinary(
          GtUInt32,
          builder->makeBinary(
            AddInt32,
            builder->makeGetLocal(2, i32),
            builder->makeConst(Literal(int32_t(size)))
          ),
          builder->makeLoad(4, false, 0, 4,
            builder->makeGetGlobal(DYNAMICTOP_PTR_IMPORT, i32), i32
          );
        )
        builder->makeCall(SEGFAULT_IMPORT)
      )
    );
    // check proper alignment
    if (curr->align > 1) {
      block->list.push_back(
        builder->makeIf(
          builder->makeBinary(
            AndInt32,
            builder->makeGetLocal(2, i32),
            builder->makeConst(Literal(int32_t(curr->align - 1)))
          )
          builder->makeCall(ALIGNFAULT_IMPORT)
        )
      );
    }
    /*
  if ((dest|0) <= 0) segfault();
  if ((dest + bytes|0) > (HEAP32[DYNAMICTOP_PTR>>2]|0)) segfault();
  if ((bytes|0) == 4) {
    if ((dest&3)) alignfault();
    return HEAP32[dest>>2] | 0;
  } else if ((bytes|0) == 1) {
    if (unsigned) {
      return HEAPU8[dest>>0] | 0;
    } else {
      return HEAP8[dest>>0] | 0;
    }
  }
  if ((dest&1)) alignfault();
  if (unsigned) return HEAPU16[dest>>1] | 0;
  return HEAP16[dest>>1] | 0;
*/
    block->finalize(curr->type);
    func->body = block;
    module->addFunction(func);
  }
};

Pass *createSafeHeapPass() {
  return new SafeHeap();
}

} // namespace wasm
