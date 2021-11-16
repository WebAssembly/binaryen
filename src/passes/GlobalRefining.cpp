/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Apply more specific subtypes to global variables where possible.
//

#include "ir/find_all.h"
#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

using namespace std;

namespace wasm {

namespace {

struct GlobalRefining : public Pass {
  // Maps each global to the possible refinement of its type. We will fill this during analysis and then use it while doing
  // an update of the types. If a global has no improvement that we can find, it
  // will not appear in this map.
  std::unordered_map<Name, Type> newGlobalTypes;

  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalRefining requires nominal typing";
    }

    // First, find all the global.sets.

    struct GlobalInfo {
      std::vector<GlobalSet*> sets;
    };

    ModuleUtils::ParallelFunctionAnalysis<GlobalInfo> analysis(
      *module, [&](Function* func, GlobalInfo& info) {
        if (func->imported()) {
          return;
        }
        info.sets = std::move(FindAll<GlobalSet>(func->body).list);
      });

    // A map of globals to the lub for that global.
    std::unordered_map<Name, LUBFinder> lubs;

    // Combine all the information we gathered and compute lubs.
    for (auto& [func, info] : analysis.map) {
      for (auto* set : info.sets) {
        lubs[set->name].note(set->value->type);
      }
    }

    for (auto& [global, lub] : lubs) {
      if (lub.noted()) {
        auto newType = lub.get();
        auto oldType =module->getGlobal(global)->type;
        if (newType != oldType) {
          // We found an improvement!
          assert(Type::isSubType(newType, oldType));
          newGlobalTypes[global] = newType;
        }
      }
    }

    if (newGlobalTypes.empty()) {
      // We found nothing to optimize.
      return;
    }

    // Update function contents for their new parameter types: global.gets must
    // now return the new type for any globals that we modified.
    struct GetUpdater : public WalkerPass<PostWalker<GetUpdater>> {
      bool isFunctionParallel() override { return true; }

      GlobalRefining& parent;
      Module& wasm;

      GetUpdater(GlobalRefining& parent, Module& wasm)
        : parent(parent), wasm(wasm) {}

      GetUpdater* create() override { return new GetUpdater(parent, wasm); }

      // If we modify anything in a function then we must refinalize so that
      // types propagate outwards.
      bool modified = false;

      void visitGlobalGet(GlobalGet* curr) {
        auto iter = parent.newGlobalTypes.find(curr->name);
        if (iter != parent.newGlobalTypes.end()) {
          curr->type = iter->second;
          modified = true;
        }
      }

      void visitFunction(Function* curr) {
        if (modified) {
          ReFinalize().walkFunctionInModule(curr, &wasm);
        }
      }
    };
    GetUpdater(*this, *module).run(runner, module);
  }
};

} // anonymous namespace

Pass* createGlobalRefiningPass() { return new GlobalRefining(); }

} // namespace wasm
