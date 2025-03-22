/*
 * Copyright 2025 WebAssembly Community Group participants
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
// Instruments the build with code to intercept all memory.grow operations.
//
//  Before:
//   (memory.grow (const.i32 6))
//
//  After:
//   (call $post_memory_grow
//    (i32.const 1) // ID
//    (memory.grow
//     (call $pre_memory_grow
//      (i32.const 1) // ID
//      (i32.const 6) // number of pages
//     )
//    )
//   )
//

#include "asmjs/shared-constants.h"
#include <pass.h>
#include <wasm-builder.h>

namespace wasm {

static Name pre_memory_grow("pre_memory_grow");
static Name post_memory_grow("post_memory_grow");

struct InstrumentMemoryGrow
  : public WalkerPass<PostWalker<InstrumentMemoryGrow>> {
  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  void visitMemoryGrow(MemoryGrow* curr) {
    id++;
    Builder builder(*getModule());
    auto addressType = getModule()->getMemory(curr->memory)->addressType;
    curr->delta =
      builder.makeCall(pre_memory_grow,
                       {builder.makeConst(int32_t(id)), curr->delta},
                       addressType);
    replaceCurrent(builder.makeCall(
      post_memory_grow, {builder.makeConst(int32_t(id)), curr}, addressType));
  }

  void visitModule(Module* curr) {
    auto addressType =
      curr->memories.empty() ? Type::i32 : curr->memories[0]->addressType;
    addImport(curr, pre_memory_grow, {Type::i32, addressType}, addressType);
    addImport(curr, post_memory_grow, {Type::i32, addressType}, addressType);
  }

private:
  Index id;

  void addImport(Module* curr, Name name, Type params, Type results) {
    auto import = Builder::makeFunction(name, Signature(params, results), {});
    import->module = ENV;
    import->base = name;
    curr->addFunction(std::move(import));
  }
};

Pass* createInstrumentMemoryGrowPass() { return new InstrumentMemoryGrow(); }

} // namespace wasm
