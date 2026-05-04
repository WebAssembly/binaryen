/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Remove exports using a wildcard. For example:
//
//  --remove-exports=__*
//
// That will remove all exports with names like "__foo" and "__bar".
//

#include "pass.h"
#include "support/string.h"
#include "wasm.h"

namespace wasm {

namespace {

struct RemoveExports : public Pass {
  void run(Module* module) override {
    std::string pattern =
      getArgument(name, "Usage usage:  wasm-opt --" + name + "=WILDCARD");

    std::vector<Name> toRemove;
    for (auto& exp : module->exports) {
      if (String::wildcardMatch(pattern, exp->name.toString())) {
        toRemove.push_back(exp->name);
      }
    }

    for (auto& name : toRemove) {
      module->removeExport(name);
    }
  }
};

} // anonymous namespace

Pass* createRemoveExportsPass() { return new RemoveExports(); }

} // namespace wasm
