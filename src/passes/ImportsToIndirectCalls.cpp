/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Turn main module imports into direct calls. This will improve the runtime
// performance as VMs typically are slower when making Wasm to JS transitions
// as compared to an indirect call. By making the switch to indirect calls,
// the need for legalization between modules can also be avoided.
//
// This is only necessary for the main module because the side module makes
// direct calls to exported Wasm functions from the main module which is
// already faster.
//

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "pass.h"
#include <fstream>
#include <regex>
#include <sstream>

namespace wasm {

static Name ASSIGN_GOT_ENTIRES("__assign_got_enties");

struct FunctionImportsToIndirectCalls
  : public WalkerPass<PostWalker<FunctionImportsToIndirectCalls>> {
  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new FunctionImportsToIndirectCalls(); }

  FunctionImportsToIndirectCalls() : block(nullptr) {}

  FunctionImportsToIndirectCalls(const std::set<std::string>& libraryFns,
                                 Block* blk)
    : m_libraryFns(libraryFns), block(blk) {}

  static Function*
  ensureFunctionImport(Module* module, Name name, Signature sig) {
    // Then see if its already imported
    ImportInfo info(*module);
    if (Function* f = info.getImportedFunction(ENV, name)) {
      return f;
    }
    // Failing that create a new function import.
    auto import = new Function;
    import->name = name;
    import->module = ENV;
    import->base = name;
    import->sig = sig;
    module->addFunction(import);
    return import;
  }

  void visitCall(Call* curr) {
    auto name = curr->target;

    if (name.isNull()) {
      return;
    }

    auto module = getModule();
    auto* func = module->getFunction(name);

    if (!func || !func->imported()) {
      return;
    }

    name = func->base; // Use the original imported name instead

    if (m_libraryFns.find(name.c_str()) != m_libraryFns.end() ||
        name.hasSubstring("g$") || name.hasSubstring("fp$") ||
        name.hasSubstring("__wasi_"))
      return;

    std::vector<Expression*> args;
    for (int i = 0; i < curr->operands.size(); ++i) {
      args.push_back(curr->operands[i]);
    }
    Builder builder(*module);
    ImportInfo info(*module);

    Name accessor(
      (std::string("fp$") + name.c_str() + std::string("$") + getSig(func))
        .c_str());

    // When a function is already address-taken in the main module, the fp$
    // accessor function would already have been created. Retrieve the
    // global that contains the address and use it for the indirect call.
    // The global will be of the form gimport$xxx if it exists
    Name gpAddr = getGlobalNameFromBase(module, name);

    if (gpAddr.isNull()) {
      // Add the global that holds the address of the function. 
      gpAddr = std::string("gp$") + name.c_str();
      auto* global = module->getGlobalOrNull(gpAddr);

      if (!global) {
        // Ensure that the fp$ accessor is in the module, if not add it in.
        ensureFunctionImport(module, accessor, Signature(Type::none, Type::i32));

        module->addGlobal(builder.makeGlobal(gpAddr,
                             Type::i32,
                             LiteralUtils::makeZero(Type::i32, *module),
                             Builder::Mutable));

        Expression* call = builder.makeCall(accessor, {}, Type::i32);
        GlobalSet* globalSet = builder.makeGlobalSet(gpAddr, call);
        block->list.push_back(globalSet);
      }
    }

    // Replace the call
    Expression* fptr = builder.makeGlobalGet(gpAddr, Type::i32);

    auto indirectCall =
      builder.makeCallIndirect(fptr, args, func->sig, curr->isReturn);

    replaceCurrent(indirectCall);

    return;
  }

  Name getGlobalNameFromBase(Module* module, const Name& name) {
    Name fnAddr;
    for (size_t i = 0, globals = module->globals.size(); i < globals; ++i) {
      auto* curr = module->globals[i].get();
      if (!curr->base.isNull()) {
        if (curr->base.equals(name.c_str())) {
          fnAddr = curr->name;
          break;
        }
      }
    }
    return fnAddr;
  }

private:
  std::set<std::string> m_libraryFns;
  Block* block;
};

struct ImportsToIndirectCalls : public Pass {
  void run(PassRunner* runner, Module* module) override {
    Name name = runner->options.getArgument(
      "js-symbols",
      "ImportsToIndirectCalls usage:  wasm-emscripten-finalize "
      "--pass-arg=js-symbols@FILE_NAME");

    std::set<std::string> jsSymbols = getJSSymbols(name);

    // Create a table if there isn't one
    if (!module->table.exists) {
      Table::Segment segment;

      module->table.initial = 0;
      module->table.max = Memory::kUnlimitedSize;
      module->table.exists = true;
      module->table.segments.push_back(segment);
    }

    auto* assignFunc = module->getFunction(ASSIGN_GOT_ENTIRES);
    auto block = static_cast<Block*>(assignFunc->body);

    if (!block) {
      Fatal() << "__assign_got_enties does not exist in module!!!";
      return;
    }

    FunctionImportsToIndirectCalls(jsSymbols, block).run(runner, module);
  }

  std::set<std::string> getJSSymbols(Name& name) {
    std::ifstream infile(name.c_str(), std::ios::in);

    std::set<std::string> setStrings;

    std::string jsSymbol;
    while (infile >> jsSymbol) {
      jsSymbol.erase(0, 1);
      setStrings.insert(jsSymbol);
    }

    return setStrings;
  }
};

Pass* createImportsToIndirectCallsPass() {
  return new ImportsToIndirectCalls();
}

} // namespace wasm
