/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Optimize added constants into load/store offsets. This requires the
// assumption that low memory is unused, so that we can replace an add (which
// might wrap) with a load/store offset (which does not).
//
// The propagate option also propagates offsets across set/get local pairs.
//
// Optimizing constants into load/store offsets is almost always
// beneficial for speed, as VMs can optimize these operations better.
// If a LocalGraph is provided, this can also propagate values along get/set
// pairs. In such a case, we may increase code size slightly or reduce
// compressibility (e.g., replace (load (get $x)) with (load offset=Z (get $y)),
// where Z is big enough to not fit in a single byte), but this is good for
// speed, and may lead to code size reductions elsewhere by using fewer locals.
//

#include <ir/local-graph.h>
#include <ir/local-utils.h>
#include <ir/parents.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

template<typename P, typename T> class MemoryAccessOptimizer {
public:
  MemoryAccessOptimizer(P* parent,
                        T* curr,
                        Module* module,
                        LocalGraph* localGraph)
    : parent(parent), curr(curr), module(module), localGraph(localGraph) {
    memory64 = module->getMemory(curr->memory)->is64();
  }

  // Tries to optimize, and returns whether we propagated a change.
  bool optimize() {
    // The pointer itself may be a constant, if e.g. it was precomputed or
    // a get that we propagated.
    if (curr->ptr->template is<Const>()) {
      optimizeConstantPointer();
      return false;
    }
    if (auto* add = curr->ptr->template dynCast<Binary>()) {
      if (add->op == AddInt32 || add->op == AddInt64) {
        // Look for a constant on both sides.
        if (tryToOptimizeConstant(add->right, add->left) ||
            tryToOptimizeConstant(add->left, add->right)) {
          return false;
        }
      }
    }
    if (localGraph) {
      // A final important case is a propagated add:
      //
      //  x = y + 10
      //  ..
      //  load(x)
      // =>
      //  x = y + 10
      //  ..
      //  load(y, offset=10)
      //
      // This is only valid if y does not change in the middle!
      if (auto* get = curr->ptr->template dynCast<LocalGet>()) {
        auto& sets = localGraph->getSets(get);
        if (sets.size() == 1) {
          auto* set = *sets.begin();
          // May be a zero-init (in which case, we can ignore it). Must also be
          // valid to propagate, as checked earlier in the parent.
          if (set && parent->isPropagatable(set)) {
            auto* value = set->value;
            if (auto* add = value->template dynCast<Binary>()) {
              if (add->op == AddInt32) {
                // We can optimize on either side, but only if both we find
                // a constant *and* the other side cannot change in the middle.
                // TODO If it could change, we may add a new local to capture
                //      the old value.
                if (tryToOptimizePropagatedAdd(
                      add->right, add->left, get, set) ||
                    tryToOptimizePropagatedAdd(
                      add->left, add->right, get, set)) {
                  return true;
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

private:
  P* parent;
  T* curr;
  Module* module;
  LocalGraph* localGraph;
  bool memory64;

  void optimizeConstantPointer() {
    // The constant and an offset are interchangeable:
    //   (load (const X))  <=>  (load offset=X (const 0))
    // It may not matter if we do this or not - it's the same size,
    // and in both cases the compiler can see it's a constant location.
    // For code clarity and compressibility, we prefer to put the
    // entire address in the constant.
    if (curr->offset) {
      // Note that the offset may already be larger than low memory - the
      // code may know that is valid, even if we can't. Only handle the
      // obviously valid case where an overflow can't occur.
      auto* c = curr->ptr->template cast<Const>();
      if (memory64) {
        uint64_t base = c->value.geti64();
        uint64_t offset = curr->offset;

        uint64_t max = std::numeric_limits<uint64_t>::max();
        bool overflow = (base > max - offset);
        if (!overflow) {
          c->value = c->value.add(Literal(offset));
          curr->offset = 0;
        }
      } else {
        uint32_t base = c->value.geti32();
        uint32_t offset = curr->offset;
        if (uint64_t(base) + uint64_t(offset) < (uint64_t(1) << 32)) {
          c->value = c->value.add(Literal(uint32_t(curr->offset)));
          curr->offset = 0;
        }
      }
    }
  }

  struct Result {
    bool succeeded;
    Address total;
    Result() : succeeded(false) {}
    Result(Address total) : succeeded(true), total(total) {}
  };

  // See if we can optimize an offset from an expression. If we report
  // success, the returned offset can be added as a replacement for the
  // expression here.
  bool tryToOptimizeConstant(Expression* oneSide, Expression* otherSide) {
    if (auto* c = oneSide->dynCast<Const>()) {
      auto result = canOptimizeConstant(c->value);
      if (result.succeeded) {
        curr->offset = result.total;
        curr->ptr = otherSide;
        if (curr->ptr->template is<Const>()) {
          optimizeConstantPointer();
        }
        return true;
      }
    }
    return false;
  }

  bool tryToOptimizePropagatedAdd(Expression* oneSide,
                                  Expression* otherSide,
                                  LocalGet* ptr,
                                  LocalSet* set) {
    if (auto* c = oneSide->dynCast<Const>()) {
      if (otherSide->is<Const>()) {
        // Both sides are constant - this is not optimized code, ignore.
        return false;
      }
      auto result = canOptimizeConstant(c->value);
      if (result.succeeded) {
        // Looks good, but we need to make sure the other side cannot change:
        //
        //  x = y + 10
        //  y = y + 1
        //  load(x)
        //
        // This example should *not* be optimized into
        //
        //  load(y, offset=10)
        //
        // If the other side is a get, we may be able to prove that we can just
        // use that same local, if both it and the pointer are in SSA form. In
        // that case,
        //
        //  y = .. // single assignment that dominates all uses
        //  x = y + 10 // single assignment that dominates all uses
        //  [..]
        //  load(x) => load(y, offset=10)
        //
        // This is valid since dominance is transitive, so y's definition
        // dominates the load, and it is ok to replace x with y + 10 there.
        Index index = -1;
        bool canReuseIndex = false;
        if (auto* get = otherSide->dynCast<LocalGet>()) {
          if (localGraph->isSSA(get->index) && localGraph->isSSA(ptr->index)) {
            index = get->index;
            canReuseIndex = true;
          }
        }
        // If we can't reuse the index, then create a new one,
        //
        //  x = y + 10
        //  y = y + 1
        //  load(x)
        // =>
        //  y' = y
        //  x = y' + 10
        //  y = y + 1
        //  load(y', offset=10)
        //
        // Often x has no other uses and later passes can remove it.
        if (!canReuseIndex) {
          index = parent->getHelperIndex(set);
        }
        curr->offset = result.total;
        curr->ptr = Builder(*module).makeLocalGet(index, Type::i32);
        return true;
      }
    }
    return false;
  }

  // Sees if we can optimize a particular constant.
  Result canOptimizeConstant(Literal literal) {
    uint64_t value = literal.getInteger();
    // Avoid uninteresting corner cases with peculiar offsets.
    if (value < PassOptions::LowMemoryBound) {
      // The total offset must not allow reaching reasonable memory
      // by overflowing.
      auto total = curr->offset + value;
      if (total < PassOptions::LowMemoryBound) {
        return Result(total);
      }
    }
    return Result();
  }
};

struct OptimizeAddedConstants
  : public WalkerPass<
      PostWalker<OptimizeAddedConstants,
                 UnifiedExpressionVisitor<OptimizeAddedConstants>>> {
  bool isFunctionParallel() override { return true; }

  // This pass operates on linear memory, and does not affect reference locals.
  bool requiresNonNullableLocalFixups() override { return false; }

  bool propagate;

  OptimizeAddedConstants(bool propagate) : propagate(propagate) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<OptimizeAddedConstants>(propagate);
  }

  void visitLoad(Load* curr) {
    MemoryAccessOptimizer<OptimizeAddedConstants, Load> optimizer(
      this, curr, getModule(), localGraph.get());
    if (optimizer.optimize()) {
      propagated = true;
    }
  }

  void visitStore(Store* curr) {
    MemoryAccessOptimizer<OptimizeAddedConstants, Store> optimizer(
      this, curr, getModule(), localGraph.get());
    if (optimizer.optimize()) {
      propagated = true;
    }
  }

  void doWalkFunction(Function* func) {
    if (!getPassOptions().lowMemoryUnused) {
      Fatal() << "OptimizeAddedConstants can only be run when the "
              << "--low-memory-unused flag is set.";
    }

    // Multiple passes may be needed if we have x + 4 + 8 etc. (nested structs
    // in C can cause this, but it's rare). Note that we only need that for the
    // propagation case (as 4 + 8 would be optimized directly if it were
    // adjacent).
    while (1) {
      propagated = false;
      helperIndexes.clear();
      propagatable.clear();
      if (propagate) {
        localGraph = std::make_unique<LocalGraph>(func, getModule());
        localGraph->computeSetInfluences();
        localGraph->computeSSAIndexes();
        findPropagatable();
      }
      super::doWalkFunction(func);
      if (!helperIndexes.empty()) {
        createHelperIndexes();
      }
      if (propagated) {
        cleanUpAfterPropagation();
      } else {
        return;
      }
    }
  }

  // For a given expression, store it to a local and return us the local index
  // we can use, in order to get that value someplace else. We are provided not
  // the expression, but the set in which it is in, as the arm of an add that is
  // the set's value (the other arm is a constant, and we are not a constant).
  // We cache these, that is, use a single one for all requests.
  Index getHelperIndex(LocalSet* set) {
    auto iter = helperIndexes.find(set);
    if (iter != helperIndexes.end()) {
      return iter->second;
    }
    return helperIndexes[set] =
             Builder(*getModule()).addVar(getFunction(), Type::i32);
  }

  bool isPropagatable(LocalSet* set) { return propagatable.count(set); }

private:
  bool propagated;

  std::unique_ptr<LocalGraph> localGraph;

  // Whether a set is propagatable.
  std::set<LocalSet*> propagatable;

  void findPropagatable() {
    // Conservatively, only propagate if all uses can be removed of the
    // original. That is,
    //  x = a + 10
    //  f(x)
    //  g(x)
    // should be optimized to
    //  f(a, offset=10)
    //  g(a, offset=10)
    // but if x has other uses, then avoid doing so - we'll be doing that add
    // anyhow, so the load/store offset trick won't actually help.
    Parents parents(getFunction()->body);
    for (auto& [location, _] : localGraph->locations) {
      if (auto* set = location->dynCast<LocalSet>()) {
        if (auto* add = set->value->dynCast<Binary>()) {
          if (add->op == AddInt32) {
            if (add->left->is<Const>() || add->right->is<Const>()) {
              // Looks like this might be relevant, check all uses.
              bool canPropagate = true;
              for (auto* get : localGraph->getSetInfluences(set)) {
                auto* parent = parents.getParent(get);
                // if this is at the top level, it's the whole body - no set can
                // exist!
                assert(parent);
                if (!(parent->is<Load>() || parent->is<Store>())) {
                  canPropagate = false;
                  break;
                }
              }
              if (canPropagate) {
                propagatable.insert(set);
              }
            }
          }
        }
      }
    }
  }

  void cleanUpAfterPropagation() {
    // Remove sets that no longer have uses. This allows further propagation by
    // letting us see the accurate amount of uses of each set.
    UnneededSetRemover remover(getFunction(), getPassOptions(), *getModule());
  }

  std::map<LocalSet*, Index> helperIndexes;

  void createHelperIndexes() {
    struct Creator : public PostWalker<Creator> {
      std::map<LocalSet*, Index>& helperIndexes;
      Module* module;

      Creator(std::map<LocalSet*, Index>& helperIndexes)
        : helperIndexes(helperIndexes) {}

      void visitLocalSet(LocalSet* curr) {
        auto iter = helperIndexes.find(curr);
        if (iter != helperIndexes.end()) {
          auto index = iter->second;
          auto* binary = curr->value->cast<Binary>();
          Expression** target;
          if (binary->left->is<Const>()) {
            target = &binary->right;
          } else {
            assert(binary->right->is<Const>());
            target = &binary->left;
          }
          auto* value = *target;
          Builder builder(*module);
          *target = builder.makeLocalGet(index, Type::i32);
          replaceCurrent(
            builder.makeSequence(builder.makeLocalSet(index, value), curr));
        }
      }
    } creator(helperIndexes);
    creator.module = getModule();
    creator.walk(getFunction()->body);
  }
};

Pass* createOptimizeAddedConstantsPass() {
  return new OptimizeAddedConstants(false);
}

Pass* createOptimizeAddedConstantsPropagatePass() {
  return new OptimizeAddedConstants(true);
}

} // namespace wasm
