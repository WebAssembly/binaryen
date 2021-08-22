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
// The latter call is can be removed since it has definitely run by then.
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
  // functions. That means:
  //
  //  * They begin as 0.
  //  * They are only ever written to with non-zero values.
  //  * All writes to the global occur after a check for the global being 0.
  //
  // Those properties ensure that the global is monotonic in the sense that it
  // begins at zero and, if they are written to, will only receive a non-zero
  // value - they never return to 0.
  std::unordered_map<Name, std::atomic<bool>> onceGlobals;

  // Maps functions to whether they are run-once, by indicating the global that
  // they use for that purpose. An empty name means they are not once.
  std::unordered_map<Name, Name> onceFuncs;
};

struct Scanner : public WalkerPass<PostWalker<Scanner>> {
  bool isFunctionParallel() override { return true; }

  Scanner(OptInfo& optInfo) : optInfo(optInfo) {}

  Scanner* create() override { return new Scanner(optInfo); }

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
    optInfo.onceGlobals[curr->name] = false;
  }

  void visitFunction(Function* curr) {
    // TODO: support params and results?
    if (curr->getParams() != Type::none || curr->getResults() != Type::none ||
        !isOnce(curr->body)) {
      optInfo.onceFuncs[curr->name] = false;
    }
  }

  void isOnce(Expression* body) {
    // Look the pattern mentioned above:
    //
    //  function foo() {
    //    if (foo$once) return;
    //    foo$once = 1;
    //    ...
    //
    auto* block = curr->body->dynCast<Block>();
    if (!block) {
      return false;
    }
    auto& list = block->list;
    if (list.size() < 2) {
      return false;
    }
    auto* iff = list[0]->dynCast<iff>();
    if (!iff) {
      return false;
    }
    auto* get = iff->condition->dynCast<GlobalGet>();
    if (!get) {
      return false;
    }
    if (!iff->ifTrue->is<Return>() || iff->ifFalse) {
      return false;
    }
    auto* set = list[1]->dynCast<GlobalSet>();
    // Note that we have already checked the set's value earlier, but we do need
    // it to not be unreachable (so it is actually set).
    if (!set || set->name != get->name || set->type == Type::unreachable) {
      return false;
    }
    return true;
  }

private:
  OptInfo& optInfo;
};

// Information in a basic block. We track relevant expressions which are calls
// calls to "once" functions, and writes to "once" globals.
struct BlockInfo {
  std::vector<Expression*> exprs;
};

struct Optimizer
  : public WalkerPass<CFGWalker<Optimizer,
                                Visitor<Optimizer>,
                                BlockInfo>> {
  bool isFunctionParallel() override { return true; }

  Optimizer(OptInfo& optInfo) : optInfo(optInfo) {}

  Optimizer* create() override { return new Optimizer(optInfo); }

  void visitGlobalSet(visitGlobalSet* curr) {
    if (optInfo.onceGlobals[curr->name].is()) {
      currBasicBlock->contents.exprs.push_back(curr);
    }
  }

  void visitCall(Call* curr) {
    if (optInfo.onceFuncs[curr->name].is()) {
      currBasicBlock->contents.exprs.push_back(curr);
    }
  }

  void doWalkFunction(Function* curr) {
    using Parent = WalkerPass<CFGWalker<Optimizer,
                                Visitor<Optimizer>,
                                BlockInfo>;
    // Walk the function, which optimizes some calls and which also builds the
    // CFG.
    Parent::doWalkFunction(curr);

    // Build a dominator tree, which then tells us what to remove: if a call
    // appears in block A, then we do not need to make any calls in any blocks
    // dominated by A.
    DomTree<Parent::BasicBlock> domTree(blocks);

    // Perform the work by going through the blocks in reverse postorder and
    // filling out which "once" globals have been written to.
    auto numBlocks = blocks.size();
    std::vector<std::unordered_map<Name>> onceGlobalsWrittenVec;
    onceGlobalsWrittenVec.resize(numBlocks);

    for (Index i = 0; i < blocks.size(); i++) {
      // Note that we take a reference here, which is how the data we accumulate
      // ends up stored for blocks we dominate to see later.
      auto& onceGlobalsWritten = onceGlobalsWrittenVec[i];

      // Note information from our immediate dominator.
      auto parent = domTree.parents[i];
      if (parent == domTree.nonsense) {
        // This is either the entry node, or an unreachable block.
        if (i > 0) {
          // We do not need to process unreachable blocks (leave that to DCE).
          continue;
        }
      } else {
        // This block has an immediate dominator, so we know that everything
        // written to there can be assumed writte.
        onceGlobalsWritten = onceGlobalsWrittenVec[parent];
      }

      // Process the block's expressions.
      auto* block = blocks[work.blockIndex].get();
      auto& exprs = block->contents.exprs;
      for (auto* expr : exprs) {
        Name globalName;
        if (auto* set = expr->dynCast<GlobalSet>()) {
          // This global is written.
          globalName = set->name;
          assert(set->value->is<Const>());
        } else if (auto* call = expr->dynCast<Call>()) {
          // The global used by the "once" func is written.
          globalName = optInfo.onceFuncs[call->name];
          assert(curr->operands.empty());
        } else {
          WASM_UNREACHABLE("invalid expr");
        }
        assert(optInfo.onceGlobals[globalName]);
        if (work.onceGlobalsWritten.count(globalName)) {
          // This global has already been written, so this expr is not needed,
          // regardless of whether it is a global.set or a call.
          //
          // Note that assertions above verify that there are no children that
          // we need to keep around, and so we can just nop the entire node.
          ExpressionManipulator::nop(expr);
        } else {
          // From here on, this global is set.
          work.onceGlobalsWritten.insert(globalName);
        }
      }
    }
  }

private:
  OptInfo& optInfo;
};

} // anonymous namespace

struct OnceReduction : public Pass {
  void run(PassRunner* runner_, Module* module_) override {
    OptInfo optInfo;

    // Fill out the data so it can be processed in parallel.
    for (auto& global : module->globals) {
      optInfo.onceGlobals[global->name] = false;
    }
    for (auto& func : module->funcs) {
      optInfo.onceFuncs[func->name] = Name();
    }

    // Scan the module to find out which globals and functions are "once".
    Scanner(optInfo).run(runner, module);

    // Combine the information. We found which globals are "once", but we need
    // to do more work for functions: so far we just noted which functions
    // appear to be in the form of a "once" function, but their global must also
    // have that property.
    for (auto& kv : optInfo.onceFuncs) {
      Name func = kv.first;
      Name& onceGlobal = kv.second;
      if (onceGlobal.is() && !optInfo.onceGlobals[onceGlobal]) {
        onceGlobal = Name();
      }
    }

    // Optimize using what we found. TODO: don't do this if we found nothing.
    Optimizer(optInfo).run(runner, module);
  }
};

Pass* createOnceReductionPass() { return new OnceReduction(false); }

} // namespace wasm
