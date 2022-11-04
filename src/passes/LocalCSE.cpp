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
// algorithm, where we track "requests" to reuse a value. That is, if we see
// an add operation appear twice, and the inputs must be identical in both
// cases, then the second one requests to reuse the computed value from the
// first. The first one to appear is the "original" expression that will remain
// in the code; we will save its value to a local, and get it from that local
// later:
//
//  (i32.add (A) (B))
//  (i32.add (A) (B))
//
//    =>
//
//  (local.tee $temp (i32.add (A) (B)))
//  (local.get $temp)
//
// The algorithm used here is as follows:
//
//  * Scan: Hash each expression and see if it repeats later.
//          If it does:
//            * Note that the original appearance is requested to be reused
//              an additional time.
//            * Link the first expression as the original appearance of the
//              later one.
//            * Scan the children of the repeat and undo their requests to be
//              replaced (as if we will reuse the parent, we don't need to do
//              anything for the children, see below).
//
//  * Check: Check if effects prevent some of the requests from being done. For
//           example, if the value contains a load from memory, we cannot
//           optimize around a store, as the value before the store might be
//           different (see below).
//
//  * Apply: Go through the basic block again, this time adding a tee on an
//           expression whose value we want to use later, and replacing the
//           uses with gets.
//
// For example, here is what the algorithm would do on
//
//  (i32.eqz (A))
//  ..
//  (i32.eqz (A))
//
// Assuming A does not have side effects that interfere, this will happen:
//
//  1. Scan A and add it to the hash map of things we have seen.
//  2. Scan the eqz, and do the same for it.
//  3. Scan the second A. Increment the first A's requests counter, and mark the
//     second A as intended to be replaced by the original A.
//  4. Scan the second eqz, and do similar things for it: increment the requests
//     for the original eqz, and point to the original from the repeat.
//     * Then also scan its children, in this case A, and decrement the first
//       A's reuse counter, and unmark the second A's note that it is intended
//       to be replaced.
//  5. After that, the second eqz requests to be replaced by the first, and
//     there is no request on A.
//  6. Run through the block again, adding a tee and replacing the second eqz,
//     resulting in:
//
//   (local.tee $temp
//     (i32.eqz
//       (A)
//     )
//   )
//   (local.get $temp)
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
// different value, so we will invalidate the request to optimize here.
//
// This pass only finds entire expression trees, and not parts of them, so we
// will not optimize this:
//
//  (A (B (C (D1))))
//  (A (B (C (D2))))
//
// The innermost child is different, so the trees are not identical. However,
// running flatten before running this pass would allow those to be optimized as
// well (we would also need to simplify locals somewhat to allow the locals to
// be identified as identical, see pass.cpp).
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

// A full equality check for HashedExpressions. The hash is used as a speedup,
// but if it matches we still verify the contents are identical.
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
                                       SmallVector<Expression*, 1>,
                                       HEHasher,
                                       HEComparer>;

// Request information about an expression: whether it requests to be replaced,
// or it is an original expression whose value can be used to replace others
// later.
struct RequestInfo {
  // The number of other expressions that would like to reuse this value.
  Index requests = 0;

  // If this is a repeat value, this points to the original. (And we have
  // incremented the original's |requests|.)
  Expression* original = nullptr;

  void validate() const {
    // An expression cannot both be requested and make requests. If we see A
    // appear three times, both repeats must request from the very first.
    assert(!(requests && original));

    // When we encounter a requestInfo (after its initial creation) then it
    // must either request or be requested - otherwise, it should not exist,
    // as we remove unneeded things from our tracking.
    assert(requests || original);
  }
};

// A map of expressions to their request info.
struct RequestInfoMap : public std::unordered_map<Expression*, RequestInfo> {
  void dump(std::ostream& o) {
    for (auto& [curr, info] : *this) {
      o << *curr << " has " << info.requests << " reqs, orig: " << info.original
        << '\n';
    }
  }
};

struct Scanner
  : public LinearExecutionWalker<Scanner, UnifiedExpressionVisitor<Scanner>> {
  PassOptions& options;

  // Request info for all expressions ever seen.
  RequestInfoMap& requestInfos;

  Scanner(PassOptions& options, RequestInfoMap& requestInfos)
    : options(options), requestInfos(requestInfos) {}

  // Currently active hashed expressions in the current basic block. If we see
  // an active expression before us that is identical to us, then it becomes our
  // original expression that we request from.
  HashedExprs activeExprs;

  // Stack of hash values of all active expressions. We store these so that we
  // do not end up recomputing hashes of children in an N^2 manner.
  SmallVector<size_t, 10> activeHashes;

  static void doNoteNonLinear(Scanner* self, Expression** currp) {
    // We are starting a new basic block. Forget all the currently-hashed
    // expressions, as we no longer want to make connections to anything from
    // another block.
    self->activeExprs.clear();
    self->activeHashes.clear();
    // Note that we do not clear requestInfos - that is information we will use
    // later in the Applier class. That is, we've cleared all the active
    // information, leaving the things we need later.
  }

  void visitExpression(Expression* curr) {
    // Compute the hash, using the pre-computed hashes of the children, which
    // are saved. This allows us to hash everything in linear time.
    //
    // Note that we must compute the hash first, as we need it even for things
    // that are not isRelevant() (if they are the children of a relevant thing).
    auto numChildren = Properties::getNumChildren(curr);
    auto hash = ExpressionAnalyzer::shallowHash(curr);
    for (Index i = 0; i < numChildren; i++) {
      if (activeHashes.empty()) {
        // The child was in another block, so this expression cannot be
        // optimized.
        return;
      }
      hash_combine(hash, activeHashes.back());
      activeHashes.pop_back();
    }
    activeHashes.push_back(hash);

    // Check if this is something relevant for optimization.
    if (!isRelevant(curr)) {
      return;
    }

    auto& vec = activeExprs[HashedExpression(curr, hash)];
    vec.push_back(curr);
    if (vec.size() > 1) {
      // This is a repeat expression. Add a request for it.
      auto& info = requestInfos[curr];
      auto* original = vec[0];
      info.original = original;

      // Mark the request on the original. Note that this may create the
      // requestInfo for it, if it is the first request (this avoids us creating
      // requests eagerly).
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
          // The child never had a request. While it repeated (since the parent
          // repeats), it was not relevant for the optimization so we never
          // created a requestInfo for it.
          continue;
        }

        // Remove the child.
        auto& childInfo = requestInfos[child];
        auto* childOriginal = childInfo.original;
        requestInfos.erase(child);

        // Update the child's original, potentially erasing it too if no
        // requests remain.
        assert(childOriginal);
        auto& childOriginalRequests = requestInfos[childOriginal].requests;
        assert(childOriginalRequests > 0);
        childOriginalRequests--;
        if (childOriginalRequests == 0) {
          requestInfos.erase(childOriginal);
        }
      }
    }
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
    // and so adding one set+one get and removing one of the items itself
    // is not detrimental, and may be beneficial.
    // TODO: investigate size 2
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
  PassOptions& options;
  RequestInfoMap& requestInfos;

  Checker(PassOptions& options, RequestInfoMap& requestInfos)
    : options(options), requestInfos(requestInfos) {}

  struct ActiveOriginalInfo {
    // How many of the requests remain to be seen during our walk. When this
    // reaches 0, we know that the original is no longer requested from later in
    // the block.
    Index requestsLeft;

    // The effects in the expression.
    EffectAnalyzer effects;
  };

  // The currently relevant original expressions, that is, the ones that may be
  // optimized in the current basic block.
  std::unordered_map<Expression*, ActiveOriginalInfo> activeOriginals;

  void visitExpression(Expression* curr) {
    // This is the first time we encounter this expression.
    assert(!activeOriginals.count(curr));

    // Given the current expression, see what it invalidates of the currently-
    // hashed expressions, if there are any.
    if (!activeOriginals.empty()) {
      EffectAnalyzer effects(options, *getModule());
      // We only need to visit this node itself, as we have already visited its
      // children by the time we get here.
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

        // If no requests remain at all (that is, there were no requests we
        // could provide before we ran into this invalidation) then we do not
        // need this original at all.
        if (requestInfos[original].requests == 0) {
          requestInfos.erase(original);
        }

        activeOriginals.erase(original);
      }
    }

    auto iter = requestInfos.find(curr);
    if (iter == requestInfos.end()) {
      return;
    }
    auto& info = iter->second;
    info.validate();

    if (info.requests > 0) {
      // This is an original. Compute its side effects, as we cannot optimize
      // away repeated apperances if it has any.
      EffectAnalyzer effects(options, *getModule(), curr);

      // We can ignore traps here, as we replace a repeating expression with a
      // single appearance of it, a store to a local, and gets in the other
      // locations, and so if the expression traps then the first appearance -
      // that we keep around - would trap, and the others are never reached
      // anyhow. (The other checks we perform here, including invalidation and
      // determinism, will ensure that either all of the appearances trap, or
      // none of them.)
      effects.trap = false;

      // We also cannot optimize away something that is intrinsically
      // nondeterministic: even if it has no side effects, if it may return a
      // different result each time, then we cannot optimize away repeats.
      if (effects.hasSideEffects() ||
          Properties::isGenerative(curr, getModule()->features)) {
        requestInfos.erase(curr);
      } else {
        activeOriginals.emplace(
          curr, ActiveOriginalInfo{info.requests, std::move(effects)});
      }
    } else if (info.original) {
      // The original may have already been invalidated. If so, remove our info
      // as well.
      auto originalIter = activeOriginals.find(info.original);
      if (originalIter == activeOriginals.end()) {
        requestInfos.erase(iter);
        return;
      }

      // After visiting this expression, we have one less request for its
      // original, and perhaps none are left.
      auto& originalInfo = originalIter->second;
      if (originalInfo.requestsLeft == 1) {
        activeOriginals.erase(info.original);
      } else {
        originalInfo.requestsLeft--;
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

// Applies the optimization now that we know which requests are valid.
struct Applier
  : public LinearExecutionWalker<Applier, UnifiedExpressionVisitor<Applier>> {
  RequestInfoMap requestInfos;

  Applier(RequestInfoMap& requestInfos) : requestInfos(requestInfos) {}

  // Maps the original expressions that we save to locals to the local indexes
  // for them.
  std::unordered_map<Expression*, Index> originalLocalMap;

  void visitExpression(Expression* curr) {
    auto iter = requestInfos.find(curr);
    if (iter == requestInfos.end()) {
      return;
    }

    const auto& info = iter->second;
    info.validate();

    if (info.requests) {
      // We have requests for this value. Add a local and tee the value to
      // there.
      Index local = originalLocalMap[curr] =
        Builder::addVar(getFunction(), curr->type);
      replaceCurrent(
        Builder(*getModule()).makeLocalTee(local, curr, curr->type));
    } else if (info.original) {
      auto& originalInfo = requestInfos.at(info.original);
      if (originalInfo.requests) {
        // This is a valid request of an original value. Get the value from the
        // local.
        assert(originalLocalMap.count(info.original));
        replaceCurrent(
          Builder(*getModule())
            .makeLocalGet(originalLocalMap[info.original], curr->type));
        originalInfo.requests--;
      }
    }
  }

  static void doNoteNonLinear(Applier* self, Expression** currp) {
    // Clear the state between blocks.
    self->originalLocalMap.clear();
  }
};

} // anonymous namespace

struct LocalCSE : public WalkerPass<PostWalker<LocalCSE>> {
  bool isFunctionParallel() override { return true; }

  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<LocalCSE>();
  }

  void doWalkFunction(Function* func) {
    auto& options = getPassOptions();

    RequestInfoMap requestInfos;

    Scanner scanner(options, requestInfos);
    scanner.walkFunctionInModule(func, getModule());
    if (requestInfos.empty()) {
      // We did not find any repeated expressions at all.
      return;
    }

    Checker checker(options, requestInfos);
    checker.walkFunctionInModule(func, getModule());
    if (requestInfos.empty()) {
      // No repeated expressions remain after checking for effects.
      return;
    }

    Applier applier(requestInfos);
    applier.walkFunctionInModule(func, getModule());
  }
};

Pass* createLocalCSEPass() { return new LocalCSE(); }

} // namespace wasm
