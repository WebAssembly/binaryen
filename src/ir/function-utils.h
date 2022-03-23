/*
 * Copyright 2018 WebAssembly Community Group participants
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

#ifndef wasm_ir_function_h
#define wasm_ir_function_h

#include "ir/local-graph.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "support/sorted_vector.h"
#include "wasm.h"

namespace wasm::FunctionUtils {

// Checks if two functions are equal in all functional aspects,
// everything but their name (which can't be the same, in the same
// module!) - same params, vars, body, result, etc.
inline bool equal(Function* left, Function* right) {
  if (left->type != right->type) {
    return false;
  }
  if (left->getNumVars() != right->getNumVars()) {
    return false;
  }
  for (Index i = left->getParams().size(); i < left->getNumLocals(); i++) {
    if (left->getLocalType(i) != right->getLocalType(i)) {
      return false;
    }
  }
  if (!left->imported() && !right->imported()) {
    return ExpressionAnalyzer::equal(left->body, right->body);
  }
  return left->imported() && right->imported();
}

// Find which parameters are actually used in the function, that is, that the
// values arriving in the parameter are read. This ignores values set in the
// function, like this:
//
// function foo(x) {
//   x = 10;
//   bar(x); // read of a param index, but not the param value passed in.
// }
//
// This is an actual use:
//
// function foo(x) {
//   bar(x); // read of a param value
// }
inline std::unordered_set<Index> getUsedParams(Function* func) {
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

// Try to remove a parameter from a set of functions and replace it with a local
// instead. This may not succeed if the parameter type cannot be used in a
// local, or if we hit another limitation, in which case this returns false and
// does nothing. If we succeed then the parameter is removed both from the
// functions and from the calls to it, which are passed in (the caller must
// ensure to pass in all relevant calls and call_refs).
//
// This does not check if removing the parameter would change the semantics
// (say, if the parameter's value is used), which the caller is assumed to do.
//
// This assumes that the set of functions all have the same signature. The main
// use cases are either to send a single function, or to send a set of functions
// that all have the same heap type (and so if they all do not use some
// parameter, it can be removed from them all).
inline bool removeParameter(const std::vector<Function*> funcs,
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

  // Great, it's not used. Check if none of the calls has a param with
  // side effects that we cannot remove (as if we can remove them, we
  // will simply do that when we remove the parameter). Note: flattening
  // the IR beforehand can help here.
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
  for (Index j = 0; j < funcs.size(); j++) {
    LocalUpdater(funcs[j], index, newIndexes[j]);
  }

  // Remove the arguments from the calls.
  for (auto* call : calls) {
    call->operands.erase(call->operands.begin() + index);
  }
  for (auto* call : callRefs) {
    call->operands.erase(call->operands.begin() + index);
  }

  for (auto* func : funcs) {
    TypeUpdating::handleNonDefaultableLocals(func, *module);
  }
  return true;
}

// The same as removeParameter, but gets a sorted list of indexes. It tries to
// remove them all, and returns true if we managed to remove at least one.
inline bool removeParameters(const std::vector<Function*> funcs,
                             SortedVector indexes,
                             const std::vector<Call*>& calls,
                             const std::vector<CallRef*>& callRefs,
                             Module* module,
                             PassRunner* runner) {
  if (indexes.empty()) {
    return false;
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
  bool removed = false;
  while (1) {
    if (indexes.has(i)) {
      if (removeParameter(funcs, i, calls, callRefs, module, runner)) {
        // Success!
        removed = true;
      }
    }
    if (i == 0) {
      break;
    }
    i--;
  }
  return removed;
}

} // namespace wasm::FunctionUtils

#endif // wasm_ir_function_h
