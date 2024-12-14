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
// Removes function exports. This is particularly helpful for shared
// libraries where not all the exported functions are being used for
// a specific use case.
//

#include <unordered_map>

#include "pass.h"
#include "support/string.h"

namespace wasm {

struct RemoveExports : public Pass {
  void run(Module* module) override {
    auto arg =
      getArgument("remove-exports",
                  "RemoveExports usage: wasm-opt "
                  "--remove-exports=EXPORT_NAME_1[,EXPORT_NAME_2[,...]]");

    auto argsItems = String::Split(arg, ",");
    auto exportsToRemove =
      std::unordered_set<std::string>(argsItems.begin(), argsItems.end());

    auto it = module->exports.begin();
    while (it != module->exports.end()) {
      if ((*it)->kind == ExternalKind::Function &&
          exportsToRemove.count((*it)->name.toString())) {
        it = module->exports.erase(it);
      } else {
        ++it;
      }
    }
  }
};

Pass* createRemoveExportsPass() { return new RemoveExports(); }

} // namespace wasm
