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
// By default, all imports are removed. Imports can be specified as a
// comma-separated list with format module.base (with or without wildcards) or
// as a response file.

#include "ir/element-utils.h"
#include "ir/module-utils.h"
#include "pass.h"
#include "support/file.h"
#include "support/string.h"
#include "wasm.h"

namespace wasm {

struct RemoveImports : public WalkerPass<PostWalker<RemoveImports>> {
  std::set<Name> toRemove;

  void run(Module* module) override {
    toRemove.clear();

    // If no arguments are provided, all function imports are removed.
    std::string param = getArgumentOrDefault(name, "");
    param = String::trim(read_possible_response_file(param));
    bool removeAllImports = param.empty();

    String::Split patterns(param, String::Split::NewLineOr(","));
    patterns = handleBracketingOperators(patterns);

    ModuleUtils::iterImportedFunctions(*module, [&](Function* func) {
      if (removeAllImports) {
        toRemove.insert(func->name);
        return;
      }
      auto full = func->module.toString() + '.' + func->base.toString();
      for (auto& pattern : patterns) {
        if (String::wildcardMatch(pattern, full)) {
          toRemove.insert(func->name);
          break;
        }
      }
    });
    WalkerPass<PostWalker<RemoveImports>>::run(module);
  }

  void visitCall(Call* curr) {
    if (!toRemove.count(curr->target)) {
      return;
    }
    auto* func = getModule()->getFunction(curr->target);
    Type type = func->getResults();
    if (type == Type::none) {
      replaceCurrent(getModule()->allocator.alloc<Nop>());
    } else {
      Literal nopLiteral(type);
      replaceCurrent(getModule()->allocator.alloc<Const>()->set(nopLiteral));
    }
  }

  void visitModule(Module* curr) {
    // Do not remove names referenced in a table
    std::set<Name> indirectNames;
    ElementUtils::iterAllElementFunctionNames(
      curr, [&](Name name) { indirectNames.insert(name); });
    for (auto& name : toRemove) {
      if (indirectNames.find(name) == indirectNames.end()) {
        curr->removeFunction(name);
      }
    }
  }
};

Pass* createRemoveImportsPass() { return new RemoveImports(); }

} // namespace wasm
