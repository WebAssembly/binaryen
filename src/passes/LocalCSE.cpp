/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Local CSE
//
// This finds common sub-expressions and saves them to a local to avoid
// recomputing them. It runs in each basic block separately, and uses a simple
// algorithm:
//
//  * Scan: Hash each expression and see if it repeats later. If it does, note
//          that both on the first appearance (whose value we will save) and on
//          the expression itself (who we want to replace with a local.get).
//          After doing so, scan the children and remove any such notes from
//          them (as if we will reuse the parent, we don't need to do anything
//          for the child, see below).
//
//  * Apply: Go through the basic block again, this time adding a tee on an
//           expression whose value we want to use later, and replacing the
//           uses with gets.
//
// For example:
//
//   (something
//     (i32.eqz
//       (A)
//     )
//     (i32.eqz
//       (B)
//     )
//   )
//
// Assuming A does not have side effects that interfere, this will happen:
//
//  1. Scan A and add it to the hash map of things we have seen.
//  2. Scan the eqz, and do the same for it.
//  3. Scan the second A. Increment the first A's reuse counter, and mark the
//     second A and intended to be replaced.
//  4. Scan the second eqz, and do the same for it. Then also scan its children,
//     in this case A, and decrement the first A's reuse counter, and unmark the
//     second A's note that it is intended to be replaced.
//  5. Run through the block again, adding a tee and replacing the second eqz,
//     resulting in:
//
//   (something
//     (local.tee $temp
//       (i32.eqz
//         (A)
//       )
//     )
//     (local.get $temp)
//   )
//
// Note how the scanning of children avoids us adding a local for A: when we
// reuse the parent, we don't need to also try to reuse the child.
//
// TODO: global, inter-block gvn etc.
//

#include <algorithm>
#include <memory>

#include "ir/flat.h"
#include <ir/cost.h>
#include <ir/effects.h>
#include <ir/equivalent_sets.h>
#include <ir/hashed.h>
#include <ir/linear-execution.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm-traversal.h>
#include <wasm.h>

namespace wasm {

namespace {

// An expression with a cached hash value
struct HashedExpression {
  Expression* expr;
  size_t digest;

  HashedExpression(Expression* expr) : expr(expr) {
    if (expr) {
      digest = ExpressionAnalyzer::hash(expr);
    } else {
      digest = hash(0);
    }
  }

  HashedExpression(const HashedExpression& other)
    : expr(other.expr), digest(other.digest) {}
};

struct HEHasher {
  size_t operator()(const HashedExpression hashed) const {
    return hashed.digest;
  }
};

struct HEComparer {
  bool operator()(const HashedExpression a, const HashedExpression b) const {
    if (a.digest != b.digest) {
      return false;
    }
    return ExpressionAnalyzer::equal(a.expr, b.expr);
  }
};

struct Scan : public LinearExecutionWalker<Scan, UnifiedExpressionVisitor<Scan>> {
  // Maps hashed expressions to those relevant expressions. That is, all
  // expressions that are equivalent (same hash, and also compare equal) will
  // be in a vector for the corresponding entry in this map.
  using HashedExprs = std::unordered_map<HashedExpression, std::vector<Expression*>, HEHasher, HEComparer> {};

  // The data about hashed expressions in the current basic block.
  HashedExprs hashedExprs;

  struct Info {
    // The number of other expressions that would like to reuse this value.
    Index requests = 0;
    // Whether this is a repeat, that is, something we would like to replace
    // with a local.get of the first time the value appeared. If this is a
    // repeat then we have incremented the original's |requests|.
    bool repeat = false;
  };

  // The information about expressions in the current basic block.
  std::unordered_map<Expression*, Info> infos;

  static void doNoteNonLinear(LocalCSE* self, Expression** currp) {
    self->clear();
  }

  void clear() {
    hashedExprs.clear();
    infos.clear();
  }

  void visitExpression(Expression* curr) {
    // TODO: Do shallow hashing so that we can add child hashes to parents, to
    // avoid quadratic time FIXME
    auto hash = ExpressionAnalyzer::hash(curr);
    auto& vec = hashedExprs
  }
};

} // anonymous namespace

struct LocalCSE : public WalkerPass<LinearExecutionWalker<LocalCSE>> {
  bool isFunctionParallel() override { return true; }

  // CSE adds and reuses locals.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  Pass* create() override { return new LocalCSE(); }

  struct Usable {
    HashedExpression hashed;
    Type localType;
    Usable(HashedExpression hashed, Type localType)
      : hashed(hashed), localType(localType) {}
  };

  struct UsableHasher {
    size_t operator()(const Usable value) const {
      auto digest = value.hashed.digest;
      wasm::rehash(digest, value.localType.getID());
      return digest;
    }
  };

  struct UsableComparer {
    bool operator()(const Usable a, const Usable b) const {
      if (a.hashed.digest != b.hashed.digest || a.localType != b.localType) {
        return false;
      }
      return ExpressionAnalyzer::equal(a.hashed.expr, b.hashed.expr);
    }
  };

  // information for an expression we can reuse
  struct UsableInfo {
    Expression* value; // the value we can reuse
    Index index; // the local we are assigned to, local.get that to reuse us
    EffectAnalyzer effects;

    UsableInfo(Expression* value,
               Index index,
               PassOptions& passOptions,
               FeatureSet features)
      : value(value), index(index), effects(passOptions, features, value) {}
  };

  // a list of usables in a linear execution trace
  class Usables
    : public std::
        unordered_map<Usable, UsableInfo, UsableHasher, UsableComparer> {};

  // locals in current linear execution trace, which we try to sink
  Usables usables;

  // We track locals containing the same value - the value is what matters, not
  // the index.
  EquivalentSets equivalences;

  bool anotherPass;

  void doWalkFunction(Function* func) {
    Flat::verifyFlatness(func);
    anotherPass = true;
    // we may need multiple rounds
    while (anotherPass) {
      anotherPass = false;
      clear();
      super::doWalkFunction(func);
    }
  }

  static void doNoteNonLinear(LocalCSE* self, Expression** currp) {
    self->clear();
  }

  void clear() {
    usables.clear();
    equivalences.clear();
  }

  // Checks invalidations due to a set of effects. Also optionally receive
  // an expression that was just post-visited, and that also needs to be
  // taken into account.
  void checkInvalidations(EffectAnalyzer& effects, Expression* curr = nullptr) {
    // TODO: this is O(bad)
    std::vector<Usable> invalidated;
    for (auto& sinkable : usables) {
      // Check invalidations of the values we may want to use.
      if (effects.invalidates(sinkable.second.effects)) {
        invalidated.push_back(sinkable.first);
      }
    }
    if (curr) {
      // If we are a set, we have more to check: each of the usable
      // values was from a set, and we did not consider the set in
      // the loop above - just the values. So here we must check that
      // sets do not interfere. (Note that due to flattening we
      // have no risk of tees etc.)
      if (auto* set = curr->dynCast<LocalSet>()) {
        for (auto& sinkable : usables) {
          // Check if the index is the same. Make sure to ignore
          // our own value, which we may have just added!
          if (sinkable.second.index == set->index &&
              sinkable.second.value != set->value) {
            invalidated.push_back(sinkable.first);
          }
        }
      }
    }
    for (auto index : invalidated) {
      usables.erase(index);
    }
  }

  std::vector<Expression*> expressionStack;

  static void visitPre(LocalCSE* self, Expression** currp) {
    // pre operations
    Expression* curr = *currp;

    EffectAnalyzer effects(self->getPassOptions(), self->getModule()->features);
    if (effects.checkPre(curr)) {
      self->checkInvalidations(effects);
    }

    self->expressionStack.push_back(curr);
  }

  static void visitPost(LocalCSE* self, Expression** currp) {
    auto* curr = *currp;

    // main operations
    self->handle(curr);

    // post operations

    EffectAnalyzer effects(self->getPassOptions(), self->getModule()->features);
    if (effects.checkPost(curr)) {
      self->checkInvalidations(effects, curr);
    }

    self->expressionStack.pop_back();
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(LocalCSE* self, Expression** currp) {
    self->pushTask(visitPost, currp);

    super::scan(self, currp);

    self->pushTask(visitPre, currp);
  }

  void handle(Expression* curr) {
    if (auto* set = curr->dynCast<LocalSet>()) {
      // Calculate equivalences
      auto* func = getFunction();
      equivalences.reset(set->index);
      if (auto* get = set->value->dynCast<LocalGet>()) {
        if (func->getLocalType(set->index) == func->getLocalType(get->index)) {
          equivalences.add(set->index, get->index);
        }
      }
      // consider the value
      auto* value = set->value;
      if (isRelevant(value)) {
        Usable usable(value, func->getLocalType(set->index));
        auto iter = usables.find(usable);
        if (iter != usables.end()) {
          // already exists in the table, this is good to reuse
          auto& info = iter->second;
          Type localType = func->getLocalType(info.index);
          set->value =
            Builder(*getModule()).makeLocalGet(info.index, localType);
          anotherPass = true;
        } else {
          // not in table, add this, maybe we can help others later
          usables.emplace(std::make_pair(
            usable,
            UsableInfo(
              value, set->index, getPassOptions(), getModule()->features)));
        }
      }
    } else if (auto* get = curr->dynCast<LocalGet>()) {
      if (auto* set = equivalences.getEquivalents(get->index)) {
        // Canonicalize to the lowest index. This lets hashing and comparisons
        // "just work".
        get->index = *std::min_element(set->begin(), set->end());
      }
    }
  }

  // A relevant value is a non-trivial one, something we may want to reuse
  // and are able to.
  bool isRelevant(Expression* value) {
    if (value->is<LocalGet>()) {
      return false; // trivial, this is what we optimize to!
    }
    if (!value->type.isConcrete()) {
      return false; // don't bother with unreachable etc.
    }
    if (EffectAnalyzer(getPassOptions(), getModule()->features, value)
          .hasSideEffects()) {
      return false; // we can't combine things with side effects
    }
    auto& options = getPassRunner()->options;
    // If the size is at least 3, then if we have two of them we have 6,
    // and so adding one set+two gets and removing one of the items itself
    // is not detrimental, and may be beneficial.
    if (options.shrinkLevel > 0 && Measurer::measure(value) >= 3) {
      return true;
    }
    // If we focus on speed, any reduction in cost is beneficial, as the
    // cost of a get is essentially free.
    if (options.shrinkLevel == 0 && CostAnalyzer(value).cost > 0) {
      return true;
    }
    return false;
  }
};

Pass* createLocalCSEPass() { return new LocalCSE(); }

} // namespace wasm
