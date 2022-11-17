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

//
// When we see a call foo(arg1, arg2) and at least one of the arguments has a
// more refined type than is declared in the function being called, create a
// copy of the function with the refined type. That copy can then potentially be
// optimized in useful ways later.
//
// Inlining also monomorphizes in effect. What this pass does is handle the
// cases where inlining cannot be done.
//
// To see when monomorphizing makes sense, this optimizes the target function
// both with and without the more refined types. If the refined types help then
// the version with might remove a cast, for example. Note that while doing so
// we keep the optimization results of the version without - there is no reason
// to forget them since we've gone to the trouble anyhow. So this pass may have
// the side effect of performing minor optimizations on functions. There is also
// a variant of the pass that always monomorphizes, even when it does not seem
// helpful, which is useful for testing, and possibly in cases where we need
// more than just local optimizations to see the benefit - for example, perhaps
// GUFA ends up more powerful later on.
//
// TODO: When we optimize we could run multiple cycles: A calls B calls C might
//       end up with the refined+optimized B now having refined types in its
//       call to C, which it did not have before. This is in fact the expected
//       pattern of incremental monomorphization. Doing it in the pass could be
//       more efficient as later cycles can focus only on what was just
//       optimized and changed. Also, operating on functions just modified would
//       help the case of A calls B and we end up optimizing A after we consider
//       A->B, and the optimized version sends more refined types to B, which
//       could unlock more potential.
// TODO: We could sort the functions so that we start from root functions and
//       end on leaves. That would make it more likely for a single iteration to
//       do more work, as if A->B->C then we'd do A->B and optimize B and only
//       then look at B->C.
// TODO: Also run the result-refining part of SignatureRefining, as if we
//       refine the result then callers of the function may benefit, even if
//       there is no benefit in the function itself.
// TODO: If this is too slow, we could "group" things, for example we could
//       compute the LUB of a bunch of calls to a target and then investigate
//       that one case and use it in all those callers.
// TODO: Not just direct calls? But updating vtables is complex.
// TODO: Not just types? We could monomorphize using Literal values. E.g. for
//       function references, if we monomorphized we'd end up specializing qsort
//       for the particular functions it is given.
//

#include "ir/cost.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Monomorphize : public Pass {
  // If set, we run some opts to see if monomorphization helps, and skip it if
  // not.
  bool onlyWhenHelpful;

  Monomorphize(bool onlyWhenHelpful) : onlyWhenHelpful(onlyWhenHelpful) {}

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    // TODO: parallelize, see comments below

    // Note the list of all functions. We'll be adding more, and do not want to
    // operate on those.
    std::vector<Name> funcNames;
    ModuleUtils::iterDefinedFunctions(
      *module, [&](Function* func) { funcNames.push_back(func->name); });

    // Find the calls in each function and optimize where we can, changing them
    // to call more refined targets.
    for (auto name : funcNames) {
      auto* func = module->getFunction(name);
      for (auto* call : FindAll<Call>(func->body).list) {
        if (call->type == Type::unreachable) {
          // Ignore unreachable code.
          // TODO: return_call?
          continue;
        }

        if (call->target == name) {
          // Avoid recursion, which adds some complexity (as we'd be modifying
          // ourselves if we apply optimizations).
          continue;
        }

        call->target = getRefinedTarget(call, module);
      }
    }
  }

  // Given a call, make a copy of the function it is calling that has more
  // refined arguments that fit the arguments being passed perfectly.
  Name getRefinedTarget(Call* call, Module* module) {
    auto target = call->target;
    auto* func = module->getFunction(target);
    if (func->imported()) {
      // Nothing to do since this calls outside of the module.
      return target;
    }
    auto params = func->getParams();
    bool hasRefinedParam = false;
    for (Index i = 0; i < call->operands.size(); i++) {
      if (call->operands[i]->type != params[i]) {
        hasRefinedParam = true;
        break;
      }
    }
    if (!hasRefinedParam) {
      // Nothing to do since all params are fully refined already.
      return target;
    }

    std::vector<Type> refinedTypes;
    for (auto* operand : call->operands) {
      refinedTypes.push_back(operand->type);
    }
    auto refinedParams = Type(refinedTypes);
    auto iter = funcParamMap.find({target, refinedParams});
    if (iter != funcParamMap.end()) {
      return iter->second;
    }

    // This is the first time we see this situation. Let's see if it is worth
    // monomorphizing.

    // Create a new function with refined parameters as a copy of the original.
    // (Note we must clear stack IR on the original: atm we do not have the
    // ability to copy stack IR, so we'd hit an internal error. But as we will
    // be optimizing the function anyhow, we'd be throwing away stack IR later
    // so this isn't a problem.)
    func->stackIR.reset();
    auto refinedTarget = Names::getValidFunctionName(*module, target);
    auto* refinedFunc = ModuleUtils::copyFunction(func, *module, refinedTarget);
    TypeUpdating::updateParamTypes(refinedFunc, refinedTypes, *module);
    refinedFunc->type = HeapType(Signature(refinedParams, func->getResults()));

    // Assume we'll choose to use the refined target, but if we are being
    // careful then we might change our mind.
    auto chosenTarget = refinedTarget;
    if (onlyWhenHelpful) {
      // Optimize both functions using minimal opts, hopefully enough to see if
      // there is a benefit to the refined types (such as the new types allowing
      // a cast to be removed).
      // TODO: Atm this can be done many times per function as it is once per
      //       function and per set of types sent to it. Perhaps have some
      //       total limit to avoid slow runtimes.
      // TODO: We can end up optimizing |func| more than once. It may be
      //       different each time if the previous optimization helped, but
      //       often it will be identical. We could save the original version
      //       and use that as the starting point here (and cache the optimized
      //       version), but then we'd be throwing away optimization results. Or
      //       we could see if later optimizations do not further decrease the
      //       cost, and if so, use a cached value for the cost on such
      //       "already maximally optimized" functions. The former approach is
      //       more amenable to parallelization, as it avoids path dependence -
      //       the other approaches are deterministic but they depend on the
      //       order in which we see things. But it does require saving a copy
      //       of the function, which uses memory, which is avoided if we just
      //       keep optimizing from the current contents as we go. It's not
      //       obvious which approach is best here.
      doMinimalOpts(func);
      doMinimalOpts(refinedFunc);

      auto costBefore = CostAnalyzer(func->body).cost;
      auto costAfter = CostAnalyzer(refinedFunc->body).cost;
      if (costAfter >= costBefore) {
        // We failed to improve. Remove the new function and return the old
        // target.
        module->removeFunction(refinedTarget);
        chosenTarget = target;
      }
    }

    // Mark the chosen target in the map, so we don't do this work again: every
    // pair of target and refinedParams is only considered once.
    funcParamMap[{target, refinedParams}] = chosenTarget;

    return chosenTarget;
  }

  // Run minimal function-level optimizations on a function. This optimizes at
  // -O1 which is very fast and runs in linear time basically, and so it should
  // be reasonable to run as part of this pass: -O1 is several times faster than
  // a full -O2, in particular, and so if we run this as part of -O2 we should
  // not be making it much slower overall.
  // TODO: Perhaps we don't need all of -O1, and can focus on specific things we
  //       expect to help. That would be faster, but we'd always run the risk of
  //       missing things, especially as new passes are added later and we don't
  //       think to add them here.
  //       Alternatively, perhaps we should have a mode that does use -O1 or
  //       even -O2 or above, as in theory any optimization could end up
  //       mattering a lot here.
  void doMinimalOpts(Function* func) {
    PassRunner runner(getPassRunner());
    runner.options.optimizeLevel = 1;
    // Local subtyping is not run in -O1, but we really do want it here since
    // the entire point is that parameters now have more refined types, which
    // can lead to locals reading them being refinable as well.
    runner.add("local-subtyping");
    runner.addDefaultFunctionOptimizationPasses();
    runner.setIsNested(true);
    runner.runOnFunction(func);
  }

  // Maps [func name, param types] to the name of a new function whose params
  // have those types.
  //
  // Note that this can contain funcParamMap{A, types} = A, that is, that maps
  // a function name to itself. That indicates we found no benefit from
  // refining with those particular types, and saves us from computing it again
  // later on.
  std::unordered_map<std::pair<Name, Type>, Name> funcParamMap;
};

} // anonymous namespace

Pass* createMonomorphizePass() { return new Monomorphize(true); }

Pass* createMonomorphizeAlwaysPass() { return new Monomorphize(false); }

} // namespace wasm
