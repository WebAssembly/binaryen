/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include "passes/param-utils.h"
#include "ir/function-utils.h"
#include "ir/local-graph.h"
#include "ir/localize.h"
#include "ir/possible-constant.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "support/sorted_vector.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm::ParamUtils {

std::unordered_set<Index> getUsedParams(Function* func) {
  LocalGraph localGraph(func);

  std::unordered_set<Index> usedParams;

  for (auto& [get, sets] : localGraph.getSetses) {
    if (!func->isParam(get->index)) {
      continue;
    }

    for (auto* set : sets) {
      // A nullptr value indicates there is no LocalSet* that sets the value,
      // so it must be the parameter value.
      if (!set) {
        usedParams.insert(get->index);
      }
    }
  }

  return usedParams;
}

RemovalOutcome removeParameter(const std::vector<Function*>& funcs,
                               Index index,
                               const std::vector<Call*>& calls,
                               const std::vector<CallRef*>& callRefs,
                               Module* module,
                               PassRunner* runner) {
  assert(funcs.size() > 0);
  auto* first = funcs[0];
#ifndef NDEBUG
  for (auto* func : funcs) {
    assert(func->type == first->type);
  }
#endif

  // Check if none of the calls has a param with side effects that we cannot
  // remove (as if we can remove them, we will simply do that when we remove the
  // parameter). Note: flattening the IR beforehand can help here.
  //
  // It would also be bad if we remove a parameter that causes the type of the
  // call to change, like this:
  //
  //  (call $foo
  //    (unreachable))
  //
  // After removing the parameter the type should change from unreachable to
  // something concrete. We could handle this by updating the type and then
  // propagating that out, or by appending an unreachable after the call, but
  // for simplicity just ignore such cases; if we are called again later then
  // if DCE ran meanwhile then we could optimize.
  auto checkEffects = [&](auto* call) {
    auto& operands = call->operands;

    bool hasUnremovable =
      EffectAnalyzer(runner->options, *module, operands[index])
        .hasUnremovableSideEffects();

    return hasUnremovable ? Failure : Success;
  };

  for (auto* call : calls) {
    auto result = checkEffects(call);
    if (result != Success) {
      return result;
    }
  }

  for (auto* call : callRefs) {
    auto result = checkEffects(call);
    if (result != Success) {
      return result;
    }
  }

  // The type must be valid for us to handle as a local (since we
  // replace the parameter with a local).
  // TODO: if there are no references at all, we can avoid creating a
  //       local
  bool typeIsValid = TypeUpdating::canHandleAsLocal(first->getLocalType(index));
  if (!typeIsValid) {
    return Failure;
  }

  // We can do it!

  // Remove the parameter from the function. We must add a new local
  // for uses of the parameter, but cannot make it use the same index
  // (in general).
  auto paramsType = first->getParams();
  std::vector<Type> params(paramsType.begin(), paramsType.end());
  auto type = params[index];
  params.erase(params.begin() + index);
  // TODO: parallelize some of these loops?
  for (auto* func : funcs) {
    func->setParams(Type(params));

    // It's cumbersome to adjust local names - TODO don't clear them?
    Builder::clearLocalNames(func);
  }
  std::vector<Index> newIndexes;
  for (auto* func : funcs) {
    newIndexes.push_back(Builder::addVar(func, type));
  }
  // Update local operations.
  struct LocalUpdater : public PostWalker<LocalUpdater> {
    Index removedIndex;
    Index newIndex;
    LocalUpdater(Function* func, Index removedIndex, Index newIndex)
      : removedIndex(removedIndex), newIndex(newIndex) {
      walk(func->body);
    }
    void visitLocalGet(LocalGet* curr) { updateIndex(curr->index); }
    void visitLocalSet(LocalSet* curr) { updateIndex(curr->index); }
    void updateIndex(Index& index) {
      if (index == removedIndex) {
        index = newIndex;
      } else if (index > removedIndex) {
        index--;
      }
    }
  };
  for (Index i = 0; i < funcs.size(); i++) {
    auto* func = funcs[i];
    if (!func->imported()) {
      LocalUpdater(funcs[i], index, newIndexes[i]);
      TypeUpdating::handleNonDefaultableLocals(func, *module);
    }
  }

  // Remove the arguments from the calls.
  for (auto* call : calls) {
    call->operands.erase(call->operands.begin() + index);
  }
  for (auto* call : callRefs) {
    call->operands.erase(call->operands.begin() + index);
  }

  return Success;
}

std::pair<SortedVector, RemovalOutcome>
removeParameters(const std::vector<Function*>& funcs,
                 SortedVector indexes,
                 const std::vector<Call*>& calls,
                 const std::vector<CallRef*>& callRefs,
                 Module* module,
                 PassRunner* runner) {
  if (indexes.empty()) {
    return {{}, Success};
  }

  assert(funcs.size() > 0);
  auto* first = funcs[0];
#ifndef NDEBUG
  for (auto* func : funcs) {
    assert(func->type == first->type);
  }
#endif

  // Iterate downwards, as we may remove more than one, and going forwards would
  // alter the indexes after us.
  Index i = first->getNumParams() - 1;
  SortedVector removed;
  while (1) {
    if (indexes.has(i)) {
      auto outcome = removeParameter(funcs, i, calls, callRefs, module, runner);
      if (outcome == Success) {
        removed.insert(i);
      }
    }
    if (i == 0) {
      break;
    }
    i--;
  }
  RemovalOutcome finalOutcome = Success;
  if (removed.size() < indexes.size()) {
    finalOutcome = Failure;
  }
  return {removed, finalOutcome};
}

SortedVector applyConstantValues(const std::vector<Function*>& funcs,
                                 const std::vector<Call*>& calls,
                                 const std::vector<CallRef*>& callRefs,
                                 Module* module) {
  assert(funcs.size() > 0);
  auto* first = funcs[0];
#ifndef NDEBUG
  for (auto* func : funcs) {
    assert(func->type == first->type);
  }
#endif

  SortedVector optimized;
  auto numParams = first->getNumParams();
  for (Index i = 0; i < numParams; i++) {
    PossibleConstantValues value;
    for (auto* call : calls) {
      value.note(call->operands[i], *module);
      if (!value.isConstant()) {
        break;
      }
    }
    for (auto* call : callRefs) {
      value.note(call->operands[i], *module);
      if (!value.isConstant()) {
        break;
      }
    }
    if (!value.isConstant()) {
      continue;
    }

    // Optimize: write the constant value in the function bodies, making them
    // ignore the parameter's value.
    Builder builder(*module);
    for (auto* func : funcs) {
      func->body = builder.makeSequence(
        builder.makeLocalSet(i, value.makeExpression(*module)), func->body);
    }
    optimized.insert(i);
  }

  return optimized;
}

void localizeCallsTo(const std::unordered_set<Name>& callTargets,
                     Module& wasm,
                     PassRunner* runner) {
  struct LocalizerPass : public WalkerPass<PostWalker<LocalizerPass>> {
    bool isFunctionParallel() override { return true; }

    std::unique_ptr<Pass> create() override {
      return std::make_unique<LocalizerPass>(callTargets);
    }

    const std::unordered_set<Name>& callTargets;

    LocalizerPass(const std::unordered_set<Name>& callTargets)
      : callTargets(callTargets) {}

    void visitCall(Call* curr) {
      if (!callTargets.count(curr->target)) {
        return;
      }

      ChildLocalizer localizer(
        curr, getFunction(), *getModule(), getPassOptions());
      auto* replacement = localizer.getReplacement();
      if (replacement != curr) {
        replaceCurrent(replacement);
      }
    }
  };

  LocalizerPass(callTargets).run(runner, &wasm);
}

void localizeCallsTo(const std::unordered_set<HeapType>& callTargets,
                     Module& wasm,
                     PassRunner* runner) {
  struct LocalizerPass : public WalkerPass<PostWalker<LocalizerPass>> {
    bool isFunctionParallel() override { return true; }

    std::unique_ptr<Pass> create() override {
      return std::make_unique<LocalizerPass>(callTargets);
    }

    const std::unordered_set<HeapType>& callTargets;

    LocalizerPass(const std::unordered_set<HeapType>& callTargets)
      : callTargets(callTargets) {}

    void visitCall(Call* curr) {
      handleCall(curr, getModule()->getFunction(curr->target)->getResults());
    }

    void visitCallRef(CallRef* curr) {
      handleCall(curr, curr->target->type);
    }

    void handleCall(Expression* call, Type type) {
      if (!type.isRef() || !callTargets.count(type.getHeapType())) {
        return;
      }

      ChildLocalizer localizer(
        call, getFunction(), *getModule(), getPassOptions());
      auto* replacement = localizer.getReplacement();
      if (replacement != call) {
        replaceCurrent(replacement);
      }
    }
  };

  LocalizerPass(callTargets).run(runner, &wasm);
}

} // namespace wasm::ParamUtils
