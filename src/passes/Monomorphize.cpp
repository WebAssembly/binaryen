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
// When we see a call, see if the information at the callsite can allow us to
// optimize. This is related to inlining: when we inline, the calling function
// then optimizes the inlined code together with the code around the callsite,
// while in monomorphization we handle cases that inlining cannot do, by
// creating a specialized version of the called function tuned for the
// particular call. In particular, we may benefit from monomorphizing in the
// following cases:
//
//  * If a call provides a more refined type than the function declares for a
//    parameter.
//  * If a call provides a constant as a parameter.
//  * If a call provides a GC allocation as a parameter. TODO
//  * If a call is dropped. TODO also other stuff on the outside?
//
// For example, if a call provides a constant then the call + called function
// may optimize well together if constant propagation leads to removal of code.
// GC allocations may also be useful as Heap2Local may operate (if the
// allocation does not escape). And for a dropped call, if we optimize with the
// drop inside the function then all the computation of that result may be
// removed.
//
// As this monormophization uses callsite context (the parameters, where the
// result flows to), we call it "Contextual Monomorphization." We do not just
// monomorphize the called function itself but in combination with that
// context.
//
// To see when monomorphizing makes sense, this optimizes the target function
// together with the callsite context, and then measures how much we benefit.
// This is a "try it and see" approach, so we call it "Empirical Contextual
// Monomorphization." Seeing how well the callsite + called function optimize
// together is a general approach that reduces the need for heuristics. For
// example, rather than have a heuristic for "see if a constant parameter flows
// into a conditional branch," we simply run the optimizer and let it optimize
// that case. All other cases handled by the optimizer work as well, without
// needing to specify them as heuristics, and this gets smarter as the optimizer
// does.
//
// There are two versions of this pass, the normal one and one that always
// monomorphizes (even if empirically it doesn't look helpful), which is useful
// for testing.
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
//

#include "ir/cost.h"
#include "ir/find_all.h"
#include "ir/manipulation.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/hash.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

// Relevant information about a call for purposes of monomorphization.
struct CallContext {
  // The operands the call sends as parameters, in a general form. This form is
  // in fact the exact code that will appear in the specialized called function.
  // An example may help:
  //
  //  (call $foo
  //    (i32.const 10)
  //    (struct.new $struct
  //      (..something complicated..)
  //    )
  //  )
  //
  //  (func $foo (param $int i32) (param $ref (ref $struct))
  //    ..
  //
  // The generalized operands are
  //
  //  [
  //    (i32.const 10)       ;; unchanged
  //    (struct.new $struct  ;; the struct.new can be handled
  //      (local.get $0)     ;; the complicated child cannot; make it a param
  //    )
  //  ]
  //
  // Note how the inner part of the struct.new is a local.get. That is a
  // local.get of a parameter to the specialized function, which looks like
  // this:
  //
  //  (func $foo-monomorphized (param $0 ..)
  //    (..local defs..)
  //    ;; Apply the first operand.
  //    (local.set $int
  //      (i32.const 10)
  //    )
  //    ;; Apply the second operand.
  //    (local.set $ref
  //      (struct.new $struct
  //        (local.get $0)  ;; Read the new parameter.
  //      )
  //    )
  //    ;; The original body.
  //    ..
  //
  // The $int param is no longer a parameter, and it is set in a local at the
  // top. The $ref parameter is likewise removed. Note how, effectively, we have
  // "reverse-inlined" code from the calling function into the caller, that is,
  // we pull the context into the called function, where it is now alongside the
  // code that we hope optimizes well with it.
  //
  // We also have a new parameter for the internal part of the struct.new that
  // we could not handle, and the call would send only that:
  //
  //  (call $foo-monomorphized
  //    (..something complicated..)
  //  )
  //
  // $foo-monomorphized is now a version of $monomorphized that has "pulled in"
  // parts of the call context, which may allow it to get optimized better.
  std::vector<Expression*> operands;

  // Whether the call is dropped.
  bool dropped;

  CallContext(std::vector<Expression*> operands, bool dropped) : operands(operands), dropped(dropped) {}
};

} // anonymous namespace

} // namespace wasm

namespace std {

template<> struct hash<wasm::CallContext> {
  size_t operator()(const wasm::CallContext& info) const {
    size_t digest = std::hash<bool>(info.dropped);

    rehash(digest, info.operands.size());
    for (auto* operand : info.operands) {
      hash_combine(digest, ExpressionAnalyzer::hash(operand));
    }
  }
};

}

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

        processCall(call, *module);
      }
    }
  }

  // Try to optimize a call.
  void processCall(Call* call, Module& wasm) {
    auto target = call->target;
    auto* func = module->getFunction(target);
    if (func->imported()) {
      // Nothing to do since this calls outside of the module.
      return target;
    }

    // Compute the call context. This builds up the generalized parameters as
    // explained in the comments on CallContext, and sets up the operands for
    // the new call (which may have less, more, or different parameters than the
    // original).
    CallContext context;
    std::vector<Expression*> newOperands;
    //auto params = func->getParams();
    for (auto* operand : call->operands) {
      // Process the operand, generating the generalized one. This is a copy
      // operation, as so long as we find things that we can "reverse-inline"
      // into the called function, we continue to do so. When we cannot move
      // code in that manner then we emit a local.get, as that is a new
      // parameter.
      context.operands = ExpressionManipulator::flexibleCopy(operand, wasm, [&](Expression*) {
      });


..

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
      // a cast to be removed). We optimize both to avoid confusion from the
      // function benefiting from just another cycle of optimization, regardless
      // or monomorphization.
      //
      // Note that we do *not* discard the optimizations to the original
      // function if we decide not to optimize. We've already done them, and the
      // function is improved, so we may as well keep them.
      //
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
    // TODO Heap2Local if there is a struct.new in the new operands
    runner.addDefaultFunctionOptimizationPasses();
    runner.setIsNested(true);
    runner.runOnFunction(func);
  }

  // Maps [func name, call info] to the name of a new function which is
  // specialized to that call info.
  //
  // Note that this can contain funcParamMap{A, ...} = A, that is, that maps
  // a function name to itself. That indicates we found no benefit from
  // refining with those particular types, and saves us from computing it again
  // later on.
  std::unordered_map<std::pair<Name, CallContext>, Name> funcParamMap;
};

} // anonymous namespace

Pass* createMonomorphizePass() { return new Monomorphize(true); }

Pass* createMonomorphizeAlwaysPass() { return new Monomorphize(false); }

} // namespace wasm
