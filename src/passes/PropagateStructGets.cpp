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
// Identify when a GC reference local is always read from using struct.get, as
// opposed to operations on the reference itself (like passing it out, or doing
// ref.eq). When all local.gets are immediately consumed by struct.gets, then
// the GC allocation is basically used as data, and we can store that data
// directly, simplifying things. More concretely:
//
//   1. When a struct-typed local is written and every read of it
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
//      the allocation away. That is, we are detecting a simple case where
//      nothing escapes and things are easy to optimize, and we handle it
//      directly. This is simpler than making Heap2Local able to reason about
//      groups of allocations and their possibly overlapping livenesses, in
//      situations like this:
//
//        x = new Foo(42);
//        if (condition) x = new Foo(1337);
//        bar(x.value, x.value);
//
//      The allocations here have overlapping live ranges, and Heap2Local
//      cannot handle them (it sees the x.value operations are not exclusive to
//      any single allocation). After we simplify things in this pass, the
//      situation becomes trivial for Heap2Local, as the allocations do not
//      overlap:
//
//        x_value = (new Foo(42)).value;
//        if (condition) x_value = (new Foo(1337)).value;
//        bar(x_value, x_value);
//
//      TODO verify in tests
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
// Heap2Local can optimize the underlying allocations independently. Another way
// to look at it is that it handles a simple case of escape analysis, the easy
// situation where the heap allocation is just used as data - we immediately
// struct.get data from it, and never use it otherwise, not in ref.eq or
// anything else.
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<PropagateStructGets>();
  }

  // Track the number of gets for each local, so that we can see if all gets are
  // accounted for and understood.
  std::unordered_map<Index, Index> numGets;

  // The sets for each local index.
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
    // TODO fallthrough
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
      // TODO Handle arbitrary nesting here, including leading to gets/tees.
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
    Builder builder(*module);
    LazyLocalGraph localGraph(func, module);
    std::unordered_map<Index, Index> projectedLocals;

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

      // Veirfy all the struct.gets operate on the same field in the struct, and
      // in the same way.
      // TODO: handle multiple field indexes, and mixtures of signed/unsigned
      Index fieldIndex = getStructGets[0]->index;
      bool isSigned = getStructGets[0]->signed_;
      Type fieldType = getStructGets[0]->type;

      bool ok = true;
      for (auto* sget : getStructGets) {
        if (sget->index != fieldIndex || sget->signed_ != isSigned ||
            sget->type != fieldType) {
          ok = false;
          break;
        }
      }
      if (!ok) {
        continue;
      }

      // Analyze the sets to the local. Things are especially simple if they all
      // store a fresh unescaping allocation, that is, a struct.new which does
      // not flow out through a tee.
      bool allSetsAreUnescapingAllocs = true;
      for (auto* set : localSets) {
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
          // Check if the parent struct.get is compatible with all the ones
          // before, that we checked for the parents of local.gets.
          auto* pget = teeIt->second;
          if (pget->index != fieldIndex || pget->signed_ != isSigned ||
              pget->type != fieldType) {
            ok = false;
            break;
          }
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

      // The field value must not change between the local.set and local.get:
      // either the field is immutable, or every set writes a fresh struct.new
      // that only ever flows into this local's struct.gets.
      auto& field = func->getLocalType(localIndex)
                      .getHeapType()
                      .getStruct()
                      .fields[fieldIndex];
      if (field.mutable_ != Immutable && !allSetsAreUnescapingAllocs) {
        continue;
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
      for (auto* set : localSets) {
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
      // local to store the value in its field.
      projectedLocals[localIndex] = builder.addVar(func, fieldType);
    }

    // Rewrite recorded struct.gets in post-order.
    for (auto** currp : structGets) {
      auto* sget = (*currp)->cast<StructGet>();
      if (auto* get = sget->ref->dynCast<LocalGet>()) {
        auto it = projectedLocals.find(get->index);
        if (it == projectedLocals.end()) {
          continue;
        }

        // Replace (struct.get (local.get)) with a local.get of the field, which
        // is now in a local directly.
        Index newLocal = it->second;
        *currp =
          builder.makeLocalGet(newLocal, func->getLocalType(newLocal));
      } else if (auto* tee = sget->ref->dynCast<LocalSet>()) {
        auto it = projectedLocals.find(tee->index);
        if (it == projectedLocals.end()) {
          continue;
        }

        // Replace (struct.get (local.tee (REF))) with
        // (local.tee (struct.get (REF))). Before we stashed the ref in a local,
        // and now we stash the field.
        Index newLocal = it->second;
        sget->ref = tee->value;
        sget->finalize();
        tee->index = newLocal;
        tee->value = sget;
        tee->makeTee(func->getLocalType(newLocal));
        *currp = tee;
      } else if (auto* iff = sget->ref->dynCast<If>()) {
        // Replace (struct.get (if .. (A) (B))) with
        // (if .. (struct.get (A)) (struct.get (B))). This avoids an overlapping
        // live range for the allocations in the If arms.
        iff->ifTrue = builder.makeStructGet(
          sget->index, iff->ifTrue, sget->order, sget->type, sget->signed_);
        iff->ifFalse = builder.makeStructGet(
          sget->index, iff->ifFalse, sget->order, sget->type, sget->signed_);
        iff->finalize();
        *currp = iff;
      }
    }

    // Rewrite non-tee local.sets of projected locals: all local.sets now store
    // the field.
    for (auto [x, newLocal] : projectedLocals) {
      // All the struct.gets are the same, so it is enough to look at the first
      // and copy it.
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
