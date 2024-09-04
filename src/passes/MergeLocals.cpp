/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Merges locals when it is beneficial to do so.
//
// An obvious case is when locals are copied. In that case, two locals have the
// same value in a range, and we can pick which of the two to use. For
// example, in
//
//  (if (result i32)
//   (local.tee $x
//    (local.get $y)
//   )
//   (i32.const 100)
//   (local.get $x)
//  )
//
// If that assignment of $y is never used again, everything is fine. But if
// if is, then the live range of $y does not end in that get, and will
// necessarily overlap with that of $x - making them appear to interfere
// with each other in coalesce-locals, even though the value is identical.
//
// To fix that, we replace uses of $y with uses of $x. This extends $x's
// live range and shrinks $y's live range. This tradeoff is not always good,
// but $x and $y definitely overlap already, so trying to shrink the overlap
// makes sense - if we remove the overlap entirely, we may be able to let
// $x and $y be coalesced later.
//
// If we can remove only some of $y's uses, then we are definitely not
// removing the overlap, and they do conflict. In that case, it's not clear
// if this is beneficial or not, and we don't do it for now
// TODO: investigate more
//

#include <ir/local-graph.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

struct MergeLocals
  : public WalkerPass<
      PostWalker<MergeLocals, UnifiedExpressionVisitor<MergeLocals>>> {
  bool isFunctionParallel() override { return true; }

  // This pass merges locals, mapping the originals to new ones.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<MergeLocals>();
  }

  void doWalkFunction(Function* func) {
    // first, instrument the graph by modifying each copy
    //   (local.set $x
    //    (local.get $y)
    //   )
    // to
    //   (local.set $x
    //    (local.tee $y
    //     (local.get $y)
    //    )
    //   )
    // That is, we add a trivial assign of $y. This ensures we
    // have a new assignment of $y at the location of the copy,
    // which makes it easy for us to see if the value if $y
    // is still used after that point
    super::doWalkFunction(func);

    // optimize the copies, merging when we can, and removing
    // the trivial assigns we added temporarily
    optimizeCopies();
  }

  std::vector<LocalSet*> copies;

  void visitLocalSet(LocalSet* curr) {
    if (auto* get = curr->value->dynCast<LocalGet>()) {
      if (get->index != curr->index) {
        Builder builder(*getModule());
        auto* trivial = builder.makeLocalTee(get->index, get, get->type);
        curr->value = trivial;
        copies.push_back(curr);
      }
    }
  }

  void optimizeCopies() {
    if (copies.empty()) {
      return;
    }
    // compute all dependencies
    auto* func = getFunction();
    LocalGraph preGraph(func, getModule());
    preGraph.computeInfluences();
    // optimize each copy
    std::unordered_map<LocalSet*, LocalSet*> optimizedToCopy,
      optimizedToTrivial;
    for (auto* copy : copies) {
      auto* trivial = copy->value->cast<LocalSet>();
      bool canOptimizeToCopy = false;
      auto& trivialInfluences = preGraph.getSetInfluences(trivial);
      if (!trivialInfluences.empty()) {
        canOptimizeToCopy = true;
        for (auto* influencedGet : trivialInfluences) {
          // this get uses the trivial write, so it uses the value in the copy.
          // however, it may depend on other writes too, if there is a
          // merge/phi, and in that case we can't do anything
          assert(influencedGet->index == trivial->index);
          auto& sets = preGraph.getSets(influencedGet);
          if (sets.size() == 1) {
            // this is ok
            assert(*sets.begin() == trivial);
            // If local types are different (when one is a subtype of the
            // other), don't optimize
            if (func->getLocalType(copy->index) != influencedGet->type) {
              canOptimizeToCopy = false;
            }
          } else {
            canOptimizeToCopy = false;
            break;
          }
        }
      }
      if (canOptimizeToCopy) {
        // worth it for this copy, do it
        for (auto* influencedGet : trivialInfluences) {
          influencedGet->index = copy->index;
        }
        optimizedToCopy[copy] = trivial;
      } else {
        // alternatively, we can try to remove the conflict in the opposite way:
        // given
        //   (local.set $x
        //    (local.get $y)
        //   )
        // we can look for uses of $x that could instead be uses of $y. this
        // extends $y's live range, but if it removes the conflict between $x
        // and $y, it may be worth it

        // if the trivial set we added has influences, it means $y lives on
        if (!trivialInfluences.empty()) {
          auto& copyInfluences = preGraph.getSetInfluences(copy);
          if (!copyInfluences.empty()) {
            bool canOptimizeToTrivial = true;
            for (auto* influencedGet : copyInfluences) {
              // as above, avoid merges/phis
              assert(influencedGet->index == copy->index);
              auto& sets = preGraph.getSets(influencedGet);
              if (sets.size() == 1) {
                // this is ok
                assert(*sets.begin() == copy);
                // If local types are different (when one is a subtype of the
                // other), don't optimize
                if (func->getLocalType(trivial->index) != influencedGet->type) {
                  canOptimizeToTrivial = false;
                }
              } else {
                canOptimizeToTrivial = false;
                break;
              }
            }
            if (canOptimizeToTrivial) {
              // worth it for this copy, do it
              for (auto* influencedGet : copyInfluences) {
                influencedGet->index = trivial->index;
              }
              optimizedToTrivial[copy] = trivial;
              // note that we don't
            }
          }
        }
      }
    }
    if (!optimizedToCopy.empty() || !optimizedToTrivial.empty()) {
      // finally, we need to verify that the changes work properly, that is,
      // they use the value from the right place (and are not affected by
      // another set of the index we changed to).
      // if one does not work, we need to undo all its siblings (don't extend
      // the live range unless we are definitely removing a conflict, same
      // logic as before).
      LocalGraph postGraph(func, getModule());
      postGraph.computeSetInfluences();
      for (auto& [copy, trivial] : optimizedToCopy) {
        auto& trivialInfluences = preGraph.getSetInfluences(trivial);
        for (auto* influencedGet : trivialInfluences) {
          // verify the set
          auto& sets = postGraph.getSets(influencedGet);
          if (sets.size() != 1 || *sets.begin() != copy) {
            // not good, undo all the changes for this copy
            for (auto* undo : trivialInfluences) {
              undo->index = trivial->index;
            }
            break;
          }
        }
      }
      for (auto& [copy, trivial] : optimizedToTrivial) {
        auto& copyInfluences = preGraph.getSetInfluences(copy);
        for (auto* influencedGet : copyInfluences) {
          // verify the set
          auto& sets = postGraph.getSets(influencedGet);
          if (sets.size() != 1 || *sets.begin() != trivial) {
            // not good, undo all the changes for this copy
            for (auto* undo : copyInfluences) {
              undo->index = copy->index;
            }
            break;
          }
        }
        // if this change was ok, we can probably remove the copy itself,
        // but we leave that for other passes
      }
    }
    // remove the trivial sets
    for (auto* copy : copies) {
      copy->value = copy->value->cast<LocalSet>()->value;
    }
  }
};

Pass* createMergeLocalsPass() { return new MergeLocals(); }

} // namespace wasm
