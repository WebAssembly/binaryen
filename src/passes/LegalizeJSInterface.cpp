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
// (wasm will never call them, as it can share the table directly). E.g.
// is dynamic linking, where we can avoid legalizing wasm=>wasm calls
// across modules, we still want to legalize dynCalls so JS can call into the
// table even to a signature that is not legal.
//

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ir/function-type-utils.h"
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
    // for each illegal export, we must export a legalized stub instead
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        // if it's an import, ignore it
        auto* func = module->getFunction(ex->value);
        if (isIllegal(func) && shouldBeLegalized(ex.get(), func)) {
          auto legalName = makeLegalStub(func, module);
          ex->value = legalName;
        }
      }
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
        // we need to use the legalized version in the table, as the import from
        // JS is legal for JS. Our stub makes it look like a native wasm
        // function.
        for (auto& segment : module->table.segments) {
          for (auto& name : segment.data) {
            if (name == im->name) {
              name = funcName;
            }
          }
        }
      }
    }
    if (!illegalImportsToLegal.empty()) {
      for (auto& pair : illegalImportsToLegal) {
        module->removeFunction(pair.first);
      }

      // fix up imports: call_import of an illegal must be turned to a call of a
      // legal

      struct FixImports : public WalkerPass<PostWalker<FixImports>> {
        bool isFunctionParallel() override { return true; }

        Pass* create() override {
          return new FixImports(illegalImportsToLegal);
        }

        std::map<Name, Name>* illegalImportsToLegal;

        FixImports(std::map<Name, Name>* illegalImportsToLegal)
          : illegalImportsToLegal(illegalImportsToLegal) {}

        void visitCall(Call* curr) {
          auto iter = illegalImportsToLegal->find(curr->target);
          if (iter == illegalImportsToLegal->end()) {
            return;
          }

          if (iter->second == getFunction()->name) {
            // inside the stub function itself, is the one safe place to do the
            // call
            return;
          }
          replaceCurrent(Builder(*getModule())
                           .makeCall(iter->second, curr->operands, curr->type));
        }
      };

      FixImports(&illegalImportsToLegal).run(runner, module);
    }
  }

private:
  // map of illegal to legal names for imports
  std::map<Name, Name> illegalImportsToLegal;

  template<typename T> bool isIllegal(T* t) {
    for (auto param : t->params) {
      if (param == i64) {
        return true;
      }
    }
    return t->result == i64;
  }

  // Check if an export should be legalized.
  bool shouldBeLegalized(Export* ex, Function* func) {
    if (full) {
      return true;
    }
    // We are doing minimal legalization - just what JS needs.
    return ex->name.startsWith("dynCall_");
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
    Builder builder(*module);
    auto* legal = new Function();
    legal->name = Name(std::string("legalstub$") + func->name.str);

    auto* call = module->allocator.alloc<Call>();
    call->target = func->name;
    call->type = func->result;

    for (auto param : func->params) {
      if (param == i64) {
        call->operands.push_back(I64Utilities::recreateI64(
          builder, legal->params.size(), legal->params.size() + 1));
        legal->params.push_back(i32);
        legal->params.push_back(i32);
      } else {
        call->operands.push_back(
          builder.makeLocalGet(legal->params.size(), param));
        legal->params.push_back(param);
      }
    }

    if (func->result == i64) {
      Function* f = getFunctionOrImport(module, SET_TEMP_RET0, "vi");
      legal->result = i32;
      auto index = Builder::addVar(legal, Name(), i64);
      auto* block = builder.makeBlock();
      block->list.push_back(builder.makeLocalSet(index, call));
      block->list.push_back(builder.makeCall(
        f->name, {I64Utilities::getI64High(builder, index)}, none));
      block->list.push_back(I64Utilities::getI64Low(builder, index));
      block->finalize();
      legal->body = block;
    } else {
      legal->result = func->result;
      legal->body = call;
    }

    // a method may be exported multiple times
    if (!module->getFunctionOrNull(legal->name)) {
      module->addFunction(legal);
    }
    return legal->name;
  }

  // wasm calls the import, so it must call a stub that calls the actual legal
  // JS import
  Name makeLegalStubForCalledImport(Function* im, Module* module) {
    Builder builder(*module);
    auto type = make_unique<FunctionType>();
    type->name = Name(std::string("legaltype$") + im->name.str);
    auto legal = make_unique<Function>();
    legal->name = Name(std::string("legalimport$") + im->name.str);
    legal->module = im->module;
    legal->base = im->base;
    legal->type = type->name;
    auto func = make_unique<Function>();
    func->name = Name(std::string("legalfunc$") + im->name.str);

    auto* call = module->allocator.alloc<Call>();
    call->target = legal->name;

    auto* imFunctionType = ensureFunctionType(getSig(im), module);

    for (auto param : imFunctionType->params) {
      if (param == i64) {
        call->operands.push_back(
          I64Utilities::getI64Low(builder, func->params.size()));
        call->operands.push_back(
          I64Utilities::getI64High(builder, func->params.size()));
        type->params.push_back(i32);
        type->params.push_back(i32);
      } else {
        call->operands.push_back(
          builder.makeLocalGet(func->params.size(), param));
        type->params.push_back(param);
      }
      func->params.push_back(param);
    }

    if (imFunctionType->result == i64) {
      Function* f = getFunctionOrImport(module, GET_TEMP_RET0, "i");
      call->type = i32;
      Expression* get = builder.makeCall(f->name, {}, call->type);
      func->body = I64Utilities::recreateI64(builder, call, get);
      type->result = i32;
    } else {
      call->type = imFunctionType->result;
      func->body = call;
      type->result = imFunctionType->result;
    }
    func->result = imFunctionType->result;
    FunctionTypeUtils::fillFunction(legal.get(), type.get());

    const auto& funcName = func->name;
    if (!module->getFunctionOrNull(funcName)) {
      module->addFunction(std::move(func));
    }
    if (!module->getFunctionTypeOrNull(type->name)) {
      module->addFunctionType(std::move(type));
    }
    if (!module->getFunctionOrNull(legal->name)) {
      module->addFunction(std::move(legal));
    }
    return funcName;
  }

  static Function*
  getFunctionOrImport(Module* module, Name name, std::string sig) {
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
    auto import = new Function;
    import->name = name;
    import->module = ENV;
    import->base = name;
    auto* functionType = ensureFunctionType(std::move(sig), module);
    import->type = functionType->name;
    FunctionTypeUtils::fillFunction(import, functionType);
    module->addFunction(import);
    return import;
  }
};

Pass* createLegalizeJSInterfacePass() { return new LegalizeJSInterface(true); }

Pass* createLegalizeJSInterfaceMinimallyPass() {
  return new LegalizeJSInterface(false);
}

} // namespace wasm
