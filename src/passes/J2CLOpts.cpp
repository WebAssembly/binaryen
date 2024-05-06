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

using AssignmentCountMap = std::unordered_map<Name, Index>;
using TrivialFunctionMap = std::unordered_map<Name, Expression*>;

bool isOnceFunction(Function* f) { return f->name.hasSubstring("_<once>_"); }

// Returns the function body if it is a trivial function, null otherwise.
Expression* getTrivialFunctionBody(Module* m, Function* f) {
  auto* body = f->body;
  if (body->is<Return>()) {
    body = body->dynCast<Return>()->value;
  }
  if (body == nullptr) {
    // Empty body is trivial, use nop as the replacement for inlinling.
    Builder builder(*m);
    body = builder.makeNop();
  }

  // Only consider trivial the following instructions which can be safely
  // inlined and whose size is it most 2.
  if (body->is<Nop>() || body->is<GlobalGet>() || body->is<Const>() ||
      (body->is<Call>() && body->dynCast<Call>()->operands.size() == 0) ||
      (body->is<GlobalSet>() &&
       body->dynCast<GlobalSet>()->value->is<Const>())) {
    return body;
  }
  return nullptr;
}

// Adds the function to the map if it is trivial.
void maybeCollectTrivialFunction(Module* m,
                                 Function* f,
                                 TrivialFunctionMap& trivialFunctionMap) {
  auto* body = getTrivialFunctionBody(m, f);
  if (body == nullptr) {
    return;
  }

  trivialFunctionMap[f->name] = body;
}

// Cleans up a once function that has been modified in the hopes it
// becomes trivial.
void cleanupFunction(Module* m, Function* f) {
  PassRunner runner(m);
  runner.add("precompute-propagate");
  runner.add("remove-unused-brs");
  runner.add("vacuum");
  runner.setIsNested(true);
  runner.runOnFunction(f);
}

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
    if (name.startsWith("$class-initialized@")) {
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
  ConstantHoister(AssignmentCountMap& assignmentCounts,
                  TrivialFunctionMap& trivialFunctionMap)
    : assignmentCounts(assignmentCounts),
      trivialFunctionMap(trivialFunctionMap) {}

  int optimized = 0;

  void visitFunction(Function* curr) {
    if (!isOnceFunction(curr)) {
      return;
    }
    Name enclosingClassName = getEnclosingClass(curr->name);
    int optimizedBefore = optimized;
    if (auto* block = curr->body->dynCast<Block>()) {
      for (auto*& expr : block->list) {
        maybeHoistConstant(expr, enclosingClassName);
      }
    } else {
      maybeHoistConstant(curr->body, enclosingClassName);
    }

    if (optimized != optimizedBefore) {
      cleanupFunction(getModule(), curr);
      maybeCollectTrivialFunction(getModule(), curr, trivialFunctionMap);
    }
  }

private:
  void maybeHoistConstant(Expression* expr, Name enclosingClassName) {
    auto set = expr->dynCast<GlobalSet>();
    if (!set) {
      return;
    }

    if (assignmentCounts[set->name] != 1) {
      // The global assigned in multiple places, so it is not safe to
      // hoist them as global constants.
      return;
    }

    if (getEnclosingClass(set->name) != enclosingClassName) {
      // Only hoist fields initialized by its own class.
      // If it is only initialized once but by another class (although it is
      // very uncommon / edge scenario) then we cannot be sure if the clinit was
      // triggered before the field access so it is better to leave it alone.
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

  Name getEnclosingClass(Name name) {
    return Name(name.str.substr(name.str.find_last_of('@')));
  }

  AssignmentCountMap& assignmentCounts;
  TrivialFunctionMap& trivialFunctionMap;
};

class TrivialOnceFunctionCollector
  : public WalkerPass<PostWalker<TrivialOnceFunctionCollector>> {
public:
  TrivialOnceFunctionCollector(TrivialFunctionMap& trivialFunctionMap)
    : trivialFunctionMap(trivialFunctionMap) {}

  void visitFunction(Function* curr) {
    if (!isOnceFunction(curr)) {
      return;
    }
    maybeCollectTrivialFunction(getModule(), curr, trivialFunctionMap);
  }

private:
  TrivialFunctionMap& trivialFunctionMap;
};

// A visitor that inlines trivial once functions.
// TODO: parallelize
class InlineTrivialOnceFunctions
  : public WalkerPass<PostWalker<InlineTrivialOnceFunctions>> {
public:
  InlineTrivialOnceFunctions(TrivialFunctionMap& trivialFunctionMap)
    : trivialFunctionMap(trivialFunctionMap) {}

  void visitCall(Call* curr) {
    if (curr->operands.size() != 0) {
      return;
    }

    auto* expr = trivialFunctionMap[curr->target];
    if (expr == nullptr) {
      return;
    }

    // The call was to a trivial once function which consists of the expression
    // in <expr>; replace the call with it.
    Builder builder(*getModule());
    auto* replacement = ExpressionManipulator::copy(expr, *getModule());
    replaceCurrent(replacement);

    lastModifiedFunction = getFunction();
    inlined++;
  }

  void visitFunction(Function* curr) {
    // Since the traversal is in post-order, we only need to check if the
    // current function is the function that was last inlined into.
    if (lastModifiedFunction != curr || !isOnceFunction(curr)) {
      return;
    }

    cleanupFunction(getModule(), curr);
    maybeCollectTrivialFunction(getModule(), curr, trivialFunctionMap);
  }

  int inlined = 0;

private:
  TrivialFunctionMap& trivialFunctionMap;
  Function* lastModifiedFunction = nullptr;
};

struct J2CLOpts : public Pass {
  void hoistConstants(Module* module) {
    AssignmentCountMap assignmentCounts;
    TrivialFunctionMap trivialFunctionMap;

    GlobalAssignmentCollector collector(assignmentCounts);
    collector.run(getPassRunner(), module);

    TrivialOnceFunctionCollector trivialFunctionCollector(trivialFunctionMap);
    trivialFunctionCollector.run(getPassRunner(), module);

    while (1) {
      ConstantHoister hoister(assignmentCounts, trivialFunctionMap);
      hoister.run(getPassRunner(), module);
      int optimized = hoister.optimized;

      InlineTrivialOnceFunctions inliner(trivialFunctionMap);
      inliner.run(getPassRunner(), module);
      int inlined = inliner.inlined;

#ifdef J2CL_OPT_DEBUG
      std::cout << "Optimized " << optimized << " global fields\n";
#endif
      if (optimized == 0 && inlined == 0) {
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
