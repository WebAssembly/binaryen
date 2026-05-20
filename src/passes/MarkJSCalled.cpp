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
// Users should mark JS-called functions using @binaryen.js.called. This pass
// helps by auto-marking them where possible. The main thing this does is to
// find any configureAll calls and mark the functions referred to there.
//

#include "ir/find_all.h"
#include "ir/intrinsics.h"
#include "ir/module-utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

struct MarkJSCalled : public Pass {
  void run(Module* module) override {
    Intrinsics intrinsics(*module);

    // See if there even is a configureAll.
    auto hasConfigureAll = false;
    for (auto& func : module->functions) {
      if (intrinsics.isConfigureAll(func.get())) {
        hasConfigureAll = true;
        break;
      }
    }
    if (!hasConfigureAll) {
      return;
    }

    using JSCalledSet = std::unordered_set<Name>;

    ModuleUtils::ParallelFunctionAnalysis<JSCalledSet> analysis(
      *module, [&](Function* func, JSCalledSet& jsCalled) {
        if (func->imported()) {
          return;
        }

        FindAll<Call> calls(func->body);
        for (auto* call : calls.list) {
          if (intrinsics.isConfigureAll(call)) {
            for (auto name : intrinsics.getConfigureAllFunctions(call)) {
              jsCalled.insert(name);
            }
          }
        }
      });

    for (auto& [_, jsCalled] : analysis.map) {
      for (auto name : jsCalled) {
        module->getFunction(name)->funcAnnotations.jsCalled = true;
      }
    }
  }
};

Pass* createMarkJSCalledPass() { return new MarkJSCalled(); }

} // namespace wasm
