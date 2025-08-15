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
// A pass argument allows customizing the module name for string constants:
//
//   --pass-arg=string-constants-module@MODULE_NAME
//

#include "ir/utils.h"
#include "pass.h"
#include "passes/string-utils.h"
#include "support/json.h"
#include "support/string.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct StringLifting : public Pass {
  // Maps the global name of an imported string to the actual string.
  std::unordered_map<Name, Name> importedStrings;

  // Imported string functions. Imports that do not exist remain null.
  Name fromCharCodeArrayImport;
  Name intoCharCodeArrayImport;
  Name fromCodePointImport;
  Name concatImport;
  Name equalsImport;
  Name testImport;
  Name compareImport;
  Name lengthImport;
  Name charCodeAtImport;
  Name substringImport;

  void run(Module* module) override {
    // Whether we found any work to do.
    bool found = false;

    // Imported string constants look like
    //
    //   (import "\'" "bar" (global $string.bar.internal.name (ref extern)))
    //
    // That is, they are imported from module "'" and the basename is the
    // actual string. Find them all so we can apply them.
    Name stringConstsModule =
      getArgumentOrDefault("string-constants-module", WasmStringConstsModule);
    for (auto& global : module->globals) {
      if (!global->imported()) {
        continue;
      }
      if (global->module == stringConstsModule) {
        // Encode from WTF-8 to WTF-16.
        auto wtf8 = global->base;
        std::stringstream wtf16;
        bool valid = String::convertWTF8ToWTF16(wtf16, wtf8.str);
        if (!valid) {
          Fatal() << "Bad string to lift: " << wtf8;
        }
        importedStrings[global->name] = wtf16.str();
        found = true;
      }
    }

    // Imported strings may also be found in the string section.
    auto stringSectionIter = std::find_if(
      module->customSections.begin(),
      module->customSections.end(),
      [&](CustomSection& section) { return section.name == "string.consts"; });
    if (stringSectionIter != module->customSections.end()) {
      // We found the string consts section. Parse it.
      auto& section = *stringSectionIter;
      auto copy = section.data;
      json::Value array;
      array.parse(copy.data(), json::Value::WTF16);
      if (!array.isArray()) {
        Fatal() << "StringLifting: string.const section should be a JSON array";
      }

      // We have the array of constants from the section. Find globals that
      // refer to it.
      for (auto& global : module->globals) {
        if (!global->imported() || global->module != "string.const") {
          continue;
        }
        // The index in the array is the basename.
        Index index = std::stoi(std::string(global->base.str));
        if (index >= array.size()) {
          Fatal() << "StringLifting: bad index in string.const section";
        }
        auto item = array[index];
        if (!item->isString()) {
          Fatal()
            << "StringLifting: string.const section entry is not a string";
        }
        if (importedStrings.count(global->name)) {
          Fatal() << "StringLifting: string.const section tramples other const";
        }
        importedStrings[global->name] = item->getIString();
      }

      // Remove the custom section: After lifting it has no purpose (and could
      // cause problems with repeated lifting/lowering).
      module->customSections.erase(stringSectionIter);
    }

    auto array16 = Type(Array(Field(Field::i16, Mutable)), Nullable);
    auto refExtern = Type(HeapType::ext, NonNullable);
    auto externref = Type(HeapType::ext, Nullable);
    auto i32 = Type::i32;

    // Find imported string functions.
    for (auto& func : module->functions) {
      if (!func->imported() || func->module != WasmStringsModule) {
        continue;
      }
      auto type = func->type;
      if (func->base == "fromCharCodeArray") {
        if (type != Signature({array16, i32, i32}, refExtern)) {
          Fatal() << "StringLifting: bad type for fromCharCodeArray: " << type;
        }
        fromCharCodeArrayImport = func->name;
        found = true;
      } else if (func->base == "fromCodePoint") {
        if (type != Signature(i32, refExtern)) {
          Fatal() << "StringLifting: bad type for fromCodePoint: " << type;
        }
        fromCodePointImport = func->name;
        found = true;
      } else if (func->base == "concat") {
        if (type != Signature({externref, externref}, refExtern)) {
          Fatal() << "StringLifting: bad type for concat: " << type;
        }
        concatImport = func->name;
        found = true;
      } else if (func->base == "intoCharCodeArray") {
        if (type != Signature({externref, array16, i32}, i32)) {
          Fatal() << "StringLifting: bad type for intoCharCodeArray: " << type;
        }
        intoCharCodeArrayImport = func->name;
        found = true;
      } else if (func->base == "equals") {
        if (type != Signature({externref, externref}, i32)) {
          Fatal() << "StringLifting: bad type for equals: " << type;
        }
        equalsImport = func->name;
        found = true;
      } else if (func->base == "test") {
        if (type != Signature({externref}, i32)) {
          Fatal() << "StringLifting: bad type for test: " << type;
        }
        testImport = func->name;
        found = true;
      } else if (func->base == "compare") {
        if (type != Signature({externref, externref}, i32)) {
          Fatal() << "StringLifting: bad type for compare: " << type;
        }
        compareImport = func->name;
        found = true;
      } else if (func->base == "length") {
        if (type != Signature({externref}, i32)) {
          Fatal() << "StringLifting: bad type for length: " << type;
        }
        lengthImport = func->name;
        found = true;
      } else if (func->base == "charCodeAt") {
        if (type != Signature({externref, i32}, i32)) {
          Fatal() << "StringLifting: bad type for charCodeAt: " << type;
        }
        charCodeAtImport = func->name;
        found = true;
      } else if (func->base == "substring") {
        if (type != Signature({externref, i32, i32}, refExtern)) {
          Fatal() << "StringLifting: bad type for substring: " << type;
        }
        substringImport = func->name;
        found = true;
      } else {
        std::cerr << "warning: unknown strings import: " << func->base << '\n';
      }
    }

    if (!found) {
      // Nothing to do.
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
        // Replace global.gets of imported strings with string.const.
        auto iter = parent.importedStrings.find(curr->name);
        if (iter != parent.importedStrings.end()) {
          auto wtf16 = iter->second;
          replaceCurrent(Builder(*getModule()).makeStringConst(wtf16.str));
          modified = true;
        }
      }

      void visitCall(Call* curr) {
        // Replace calls of imported string methods with stringref operations.
        if (curr->target == parent.fromCharCodeArrayImport) {
          replaceCurrent(Builder(*getModule())
                           .makeStringNew(StringNewWTF16Array,
                                          curr->operands[0],
                                          curr->operands[1],
                                          curr->operands[2]));
        } else if (curr->target == parent.fromCodePointImport) {
          replaceCurrent(
            Builder(*getModule())
              .makeStringNew(StringNewFromCodePoint, curr->operands[0]));
        } else if (curr->target == parent.concatImport) {
          replaceCurrent(
            Builder(*getModule())
              .makeStringConcat(curr->operands[0], curr->operands[1]));
        } else if (curr->target == parent.intoCharCodeArrayImport) {
          replaceCurrent(Builder(*getModule())
                           .makeStringEncode(StringEncodeWTF16Array,
                                             curr->operands[0],
                                             curr->operands[1],
                                             curr->operands[2]));
        } else if (curr->target == parent.equalsImport) {
          replaceCurrent(Builder(*getModule())
                           .makeStringEq(StringEqEqual,
                                         curr->operands[0],
                                         curr->operands[1]));
        } else if (curr->target == parent.testImport) {
          replaceCurrent(
            Builder(*getModule()).makeStringTest(curr->operands[0]));
        } else if (curr->target == parent.compareImport) {
          replaceCurrent(Builder(*getModule())
                           .makeStringEq(StringEqCompare,
                                         curr->operands[0],
                                         curr->operands[1]));
        } else if (curr->target == parent.lengthImport) {
          replaceCurrent(
            Builder(*getModule())
              .makeStringMeasure(StringMeasureWTF16, curr->operands[0]));
        } else if (curr->target == parent.charCodeAtImport) {
          replaceCurrent(
            Builder(*getModule())
              .makeStringWTF16Get(curr->operands[0], curr->operands[1]));
        } else if (curr->target == parent.substringImport) {
          replaceCurrent(Builder(*getModule())
                           .makeStringSliceWTF(curr->operands[0],
                                               curr->operands[1],
                                               curr->operands[2]));
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

    // TODO: Add casts. We generate new string.* instructions, and all their
    //       string inputs should be stringref, not externref, but we have not
    //       converted all externrefs to stringrefs (since some externrefs might
    //       be something else). It is not urgent to fix this as the validator
    //       accepts externrefs there atm, and since toolchains will lower
    //       strings out at the end anyhow (which would remove such casts). Note
    //       that if we add a type import for stringref then this problem would
    //       become a lot simpler (we'd convert that type to stringref).

    // Enable the feature so the module validates.
    module->features.enable(FeatureSet::Strings);
  }
};

Pass* createStringLiftingPass() { return new StringLifting(); }

} // namespace wasm
