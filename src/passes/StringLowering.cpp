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

  void run(Module* module) override {
    scanStrings(module);
    replaceStrings(module);
    addGlobals(module);
  }

  // Scan the entire wasm to find the relevant strings and populate strings and
  // stringIndexes.
  void scanStrings() {
    using StringSet = std::unordered_set<Name>;

    struct StringWalker : public PostWalker<StringWalker> {
      StringSet& strings;

      StringWalker(StringSet& strings) : strings(strings) {}

      void visitStringConst(StringConst* curr) { strings.insert(curr->string); }
    };

    ModuleUtils::ParallelFunctionAnalysis<StringSet> analysis(
      *wasm, [&](Function* func, StringSet& strings) {
        if (!func->imported()) {
          StringWalker(strings).walk(func->body);
        }
      });

    // Also walk the global module code (for simplicity, also add it to the
    // function map, using a "function" key of nullptr).
    auto& globalStrings = analysis.map[nullptr];
    StringWalker(globalStrings).walkModuleCode(wasm);

    // Generate the indexes from the combined set of necessary strings,
    // which we sort for determinism.
    StringSet allStrings;
    for (auto& [func, strings] : analysis.map) {
      for (auto& string : strings) {
        allStrings.insert(string);
      }
    }
    for (auto& string : allStrings) {
      strings.push_back(string);
    }
    std::sort(strings.begin(), strings.end());
    for (Index i = 0; i < strings.size(); i++) {
      stringIndexes[strings[i]] = i;
    }
  }

  void replaceStrings(Module* module) {
  }

  void addGlobals(Module* module) {
  }
};

Pass* createStringLoweringPass() { return new StringLowering(); }

} // namespace wasm
