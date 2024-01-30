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
//

#include <algorithm>

#include "ir/module-utils.h"
#include "ir/names.h"
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
    addGlobals(module);
    replaceStrings(module);
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

  // For each string index, the name of the global that replaces it.
  std::vector<Name> globalNames;

  Type nnstringref = Type(HeapType::string, NonNullable);

  void addGlobals(Module* module) {
    // Note all the new names we create for the sorting later.
    std::unordered_set<Name> newNames;

    Builder builder(*module);
    for (auto& string : strings) {
      auto name = Names::getValidGlobalName(*module, std::string("string.const_") + std::string(string.str));
      globalNames.push_back(name);
      newNames.insert(name);
      auto* stringConst = builder.makeStringConst(string);
      auto global = builder.makeGlobal(name, nnstringref, stringConst, Builder::Immutable);
      module->addGlobal(std::move(global));
    }

    // Sort our new globals to the start, as others may use them.
    std::stable_sort(module->globals.begin(), module->globals.end(), [&](const std::unique_ptr<Global>& a, const std::unique_ptr<Global>& b) {
      return newNames.count(a->name) && !newNames.count(b->name);
    });
  }

  void replaceStrings(Module* module) {
    Builder builder(*module);
    for (auto** stringPtr : stringPtrs) {
      auto* stringConst = (*stringPtr)->cast<StringConst>();
      auto importName = globalNames[stringIndexes[stringConst->string]];
      *stringPtr = builder.makeGlobalGet(importName, nnstringref);
    }
  }
};

Pass* createStringLoweringPass() { return new StringLowering(); }

} // namespace wasm
