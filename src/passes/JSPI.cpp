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
#include "ir/module-splitting.h"
#include "ir/names.h"
#include "ir/utils.h"
#include "pass.h"
#include "shared-constants.h"
#include "support/file.h"
#include "support/string.h"
#include "wasm-builder.h"
#include "wasm.h"
#include <utility>

//
// Convert a module to be compatible with JavaScript promise integration (JSPI).
// Promising exports will be wrapped with a function that will handle storing
// the suspsender that is passed in as the first param from a "promising"
// `WebAssembly.Function`. Suspending imports will also be wrapped, but they
// will take the stored suspender and pass it as the first param to the imported
// function that should be created from a "suspending" `WebAssembly.Function`.
//
// By default all imports and exports will be wrapped, but this can be
// controlled with the following options:
//
//   --pass-arg=jspi-imports@module1.base1,module2.base2,module3.base3
//
//      Wrap each import in the comma-separated list. Wildcards and a separate
//      files are supported. See `asyncify-imports` for more details.
//
//   --pass-arg=jspi-exports@function_one,function_two,function_three
//
//      Wrap each export in the comma-separated list. Similar to jspi-imports,
//      wildcards and separate files are supported.
//
//   --pass-arg=jspi-split-module
//
//      Enables integration with wasm-split. A JSPI'ed function named
//      `__load_secondary_module` will be injected that is used by wasm-split to
//      load a secondary module.
//

namespace wasm {

static std::string getFullFunctionName(Name module, Name base) {
  return std::string(module.str) + '.' + base.toString();
}

static bool canChangeState(std::string name, String::Split stateChangers) {
  // When no state changers are given default to everything changes state.
  if (stateChangers.empty()) {
    return true;
  }
  for (auto& stateChanger : stateChangers) {
    if (String::wildcardMatch(stateChanger, name)) {
      return true;
    }
  }
  return false;
}

struct JSPI : public Pass {

  Type externref = Type(HeapType::ext, Nullable);

  void run(Module* module) override {
    Builder builder(*module);

    // Find which imports can suspend.
    auto stateChangingImports = String::trim(
      read_possible_response_file(getArgumentOrDefault("jspi-imports", "")));
    String::Split listedImports(stateChangingImports, ",");

    // Find which exports should create a promise.
    auto stateChangingExports = String::trim(
      read_possible_response_file(getArgumentOrDefault("jspi-exports", "")));
    String::Split listedExports(stateChangingExports, ",");

    bool wasmSplit = hasArgument("jspi-split-module");
    if (wasmSplit) {
      // Make an import for the load secondary module function so a JSPI wrapper
      // version will be created.
      auto import =
        Builder::makeFunction(ModuleSplitting::LOAD_SECONDARY_MODULE,
                              Signature(Type::none, Type::none),
                              {});
      import->module = ENV;
      import->base = ModuleSplitting::LOAD_SECONDARY_MODULE;
      module->addFunction(std::move(import));
      listedImports.push_back(
        ENV.toString() + "." +
        ModuleSplitting::LOAD_SECONDARY_MODULE.toString());
    }

    // Create a global to store the suspender that is passed into exported
    // functions and will then need to be passed out to the imported functions.
    Name suspender = Names::getValidGlobalName(*module, "suspender");
    module->addGlobal(builder.makeGlobal(suspender,
                                         externref,
                                         builder.makeRefNull(HeapType::noext),
                                         Builder::Mutable));

    // Keep track of already wrapped functions since they can be exported
    // multiple times, but only one wrapper is needed.
    std::unordered_map<Name, Name> wrappedExports;

    // Wrap each exported function in a function that stores the suspender
    // and calls the original export.
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function &&
          canChangeState(ex->name.toString(), listedExports)) {
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

    // Replace any references to the original exports that are in the elements.
    for (auto& segment : module->elementSegments) {
      if (!segment->type.isFunction()) {
        continue;
      }
      for (Index i = 0; i < segment->data.size(); i++) {
        if (auto* get = segment->data[i]->dynCast<RefFunc>()) {
          auto iter = wrappedExports.find(get->func);
          if (iter == wrappedExports.end()) {
            continue;
          }
          auto* replacementRef = builder.makeRefFunc(
            iter->second, module->getFunction(iter->second)->type);
          segment->data[i] = replacementRef;
        }
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
      if (im->imported() &&
          canChangeState(getFullFunctionName(im->module, im->base),
                         listedImports)) {
        makeWrapperForImport(im, module, suspender, wasmSplit);
      }
    }
  }

private:
  Name makeWrapperForExport(Function* func, Module* module, Name suspender) {
    Name wrapperName = Names::getValidFunctionName(
      *module, std::string("export$") + func->name.toString());

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

  void makeWrapperForImport(Function* im,
                            Module* module,
                            Name suspender,
                            bool wasmSplit) {
    Builder builder(*module);
    auto wrapperIm = std::make_unique<Function>();
    wrapperIm->name = Names::getValidFunctionName(
      *module, std::string("import$") + im->name.toString());
    wrapperIm->module = im->module;
    wrapperIm->base = im->base;
    auto stub = std::make_unique<Function>();
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

    if (wasmSplit && im->name == ModuleSplitting::LOAD_SECONDARY_MODULE) {
      // In non-debug builds the name of the JSPI wrapper function for loading
      // the secondary module will be removed. Create an export of it so that
      // wasm-split can find it.
      module->addExport(
        builder.makeExport(ModuleSplitting::LOAD_SECONDARY_MODULE,
                           ModuleSplitting::LOAD_SECONDARY_MODULE,
                           ExternalKind::Function));
    }
    module->removeFunction(im->name);
    module->addFunction(std::move(stub));
    module->addFunction(std::move(wrapperIm));
  }
};

Pass* createJSPIPass() { return new JSPI(); }

} // namespace wasm
