/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Minifies import and export names, renaming them to short versions,
// and prints out a mapping to the new short versions. That mapping
// can then be used to minify the JS calling the wasm, together enabling
// minification of the identifiers on the JS/wasm boundary.
//
// For example, this may minify
//   (import "env" "longname" (func $internal))
// to
//   (import "env" "a" (func $internal))
// "a" is the minified name. If we also minify module names, then the
// result could be
//   (import "a" "a" (func $internal))
//
// TODO: check if we can minify names to the empty string "", which is even
//       shorter than one character.

#include <asmjs/shared-constants.h>
#include <assert.h>
#include <iostream>
#include <ir/module-utils.h>
#include <map>
#include <memory>
#include <pass.h>
#include <set>
#include <stddef.h>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>
#include <wasm.h>

#include "emscripten-optimizer/istring.h"
#include "support/name.h"

namespace wasm {

struct MinifyImportsAndExports : public Pass {
  bool minifyExports, minifyModules;

public:
  explicit MinifyImportsAndExports(bool minifyExports, bool minifyModules)
    : minifyExports(minifyExports), minifyModules(minifyModules) {}

private:
  // Generates minified names that are valid in JS.
  // Names are computed lazily.
  class MinifiedNames {
  public:
    MinifiedNames() {
      // Reserved words in JS up to size 4 - size 5 and above would mean we use
      // an astronomical number of symbols, which is not realistic anyhow.
      reserved.insert("do");
      reserved.insert("if");
      reserved.insert("in");
      reserved.insert("for");
      reserved.insert("new");
      reserved.insert("try");
      reserved.insert("var");
      reserved.insert("env");
      reserved.insert("let");
      reserved.insert("case");
      reserved.insert("else");
      reserved.insert("enum");
      reserved.insert("void");
      reserved.insert("this");
      reserved.insert("with");

      validInitialChars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$";
      validLaterChars = validInitialChars + "0123456789";

      minifiedState.push_back(0);
    }

    // Get the n-th minified name.
    std::string getName(size_t n) {
      ensure(n + 1);
      return names[n];
    }

  private:
    // Reserved words we must not emit.
    std::unordered_set<std::string> reserved;

    // Possible initial letters.
    std::string validInitialChars;

    // Possible later letters.
    std::string validLaterChars;

    // The minified names we computed so far.
    std::vector<std::string> names;

    // Helper state for progressively computing more minified names -
    // a stack of the current index.
    std::vector<size_t> minifiedState;

    // Make sure we have at least n minified names.
    void ensure(size_t n) {
      while (names.size() < n) {
        // Generate the current name.
        std::string name;
        auto index = minifiedState[0];
        assert(index < validInitialChars.size());
        name += validInitialChars[index];
        for (size_t i = 1; i < minifiedState.size(); i++) {
          auto index = minifiedState[i];
          assert(index < validLaterChars.size());
          name += validLaterChars[index];
        }
        if (reserved.count(name) == 0) {
          names.push_back(name);
        }
        // Increment the state.
        size_t i = 0;
        while (1) {
          minifiedState[i]++;
          if (minifiedState[i] <
              (i == 0 ? validInitialChars : validLaterChars).size()) {
            break;
          }
          // Overflow.
          minifiedState[i] = 0;
          i++;
          if (i == minifiedState.size()) {
            // will become 0 after increment in next loop head
            minifiedState.push_back(-1);
          }
        }
      }
    }
  };

  void run(PassRunner* runner, Module* module) override {
    // Minify the imported names.
    MinifiedNames names;
    size_t soFar = 0;
    std::map<Name, Name> oldToNew;
    std::map<Name, Name> newToOld;
    auto process = [&](Name& name) {
      auto iter = oldToNew.find(name);
      if (iter == oldToNew.end()) {
        auto newName = names.getName(soFar++);
        oldToNew[name] = newName;
        newToOld[newName] = name;
        name = newName;
      } else {
        name = iter->second;
      }
    };
    ModuleUtils::iterImports(*module, [&](Importable* curr) {
      // Minify all import base names if we are importing modules (which means
      // we will minify all modules names, so we are not being careful).
      // Otherwise, assume we just want to minify "normal" imports like env
      // and wasi, but not special things like asm2wasm or custom user things.
      if (minifyModules || curr->module == ENV ||
          curr->module.startsWith("wasi_")) {
        process(curr->base);
      }
    });

    if (minifyExports) {
      // Minify the exported names.
      for (auto& curr : module->exports) {
        process(curr->name);
      }
    }
    module->updateMaps();
    // Emit the mapping.
    for (auto& pair : newToOld) {
      std::cout << pair.second.str << " => " << pair.first.str << '\n';
    }

    if (minifyModules) {
      doMinifyModules(module);
    }
  }

  const Name SINGLETON_MODULE_NAME = "a";

  void doMinifyModules(Module* module) {
    // Minify the module name itself, and also merge all the modules into
    // one. Assert against overlapping names.
#ifndef NDEBUG
    std::set<Name> seenImports;
#endif
    ModuleUtils::iterImports(*module, [&](Importable* curr) {
      curr->module = SINGLETON_MODULE_NAME;
#ifndef NDEBUG
      assert(seenImports.count(curr->base) == 0);
      seenImports.insert(curr->base);
#endif
    });
  }
};

Pass* createMinifyImportsPass() {
  return new MinifyImportsAndExports(false, false);
}

Pass* createMinifyImportsAndExportsPass() {
  return new MinifyImportsAndExports(true, false);
}

Pass* createMinifyImportsAndExportsAndModulesPass() {
  return new MinifyImportsAndExports(true, true);
}

} // namespace wasm
