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
// Removes function imports, and replaces them with nops. This is useful
// for running a module through the reference interpreter, which
// does not validate imports for a JS environment (by removing
// imports, we can at least get the reference interpreter to
// look at all the rest of the code).
//

#include "wasm.h"
#include "pass.h"
#include "ir/module-utils.h"

namespace wasm {

struct RemoveImports : public WalkerPass<PostWalker<RemoveImports>> {
  void visitCall(Call *curr) {
    auto* func = getModule()->getFunction(curr->target);
    if (!func->imported()) {
      return;
    }
    Type type = getModule()->getFunctionType(func->type)->result;
    if (type == none) {
      replaceCurrent(getModule()->allocator.alloc<Nop>());
    } else {
      Literal nopLiteral;
      nopLiteral.type = type;
      replaceCurrent(getModule()->allocator.alloc<Const>()->set(nopLiteral));
    }
  }

  void visitModule(Module *curr) {
    std::vector<Name> names;
    ModuleUtils::iterImportedFunctions(*curr, [&](Function* func) {
      names.push_back(func->name);
    });
    for (auto& name : names) {
      curr->removeFunction(name);
    }
  }
};

Pass *createRemoveImportsPass() {
  return new RemoveImports();
}

} // namespace wasm
