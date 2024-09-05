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
#include "ir/subtype-exprs.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/string.h"
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
      if (global->type == nnstringref && !global->imported() &&
          !global->mutable_) {
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
      // Re-encode from WTF-16 to WTF-8 to make the name easier to read.
      std::stringstream wtf8;
      [[maybe_unused]] bool valid =
        String::convertWTF16ToWTF8(wtf8, string.str);
      assert(valid);
      // TODO: Use wtf8.view() once we have C++20.
      auto name = Names::getValidGlobalName(
        *module, std::string("string.const_") + std::string(wtf8.str()));
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
  // If true, then encode well-formed strings as (import "'" "string...")
  // instead of emitting them into the JSON custom section.
  bool useMagicImports;

  // Whether to throw a fatal error on non-UTF8 strings that would not be able
  // to use the "magic import" mechanism. Only usable in conjunction with magic
  // imports.
  bool assertUTF8;

  StringLowering(bool useMagicImports = false, bool assertUTF8 = false)
    : useMagicImports(useMagicImports), assertUTF8(assertUTF8) {
    // If we are asserting valid UTF-8, we must be using magic imports.
    assert(!assertUTF8 || useMagicImports);
  }

  void run(Module* module) override {
    if (!module->features.has(FeatureSet::Strings)) {
      return;
    }

    // First, run the gathering operation so all string.consts are in one place.
    StringGathering::run(module);

    // Remove all HeapType::string etc. in favor of externref.
    updateTypes(module);

    // Lower the string.const globals into imports.
    makeImports(module);

    // Replace string.* etc. operations with imported ones.
    replaceInstructions(module);

    // Replace ref.null types as needed.
    replaceNulls(module);

    // ReFinalize to apply all the above changes.
    ReFinalize().run(getPassRunner(), module);

    // Disable the feature here after we lowered everything away.
    module->features.disable(FeatureSet::Strings);
  }

  void makeImports(Module* module) {
    Index jsonImportIndex = 0;
    std::stringstream json;
    bool first = true;
    for (auto& global : module->globals) {
      if (global->init) {
        if (auto* c = global->init->dynCast<StringConst>()) {
          std::stringstream utf8;
          if (useMagicImports &&
              String::convertUTF16ToUTF8(utf8, c->string.str)) {
            global->module = "'";
            global->base = Name(utf8.str());
          } else {
            if (assertUTF8) {
              std::stringstream escaped;
              String::printEscaped(escaped, utf8.str());
              Fatal() << "Cannot lower non-UTF-16 string " << escaped.str()
                      << '\n';
            }
            global->module = "string.const";
            global->base = std::to_string(jsonImportIndex);
            if (first) {
              first = false;
            } else {
              json << ',';
            }
            String::printEscapedJSON(json, c->string.str);
            jsonImportIndex++;
          }
          global->init = nullptr;
        }
      }
    }

    auto jsonString = json.str();
    if (!jsonString.empty()) {
      // If we are asserting UTF8, then we shouldn't be generating any JSON.
      assert(!assertUTF8);
      // Add a custom section with the JSON.
      auto str = '[' + jsonString + ']';
      auto vec = std::vector<char>(str.begin(), str.end());
      module->customSections.emplace_back(
        CustomSection{"string.consts", std::move(vec)});
    }
  }

  // Common types used in imports.
  Type nullArray16 = Type(Array(Field(Field::i16, Mutable)), Nullable);
  Type nullExt = Type(HeapType::ext, Nullable);
  Type nnExt = Type(HeapType::ext, NonNullable);

  void updateTypes(Module* module) {
    // TypeMapper will not handle public types, but we do want to modify them as
    // well: we are modifying the public ABI here. We can't simply tell
    // TypeMapper to consider them private, as then they'd end up in the new big
    // rec group with the private types (and as they are public, that would make
    // the entire rec group public, and all types in the module with it).
    // Instead, manually handle singleton-rec groups of function types. This
    // keeps them at size 1, as expected, and handles the cases of function
    // imports and exports. If we need more (non-function types, non-singleton
    // rec groups, etc.) then more work will be necessary TODO
    //
    // Note that we do this before TypeMapper, which allows it to then fix up
    // things like the types of parameters (which depend on the type of the
    // function, which must be modified either in TypeMapper - but as just
    // explained we cannot do that - or before it, which is what we do here).
    for (auto& func : module->functions) {
      if (func->type.getRecGroup().size() != 1 ||
          !func->type.getFeatures().hasStrings()) {
        continue;
      }

      // Fix up the stringrefs in this type that uses strings and is in a
      // singleton rec group.
      std::vector<Type> params, results;
      auto fix = [](Type t) {
        if (t.isRef() && t.getHeapType().isMaybeShared(HeapType::string)) {
          auto share = t.getHeapType().getShared();
          t = Type(HeapTypes::ext.getBasic(share), t.getNullability());
        }
        return t;
      };
      for (auto param : func->type.getSignature().params) {
        params.push_back(fix(param));
      }
      for (auto result : func->type.getSignature().results) {
        results.push_back(fix(result));
      }
      func->type = Signature(params, results);
    }

    TypeMapper::TypeUpdates updates;

    // Strings turn into externref.
    updates[HeapType::string] = HeapType::ext;

    // The module may have its own array16 type inside a big rec group, but
    // imported strings expects that type in its own rec group as part of the
    // ABI. Fix that up here. (This is valid to do as this type has no sub- or
    // super-types anyhow; it is "plain old data" for communicating with the
    // outside.)
    auto allTypes = ModuleUtils::collectHeapTypes(*module);
    auto array16 = nullArray16.getHeapType();
    auto array16Element = array16.getArray().element;
    for (auto type : allTypes) {
      // Match an array type with no super and that is closed.
      if (type.isArray() && !type.getDeclaredSuperType() && !type.isOpen() &&
          type.getArray().element == array16Element) {
        updates[type] = array16;
      }
    }

    TypeMapper(*module, updates).map();
  }

  // Imported string functions.
  Name fromCharCodeArrayImport;
  Name intoCharCodeArrayImport;
  Name fromCodePointImport;
  Name concatImport;
  Name equalsImport;
  Name compareImport;
  Name lengthImport;
  Name charCodeAtImport;
  Name substringImport;

  // The name of the module to import string functions from.
  Name WasmStringsModule = "wasm:js-string";

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
    // string.concat: string, string -> string
    concatImport = addImport(module, "concat", {nullExt, nullExt}, nnExt);
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
    charCodeAtImport =
      addImport(module, "charCodeAt", {nullExt, Type::i32}, Type::i32);
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
                                            {curr->ref, curr->start, curr->end},
                                            lowering.nnExt));
            return;
          case StringNewFromCodePoint:
            replaceCurrent(builder.makeCall(
              lowering.fromCodePointImport, {curr->ref}, lowering.nnExt));
            return;
          default:
            WASM_UNREACHABLE("TODO: all of string.new*");
        }
      }

      void visitStringConcat(StringConcat* curr) {
        Builder builder(*getModule());
        replaceCurrent(builder.makeCall(
          lowering.concatImport, {curr->left, curr->right}, lowering.nnExt));
      }

      void visitStringEncode(StringEncode* curr) {
        Builder builder(*getModule());
        switch (curr->op) {
          case StringEncodeWTF16Array:
            replaceCurrent(
              builder.makeCall(lowering.intoCharCodeArrayImport,
                               {curr->str, curr->array, curr->start},
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
        replaceCurrent(
          builder.makeCall(lowering.lengthImport, {curr->ref}, Type::i32));
      }

      void visitStringWTF16Get(StringWTF16Get* curr) {
        Builder builder(*getModule());
        replaceCurrent(builder.makeCall(
          lowering.charCodeAtImport, {curr->ref, curr->pos}, Type::i32));
      }

      void visitStringSliceWTF(StringSliceWTF* curr) {
        Builder builder(*getModule());
        replaceCurrent(builder.makeCall(lowering.substringImport,
                                        {curr->ref, curr->start, curr->end},
                                        lowering.nnExt));
      }
    };

    Replacer replacer(*this);
    replacer.run(getPassRunner(), module);
    replacer.walkModuleCode(module);
  }

  // A ref.null of none needs to be noext if it is going to a location of type
  // stringref.
  void replaceNulls(Module* module) {
    // Use SubtypingDiscoverer to find when a ref.null of none flows into a
    // place that has been changed from stringref to externref.
    struct NullFixer
      : public WalkerPass<
          ControlFlowWalker<NullFixer, SubtypingDiscoverer<NullFixer>>> {
      // Hooks for SubtypingDiscoverer.
      void noteSubtype(Type, Type) {
        // Nothing to do for pure types.
      }
      void noteSubtype(HeapType, HeapType) {
        // Nothing to do for pure types.
      }
      void noteSubtype(Type, Expression*) {
        // Nothing to do for a subtype of an expression.
      }
      void noteSubtype(Expression* a, Type b) {
        // This is the case we care about: if |a| is a null that must be a
        // subtype of ext then we fix that up.
        if (!b.isRef()) {
          return;
        }
        HeapType top = b.getHeapType().getTop();
        if (top.isMaybeShared(HeapType::ext)) {
          if (auto* null = a->dynCast<RefNull>()) {
            null->finalize(HeapTypes::noext.getBasic(top.getShared()));
          }
        }
      }
      void noteSubtype(Expression* a, Expression* b) {
        // Only the type matters of the place we assign to.
        noteSubtype(a, b->type);
      }
      void noteNonFlowSubtype(Expression* a, Type b) {
        // Flow or non-flow is the same for us.
        noteSubtype(a, b);
      }
      void noteCast(HeapType, HeapType) {
        // Casts do not concern us.
      }
      void noteCast(Expression*, Type) {
        // Casts do not concern us.
      }
      void noteCast(Expression*, Expression*) {
        // Casts do not concern us.
      }
    };

    NullFixer fixer;
    fixer.run(getPassRunner(), module);
    fixer.walkModuleCode(module);
  }
};

Pass* createStringGatheringPass() { return new StringGathering(); }
Pass* createStringLoweringPass() { return new StringLowering(); }
Pass* createStringLoweringMagicImportPass() { return new StringLowering(true); }
Pass* createStringLoweringMagicImportAssertPass() {
  return new StringLowering(true, true);
}

} // namespace wasm
