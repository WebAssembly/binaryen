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
//  * Remove writes to globals that are always assigned the same value.
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

  // Whether the global is written a value different from its initial value.
  std::atomic<bool> nonInitWritten{false};

  // How many times the global is "read, but only to write", that is, is used in
  // something like this pattern:
  //
  //   if (global == X) { global = Y }
  //
  // The if's condition only uses |global| in order to decide to write to that
  // same global, so it is "read, but only to write." If all we have are such
  // reads only to write then the global is really not necessary, even though
  // there are both reads and writes of it, and regardless of what the written
  // values are etc.
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<GlobalUseScanner>(infos);
  }

  void visitGlobalSet(GlobalSet* curr) {
    (*infos)[curr->name].written++;

    // Check if there is a write of a value that may differ from the initial
    // one. If there is anything but identical constants in both the initial
    // value and the written value then we must assume that.
    auto* global = getModule()->getGlobal(curr->name);
    if (global->imported() || !Properties::isConstantExpression(curr->value) ||
        !Properties::isConstantExpression(global->init) ||
        Properties::getLiterals(curr->value) !=
          Properties::getLiterals(global->init)) {
      (*infos)[curr->name].nonInitWritten = true;
    }
  }

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

    auto global = readsGlobalOnlyToWriteIt(curr->condition, curr->ifTrue);
    if (global.is()) {
      // This is exactly the pattern we sought!
      (*infos)[global].readOnlyToWrite++;
    }
  }

  // Given a condition and some code that is executed based on the condition,
  // check if the condition reads from some global in order to make the decision
  // whether to run that code, and that code only writes to that global, which
  // means the global is "read, but only to be written."
  //
  // The condition may also do other things than read from that global - it may
  // compare it to a value, or negate it, or anything else, so long as the value
  // of the global is only used to decide to run the code, like this:
  //
  //  if (global % 17 < 4) { global = 1 }
  //
  // What we want to disallow is using the global to actually do something that
  // is noticeeable *aside* from writing the global, like this:
  //
  //  if (global ? foo() : bar()) { .. }
  //
  // Here ? : is another nested if, and we end up running different code based
  // on global, which is noticeable: the global is *not* only read in order to
  // write that global, but also for other reasons.
  //
  // Returns the global name if things like up, or a null name otherwise.
  Name readsGlobalOnlyToWriteIt(Expression* condition, Expression* code) {
    // See if writing a global is the only effect the code has. (Note that we
    // don't need to care about the case where the code has no effects at
    // all - other passes would handle that trivial situation.)
    EffectAnalyzer codeEffects(getPassOptions(), *getModule(), code);
    if (codeEffects.globalsWritten.size() != 1) {
      return Name();
    }
    auto writtenGlobal = *codeEffects.globalsWritten.begin();
    codeEffects.globalsWritten.clear();
    if (codeEffects.hasAnything()) {
      return Name();
    }

    // See if we read that global in the condition expression.
    EffectAnalyzer conditionEffects(getPassOptions(), *getModule(), condition);
    if (!conditionEffects.mutableGlobalsRead.count(writtenGlobal)) {
      return Name();
    }

    // If the condition has no other (non-removable) effects other than reading
    // that global then we have found what we looked for.
    if (!conditionEffects.hasUnremovableSideEffects()) {
      return writtenGlobal;
    }

    // There are unremovable side effects of some form. However, they may not
    // be related to the reading of the global, that is, the global's value may
    // not flow to anything that uses it in a dangerous way. It *would* be
    // dangerous for the global's value to flow into a nested if condition, as
    // mentioned in the comment earlier, but if it flows into an if arm for
    // example then that is safe, so long as the final place it flows out to is
    // the condition.
    //
    // To check this, find the get of the global in the condition, and look up
    // through its parents to see how the global's value is used.
    struct FlowScanner
      : public ExpressionStackWalker<FlowScanner,
                                     UnifiedExpressionVisitor<FlowScanner>> {
      GlobalUseScanner& globalUseScanner;
      Name writtenGlobal;
      PassOptions& passOptions;
      Module& wasm;

      FlowScanner(GlobalUseScanner& globalUseScanner,
                  Name writtenGlobal,
                  PassOptions& passOptions,
                  Module& wasm)
        : globalUseScanner(globalUseScanner), writtenGlobal(writtenGlobal),
          passOptions(passOptions), wasm(wasm) {}

      bool ok = true;

      void visitExpression(Expression* curr) {
        if (auto* get = curr->dynCast<GlobalGet>()) {
          if (get->name == writtenGlobal) {
            // We found the get of the global. Check where its value flows to,
            // and how it is used there.
            assert(expressionStack.back() == get);
            for (int i = int(expressionStack.size()) - 2; i >= 0; i--) {
              // Consider one pair of parent->child, and check if the parent
              // causes any problems when the child's value reaches it.
              auto* parent = expressionStack[i];
              auto* child = expressionStack[i + 1];
              EffectAnalyzer parentEffects(passOptions, wasm);
              parentEffects.visit(parent);
              if (parentEffects.hasUnremovableSideEffects()) {
                // The parent has some side effect, and the child's value may
                // be used to determine its manner, so this is dangerous.
                ok = false;
                break;
              }

              if (auto* iff = parent->dynCast<If>()) {
                if (iff->condition == child) {
                  // The child is used to decide what code to run, which is
                  // dangerous: check what effects it causes. If it is a nested
                  // appearance of the pattern, that is one case that we know is
                  // actually safe.
                  if (!iff->ifFalse &&
                      globalUseScanner.readsGlobalOnlyToWriteIt(
                        iff->condition, iff->ifTrue) == writtenGlobal) {
                    // This is safe, and we can stop here: the value does not
                    // flow any further.
                    break;
                  }

                  // Otherwise, we found a problem, and can stop.
                  ok = false;
                  break;
                }
              }
            }
          }
        }
      }
    };

    FlowScanner scanner(*this, writtenGlobal, getPassOptions(), *getModule());
    scanner.walk(condition);
    return scanner.ok ? writtenGlobal : Name();
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

    auto global = readsGlobalOnlyToWriteIt(iff->condition, list[1]);
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<GlobalUseModifier>(copiedParentMap);
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<ConstantGlobalApplier>(constantGlobals, optimize);
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

    // Otherwise, invalidate if we need to. Note that we handled a GlobalSet
    // earlier, but also need to handle calls. A general call forces us to
    // forget everything, but in some cases we can do better, if we have a call
    // and have computed function effects for it.
    ShallowEffectAnalyzer effects(getPassOptions(), *getModule(), curr);
    if (effects.calls) {
      // Forget everything.
      currConstantGlobals.clear();
    } else {
      // Forget just the globals written, if any.
      for (auto writtenGlobal : effects.globalsWritten) {
        currConstantGlobals.erase(writtenGlobal);
      }
    }
  }

  static void doNoteNonLinear(ConstantGlobalApplier* self, Expression** currp) {
    self->currConstantGlobals.clear();
  }

  void visitFunction(Function* curr) {
    if (replaced && optimize) {
      PassRunner runner(getPassRunner());
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<GlobalSetRemover>(toRemove, optimize);
  }

  void visitGlobalSet(GlobalSet* curr) {
    if (toRemove->count(curr->name) != 0) {
      replaceCurrent(Builder(*getModule()).makeDrop(curr->value));
      removed = true;
    }
  }

  void visitFunction(Function* curr) {
    if (removed && optimize) {
      PassRunner runner(getPassRunner());
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
  Module* module;

  GlobalInfoMap map;
  bool optimize;

  SimplifyGlobals(bool optimize = false) : optimize(optimize) {}

  void run(Module* module_) override {
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
    GlobalUseScanner(&map).run(getPassRunner(), module);
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

    // Globals that are not exports and not read from do not need their sets.
    // Likewise, globals that only write their initial value later also do not
    // need those writes. And, globals that are only read from in order to write
    // to themselves as well. First, find such globals.
    NameSet globalsNotNeedingSets;
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

      if (!info.read || !info.nonInitWritten || onlyReadOnlyToWrite) {
        globalsNotNeedingSets.insert(global->name);

        // We can now mark this global as immutable, and un-written, since we
        // are about to remove all the sets on it.
        global->mutable_ = false;
        info.written = 0;

        // Nested only-read-to-write expressions require another full iteration
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
        //
        // TODO: In principle other situations exist as well where more
        //       iterations help, like if we remove a set that turns something
        //       into a read-only-to-write.
        if (onlyReadOnlyToWrite) {
          more = true;
        }
      }
    }

    // Remove all the sets on the unnecessary globals. Later optimizations can
    // then see that since the global has no writes, it is a constant, which
    // will lead to removal of gets, and after removing them, the global itself
    // will be removed as well.
    GlobalSetRemover(&globalsNotNeedingSets, optimize)
      .run(getPassRunner(), module);

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
      GlobalUseModifier(&copiedParentMap).run(getPassRunner(), module);
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
    ConstantGlobalApplier(&constantGlobals, optimize)
      .run(getPassRunner(), module);
  }
};

Pass* createSimplifyGlobalsPass() { return new SimplifyGlobals(false); }

Pass* createSimplifyGlobalsOptimizingPass() {
  return new SimplifyGlobals(true);
}

} // namespace wasm
