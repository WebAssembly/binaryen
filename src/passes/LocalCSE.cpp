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
//  * Check: Check if effects prevent some of the requests from being done. For
//           example, if the value is a load from memory, we cannot optimize
//           around a store, as the value before the store might be different
//           (see below).
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
// Effects must be considered carefully by the Checker phase. E.g.:
//
//  x = load(a);
//  store(..)
//  y = load(a);
//
// Even though the load looks identical, the store means we may load a
// different value, so we will invalidate and not optimize here.
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
// TODO: Global, inter-block gvn etc. However, note that atm the cost of our
//       adding new locals here is low because their lifetimes are all within a
//       single basic block. A global optimization here could add long-lived
//       locals with register allocation costs in the entire function.
//

#include <algorithm>
#include <memory>

#include <ir/cost.h>
#include <ir/effects.h>
#include <ir/iteration.h>
#include <ir/linear-execution.h>
#include <ir/properties.h>
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

  HashedExpression(Expression* expr, size_t digest)
    : expr(expr), digest(digest) {}

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

// A map of expressions to their request info.
using RequestInfoMap = std::unordered_map<Expression*, RequestInfo>;

struct Scanner
  : public LinearExecutionWalker<Scanner, UnifiedExpressionVisitor<Scanner>> {
  PassOptions options;

  Scanner(PassOptions options) : options(options) {}

  // Hash values of all the expressions we've encountered.
  std::unordered_map<Expression*, size_t> hashes;

  // Currently active hashed expressions in the current basic block.
  HashedExprs blockExprs;

  // Request info for all expressions.
  RequestInfoMap requestInfos;

  static void doNoteNonLinear(Scanner* self, Expression** currp) {
    // We are starting a new basic block. Forget all the currently-hashed
    // expressions, as we no longer want to make connections to anything from
    // another block.
    self->blockExprs.clear();
    // Note that we do not clear requestInfos - that is information we will use
    // later in the Applier class. That is, we've cleared all the active
    // information, leaving the things we need later.
  }

  void visitExpression(Expression* curr) {
    auto hash = computeHash(curr);

    if (!isRelevant(curr)) {
      return;
    }

    auto& vec = blockExprs[HashedExpression(curr, hash)];
    vec.push_back(curr);
    auto& info = requestInfos[curr];
    if (vec.size() > 1) {
      // This is a repeat expression. Mark it as such, and add a request for the
      // original appearance of the value.
      auto* original = vec[0];
      info.original = original;
      requestInfos[original].requests++;

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
        if (!requestInfos.count(child)) {
          continue;
        }
        auto& childInfo = requestInfos[child];
        if (childInfo.original) {
          assert(requestInfos[childInfo.original].requests > 0);
          requestInfos[childInfo.original].requests--;
          childInfo.original = nullptr;
        }
      }
    }
  }

  // Compute the hash, using the pre-computed hashes of the children, which are
  // saved. This allows us to hash everything in linear time.
  size_t computeHash(Expression* curr) {
    auto hash = ExpressionAnalyzer::shallowHash(curr);
    for (auto* child : ChildIterator(curr)) {
      assert(hashes.count(child));
      hash_combine(hash, hashes[child]);
    }
    return hashes[curr] = hash;
  }

  // Only some values are relevant to be optimized.
  bool isRelevant(Expression* curr) {
    // * Ignore anything that is not a concrete type, as we are looking for
    //   computed values to reuse, and so none and unreachable are irrelevant.
    // * Ignore local.get and set, as those are the things we optimize to.
    // * Ignore constants so that we don't undo the effects of constant
    //   propagation.
    // * Ignore things we cannot put in a local, as then we can't do this
    //   optimization at all.
    //
    // More things matter here, like having side effects or not, but computing
    // them is not cheap, so leave them for later, after we know if there
    // actually are any requests for reuse of this value (which is rare).
    if (!curr->type.isConcrete() || curr->is<LocalGet>() ||
        curr->is<LocalSet>() || Properties::isConstantExpression(curr) ||
        !TypeUpdating::canHandleAsLocal(curr->type)) {
      return false;
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
};

// Check for invalidations due to effects. We do this after scanning as effect
// computation is not cheap, and there are usually not many identical fragments
// of code.
//
// This updates the RequestInfos of things it sees are invalidated, which will
// make Applier ignore them.
struct Checker
  : public LinearExecutionWalker<Checker, UnifiedExpressionVisitor<Checker>> {
  PassOptions options;
  RequestInfoMap& requestInfos;

  Checker(PassOptions options, RequestInfoMap& requestInfos)
    : options(options), requestInfos(requestInfos) {}

  struct ActiveOriginalInfo {
    // How many of the requests remain to be seen.
    Index requestsLeft;

    // The effects in the expression.
    EffectAnalyzer effects;
  };

  // The currently relevant original expressions, that is, the ones that may be
  // optimized in the current basic block. This maps each one to the number of
  // requests for it, which allows us to know when it is no longer relevant.
  std::unordered_map<Expression*, ActiveOriginalInfo> activeOriginals;

  void visitExpression(Expression* curr) {
    // Given the current expression, see what it invalidates of the currently-
    // hashed expressions, if there are any.
    if (!activeOriginals.empty()) {
      EffectAnalyzer effects(options, getModule()->features);
      effects.visit(curr);

      std::vector<Expression*> invalidated;
      for (auto& kv : activeOriginals) {
        auto* original = kv.first;
        auto& originalInfo = kv.second;
        if (effects.invalidates(originalInfo.effects)) {
          invalidated.push_back(original);
        }
      }

      for (auto* original : invalidated) {
        // Remove all requests after this expression, as we cannot optimize to
        // them.
        requestInfos[original].requests -=
          activeOriginals.at(original).requestsLeft;

        activeOriginals.erase(original);
      }
    }

    assert(!activeOriginals.count(curr));

    // Check if the current expression is an original or requests from one.
    auto iter = requestInfos.find(curr);
    if (iter != requestInfos.end()) {
      auto& info = iter->second;

      // An expression cannot both be requested to be copied to a local, and
      // also have some other expression it is a repeat of - if it is a repeat,
      // then anything that requests to be copied from it should have requested
      // from the the original of this expression.
      assert(!(info.requests && info.original));

      if (info.requests > 0) {
        EffectAnalyzer effects(options, getModule()->features, curr);
        // We cannot optimize away repeats of something with side effects.
        //
        // We also cannot optimize away something that is not observably-
        // deterministic: even if it has no side effects, if it may return a
        // different result each time, we cannot optimize away repeats.
        if (effects.hasSideEffects() || !Properties::isObservablyDeterministic(
                                          curr, getModule()->features)) {
          requestInfos[curr].requests = 0;
        } else {
          activeOriginals.emplace(
            curr, ActiveOriginalInfo{info.requests, std::move(effects)});
        }
      } else if (info.original) {
        // The original may have already been invalidated.
        auto iter = activeOriginals.find(info.original);
        if (iter != activeOriginals.end()) {
          // After visiting this expression, we have one less request for its
          // original, and perhaps none are left.
          auto& originalInfo = iter->second;
          if (originalInfo.requestsLeft == 1) {
            activeOriginals.erase(info.original);
          } else {
            originalInfo.requestsLeft--;
          }
        }
      }
    }
  }

  static void doNoteNonLinear(Checker* self, Expression** currp) {
    // Between basic blocks there can be no active originals.
    assert(self->activeOriginals.empty());
  }

  void visitFunction(Function* curr) {
    // At the end of the function there can be no active originals.
    assert(activeOriginals.empty());
  }
};

// Applies the optimization now that we know which requests are valid. We track
// the number of remaining valid requests (after Checker decreased them to leave
// only valid ones), and stop optimizing when none remain.
struct Applier
  : public LinearExecutionWalker<Applier, UnifiedExpressionVisitor<Applier>> {
  RequestInfoMap requestInfos;

  Applier(RequestInfoMap& requestInfos) : requestInfos(requestInfos) {}

  // Maps expressions that we save to locals to the local index for them.
  std::unordered_map<Expression*, Index> exprLocals;

  void visitExpression(Expression* curr) {
    auto iter = requestInfos.find(curr);
    if (iter == requestInfos.end()) {
      return;
    }

    const auto& info = iter->second;
    assert(!(info.requests && info.original));

    if (info.requests) {
      // We have requests for this value. Add a local and tee the value to
      // there.
      Index local = exprLocals[curr] =
        Builder::addVar(getFunction(), curr->type);
      replaceCurrent(
        Builder(*getModule()).makeLocalTee(local, curr, curr->type));
    } else if (info.original) {
      auto& originalInfo = requestInfos.at(info.original);
      if (originalInfo.requests) {
        // This is a valid request of an original value. Get the value from the
        // local.
        assert(exprLocals.count(info.original));
        replaceCurrent(Builder(*getModule())
                         .makeLocalGet(exprLocals[info.original], curr->type));
        originalInfo.requests--;
      }
    }
  }

  static void doNoteNonLinear(Applier* self, Expression** currp) {
    // Clear the state between blocks.
    self->exprLocals.clear();
  }
};

} // anonymous namespace

struct LocalCSE : public WalkerPass<PostWalker<LocalCSE>> {
  bool isFunctionParallel() override { return true; }

  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  Pass* create() override { return new LocalCSE(); }

  void doWalkFunction(Function* func) {
    auto options = getPassOptions();

    Scanner scanner(options);
    scanner.walkFunctionInModule(func, getModule());

    Checker checker(options, scanner.requestInfos);
    checker.walkFunctionInModule(func, getModule());

    Applier applier(scanner.requestInfos);
    applier.walkFunctionInModule(func, getModule());

    TypeUpdating::handleNonDefaultableLocals(func, *getModule());
  }
};

Pass* createLocalCSEPass() { return new LocalCSE(); }

} // namespace wasm
