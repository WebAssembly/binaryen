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
// Finds types which are only created in assignments to immutable globals. For
// such types we can replace a struct.get with this pattern:
//
//  (struct.get $foo i
//    (..ref..))
//  =>
//  (select
//    (value1)
//    (value2)
//    (ref.eq
//      (..ref..)
//      (global.get $global1)))
//
// That is a valid transformation if there are only two struct.news of $foo, it
// is created in two immutable globals $global1 and $global2, and the values of
// field |i| in them are value1 and value2 respectively (and there are no
// subtypes). In that situation, the reference must be one of those two, so we
// can compare the reference to the globals and pick the right value there.
//
// The benefit of this optimization is primarily in the case of constant values
// that we can heavily optimize, like function references (constant function
// refs let us inline, etc.). Function references cannot be directly compared,
// so we cannot use ConstantFieldPropagation or such with an extension to
// multiple values, as the select pattern shown above can't be used - it needs a
// comparison. But we can compare structs, so if the function references are in
// vtables, and the vtables follow the above pattern, then we can optimize.
//

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/subtypes.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

struct GlobalStructInference : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalStructInference requires nominal typing";
    }

    // First, find all the information we need. We need to know which struct
    // types are created in functions, because we will not be able to optimize
    // those.

    using StructNewTypes = std::unordered_set<StructNew*>;

    ModuleUtils::ParallelFunctionAnalysis<StructNewTypes> analysis(
      *module, [&](Function* func, StructNewTypes& structNewTypes) {
        if (func->imported()) {
          continue;
        }

        for (auto* structNew : FindAll<StructNew>(func->body).list) {
          auto type = structNew->type;
          if (type.isReference()) {
            structNewTypes.insert(type.getHeapType());
          }
        }
      });

    // We cannot optimize types that appear in a struct.new in a function, which
    // we just collected and merge now.
    StructNewTypes unoptimizable;

    for (auto& [func, structNewTypes] : analysis.map) {
      for (auto type : structNewTypes) {
        unoptimizable.insert(type);
      }
    }

    // Maps struct types to the globals whose init is a struct.new of them.
    std::unordered_map<HeapType, std::vector<Name>> typeGlobals;

    // We also cannot optimize a type that appears in a non-toplevel location in
    // a global init. Note the toplevel global inits as well, while we go.
    for (auto& global : module->globals) {
      if (global->imported()) {
        continue;
      }

      for (auto* structNew : FindAll<StructNew>(global->init).list) {
        auto type = structNew->type;
        if (type.isReference() && structNew != global->init) {
          unoptimizable.insert(type.getHeapType());
        }
      }

      if (global->init->is<StructNew()) {
        typeGlobals[global->init->type.getHeapType()].push_back(global->name);
      }
    }

    // Compute subtypes, as a get from a struct might also read from any of
    // them.
    SubTypes subTypes(*module);
  }
};

} // anonymous namespace

Pass* createGlobalStructInferencePass() { return new GlobalStructInference(); }

} // namespace wasm
