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
// Simplify and optimize globals and their use.
//
//  * Turns never-written and unwritable (not imported or exported)
//    globals immutable.
//  * If an immutable global is a copy of another, use the earlier one,
//    to allow removal of the copies later.
//  * Apply the constant values of immutable globals.
//  * Apply the constant values of previous global.sets, in a linear
//    execution trace.
//  * Remove writes to globals that are never read from.
//  * Remove writes to globals that are only read from in order to write (see
//    below, "readOnlyToWrite").
//
// Some globals may not have uses after these changes, which we leave
// to other passes to optimize.
//
// This pass has a "optimize" variant (similar to inlining and DAE)
// that also runs general function optimizations where we managed to replace
// a constant value. That is helpful as such a replacement often opens up
// further optimization opportunities.
//

#include <atomic>

#include "ir/effects.h"
#include "ir/linear-execution.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct GlobalInfo {
  // Whether the global is imported and exported.
  bool imported = false;
  bool exported = false;

  // How many times the global is written and read.
  std::atomic<Index> written{0};
  std::atomic<Index> read{0};

  // How many times the global is "read, but only to write", that is, is used in
  // this pattern:
  //
  //   if (global == X) { global = Y }
  //
  // where X and Y have no side effects. If all we have are such reads only to
  // write then the global is really not necessary, even though there are both
  // reads and writes of it.
  //
  // This pattern can show up in global initialization code, where in the block
  // alongside "global = Y" there was some useful code, but the optimizer
  // managed to remove it. For example,
  //
  //   if (global == 0) { global = 1; sideEffect(); }
  //
  // If the global's initial value is the default 0, and there are no other uses
  // of this global, then this code will run sideEffect() the very first time we
  // reach here. We therefore need to keep this global and its reads and writes.
  // However, if sideEffect() were removed, then we read the global only to
  // write it - and nothing else - and so we can optimize away that global
  // entirely.
  std::atomic<Index> readOnlyToWrite{0};
};

using GlobalInfoMap = std::map<Name, GlobalInfo>;

struct GlobalUseScanner : public WalkerPass<PostWalker<GlobalUseScanner>> {
  bool isFunctionParallel() override { return true; }

  GlobalUseScanner(GlobalInfoMap* infos) : infos(infos) {}

  GlobalUseScanner* create() override { return new GlobalUseScanner(infos); }

  void visitGlobalSet(GlobalSet* curr) { (*infos)[curr->name].written++; }

  void visitGlobalGet(GlobalGet* curr) { (*infos)[curr->name].read++; }

  void visitIf(If* curr) {
    // We are looking for
    //
    //   if (global == X) { global = Y }
    //
    // Ignore an if-else, which cannot be that.
    if (curr->ifFalse) {
      return;
    }

    auto global =
      firstOnlyReadsGlobalWhichSecondOnlyWrites(curr->condition, curr->ifTrue);
    if (global.is()) {
      // This is exactly the pattern we sought!
      (*infos)[global].readOnlyToWrite++;
    }
  }

  // Checks if the first expression only reads a certain global, and has no
  // other effects, and the second only writes that same global, and also has no
  // other effects. Returns the global name if so, or a null name otherwise.
  Name firstOnlyReadsGlobalWhichSecondOnlyWrites(Expression* first,
                                                 Expression* second) {
    // See if reading a specific global is the only effect the first has.
    EffectAnalyzer firstEffects(getPassOptions(), *getModule(), first);

    if (firstEffects.immutableGlobalsRead.size() +
          firstEffects.mutableGlobalsRead.size() !=
        1) {
      return Name();
    }
    Name global;
    if (firstEffects.immutableGlobalsRead.size() == 1) {
      global = *firstEffects.immutableGlobalsRead.begin();
      firstEffects.immutableGlobalsRead.clear();
    } else {
      global = *firstEffects.mutableGlobalsRead.begin();
      firstEffects.mutableGlobalsRead.clear();
    }
    if (firstEffects.hasAnything()) {
      return Name();
    }

    // See if writing the same global is the only effect the second has. (Note
    // that we don't need to care about the case where the second has no effects
    // at all - other passes would handle that trivial situation.)
    EffectAnalyzer secondEffects(getPassOptions(), *getModule(), second);
    if (secondEffects.globalsWritten.size() != 1) {
      return Name();
    }
    auto writtenGlobal = *secondEffects.globalsWritten.begin();
    if (writtenGlobal != global) {
      return Name();
    }
    secondEffects.globalsWritten.clear();
    if (secondEffects.hasAnything()) {
      return Name();
    }

    return global;
  }

  void visitFunction(Function* curr) {
    // We are looking for a function body like this:
    //
    //   if (global == X) return;
    //   global = Y;
    //
    // And nothing else at all. Note that this does not overlap with the if
    // pattern above (the assignment is in the if body) so we will never have
    // overlapping matchings (which would each count as 1, leading to a
    // miscount).

    if (curr->body->type != Type::none) {
      return;
    }

    auto* block = curr->body->dynCast<Block>();
    if (!block) {
      return;
    }

    auto& list = block->list;
    if (list.size() != 2) {
      return;
    }

    auto* iff = list[0]->dynCast<If>();
    if (!iff || iff->ifFalse || !iff->ifTrue->is<Return>()) {
      return;
    }

    auto global =
      firstOnlyReadsGlobalWhichSecondOnlyWrites(iff->condition, list[1]);
    if (global.is()) {
      // This is exactly the pattern we sought!
      (*infos)[global].readOnlyToWrite++;
    }
  }

private:
  GlobalInfoMap* infos;
};

using NameNameMap = std::map<Name, Name>;
using NameSet = std::set<Name>;

struct GlobalUseModifier : public WalkerPass<PostWalker<GlobalUseModifier>> {
  bool isFunctionParallel() override { return true; }

  GlobalUseModifier(NameNameMap* copiedParentMap)
    : copiedParentMap(copiedParentMap) {}

  GlobalUseModifier* create() override {
    return new GlobalUseModifier(copiedParentMap);
  }

  void visitGlobalGet(GlobalGet* curr) {
    auto iter = copiedParentMap->find(curr->name);
    if (iter != copiedParentMap->end()) {
      curr->name = iter->second;
    }
  }

private:
  NameNameMap* copiedParentMap;
};

struct ConstantGlobalApplier
  : public WalkerPass<
      LinearExecutionWalker<ConstantGlobalApplier,
                            UnifiedExpressionVisitor<ConstantGlobalApplier>>> {
  bool isFunctionParallel() override { return true; }

  ConstantGlobalApplier(NameSet* constantGlobals, bool optimize)
    : constantGlobals(constantGlobals), optimize(optimize) {}

  ConstantGlobalApplier* create() override {
    return new ConstantGlobalApplier(constantGlobals, optimize);
  }

  void visitExpression(Expression* curr) {
    if (auto* set = curr->dynCast<GlobalSet>()) {
      if (Properties::isConstantExpression(set->value)) {
        currConstantGlobals[set->name] =
          getLiteralsFromConstExpression(set->value);
      } else {
        currConstantGlobals.erase(set->name);
      }
      return;
    } else if (auto* get = curr->dynCast<GlobalGet>()) {
      // Check if the global is known to be constant all the time.
      if (constantGlobals->count(get->name)) {
        auto* global = getModule()->getGlobal(get->name);
        assert(Properties::isConstantExpression(global->init));
        replaceCurrent(ExpressionManipulator::copy(global->init, *getModule()));
        replaced = true;
        return;
      }
      // Check if the global has a known value in this linear trace.
      auto iter = currConstantGlobals.find(get->name);
      if (iter != currConstantGlobals.end()) {
        Builder builder(*getModule());
        replaceCurrent(builder.makeConstantExpression(iter->second));
        replaced = true;
      }
      return;
    }
    // Otherwise, invalidate if we need to.
    EffectAnalyzer effects(getPassOptions(), *getModule());
    effects.visit(curr);
    assert(effects.globalsWritten.empty()); // handled above
    if (effects.calls) {
      currConstantGlobals.clear();
    }
  }

  static void doNoteNonLinear(ConstantGlobalApplier* self, Expression** currp) {
    self->currConstantGlobals.clear();
  }

  void visitFunction(Function* curr) {
    if (replaced && optimize) {
      PassRunner runner(getModule(), getPassRunner()->options);
      runner.setIsNested(true);
      runner.addDefaultFunctionOptimizationPasses();
      runner.runOnFunction(curr);
    }
  }

private:
  NameSet* constantGlobals;
  bool optimize;
  bool replaced = false;

  // The globals currently constant in the linear trace.
  std::map<Name, Literals> currConstantGlobals;
};

struct GlobalSetRemover : public WalkerPass<PostWalker<GlobalSetRemover>> {
  GlobalSetRemover(const NameSet* toRemove, bool optimize)
    : toRemove(toRemove), optimize(optimize) {}

  bool isFunctionParallel() override { return true; }

  GlobalSetRemover* create() override {
    return new GlobalSetRemover(toRemove, optimize);
  }

  void visitGlobalSet(GlobalSet* curr) {
    if (toRemove->count(curr->name) != 0) {
      replaceCurrent(Builder(*getModule()).makeDrop(curr->value));
      removed = true;
    }
  }

  void visitFunction(Function* curr) {
    if (removed && optimize) {
      PassRunner runner(getModule(), getPassRunner()->options);
      runner.setIsNested(true);
      runner.addDefaultFunctionOptimizationPasses();
      runner.runOnFunction(curr);
    }
  }

private:
  const NameSet* toRemove;
  bool optimize;
  bool removed = false;
};

} // anonymous namespace

struct SimplifyGlobals : public Pass {
  PassRunner* runner;
  Module* module;

  GlobalInfoMap map;
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
    GlobalUseScanner(&map).run(runner, module);
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

Pass* createSimplifyGlobalsPass() { return new SimplifyGlobals(false); }

Pass* createSimplifyGlobalsOptimizingPass() {
  return new SimplifyGlobals(true);
}

} // namespace wasm
