/*
 * Copyright 2024 WebAssembly Community Group participants
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
//  (func $refs (export "refs") (param $x (ref $X)) (result (ref $Y))
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

#include "ir/names.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct EncloseWorld : public Pass {
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
  // Whether a type is an "open" ref, that is, a type that closed-world would
  // consider to keep things public and prevent some amount of closed-world
  // optimizations.
  bool isOpenRef(Type t) {
    // Only externref keeps things closed, and we must ignore things that
    // cannot be converted to/from it (like funcrefs), so we can just check for
    // the top type being any.
    return t.isRef() && t.getHeapType().getTop() == HeapType::any;
  }

  // Whether a function causes types to be open.
  bool opensTypes(Function* func) {
    for (const auto& param : func->getParams()) {
      if (isOpenRef(param)) {
        return true;
      }
    }
    // TODO: Handle tuple results.
    return isOpenRef(func->getResults());
  }

  // Make an enclosed stub function for an exported function, and return its
  // name.
  Name makeStubStubForExport(Function* func, Module* module) {
    // Pick a valid name for the stub we are about to create.
    auto stubName = Names::getValidFunctionName(
      *module, std::string("stub$") + func->name.toString());

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
      if (!isOpenRef(param)) {
        // A normal parameter. Just pass it to the original function.
        auto* get = builder.makeLocalGet(stubParams.size(), param);
        call->operands.push_back(get);
        stubParams.push_back(param);
      } else {
        // A type we must fix up: receive as an externref and then internalize
        // and cast before sending to the original function.
        auto* get = builder.makeLocalGet(stubParams.size(), externref);
        auto* interned = builder.makeRefAs(AnyConvertExtern, get);
        // This cast may be trivial, but we leave it to the optimizer to remove.
        auto* cast = builder.makeRefCast(interned, param);
        call->operands.push_back(cast);
        stubParams.push_back(externref);
      }
    }

    // Generate the stub's type.
    auto oldResults = func->getResults();
    Type resultsType = isOpenRef(oldResults) ? externref : oldResults;
    stub->type = Signature(Type(stubParams), resultsType);

    // Handle the results.
    if (!isOpenRef(oldResults)) {
      // Just use the call.
      stub->body = call;
    } else {
      // Fix up the call's result.
      stub->body = builder.makeRefAs(ExternConvertAny, call);
    }
    return module->addFunction(stub)->name;
  }
};

} // anonymous namespace

Pass* createEncloseWorldPass() { return new EncloseWorld(); }

} // namespace wasm
