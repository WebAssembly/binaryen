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
// Specs:
// https://github.com/WebAssembly/stringref/blob/main/proposals/stringref/Overview.md
// https://github.com/WebAssembly/js-string-builtins/blob/main/proposals/js-string-builtins/Overview.md
//

#include <algorithm>

#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "support/json.h"
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

struct StringLowering : public StringGathering {
  void run(Module* module) override {
    if (!module->features.has(FeatureSet::Strings)) {
      return;
    }

    // First, run the gathering operation so all string.consts are in one place.
    StringGathering::run(module);

    // Lower the string.const globals into imports.
    makeImports(module);

    // Remove all HeapType::string etc. in favor of externref.
    updateTypes(module);

    // Replace string.* etc. operations with imported ones.
    replaceInstructions(module);

    // Disable the feature here after we lowered everything away.
    module->features.disable(FeatureSet::Strings);
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
    auto str = stream.str();
    auto vec = std::vector<char>(str.begin(), str.end());
    module->customSections.emplace_back(
      CustomSection{"string.consts", std::move(vec)});
  }

  void updateTypes(Module* module) {
    TypeMapper::TypeUpdates updates;

    // There is no difference between strings and views with imported strings:
    // they are all just JS strings, so they all turn into externref.
    updates[HeapType::string] = HeapType::ext;
    updates[HeapType::stringview_wtf8] = HeapType::ext;
    updates[HeapType::stringview_wtf16] = HeapType::ext;
    updates[HeapType::stringview_iter] = HeapType::ext;

    // We consider all types that use strings as modifiable, which means we
    // mark them as non-private. That is, we are doing something TypeMapper
    // normally does not, as we are changing the external interface/ABI of the
    // module: we are changing that ABI from using strings to externs.
    auto publicTypes = ModuleUtils::getPublicHeapTypes(*module);
    std::vector<HeapType> stringUsers;
    for (auto t : publicTypes) {
      if (Type(t, Nullable).getFeatures().hasStrings()) {
        stringUsers.push_back(t);
      }
    }

    TypeMapper(*module, updates).map(stringUsers);
  }

  // Imported string functions.
  Name fromCharCodeArrayImport;
  Name intoCharCodeArrayImport;
  Name fromCodePointImport;
  Name equalsImport;
  Name compareImport;
  Name lengthImport;
  Name codePointAtImport;
  Name substringImport;

  // The name of the module to import string functions from.
  Name WasmStringsModule = "wasm:js-string";

  // Common types used in imports.
  Type nullArray16 = Type(Array(Field(Field::i16, Mutable)), Nullable);
  Type nullExt = Type(HeapType::ext, Nullable);
  Type nnExt = Type(HeapType::ext, NonNullable);

  // Creates an imported string function, returning its name (which is equal to
  // the true name of the import, if there is no conflict).
  Name addImport(Module* module, Name trueName, Type params, Type results) {
    auto name = Names::getValidFunctionName(*module, trueName);
    auto sig = Signature(params, results);
    Builder builder(*module);
    auto* func = module->addFunction(builder.makeFunction(name, sig, {}));
    func->module = WasmStringsModule;
    func->base = trueName;
    return name;
  }

  void replaceInstructions(Module* module) {
    // Add all the possible imports up front, to avoid adding them during
    // parallel work. Optimizations can remove unneeded ones later.

    // string.fromCharCodeArray: array, start, end -> ext
    fromCharCodeArrayImport = addImport(
      module, "fromCharCodeArray", {nullArray16, Type::i32, Type::i32}, nnExt);
    // string.fromCodePoint: codepoint -> ext
    fromCodePointImport = addImport(module, "fromCodePoint", Type::i32, nnExt);
    // string.intoCharCodeArray: string, array, start -> num written
    intoCharCodeArrayImport = addImport(module,
                                        "intoCharCodeArray",
                                        {nullExt, nullArray16, Type::i32},
                                        Type::i32);
    // string.equals: string, string -> i32
    equalsImport = addImport(module, "equals", {nullExt, nullExt}, Type::i32);
    // string.compare: string, string -> i32
    compareImport = addImport(module, "compare", {nullExt, nullExt}, Type::i32);
    // string.length: string -> i32
    lengthImport = addImport(module, "length", nullExt, Type::i32);
    // string.codePointAt: string, offset -> i32
    codePointAtImport =
      addImport(module, "codePointAt", {nullExt, Type::i32}, Type::i32);
    // string.substring: string, start, end -> string
    substringImport =
      addImport(module, "substring", {nullExt, Type::i32, Type::i32}, nnExt);

    // Replace the string instructions in parallel.
    struct Replacer : public WalkerPass<PostWalker<Replacer>> {
      bool isFunctionParallel() override { return true; }

      StringLowering& lowering;

      std::unique_ptr<Pass> create() override {
        return std::make_unique<Replacer>(lowering);
      }

      Replacer(StringLowering& lowering) : lowering(lowering) {}

      void visitStringNew(StringNew* curr) {
        Builder builder(*getModule());
        switch (curr->op) {
          case StringNewWTF16Array:
            replaceCurrent(builder.makeCall(lowering.fromCharCodeArrayImport,
                                            {curr->ptr, curr->start, curr->end},
                                            lowering.nnExt));
            return;
          case StringNewFromCodePoint:
            replaceCurrent(builder.makeCall(
              lowering.fromCodePointImport, {curr->ptr}, lowering.nnExt));
            return;
          default:
            WASM_UNREACHABLE("TODO: all of string.new*");
        }
      }

      void visitStringAs(StringAs* curr) {
        // There is no difference between strings and views with imported
        // strings: they are all just JS strings, so no conversion is needed.
        replaceCurrent(curr->ref);
      }

      void visitStringEncode(StringEncode* curr) {
        Builder builder(*getModule());
        switch (curr->op) {
          case StringEncodeWTF16Array:
            replaceCurrent(builder.makeCall(lowering.intoCharCodeArrayImport,
                                            {curr->ref, curr->ptr, curr->start},
                                            Type::i32));
            return;
          default:
            WASM_UNREACHABLE("TODO: all of string.encode*");
        }
      }

      void visitStringEq(StringEq* curr) {
        Builder builder(*getModule());
        switch (curr->op) {
          case StringEqEqual:
            replaceCurrent(builder.makeCall(
              lowering.equalsImport, {curr->left, curr->right}, Type::i32));
            return;
          case StringEqCompare:
            replaceCurrent(builder.makeCall(
              lowering.compareImport, {curr->left, curr->right}, Type::i32));
            return;
          default:
            WASM_UNREACHABLE("invalid string.eq*");
        }
      }

      void visitStringMeasure(StringMeasure* curr) {
        Builder builder(*getModule());
        switch (curr->op) {
          case StringMeasureWTF16View:
            replaceCurrent(
              builder.makeCall(lowering.lengthImport, {curr->ref}, Type::i32));
            return;
          default:
            WASM_UNREACHABLE("invalid string.measure*");
        }
      }

      void visitStringWTF16Get(StringWTF16Get* curr) {
        Builder builder(*getModule());
        replaceCurrent(builder.makeCall(
          lowering.codePointAtImport, {curr->ref, curr->pos}, Type::i32));
      }

      void visitStringSliceWTF(StringSliceWTF* curr) {
        Builder builder(*getModule());
        switch (curr->op) {
          case StringSliceWTF16:
            replaceCurrent(builder.makeCall(lowering.substringImport,
                                            {curr->ref, curr->start, curr->end},
                                            lowering.nnExt));
            return;
          default:
            WASM_UNREACHABLE("TODO: all string.slice*");
        }
      }

      // Additional hacks.

      void visitIf(If* curr) {
        // Before the lowering we could have one arm be a ref.null none and the
        // other a stringref; after the lowering that is invalid, because the
        // string is now extern, which has no shared ancestor with none. Fix
        // that up manually in the simple case of an if arm with a null by
        // correcting the null's type. This is of course wildly insufficient (we
        // need selects and blocks and all other joins) but in practice this is
        // enough for now. TODO extend as needed
        if (curr->type.isRef() && curr->type.getHeapType() == HeapType::ext) {
          auto fixArm = [this](Expression* arm) {
            if (auto* null = arm->dynCast<RefNull>()) {
              null->finalize(HeapType::noext);
            }
          };
          fixArm(curr->ifTrue);
          fixArm(curr->ifFalse);
        }
      }
    };

    Replacer replacer(*this);
    replacer.run(getPassRunner(), module);
    replacer.walkModuleCode(module);
  }
};

Pass* createStringGatheringPass() { return new StringGathering(); }
Pass* createStringLoweringPass() { return new StringLowering(); }

} // namespace wasm
