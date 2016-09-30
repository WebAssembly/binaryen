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

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <ast_utils.h>

namespace wasm {

Name TEMP_RET_0("tempRet0");

struct LegalizeJSInterface : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // for each illegal export, we must export a legalized stub instead
    for (auto& ex : module->exports) {
      if (ex->kind == Export::Function) {
        // if it's an import, ignore it
        if (auto* func = module->checkFunction(ex->value)) {
          if (isIllegal(func)) {
            auto legalName = makeLegalStub(func, module);
            ex->value = legalName;
          }
        }
      }
    }
    // for each illegal import, we must call a legalized stub instead
    std::vector<Import*> newImports; // add them at the end, to not invalidate the iter
    for (auto& im : module->imports) {
      if (im->kind == Import::Function && isIllegal(im->functionType)) {
        Name funcName;
        auto* legal = makeLegalStub(im.get(), module, funcName);
        illegalToLegal[im->name] = funcName;
        newImports.push_back(legal);
      }
    }
    if (illegalToLegal.size() > 0) {
      for (auto* im : newImports) {
        module->addImport(im);
      }

      // fix up imports: call_import of an illegal must be turned to a call of a legal

      struct FixImports : public WalkerPass<PostWalker<FixImports, Visitor<FixImports>>> {
        bool isFunctionParallel() override { return true; }

        Pass* create() override { return new FixImports(illegalToLegal); }

        std::map<Name, Name>* illegalToLegal;

        FixImports(std::map<Name, Name>* illegalToLegal) : illegalToLegal(illegalToLegal) {}

        void visitCallImport(CallImport* curr) {
          auto iter = illegalToLegal->find(curr->target);
          if (iter == illegalToLegal->end()) return;

          if (iter->second == getFunction()->name) return; // inside the stub function itself, is the one safe place to do the call
          replaceCurrent(Builder(*getModule()).makeCall(iter->second, curr->operands, curr->type));
        }
      };

      PassRunner passRunner(module);
      passRunner.add<FixImports>(&illegalToLegal);
      passRunner.run();
    }
  }

private:
  // map of illegal to legal names for imports
  std::map<Name, Name> illegalToLegal;

  template<typename T>
  bool isIllegal(T* t) {
    for (auto param : t->params) {
      if (param == i64) return true;
    }
    if (t->result == i64) return true;
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
      if (module->checkGlobal(TEMP_RET_0)) {
        block->list.push_back(builder.makeSetGlobal(
          TEMP_RET_0,
          I64Utilities::getI64High(builder, index)
        ));
      } else {
        block->list.push_back(builder.makeUnreachable()); // no way to emit the high bits :(
      }
      block->list.push_back(I64Utilities::getI64Low(builder, index));
      block->finalize();
      legal->body = block;
    } else {
      legal->result = func->result;
      legal->body = call;
    }

    // a method may be exported multiple times
    if (!module->checkFunction(legal->name)) {
      module->addFunction(legal);
    }
    return legal->name;
  }

  // wasm calls the import, so it must call a stub that calls the actual legal JS import
  Import* makeLegalStub(Import* im, Module* module, Name& funcName) {
    Builder builder(*module);
    auto* type = new FunctionType();
    type->name =  Name(std::string("legaltype$") + im->name.str);
    auto* legal = new Import();
    legal->name = Name(std::string("legalimport$") + im->name.str);
    legal->module = im->module;
    legal->base = im->base;
    legal->kind = Import::Function;
    legal->functionType = type;
    auto* func = new Function();
    func->name = Name(std::string("legalfunc$") + im->name.str);
    funcName = func->name;

    auto* call = module->allocator.alloc<CallImport>();
    call->target = legal->name;

    for (auto param : im->functionType->params) {
      if (param == i64) {
        call->operands.push_back(I64Utilities::getI64Low(builder, func->params.size()));
        call->operands.push_back(I64Utilities::getI64High(builder, func->params.size()));
        type->params.push_back(i32);
        type->params.push_back(i32);
      } else {
        call->operands.push_back(builder.makeGetLocal(func->params.size(), param));
        type->params.push_back(param);
      }
      func->params.push_back(param);
    }

    if (im->functionType->result == i64) {
      call->type = i32;
      Expression* get;
      if (module->checkGlobal(TEMP_RET_0)) {
        get = builder.makeGetGlobal(TEMP_RET_0, i32);
      } else {
        get = builder.makeUnreachable(); // no way to emit the high bits :(
      }
      func->body = I64Utilities::recreateI64(builder, call, get);
      type->result = i32;
    } else {
      call->type = im->functionType->result;
      func->body = call;
      type->result = im->functionType->result;
    }
    func->result = im->functionType->result;

    module->addFunction(func);
    module->addFunctionType(type);
    return legal;
  }
};

Pass *createLegalizeJSInterfacePass() {
  return new LegalizeJSInterface();
}

} // namespace wasm

