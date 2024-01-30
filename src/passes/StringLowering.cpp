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
#include "ir/names.h"
#include "ir/find_all.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct StringLowering : public Pass {
  // All the strings we found in the module, and a reverse mapping.
  std::vector<Name> strings;
  std::unordered_map<Name, Index> stringIndexes;

  // Pointers to all StringConsts, so that we can replace them.
  using StringPtrs = std::vector<Expression**>;
  StringPtrs stringPtrs;

  // Main entry point.
  void run(Module* module) override {
    processModule(module);
    addImports(module);
    replaceStrings(module);
    updateTypes(module);
  }

  // Scan the entire wasm to find the relevant strings to populate our global
  // data structures.
  void processModule(Module* module) {
    struct StringWalker : public PostWalker<StringWalker, UnifiedExpressionVisitor<StringWalker>> {
      StringPtrs& stringPtrs;

      StringWalker(StringPtrs& stringPtrs) : stringPtrs(stringPtrs) {}

      void visitExpression(Expression* curr) {
        if (curr->is<StringConst>()) {
          stringPtrs.push_back(getCurrentPointer());
        }

        // We must replace all string heap types with extern. Do so now in this
        // operation to avoid needing a second pass.
        if (curr->type.isRef() && curr->type.getHeapType() == HeapType::string) {
//          curr->type = Type(HeapType::ext, curr->type.getNullability());
        }
      }
    };

    ModuleUtils::ParallelFunctionAnalysis<StringPtrs> analysis(
      *module, [&](Function* func, StringPtrs& stringPtrs) {
        if (!func->imported()) {
          StringWalker(stringPtrs).walk(func->body);
        }
      });

    // Also walk the global module code (for simplicity, also add it to the
    // function map, using a "function" key of nullptr).
    auto& globalStrings = analysis.map[nullptr];
    StringWalker(globalStrings).walkModuleCode(module);

    // Combine all the strings.
    std::unordered_set<Name> stringSet;
    for (auto& [_, currStringPtrs] : analysis.map) {
      for (auto** stringPtr : currStringPtrs) {
        stringSet.insert((*stringPtr)->cast<StringConst>()->string);
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

  Type nnexternref = Type(HeapType::ext, NonNullable);

  void addImports(Module* module) {
    // TOOD: imports should be in front, so they can be used from globals, or
    // run sort-globals internally..
    Builder builder(*module);
    for (Index i = 0; i < strings.size(); i++) {
      auto name = Names::getValidGlobalName(*module, std::string("string.const_") + std::string(strings[i].str));
      importNames.push_back(name);
      auto global = builder.makeGlobal(name, nnexternref, nullptr, Builder::Immutable);
      global->module = "string.const";
      global->base = std::to_string(i);
      module->addGlobal(std::move(global));
    }
  }

  void replaceStrings(Module* module) {
    Builder builder(*module);
    for (auto** stringPtr : stringPtrs) {
      auto* stringConst = (*stringPtr)->cast<StringConst>();
      auto importName = importNames[stringIndexes[stringConst->string]];
      *stringPtr = builder.makeGlobalGet(importName, nnexternref);
    }
  }

  void updateTypes(Module* module) {
    TypeMapper::TypeUpdates updates;
    updates[HeapType::string] = HeapType::ext;
    TypeMapper(*module, updates).map();
  }
};

Pass* createStringLoweringPass() { return new StringLowering(); }

} // namespace wasm
