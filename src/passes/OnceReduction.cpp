/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Reduces the amount of calls to functions that only run once. A "run-once"
// or "once" function is a function guarded by a global to make sure it runs a
// single time:
//
//  global foo$once = 0;
//
//  function foo() {
//    if (foo$once) return;
//    foo$once = 1;
//    ..do some work..
//  }
//
// If we verify that there are no other kind of sets to that global - that is,
// it is only used to guard this code - then we can remove subsequent calls to
// the function,
//
//  foo();
//  ..stuff..
//  foo(); // this call can be removed
//
// The latter call can be removed since it has definitely run by then.
//
// TODO: "Once" globals are effectively boolean in that all non-zero values are
//       indistinguishable, and so we could rewrite them all to be 1.
//

#include <atomic>

#include "cfg/domtree.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct OptInfo {
  // Maps global names to whether they are possible indicators of "once"
  // functions. A "once" global has these properties:
  //
  //  * They are only ever written to with non-zero values.
  //  * They are never read from except in the beginning of a "once" function
  //    (otherwise, execution might be affected by the specific values of the
  //    global, instead of just using it to guard the "once" function).
  //
  // Those properties ensure that the global is monotonic in the sense that it
  // begins at zero and, if they are written to, will only receive a non-zero
  // value - they never return to 0.
  std::unordered_map<Name, std::atomic<bool>> onceGlobals;

  // Maps functions to whether they are "once", by indicating the global that
  // they use for that purpose. An empty name means they are not "once".
  std::unordered_map<Name, Name> onceFuncs;

  // For each function, the "once" globals that are definitely set after calling
  // it. If the function is "once" itself, that is included, but it also
  // includes any other "once" functions we definitely call, and so forth.
  // The "new" version is written to in each iteration, and then swapped with
  // the main one (to avoid reading and writing in parallel).
  std::unordered_map<Name, std::unordered_set<Name>> onceGlobalsSetInFuncs,
    newOnceGlobalsSetInFuncs;
};

struct Scanner : public WalkerPass<PostWalker<Scanner>> {
  bool isFunctionParallel() override { return true; }

  bool modifiesBinaryenIR() override { return false; }

  Scanner(OptInfo& optInfo) : optInfo(optInfo) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Scanner>(optInfo);
  }

  // All the globals we read from. Any read of a global prevents us from
  // optimizing, unless it is the single read at the top of an "only" function
  // (as other reads might be used to check for the value of the global in
  // complex ways that we do not want to try to reason about).
  std::unordered_map<Name, Index> readGlobals;

  void visitGlobalGet(GlobalGet* curr) { readGlobals[curr->name]++; }

  void visitGlobalSet(GlobalSet* curr) {
    if (!curr->value->type.isInteger()) {
      // This is either a type we don't care about, or an unreachable set which
      // we also don't care about.
      return;
    }

    if (auto* c = curr->value->dynCast<Const>()) {
      if (c->value.getInteger() > 0) {
        // This writes a non-zero constant, which is what we hoped for.
        return;
      }
    }

    // This is not a constant, or it is zero - failure.
    optInfo.onceGlobals.at(curr->name) = false;
  }

  void visitFunction(Function* curr) {
    // TODO: support params and results?
    if (curr->getParams() == Type::none && curr->getResults() == Type::none) {
      auto global = getOnceGlobal(curr->body);
      if (global.is()) {
        // This is a "once" function, as best we can tell for now. Further
        // information may cause a problem, say, if the global is used in a bad
        // way in another function, so we may undo this.
        optInfo.onceFuncs.at(curr->name) = global;

        // We can ignore the get in the "once" pattern at the top of the
        // function.
        readGlobals[global]--;
      }
    }

    for (auto& [global, count] : readGlobals) {
      if (count > 0) {
        // This global has reads we cannot reason about, so do not optimize it.
        optInfo.onceGlobals.at(global) = false;
      }
    }
  }

  // Check if a function body is in the "once" pattern. Return the name of the
  // global if so, or an empty name otherwise.
  //
  // TODO: This pattern can show up in random places and not just at the top of
  //       the "once" function - say, if that function was inlined somewhere -
  //       so it might be good to look for the more general pattern everywhere.
  // TODO: Handle related patterns like if (!once) { .. }, but other opts will
  //       tend to normalize to this form anyhow.
  Name getOnceGlobal(Expression* body) {
    // Look the pattern mentioned above:
    //
    //  function foo() {
    //    if (foo$once) return;
    //    foo$once = 1;
    //    ...
    //
    // TODO: if we generalize this to allow more conditions than just a
    //       global.get, this could be merged with
    //       SimplifyGlobals::GlobalUseScanner::visitFunction().
    auto* block = body->dynCast<Block>();
    if (!block) {
      return Name();
    }
    auto& list = block->list;
    if (list.size() < 2) {
      return Name();
    }
    auto* iff = list[0]->dynCast<If>();
    if (!iff) {
      return Name();
    }
    auto* get = iff->condition->dynCast<GlobalGet>();
    if (!get) {
      return Name();
    }
    if (!iff->ifTrue->is<Return>() || iff->ifFalse) {
      return Name();
    }
    auto* set = list[1]->dynCast<GlobalSet>();

    // Note that we have already checked the set's value earlier - that if it is
    // reached then it writes a non-zero constant. Those are properties that we
    // need from all sets. For this specific set, we also need it to actually
    // perform the write, that is, to not be unreachable (otherwise, the global
    // is not written here, and the function can execute more than once).
    if (!set || set->name != get->name || set->type == Type::unreachable) {
      return Name();
    }
    return get->name;
  }

private:
  OptInfo& optInfo;
};

// Information in a basic block.
struct BlockInfo {
  // We track relevant expressions, which are call to "once" functions, and
  // writes to "once" globals.
  std::vector<Expression*> exprs;
};

// Performs optimization in all functions. This reads onceGlobalsSetInFuncs in
// order to know what "once" globals are written by each function (so that when
// we see a call, we can infer things), and when it finishes with a function it
// has learned which "once" globals it must set, and it then writes out
// newOnceGlobalsSetInFuncs with that result. Later iterations will then use
// those values in place of onceGlobalsSetInFuncs, which propagate things to
// callers. This in effect mixes local optimization with the global propagation
// - as we need to run the full local optimization in order to infer the new
// values for onceGlobalsSetInFuncs, that is unavoidable (in principle, we could
// also do a full propagation to a fixed point in between running local
// optimization, but that would require more code - it might be more efficient,
// though).
struct Optimizer
  : public WalkerPass<CFGWalker<Optimizer, Visitor<Optimizer>, BlockInfo>> {
  bool isFunctionParallel() override { return true; }

  Optimizer(OptInfo& optInfo) : optInfo(optInfo) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Optimizer>(optInfo);
  }

  void visitGlobalSet(GlobalSet* curr) {
    if (currBasicBlock) {
      currBasicBlock->contents.exprs.push_back(curr);
    }
  }

  void visitCall(Call* curr) {
    if (currBasicBlock) {
      currBasicBlock->contents.exprs.push_back(curr);
    }
  }

  void doWalkFunction(Function* func) {
    using Parent =
      WalkerPass<CFGWalker<Optimizer, Visitor<Optimizer>, BlockInfo>>;

    // Walk the function to builds the CFG.
    Parent::doWalkFunction(func);
    if (basicBlocks.empty()) {
      return;
    }

    // Build a dominator tree, which then tells us what to remove: if a call
    // appears in block A, then we do not need to make any calls in any blocks
    // dominated by A.
    DomTree<Parent::BasicBlock> domTree(basicBlocks);

    // Perform the work by going through the blocks in reverse postorder and
    // filling out which "once" globals have been written to.

    // Each index in this vector is the set of "once" globals written to in the
    // basic block with the same index.
    std::vector<std::unordered_set<Name>> onceGlobalsWrittenVec;
    auto numBlocks = basicBlocks.size();
    onceGlobalsWrittenVec.resize(numBlocks);

    for (Index i = 0; i < numBlocks; i++) {
      auto* block = basicBlocks[i].get();

      // Note that we take a reference here, which is how the data we accumulate
      // ends up stored. The blocks we dominate will see it later.
      auto& onceGlobalsWritten = onceGlobalsWrittenVec[i];

      // Note information from our immediate dominator.
      // TODO: we could also intersect information from all of our preds.
      auto parent = domTree.iDoms[i];
      if (parent == domTree.nonsense) {
        // This is either the entry node (which we need to process), or an
        // unreachable block (which we do not need to process - we leave that to
        // DCE).
        if (i > 0) {
          continue;
        }
      } else {
        // This block has an immediate dominator, so we know that everything
        // written to there can be assumed written.
        onceGlobalsWritten = onceGlobalsWrittenVec[parent];
      }

      // Process the block's expressions.
      auto& exprs = block->contents.exprs;
      for (auto* expr : exprs) {
        // Given the name of a "once" global that is written by this
        // instruction, optimize.
        auto optimizeOnce = [&](Name globalName) {
          assert(optInfo.onceGlobals.at(globalName));
          auto res = onceGlobalsWritten.emplace(globalName);
          if (!res.second) {
            // This global has already been written, so this expr is not needed,
            // regardless of whether it is a global.set or a call.
            //
            // Note that assertions below verify that there are no children that
            // we need to keep around, and so we can just nop the entire node.
            ExpressionManipulator::nop(expr);
          } else {
            // From here on, this global is set, hopefully allowing us to
            // optimize away others.
          }
        };

        if (auto* set = expr->dynCast<GlobalSet>()) {
          if (optInfo.onceGlobals.at(set->name)) {
            // This global is written.
            assert(set->value->is<Const>());
            optimizeOnce(set->name);
          }
        } else if (auto* call = expr->dynCast<Call>()) {
          auto target = call->target;
          if (optInfo.onceFuncs.at(target).is()) {
            // The global used by the "once" func is written.
            assert(call->operands.empty());
            optimizeOnce(optInfo.onceFuncs.at(target));
            continue;
          }

          // Note as written all globals the called function is known to write.
          for (auto globalName : optInfo.onceGlobalsSetInFuncs.at(target)) {
            onceGlobalsWritten.insert(globalName);
          }
        } else {
          WASM_UNREACHABLE("invalid expr");
        }
      }
    }

    // As a result of the above optimization, we know which "once" globals are
    // definitely written in this function. Regardless of whether this is a
    // "once" function itself, that set of globals can be used in further
    // optimizations, as any call to this function must set those.
    // TODO: Aside from the entry block, we could intersect all the exit blocks.
    optInfo.newOnceGlobalsSetInFuncs[func->name] =
      std::move(onceGlobalsWrittenVec[0]);
  }

private:
  OptInfo& optInfo;
};

} // anonymous namespace

struct OnceReduction : public Pass {
  void run(Module* module) override {
    OptInfo optInfo;

    // Fill out the initial data.
    for (auto& global : module->globals) {
      // For a global to possibly be "once", it must be an integer, and to not
      // be imported (as a mutable import may be read and written to from the
      // outside). As we scan code we will turn this into false if we see
      // anything that proves the global is not "once".
      // TODO: This limitation could perhaps only be on mutable ones, but
      //       immutable globals will not be considered "once" anyhow as they do
      //       not fit the pattern of being written after the first call.
      // TODO: non-integer types?
      optInfo.onceGlobals[global->name] =
        global->type.isInteger() && !global->imported();
    }
    for (auto& func : module->functions) {
      // Fill in the map so that it can be operated on in parallel.
      optInfo.onceFuncs[func->name] = Name();
    }
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Global) {
        // An exported global cannot be "once" since the outside may read and
        // write to it in ways we are unaware.
        // TODO: See comment above on mutability.
        optInfo.onceGlobals[ex->value] = false;
      }
    }

    // Scan the module to find out which globals and functions are "once".
    Scanner(optInfo).run(getPassRunner(), module);

    // Combine the information. We found which globals appear to be "once", but
    // other information may have proven they are not so, in fact. Specifically,
    // for a function to be "once" we need its global to also be such.
    for (auto& [_, onceGlobal] : optInfo.onceFuncs) {
      if (onceGlobal.is() && !optInfo.onceGlobals[onceGlobal]) {
        onceGlobal = Name();
      }
    }

    // Optimize using what we found. Keep iterating while we find things to
    // optimize, which we estimate using a counter of the total number of once
    // globals set by functions: as that increases, it means we are propagating
    // useful information.
    // TODO: limit # of iterations?
    Index lastOnceGlobalsSet = 0;

    // First, initialize onceGlobalsSetInFuncs for the first iteration, by
    // ensuring each item is present, and adding the "once" global for "once"
    // funcs.
    bool foundOnce = false;
    for (auto& func : module->functions) {
      // Either way, at least fill the data structure for parallel operation.
      auto& set = optInfo.onceGlobalsSetInFuncs[func->name];

      auto global = optInfo.onceFuncs[func->name];
      if (global.is()) {
        set.insert(global);
        foundOnce = true;
      }
    }

    if (!foundOnce) {
      // Nothing to optimize.
      return;
    }

    while (1) {
      // Initialize all the items in the new data structure that will be
      // populated.
      for (auto& func : module->functions) {
        optInfo.newOnceGlobalsSetInFuncs[func->name];
      }

      Optimizer(optInfo).run(getPassRunner(), module);

      optInfo.onceGlobalsSetInFuncs =
        std::move(optInfo.newOnceGlobalsSetInFuncs);

      // Count how many once globals are set, and see if we have any more work
      // to do.
      Index currOnceGlobalsSet = 0;
      for (auto& [_, globals] : optInfo.onceGlobalsSetInFuncs) {
        currOnceGlobalsSet += globals.size();
      }
      assert(currOnceGlobalsSet >= lastOnceGlobalsSet);
      if (currOnceGlobalsSet > lastOnceGlobalsSet) {
        lastOnceGlobalsSet = currOnceGlobalsSet;
        continue;
      }
      break;
    }

    // Finally, apply some optimizations to "once" functions themselves. We do
    // this at the end to not modify them as we go, which could confuse the main
    // part of this pass right before us.
    optimizeOnceBodies(optInfo, module);
  }

  void optimizeOnceBodies(const OptInfo& optInfo, Module* module) {
    // Track which "once" functions we remove the exit logic from, as we cannot
    // create loops without exit logic, see below.
    std::unordered_set<Name> removedExitLogic;

    // Iterate deterministically on functions, as the order matters (since we
    // make decisions based on previous actions; see below).
    for (auto& func : module->functions) {
      if (!optInfo.onceFuncs.at(func->name).is()) {
        // This is not a "once" function.
        continue;
      }

      // We optimize the case where the payload is trivial, that is where we
      // have this:
      //
      //  function foo() {
      //    if (!foo$once) return;   //  two lines of
      //    foo$once = 1;            // early-exit code
      //    PAYLOAD
      //  }
      //
      // And PAYLOAD is simple.
      auto* body = func->body;
      auto& list = body->cast<Block>()->list;
      if (list.size() == 2) {
        // No payload at all; we don't need the early-exit code then.
        //
        // Note that this overlaps with SimplifyGlobals' optimization on
        // "read-only-to-write" globals: with no payload, this global is really
        // only read in order to write itself, and nothing more, so there is no
        // observable behavior we need to preserve, and the global can be
        // removed. We might as well handle this case here as well since we've
        // done all the work up to here, and it is just one line to implement
        // the nopping out. (And doing so here can accelerate the optimization
        // pipeline by not needing to wait until the next SimplifyGlobals.)
        ExpressionManipulator::nop(body);
        continue;
      }
      if (list.size() != 3) {
        // Something non-trivial; too many items for us to consider.
        continue;
      }
      auto* payload = list[2];
      if (auto* call = payload->dynCast<Call>()) {
        if (optInfo.onceFuncs.at(call->target).is()) {
          // All this "once" function does is call another. We do not need the
          // early-exit logic in this one, then, because of the following
          // reasoning. We are comparing these forms:
          //
          //  // BEFORE
          //  function foo() {
          //    if (!foo$once) return;   //  two lines of
          //    foo$once = 1;            // early-exit code
          //    bar();
          //  }
          //
          // to
          //
          //  // AFTER
          //  function foo() {
          //    bar();
          //  }
          //
          // The question is whether different behavior can be observed between
          // those two. There are two cases, when we enter foo:
          //
          //  1. foo has been called before. Then we early-exit in BEFORE, and
          //     in AFTER we call bar which will early-exit (since foo was
          //     called, which means bar was at least entered, which set its
          //     global; bar might be on the stack, if it called foo, so it has
          //     not necessarily fully executed - this is a tricky situation to
          //     handle in general, like recursive imports of modules in various
          //     languages - but we do know bar has been *entered*, which means
          //     the global was set).
          //  2. foo has never been called before. In this case in BEFORE we set
          //     the global and call bar, and in AFTER we also call bar.
          //
          // Thus, the behavior is the same, and we can remove the early-exit
          // lines. Note that things would be quite different if we had any code
          // after the call to bar(), as then that code would no longer be
          // guarded by an early-exit (and could end up called more than once).
          // That is, this optimization depends on the fact that bar's call from
          // foo is being guarded by two sets of early-exits, one in foo and one
          // in bar, and therefore we only really need one; if foo did anything
          // more than just call bar, that would be incorrect.
          //
          // We must be careful of loops, however: If A calls B and B calls A,
          // then at least one must keep the early-exit logic, or else they
          // would infinitely loop if one is called. To avoid that, we track
          // which functions we remove the early-exit logic from, and never
          // remove the logic if we are calling such a function. (As a result,
          // the order of iteration matters here, and so the outer loop in this
          // function must be deterministic.)
          if (!removedExitLogic.count(call->target)) {
            ExpressionManipulator::nop(list[0]);
            ExpressionManipulator::nop(list[1]);
            removedExitLogic.insert(func->name);
          }
        }
      }
    }
  }
};

Pass* createOnceReductionPass() { return new OnceReduction(); }

} // namespace wasm
