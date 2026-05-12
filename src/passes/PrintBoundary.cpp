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
//        'params': ['i32', '(ref func)'],
//        'results': ['f64']
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

    for (auto& func : module->functions) {
      if (!func->imported()) {
        continue;
      }

      auto import = json::Value::make();
      import["module"] = json::Value::make(func->module.view());
      import["base"] = json::Value::make(func->base.view());
      import["kind"] = json::Value::make("func");
      import["params"] = getTypes(func->getParams());
      import["results"] = getTypes(func->getResults());

      imports->push_back(import);
    }

    // Exports.
    auto exports = json::Value::make();
    exports->setArray();

    for (auto& exp : module->exports) {
      auto export_ = json::Value::make();
      export_["name"] = json::Value::make(exp->name.view());
      const char* kind;
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
      export_["kind"] = json::Value::make(kind);
      export_["type"] = getTypes(exp->type);

      exports->push_back(export_);
    }

    // Emit the final structure
    json::Value root;
    root.setArray(2);
    root[0] = imports;
    root[1] = exports;

    Output output(target, Flags::BinaryOption::Text);
    root.stringify(output.getStream(), true /* pretty */);
  }

  json::Value::Ref getTypes(Type type) {
    auto ret = json::Value::make();
    ret->setArray();
    for (auto t : type) {
      ret->push_back(json::Value::make(t.toString()));
    }
    return ret;
  }
};

Pass* createPrintBoundaryPass() { return new PrintBoundary(); }

} // namespace wasm
