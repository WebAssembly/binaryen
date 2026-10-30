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
// Simple multi-allocation escape analysis, aiming to cleanly separate multiple
// allocations to a single local.
//
// This pass identifies a simple case of refs not escaping, like Heap2Local, but
// allowing more than a single allocation (struct.new), which is better, but
// which handles a far simpler-to-identify situation, which is worse. To see the
// motivation, consider overlapping allocations like this:
//
//    x = new Foo(42);
//    if (condition) x = new Foo(1337);
//    else x.value = -1;
//    bar(x.value, x.value);
//
// Heap2Local cannot optimize this due to the overlapping live ranges (it sees
// some x.value operations are not exclusive to any single allocation). But this
// pass can optimize into this:
//
//    x_value = (new Foo(42)).value;
//    if (condition) x_value = (new Foo(1337)).value;
//    else x_value = -1;
//    bar(x_value, x_value);
//
// Note how we now operate on x_value, a new local with data. Basically, each
// struct.get/struct.set is turned into an operation on that new local. This is
// safe despite the multiple allocations because the local x is always used
// immediately, as data: rather than store a reference, we can just focus on the
// data. That is, each struct.new just writes a bunch of fields, and it all
// could have been replaced with a single allocation up front and struct.sets in
// all other places. After verifying that nothing observes x as a reference (no
// ref.eq), and it does not escape, we can optimize this. Heap2Local will then
// see 'untangled' allocations, each one immediately consumed, and remove them
// all.
//
// Note that Heap2Local could safely optimize in this example, even before our
// changes: while the `x.value` operations are not exclusive to allocations, the
// live ranges of the allocations join exactly there - they do not overlap in a
// dangerous way. But here is an actually dangerous example:
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
// between them, so we must store both of them somewhere in the interim.
// Detecting such overlaps is not trivial as it involves locals as well as the
// wasm value stack, which is why this pass is useful, as it handles common and
// obviously-optimizable cases.
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

struct HeapUntangling : public WalkerPass<PostWalker<HeapUntangling>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<HeapUntangling>();
  }

  // Information about a local index, used to decide whether we can optimize.
  struct LocalInfo {
    // The number of gets for the local, tracked so that we can see if all the
    // local.gets are consumed by struct.get/sets.
    Index numGets = 0;

    // The number of sets for the local, tracked as we only optimize when we see
    // 2 or more local.sets (a single one is trivially optimized by Heap2Local,
    // so we would be doing pointless work).
    Index numSets = 0;

    // The number of tees for the local, tracked for the same reason as gets:
    // they flow out the reference, so we must see them consumed by struct
    // gets/sets.
    Index numTees = 0;

    // All struct.get/struct.set operations that read a get/tee of this local.
    std::vector<Expression*> structOperations;

    // Certain conditions prevent us from optimizing.
    bool unoptimizable = false;
  };

  // For each local index, its info.
  std::vector<LocalInfo> localInfos;

  // Checks if a local index is relevant for us: if it refers to a struct.
  bool isStructLocal(Index index) {
    auto type = getFunction()->getLocalType(index);
    return type.isRef() && type.getHeapType().isStruct();
  }

  void visitLocalGet(LocalGet* curr) {
    if (isStructLocal(curr->index)) {
      localInfos[curr->index].numGets++;
    }
  }

  void visitLocalSet(LocalSet* curr) {
    if (isStructLocal(curr->index)) {
      localInfos[curr->index].numSets++;
      if (curr->isTee()) {
        localInfos[curr->index].numTees++;
      }
      // All sets must write a struct.new, otherwise we cannot analyze this
      // local.
      if (!curr->value->is<StructNew>()) {
        localInfos[curr->index].unoptimizable = true;
      }
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
      localInfos[get->index].structOperations.push_back(curr);
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
      if (!curr->template is<StructSet>()) {
        localInfos[tee->index].structOperations.push_back(curr);
      }
    }
    // TODO: handle more things flowing into struct.get, like an If
  }

  void doWalkFunction(Function* func) {
    localInfos.resize(func->getNumLocals());

    WalkerPass<PostWalker<HeapUntangling>>::doWalkFunction(func);

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

    for (Index localIndex = 0; localIndex < localInfos.size(); ++localIndex) {
      auto& info = localInfos[localIndex];
      if (info.unoptimizable) {
        continue;
      }

      if (info.numSets < 2) {
        // We only care about the case of 2 or more sets for a local: otherwise,
        // Heap2Local can handle things perfectly for a single set.
        continue;
      }

      // Check if each local.get is consumed by a struct.get/set, which is the
      // case if the counts match: the sum of local.gets/local.tees (things
      // that flow out the reference) must match the number of struct.gets/sets
      // (things that consume the reference).
      if (info.numGets + info.numTees != info.structOperations.size()) {
        continue;
      }

      // Finally, if the initial value of the local from the function entry is
      // used, do not optimize. For a var, that means the default of zero, which
      // will trap. TODO tnh?
      bool ok = true;
      for (auto* op : info.structOperations) {
        Expression* ref;
        if (auto* get = op->dynCast<StructGet>()) {
          ref = get->ref;
        } else if (auto* set = op->dynCast<StructSet>()) {
          ref = set->ref;
        } else {
          WASM_UNREACHABLE("bad op");
        }
        if (auto* get = ref->dynCast<LocalGet>()) {
          if (localGraph.getSets(get).contains(nullptr)) {
            ok = false;
            break;
          }
        }
      }
      if (!ok) {
        continue;
      }

      // We can optimize!

      // Gather all the struct field indexes read from this local.
      std::set<Index> usedFields;
      for (auto* op : info.structOperations) {
        usedFields.insert(getFieldIndex(op));
      }

      // Allocate new locals to store each field.
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
      HeapUntangling& parent;

      Optimizer(HeapUntangling& parent) : parent(parent) {}

      void visitLocalSet(LocalSet* curr) {
        if (!curr->isTee() && parent.optimizedLocals.contains(curr->index)) {
          // local.set now stores the used fields (tee is handled below).
          replaceCurrent(makeFieldSets(curr));
        }
      }

      void visitStructGet(StructGet* curr) {
        if (auto* get = curr->ref->dynCast<LocalGet>()) {
          if (parent.optimizedLocals.contains(get->index)) {
            // struct.get of a local.get reads the field from a new local.
            replaceCurrent(
              getFieldFromLocal(get->index, curr->index, curr->signed_));
          }
        } else if (auto* tee = curr->ref->dynCast<LocalSet>()) {
          if (parent.optimizedLocals.contains(tee->index)) {
            // struct.get of a local.tee first writes the fields, then reads.
            replaceCurrent(makeFieldSets(tee, curr));
          }
        }
      }

      void visitStructSet(StructSet* curr) {
        if (auto* get = curr->ref->dynCast<LocalGet>()) {
          if (parent.optimizedLocals.contains(get->index)) {
            // struct.set of a local.get writes the field into a new local.
            replaceCurrent(
              setFieldToLocal(get->index, curr->index, curr->value));
          }
        }
      }

      Expression*
      getFieldFromLocal(Index localIndex, Index fieldIndex, bool signed_) {
        auto& field = getFunction()
                        ->getLocalType(localIndex)
                        .getHeapType()
                        .getStruct()
                        .fields[fieldIndex];
        // Read from the appropriate new local, handling sign extension as
        // needed.
        auto newLocal = parent.optimizedLocals[localIndex][fieldIndex];
        Builder builder(*getModule());
        Expression* ret =
          builder.makeLocalGet(newLocal, getFunction()->getLocalType(newLocal));
        return Bits::makePackedFieldGet(ret, field, signed_, *getModule());
      }

      Expression*
      setFieldToLocal(Index localIndex, Index fieldIndex, Expression* value) {
        // Write to the appropriate new local.
        auto newLocal = parent.optimizedLocals[localIndex][fieldIndex];
        Builder builder(*getModule());
        return builder.makeLocalSet(newLocal, value);
      }

      Expression* makeFieldSets(LocalSet* set, StructGet* teeParent = nullptr) {
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
          // Note that the sign does not matter here: we just store the bits,
          // and will handle the sign when reading back out (like in
          // Heap2Local).
          auto* sget =
            builder.makeStructGet(fieldIndex,
                                  builder.makeLocalGet(localIndex, localType),
                                  MemoryOrder::Unordered,
                                  field.type,
                                  false);
          list.push_back(builder.makeLocalSet(newLocal, sget));
        }

        // Finally, if this is a tee, then it was consumed by a struct.get, and
        // we can read that field and return it.
        if (teeParent) {
          list.push_back(getFieldFromLocal(
            localIndex, teeParent->index, teeParent->signed_));
        }
        return builder.makeBlock(list);
      }
    } optimizer(*this);
    optimizer.setModule(getModule());
    optimizer.walkFunction(func);
  }

  // Given a struct.get or struct.set, return the field index.
  Index getFieldIndex(Expression* curr) {
    if (auto* get = curr->dynCast<StructGet>()) {
      return get->index;
    } else if (auto* set = curr->dynCast<StructSet>()) {
      return set->index;
    } else {
      WASM_UNREACHABLE("bad op");
    }
  };
};

} // anonymous namespace

Pass* createHeapUntanglingPass() { return new HeapUntangling(); }

} // namespace wasm
