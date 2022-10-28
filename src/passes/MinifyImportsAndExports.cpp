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

#include <map>
#include <string>
#include <unordered_set>

#include <asmjs/shared-constants.h>
#include <ir/import-utils.h>
#include <ir/module-utils.h>
#include <ir/names.h>
#include <pass.h>
#include <shared-constants.h>
#include <wasm.h>

namespace wasm {

struct MinifyImportsAndExports : public Pass {
  // This operates on import/export names only.
  bool requiresNonNullableLocalFixups() override { return false; }

  bool minifyExports, minifyModules;

public:
  explicit MinifyImportsAndExports(bool minifyExports, bool minifyModules)
    : minifyExports(minifyExports), minifyModules(minifyModules) {}

private:
  // Generates minified names that are valid in JS.
  // Names are computed lazily.

  void run(Module* module) override {
    // Minify the imported names.
    Names::MinifiedNameGenerator names;
    std::map<Name, Name> oldToNew;
    std::map<Name, Name> newToOld;
    auto process = [&](Name& name) {
      auto iter = oldToNew.find(name);
      if (iter == oldToNew.end()) {
        auto newName = names.getName();
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
      // and wasi, but not custom user things.
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
    for (auto& [new_, old] : newToOld) {
      std::cout << old.str << " => " << new_.str << '\n';
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
      auto res = seenImports.emplace(curr->base);
      assert(res.second);
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
