/*
 * Copyright 2020 WebAssembly Community Group participants
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
// Create `dynCall` helper functions used by emscripten.  These allow JavaScript
// to call back into WebAssembly given a function pointer (table index). These
// are used primarily to implement the `invoke` functions which in turn are used
// to implment exceptions handling and setjmp/longjmp.  Creates one for each
// signature in the indirect function table.
//

#include "abi/js.h"
#include "asm_v_wasm.h"
#include "ir/import-utils.h"
#include "pass.h"
#include "support/debug.h"
#include "wasm-emscripten.h"

#define DEBUG_TYPE "generate-dyncalls"

namespace wasm {

struct GenerateDynCalls : public WalkerPass<PostWalker<GenerateDynCalls>> {
  GenerateDynCalls(bool onlyI64) : onlyI64(onlyI64) {}

  void visitTable(Table* table) {
    if (table->segments.size() > 0) {
      EmscriptenGlueGenerator generator(*getModule());
      generator.onlyI64DynCalls = onlyI64;
      std::vector<Name> tableSegmentData;
      for (const auto& indirectFunc : table->segments[0].data) {
        generator.generateDynCallThunk(
          getModule()->getFunction(indirectFunc)->sig);
      }
    }
  }

  bool onlyI64;
};

Pass* createGenerateDynCallsPass() { return new GenerateDynCalls(false); }
Pass* createGenerateI64DynCallsPass() { return new GenerateDynCalls(true); }

} // namespace wasm
