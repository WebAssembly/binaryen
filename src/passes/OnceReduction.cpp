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
  std::unordered_map<Name, std::atomic<bool>> onceFuncs;
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

    // Perform the work using a stack. A work state includes which block we are
    // in, and which "once" globals we have seen either here or in the blocks
    // that dominate this one.
    struct Work {
      Index blockIndex;
      // TODO: Clever use of std::move for this? But the size here will be
      //       extremely small.
      std::unordered_map<Name> onceGlobalsWritten;
    };
    UniqueDeferredQueue<ChildAndParent> queue;

    // The work begins at the entry block, with no information.
    queue.push(Work{0, {}});

    while (!work.empty()) {
      auto work = work.pop();

      // Process the block.
      auto* block = blocks[work.blockIndex].get();
      auto& exprs = block->contents.exprs;
      for (auto* expr : exprs) {
        Name globalName;
        if (auto* set = expr->dynCast<GlobalSet>()) {
          // This global is written.
          globalName = set->name;
        } else if (auto* call = expr->dynCast<Call>()) {
          // The global used by the "once" func is written.
          globalName = optInfo.onceFuncs[call->name];
        } else {
          WASM_UNREACHABLE("invalid expr");
        }
        assert(optInfo.onceGlobals[globalName]);
        if (work.onceGlobalsWritten.count(globalName)) {
          // This global has already been written, so this set
      }
    }
  }

private:
  OptInfo& optInfo;
};

} // anonymous namespace

struct SimplifyGlobals : public Pass {
  PassRunner* runner;
  Module* module;

  OptimizableMap map;
  bool optimize;

  SimplifyGlobals(bool optimize = false) : optimize(optimize) {}

  void run(PassRunner* runner_, Module* module_) override {
    runner = runner_;
    module = module_;

    while (iteration()) {
    }
  }

  bool iteration() {
    analyze();

    // Removing unneeded writes can in some cases lead to more optimizations
    // that we need an entire additional iteration to perform, see below.
    bool more = removeUnneededWrites();

    preferEarlierImports();

    propagateConstantsToGlobals();

    propagateConstantsToCode();

    return more;
  }

  void analyze() {
    map.clear();

    // First, find out all the relevant info.
    for (auto& global : module->globals) {
      auto& info = map[global->name];
      if (global->imported()) {
        info.imported = true;
      }
    }
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Global) {
        map[ex->value].exported = true;
      }
    }
    Scanner(&map).run(runner, module);
    // We now know which are immutable in practice.
    for (auto& global : module->globals) {
      auto& info = map[global->name];
      if (global->mutable_ && !info.imported && !info.exported &&
          !info.written) {
        global->mutable_ = false;
      }
    }
  }

  // Removes writes from globals that will never do anything useful with the
  // written value anyhow. Returns whether an addition iteration is necessary.
  bool removeUnneededWrites() {
    bool more = false;

    // Globals that are not exports and not read from are unnecessary (even if
    // they are written to). Likewise, globals that are only read from in order
    // to write to themselves are unnecessary. First, find such globals.
    NameSet unnecessaryGlobals;
    for (auto& global : module->globals) {
      auto& info = map[global->name];

      if (!info.written) {
        // No writes occur here, so there is nothing for us to remove.
        continue;
      }

      if (info.imported || info.exported) {
        // If the global is observable from the outside, we can't do anythng
        // here.
        //
        // TODO: optimize the case of an imported but immutable global, etc.
        continue;
      }

      // We only ever optimize read-only-to-write if all of our reads are done
      // in places we identified as read-only-to-write. That is, we have
      // eliminated the possibility of any other uses. (Technically, each
      // read-to-write location might have more than one read since we did not
      // count them, but only verified there was one read or more; but this is
      // good enough as the common case has exactly one.)
      //
      // Note that there might be more writes, if there are additional writes
      // besides those in the read-only-to-write locations. But we can ignore
      // those, as whatever they write will not be read in order to do anything
      // of value.
      bool onlyReadOnlyToWrite = (info.read == info.readOnlyToWrite);

      // There is at least one write in each read-only-to-write location, unless
      // our logic is wrong somewhere.
      assert(info.written >= info.readOnlyToWrite);

      if (!info.read || onlyReadOnlyToWrite) {
        unnecessaryGlobals.insert(global->name);

        // We can now mark this global as immutable, and un-written, since we
        // are about to remove all the operations on it.
        global->mutable_ = false;
        info.written = 0;

        // Nested old-read-to-write expressions require another full iteration
        // to optimize, as we have:
        //
        //   if (a) {
        //     a = 1;
        //     if (b) {
        //       b = 1;
        //     }
        //   }
        //
        // The first iteration can only optimize b, as the outer if's body has
        // more effects than we understand. After finishing the first iteration,
        // b will no longer exist, removing those effects.
        if (onlyReadOnlyToWrite) {
          more = true;
        }
      }
    }

    // Remove all the sets on the unnecessary globals. Later optimizations can
    // then see that since the global has no writes, it is a constant, which
    // will lead to removal of gets, and after removing them, the global itself
    // will be removed as well.
    GlobalSetRemover(&unnecessaryGlobals, optimize).run(runner, module);

    return more;
  }

  void preferEarlierImports() {
    // Optimize uses of immutable globals, prefer the earlier import when
    // there is a copy.
    NameNameMap copiedParentMap;
    for (auto& global : module->globals) {
      auto child = global->name;
      if (!global->mutable_ && !global->imported()) {
        if (auto* get = global->init->dynCast<GlobalGet>()) {
          auto parent = get->name;
          if (!module->getGlobal(get->name)->mutable_) {
            copiedParentMap[child] = parent;
          }
        }
      }
    }
    if (!copiedParentMap.empty()) {
      // Go all the way back.
      for (auto& global : module->globals) {
        auto child = global->name;
        if (copiedParentMap.count(child)) {
          while (copiedParentMap.count(copiedParentMap[child])) {
            copiedParentMap[child] = copiedParentMap[copiedParentMap[child]];
          }
        }
      }
      // Apply to the gets.
      GlobalUseModifier(&copiedParentMap).run(runner, module);
    }
  }

  // Constant propagation part 1: even an mutable global with a constant
  // value can have that value propagated to another global that reads it,
  // since we do know the value during startup, it can't be modified until
  // code runs.
  void propagateConstantsToGlobals() {
    // Go over the list of globals in order, which is the order of
    // initialization as well, tracking their constant values.
    std::map<Name, Literals> constantGlobals;
    for (auto& global : module->globals) {
      if (!global->imported()) {
        if (Properties::isConstantExpression(global->init)) {
          constantGlobals[global->name] =
            getLiteralsFromConstExpression(global->init);
        } else if (auto* get = global->init->dynCast<GlobalGet>()) {
          auto iter = constantGlobals.find(get->name);
          if (iter != constantGlobals.end()) {
            Builder builder(*module);
            global->init = builder.makeConstantExpression(iter->second);
          }
        }
      }
    }
  }

  // Constant propagation part 2: apply the values of immutable globals
  // with constant values to to global.gets in the code.
  void propagateConstantsToCode() {
    NameSet constantGlobals;
    for (auto& global : module->globals) {
      if (!global->mutable_ && !global->imported() &&
          Properties::isConstantExpression(global->init)) {
        constantGlobals.insert(global->name);
      }
    }
    ConstantGlobalApplier(&constantGlobals, optimize).run(runner, module);
  }
};

remove once from funcs whose global is not once.

Pass* createSimplifyGlobalsPass() { return new SimplifyGlobals(false); }

Pass* createSimplifyGlobalsOptimizingPass() {
  return new SimplifyGlobals(true);
}

} // namespace wasm
