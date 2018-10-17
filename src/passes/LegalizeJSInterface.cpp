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
// This pass also legalizes according to asm.js FFI rules, which
// disallow f32s. TODO: an option to not do that, if it matters?
//

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "ir/function-type-utils.h"
#include "ir/literal-utils.h"
#include "ir/utils.h"

namespace wasm {

Name TEMP_RET_0("tempRet0");
Name GET_TEMP_RET_0("getTempRet0");
Name SET_TEMP_RET_0("setTempRet0");

struct LegalizeJSInterface : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // First of all, ensure we have the tempRet global and getter/setter
    // for it.
    // With asm2wasm these will almost certainly already exists since
    // emscripten creates them, but for wasm inputs they always get created
    // here.
    addTempRet0Helpers(module);

    // for each illegal export, we must export a legalized stub instead
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        // if it's an import, ignore it
        auto* func = module->getFunction(ex->value);
        if (isIllegal(func)) {
          auto legalName = makeLegalStub(func, module);
          ex->value = legalName;
        }
      }
    }

    // Avoid iterator invalidation since we are about to add functions
    std::vector<Function*> originalFunctions;
    for (auto& func : module->functions) {
      originalFunctions.push_back(func.get());
    }

    // for each illegal import, we must call a legalized stub instead
    for (auto* func : originalFunctions) {
      if (func->imported() && isIllegal(func)) {
        auto funcName = makeLegalStubForCalledImport(func, module);
        illegalImportsToLegal[func->name] = funcName;
        // we need to use the legalized version in the table, as the import from JS
        // is legal for JS. Our stub makes it look like a native wasm function.
        for (auto& segment : module->table.segments) {
          for (auto& name : segment.data) {
            if (name == func->name) {
              name = funcName;
            }
          }
        }
      }
    }

    if (illegalImportsToLegal.size() > 0) {
      for (auto& pair : illegalImportsToLegal) {
        module->removeFunction(pair.first);
      }

      // fix up imports: call_import of an illegal must be turned to a call of a legal

      struct FixImports : public WalkerPass<PostWalker<FixImports>> {
        bool isFunctionParallel() override { return true; }

        Pass* create() override { return new FixImports(illegalImportsToLegal); }

        std::map<Name, Name>* illegalImportsToLegal;

        FixImports(std::map<Name, Name>* illegalImportsToLegal) : illegalImportsToLegal(illegalImportsToLegal) {}

        void visitCall(Call* curr) {
          auto iter = illegalImportsToLegal->find(curr->target);
          if (iter == illegalImportsToLegal->end()) return;

          if (iter->second == getFunction()->name) return; // inside the stub function itself, is the one safe place to do the call
          replaceCurrent(Builder(*getModule()).makeCall(iter->second, curr->operands, curr->type));
        }
      };

      PassRunner passRunner(module);
      passRunner.setIsNested(true);
      passRunner.add<FixImports>(&illegalImportsToLegal);
      passRunner.run();
    }
  }

private:
  // map of illegal to legal names for imports
  std::map<Name, Name> illegalImportsToLegal;

  bool isIllegal(Function* f) {
    for (auto param : f->params) {
      if (param == i64 || param == f32) return true;
    }
    if (f->result == i64 || f->result == f32) return true;
    return false;
  }

  // JS calls the export, so it must call a legal stub that calls the actual wasm function
  Name makeLegalStub(Function* func, Module* module) {
    Builder builder(*module);
    auto* legal = new Function();
    legal->name = Name(std::string("legalstub$") + func->name.str);

    auto* call = module->allocator.alloc<Call>();
    call->target = func->name;
    call->type = func->result;

    for (auto param : func->params) {
      if (param == i64) {
        call->operands.push_back(I64Utilities::recreateI64(builder, legal->params.size(), legal->params.size() + 1));
        legal->params.push_back(i32);
        legal->params.push_back(i32);
      } else if (param == f32) {
        call->operands.push_back(builder.makeUnary(DemoteFloat64, builder.makeGetLocal(legal->params.size(), f64)));
        legal->params.push_back(f64);
      } else {
        call->operands.push_back(builder.makeGetLocal(legal->params.size(), param));
        legal->params.push_back(param);
      }
    }

    if (func->result == i64) {
      legal->result = i32;
      auto index = builder.addVar(legal, Name(), i64);
      auto* block = builder.makeBlock();
      block->list.push_back(builder.makeSetLocal(index, call));
      block->list.push_back(builder.makeSetGlobal(
        TEMP_RET_0,
        I64Utilities::getI64High(builder, index)
      ));
      block->list.push_back(I64Utilities::getI64Low(builder, index));
      block->finalize();
      legal->body = block;
    } else if (func->result == f32) {
      legal->result = f64;
      legal->body = builder.makeUnary(PromoteFloat32, call);
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

  // wasm calls the import, so it must call a stub that calls the actual legal JS import
  Name makeLegalStubForCalledImport(Function* im, Module* module) {
    Builder builder(*module);
    auto* type = new FunctionType;
    type->name =  Name(std::string("legaltype$") + im->name.str);
    auto* legal = new Function;
    legal->name = Name(std::string("legalimport$") + im->name.str);
    legal->module = im->module;
    legal->base = im->base;
    legal->type = type->name;
    auto* func = new Function;
    func->name = Name(std::string("legalfunc$") + im->name.str);

    auto* call = module->allocator.alloc<Call>();
    call->target = legal->name;

    auto* imFunctionType = module->getFunctionType(im->type);

    for (auto param : imFunctionType->params) {
      if (param == i64) {
        call->operands.push_back(I64Utilities::getI64Low(builder, func->params.size()));
        call->operands.push_back(I64Utilities::getI64High(builder, func->params.size()));
        type->params.push_back(i32);
        type->params.push_back(i32);
      } else if (param == f32) {
        call->operands.push_back(builder.makeUnary(PromoteFloat32, builder.makeGetLocal(func->params.size(), f32)));
        type->params.push_back(f64);
      } else {
        call->operands.push_back(builder.makeGetLocal(func->params.size(), param));
        type->params.push_back(param);
      }
      func->params.push_back(param);
    }

    if (imFunctionType->result == i64) {
      call->type = i32;
      Expression* get;
      get = builder.makeGetGlobal(TEMP_RET_0, i32);
      func->body = I64Utilities::recreateI64(builder, call, get);
      type->result = i32;
    } else if (imFunctionType->result == f32) {
      call->type = f64;
      func->body = builder.makeUnary(DemoteFloat64, call);
      type->result = f64;
    } else {
      call->type = imFunctionType->result;
      func->body = call;
      type->result = imFunctionType->result;
    }
    func->result = imFunctionType->result;
    FunctionTypeUtils::fillFunction(legal, type);

    if (!module->getFunctionOrNull(func->name)) {
      module->addFunction(func);
    }
    if (!module->getFunctionTypeOrNull(type->name)) {
      module->addFunctionType(type);
    }
    if (!module->getFunctionOrNull(legal->name)) {
      module->addFunction(legal);
    }
    return func->name;
  }


  void addTempRet0Helpers(Module* module) {
    // Synthesize implementations of getTempRet0/setTempRet0
    bool getterExists = module->getExportOrNull(GET_TEMP_RET_0) != nullptr;
    bool setterExists = module->getExportOrNull(SET_TEMP_RET_0) != nullptr;

    // If they both exist alrady as exports then do nothing.
    if (getterExists && setterExists) {
      return;
    }

    // If only one exists we can't create the other becasue we don't know
    // how tempRet0 is stored.
    if (getterExists || setterExists) {
      Fatal() << "getTempRet0/setTempRet0 must exist together.";
    }

    module->addGlobal(Builder::makeGlobal(
      TEMP_RET_0,
      i32,
      LiteralUtils::makeZero(i32, *module),
      Builder::Mutable
    ));

    // We should also let JS access the tempRet0 global, which is necessary
    // to (among other things) send/receive 64-bit return values.
    auto exportIt = [&](Function* func) {
      // Remove any existing import
      Function* existing = module->getFunctionOrNull(func->name);
      if (existing) {
        assert(existing->imported());
        module->removeFunction(func->name);
      }

      // Add the function
      module->addFunction(func);

      // Export the function
      auto* export_ = new Export;
      export_->name = func->name;
      export_->value = func->name;
      export_->kind = ExternalKind::Function;
      module->addExport(export_);
    };

    Builder builder(*module);
    auto* getter = new Function();
    getter->name = GET_TEMP_RET_0;
    getter->result = i32;
    getter->body = builder.makeGetGlobal(TEMP_RET_0, i32);
    exportIt(getter);

    auto* setter = new Function();
    setter->name = SET_TEMP_RET_0;
    setter->result = none;
    setter->params.push_back(i32);
    setter->body = builder.makeSetGlobal(
      TEMP_RET_0,
      builder.makeGetLocal(0, i32)
    );
    exportIt(setter);
  }
};

Pass *createLegalizeJSInterfacePass() {
  return new LegalizeJSInterface();
}

} // namespace wasm
