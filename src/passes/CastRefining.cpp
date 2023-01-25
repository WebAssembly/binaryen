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
// must fail (unless it allows null).
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

struct CastRefining : public Pass {
  // Only changes cast types, but not locals.
  bool requiresNonNullableLocalFixups() override { return false; }

  // The types that are created (have a struct.new). TODO move into func, some
  // of theses
  Types createdTypes;

  // The types that are created, or have a subtype that is created.
  Types createdTypesOrSubTypes;

  // A map of a cast type to refine and the type to refine it to.
  TypeMap refinableTypes;

  bool trapsNeverHappen;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "CastRefining requires --closed-world";
    }

    trapsNeverHappen = getPassOptions().trapsNeverHappen;

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

    NewFinder(createdTypes).walkModuleCode(module);

    // Combine all the info from the functions.
    for (auto& [_, types] : analysis.map) {
      for (auto type : types) {
        createdTypes.insert(type);
      }
    }

    SubTypes subTypes(*module);

    // Compute createdTypesOrSubTypes by starting with the created types and
    // then propagating subtypes.
    createdTypesOrSubTypes = createdTypes;
    for (auto type : subTypes.getDepthSort()) {
      // If any of our subtypes are created, so are we.
      for (auto subType : subTypes.getStrictSubTypes(type)) {
        if (createdTypesOrSubTypes.count(subType)) {
          createdTypesOrSubTypes.insert(type);
          break;
        }
      }
    }

    if (trapsNeverHappen) {
      // Abstract types are those with no news, i.e., the complement of
      // |createdTypes|. As mentioned above, we can only optimize this case if
      // traps never happen.
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
      //
      // Do this depth-first, so that we visit subtypes first. That will handle
      // chains where we want to refine a type A to a subtype of a subtype of
      // it.
      for (auto type : subTypes.getDepthSort()) {
        if (!abstractTypes.count(type)) {
          continue;
        }
        auto& typeSubTypes = subTypes.getStrictSubTypes(type);
        std::optional<HeapType> refinedType;
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

    // We found optimizable types. Apply them.
    Optimizer optimizer(*this);
    optimizer.run(getPassRunner(), module);

    // Refinalize, as RefCasts may have new types now.
    ReFinalize().run(getPassRunner(), module);
  }

  // Given a map of [old type, new type], where each old type can be optimized
  // to the new type in a cast, apply those optimizations.
  struct Optimizer : public WalkerPass<PostWalker<Optimizer>> {
    bool isFunctionParallel() override { return true; }

    CastRefining& parent;

    Optimizer(CastRefining& parent) : parent(parent) {}

    std::unique_ptr<Pass> create() override {
      return std::make_unique<Optimizer>(parent);
    }

    template<typename T> void refineCast(T* curr) {
      auto& type = curr->getCastType();
      if (type == Type::unreachable || !type.isRef()) {
        return;
      }

      auto iter = parent.refinableTypes.find(type.getHeapType());
      if (iter != parent.refinableTypes.end()) {
        // We can refine this cast.
        type = Type(iter->second, type.getNullability());
      }
    }

    void visitRefCast(RefCast* curr) {
      auto& type = curr->getCastType();
      if (type == Type::unreachable) {
        return;
      }

      auto heapType = type.getHeapType();
      if (parent.createdTypesOrSubTypes.count(heapType) == 0) {
        // Nothing is created of this type or any subtype, so the cast can only
        // pass through a null, at most.
        Builder builder(*getModule());
        Expression* rep = nullptr;
        if (type.isNullable()) {
          // TODO: Without TNH we can still optimize here, to do a null check +
          //       trap.
          if (parent.trapsNeverHappen) {
            rep = builder.makeRefNull(heapType.getBottom());
          }
        } else {
          rep = builder.makeUnreachable();
        }
        if (rep) {
          replaceCurrent(builder.makeSequence(builder.makeDrop(curr), rep));
          return;
        }
      }

      refineCast(curr);
    }

    void visitRefTest(RefTest* curr) {
      if (curr->type == Type::unreachable) {
        return;
      }

      auto castType = curr->getCastType();
      if (parent.createdTypesOrSubTypes.count(castType.getHeapType()) == 0) {
        // Nothing is created of this type or any subtype, so the cast can only
        // succeed if the input is a null, and we allow that.
        Builder builder(*getModule());
        if (castType.isNullable()) {
          replaceCurrent(builder.makeRefIsNull(curr->ref));
        } else {
          replaceCurrent(builder.makeSequence(
            builder.makeDrop(curr), builder.makeConst(Literal(int32_t(0)))));
        }
        return;
      }

      refineCast(curr);
    }

    void visitBrOn(BrOn* curr) {
      // TODO: optimize with createdTypesOrSubTypes here

      refineCast(curr);
    }
  };
};

} // anonymous namespace

Pass* createCastRefiningPass() { return new CastRefining(); }

} // namespace wasm
