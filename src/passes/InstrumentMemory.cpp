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
// This can be useful in building tools that analyze cache behaviour.
//
// The instrumentation is performed by calling an ffi with an id for each
// memory access site. You need to provide imports on the JS side to read
// and write from memory.
//

#include <wasm.h>
#include <wasm-builder.h>
#include <pass.h>
#include "shared-constants.h"
#include "asmjs/shared-constants.h"
#include "asm_v_wasm.h"

namespace wasm {

Name load("load");
Name store("store");

struct InstrumentMemory : public WalkerPass<PostWalker<InstrumentMemory>> {
  void visitLoad(Load* curr) {
    makeLoadCall(curr);
  }
  void visitStore(Store* curr) {
    makeStoreCall(curr);
  }
  void addImport(Module *curr, Name name, std::string sig) {
    auto import = new Import;
    import->name = name;
    import->module = INS;
    import->base = name;
    import->functionType = ensureFunctionType(sig, curr)->name;
    import->kind = ExternalKind::Function;
    curr->addImport(import);
  }

  void visitModule(Module *curr) {
    // load(id, bytes, offset, address) => address
    addImport(curr, load,  "iiiii");
    // store(id, bytes, offset, address) => address
    addImport(curr, store,  "iiiii");
  }

private:
  std::atomic<Index> id;
  Expression* makeLoadCall(Load* curr) {
    Builder builder(*getModule());
    curr->ptr = builder.makeCallImport(load,
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
    curr->ptr = builder.makeCallImport(store,
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
