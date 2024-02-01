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
// Building on that, an extended version of StringGathering will also replace
// those new globals with imported globals of type externref, for use with the
// string imports proposal. String operations will likewise need to be lowered.
// TODO
//

#include <algorithm>

#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct StringGathering : public Pass {
  // All the strings we found in the module.
  std::vector<Name> strings;

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

    // Sort the strings for determinism (alphabetically).
    strings = std::vector<Name>(stringSet.begin(), stringSet.end());
    std::sort(strings.begin(), strings.end());
  }

  // For each string, the name of the global that replaces it.
  std::unordered_map<Name, Name> stringToGlobalName;

  Type nnstringref = Type(HeapType::string, NonNullable);

  // Existing globals already in the form we emit can be reused. That is, if
  // we see
  //
  //  (global $foo (ref string) (string.const ..))
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

    // Find globals to reuse (see comment on stringPtrsToPreserve for context).
    for (auto& global : module->globals) {
      if (global->type == nnstringref && !global->imported()) {
        if (auto* stringConst = global->init->dynCast<StringConst>()) {
          auto& globalName = stringToGlobalName[stringConst->string];
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
      auto& globalName = stringToGlobalName[strings[i]];
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

    // Sort our new globals to the start, as other global initializers may use
    // them (and it would be invalid for us to appear after a use). This sort is
    // a simple way to ensure that we validate, but it may be unoptimal (we
    // leave that for reorder-globals).
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
      auto globalName = stringToGlobalName[stringConst->string];
      *stringPtr = builder.makeGlobalGet(globalName, nnstringref);
    }
  }
};

Pass* createStringGatheringPass() { return new StringGathering(); }

} // namespace wasm
