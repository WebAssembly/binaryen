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
#include "ir/subtypes.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

using Types = std::unordered_set<HeapType>;
using TypeMap = std::unordered_map<HeapType, HeapType>;

// Gather all types in StructNews.
struct NewFinder : public PostWalker<NewFinder> {
  Types& types;

  NewFinder(Types& types) : types(types) {}

  void visitStructNew(StructNew* curr) {
    auto type = curr->type;
    if (type != Type::unreachable) {
      types.insert(type.getHeapType());
    }
  }
};

// Given a map of [old type, new type], where each old type can be optimized to
// the new type in a cast, apply those optimizations.
struct Optimizer : public WalkerPass<PostWalker<Optimizer>> {
  bool isFunctionParallel() override { return true; }

  TypeMap& optimizableTypes;

  Optimizer(TypeMap& optimizableTypes) : optimizableTypes(optimizableTypes) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Optimizer>(optimizableTypes);
  }

  template<typename T> void visitCast(T* curr) {
    auto& type = curr->getCastType();
    if (type == Type::unreachable) {
      return;
    }

    auto iter = optimizableTypes.find(type.getHeapType());
    if (iter == optimizableTypes.end()) {
      return;
    }

    // Success: Apply the new type.
    type = Type(iter->second, type.getNullability());
  }

  void visitRefCast(RefCast* curr) { visitCast(curr); }

  void visitRefTest(RefTest* curr) { visitCast(curr); }

  void visitBrOn(BrOn* curr) { visitCast(curr); }
};

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

    // First, find "abstract" types, that is, types without a struct.new.

    ModuleUtils::ParallelFunctionAnalysis<Types> analysis(
      *module, [&](Function* func, Types& types) {
        if (func->imported()) {
          return;
        }

        NewFinder(types).walk(func->body);
      });

    Types createdTypes;
    NewFinder(createdTypes).walkModuleCode(module);

    // Combine all the types.
    for (auto& [_, types] : analysis.map) {
      for (auto type : types) {
        createdTypes.insert(type);
      }
    }

    // Abstract types are those with no news, i.e., the complement of
    // |createdTypes|.
    Types abstractTypes;
    auto types = ModuleUtils::collectHeapTypes(*module);
    for (auto type : types) {
      if (createdTypes.count(type) == 0) {
        abstractTypes.insert(type);
      }
    }

    // We found abstract types. Next, find which of them are optimizable. We
    // need an abstract type to have a single subtype, to which we will switch
    // all of their casts.

    SubTypes subTypes(*module);

    TypeMap optimizableTypes;

    for (auto type : abstractTypes) {
      auto& typeSubTypes = subTypes.getStrictSubTypes(type);
      if (typeSubTypes.size() == 1) {
        optimizableTypes[type] = typeSubTypes[0];
      }
    }

    if (optimizableTypes.empty()) {
      return;
    }

    // We found optimizable types. Apply them.
    Optimizer optimizer(optimizableTypes);
    optimizer.run(getPassRunner(), module);

    // Refinalize, as RefCasts may have new types now.
    ReFinalize().run(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createCastRefiningPass() { return new CastRefining(); }

} // namespace wasm
