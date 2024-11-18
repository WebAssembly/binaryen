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
// "Closes" the world, in the sense of making it more compatible with the
// --closed-world flag, in a potentially destructive manner. This is mainly
// useful for fuzzing (in that a random module is usually very incomptable with
// closed world, with most types being public and hence unoptimizable, but
// running this pass makes as many as we can fully private).
//
// The fixup we do is to find references sent out/received in, and to
// externalize / internalize them.
//

// TODO whiches?
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "shared-constants.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct EncloseWorld : public Pass {
  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  EncloseWorld() {}

  void run(Module* module) override {
    // Handle exports.
    // TODO: Non-function exports.
    std::vector<std::unique_ptr<Export>> newExports;
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        auto* func = module->getFunction(ex->value);
        // If this opens up types, replace it with an enclosed stub.
        if (opensTypes(func)) {
          auto enclosedName = makeEnclosedStubForExport(func, module);
          ex->value = enclosedName;
        }
      }
    }
    for (auto& ex : newExports) {
      module->addExport(std::move(ex));
    }

    // Avoid iterator invalidation later, as we will be adding functions.
    std::vector<Function*> originalFunctions;
    for (auto& func : module->functions) {
      originalFunctions.push_back(func.get());
    }
    // Handle imports.
    // TODO: Non-function imports.
    for (auto* im : originalFunctions) {
      if (im->imported() && opensTypes(im)) {
        auto funcName = makeEnclosedStubForImport(im, module);
        openImportsToEnclosed[im->name] = funcName;
      }
    }
    if (!openImportsToEnclosed.empty()) {
      // Every call or ref.func of the imports we are enclosing must be fixed
      // up, so that we call the stub.
      struct Fixer : public WalkerPass<PostWalker<Fixer>> {
        bool isFunctionParallel() override { return true; }

        std::unique_ptr<Pass> create() override {
          return std::make_unique<Fixer>(openImportsToEnclosed);
        }

        std::map<Name, Name>& openImportsToEnclosed;

        Fixer(std::map<Name, Name>* openImportsToEnclosed)
          : openImportsToEnclosed(openImportsToEnclosed) {}

        void visitCall(Call* curr) {
          auto iter = openImportsToEnclosed.find(curr->target);
          if (iter == openImportsToEnclosed.end()) {
            return;
          }

          replaceCurrent(
            Builder(*getModule())
              .makeCall(
                iter->second, curr->operands, curr->type, curr->isReturn));
        }

        void visitRefFunc(RefFunc* curr) {
          auto iter = openImportsToEnclosed.find(curr->func);
          if (iter == openImportsToEnclosed.end()) {
            return;
          }

          curr->func = iter->second;
        }
      } fixer(openImportsToEnclosed);
      fixer.run(getPassRunner(), module);
      fixer.runOnModuleCode(getPassRunner(), module);

      // Finally we can remove all the now-unused illegal imports
      for (const auto& pair : openImportsToEnclosed) {
        module->removeFunction(pair.first);
      }
    }
  }

private:
  // map of illegal to legal names for imports
  std::map<Name, Name> openImportsToEnclosed;
  bool exportedHelpers = false;
  Function* getTempRet0 = nullptr;
  Function* setTempRet0 = nullptr;

  template<typename T> bool opensTypes(T* t) {
    for (const auto& param : t->getParams()) {
      if (param == Type::i64) {
        return true;
      }
    }
    return t->getResults() == Type::i64;
  }

  bool isDynCall(Name name) { return name.startsWith("dynCall_"); }

  Function* tempSetter(Module* module) {
    if (!setTempRet0) {
      if (exportedHelpers) {
        auto* ex = module->getExport(SET_TEMP_RET_EXPORT);
        setTempRet0 = module->getFunction(ex->value);
      } else {
        setTempRet0 = getFunctionOrImport(
          module, SET_TEMP_RET_IMPORT, Type::i32, Type::none);
      }
    }
    return setTempRet0;
  }

  Function* tempGetter(Module* module) {
    if (!getTempRet0) {
      if (exportedHelpers) {
        auto* ex = module->getExport(GET_TEMP_RET_EXPORT);
        getTempRet0 = module->getFunction(ex->value);
      } else {
        getTempRet0 = getFunctionOrImport(
          module, GET_TEMP_RET_IMPORT, Type::none, Type::i32);
      }
    }
    return getTempRet0;
  }

  // JS calls the export, so it must call a legal stub that calls the actual
  // wasm function
  Name makeEnclosedStubForExport(Function* func, Module* module) {
    Name legalName(std::string("enclosed$") + func->name.toString());

    // a method may be exported multiple times
    if (module->getFunctionOrNull(legalName)) {
      return legalName;
    }

    Builder builder(*module);
    auto* legal = new Function();
    legal->name = legalName;
    legal->hasExplicitName = true;

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
      auto index = Builder::addVar(legal, Name(), Type::i64);
      auto* block = builder.makeBlock();
      block->list.push_back(builder.makeLocalSet(index, call));
      block->list.push_back(
        builder.makeCall(tempSetter(module)->name,
                         {I64Utilities::getI64High(builder, index)},
                         Type::none));
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
  Name makeEnclosedStubForImport(Function* im, Module* module) {
    Builder builder(*module);
    auto legalIm = std::make_unique<Function>();
    legalIm->name = Name(std::string("legalimport$") + im->name.toString());
    legalIm->module = im->module;
    legalIm->base = im->base;
    legalIm->hasExplicitName = true;
    auto stub = std::make_unique<Function>();
    stub->name = Name(std::string("legalfunc$") + im->name.toString());
    stub->type = im->type;
    stub->hasExplicitName = true;

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
      call->type = Type::i32;
      Expression* get =
        builder.makeCall(tempGetter(module)->name, {}, call->type);
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

struct LegalizeAndPruneJSInterface : public EncloseWorld {
  // Legalize and add pruning on top.
  LegalizeAndPruneJSInterface() : EncloseWorld() {}

  void run(Module* module) override {
    EncloseWorld::run(module);

    prune(module);
  }

  void prune(Module* module) {
    // For each function name, the exported id it is exported with. For
    // example,
    //
    //   (func $foo (export "bar")
    //
    // Would have exportedFunctions["foo"] = "bar";
    std::unordered_map<Name, Name> exportedFunctions;
    for (auto& exp : module->exports) {
      if (exp->kind == ExternalKind::Function) {
        exportedFunctions[exp->value] = exp->name;
      }
    }

    for (auto& func : module->functions) {
      // If the function is neither exported nor imported, no problem.
      auto imported = func->imported();
      auto exported = exportedFunctions.count(func->name);
      if (!imported && !exported) {
        continue;
      }

      // The params are allowed to be multivalue, but not the results. Otherwise
      // look for SIMD.
      auto sig = func->type.getSignature();
      auto illegal = opensTypes(sig.results);
      illegal =
        illegal || std::any_of(sig.params.begin(),
                               sig.params.end(),
                               [&](const Type& t) { return opensTypes(t); });
      if (!illegal) {
        continue;
      }

      // Prune an import by implementing it in a trivial manner.
      if (imported) {
        func->module = func->base = Name();

        Builder builder(*module);
        if (sig.results == Type::none) {
          func->body = builder.makeNop();
        } else {
          func->body =
            builder.makeConstantExpression(Literal::makeZeros(sig.results));
        }
      }

      // Prune an export by just removing it.
      if (exported) {
        module->removeExport(exportedFunctions[func->name]);
      }
    }

    // TODO: globals etc.
  }

  bool opensTypes(Type type) {
    auto features = type.getFeatures();
    return features.hasSIMD() || features.hasMultivalue();
  }
};

} // anonymous namespace

Pass* createEncloseWorldPass() { return new EncloseWorld(); }

Pass* createLegalizeAndPruneJSInterfacePass() {
  return new LegalizeAndPruneJSInterface();
}

} // namespace wasm
