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
// Instruments the build with code to intercept all memory reads and writes.
// This can be useful in building tools that analyze memory access behaviour.
//
// The instrumentation is performed by calling an FFI with an ID for each
// memory access site. Load / store IDs share the same index space. The
// instrumentation wraps the evaluation of the address operand, therefore
// it executes before the load / store is executed. Note that Instrumentation
// code must return tha address argument.
//
// Loads: load(id, bytes, offset, address) => address
//
//  Before:
//   (i32.load8_s align=1 offset=2 (i32.const 3))
//
//  After:
//   (i32.load8_s align=1 offset=2
//    (call $load
//     (i32.const n) // ID
//     (i32.const 1) // bytes
//     (i32.const 2) // offset
//     (i32.const 3) // address
//    )
//   )
//
// Stores: store(id, bytes, offset, address) => address
//
//  Before:
//   (i32.store8 align=1 offset=2 (i32.const 3) (i32.const 4))
//
//  After:
//   (i32.store16 align=1 offset=2
//    (call $store
//     (i32.const n) // ID
//     (i32.const 1) // bytes
//     (i32.const 2) // offset
//     (i32.const 3) // address
//    )
//    (i32.const 4)
//   )

#include <wasm.h>
#include <wasm-builder.h>
#include <pass.h>
#include "shared-constants.h"
#include "asmjs/shared-constants.h"
#include "asm_v_wasm.h"
#include "ir/function-type-utils.h"

namespace wasm {

Name load("load");
Name store("store");
// TODO: Add support for atomicRMW/cmpxchg

struct InstrumentMemory : public WalkerPass<PostWalker<InstrumentMemory>> {
  void visitLoad(Load* curr) {
    makeLoadCall(curr);
  }
  void visitStore(Store* curr) {
    makeStoreCall(curr);
  }
  void addImport(Module *curr, Name name, std::string sig) {
    auto import = new Function;
    import->name = name;
    import->module = INSTRUMENT;
    import->base = name;
    auto* functionType = ensureFunctionType(sig, curr);
    import->type = functionType->name;
    FunctionTypeUtils::fillFunction(import, functionType);
    curr->addFunction(import);
  }

  void visitModule(Module *curr) {
    addImport(curr, load,  "iiiii");
    addImport(curr, store,  "iiiii");
  }

private:
  std::atomic<Index> id;
  Expression* makeLoadCall(Load* curr) {
    Builder builder(*getModule());
    curr->ptr = builder.makeCall(load,
      { builder.makeConst(Literal(int32_t(id.fetch_add(1)))),
        builder.makeConst(Literal(int32_t(curr->bytes))),
        builder.makeConst(Literal(int32_t(curr->offset.addr))),
        curr->ptr},
      i32
    );
    return curr;
  }

  Expression* makeStoreCall(Store* curr) {
    Builder builder(*getModule());
    curr->ptr = builder.makeCall(store,
      { builder.makeConst(Literal(int32_t(id.fetch_add(1)))),
        builder.makeConst(Literal(int32_t(curr->bytes))),
        builder.makeConst(Literal(int32_t(curr->offset.addr))),
        curr->ptr },
      i32
    );
    return curr;
  }
};

Pass *createInstrumentMemoryPass() {
  return new InstrumentMemory();
}

} // namespace wasm
