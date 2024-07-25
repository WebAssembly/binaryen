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
// Optimize away trivial tuples. When values are bundled together in a tuple, we
// are limited in how we can optimize then in the various local-related passes,
// like this:
//
//  (local.set $tuple
//    (tuple.make 3 (A) (B) (C)))
//  (use
//    (tuple.extract 3 0
//      (local.get $tuple)))
//
// If there are no other uses, then we just need one of the three elements. By
// lowing them to three separate locals, other passes can remove the other two.
//
// Specifically, this pass seeks out tuple locals that have these properties:
//
//  * They are always written either a tuple.make or another tuple local with
//    these properties.
//  * They are always used either in tuple.extract or they are copied to another
//    tuple local with these properties.
//
// The set of those tuple locals can be easily optimized into individual locals,
// as the tuple does not "escape" into, say, a return value.
//
// TODO: Blocks etc. might be handled here, but it's not clear if we want to:
//       there are situations where multivalue leads to smaller code using
//       those constructs. Atm this pass should only remove things that are
//       definitely worth lowering.
//

#include <pass.h>
#include <support/unique_deferring_queue.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

struct TupleOptimization : public WalkerPass<PostWalker<TupleOptimization>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TupleOptimization>();
  }

  // Track the number of uses for each tuple local. We consider a use as a
  // local.get, a set, or a tee. A tee counts as two uses (since it both sets
  // and gets, and so we must see that it is both used and uses properly).
  std::vector<Index> uses;

  // Tracks which tuple local uses are valid, that is, follow the properties
  // above. If we have more uses than valid uses then we must have an invalid
  // one, and the local cannot be optimized.
  std::vector<Index> validUses;

  // When one tuple local copies the value of another, we need to track the
  // index that was copied, as if the source ends up bad then the target is bad
  // as well.
  //
  // This is a symmetrical map, that is, we consider copies to work both ways:
  //
  //    x \in copiedIndexed[y]    <==>    y \in copiedIndexed[x]
  //
  std::vector<std::unordered_set<Index>> copiedIndexes;

  void doWalkFunction(Function* func) {
    // If tuples are not enabled, or there are no tuple locals, then there is no
    // work to do.
    if (!getModule()->features.hasMultivalue()) {
      return;
    }
    bool hasTuple = false;
    for (auto var : func->vars) {
      if (var.isTuple()) {
        hasTuple = true;
        break;
      }
    }
    if (!hasTuple) {
      return;
    }

    // Prepare global data structures before we collect info.
    auto numLocals = func->getNumLocals();
    uses.resize(numLocals);
    validUses.resize(numLocals);
    copiedIndexes.resize(numLocals);

    // Walk the code to collect info.
    super::doWalkFunction(func);

    // Analyze and optimize.
    optimize(func);
  }

  void visitLocalGet(LocalGet* curr) {
    if (curr->type.isTuple()) {
      uses[curr->index]++;
    }
  }

  void visitLocalSet(LocalSet* curr) {
    if (getFunction()->getLocalType(curr->index).isTuple()) {
      // See comment above about tees (we consider their set and get each a
      // separate use).
      uses[curr->index] += curr->isTee() ? 2 : 1;
      auto* value = curr->value;

      // We need the input to the local to be another such local (from a tee, or
      // a get), or a tuple.make.
      if (auto* tee = value->dynCast<LocalSet>()) {
        assert(tee->isTee());
        // We don't want to count anything as valid if the inner tee is
        // unreachable. In that case the outer tee is also unreachable, of
        // course, and in fact they might not even have the same tuple type or
        // the inner one might not even be a tuple (since we are in unreachable
        // code, that is possible). We could try to optimize unreachable tees in
        // some cases, but it's simpler to let DCE simplify the code first.
        if (tee->type != Type::unreachable) {
          validUses[tee->index]++;
          validUses[curr->index]++;
          copiedIndexes[tee->index].insert(curr->index);
          copiedIndexes[curr->index].insert(tee->index);
        }
      } else if (auto* get = value->dynCast<LocalGet>()) {
        validUses[get->index]++;
        validUses[curr->index]++;
        copiedIndexes[get->index].insert(curr->index);
        copiedIndexes[curr->index].insert(get->index);
      } else if (value->is<TupleMake>()) {
        validUses[curr->index]++;
      }
    }
  }

  void visitTupleExtract(TupleExtract* curr) {
    // We need the input to be a local, either from a tee or a get.
    if (auto* set = curr->tuple->dynCast<LocalSet>()) {
      validUses[set->index]++;
    } else if (auto* get = curr->tuple->dynCast<LocalGet>()) {
      validUses[get->index]++;
    }
  }

  void optimize(Function* func) {
    auto numLocals = func->getNumLocals();

    // Find the set of bad indexes. We add each such candidate to a worklist
    // that we will then flow to find all those corrupted.
    std::vector<bool> bad(numLocals);
    UniqueDeferredQueue<Index> work;

    for (Index i = 0; i < uses.size(); i++) {
      assert(validUses[i] <= uses[i]);
      if (uses[i] > 0 && validUses[i] < uses[i]) {
        // This is a bad tuple.
        work.push(i);
      }
    }

    // Flow badness forward.
    while (!work.empty()) {
      auto i = work.pop();
      if (bad[i]) {
        continue;
      }
      bad[i] = true;
      for (auto target : copiedIndexes[i]) {
        work.push(target);
      }
    }

    // Good indexes we can optimize are tuple locals with uses that are not bad.
    std::vector<bool> good(numLocals);
    bool hasGood = false;
    for (Index i = 0; i < uses.size(); i++) {
      if (uses[i] > 0 && !bad[i]) {
        good[i] = true;
        hasGood = true;
      }
    }

    if (!hasGood) {
      return;
    }

    // We found things to optimize! Create new non-tuple locals for their
    // contents, and then rewrite the code to use those according to the
    // mapping from tuple locals to normal ones. The mapping maps a tuple local
    // to the base index used for its contents: an index and several others
    // right after it, depending on the tuple size.
    std::unordered_map<Index, Index> tupleToNewBaseMap;
    for (Index i = 0; i < good.size(); i++) {
      if (!good[i]) {
        continue;
      }

      auto newBase = func->getNumLocals();
      tupleToNewBaseMap[i] = newBase;
      Index lastNewIndex = 0;
      for (auto t : func->getLocalType(i)) {
        Index newIndex = Builder::addVar(func, t);
        if (lastNewIndex == 0) {
          // This is the first new local we added (0 is an impossible value,
          // since tuple locals exist, hence index 0 was already taken), so it
          // must be equal to the base.
          assert(newIndex == newBase);
        } else {
          // This must be right after the former.
          assert(newIndex == lastNewIndex + 1);
        }
        lastNewIndex = newIndex;
      }
    }

    MapApplier mapApplier(tupleToNewBaseMap);
    mapApplier.walkFunctionInModule(func, getModule());
  }

  struct MapApplier : public PostWalker<MapApplier> {
    std::unordered_map<Index, Index>& tupleToNewBaseMap;

    MapApplier(std::unordered_map<Index, Index>& tupleToNewBaseMap)
      : tupleToNewBaseMap(tupleToNewBaseMap) {}

    // Gets the new base index if there is one, or 0 if not (0 is an impossible
    // value for a new index, as local index 0 was taken before, as tuple
    // locals existed).
    Index getNewBaseIndex(Index i) {
      auto iter = tupleToNewBaseMap.find(i);
      if (iter == tupleToNewBaseMap.end()) {
        return 0;
      }
      return iter->second;
    }

    // Given a local.get or local.set, return the new base index for the local
    // index used there. Returns 0 (an impossible value, see above) otherwise.
    Index getSetOrGetBaseIndex(Expression* setOrGet) {
      Index index;
      if (auto* set = setOrGet->dynCast<LocalSet>()) {
        index = set->index;
      } else if (auto* get = setOrGet->dynCast<LocalGet>()) {
        index = get->index;
      } else {
        return 0;
      }

      return getNewBaseIndex(index);
    }

    // Replacing a local.tee requires some care, since we might have
    //
    //  (local.set
    //   (local.tee
    //    ..
    //
    // We replace the local.tee with a block of sets of the new non-tuple
    // locals, and the outer set must then (1) keep those around and also (2)
    // identify the local that was tee'd, so we know what to get (which has been
    // replaced by the block). To make that simple keep a map of the things that
    // replaced tees.
    std::unordered_map<Expression*, LocalSet*> replacedTees;

    void visitLocalSet(LocalSet* curr) {
      auto replace = [&](Expression* replacement) {
        if (curr->isTee()) {
          replacedTees[replacement] = curr;
        }
        replaceCurrent(replacement);
      };

      if (auto targetBase = getNewBaseIndex(curr->index)) {
        Builder builder(*getModule());
        auto type = getFunction()->getLocalType(curr->index);

        auto* value = curr->value;
        if (auto* make = value->dynCast<TupleMake>()) {
          // Write each of the tuple.make fields into the proper local.
          std::vector<Expression*> sets;
          for (Index i = 0; i < type.size(); i++) {
            auto* value = make->operands[i];
            sets.push_back(builder.makeLocalSet(targetBase + i, value));
          }
          replace(builder.makeBlock(sets));
          return;
        }

        std::vector<Expression*> contents;

        auto iter = replacedTees.find(value);
        if (iter != replacedTees.end()) {
          // The input to us was a tee that has been replaced. The actual value
          // we read from (the tee) can be found in replacedTees. Also, we
          // need to keep around the replacement of the tee.
          contents.push_back(value);
          value = iter->second;
        }

        // This is a copy of a tuple local into another. Copy all the fields
        // between them.
        Index sourceBase = getSetOrGetBaseIndex(value);

        // The target is being optimized, so the source must be as well, or else
        // we were confused earlier and the target should not be.
        assert(sourceBase);

        // The source and target may have different element types due to
        // subtyping (but their sizes must be equal).
        auto sourceType = value->type;
        assert(sourceType.size() == type.size());

        for (Index i = 0; i < type.size(); i++) {
          auto* get = builder.makeLocalGet(sourceBase + i, sourceType[i]);
          contents.push_back(builder.makeLocalSet(targetBase + i, get));
        }
        replace(builder.makeBlock(contents));
      }
    }

    void visitTupleExtract(TupleExtract* curr) {
      auto* value = curr->tuple;
      Expression* extraContents = nullptr;

      auto iter = replacedTees.find(value);
      if (iter != replacedTees.end()) {
        // The input to us was a tee that has been replaced. Handle it as in
        // visitLocalSet.
        extraContents = value;
        value = iter->second;
      }

      auto type = value->type;
      if (type == Type::unreachable) {
        return;
      }

      Index sourceBase = getSetOrGetBaseIndex(value);
      if (!sourceBase) {
        return;
      }

      Builder builder(*getModule());
      auto i = curr->index;
      auto* get = builder.makeLocalGet(sourceBase + i, type[i]);
      if (extraContents) {
        replaceCurrent(builder.makeSequence(extraContents, get));
      } else {
        replaceCurrent(get);
      }
    }
  };
};

Pass* createTupleOptimizationPass() { return new TupleOptimization(); }

} // namespace wasm
