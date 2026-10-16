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
// Identify when a GC reference local is always used as "data". If all the
// local.gets and local.tees of a reference local are immediately consumed by
// a struct.get, to read data from the reference, then we can optimize:
//
//    x = new Foo(42);
//    bar(x.value, x.value);
//
//  =>
//
//    // Store the value directly.
//    x_value = (new Foo(42)).value; // do the struct.get earlier, here
//    bar(x_value, x_value);
//
// More concretely, when we see all local operations look like this:
//
//    (local.set $ref ..)               # no constraint on local.set
//    (struct.get (local.tee $ref ..))  # consumed by struct.get
//    (struct.get (local.get $ref))     # consumed by struct.get
//
// Then we can reshape the code to look like this:
//
//    (local.set $ref_field (struct.get (..))  # store data in local
//    (local.tee $ref_field (struct.get (..))  # store data in local, get it
//    (local.get $ref_field))                  # get data from local
//
// This is basically a simple form of escape analysis, like Heap2Local, but
// which handles a far more restricted case (where the reference is immediately
// struct.get-ed). The benefit of this pass is that our restricted case can
// handle overlapping allocations, like this:
//
//    x = new Foo(42);
//    if (condition) x = new Foo(1337);
//    bar(x.value, x.value);
//
// Heap2Local cannot optimize this due to the overlapping live ranges (it sees
// the x.value operations are not exclusive to any single allocation). But this
// pass can optimize into this:
//
//    x_value = (new Foo(42)).value;
//    if (condition) x_value = (new Foo(1337)).value;
//    bar(x_value, x_value);
//
// The live ranges of the reference local no longer overlap (only of the data-
// storing local), so Heap2Local can handle both those allocations.
//

#include "ir/bits.h"
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<PropagateStructGets>();
  }

  // Track the number of gets for each local, so that we can see if all gets are
  // consumed by struct.gets.
  std::unordered_map<Index, Index> numGets;

  // The sets for each local index.
  std::unordered_map<Index, std::vector<Expression**>> sets;

  // The parent struct.gets for each local index's gets.
  std::unordered_map<Index, std::vector<StructGet*>> getParents;

  // The parent struct.get for each tee.
  std::unordered_map<LocalSet*, StructGet*> teeParents;

  // All relevant struct.gets in the function. We gather these during the walk,
  // and then determine which can actually be optimized (the final decision is
  // stored in optimizedLocals, for each local, below).
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
      sets[curr->index].push_back(getCurrentPointer());
    }
  }

  void visitStructGet(StructGet* curr) {
    // Avoid unreachable code, and leave atomic operations for now TODO
    if (curr->type == Type::unreachable ||
        curr->order != MemoryOrder::Unordered) {
      return;
    }

    // See if the reference is one of the patterns we recognize.
    // TODO fallthrough, but careful of br_if which can escape the value
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
    }
    // TODO: handle more things flowing into struct.get, like an If
  }

  void visitFunction(Function* func) {
    if (structGets.empty()) {
      // Nothing was found to be optimizable in the walk.
      return;
    }

    auto* module = getModule();
    Builder builder(*module);
    LazyLocalGraph localGraph(func, module);

    // For each optimized local, maps each used field index to the new local
    // index that stores that field.
    std::unordered_map<Index, std::map<Index, Index>> optimizedLocals;

    for (auto& [localIndex, localSets] : sets) {
      if (localSets.size() < 2) {
        // We only care about the case of 2 or more sets for a local: otherwise,
        // Heap2Local can handle things perfectly for a single set (and zero is
        // trivially trapping).
        continue;
      }

      auto getIt = getParents.find(localIndex);
      if (getIt == getParents.end()) {
        // No struct.get parents for this local's gets.
        continue;
      }

      // Check if each local.get is consumed by a struct.get, which is the case
      // if the counts match. If so, then we understand all the gets, and this
      // situation is the pattern we optimize: each local.get is consumed
      // by a struct.get.
      const auto& getStructGets = getIt->second;
      // There must be a struct.get, if we added one for this local.
      assert(!getStructGets.empty());
      if (getStructGets.size() != numGets[localIndex]) {
        continue;
      }

      // Gather all the field indexes read from this local.
      std::set<Index> usedFields;
      for (auto* sget : getStructGets) {
        usedFields.insert(sget->index);
      }

      // Analyze the sets to the local. Things are especially simple if they all
      // store a fresh unescaping allocation, that is, a struct.new which does
      // not flow out through a tee.
      bool ok = true;
      bool allSetsAreUnescapingAllocs = true;
      for (auto** setp : localSets) {
        auto* set = (*setp)->cast<LocalSet>();
        if (set->value->type == Type::unreachable) {
          // Stop on dead code.
          ok = false;
          break;
        }
        if (set->isTee()) {
          allSetsAreUnescapingAllocs = false;
          auto teeIt = teeParents.find(set);
          if (teeIt == teeParents.end()) {
            // This tee does not feed into a struct.get, so the allocation(s)
            // might escape.
            ok = false;
            break;
          }
          usedFields.insert(teeIt->second->index);
        } else {
          // Not a tee: a normal local.set.
          if (!set->value->is<StructNew>()) {
            allSetsAreUnescapingAllocs = false;
          }
        }
      }
      if (!ok) {
        continue;
      }

      // Each used field's value must not change between the local.set and
      // local.get: either the field is immutable, or every set writes a fresh
      // struct.new that only ever flows into this local's struct.gets. (Note
      // that struct.sets are ruled out by the fact that we analyzed all
      // local.get/tee operations, and all flowed into struct.get.)
      auto& fields =
        func->getLocalType(localIndex).getHeapType().getStruct().fields;
      if (!allSetsAreUnescapingAllocs) {
        for (auto fieldIndex : usedFields) {
          if (fields[fieldIndex].mutable_ != Immutable) {
            ok = false;
            break;
          }
        }
        if (!ok) {
          continue;
        }
      }

      // If the original local is nullable, then the struct.gets that we add may
      // end up reading it and trapping:
      //
      //   x = getRef();
      //   foo();
      //   bar(x.value, x.value);
      //
      // =>
      //
      //   x_value = getRef().value;
      //   foo();
      //   bar(x_value, x_value);
      //
      // Note how the `.value` (the struct.get) happens before `foo()`,
      // after the optimization, so we may have moved a trap around here. It is
      // not enough to check trapsNeverHappen here, since we are moving the
      // trap earlier, after `foo()` which might have prevented us from reaching
      // the trap. We can rule this problem out by seeing that only non-nullable
      // values are written to the local (it is fine for the local itself to be
      // nullable, see below).
      for (auto** setp : localSets) {
        auto* set = (*setp)->cast<LocalSet>();
        if (set->value->type.isNullable()) {
          ok = false;
          break;
        }
      }
      if (!ok) {
        continue;
      }

      // Finally, if the local is nullable, see if the null default value can
      // actually be read.
      if (func->getLocalType(localIndex).isNullable()) {
        for (auto* sget : getStructGets) {
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

      // Success! The pattern fits, prepare to optimize this local by adding a
      // local to store the value of each used field.
      for (auto fieldIndex : usedFields) {
        optimizedLocals[localIndex][fieldIndex] =
          builder.addVar(func, fields[fieldIndex].type);
      }
    }

    auto getFieldFromLocal =
      [&](Index localIndex, Index fieldIndex, bool signed_) -> Expression* {
      auto& field = func->getLocalType(localIndex)
                      .getHeapType()
                      .getStruct()
                      .fields[fieldIndex];
      auto newLocal = optimizedLocals[localIndex][fieldIndex];
      Expression* ret =
        builder.makeLocalGet(newLocal, func->getLocalType(newLocal));
      return Bits::makePackedFieldGet(ret, field, signed_, *module);
    };

    auto makeFieldSets = [&](LocalSet* set,
                             StructGet* teeParent = nullptr) -> Expression* {
      auto localIndex = set->index;
      auto localType = func->getLocalType(localIndex);
      auto& fields = localType.getHeapType().getStruct().fields;
      std::vector<Expression*> list = {
        builder.makeLocalSet(localIndex, set->value)};
      for (auto [fieldIndex, newLocal] : optimizedLocals[localIndex]) {
        auto& field = fields[fieldIndex];
        auto* sget =
          builder.makeStructGet(fieldIndex,
                                builder.makeLocalGet(localIndex, localType),
                                MemoryOrder::Unordered,
                                field.type,
                                false);
        list.push_back(builder.makeLocalSet(newLocal, sget));
      }
      if (teeParent) {
        list.push_back(
          getFieldFromLocal(localIndex, teeParent->index, teeParent->signed_));
      }
      return builder.makeBlock(list);
    };

    // Rewrite recorded struct.gets in post-order.
    for (auto** currp : structGets) {
      auto* sget = (*currp)->cast<StructGet>();
      if (auto* get = sget->ref->dynCast<LocalGet>()) {
        if (!optimizedLocals.contains(get->index)) {
          continue;
        }

        // Replace (struct.get (local.get)) with a local.get of the field, which
        // is now in a local directly.
        *currp = getFieldFromLocal(get->index, sget->index, sget->signed_);
      } else if (auto* tee = sget->ref->dynCast<LocalSet>()) {
        if (!optimizedLocals.contains(tee->index)) {
          continue;
        }

        // Replace (struct.get (local.tee (REF))) with a block that sets the
        // local, copies all used fields into their locals, and returns the
        // tee'd field.
        *currp = makeFieldSets(tee, sget);
      }
    }

    // Rewrite non-tee local.sets of optimized locals: all local.sets now also
    // store the used fields.
    for (auto& [x, _] : optimizedLocals) {
      for (auto** setp : sets[x]) {
        auto* set = (*setp)->cast<LocalSet>();
        if (!set->isTee()) {
          *setp = makeFieldSets(set);
        }
      }
    }
  }
};

} // anonymous namespace

Pass* createPropagateStructGetsPass() { return new PropagateStructGets(); }

} // namespace wasm
