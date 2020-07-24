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
// Convert llvm's stack pointer usage from from global.get/global.set into
// cals to external stackSave/stackRestore.
// This is needed to emscripten SIDE_MODULE code where motuble global imports
// are not yet permitted by default.
//

#include "abi/js.h"
#include "ir/import-utils.h"
#include "pass.h"
#include "support/debug.h"
#include "wasm-emscripten.h"

#define DEBUG_TYPE "binary"

namespace wasm {

static Name STACK_SAVE("stackSave");
static Name STACK_RESTORE("stackRestore");

struct ReplaceStackPointer
  : public WalkerPass<PostWalker<ReplaceStackPointer>> {
  void visitGlobalGet(GlobalGet* curr) {
    if (getModule()->getGlobalOrNull(curr->name) == stackPointer) {
      needStackSave = true;
      if (!builder) {
        builder = make_unique<Builder>(*getModule());
      }
      replaceCurrent(builder->makeCall(STACK_SAVE, {}, Type::i32));
    }
  }

  void visitGlobalSet(GlobalSet* curr) {
    if (getModule()->getGlobalOrNull(curr->name) == stackPointer) {
      needStackRestore = true;
      if (!builder) {
        builder = make_unique<Builder>(*getModule());
      }
      replaceCurrent(
        builder->makeCall(STACK_RESTORE, {curr->value}, Type::none));
    }
  }

  void doWalkModule(Module* module) {
    stackPointer = getStackPointerGlobal(*module);
    if (!stackPointer) {
      BYN_DEBUG(std::cerr << "no stack pointer found\n");
      return;
    }
    BYN_DEBUG(std::cerr << "stack pointer found\n");
    super::doWalkModule(module);
    if (needStackSave) {
      ensureFunctionImport(
        module, STACK_SAVE, Signature(Type::none, Type::i32));
    }
    if (needStackRestore) {
      ensureFunctionImport(
        module, STACK_RESTORE, Signature(Type::i32, Type::none));
    }
    // Finally remove the stack pointer global itself. This avoids importing
    // a mutable global.
    module->removeGlobal(stackPointer->name);
  }

  void ensureFunctionImport(Module* module, Name name, Signature sig) {
    ImportInfo info(*module);
    if (info.getImportedFunction(ENV, name)) {
      return;
    }
    auto import = new Function;
    import->name = name;
    import->module = ENV;
    import->base = name;
    import->sig = sig;
    module->addFunction(import);
  }

private:
  std::unique_ptr<Builder> builder;
  Global* stackPointer = nullptr;
  bool needStackSave = false;
  bool needStackRestore = false;
};

Pass* createReplaceStackPointerPass() { return new ReplaceStackPointer; }

} // namespace wasm
