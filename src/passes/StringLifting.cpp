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
#include "passes/string-utils.h"
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
    for (auto& global : module->globals) {
      if (!global->imported()) {
        continue;
      }
      if (global->module == WasmStringConstsModule) {
        importedStrings[global->name] = global->base;
        found = true;
      }
    }
    for (auto& func : module->functions) {
      if (!func->imported() || func->module != WasmStringsModule) {
        continue;
      }
      if (func->base == "fromCharCodeArray") {
        fromCharCodeArrayImport = func->name;
        found = true;
      } else if (func->base == "fromCodePoint") {
        fromCodePointImport = func->name;
        found = true;
      } else if (func->base == "concat") {
        concatImport = func->name;
        found = true;
      } else if (func->base == "intoCharCodeArray") {
        intoCharCodeArrayImport = func->name;
        found = true;
      } else if (func->base == "equals") {
        equalsImport = func->name;
        found = true;
      } else if (func->base == "compare") {
        compareImport = func->name;
        found = true;
      } else if (func->base == "length") {
        lengthImport = func->name;
        found = true;
      } else if (func->base == "charCodeAt") {
        charCodeAtImport = func->name;
        found = true;
      } else if (func->base == "substring") {
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

      void visitCall(Call* curr) {
        if (curr->target == parent.fromCharCodeArrayImport) {
          replaceCurrent(Builder(*getModule()).makeStringNew(StringNewWTF16Array, curr->operands[0], curr->operands[1], curr->operands[2]));
        } else if (curr->target == parent.fromCodePointImport) {
          replaceCurrent(Builder(*getModule()).makeStringNew(StringNewFromCodePoint, curr->operands[0]));
        } else if (curr->target == parent.concatImport) {
          replaceCurrent(Builder(*getModule()).makeStringConcat(curr->operands[0], curr->operands[1]));
        } else if (curr->target == parent.intoCharCodeArrayImport) {
          replaceCurrent(Builder(*getModule()).makeStringEncode(StringEncodeWTF16Array, curr->operands[0], curr->operands[1], curr->operands[2]));
        } else if (curr->target == parent.equalsImport) {
          replaceCurrent(Builder(*getModule()).makeStringEq(StringEqEqual, curr->operands[0], curr->operands[1]));
        } else if (curr->target == parent.compareImport) {
          replaceCurrent(Builder(*getModule()).makeStringEq(StringEqCompare, curr->operands[0], curr->operands[1]));
        } else if (curr->target == parent.lengthImport) {
          replaceCurrent(Builder(*getModule()).makeStringMeasure(StringMeasureWTF16, curr->operands[0]));
        } else if (curr->target == parent.charCodeAtImport) {
          replaceCurrent(Builder(*getModule()).makeStringWTF16Get(curr->operands[0], curr->operands[1]));
        } else if (curr->target == parent.substringImport) {
          replaceCurrent(Builder(*getModule()).makeStringSliceWTF(curr->operands[0], curr->operands[1], curr->operands[2]));
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

Pass* createStringLiftingPass() { return new StringLifting(); }

} // namespace wasm
