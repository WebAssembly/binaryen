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
// Even without trapsNeverHappen we can optimize certain cases. When we see a
// cast to a type that is never created, nor any subtype is created, then it
// must fail unless it allows null.
//

#include "ir/module-utils.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

using Types = std::unordered_set<HeapType>;

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

struct CastRefining : public Pass {
  // Changes types, either by refining them without changing nullability, or
  // changing them to be null types, so we never add new non-nullable locals
  // here.
  bool requiresNonNullableLocalFixups() override { return false; }

  // The types that are created (have a struct.new).
  Types createdTypes;

  // The types that are created, or have a subtype that is created.
  Types createdTypesOrSubTypes;

  // A map of a cast type to refine and the type to refine it to.
  TypeMapper::TypeUpdates refinableTypes;

  bool trapsNeverHappen;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "CastRefining requires --closed-world";
    }

    trapsNeverHappen = getPassOptions().trapsNeverHappen;

    // First, find all the created types (that have a struct.new) both in module
    // code and in functions.
    NewFinder(createdTypes).walkModuleCode(module);

    ModuleUtils::ParallelFunctionAnalysis<Types> analysis(
      *module, [&](Function* func, Types& types) {
        if (!func->imported()) {
          NewFinder(types).walk(func->body);
        }
      });

    for (auto& [_, types] : analysis.map) {
      for (auto type : types) {
        createdTypes.insert(type);
      }
    }

    SubTypes subTypes(*module);

    // Compute createdTypesOrSubTypes by starting with the created types and
    // then propagating subtypes.
    createdTypesOrSubTypes = createdTypes;
    for (auto type : subTypes.getSubTypesFirstSort()) {
      // If any of our subtypes are created, so are we.
      for (auto subType : subTypes.getStrictSubTypes(type)) {
        if (createdTypesOrSubTypes.count(subType)) {
          createdTypesOrSubTypes.insert(type);
          break;
        }
      }
    }

    if (trapsNeverHappen) {
      computeAbstractTypes(subTypes);
    }

    // Use what we found about abstract types and never-created types to
    // optimize.
    optimize(module, subTypes);
  }

  void computeAbstractTypes(const SubTypes& subTypes) {
    // Abstract types are those with no news, i.e., the complement of
    // |createdTypes|. As mentioned above, we can only optimize this case if
    // traps never happen.
    Types abstractTypes;
    for (auto type : subTypes.types) {
      if (createdTypes.count(type) == 0) {
        abstractTypes.insert(type);
      }
    }

    // We found abstract types. Next, find which of them are refinable. We
    // need an abstract type to have a single subtype, to which we will switch
    // all of their casts.
    //
    // Do this depth-first, so that we visit subtypes first. That will handle
    // chains where we want to refine a type A to a subtype of a subtype of
    // it.
    for (auto type : subTypes.getSubTypesFirstSort()) {
      if (!abstractTypes.count(type)) {
        continue;
      }

      std::optional<HeapType> refinedType;
      auto& typeSubTypes = subTypes.getStrictSubTypes(type);
      if (typeSubTypes.size() == 1) {
        // There is only a single possibility, so we can definitely use that
        /// one.
        refinedType = typeSubTypes[0];
      } else if (!typeSubTypes.empty()) {
        // There are multiple possibilities. However, perhaps only one of them
        // is relevant, if nothing is ever created of the others or their
        // subtypes.
        for (auto subType : typeSubTypes) {
          if (createdTypesOrSubTypes.count(subType)) {
            if (!refinedType) {
              // This is the first relevant thing, and hopefully will remain
              // the only one.
              refinedType = subType;
            } else {
              // We've seen more than one as relevant, so we have failed to
              // find a singleton.
              refinedType = std::nullopt;
              break;
            }
          }
        }
      }
      if (refinedType) {
        // Propagate anything from the child, to handle chains.
        auto iter = refinableTypes.find(*refinedType);
        if (iter != refinableTypes.end()) {
          *refinedType = iter->second;
        }

        refinableTypes[type] = *refinedType;
      }
    }
  }

  void optimize(Module* module, const SubTypes& subTypes) {
    // To optimize we rewrite types. That is, if we want to optimize all casts
    // of $A to instead cast to the refined type $B, we can do that by simply
    // replacing all appearances of $A with $B. That is possible here since we
    // only optimize when we know $A is never created, and we are removing all
    // casts to it, which means no other references to it are needed - so we can
    // just rewrite all references to $A to point to $B. Doing such a rewrite
    // will also remove the unneeded type from the type section, which is nice
    // for code size.
    //
    // Note that this could in theory limit optimizability, but it does not. It
    // could in theory because we are merging types here - even though we merge
    // types that are not needed (so we can't hurt optimizations), those changes
    // can affect needed types. For example, imagine that we replace all $A with
    // $B, and we had types like this:
    //
    //  $C = [.., $A, ..]
    //  $D = [.., $B, ..]
    //
    // After replacing $A with $B, we cause $C and $D to be structurally
    // identical. However, we will not actually merge those in the normal course
    // of optimization: the type rewriter will create a single new rec group for
    // all new types anyhow, so they all remain distinct from each other. The
    // only thing that can merge them is if we run TypeMerging, which is not run
    // by default exactly for this reason, that it can limit optimizations.
    // Thus, this pass does only "safe" merging, that cannot limit later
    // optimizations.

    TypeMapper::TypeUpdates mapping;

    for (auto type : subTypes.types) {
      if (!type.isStruct()) {
        // TODO: support arrays and funcs
        continue;
      }

      // Add a mapping of types that are never created (and none of their
      // subtypes) to the bottom type. This is valid because all locations of
      // that type, like a local variable, will only contain null at runtime.
      // Likewise, if we have a ref.test of such a type, we can only be looking
      // for a null at best. This can be seen as "refining" uses of these
      // never-created types to the bottom type.
      //
      // We check this first as it is the most powerful change.
      if (createdTypesOrSubTypes.count(type) == 0) {
        mapping[type] = type.getBottom();
        continue;
      }

      // Otherwise, apply a refining if we found one before.
      if (auto iter = refinableTypes.find(type); iter != refinableTypes.end()) {
        mapping[type] = iter->second;
      }
    }

    if (mapping.empty()) {
      return;
    }

    // A TypeMapper that handles the patterns we have in our mapping, where we
    // end up mapping a type to a *subtype*. We need to properly create
    // supertypes while doing this rewriting. For example, say we have this:
    //
    //  A :> B :> C
    //
    // Say we see B is never created, so we want to map B to its subtype C. C's
    // supertype must now be A.
    class CastRefiningTypeMapper : public TypeMapper {
    public:
      CastRefiningTypeMapper(Module& wasm, const TypeUpdates& mapping)
        : TypeMapper(wasm, mapping) {}

      std::optional<HeapType> getSuperType(HeapType oldType) override {
        auto super = oldType.getSuperType();
        if (!super) {
          return super;
        }

        // Go up the chain of supertypes, skipping things we are mapping away,
        // as those things will not appear in the output. This skips B in the
        // example above.
        while (1) {
          if (mapping.count(*super)) {
            super = super->getSuperType();
          } else {
            return super;
          }
        }
      }
    };

    CastRefiningTypeMapper(*module, mapping).map();

    // Refinalize, as RefCasts may have new types now.
    ReFinalize().run(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createCastRefiningPass() { return new CastRefining(); }

} // namespace wasm
