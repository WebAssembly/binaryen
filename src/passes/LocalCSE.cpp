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
#include <ir/hashed.h>
#include <ir/iteration.h>
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

// Maps hashed expressions to those relevant expressions. That is, all
// expressions that are equivalent (same hash, and also compare equal) will
// be in a vector for the corresponding entry in this map.
using HashedExprs = std::unordered_map<HashedExpression,
                                       std::vector<Expression*>,
                                       HEHasher,
                                       HEComparer>;

// Information about an expression.
struct Info {
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

  // Currently hashed expressions in the current basic block, in their
  // equivalence classes.
  HashedExprs blockExprs;

  // The effects of hashed expressions
  std::unordered_map<Expression*, EffectAnalyzer> blockEffects;

  // Information about repetition of expressions in the current basic block.
  std::unordered_map<Expression*, Info> blockInfos;

  static void doNoteNonLinear(Scanner* self, Expression** currp) {
    // We are starting a new basic block. Forget all the currently-hashed
    // expressions, as we no longer want to make connections to anything from
    // another block.
    self->blockExprs.clear();
  }

  void visitExpression(Expression* curr) {
    checkInvalidations(curr);

    if (!isRelevant(curr)) {
      return;
    }

    // TODO: Do shallow hashing so that we can add child hashes to parents, to
    // avoid quadratic time FIXME
    auto& vec = blockExprs[curr];
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

  // Only some values are relevant to be optimized.
  bool isRelevant(Expression* curr) {
    if (curr->is<LocalGet>() || curr->is<LocalSet>() || curr->is<Const>()) {
      return false; // trivial
    }
    if (!curr->type.isConcrete()) {
      return false; // don't bother with unreachable etc.
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

  // CSE adds and reuses locals.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  Pass* create() override { return new LocalCSE(); }

  void doWalkFunction(Function* func) {
    // TODO: do we need iterations here?

    Scanner scanner(getPassOptions());
    scanner.walkFunctionInModule(func, getModule());

    Applier applier(scanner);
    applier.walkFunctionInModule(func, getModule());

    // Non-nullable fixups FIXME TODO
  }
};

Pass* createLocalCSEPass() { return new LocalCSE(); }

} // namespace wasm
