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
//  * Scan: Hash each expression and see if it repeats later.
//          If it does:
//            * Note that the original appearance is requested to be reused
//              an additional time.
//            * Note that the repeat appearance requests to be replaced.
//            * Scan the children of the repeat and undo their requests to be
//              replaced (as if we will reuse the parent, we don't need to do
//              anything for the children, see below).
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
//       (A)
//     )
//   )
//
// Assuming A does not have side effects that interfere, this will happen:
//
//  1. Scan A and add it to the hash map of things we have seen.
//  2. Scan the eqz, and do the same for it.
//  3. Scan the second A. Increment the first A's requests counter, and mark the
//     second A as intended to be replaced.
//  4. Scan the second eqz, and do the same for it. Then also scan its children,
//     in this case A, and decrement the first A's reuse counter, and unmark the
//     second A's note that it is intended to be replaced.
//  5. After that, the second eqz request to be replaced by the first, and there
//     is no request on A.
//  6. Run through the block again, adding a tee and replacing the second eqz,
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
// This pass only finds entire expression trees, and not parts of them, so we
// will not optimize this:
//
//  (A (B (C (D1))))
//  (A (B (C (D2))))
//
// The innermost child is different, so the trees are not identical. However,
// running flatten before running this pass would allow those to be optimized as
// well.
//
// TODO: global, inter-block gvn etc.
//

#include <algorithm>
#include <memory>

#include <ir/cost.h>
#include <ir/effects.h>
#include <ir/iteration.h>
#include <ir/linear-execution.h>
#include <ir/type-updating.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm-traversal.h>
#include <wasm.h>

namespace wasm {

namespace {

// An expression with a cached hash value.
struct HashedExpression {
  Expression* expr;
  size_t digest;

  HashedExpression(Expression* expr, size_t digest) : expr(expr), digest(digest) {}

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

// Maps hashed expressions to the list of expressions that match. That is, all
// expressions that are equivalent (same hash, and also compare equal) will
// be in a vector for the corresponding entry in this map.
using HashedExprs = std::unordered_map<HashedExpression,
                                       std::vector<Expression*>,
                                       HEHasher,
                                       HEComparer>;

// Request information about an expression: whether it requests to be replaced,
// or it is an original expression whose value can be used to replace others
// later.
struct RequestInfo {
  // The number of other expressions that would like to reuse this value.
  Index requests = 0;

  // If this is a repeat value, that is, something we would like to replace
  // with a local.get of the original value (the first time this value
  // appeared) then we point to that original value here. In that case we have
  // incremented the original's |requests|.
  Expression* original = nullptr;
};

struct Scanner
  : public LinearExecutionWalker<Scanner, UnifiedExpressionVisitor<Scanner>> {
  PassOptions options;

  Scanner(PassOptions options) : options(options) {}

  // Shallow hashes of all the expressions we've encountered.
  std::unordered_map<Expression*, size_t> shallowHashes;

  // Currently active hashed expressions in the current basic block.
  HashedExprs blockExprs;

  // The effects of hashed expressions.
  std::unordered_map<Expression*, EffectAnalyzer> blockEffects;

  // Request info in the current basic block.
  std::unordered_map<Expression*, RequestInfo> blockInfos;

  static void doNoteNonLinear(Scanner* self, Expression** currp) {
    // We are starting a new basic block. Forget all the currently-hashed
    // expressions, as we no longer want to make connections to anything from
    // another block.
    self->blockExprs.clear();
    self->blockEffects.clear();
    // Note that we do not clear blockInfos - that is information we will use
    // later in the Applier class. That is, we've cleared all the active
    // information, leaving the things we need later.
  }

  void visitExpression(Expression* curr) {
    checkInvalidations(curr);

    if (!isRelevant(curr)) {
      return;
    }

    auto& vec = blockExprs[HashedExpression(curr, computeHash(curr))];
    vec.push_back(curr);
    auto& info = blockInfos[curr];
    if (vec.size() > 1) {
      // This is a repeat expression. Mark it as such, and add a request for the
      // original appearance of the value.
      auto* original = vec[0];
      info.original = original;
      blockInfos[original].requests++;

      // Remove any requests from the expression's children, as we will replace
      // the entire thing (see explanation earlier). Note that we just need to
      // go over our direct children, as grandchildren etc. have already been
      // processed. That is, if we have
      //
      //  (A (B (C))
      //  (A (B (C))
      //
      // Then when we see the second B we will mark the second C as no longer
      // requesting replacement. And then when we see the second A, all it needs
      // to update is the second B.
      for (auto* child : ChildIterator(curr)) {
        if (!blockInfos.count(child)) {
          continue;
        }
        auto& childInfo = blockInfos[child];
        if (childInfo.original) {
          assert(blockInfos[childInfo.original].requests > 0);
          blockInfos[childInfo.original].requests--;
          childInfo.original = nullptr;
        }
      }
    }
  }

  // Compute the total hash of the current expression, and also save the shallow
  // hash for its parent. That allows us to hash everything in linear time.
  size_t computeHash(Expression* curr) {
    size_t hash = shallowHashes[curr] = ExpressionAnalyzer::shallowHash(curr);
    for (auto* child : ChildIterator(curr)) {
      assert(shallowHashes.count(child));
      hash_combine(hash, shallowHashes[child]);
    }
    return hash;
  }

  // Only some values are relevant to be optimized.
  bool isRelevant(Expression* curr) {
    if (curr->is<LocalGet>() || curr->is<LocalSet>() || curr->is<Const>()) {
      return false; // trivial
    }
    if (!curr->type.isConcrete()) {
      return false; // don't bother with none or unreachable etc.
    }
    if (!TypeUpdating::canHandleAsLocal(curr->type)) {
      return false;
    }
    // TODO: this recomputes effects for duplicates.
    // TODO: we can ignore a trap here. It is ok to trap twice.
    auto iter = blockEffects.emplace(
      curr, EffectAnalyzer(options, getModule()->features, curr));
    if (iter.first->second.hasSideEffects()) {
      return false; // we can't combine things with side effects
    }
    // If the size is at least 3, then if we have two of them we have 6,
    // and so adding one set+two gets and removing one of the items itself
    // is not detrimental, and may be beneficial.
    if (options.shrinkLevel > 0 && Measurer::measure(curr) >= 3) {
      return true;
    }
    // If we focus on speed, any reduction in cost is beneficial, as the
    // cost of a get is essentially free.
    if (options.shrinkLevel == 0 && CostAnalyzer(curr).cost > 0) {
      return true;
    }
    return false;
  }

  // Given the current expression, see what it invalidates of the currently-
  // hashed expressions. For example, if the current expression writes to memory
  // then anything that reads from memory cannot be moved around it, and that
  // means we cannot optimize away repeated expressions:
  //
  //  x = load(a);
  //  store(..)
  //  y = load(a);
  //
  // Even though the load looks identical, the store means we may load a
  // different value, so invalidate the first load.
  void checkInvalidations(Expression* curr) {
    // TODO: Like SimplifyExpressions this is O(bad), but seems ok in practice..
    // TODO: put a limit on how many active expressions?
    EffectAnalyzer effects(options, getModule()->features);
    effects.visit(curr);

    std::vector<HashedExpression> invalidated;
    for (auto& kv : blockExprs) {
      auto& key = kv.first;
      auto iter = blockEffects.find(key.expr);
      if (iter != blockEffects.end() && effects.invalidates(iter->second)) {
        invalidated.push_back(key);
      }
    }

    for (const auto& key : invalidated) {
      blockExprs.erase(key);
    }
  }
};

struct Applier : public PostWalker<Applier, UnifiedExpressionVisitor<Applier>> {
  const Scanner& scanner;

  Applier(const Scanner& scanner) : scanner(scanner) {}

  // Maps expressions that we save to locals to the local index for them.
  std::unordered_map<Expression*, Index> exprLocals;

  void visitExpression(Expression* curr) {
    auto iter = scanner.blockInfos.find(curr);
    if (iter == scanner.blockInfos.end()) {
      return;
    }
    const auto& info = iter->second;

    // An expression cannot both be requested to be copied to a local, and also
    // have some other expression it is a repeat of - if it is a repeat, then
    // anything that requests to be copied from it should have requested from
    // the the original of this expression.
    assert(!(info.requests && info.original));

    if (info.requests) {
      // We have requests for this value. Add a local and tee the value to
      // there.
      Index local = exprLocals[curr] =
        Builder::addVar(getFunction(), curr->type);
      replaceCurrent(
        Builder(*getModule()).makeLocalTee(local, curr, curr->type));
    } else if (info.original) {
      // This is a repeat of an original value. Get the value from the local.
      assert(exprLocals.count(info.original));
      replaceCurrent(Builder(*getModule())
                       .makeLocalGet(exprLocals[info.original], curr->type));
    }
  }
};

} // anonymous namespace

struct LocalCSE : public WalkerPass<LinearExecutionWalker<LocalCSE>> {
  bool isFunctionParallel() override { return true; }

  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  Pass* create() override { return new LocalCSE(); }

  void doWalkFunction(Function* func) {
    Scanner scanner(getPassOptions());
    scanner.walkFunctionInModule(func, getModule());

    Applier applier(scanner);
    applier.walkFunctionInModule(func, getModule());

    TypeUpdating::handleNonDefaultableLocals(func, *getModule());
  }
};

Pass* createLocalCSEPass() { return new LocalCSE(); }

} // namespace wasm
