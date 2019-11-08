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
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct GlobalInfo {
  bool imported = false;
  bool exported = false;
  std::atomic<bool> written;
};

using GlobalInfoMap = std::map<Name, GlobalInfo>;

struct GlobalUseScanner : public WalkerPass<PostWalker<GlobalUseScanner>> {
  bool isFunctionParallel() override { return true; }

  GlobalUseScanner(GlobalInfoMap* infos) : infos(infos) {}

  GlobalUseScanner* create() override { return new GlobalUseScanner(infos); }

  void visitGlobalSet(GlobalSet* curr) { (*infos)[curr->name].written = true; }

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
      if (auto* c = set->value->dynCast<Const>()) {
        currConstantGlobals[set->name] = c->value;
      } else {
        currConstantGlobals.erase(set->name);
      }
      return;
    } else if (auto* get = curr->dynCast<GlobalGet>()) {
      // Check if the global is known to be constant all the time.
      if (constantGlobals->count(get->name)) {
        auto* global = getModule()->getGlobal(get->name);
        assert(global->init->is<Const>());
        replaceCurrent(ExpressionManipulator::copy(global->init, *getModule()));
        replaced = true;
        return;
      }
      // Check if the global has a known value in this linear trace.
      auto iter = currConstantGlobals.find(get->name);
      if (iter != currConstantGlobals.end()) {
        Builder builder(*getModule());
        replaceCurrent(builder.makeConst(iter->second));
        replaced = true;
      }
      return;
    }
    // Otherwise, invalidate if we need to.
    EffectAnalyzer effects(getPassOptions());
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
  std::map<Name, Literal> currConstantGlobals;
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

    analyze();

    preferEarlierImports();

    propagateConstantsToGlobals();

    propagateConstantsToCode();
  }

  void analyze() {
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
    std::map<Name, Literal> constantGlobals;
    for (auto& global : module->globals) {
      if (!global->imported()) {
        if (auto* c = global->init->dynCast<Const>()) {
          constantGlobals[global->name] = c->value;
        } else if (auto* get = global->init->dynCast<GlobalGet>()) {
          auto iter = constantGlobals.find(get->name);
          if (iter != constantGlobals.end()) {
            Builder builder(*module);
            global->init = builder.makeConst(iter->second);
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
          global->init->is<Const>()) {
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
