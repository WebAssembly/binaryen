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
// Utilities for lowering strings into simpler things.
//
// StringGathering collects all string.const operations and stores them in
// globals, avoiding them appearing in code that can run more than once (which
// can have overhead in VMs).
//
// StringLowering does the same, and also replaces those new globals with
// imported globals of type externref, for use with the string imports proposal.
// String operations will likewise need to be lowered. TODO
//

#include <algorithm>

#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "support/json.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct StringGathering : public Pass {
  // All the strings we found in the module, and a reverse mapping.
  std::vector<Name> strings;
  std::unordered_map<Name, Index> stringIndexes;

  // Pointers to all StringConsts, so that we can replace them.
  using StringPtrs = std::vector<Expression**>;
  StringPtrs stringPtrs;

  // Main entry point.
  void run(Module* module) override {
    processModule(module);
    addGlobals(module);
    replaceStrings(module);
  }

  // Scan the entire wasm to find the relevant strings to populate our global
  // data structures.
  void processModule(Module* module) {
    struct StringWalker : public PostWalker<StringWalker> {
      StringPtrs& stringPtrs;

      StringWalker(StringPtrs& stringPtrs) : stringPtrs(stringPtrs) {}

      void visitStringConst(StringConst* curr) {
        stringPtrs.push_back(getCurrentPointer());
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
    // sort for determinism (alphabetically).
    for (auto& string : stringSet) {
      strings.push_back(string);
    }
    std::sort(strings.begin(), strings.end());
    for (Index i = 0; i < strings.size(); i++) {
      stringIndexes[strings[i]] = i;
    }
  }

  // For each string index, the name of the global that replaces it.
  std::vector<Name> globalNames;

  Type nnstringref = Type(HeapType::string, NonNullable);

  // Existing globals already in the form we emit can be reused. That is, if
  // we see
  //
  //  (global $foo (ref null string) (string.const ..))
  //
  // then we can just use that as the global for that string. This avoids
  // repeated executions of the pass adding more and more globals.
  //
  // Note that we don't note these in newNames: They are already in the right
  // sorted position, before any uses, as we use the first of them for each
  // string. Only actually new names need sorting.
  //
  // Any time we reuse a global, we must not modify its body (or else we'd
  // replace the global that all others read from); we note them here and
  // avoid them in replaceStrings later to avoid such trampling.
  std::unordered_set<Expression**> stringPtrsToPreserve;

  void addGlobals(Module* module) {
    // Note all the new names we create for the sorting later.
    std::unordered_set<Name> newNames;

    // Each string will get a global.
    globalNames.resize(strings.size());

    // Find globals to reuse (see comment on stringPtrsToPreserve for context).
    for (auto& global : module->globals) {
      if (global->type == nnstringref && !global->imported()) {
        if (auto* stringConst = global->init->dynCast<StringConst>()) {
          auto stringIndex = stringIndexes[stringConst->string];
          auto& globalName = globalNames[stringIndex];
          if (!globalName.is()) {
            // This is the first global for this string, use it.
            globalName = global->name;
            stringPtrsToPreserve.insert(&global->init);
          }
        }
      }
    }

    Builder builder(*module);
    for (Index i = 0; i < strings.size(); i++) {
      auto& globalName = globalNames[i];
      if (globalName.is()) {
        // We are reusing a global for this one.
        continue;
      }

      auto& string = strings[i];
      auto name = Names::getValidGlobalName(
        *module, std::string("string.const_") + std::string(string.str));
      globalName = name;
      newNames.insert(name);
      auto* stringConst = builder.makeStringConst(string);
      auto global =
        builder.makeGlobal(name, nnstringref, stringConst, Builder::Immutable);
      module->addGlobal(std::move(global));
    }

    // Sort our new globals to the start, as others may use them.
    std::stable_sort(
      module->globals.begin(),
      module->globals.end(),
      [&](const std::unique_ptr<Global>& a, const std::unique_ptr<Global>& b) {
        return newNames.count(a->name) && !newNames.count(b->name);
      });
  }

  void replaceStrings(Module* module) {
    Builder builder(*module);
    for (auto** stringPtr : stringPtrs) {
      if (stringPtrsToPreserve.count(stringPtr)) {
        continue;
      }
      auto* stringConst = (*stringPtr)->cast<StringConst>();
      auto importName = globalNames[stringIndexes[stringConst->string]];
      *stringPtr = builder.makeGlobalGet(importName, nnstringref);
    }
  }
};

struct StringLowering : public StringGathering {
  void run(Module* module) override {
    if (!module->features.has(FeatureSet::Strings)) {
      return;
    }

    // First, run the gathering operation so all string.consts are in one place.
    StringGathering::run(module);

    // Lower the string.const globals into imports.
    makeImports(module);

    // TODO: disable the feature here after we lower everything away.
    // module->features.disable(FeatureSet::Strings);
  }

  void makeImports(Module* module) {
    Index importIndex = 0;
    json::Value stringArray;
    stringArray.setArray();
    std::vector<Name> importedStrings;
    for (auto& global : module->globals) {
      if (global->init) {
        if (auto* c = global->init->dynCast<StringConst>()) {
          global->module = "string.const";
          global->base = std::to_string(importIndex);
          importIndex++;
          global->init = nullptr;

          auto str = json::Value::make(std::string(c->string.str).c_str());
          stringArray.push_back(str);
        }
      }
    }

    // Add a custom section with the JSON.
    std::stringstream stream;
    stringArray.stringify(stream);
    stringArray.stringify(std::cerr);
    auto str = stream.str();
    std::vector<char> vec(str.begin(), str.end());
    module->customSections.emplace_back(
      CustomSection{"string.consts", std::move(vec)});
  }
};

Pass* createStringGatheringPass() { return new StringGathering(); }
Pass* createStringLoweringPass() { return new StringLowering(); }

} // namespace wasm
