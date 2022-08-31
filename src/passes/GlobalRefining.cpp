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

namespace wasm {

namespace {

struct GlobalRefining : public Pass {
  // Only modifies globals and global.get operations.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(PassRunner* runner, Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }
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
        lubs[set->name].noteUpdatableExpression(set->value);
      }
    }

    bool optimized = false;

    for (auto& global : module->globals) {
      if (global->imported()) {
        continue;
      }

      auto& lub = lubs[global->name];

      // Note the initial value.
      lub.noteUpdatableExpression(global->init);

      // The initial value cannot be unreachable, but it might be null, and all
      // other values might be too. In that case, we've noted nothing useful
      // and we can move on.
      if (!lub.noted()) {
        continue;
      }

      auto oldType = global->type;
      auto newType = lub.getBestPossible();
      if (newType != oldType) {
        // We found an improvement!
        assert(Type::isSubType(newType, oldType));
        global->type = newType;
        lub.updateNulls();
        optimized = true;
      }
    }

    if (!optimized) {
      return;
    }

    // Update function contents for their new parameter types: global.gets must
    // now return the new type for any globals that we modified.
    struct GetUpdater : public WalkerPass<PostWalker<GetUpdater>> {
      bool isFunctionParallel() override { return true; }

      // Only modifies global.get operations.
      bool requiresNonNullableLocalFixups() override { return false; }

      GlobalRefining& parent;
      Module& wasm;

      GetUpdater(GlobalRefining& parent, Module& wasm)
        : parent(parent), wasm(wasm) {}

      GetUpdater* create() override { return new GetUpdater(parent, wasm); }

      // If we modify anything in a function then we must refinalize so that
      // types propagate outwards.
      bool modified = false;

      void visitGlobalGet(GlobalGet* curr) {
        auto oldType = curr->type;
        auto newType = wasm.getGlobal(curr->name)->type;
        if (newType != oldType) {
          curr->type = newType;
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
