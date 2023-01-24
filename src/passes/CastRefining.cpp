/*
 * Copyright 2023 WebAssembly Community Group participants
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
// Apply more specific subtypes to cast instructions where possible.
//
// In trapsNeverHappen mode, if we see a cast to $B and the type hierarchy is
// this:
//
//   $A :> $B :> $C
//
// and $B has no struct.new instructions, and we are in closed world, then we
// can infer that the cast must be to $C. That is necessarily so since we will
// not trap by assumption, and $C or a subtype of it is all that remains
// possible.
//

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

struct CastRefining : public Pass {
  // Only changes cast types, but not locals.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    if (!module->features.hasGC() || !getPassOptions().trapsNeverHappen) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "CastRefining requires --closed-world";
    }

    if (!module->tables.empty()) {
      // When there are tables we must also take their types into account, which
      // would require us to take call_indirect, element segments, etc. into
      // account. For now, do nothing if there are tables.
      // TODO
      return;
    }

    // Look for "abstract" types, that is, types without a struct.new.
    using Types = std::unordered_set<HeapType>;

    struct NewFinder : public PostWalker<NewFinder> {
      Types& abstractTypes;

      NewFinder(Types& abstractTypes) : abstractTypes(abstractTypes) {}

      void visitStructNew(StructNew* curr) {
        auto type = curr->type;
        if (type != Type::unreachable) {
          abstractTypes.insert(type.getHeapType());
        }
      }
    };

    ModuleUtils::ParallelFunctionAnalysis<Types> analysis(
      *module, [&](Function* func, Types& abstractTypes) {
        if (func->imported()) {
          return;
        }

        NewFinder(abstractTypes).walk(func->body);
      });

    NewFinder(abstractTypes).walkModuleCode(module);



























    if (refinedResults) {
      // After return types change we need to propagate.
      // TODO: we could do this only in relevant functions perhaps
      ReFinalize().run(getPassRunner(), module);
    }
  }
};

} // anonymous namespace

Pass* createCastRefiningPass() { return new CastRefining(); }

} // namespace wasm
