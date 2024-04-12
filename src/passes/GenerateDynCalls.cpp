/*
 * Copyright 2020 WebAssembly Community Group participants
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
// Create `dynCall` helper functions used by emscripten.  These allow JavaScript
// to call back into WebAssembly given a function pointer (table index). These
// are used primarily to implement the `invoke` functions which in turn are used
// to implment exceptions handling and setjmp/longjmp.  Creates one for each
// signature in the indirect function table.
//

#include "abi/js.h"
#include "asm_v_wasm.h"
#include "ir/element-utils.h"
#include "ir/import-utils.h"
#include "pass.h"
#include "support/debug.h"
#include "support/insert_ordered.h"
#include "wasm-builder.h"

#define DEBUG_TYPE "generate-dyncalls"

namespace wasm {

struct GenerateDynCalls : public WalkerPass<PostWalker<GenerateDynCalls>> {
  GenerateDynCalls(bool onlyI64) : onlyI64(onlyI64) {}

  void doWalkModule(Module* wasm) {
    PostWalker<GenerateDynCalls>::doWalkModule(wasm);
    for (auto& type : invokeTypes) {
      generateDynCallThunk(type);
    }
  }

  void visitTable(Table* table) {
    // Generate dynCalls for functions in the table
    Module* wasm = getModule();
    auto& segments = wasm->elementSegments;

    // Find a single elem segment for the table. We only care about one, since
    // wasm-ld emits only one table with a single segment.
    auto it = std::find_if(segments.begin(),
                           segments.end(),
                           [&](std::unique_ptr<ElementSegment>& segment) {
                             return segment->table == table->name;
                           });
    if (it != segments.end()) {
      std::vector<Name> tableSegmentData;
      ElementUtils::iterElementSegmentFunctionNames(
        it->get(), [&](Name name, Index) {
          generateDynCallThunk(wasm->getFunction(name)->type);
        });
    }
  }

  void visitFunction(Function* func) {
    // Generate dynCalls for invokes
    if (func->imported() && func->module == ENV &&
        func->base.startsWith("invoke_")) {
      Signature sig = func->type.getSignature();
      // The first parameter is a pointer to the original function that's called
      // by the invoke, so skip it
      std::vector<Type> newParams(sig.params.begin() + 1, sig.params.end());
      invokeTypes.insert(Signature(Type(newParams), sig.results));
    }
  }

  void generateDynCallThunk(HeapType funcType);

  bool onlyI64;
  // The set of all invokes' signature types.
  InsertOrderedSet<HeapType> invokeTypes;
};

static bool hasI64(Signature sig) {
  // We only generate dynCall functions for signatures that contain i64. This is
  // because any other function can be called directly from JavaScript using the
  // wasm table.
  for (auto t : sig.results) {
    if (t.getID() == Type::i64) {
      return true;
    }
  }
  for (auto t : sig.params) {
    if (t.getID() == Type::i64) {
      return true;
    }
  }
  return false;
}

static void exportFunction(Module& wasm, Name name, bool must_export) {
  if (!wasm.getFunctionOrNull(name)) {
    assert(!must_export);
    return;
  }
  if (wasm.getExportOrNull(name)) {
    return; // Already exported
  }
  auto exp = new Export;
  exp->name = exp->value = name;
  exp->kind = ExternalKind::Function;
  wasm.addExport(exp);
}

void GenerateDynCalls::generateDynCallThunk(HeapType funcType) {
  Signature sig = funcType.getSignature();

  if (sig.results.isTuple()) {
    // Emscripten output is assumed to be MVP, and not to have multiple return
    // values. In particular, signatures in Emscripten all look like "abcd"
    // where "a" is the single return value, and "bcd" are the (in this case
    // three) parameters.
    Fatal() << "GenerateDynCalls: Cannot operate on multiple return values:"
            << sig.results;
  }

  if (onlyI64 && !hasI64(sig)) {
    return;
  }

  Module* wasm = getModule();
  Builder builder(*wasm);
  Name name = std::string("dynCall_") + getSig(sig.results, sig.params);
  if (wasm->getFunctionOrNull(name) || wasm->getExportOrNull(name)) {
    return; // module already contains this dyncall
  }
  std::vector<NameType> namedParams;
  std::vector<Type> params;
  namedParams.emplace_back("fptr", Type::i32); // function pointer param
  params.push_back(Type::i32);
  int p = 0;
  for (const auto& param : sig.params) {
    namedParams.emplace_back(std::to_string(p++), param);
    params.push_back(param);
  }
  auto f = builder.makeFunction(
    name, std::move(namedParams), Signature(Type(params), sig.results), {});
  f->hasExplicitName = true;
  Expression* fptr = builder.makeLocalGet(0, Type::i32);
  std::vector<Expression*> args;
  Index i = 0;
  for (const auto& param : sig.params) {
    args.push_back(builder.makeLocalGet(++i, param));
  }
  if (wasm->tables.empty()) {
    // Add an imported table in exactly the same manner as the LLVM wasm backend
    // would add one.
    auto* table = wasm->addTable(Builder::makeTable(Name::fromInt(0)));
    table->module = ENV;
    table->base = "__indirect_function_table";
  }
  f->body =
    builder.makeCallIndirect(wasm->tables[0]->name, fptr, args, funcType);

  wasm->addFunction(std::move(f));
  exportFunction(*wasm, name, true);
}

Pass* createGenerateDynCallsPass() { return new GenerateDynCalls(false); }
Pass* createGenerateI64DynCallsPass() { return new GenerateDynCalls(true); }

} // namespace wasm
