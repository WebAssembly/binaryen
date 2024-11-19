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
// externalize / internalize them. For example, this export:
//
//  (func $refs ("export "refs") (param $x (ref $X)) (result (ref $Y))
//
// would have the following function exported in its place:
//
//  (func $refs-closed ("export "refs") (param $x externref) (result externref)
//    (extern.convert_any
//      (call $refs
//        (ref.cast (ref $X)
//          (any.convert_extern
//            (local.get $x))))))
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
          auto stubName = makeStubStubForExport(func, module);
          ex->value = stubName;
        }
      }
    }
    for (auto& ex : newExports) {
      module->addExport(std::move(ex));
    }

    // TODO: Handle imports.
  }

private:
  // Whether a type is a declared type, i.e., a reference that is not a basic
  // type. Any such declared type is an issue for closed-world mode.
  bool isDeclaredType(Type t) {
    return t.isRef() && !t.isBasic();
  }

  // Whether a function causes types to be open.
  bool opensTypes(Function* func) {
    for (const auto& param : t->getParams()) {
      if (isDeclaredType(param)) {
        return true;
      }
    }
    // TODO: Handle tuple results.
    return isDeclaredType(t->getResults());
  }

  // A function may be exported more than once (under different external names).
  // After we fix up one export, we add it to this map, by doing
  //
  //  stubExportsMap[originalFuncName] = stubFuncName;
  //
  // That is, we map the original function name to the "enclosed" stub that
  // handles closed-world better, and wraps around the original.
  std::unordered_map<Name, Name> stubExportsMap;

  // Make an enclosed stub function for an exported function, and return its
  // name.
  Name makeStubStubForExport(Function* func, Module* module) {
    auto iter = stubExportsMap.find(func->name);
    if (iter != stubExportsMap.end()) {
      // We've already generated a stub; reuse it.
      return iter->second;
    }

    // Pick a valid name for the stub we are about to create.
    auto stubName = Names::getValidFunctionName(*module, std::string("stub$") + func->name.toString());

    // Create the stub.
    Builder builder(*module);
    auto* stub = new Function();
    stub->name = stubName;
    stub->hasExplicitName = true;

    // The stub's body is just a call to the original function, but with some
    // conversions to/from externref.
    auto* call = module->allocator.alloc<Call>();
    call->target = func->name;
    call->type = func->getResults();

    auto externref = Type(HeapType::ext, Nullable);

    // Handle params.
    std::vector<Type> stubParams;
    for (const auto& param : func->getParams()) {
      auto* get = builder.makeLocalGet(stubParams.size(), param);
      if (!isDeclaredType(param)) {
        // A normal parameter. Just pass it to the original function.
        call->operands.push_back(get);
        stubParams.push_back(param);
      } else {
        // A declared type, that we must internalize before sending to the
        // original function.
        auto* fixed = ;
        call->operands.push_back(builder.makeRefAs(AnyConvertExtern, get));
        stubParams.push_back(externref);
      }
    }

    // Generate the stub's type.
    auto oldResults = func->getResults();
    Type resultsType =
      isDeclaredType(oldResults) ? externref ? oldResults;
    stub->type = Signature(Type(stubParams), resultsType);

    // Handle the results.
    if (!isDeclaredType(oldResults) {
      // Just use the call.
      stub->body = call;
    } else {
      // Fix up the call's result.
      stub->body = builder.makeRefAs(ExternConvertAny, call);
    }
    return module->addFunction(stub)->name;
  }

} // anonymous namespace

Pass* createEncloseWorldPass() { return new EncloseWorld(); }

} // namespace wasm
