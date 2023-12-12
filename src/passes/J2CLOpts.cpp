/*
 * Copyright 2023 WebAssembly Community Group participants
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
// Optimize J2CL specifics construct to simplify them and enable further
// optimizations by other passes.
//

#include "ir/global-utils.h"
#include "ir/utils.h"
#include "opt-utils.h"
#include "pass.h"
#include "passes.h"
#include "wasm.h"

namespace wasm {

namespace {

bool isOnceFunction(Function* f) { return f->name.hasSubstring("_@once@_"); }

using AssignmentCountMap = std::unordered_map<Name, Index>;

// A visitor to count the number of GlobalSets of each global so we can later
// identify the number of assignments of the global.
// TODO: parallelize
class GlobalAssignmentCollector
  : public WalkerPass<PostWalker<GlobalAssignmentCollector>> {
public:
  GlobalAssignmentCollector(AssignmentCountMap& assignmentCounts)
    : assignmentCounts(assignmentCounts) {}

  void visitGlobal(Global* curr) {
    if (isInitialValue(curr->init)) {
      return;
    }
    // J2CL normally doesn't set non-default initial value however just in
    // case if other passes in bineryen does something we should back off
    // by recording this as an assignment.
    recordGlobalAssignment(curr->name);
  }
  void visitGlobalSet(GlobalSet* curr) { recordGlobalAssignment(curr->name); }

private:
  bool isInitialValue(Expression* expr) {
    if (auto* constExpr = expr->dynCast<Const>()) {
      return constExpr->value.isZero();
    } else {
      return expr->is<RefNull>();
    }
  }

  void recordGlobalAssignment(Name name) {
    // Avoid optimizing class initialization condition variable itself. If we
    // were optimizing it then it would become "true" and would defeat its
    // functionality and the clinit would never trigger during runtime.
    if (name.startsWith("f_$initialized__")) {
      return;
    }
    assignmentCounts[name]++;
  }

  AssignmentCountMap& assignmentCounts;
};

// A visitor that moves initialization of constant-like globals from "once"
// functions to global init.
// TODO: parallelize
class ConstantHoister : public WalkerPass<PostWalker<ConstantHoister>> {
public:
  ConstantHoister(AssignmentCountMap& assignmentCounts)
    : assignmentCounts(assignmentCounts) {}

  int optimized = 0;

  void visitFunction(Function* curr) {
    if (!isOnceFunction(curr)) {
      return;
    }
    int optimizedBefore = optimized;
    if (auto* block = curr->body->dynCast<Block>()) {
      for (auto*& expr : block->list) {
        maybeHoistConstant(expr);
      }
    } else {
      maybeHoistConstant(curr->body);
    }

    if (optimized != optimizedBefore) {
      // We introduced "nop" instruction. Run the vacuum to cleanup.
      // TODO: maybe we should not introduce "nop" in the first place and try
      // removing instead.
      PassRunner runner(getModule());
      runner.add("vacuum");
      runner.setIsNested(true);
      runner.runOnFunction(curr);
    }
  }

private:
  void maybeHoistConstant(Expression* expr) {
    auto set = expr->dynCast<GlobalSet>();
    if (!set) {
      return;
    }

    if (assignmentCounts[set->name] != 1) {
      // The global assigned in multiple places, so it is not safe to
      // hoist them as global constants.
      return;
    }

    if (!GlobalUtils::canInitializeGlobal(*getModule(), set->value)) {
      // It is not a valid constant expression so cannot be hoisted to
      // global init.
      return;
    }

    // Move it to global init and mark it as immutable.
    auto global = getModule()->getGlobal(set->name);
    global->init = set->value;
    global->mutable_ = false;
    ExpressionManipulator::nop(expr);

    optimized++;
  }

  AssignmentCountMap& assignmentCounts;
};

// A visitor that marks trivial once functions for removal.
// TODO: parallelize
class EnableInline : public WalkerPass<PostWalker<EnableInline>> {
public:
  void visitFunction(Function* curr) {
    if (!isOnceFunction(curr)) {
      return;
    }
    auto* body = curr->body;
    if (Measurer::measure(body) <= 2) {
      // Once function has become trivial: enable inlining so it could be
      // removed.
      //
      // Note that the size of a trivial function is set to 2 to cover things
      // like
      //  - nop (e.g. a clinit that is emptied)
      //  - call (e.g. a clinit just calling another one; note that clinits take
      //  no parameters)
      //  - return global.get abc (e.g. a string literal moved to global)
      //  - global.set abc 1 (e.g. partially inlined clinit that is empty)
      // while rejecting more complex scenario like condition checks. Optimizing
      // complex functions could change the shape of "once" functions and make
      // the ConstantHoister in this pass and OnceReducer ineffective.
      curr->noFullInline = false;
      curr->noPartialInline = false;
    }
  }
};

struct J2CLOpts : public Pass {
  void hoistConstants(Module* module) {
    AssignmentCountMap assignmentCounts;

    GlobalAssignmentCollector collector(assignmentCounts);
    collector.run(getPassRunner(), module);

    // TODO surprisingly looping help some but not a lot. Maybe we are missing
    // something that helps globals to be considered immutable.
    while (1) {
      ConstantHoister hoister(assignmentCounts);
      hoister.run(getPassRunner(), module);
      int optimized = hoister.optimized;
#ifdef J2CL_OPT_DEBUG
      std::cout << "Optimized " << optimized << " global fields\n";
#endif
      if (optimized == 0) {
        break;
      }
    }
  }

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }
    // Move constant like properties set by the once functions to global
    // initialization.
    hoistConstants(module);

    EnableInline enableInline;
    enableInline.run(getPassRunner(), module);

    // We might have introduced new globals depending on other globals. Reorder
    // order them so they follow initialization order.
    // TODO: do this only if have introduced a new global.
    PassRunner runner(module);
    runner.add("reorder-globals-always");
    runner.setIsNested(true);
    runner.run();
  }
};

} // anonymous namespace

Pass* createJ2CLOptsPass() { return new J2CLOpts(); }

} // namespace wasm
