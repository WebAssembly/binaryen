/*
 * Copyright 2022 WebAssembly Community Group participants
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
// Handle the computation of global effects. The effects are stored on the
// PassOptions structure; see more details there.
//

#include "ir/module-utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    // TODO: Full transitive closure of effects. For now, we just look at each
    //       function by itself.

    auto& funcEffectsMap = getPassOptions().funcEffectsMap;

    // First, clear any previous effects.
    funcEffectsMap.reset();

    // When we find useful effects, we'll save them. If we can't find anything,
    // the final map we emit will not have an entry there at all.
    using PossibleEffects = std::unique_ptr<EffectAnalyzer>;

    ModuleUtils::ParallelFunctionAnalysis<PossibleEffects> analysis(
      *module, [&](Function* func, PossibleEffects& storedEffects) {
        if (func->imported()) {
          // Imports can do anything, so we need to assume the worst anyhow,
          // which is the same as not specifying any effects for them in the
          // map.
          return;
        }

        // Gather the effects.
        auto effects =
          std::make_unique<EffectAnalyzer>(getPassOptions(), *module, func);

        // If the body has a call, give up - that means we can't infer a more
        // specific set of effects than the pessimistic case of just assuming
        // any call to here is an arbitrary call. (See the TODO above for
        // improvements.)
        if (effects->calls) {
          return;
        }

        // Save the useful effects we found.
        storedEffects = std::move(effects);
      });

    // Generate the final data structure.
    for (auto& [func, possibleEffects] : analysis.map) {
      if (possibleEffects) {
        // Only allocate a new funcEffectsMap if we actually have data for it
        // (which might make later effect computation slightly faster, to
        // quickly skip the funcEffectsMap code path).
        if (!funcEffectsMap) {
          funcEffectsMap = std::make_shared<FuncEffectsMap>();
        }
        funcEffectsMap->emplace(func->name, *possibleEffects);
      }
    }
  }
};

struct DiscardGlobalEffects : public Pass {
  void run(Module* module) override { getPassOptions().funcEffectsMap.reset(); }
};

Pass* createGenerateGlobalEffectsPass() { return new GenerateGlobalEffects(); }

Pass* createDiscardGlobalEffectsPass() { return new DiscardGlobalEffects(); }

} // namespace wasm
