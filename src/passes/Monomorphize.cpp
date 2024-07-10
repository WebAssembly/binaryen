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
// Monomorphization of code based on callsite context: When we see a call, see
// if the information at the callsite can help us optimize. For example, if a
// parameter is constant, then using that constant in the called function may
// unlock a lot of improvements. We may benefit from monomorphizing in the
// following cases:
//
//  * If a call provides a more refined type than the function declares for a
//    parameter.
//  * If a call provides a constant as a parameter.
//  * If a call provides a GC allocation as a parameter. TODO
//  * If a call is dropped. TODO also other stuff on the outside?
//
// We realize the benefit by creating a monomorphized (specialized/refined)
// version of the function, and call that instead. For example, if we have
//
//  function foo(x) { return x + 22; }
//  foo(7);
//
// then monomorphization leads to this:
//
//  function foo(x)  { return x + 22; } // original unmodified function
//  foo_b();                            // now calls foo_b
//  function foo_b() { return 7 + 22; } // monomorphized, constant 7 applied
//
// This is related to inlining both conceptually and practically. Conceptually,
// one of inlining's big advantages is that we then optimize the called code
// together with the code around the call, and monomorphization does something
// similar. And, this pass does so by "reverse-inlining" content from the
// caller to the monomorphized function: the constant 7 in the example above has
// been "pulled in" from the caller into the callee. Larger amounts of code can
// be moved in that manner, both values sent to the function, and the code that
// receives it (see the mention of dropped calls, before).
//
// As this monormophization uses callsite context (the parameters, where the
// result flows to), we call it "Contextual Monomorphization." The full name is
// "Empirical Contextural Monomorphization" because we decide where to optimize
// based on a "try it and see" (empirical) approach, that measures the benefit.
// That is, we generate the monomorphized function as explained, then optimize
// that function, which contains the original code + code from the callsite
// context that we pulled in. If the optimizer manages to improve that combined
// code in a useful way then we apply the optimization, and if not then we undo.
//
// The empirical approach significantly reduces the need for heuristics. For
// example, rather than have a heuristic for "see if a constant parameter flows
// into a conditional branch," we simply run the optimizer and let it optimize
// that case. All other cases handled by the optimizer work as well, without
// needing to specify them as heuristics, so this gets smarter as the optimizer
// does.
//
// Aside from the main version of this pass there is also a variant useful for
// testing that always monomorphizes non-trivial callsites, without checking if
// the optimizer can help or not (that makes writing testcases simpler).
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

// Relevant information about a callsite for purposes of monomorphization.
struct CallContext {
  // The operands of the call, processed to leave the parts that make sense to
  // keep in the context. That is, the operands of the CallContext are the exact
  // code that will appear at the start of the monomorphized function. For
  // example:
  //
  //  (call $foo
  //    (i32.const 10)
  //    (..something complicated..)
  //  )
  //  (func $foo (param $int i32) (param $complex f64)
  //    ..
  //
  // The context operands are
  //
  //  [
  //    (i32.const 10)       ;; Unchanged: this can be pulled into the called
  //                         ;; function, and removed from the caller side.
  //    (local.get $0)       ;; The complicated child cannot; keep it as a value
  //                         ;; sent from the caller, which we will local.get.
  //  ]
  //
  // Both the const and the local.get are simply used in the monomorphized
  // function, like this:
  //
  //  (func $foo-monomorphized (param $0 ..)
  //    (..local defs..)
  //    ;; Apply the first operand, which was pulled into here.
  //    (local.set $int
  //      (i32.const 10)
  //    )
  //    ;; Read the second, which remains a parameter to the function.
  //    (local.set $complex
  //      (local.get $0)
  //    )
  //    ;; The original body.
  //    ..
  //
  // The $int param is no longer a parameter, and it is set in a local at the
  // top: we have "reverse-inlined" code from the calling function into the
  // caller, pulling the constant 10 into here. The second parameter cannot be
  // pulled in, so we must still send it, but we still have a local.set there to
  // copy it into a local (this does not matter in this case, but does if the
  // sent value is more refined; always using a local.set is simpler and more
  // regular).
  std::vector<Expression*> operands;

  // Whether the call is dropped. TODO
  bool dropped;

  bool operator==(const CallContext& other) const {
    if (dropped != other.dropped) {
      return false;
    }

    // We consider logically equivalent expressions as equal (rather than raw
    // pointers), so that contexts with functionally identical shape are
    // treated the same.
    if (operands.size() != other.operands.size()) {
      return false;
    }
    for (Index i = 0; i < operands.size(); i++) {
      if (!ExpressionAnalyzer::equal(operands[i], other.operands[i])) {
        return false;
      }
    }

    return true;
  }

  bool operator!=(const CallContext& other) const { return !(*this == other); }

  // Build the context from a given call. This builds up the context operands as
  // as explained in the comments above, and updates the call to send any
  // remaining values by updating |newOperands| (for example, if all the values
  // sent are constants, then |newOperands| will end up empty, as we have
  // nothing left to send).
  void buildFromCall(Call* call,
                     std::vector<Expression*>& newOperands,
                     Module& wasm) {
    Builder builder(wasm);

    for (auto* operand : call->operands) {
      // Process the operand. This is a copy operation, as we are trying to move
      // (copy) code from the callsite into the called function. When we find we
      // can copy then we do so, and when we cannot that value remains as a
      // value sent from the call.
      operands.push_back(ExpressionManipulator::flexibleCopy(
        operand, wasm, [&](Expression* child) -> Expression* {
          if (canBeMovedIntoContext(child)) {
            // This can be moved, great: let the copy happen.
            return nullptr;
          }

          // This cannot be moved, so we stop here: this is a value that is sent
          // into the monomorphized function. It is a new operand in the call,
          // and in the context operands it is a local.get, that reads that
          // value.
          auto paramIndex = newOperands.size();
          newOperands.push_back(child);
          // TODO: If one operand is a tee and another a get, we could actually
          //       reuse the local, effectively showing the monomorphized
          //       function that the values are the same. (But then the checks
          //       later down to is<LocalGet> would need to check index too.)
          return builder.makeLocalGet(paramIndex, child->type);
        }));
    }

    // TODO: handle drop
    dropped = false;
  }

  // Checks whether an expression can be moved into the context.
  bool canBeMovedIntoContext(Expression* curr) {
    // Constant numbers, funcs, strings, etc. can all be copied, so it is ok to
    // add them to the context.
    // TODO: Allow global.get as well, and anything else that is purely
    //       copyable.
    return Properties::isSingleConstantExpression(curr);
  }

  // Check if a context is trivial relative to a call, that is, the context
  // contains no information that can allow optimization at all. Such trivial
  // contexts can be dismissed early.
  bool isTrivial(Call* call, Module& wasm) {
    // Dropped contexts are not trivial.
    if (dropped) {
      return false;
    }

    // The context must match the call for us to compare them.
    assert(operands.size() == call->operands.size());

    // If an operand is not simply passed through, then we are not trivial.
    auto callParams = wasm.getFunction(call->target)->getParams();
    for (Index i = 0; i < operands.size(); i++) {
      // A local.get of the same type implies we just pass through the value.
      // Anything else is not trivial.
      if (!operands[i]->is<LocalGet>() || operands[i]->type != callParams[i]) {
        return false;
      }
    }

    // We found nothing interesting, so this is trivial.
    return true;
  }
};

} // anonymous namespace

} // namespace wasm

namespace std {

template<> struct hash<wasm::CallContext> {
  size_t operator()(const wasm::CallContext& info) const {
    size_t digest = hash<bool>{}(info.dropped);

    wasm::rehash(digest, info.operands.size());
    for (auto* operand : info.operands) {
      wasm::hash_combine(digest, wasm::ExpressionAnalyzer::hash(operand));
    }

    return digest;
  }
};

// Useful for debugging.
[[maybe_unused]] void dump(std::ostream& o, wasm::CallContext& context) {
  o << "CallContext{\n";
  for (auto* operand : context.operands) {
    o << "  " << *operand << '\n';
  }
  if (context.dropped) {
    o << "  dropped\n";
  }
  o << "}\n";
}

} // namespace std

namespace wasm {

namespace {

struct Monomorphize : public Pass {
  // If set, we run some opts to see if monomorphization helps, and skip cases
  // where we do not help out.
  bool onlyWhenHelpful;

  Monomorphize(bool onlyWhenHelpful) : onlyWhenHelpful(onlyWhenHelpful) {}

  void run(Module* module) override {
    // TODO: parallelize, see comments below

    // Note the list of all functions. We'll be adding more, and do not want to
    // operate on those.
    std::vector<Name> funcNames;
    ModuleUtils::iterDefinedFunctions(
      *module, [&](Function* func) { funcNames.push_back(func->name); });

    // Find the calls in each function and optimize where we can, changing them
    // to call the monomorphized targets.
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
    auto* func = wasm.getFunction(target);
    if (func->imported()) {
      // Nothing to do since this calls outside of the module.
      return;
    }

    // TODO: ignore calls with unreachable operands for simplicty

    // Compute the call context, and the new operands that the call would send
    // if we use that context.
    CallContext context;
    std::vector<Expression*> newOperands;
    context.buildFromCall(call, newOperands, wasm);

    // See if we've already evaluated this function + call context. If so, then
    // we've memoized the result.
    auto iter = funcContextMap.find({target, context});
    if (iter != funcContextMap.end()) {
      auto newTarget = iter->second;
      if (newTarget != target) {
        // When we computed this before we found a benefit to optimizing, and
        // created a new monomorphized function to call. Use it by simply
        // applying the new operands we computed, and adjusting the call target.
        call->operands.set(newOperands);
        call->target = newTarget;
      }
      return;
    }

    // This is the first time we see this situation. First, check if the context
    // is trivial and has no opportunities for optimization.
    if (context.isTrivial(call, wasm)) {
      // Memoize the failure, and stop.
      funcContextMap[{target, context}] = target;
      return;
    }

    // Create the monomorphized function that includes the call context.
    std::unique_ptr<Function> monoFunc =
      makeMonoFunctionWithContext(func, context, wasm);

    // Decide whether it is worth using the monomorphized function.
    auto worthwhile = true;
    if (onlyWhenHelpful) {
      // Optimize both functions using minimal opts, hopefully enough to see if
      // there is a benefit to the context. We optimize both to avoid confusion
      // from the function benefiting from simply running another cycle of
      // optimization.
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
      doMinimalOpts(monoFunc.get());

      auto costBefore = CostAnalyzer(func->body).cost;
      auto costAfter = CostAnalyzer(monoFunc->body).cost;
      // TODO: We should probably only accept improvements above some minimum,
      //       to avoid optimizing cases where we duplicate a huge function but
      //       only optimize a tiny part of it compared to the original.
      if (costAfter >= costBefore) {
        worthwhile = false;
      }
    }

    // Memoize what we decided to call here.
    funcContextMap[{target, context}] = worthwhile ? monoFunc->name : target;

    if (worthwhile) {
      // We are using the monomorphized function, so update the call and add it
      // to the module.
      call->operands.set(newOperands);
      call->target = monoFunc->name;

      wasm.addFunction(std::move(monoFunc));
    }
  }

  // Create a monomorphized function from the original + the call context. It
  // may have different parameters, results, and may include parts of the call
  // context.
  std::unique_ptr<Function> makeMonoFunctionWithContext(
    Function* func, const CallContext& context, Module& wasm) {

    // The context has an operand for each one in the old function, each of
    // which may contain reverse-inlined content. A mismatch here means we did
    // not build the context right, or are using it with the wrong function.
    assert(context.operands.size() == func->getNumParams());

    // Pick a new name.
    auto newName = Names::getValidFunctionName(wasm, func->name);

    // Copy the function as the base for the new one.
    auto newFunc = ModuleUtils::copyFunctionWithoutAdd(func, wasm, newName);

    // Generate the new signature, and apply it to the new function.
    std::vector<Type> newParams;
    for (auto* operand : context.operands) {
      // A local.get is a value that arrives in a parameter. Anything else is
      // something that we are reverse-inlining into the function, so we don't
      // need a param for it.
      if (operand->is<LocalGet>()) {
        newParams.push_back(operand->type);
      }
    }
    // TODO: support changes to results.
    auto newResults = func->getResults();
    newFunc->type = Signature(Type(newParams), newResults);

    // We must update local indexes: the new function has a  potentially
    // different number of parameters, and parameters are at the very bottom of
    // the local index space. We are also replacing old params with vars. To
    // track this, map each old index to the new one.
    std::unordered_map<Index, Index> mappedLocals;
    auto newParamsMinusOld =
      newFunc->getParams().size() - func->getParams().size();
    for (Index i = 0; i < func->getNumLocals(); i++) {
      if (func->isParam(i)) {
        // Old params become new vars inside the function. Below we'll copy the
        // proper values into these vars.
        // TODO: We could avoid a var + copy when it is trivial (atm we rely on
        //       optimizations to remove it).
        auto local = Builder::addVar(newFunc.get(), func->getLocalType(i));
        mappedLocals[i] = local;
      } else {
        // This is a var. The only thing to adjust here is that the parameters
        // are changing.
        mappedLocals[i] = i + newParamsMinusOld;
      }
    }

    // Copy over local names to help debugging.
    if (!func->localNames.empty()) {
      newFunc->localNames.clear();
      newFunc->localIndices.clear();
      for (Index i = 0; i < func->getNumLocals(); i++) {
        auto oldName = func->getLocalNameOrDefault(i);
        if (oldName.isNull()) {
          continue;
        }

        auto newIndex = mappedLocals[i];
        auto newName = Names::getValidLocalName(*newFunc.get(), oldName);
        newFunc->localNames[newIndex] = newName;
        newFunc->localIndices[newName] = newIndex;
      }
    };

    Builder builder(wasm);

    // Surrounding the main body is the reverse-inlined content from the call
    // context, like this:
    //
    //  (func $monomorphized
    //    (..reverse-inlined parameter..)
    //    (..old body..)
    //  )
    //
    // For example, if a function that simply returns its input is called with a
    // constant parameter, it will end up like this:
    //
    //  (func $monomorphized
    //    (local $param i32)
    //    (local.set $param (i32.const 42))  ;; reverse-inlined parameter
    //    (local.get $param)                 ;; copied old body
    //  )
    //
    // We need to add such an local.set in the prelude of the function for each
    // operand in the context.
    std::vector<Expression*> pre;
    for (Index i = 0; i < context.operands.size(); i++) {
      auto* operand = context.operands[i];

      // Write the context operand (the reverse-inlined content) to the local
      // we've allocated for this.
      auto local = mappedLocals.at(i);
      auto* value = ExpressionManipulator::copy(operand, wasm);
      pre.push_back(builder.makeLocalSet(local, value));
    }

    // Map locals.
    struct LocalUpdater : public PostWalker<LocalUpdater> {
      const std::unordered_map<Index, Index>& mappedLocals;
      LocalUpdater(const std::unordered_map<Index, Index>& mappedLocals)
        : mappedLocals(mappedLocals) {}
      void visitLocalGet(LocalGet* curr) { updateIndex(curr->index); }
      void visitLocalSet(LocalSet* curr) { updateIndex(curr->index); }
      void updateIndex(Index& index) {
        auto iter = mappedLocals.find(index);
        assert(iter != mappedLocals.end());
        index = iter->second;
      }
    } localUpdater(mappedLocals);
    localUpdater.walk(newFunc->body);

    if (!pre.empty()) {
      // Add the block after the prelude.
      pre.push_back(newFunc->body);
      newFunc->body = builder.makeBlock(pre);
    }

    return newFunc;
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
    // TODO: we need local propagation and escape analysis etc. -O3?
    runner.addDefaultFunctionOptimizationPasses();
    runner.setIsNested(true);
    runner.runOnFunction(func);
  }

  // Maps [func name, call info] to the name of a new function which is a
  // monomorphization of that function, specialized to that call info.
  //
  // Note that this can contain funcContextMap{A, ...} = A, that is, that maps
  // a function name to itself. That indicates we found no benefit from
  // monomorphizing with that context, and saves us from computing it again
  // later on.
  std::unordered_map<std::pair<Name, CallContext>, Name> funcContextMap;
};

} // anonymous namespace

Pass* createMonomorphizePass() { return new Monomorphize(true); }

Pass* createMonomorphizeAlwaysPass() { return new Monomorphize(false); }

} // namespace wasm
