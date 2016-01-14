/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Removeds imports, and replaces them with nops. This is useful
// for running a module through the reference interpreter, which
// does not validate imports for a JS environment (by removing
// imports, we can at least get the reference interpreter to
// look at all the rest of the code).
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct RemoveImports : public WalkerPass<WasmWalker> {
  MixedArena* allocator;
  std::map<Name, Import*> importsMap;

  void prepare(PassRunner* runner, Module *module) override {
    allocator = runner->allocator;
    importsMap = module->importsMap;
  }

  void visitCallImport(CallImport *curr) override {
    WasmType type = importsMap[curr->target]->type->result;
    if (type == none) {
      replaceCurrent(allocator->alloc<Nop>());
    } else {
      Literal nopLiteral;
      nopLiteral.type = type;
      replaceCurrent(allocator->alloc<Const>()->set(nopLiteral));
    }
  }

  void visitModule(Module *curr) override {
    curr->importsMap.clear();
    curr->imports.clear();
  }
};

static RegisterPass<RemoveImports> registerPass("remove-imports", "removes imports and replaces them with nops");

} // namespace wasm
