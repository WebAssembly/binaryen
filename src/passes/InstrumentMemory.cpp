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

Name empty("empty");

Name i32_load8_s("i32_load8_s");
Name i32_load8_u("i32_load8_u");
Name i32_load16_s("i32_load16_s");
Name i32_load16_u("i32_load16_u");
Name i32_load("i32_load");
Name i64_load8_s("i64_load8_s");
Name i64_load8_u("i64_load8_u");
Name i64_load16_s("i64_load16_s");
Name i64_load16_u("i64_load16_u");
Name i64_load32_s("i64_load32_s");
Name i64_load32_u("i64_load32_u");
Name i64_load("i64_load");
Name f32_load("f32_load");
Name f64_load("f64_load");

Name loads [4][4][2] = {
  {
    { i32_load8_u,  i32_load8_s   },
    { i32_load16_u, i32_load16_s  },
    { i32_load,     i32_load      },
  }, {
    { i64_load8_u,  i64_load8_s   },
    { i64_load16_u, i64_load16_s  },
    { i64_load32_u, i64_load32_s  },
    { i64_load,     i64_load      }
  }, {
    { empty                       },
    { empty                       },
    { f32_load,     f32_load      }
  }, {
    { empty                       },
    { empty                       },
    { empty                       },
    { f64_load,     f64_load      }
  }
};

Name i32_store8("i32_store8");
Name i32_store16("i32_store16");
Name i32_store("i32_store");
Name i64_store8("i64_store8");
Name i64_store16("i64_store16");
Name i64_store32("i64_store32");
Name i64_store("i64_store");
Name f32_store("f32_store");
Name f64_store("f64_store");

Name stores [4][4] = {
  { i32_store8,   i32_store16, i32_store              },
  { i64_store8,   i64_store16, i64_store32, i64_store },
  { empty,        empty,       f32_store              },
  { empty,        empty,       empty,       f64_store }
};

static int32_t bytesToShift(unsigned bytes) {
  switch (bytes) {
    case 1: return 0;
    case 2: return 1;
    case 4: return 2;
    case 8: return 3;
    default: {}
  }
  abort();
  return -1; // avoid warning
}

struct InstrumentMemory : public WalkerPass<PostWalker<InstrumentMemory>> {
  void visitLoad(Load* curr) {
    replaceCurrent(makeLoadCall(curr));
  }
  void visitStore(Store* curr) {
    replaceCurrent(makeStoreCall(curr));
  }
  void addImport(Module *curr, Name name, std::string sig) {
    auto import = new Import;
    import->name = name;
    import->module = ENV;
    import->base = name;
    import->functionType = ensureFunctionType(sig, curr)->name;
    import->kind = ExternalKind::Function;
    curr->addImport(import);
  }
  void visitModule(Module *curr) {
    // Loads
    addImport(curr, i32_load8_s,  "iiiii");
    addImport(curr, i32_load8_u,  "iiiii");
    addImport(curr, i32_load16_s, "iiiii");
    addImport(curr, i32_load16_u, "iiiii");
    addImport(curr, i32_load,     "iiiii");
    addImport(curr, i64_load8_s,  "jiiii");
    addImport(curr, i64_load8_u,  "jiiii");
    addImport(curr, i64_load16_s, "jiiii");
    addImport(curr, i64_load16_u, "jiiii");
    addImport(curr, i64_load32_s, "jiiii");
    addImport(curr, i64_load32_u, "jiiii");
    addImport(curr, i64_load,     "jiiii");
    addImport(curr, f32_load,     "fiiii");
    addImport(curr, f64_load,     "diiii");

    // Stores
    addImport(curr, i32_store8,  "viiiii");
    addImport(curr, i32_store16, "viiiii");
    addImport(curr, i32_store,   "viiiii");
    addImport(curr, i64_store8,  "viiiij");
    addImport(curr, i64_store16, "viiiij");
    addImport(curr, i64_store32, "viiiij");
    addImport(curr, i64_store,   "viiiij");
    addImport(curr, f32_store,   "viiiif");
    addImport(curr, f64_store,   "viiiid");
  }

private:
  Expression* makeLoadCall(Load* curr) {
    static Index loadId = 0;
    Builder builder(*getModule());
    return builder.makeCallImport(
      loads[curr->type - 1][bytesToShift(curr->bytes)][curr->signed_],
      { builder.makeConst(Literal(int32_t(loadId++))),
        builder.makeConst(Literal(int32_t(curr->offset.addr))),
        builder.makeConst(Literal(int32_t(curr->align.addr))),
        curr->ptr },
      curr->type
    );
  }

  Expression* makeStoreCall(Store* curr) {
    static Index storeId = 0;
    Builder builder(*getModule());
    return builder.makeCallImport(
      stores[curr->valueType - 1][bytesToShift(curr->bytes)],
      { builder.makeConst(Literal(int32_t(storeId++))),
        builder.makeConst(Literal(int32_t(curr->offset.addr))),
        builder.makeConst(Literal(int32_t(curr->align.addr))),
        curr->ptr,
        curr->value },
      none
    );
  }

};

Pass *createInstrumentMemoryPass() {
  return new InstrumentMemory();
}

} // namespace wasm
