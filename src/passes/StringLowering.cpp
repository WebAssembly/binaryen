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
// Lowers string.const etc. into imports. That is,
//
//  (local.set $x (string.const "foo.bar"))
//
// will turn into
//
//  (import "string.const" "0" (global externref $string.const_foo_bar))
//  ..
//  (local.set $x (global.get $string.const_foo.bar))
//
// as well as a custom section "string.consts" containing a JSON string of an
// array with the string contents:
//
//  ["foo.bar"]
//
// The expectation is that the host environment will read the custom section and
// then provide the imports, resulting in something like this:
//
//  let stringConstsBuffer =
//      WebAssembly.Module.customSections(module, 'string.consts');
//  let stringConstsString =
//      new TextDecoder().decode(new Uint8Array(stringConstsBuffer, 'name'));
//  WebAssembly.instantiate(module, {
//    string.const: JSON.stringify(stringConstsString) // ["foo.bar"]
// });
//
// After running this you may benefit from --simplify-globals and
// --reorder-globals.
//

#include "ir/module-utils.h"
#include "ir/find_all.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct StringLowering : public Pass {
  // All the strings we found in the module, and a reverse mapping.
  std::vector<Name> strings;
  std::unordered_map<Name, Index> stringIndexes;

  // Pointers to all StringConsts, so that we can replace them.
  using StringPtrs = std::vector<StringConst**>;
  StringPtrs stringPtrs;

  // Main entry point.
  void run(Module* module) override {
    scanStrings(module);
    addImports(module);
    replaceStrings(module);
  }

  // Scan the entire wasm to find the relevant strings and populate our global
  // data structures.
  void scanStrings() {
    struct StringWalker : public PostWalker<StringWalker> {
      StringPtr& stringPtrs;

      StringWalker(StringPtr& stringPtrs) : stringPtrs(stringPtrs) {}

      void visitStringConst(StringConst* curr) {
        stringPtrs.push_back(getCurrentPointer());
      }
    };

    ModuleUtils::ParallelFunctionAnalysis<StringPtrs> analysis(
      *wasm, [&](Function* func, StringPtrs& stringPtrs) {
        if (!func->imported()) {
          StringWalker(stringPtrs).walk(func->body);
        }
      });

    // Also walk the global module code (for simplicity, also add it to the
    // function map, using a "function" key of nullptr).
    auto& globalStrings = analysis.map[nullptr];
    StringWalker(globalStrings).walkModuleCode(wasm);

    // Combine all the strings.
    std::unordered_set<Name> stringSet;
    for (auto& [_, stringPtrs] : analysis.map) {
      for (auto** stringPtr : stringPtrs) {
        stringSet.insert((*stringPtr)->name);
        stringPtrs.push_back(stringPtr);
      }
    }
    // Generate the indexes from the combined set of necessary strings, which we
    // sort for determinism.
    for (auto& string : stringSet) {
      strings.push_back(string);
    }
    std::sort(strings.begin(), strings.end());
    for (Index i = 0; i < strings.size(); i++) {
      stringIndexes[strings[i]] = i;
    }
  }

  // For each string index, the name of the import that replaces it.
  std::vector<Name> importNames;

  void addImports(Module* module) {
    // TOOD: imports should be in front, so they can be used from globals, or
    // run sort-globals internally..
    Builder builder(*module);
    for (auto& string : strings) {
      auto name = Names::getValidGlobalName(*module, std::string("string.const_") + string.str);
      importNames.push_back(name);
      module->addGlobal(builder.makeGlobal(name, Type::externref, nullptr, Builder::Immutable));
    }
  }

  void replaceStrings(Module* module) {
    Builder builder(*module);
    for (auto** stringPtr : stringPtrs) {
      auto stringConst = *stringPtr;
      auto importName = importNames[stringIndexes[stringConst->string]];
      *stringPtr = builder.makeGlobalGet(importName, Type::externref);
    }
  }
};

Pass* createStringLoweringPass() { return new StringLowering(); }

} // namespace wasm
