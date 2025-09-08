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

#include "ir/export-utils.h"
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

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
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

    // In closed world we cannot change the types of exports, as we might change
    // from a public type to a private that would cause a validation error.
    // TODO We could refine to a type that is still public, however.
    //
    // We are also limited in open world: in that mode we must assume that
    // another module might import our exported globals with the current type
    // (that type is a contract between them), and in such a case the type of
    // mutable globals must match precisely (the same rule as for mutable struct
    // fields in subtypes - the types must match exactly, or else a write in
    // one place could store a type considered in valid in another place).
    std::unordered_set<Name> unoptimizable;
    for (auto* global : ExportUtils::getExportedGlobals(*module)) {
      if (getPassOptions().closedWorld || global->mutable_) {
        unoptimizable.insert(global->name);
      }
    }

    bool optimized = false;

    for (auto& global : module->globals) {
      if (global->imported() || unoptimizable.count(global->name)) {
        continue;
      }

      auto& lub = lubs[global->name];

      // Note the initial value.
      lub.note(global->init->type);

      // The initial value cannot be unreachable, but it might be null, and all
      // other values might be too. In that case, we've noted nothing useful
      // and we can move on.
      if (!lub.noted()) {
        continue;
      }

      auto oldType = global->type;
      auto newType = lub.getLUB();
      if (newType != oldType) {
        // We found an improvement!
        assert(Type::isSubType(newType, oldType));
        global->type = newType;
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

      std::unique_ptr<Pass> create() override {
        return std::make_unique<GetUpdater>(parent, wasm);
      }

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
    } updater(*this, *module);
    updater.run(getPassRunner(), module);
    updater.runOnModuleCode(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createGlobalRefiningPass() { return new GlobalRefining(); }

} // namespace wasm
