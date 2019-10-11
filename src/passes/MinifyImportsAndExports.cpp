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
// "a" is the minified name (note that we only minify the base,
// not the module).
//

#include <map>
#include <string>
#include <unordered_set>

#include <asmjs/shared-constants.h>
#include <ir/import-utils.h>
#include <ir/module-utils.h>
#include <pass.h>
#include <shared-constants.h>
#include <wasm.h>
#include "support/json.h"

namespace wasm {

struct MinifyImportsAndExports : public Pass {
  bool minifyExports;

public:
  explicit MinifyImportsAndExports(bool minifyExports) : minifyExports(minifyExports) {}

private:
  // Generates minified names that are valid in JS.
  // Names are computed lazily.
  class MinifiedNames {
  public:
    MinifiedNames() {
      // Reserved words in JS up to size 4 - size 5 and above would mean we use an astronomical
      // number of symbols, which is not realistic anyhow.
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

      validInitialChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$";
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
          if (minifiedState[i] < (i == 0 ? validInitialChars : validLaterChars).size()) {
            break;
          }
          // Overflow.
          minifiedState[i] = 0;
          i++;
          if (i == minifiedState.size()) {
            minifiedState.push_back(-1); // will become 0 after increment in next loop head
          }
        }
      }
    }
  };

  // Super slow, need to optimize!!!
  void minifyIAT(Module* module, std::map<Name, Name> oldToNew) {
    // Minify the IAT
    std::string serializedIAT("{");
    for (int i = 0; i < module->userSections.size(); ++i) {
      if (module->userSections[i].name.compare("IAT") == 0) {
        for (int ii = 0; ii < module->userSections[i].data.size(); ++ii) {
          serializedIAT += (char)module->userSections[i].data[ii];
        }
      }
    }
    serializedIAT += "}";
    json::Value test;
    test.parse((char*)serializedIAT.c_str());
    json::Value::ObjectStorage* temp = test.obj;

    std::map<json::IString, json::Ref> newStorageMap;
    std::string deserializedMap;
    for (auto& it : *temp) {
      std::cout << it.first.str << "\n";
      for (auto& pair : oldToNew) {
        std::string tempString(pair.second.str);
        std::string strAfterToken;
        strAfterToken = tempString.substr(tempString.find('$') + 1);
        if (it.first.str == strAfterToken) {
          json::IString tempMinified(pair.first.str);
          // json::Value tempChar(it.second->getInteger());
          json::Ref iatIndex = json::Ref(new json::Value(it.second->getInteger()));
          // json::Ref testRef(&tempChar);
          //(*temp)[tempMinified] = testRef;
          newStorageMap.emplace(tempMinified, iatIndex);
        }
      }
    }

    for (auto it = newStorageMap.begin(); it != newStorageMap.end();) {
      deserializedMap += "\"" + std::string(it->first.str) + "\"" + std::string(":") +
                         std::to_string((int)it->second->getNumber());

      if (++it != newStorageMap.end()) {
        deserializedMap += ",";
      }
    }

    // Write back the minified IAT
    for (int i = 0; i < module->userSections.size(); ++i) {
      if (module->userSections[i].name.compare("IAT") == 0) {
        module->userSections[i].data.assign(
          deserializedMap.begin(), deserializedMap.begin() + deserializedMap.size());
      }
    }
  }

  #pragma optimize("", off)
  void run(PassRunner* runner, Module* module) override {
    // Minify the imported names.
    MinifiedNames names;
    size_t soFar = 0;
    std::map<Name, Name> oldToNew;
    auto process = [&](Name& name) {
      // do not minifiy special imports, they must always exist
      if (name == MEMORY_BASE || name == TABLE_BASE) {
        return;
      }
      auto newName = names.getName(soFar++);
      oldToNew[newName] = name;
      name = newName;
    };
    auto processImport = [&](Importable* curr) {
      if (curr->module == ENV) {
        process(curr->base);
      }
    };
    ModuleUtils::iterImportedGlobals(*module, processImport);
    ModuleUtils::iterImportedFunctions(*module, processImport);

    if (minifyExports) {
      // Minify the exported names.
      for (auto& curr : module->exports) {
        process(curr->name);
      }
    }
    module->updateMaps();

	minifyIAT(module, oldToNew);

    // Emit the mapping.
    for (auto& pair : oldToNew) {
      std::cout << pair.second.str << " => " << pair.first.str << '\n';
    }
  }
};
#pragma optimize("", on)

Pass* createMinifyImportsPass() { return new MinifyImportsAndExports(false); }

Pass* createMinifyImportsAndExportsPass() { return new MinifyImportsAndExports(true); }

} // namespace wasm
