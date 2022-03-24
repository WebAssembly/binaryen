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

#include <variant>

#include "ir/function-utils.h"
#include "ir/local-graph.h"
#include "ir/type-updating.h"
#include "support/sorted_vector.h"
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

bool removeParameter(const std::vector<Function*> funcs,
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
  bool callParamsAreValid =
    std::none_of(calls.begin(), calls.end(), [&](Call* call) {
      auto* operand = call->operands[index];
      return EffectAnalyzer(runner->options, *module, operand)
        .hasUnremovableSideEffects();
    });
  if (!callParamsAreValid) {
    return false;
  }

  // The type must be valid for us to handle as a local (since we
  // replace the parameter with a local).
  // TODO: if there are no references at all, we can avoid creating a
  //       local
  bool typeIsValid = TypeUpdating::canHandleAsLocal(first->getLocalType(index));
  if (!typeIsValid) {
    return false;
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

  return true;
}

SortedVector removeParameters(const std::vector<Function*>& funcs,
                              SortedVector indexes,
                              const std::vector<Call*>& calls,
                              const std::vector<CallRef*>& callRefs,
                              Module* module,
                              PassRunner* runner) {
  if (indexes.empty()) {
    return {};
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
      if (removeParameter(funcs, i, calls, callRefs, module, runner)) {
        // Success!
        removed.insert(i);
      }
    }
    if (i == 0) {
      break;
    }
    i--;
  }
  return removed;
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

  auto numParams = first->getNumParams();
  for (Index i = 0; i < numParams; i++) {
    // No value yet.
    struct None : public std::monostate {};

    // Many possible values, and so this represents unknown data: we cannot infer
    // anything there.
    struct Many : public std::monostate {};

    using Variant = std::variant<None, Literal, Many>;

    Variant value = None;

    // Processes one operand.
    auto processOperand = [&](Expression* operand) {
      if (auto* c = operand->dynCast<Const>()) {
        if (value == None) {
          // This is the first value seen.
          value = c->value;
        } else if (value != c->value) {
          // Not identical, give up.
          value = Many;
        }
        // TODO: refnull etc.
      }
      // Not a constant, give up
      value = Literal(Type::none);
    };
    for (auto* call : calls) {
      if (!processOperand(call->operands[i]);
    }
    for (auto* callRefs : calls) {
      processOperand(call->operands[i]);
    }
    if (value.type != Type::none) {
      // Success! We can just apply the constant in the function, which
      // makes the parameter value unused, which lets us remove it later.
      Builder builder(*module);
      func->body = builder.makeSequence(
        builder.makeLocalSet(i, builder.makeConst(value)), func->body);
      // Mark it as unused, which we know it now is (no point to
      // re-scan just for that).
      infoMap[name].unusedParams.insert(i);
    }
  }

} // namespace wasm::ParamUtils
