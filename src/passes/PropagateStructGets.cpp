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
// In effect we "propagate" struct.gets to earlier positions.
//
// We could in principle handle any input to local.set/local.tee, not just
// struct.news. However, we only guarantee that Heap2Local will remove an
// allocation when we do see struct.new, and when we do not remove an
// allocation, we are basically moving struct.gets to an earlier point in time,
// which may or may not be faster. Only handling struct.news leaves us in the
// simple case where all the allocations are removed by Heap2Local.
//
// This pass is basically a simple form of escape analysis, like Heap2Local, but
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
// Note that Heap2Local could safely optimize in this example, even before our
// changes: while the `x.value` operations are not exclusive to allocations, the
// live ranges of the allocations join exactly there - they do not overlap in a
// dangerous way. Here is an actually dangerous example:
//
//   (local.set $a
//     (struct.new $struct
//       (..value..)
//     )
//   )
//   (struct.get $ref 0
//     (select
//       (local.get $a)
//       (local.tee $a
//         (struct.new_default $struct)
//       )
//       (..condition..)
//     )
//   )
//
// The struct.get at the end may read ..value.. from set at the top, or it may
// read the default value from the tee at the bottom. But here we cannot
// optimize while using a single local `a_value` because of the live range
// overlap: both allocations are alive as the select executes, and it picks
// between them, so we must store both of them somewhere in the interm.
// Detecting such overlaps is not trivial as it involves locals as well as the
// wasm value stack, which is why this pass is useful, as it handles common and
// obviously-optimizable cases.
//
// TODO: document struct.set
//

#include "ir/bits.h"
#include "ir/eh-utils.h"
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

  // Track the number of gets for each local, so that we can see if all the
  // local.gets are consumed by struct.gets.
  std::unordered_map<Index, Index> numGets;

  // The sets for each local index. We store this in an ordered set so that
  // later iteration is deterministic.
  std::map<Index, std::vector<Expression**>> sets;

  // The parent struct.get/sets for each local index's local.gets (for us to
  // optimize, each local.get must have such a parent).
  std::unordered_map<Index, std::vector<Expression*>> getParents;

  // The parent struct.get for each tee (for us to optimize, each tee must have
  // such a parent).
  std::unordered_map<LocalSet*, Expression*> teeParents;

  // All the relevant struct.gets/sets. We gather these during the walk,
  // and then determine which can actually be optimized (the final decision is
  // stored in optimizedLocals, for each local, below).
  std::vector<Expression**> structOperations;

  // Checks if a local index is relevant for us: if it refers to a struct.
  bool isStructLocal(Index index) {
    auto type = getFunction()->getLocalType(index);
    return type.isRef() && type.getHeapType().isStruct();
  }

  void visitLocalGet(LocalGet* curr) {
    if (isStructLocal(curr->index)) {
      numGets[curr->index]++;
    }
  }

  void visitStructGet(StructGet* curr) { handleStructOperation(curr); }
  void visitStructSet(StructSet* curr) { handleStructOperation(curr); }

  template<typename T> void handleStructOperation(T* curr) {
    // Avoid unreachable code.
    if (curr->type == Type::unreachable) {
      return;
    }

    // See if the reference is one of the patterns we recognize.
    // TODO fallthrough, but careful of br_if which can escape the value
    if (auto* get = curr->ref->template dynCast<LocalGet>()) {
      getParents[get->index].push_back(curr);
      structOperations.push_back(getCurrentPointer());
    } else if (auto* tee = curr->ref->template dynCast<LocalSet>()) {
      // TODO: Handle a tee for struct.set. This is a little complex to handle
      // below, and not really needed, since
      //
      //   (struct.set $A k
      //     (struct.new $A ..)
      //     (value)
      //   )
      //
      // can be folded into a single struct.new (that is, we are writing all the
      // fields, then writing an additional one, and other passes make us do
      // them all at once anyhow).
      if (!curr->is<StructSet>()) {
        teeParents[tee] = curr;
        structOperations.push_back(getCurrentPointer());
      }
    }
    // TODO: handle more things flowing into struct.get, like an If
  }

  bool hasTry = false;

  void visitTry(Try* curr) { hasTry = true; }

  void visitFunction(Function* func) {
    if (structOperations.empty()) {
      // Nothing was found to be optimizable in the walk.
      return;
    }

    pickLocalsToOptimize(func);

    if (!optimizedLocals.empty()) {
      optimize(func);
    }
  }

  // For each optimized local, maps each used field index to the new local
  // index that stores that field. Note that the inner map is sorted, both for
  // deterministic ordering when we create new locals, and also because the
  // number of used fields tends to be small (so hashing is overkill).
  std::unordered_map<Index, std::map<Index, Index>> optimizedLocals;

  void pickLocalsToOptimize(Function* func) {
    auto* module = getModule();
    Builder builder(*module);
    LazyLocalGraph localGraph(func, module);

    for (auto& [localIndex, localSets] : sets) {
      if (localSets.size() < 2) {
        // We only care about the case of 2 or more sets for a local: otherwise,
        // Heap2Local can handle things perfectly for a single set.
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
      const auto& getStructOperations = getIt->second;
      // There must be a struct.get, if we added one for this local.
      assert(!getStructOperations.empty());
      if (getStructOperations.size() != numGets[localIndex]) {
        continue;
      }

      auto getIndex = [](Expression* curr) {
        if (auto* get = curr->dynCast<StructGet>()) {
          return get->index;
        } else if (auto* set = curr->dynCast<StructSet>()) {
          return set->index;
        } else {
          WASM_UNREACHABLE("bad op");
        }
      };

      // Gather all the field indexes read from this local, first from the
      // local.gets, and later from the tees.
      std::set<Index> usedFields;
      for (auto* op : getStructOperations) {
        usedFields.insert(getIndex(op));
      }

      // Analyze the sets to the local: a struct.new must be written in each.
      bool ok = true;
      for (auto** setp : localSets) {
        auto* set = (*setp)->cast<LocalSet>();
        if (set->value->type == Type::unreachable) {
          // Stop on dead code.
          ok = false;
          break;
        }
        if (!set->value->is<StructNew>()) {
          // Stop on writing an unknown reference that is not a struct.new.
          ok = false;
          break;
        }
        if (set->isTee()) {
          auto teeIt = teeParents.find(set);
          if (teeIt == teeParents.end()) {
            // This tee does not feed into a struct.get/set, so the
            // allocation(s) might escape.
            ok = false;
            break;
          }
          usedFields.insert(getIndex(teeIt->second));
        }
      }
      if (!ok) {
        continue;
      }

      // Finally, if the initial value of the local from the function entry is
      // used, do not optimize. For a var, that means the default of zero, which
      // will trap. TODO tnh?
      for (auto* op : getStructOperations) {
        Expression* ref;
        if (auto* get = op->dynCast<StructGet>()) {
          ref = get->ref;
        } else if (auto* set = op->dynCast<StructSet>()) {
          ref = set->ref;
        } else {
          WASM_UNREACHABLE("bad op");
        }
        if (localGraph.getSets(ref->cast<LocalGet>()).contains(nullptr)) {
          ok = false;
          break;
        }
      }
      if (!ok) {
        continue;
      }

      // Success! The pattern fits, prepare to optimize this local by adding a
      // local to store the value of each used field.
      auto& fields =
        func->getLocalType(localIndex).getHeapType().getStruct().fields;
      for (auto fieldIndex : usedFields) {
        optimizedLocals[localIndex][fieldIndex] =
          builder.addVar(func, fields[fieldIndex].type);
      }
    }
  }

  void optimize(Function* func) {
    struct Optimizer : PostWalker<Optimizer> {
      PropagateStructGets& parent;

      Optimizer(PropagateStructGets& parent) : parent) {}

      void visitLocalSet(LocalSet* curr) {
        if (!curr->isTee() && parent.optimizedLocals.contains(curr->index)) {
          // local.set now stores the used fields (tee is handled below).
          replaceCurrent(makeFieldSets(tee));
        }
      }

      void visitStructGet(StructGet* curr) {
        if (auto* get = curr->ref->dynCast<LocalGet>()) {
          if (parent.optimizedLocals.contains(get->index)) {
            // struct.get of a local.get reads the field from a new local.
            replaceCurrent(getFieldFromLocal(get->index, curr->index, curr->signed_));
          }
        } else if (auto* tee = curr->ref->dynCast<LocalSet>()) {
          if (parent.optimizedLocals.contains(tee->index)) {
            // struct.get of a local.tee first writes the fields, then reads.
            *currp = makeFieldSets(tee, sget);
          }
        }
      }

      void visitStructSet(StructGet* curr) {
        if (auto* get = curr->ref->dynCast<LocalGet>()) {
          if (parent.optimizedLocals.contains(get->index)) {
            // struct.set of a local.get writes the field into a new local.
            replaceCurrent(setFieldToLocal(get->index, curr->index, curr->value));
          }
        }
      }

      Expression* getFieldFromLocal(Index localIndex, Index fieldIndex, bool signed_) {
        auto& field = getFunction()->getLocalType(localIndex)
                        .getHeapType()
                        .getStruct()
                        .fields[fieldIndex];
        // Read from the appropriate new local, handling sign extension as needed.
        auto newLocal = parent.optimizedLocals[localIndex][fieldIndex];
        Builder builder(*getModule());
        Expression* ret =
          builder.makeLocalGet(newLocal, getFunction()->getLocalType(newLocal));
        return Bits::makePackedFieldGet(ret, field, signed_, *module);
      }

      Expression* setFieldToLocal(Index localIndex, Index fieldIndex, Expression* value) {
        auto& field = getFunction()->getLocalType(localIndex)
                        .getHeapType()
                        .getStruct()
                        .fields[fieldIndex];
        // Read from the appropriate new local, handling sign extension as needed.
        auto newLocal = parent.optimizedLocals[localIndex][fieldIndex];
        Builder builder(*getModule());
        return builder.makeLocalSet(newLocal, value);
      }

      Expression* makeFieldSets(LocalSet* set,
                               StructGet* teeParent = nullptr) {
        auto localIndex = set->index;
        auto localType = getFunction()->getLocalType(localIndex);
        auto& fields = localType.getHeapType().getStruct().fields;

        // Store the reference, then store struct.gets of all used fields in the
        // new locals.
        Builder builder(*getModule());
        std::vector<Expression*> list = {
          builder.makeLocalSet(localIndex, set->value)};
        for (auto [fieldIndex, newLocal] : parent.optimizedLocals[localIndex]) {
          auto& field = fields[fieldIndex];
          // Note that the sign does not matter here: we just store the bits, and
          // will handle the sign when reading back out (like in Heap2Local).
          auto* sget =
            builder.makeStructGet(fieldIndex,
                                  builder.makeLocalGet(localIndex, localType),
                                  MemoryOrder::Unordered,
                                  field.type,
                                  false);
          list.push_back(builder.makeLocalSet(newLocal, sget));
        }

        // Finally, if this is a tee, then it was consumed by a struct.get, and we
        // can read that field and return it.
        if (teeParent) {
          list.push_back(
            getFieldFromLocal(localIndex, teeParent->index, teeParent->signed_));
        }
        return builder.makeBlock(list);
      }
    } optimizer;
    optimizer.setModule(getModule());
    optimizer.walkFunction(func);

    if (hasTry) {
      EHUtils::handleBlockNestedPops(func, *getModule());
    }
  }
};

} // anonymous namespace

Pass* createPropagateStructGetsPass() { return new PropagateStructGets(); }

} // namespace wasm
