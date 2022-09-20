/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include "asmjs/shared-constants.h"
#include "ir/element-utils.h"
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "ir/names.h"
#include "ir/utils.h"
#include "pass.h"
#include "shared-constants.h"
#include "wasm-builder.h"
#include "wasm.h"
#include <utility>

//
// Convert a module to be compatible with JavaScript promise integration (JSPI).
// All exports will be wrapped with a function that will handle storing
// the suspsender that is passed in as the first param from a "promising"
// `WebAssembly.Function`. All imports will also be wrapped, but they will take
// the stored suspender and pass it as the first param to the imported function
// that should be created from a "suspending" `WebAssembly.Function`.
//
namespace wasm {

struct JSPI : public Pass {

  Type externref = Type(HeapType::ext, Nullable);

  void run(PassRunner* runner, Module* module) override {
    Builder builder(*module);
    // Create a global to store the suspender that is passed into exported
    // functions and will then need to be passed out to the imported functions.
    Name suspender = Names::getValidGlobalName(*module, "suspender");
    module->addGlobal(builder.makeGlobal(
      suspender, externref, builder.makeRefNull(externref), Builder::Mutable));

    // Keep track of already wrapped functions since they can be exported
    // multiple times, but only one wrapper is needed.
    std::unordered_map<Name, Name> wrappedExports;

    // Wrap each exported function in a function that stores the suspender
    // and calls the original export.
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function) {
        auto* func = module->getFunction(ex->value);
        Name wrapperName;
        auto iter = wrappedExports.find(func->name);
        if (iter == wrappedExports.end()) {
          wrapperName = makeWrapperForExport(func, module, suspender);
          wrappedExports[func->name] = wrapperName;
        } else {
          wrapperName = iter->second;
        }
        ex->value = wrapperName;
      }
    }

    // Avoid iterator invalidation later.
    std::vector<Function*> originalFunctions;
    for (auto& func : module->functions) {
      originalFunctions.push_back(func.get());
    }
    // Wrap each imported function in a function that gets the global suspender
    // and passes it on to the imported function.
    for (auto* im : originalFunctions) {
      if (im->imported()) {
        makeWrapperForImport(im, module, suspender);
      }
    }
  }

private:
  Name makeWrapperForExport(Function* func, Module* module, Name suspender) {
    Name wrapperName = Names::getValidFunctionName(
      *module, std::string("export$") + func->name.str);

    Builder builder(*module);

    auto* call = module->allocator.alloc<Call>();
    call->target = func->name;
    call->type = func->getResults();

    // Add an externref param as the first argument and copy all the original
    // params to new export.
    std::vector<Type> wrapperParams;
    std::vector<NameType> namedWrapperParams;
    wrapperParams.push_back(externref);
    namedWrapperParams.emplace_back(Names::getValidLocalName(*func, "susp"),
                                    externref);
    Index i = 0;
    for (const auto& param : func->getParams()) {
      call->operands.push_back(
        builder.makeLocalGet(wrapperParams.size(), param));
      wrapperParams.push_back(param);
      namedWrapperParams.emplace_back(func->getLocalNameOrGeneric(i), param);
      i++;
    }
    auto* block = builder.makeBlock();
    block->list.push_back(
      builder.makeGlobalSet(suspender, builder.makeLocalGet(0, externref)));
    block->list.push_back(call);
    Type resultsType = func->getResults();
    if (resultsType == Type::none) {
      // A void return is not currently allowed by v8. Add an i32 return value
      // that is ignored.
      // https://bugs.chromium.org/p/v8/issues/detail?id=13231
      resultsType = Type::i32;
      block->list.push_back(builder.makeConst(0));
    }
    block->finalize();
    auto wrapperFunc =
      Builder::makeFunction(wrapperName,
                            std::move(namedWrapperParams),
                            Signature(Type(wrapperParams), resultsType),
                            {},
                            block);
    return module->addFunction(std::move(wrapperFunc))->name;
  }

  void makeWrapperForImport(Function* im, Module* module, Name suspender) {
    Builder builder(*module);
    auto wrapperIm = make_unique<Function>();
    wrapperIm->name = Names::getValidFunctionName(
      *module, std::string("import$") + im->name.str);
    wrapperIm->module = im->module;
    wrapperIm->base = im->base;
    auto stub = make_unique<Function>();
    stub->name = Name(im->name.str);
    stub->type = im->type;

    auto* call = module->allocator.alloc<Call>();
    call->target = wrapperIm->name;

    // Add an externref as the first argument to the imported function.
    std::vector<Type> params;
    params.push_back(externref);
    call->operands.push_back(builder.makeGlobalGet(suspender, externref));
    Index i = 0;
    for (const auto& param : im->getParams()) {
      call->operands.push_back(builder.makeLocalGet(i, param));
      params.push_back(param);
      ++i;
    }
    auto* block = builder.makeBlock();
    // Store the suspender so it can be restored after the call in case it is
    // modified by another entry into a Wasm export.
    auto supsenderCopyIndex = Builder::addVar(stub.get(), externref);
    // If there's a return value we need to store it so it can be returned
    // after restoring the suspender.
    std::optional<Index> returnIndex;
    if (stub->getResults().isConcrete()) {
      returnIndex = Builder::addVar(stub.get(), stub->getResults());
    }
    block->list.push_back(builder.makeLocalSet(
      supsenderCopyIndex, builder.makeGlobalGet(suspender, externref)));
    if (returnIndex) {
      block->list.push_back(builder.makeLocalSet(*returnIndex, call));
    } else {
      block->list.push_back(call);
    }
    // Restore the suspender.
    block->list.push_back(builder.makeGlobalSet(
      suspender, builder.makeLocalGet(supsenderCopyIndex, externref)));
    if (returnIndex) {
      block->list.push_back(
        builder.makeLocalGet(*returnIndex, stub->getResults()));
    }
    block->finalize();
    call->type = im->getResults();
    stub->body = block;
    wrapperIm->type = Signature(Type(params), call->type);

    module->removeFunction(im->name);
    module->addFunction(std::move(stub));
    module->addFunction(std::move(wrapperIm));
  }
};

Pass* createJSPIPass() { return new JSPI(); }

} // namespace wasm
