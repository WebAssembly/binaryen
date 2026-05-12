/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Prints the boundary - the imports and exports - in a convenient JSON format.
// Only enough information for JavaScript is provided (for the full info, parse
// the wat or wasm).
//
// Usage:
//
//    wasm-opt --print-boundary=OUTFILE
//
// If OUTFILE is not provided, prints to stdout.
//
// Example:
//
//  {
//    'imports': [
//      {
//        'module': 'foo', // foo.bar
//        'base': 'bar',
//        'kind': 'func',
//        'type': {
//          'params': ['i32', '(ref func)'],
//          'results': ['f64']
//        },
//      },
//      [..]
//    ],
//    'exports': [
//      {
//        'name': 'foo',
//        'kind': 'global',
//        'type': 'i32',
//      },
//      [..]
//    ]
//  }
//

#include "ir/module-utils.h"
#include "pass.h"
#include "support/file.h"
#include "support/json.h"
#include "wasm.h"

namespace wasm {

struct PrintBoundary : public Pass {
  bool modifiesBinaryenIR() override { return false; }

  void run(Module* module) override {
    std::string target = getArgumentOrDefault("print-boundary", "");

    // Imports.
    auto imports = json::Value::make();
    imports->setArray();

    ModuleUtils::iterImportable(*module, [&](ExternalKind kind, Importable* import) {
      auto item = json::Value::make();
      item["module"] = json::Value::make(import->module.view());
      item["base"] = json::Value::make(import->base.view());
      item["kind"] = json::Value::make(kind);
      item["type"] = getExternalType(kind, name, *module);
      imports->push_back(item);
    });

    // Exports.
    auto exports = json::Value::make();
    exports->setArray();

    for (auto& exp : module->exports) {
      auto item = json::Value::make();
      item["name"] = json::Value::make(exp->name.view());
      const char* kind = nullptr;
      switch (exp->kind) {
        case ExternalKind::Function:
          kind = "func";
          break;
        case ExternalKind::Table:
          kind = "table";
          break;
        case ExternalKind::Memory:
          kind = "memory";
          break;
        case ExternalKind::Global:
          kind = "global";
          break;
        case ExternalKind::Tag:
          kind = "tag";
          break;
        case ExternalKind::Invalid:
          WASM_UNREACHABLE("invalid ExternalKind");
      }
      item["kind"] = json::Value::make(kind);
      item["type"] = getExternalType(exp->kind, *exp->getInternalName(), *module);
      exports->push_back(item);
    }

    // Emit the final structure
    json::Value root;
    root.setArray(2);
    root[0] = imports;
    root[1] = exports;

    Output output(target, Flags::BinaryOption::Text);
    root.stringify(output.getStream(), true /* pretty */);
  }

  // Emits an array of multivalue types. For a signature, emits params and
  // results.
  json::Value::Ref getTypes(Type type) {
    if (type.isRef()) {
      auto heapType = type.getHeapType();
      if (heapType.isSignature()) {
        auto sig = heapType.getSignature();
        auto ret= json::Value::make();
        ret["params"] = getTypes(sig.params);
        ret["results"] = getTypes(sig.results);
        return ret;
      }
    }

    auto ret = json::Value::make();
    ret->setArray();
    for (auto t : type) {
      ret->push_back(json::Value::make(t.toString()));
    }
    return ret;
  }

  // For an imported or exported thing (something external), and its name,
  // return the type info we report for it.
  json::Value::Ref getExternalType(ExternalKind kind, Name name, Module& wasm) {
    switch (kind) {
      case ExternalKind::Function:
        return getTypes(wasm.getFunction(name)->type);
        break;
      case ExternalKind::Table:
        break;
      case ExternalKind::Memory:
        break;
      case ExternalKind::Global:
        return getTypes(wasm.getGlobal(name)->type);
      case ExternalKind::Tag:
        break;
      case ExternalKind::Invalid:
        WASM_UNREACHABLE("invalid ExternalKind");
    }
    return {};
  }
};

Pass* createPrintBoundaryPass() { return new PrintBoundary(); }

} // namespace wasm
