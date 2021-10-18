/*
 * Copyright 2016 WebAssembly Community Group participants
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
// i64 values are not valid in JS, and must be handled in some other
// way. This pass transforms all i64s in params and results in imports
// and exports into pairs of i32, i32 (low, high). If JS on the outside
// calls with that ABI, then everything should then just work, using
// stub methods added in this pass, that thunk i64s into i32, i32 and
// vice versa as necessary.
//
// We can also legalize in a "minimal" way, that is, only JS-specific
// components, that only JS will care about, such as dynCall methods
// (wasm will never call them, as it can share the tables directly). E.g.
// is dynamic linking, where we can avoid legalizing wasm=>wasm calls
// across modules, we still want to legalize dynCalls so JS can call into the
// tables even to a signature that is not legal.
//

#include "asmjs/shared-constants.h"
#include "ir/element-utils.h"
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "shared-constants.h"
#include "wasm-builder.h"
#include "wasm.h"
#include <utility>

namespace wasm {

struct LegalizeJSInterface : public Pass {
  bool full;

  LegalizeJSInterface(bool full) : full(full) {}

  void run(PassRunner* runner, Module* module) override {
    auto exportOriginals =
      !runner->options
         .getArgumentOrDefault("legalize-js-interface-export-originals", "")
         .empty();
    // for each illegal export, we must export a legalized stub instead
    std::vector<std::unique_ptr<Export>> newExports;
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        // if it's an import, ignore it
        auto* func = module->getFunction(ex->value);
        if (isIllegal(func) && shouldBeLegalized(ex.get(), func)) {
          // Provide a legal function for the export.
          auto legalName = makeLegalStub(func, module);
          ex->value = legalName;
          if (exportOriginals) {
            // Also export the original function, before legalization. This is
            // not normally useful for JS, except in cases like dynamic linking
            // where the JS loader code must copy exported wasm functions into
            // the table, and they must not be legalized as other wasm code will
            // do an indirect call to them. However, don't do this for imported
            // functions, as those would be legalized in their actual module
            // anyhow. It also makes no sense to do this for dynCalls, as they
            // are only called from JS.
            if (!func->imported() && !isDynCall(ex->name)) {
              Builder builder(*module);
              Name newName = std::string("orig$") + ex->name.str;
              newExports.push_back(builder.makeExport(
                newName, func->name, ExternalKind::Function));
            }
          }
        }
      }
    }
    for (auto& ex : newExports) {
      module->addExport(std::move(ex));
    }
    // Avoid iterator invalidation later.
    std::vector<Function*> originalFunctions;
    for (auto& func : module->functions) {
      originalFunctions.push_back(func.get());
    }
    // for each illegal import, we must call a legalized stub instead
    for (auto* im : originalFunctions) {
      if (im->imported() && isIllegal(im) && shouldBeLegalized(im)) {
        auto funcName = makeLegalStubForCalledImport(im, module);
        illegalImportsToLegal[im->name] = funcName;
        // we need to use the legalized version in the tables, as the import
        // from JS is legal for JS. Our stub makes it look like a native wasm
        // function.
        ElementUtils::iterAllElementFunctionNames(module, [&](Name& name) {
          if (name == im->name) {
            name = funcName;
          }
        });
      }
    }

    if (!illegalImportsToLegal.empty()) {
      // fix up imports: call_import of an illegal must be turned to a call of a
      // legal. the same must be done with ref.funcs.
      struct Fixer : public WalkerPass<PostWalker<Fixer>> {
        bool isFunctionParallel() override { return true; }

        Pass* create() override { return new Fixer(illegalImportsToLegal); }

        std::map<Name, Name>* illegalImportsToLegal;

        Fixer(std::map<Name, Name>* illegalImportsToLegal)
          : illegalImportsToLegal(illegalImportsToLegal) {}

        void visitCall(Call* curr) {
          auto iter = illegalImportsToLegal->find(curr->target);
          if (iter == illegalImportsToLegal->end()) {
            return;
          }

          replaceCurrent(
            Builder(*getModule())
              .makeCall(
                iter->second, curr->operands, curr->type, curr->isReturn));
        }

        void visitRefFunc(RefFunc* curr) {
          auto iter = illegalImportsToLegal->find(curr->func);
          if (iter == illegalImportsToLegal->end()) {
            return;
          }

          curr->func = iter->second;
        }
      };

      Fixer fixer(&illegalImportsToLegal);
      fixer.run(runner, module);
      fixer.runOnModuleCode(runner, module);

      // Finally we can remove all the now-unused illegal imports
      for (const auto& pair : illegalImportsToLegal) {
        module->removeFunction(pair.first);
      }
    }
  }

private:
  // map of illegal to legal names for imports
  std::map<Name, Name> illegalImportsToLegal;

  template<typename T> bool isIllegal(T* t) {
    for (const auto& param : t->getParams()) {
      if (param == Type::i64) {
        return true;
      }
    }
    return t->getResults() == Type::i64;
  }

  bool isDynCall(Name name) { return name.startsWith("dynCall_"); }

  // Check if an export should be legalized.
  bool shouldBeLegalized(Export* ex, Function* func) {
    if (full) {
      return true;
    }
    // We are doing minimal legalization - just what JS needs.
    return isDynCall(ex->name);
  }

  // Check if an import should be legalized.
  bool shouldBeLegalized(Function* im) {
    if (full) {
      return true;
    }
    // We are doing minimal legalization - just what JS needs.
    return im->module == ENV && im->base.startsWith("invoke_");
  }

  // JS calls the export, so it must call a legal stub that calls the actual
  // wasm function
  Name makeLegalStub(Function* func, Module* module) {
    Name legalName(std::string("legalstub$") + func->name.str);

    // a method may be exported multiple times
    if (module->getFunctionOrNull(legalName)) {
      return legalName;
    }

    Builder builder(*module);
    auto* legal = new Function();
    legal->name = legalName;

    auto* call = module->allocator.alloc<Call>();
    call->target = func->name;
    call->type = func->getResults();

    std::vector<Type> legalParams;
    for (const auto& param : func->getParams()) {
      if (param == Type::i64) {
        call->operands.push_back(I64Utilities::recreateI64(
          builder, legalParams.size(), legalParams.size() + 1));
        legalParams.push_back(Type::i32);
        legalParams.push_back(Type::i32);
      } else {
        call->operands.push_back(
          builder.makeLocalGet(legalParams.size(), param));
        legalParams.push_back(param);
      }
    }
    Type resultsType =
      func->getResults() == Type::i64 ? Type::i32 : func->getResults();
    legal->type = Signature(Type(legalParams), resultsType);
    if (func->getResults() == Type::i64) {
      Function* f =
        getFunctionOrImport(module, SET_TEMP_RET0, Type::i32, Type::none);
      auto index = Builder::addVar(legal, Name(), Type::i64);
      auto* block = builder.makeBlock();
      block->list.push_back(builder.makeLocalSet(index, call));
      block->list.push_back(builder.makeCall(
        f->name, {I64Utilities::getI64High(builder, index)}, Type::none));
      block->list.push_back(I64Utilities::getI64Low(builder, index));
      block->finalize();
      legal->body = block;
    } else {
      legal->body = call;
    }
    return module->addFunction(legal)->name;
  }

  // wasm calls the import, so it must call a stub that calls the actual legal
  // JS import
  Name makeLegalStubForCalledImport(Function* im, Module* module) {
    Builder builder(*module);
    auto legalIm = make_unique<Function>();
    legalIm->name = Name(std::string("legalimport$") + im->name.str);
    legalIm->module = im->module;
    legalIm->base = im->base;
    auto stub = make_unique<Function>();
    stub->name = Name(std::string("legalfunc$") + im->name.str);
    stub->type = im->type;

    auto* call = module->allocator.alloc<Call>();
    call->target = legalIm->name;

    std::vector<Type> params;
    Index i = 0;
    for (const auto& param : im->getParams()) {
      if (param == Type::i64) {
        call->operands.push_back(I64Utilities::getI64Low(builder, i));
        call->operands.push_back(I64Utilities::getI64High(builder, i));
        params.push_back(Type::i32);
        params.push_back(Type::i32);
      } else {
        call->operands.push_back(builder.makeLocalGet(i, param));
        params.push_back(param);
      }
      ++i;
    }

    if (im->getResults() == Type::i64) {
      Function* f =
        getFunctionOrImport(module, GET_TEMP_RET0, Type::none, Type::i32);
      call->type = Type::i32;
      Expression* get = builder.makeCall(f->name, {}, call->type);
      stub->body = I64Utilities::recreateI64(builder, call, get);
    } else {
      call->type = im->getResults();
      stub->body = call;
    }
    legalIm->type = Signature(Type(params), call->type);

    const auto& stubName = stub->name;
    if (!module->getFunctionOrNull(stubName)) {
      module->addFunction(std::move(stub));
    }
    if (!module->getFunctionOrNull(legalIm->name)) {
      module->addFunction(std::move(legalIm));
    }
    return stubName;
  }

  static Function*
  getFunctionOrImport(Module* module, Name name, Type params, Type results) {
    // First look for the function by name
    if (Function* f = module->getFunctionOrNull(name)) {
      return f;
    }
    // Then see if its already imported
    ImportInfo info(*module);
    if (Function* f = info.getImportedFunction(ENV, name)) {
      return f;
    }
    // Failing that create a new function import.
    auto import = Builder::makeFunction(name, Signature(params, results), {});
    import->module = ENV;
    import->base = name;
    auto* ret = import.get();
    module->addFunction(std::move(import));
    return ret;
  }
};

Pass* createLegalizeJSInterfacePass() { return new LegalizeJSInterface(true); }

Pass* createLegalizeJSInterfaceMinimallyPass() {
  return new LegalizeJSInterface(false);
}

} // namespace wasm
