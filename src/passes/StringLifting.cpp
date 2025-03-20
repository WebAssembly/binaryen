/*
 * Copyright 2025 WebAssembly Community Group participants
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
// Lift JS string imports into wasm strings in Binaryen IR, which can then be
// fully optimized. Typically StringLowering would be run later to lower them
// back down.
//

// TODO: which of these?
#include <algorithm>

// TODO: which of these?
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

struct StringLifting : public Pass {
  // Maps the global name of an imported string to the actual string.
  std::unordered_map<Name, Name> importedStrings;

  void run(Module* module) override {
    // Imported string constants look like
    //
    //   (import "\'" "bar" (global $string.bar.internal.name (ref extern)))
    //
    // That is, they are imported from module "'" and the basename is the
    // actual string. Find them all so we can apply them.
    for (auto& global : module->globals) {
      if (global->imported() && global->module == WasmStringConstsModule) {
        importedStrings[global->name] = global->base;
      }
    }

    if (importedStrings.empty()) { // TODO: remove when we have operations too
      return;
    }

    struct StringApplier : public WalkerPass<PostWalker<StringApplier>> {
      bool isFunctionParallel() override { return true; }

      const StringLifting& parent;

      StringApplier(const StringLifting& parent) : parent(parent) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<StringApplier>(parent);
      }

      bool modified = false;

      void visitGlobalGet(GlobalGet* curr) {
        auto iter = parent.importedStrings.find(curr->name);
        if (iter != parent.importedStrings.end()) {
          // Encode from WTF-8 to WTF-16.
          auto wtf8 = iter->second;
          std::stringstream wtf16;
          bool valid = String::convertWTF8ToWTF16(wtf16, wtf8.str);
          if (!valid) {
            Fatal() << "Bad string to lift: " << wtf8;
          }

          // Replace the global.get with a string.const.
          replaceCurrent(Builder(*getModule()).makeStringConst(wtf16.str()));
          modified = true;
        }
      }

      void visitFunction(Function* curr) {
        // If we made modifications then we need to refinalize, as we replace
        // externrefs with stringrefs, a subtype.
        if (modified) {
          ReFinalize().walkFunctionInModule(curr, getModule());
        }
      }
    };

    StringApplier applier(*this);
    applier.run(getPassRunner(), module);
    applier.walkModuleCode(module);
  }
};

/*
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
*/

Pass* createStringLiftingPass() { return new StringLifting(); }

} // namespace wasm
