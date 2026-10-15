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
// Propagate struct.get operations backwards into local sets/tees and into if
// arms that allocate structs:
//
//   1. When a struct-typed local is written multiple times and every read of it
//      (including via local.tee) is immediately consumed by an identical
//      struct.get of the same field, replace the struct local with a local of
//      the field's type and perform the struct.get at each local.set/local.tee.
//      For example:
//
//        x = new Foo(42);
//        bar(x.value, x.value);
//
//      =>
//
//        // Store the value directly.
//        x_value = (new Foo(42)).value;
//        bar(x_value, x_value);
//
//      We do this when we detect a simple situation where all the uses are just
//      gets like that. In this case, we know Heap2Local can later optimize
//      the allocation away.
//
//   2. When a struct.get consumes an if whose arm(s) allocate a struct via
//      struct.new, sink the struct.get into the if arms. For example:
//
//        (struct.get $x 3
//          (if
//            (..condition..)
//            (struct.new ..)
//            (struct.new ..)))
//
//      =>
//
//        (struct.get $x 3
//          (if
//            (..condition..)
//            (struct.new ..)
//            (struct.new ..)))
//
//      This could be done as a peephole optimization in OptimizeInstructions,
//      but it generally *increases* code size. Here we only do it when we
//      detect the proper situation as in point 1, where Heap2Local's followup
//      optimizations make it worthwhile.
//
// This disentangles shared struct locals and control-flow merges so that
// Heap2Local can optimize the underlying allocations independently.
//

#include "ir/local-graph.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

struct PropagateStructGets
  : public WalkerPass<PostWalker<PropagateStructGets>> {
  bool isFunctionParallel() override { return true; }

  // New locals created here are always defaultable (nullable when references).
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<PropagateStructGets>();
  }

  // Track the number of gets for each local, so that we can see if all gets are
  // accounted for and understood.
  std::unordered_map<Index, Index> numGets;

  // The sets for each get.
  std::unordered_map<Index, std::vector<LocalSet*>> sets;

  // The parent struct.get for each local.
  std::unordered_map<Index, std::vector<StructGet*>> getParents;

  // The parent struct.get for each tee.
  std::unordered_map<LocalSet*, StructGet*> teeParents;

  // All relevant struct.gets in the function, which means the struct.gets that
  // operate on references that fit the patterns we can optimize.
  std::vector<Expression**> structGets;

  // Check if a local index is a reference to a struct. Those are the locals we
  // try to optimize.
  bool isStructVar(Index index) {
    auto* func = getFunction();
    return func->isVar(index) && func->getLocalType(index).isStruct();
  }

  void visitLocalGet(LocalGet* curr) {
    if (isStructVar(curr->index)) {
      numGets[curr->index]++;
    }
  }

  void visitLocalSet(LocalSet* curr) {
    if (isStructVar(curr->index)) {
      sets[curr->index].push_back(curr);
    }
  }

  void visitStructGet(StructGet* curr) {
    // Avoid unreachable code, and leave atomic operations for now TODO
    if (curr->type == Type::unreachable ||
        curr->order != MemoryOrder::Unordered) {
      return;
    }

    // See if the reference is one of the patterns we recognize.
    if (auto* get = curr->ref->dynCast<LocalGet>()) {
      if (isStructVar(get->index)) {
        getParents[get->index].push_back(curr);
        structGets.push_back(getCurrentPointer());
      }
    } else if (auto* set = curr->ref->dynCast<LocalSet>()) {
      if (isStructVar(set->index)) {
        teeParents[set] = curr;
        structGets.push_back(getCurrentPointer());
      }
    } else if (auto* iff = curr->ref->dynCast<If>()) {
      if (iff->ifFalse && iff->type != Type::unreachable &&
          iff->ifTrue->type != Type::unreachable &&
          iff->ifFalse->type != Type::unreachable) {
        auto* module = getModule();
        const auto& passOptions = getPassOptions();
        if (Properties::getFallthrough(iff->ifTrue, passOptions, *module)
              ->is<StructNew>() ||
            Properties::getFallthrough(iff->ifFalse, passOptions, *module)
              ->is<StructNew>()) {
          structGets.push_back(getCurrentPointer());
        }
      }
    }
  }

  void visitFunction(Function* func) {
    if (structGets.empty()) {
      // Nothing was found to be optimizable in the walk.
      return;
    }

    auto* module = getModule();
    const auto& passOptions = getPassOptions();
    Builder builder(*module);
    LazyLocalGraph localGraph(func, module);
    std::unordered_map<Index, Index> projectedLocals;

    for (auto& [localIndex, localSets] : sets) {
      if (localSets.size() < 2) {
        continue;
      }
      auto getIt = getParents.find(localIndex);
      if (getIt == getParents.end()) {
        continue;
      }
      const auto& sgets = getIt->second;
      if (sgets.empty() || sgets.size() != numGets[localIndex]) {
        continue;
      }

      Index fieldIndex = sgets[0]->index;
      bool isSigned = sgets[0]->signed_;
      Type fieldType = sgets[0]->type;
      Type localType = fieldType.isRef() ? fieldType.with(Nullable) : fieldType;
      if (!localType.isDefaultable()) {
        continue;
      }

      bool ok = true;
      for (auto* sget : sgets) {
        if (sget->index != fieldIndex || sget->signed_ != isSigned ||
            sget->type != fieldType) {
          ok = false;
          break;
        }
      }
      if (!ok) {
        continue;
      }

      bool allSetsAreFreshAllocs = true;
      for (auto* set : localSets) {
        if (set->value->type == Type::unreachable) {
          ok = false;
          break;
        }
        if (set->isTee()) {
          allSetsAreFreshAllocs = false;
          auto teeIt = teeParents.find(set);
          if (teeIt == teeParents.end()) {
            ok = false;
            break;
          }
          auto* pget = teeIt->second;
          if (pget->index != fieldIndex || pget->signed_ != isSigned ||
              pget->type != fieldType) {
            ok = false;
            break;
          }
        } else {
          if (!set->value->is<StructNew>()) {
            allSetsAreFreshAllocs = false;
          }
          if (!set->value->type.isNonNullable() &&
              !passOptions.trapsNeverHappen) {
            ok = false;
            break;
          }
        }
      }
      if (!ok) {
        continue;
      }

      // The field value must not change between the local.set and local.get:
      // either the field is immutable, or every set writes a fresh struct.new
      // that only ever flows into this local's struct.gets.
      auto& field =
        func->getLocalType(localIndex).getHeapType().getStruct().fields[fieldIndex];
      if (field.mutable_ != Immutable && !allSetsAreFreshAllocs) {
        continue;
      }

      // If the original local is nullable and the replacement local.get will
      // not trap on null via ref.as_non_null, ensure no get can observe the
      // uninitialized default null value.
      if (func->getLocalType(localIndex).isNullable() && !fieldType.isNonNullable() &&
          !passOptions.trapsNeverHappen) {
        for (auto* sget : sgets) {
          if (localGraph.getSets(sget->ref->cast<LocalGet>())
                .contains(nullptr)) {
            ok = false;
            break;
          }
        }
        if (!ok) {
          continue;
        }
      }

      projectedLocals[localIndex] = builder.addVar(func, localType);
    }

    // Rewrite recorded struct.gets in post-order.
    for (auto** currp : structGets) {
      auto* sget = (*currp)->cast<StructGet>();
      if (auto* get = sget->ref->dynCast<LocalGet>()) {
        auto it = projectedLocals.find(get->index);
        if (it == projectedLocals.end()) {
          continue;
        }
        Index newLocal = it->second;
        Expression* rep =
          builder.makeLocalGet(newLocal, func->getLocalType(newLocal));
        if (sget->type.isNonNullable()) {
          rep = builder.makeRefAs(RefAsNonNull, rep);
        }
        *currp = rep;
      } else if (auto* set = sget->ref->dynCast<LocalSet>()) {
        auto it = projectedLocals.find(set->index);
        if (it == projectedLocals.end()) {
          continue;
        }
        Index newLocal = it->second;
        sget->ref = set->value;
        sget->finalize();
        set->index = newLocal;
        set->value = sget;
        set->makeTee(func->getLocalType(newLocal));
        Expression* rep = set;
        if (sget->type.isNonNullable()) {
          rep = builder.makeRefAs(RefAsNonNull, rep);
        }
        *currp = rep;
      } else if (auto* iff = sget->ref->dynCast<If>()) {
        iff->ifTrue = builder.makeStructGet(
          sget->index, iff->ifTrue, sget->order, sget->type, sget->signed_);
        iff->ifFalse = builder.makeStructGet(
          sget->index, iff->ifFalse, sget->order, sget->type, sget->signed_);
        iff->finalize();
        *currp = iff;
      }
    }

    // Rewrite non-tee local.sets of projected locals.
    for (auto [x, newLocal] : projectedLocals) {
      auto* sget = getParents[x][0];
      for (auto* set : sets[x]) {
        if (!set->isTee()) {
          set->value = builder.makeStructGet(sget->index,
                                             set->value,
                                             MemoryOrder::Unordered,
                                             sget->type,
                                             sget->signed_);
          set->index = newLocal;
          set->finalize();
        }
      }
    }
  }
};

} // anonymous namespace

Pass* createPropagateStructGetsPass() { return new PropagateStructGets(); }

} // namespace wasm
