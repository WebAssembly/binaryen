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

  bool operator==(const CallContext& other) const {
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

    return dropped == other.dropped;
  }

  bool operator!=(const CallContext& other) const { return !(*this == other); }

  // Build the context from a given call. This builds up the generalized
  // parameters as explained in the comments above, and generates the new
  // operands for the call to have (through the out param).
  void buildFromCall(Call* call, std::vector<Expression*>& newOperands, Module& wasm) {
    Builder builder(wasm);

    for (auto* operand : call->operands) {
      // Process the operand, generating the generalized one. This is a copy
      // operation, as so long as we find things that we can "reverse-inline"
      // into the called function as part of the call context then we continue
      // to do so. When we cannot move code in that manner then we emit a
      // local.get, as that is a new parameter.
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
          //       function that the values are the same.
          return builder.makeLocalGet(paramIndex, child->type);
        }));
    }

    // TODO: handle drop
    dropped = false;
  }

  // Checks whether an expression can be moved into the context. Things that can
  // be, become part of the context, and so they become part of the refined
  // functions that we create with the context.
  bool canBeMovedIntoContext(Expression* curr) {
    // Constant numbers, funcs, strings, etc. can all be copied, so it is ok to
    // add them to the context.
    return Properties::isSingleConstantExpression(curr);
  }

  // Check if a context is trivial relative to a call, that is, the context
  // contains no information that can allow optimization at all. Such contexts
  // can be dismissed early.
  bool isTrivial(Call* call, Module& wasm) {
    // Dropped contexts are not trivial.
    if (dropped) {
      return false;
    }

    // If the context simply passes through all the operands, without adding or
    // removing any, and without even refining a type, then it is trivial.
    if (operands.size() != call->operands.size()) {
      return false;
    }
    auto callParams = wasm.getFunction(call->target)->getParams();
    for (Index i = 0; i < operands.size(); i++) {
      // A local.get of the same type implies we just pass through the value.
      if (!operands[i]->is<LocalGet>() ||
          operands[i]->type != callParams[i]) {
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

[[maybe_unused]]
std::ostream& operator<<(std::ostream& o, wasm::CallContext& context) {
  o << "CallContext{\n";
  for (auto* operand : context.operands) {
    o << "  " << *operand << '\n';
  }
  if (context.dropped) {
    o << "  dropped\n";
  }
  o << "}\n";
  return o;
}

} // namespace std

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
    auto* func = wasm.getFunction(target);
    if (func->imported()) {
      // Nothing to do since this calls outside of the module.
      return;
    }

    // TODO: igmore calls with unreachable operands for simplicty

    // Compute the call context.
    CallContext context;
    std::vector<Expression*> newOperands;
    context.buildFromCall(call, newOperands, wasm);
//std::cout << "eval " << *call << " : " << context << '\n';
    // See if we've already evaluated this function + call context. If so, that
    // is in the map, whether we decided to optimize or not.
    auto iter = funcContextMap.find({target, context});
    if (iter != funcContextMap.end()) {
//std::cout << "old\n";
      auto newTarget = iter->second;
      if (newTarget != target) {
//std::cout << " good\n";
        // When we computed this before, we found a benefit to optimizing, and
        // created a new monomorphized function to call. Use it by simply
        // applying the new operands we computed, and adjusting the call target.
        call->operands.set(newOperands);
        call->target = newTarget;
      }
      return;
    }

    // This is the first time we see this situation. Firs, check if it the
    // context is trivial and has no opportunities for optimization.
    if (context.isTrivial(call, wasm)) {
//std::cout << "triv\n";
      // Memoize the failure, and stop.
      funcContextMap[{target, context}] = target;
      return;
    }

    // Create the refined function that has includes the call context.
    std::unique_ptr<Function> refinedFunc =
      makeRefinedFunctionWithContext(func, context, wasm);

    // Assume we'll choose to use the refined target, but if we are being
    // careful then we might change our mind.
    auto chosenTarget = refinedFunc->name;
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
      doMinimalOpts(refinedFunc.get());

      auto costBefore = CostAnalyzer(func->body).cost;
      auto costAfter = CostAnalyzer(refinedFunc->body).cost;
      if (costAfter >= costBefore) {
        // We failed to improve; use the original target instead.
        chosenTarget = target;
      }
    }

//std::cout << "memo " << chosenTarget << "\n";
    // Mark the chosen target in the map, so we don't do this work again,
    // memoizing both success and failure.
    funcContextMap[{target, context}] = chosenTarget;

    if (chosenTarget == refinedFunc->name) {
      // We are using the refined function, so add it to the module, and update
      // the call.
      wasm.addFunction(std::move(refinedFunc));

      call->operands.set(newOperands);
      call->target = chosenTarget;
    }
  }

  // Creates a refined function from the original + the call context. The
  // refined one may have different parameters, results, and may include parts
  // of the call context.
  std::unique_ptr<Function> makeRefinedFunctionWithContext(
    Function* func, const CallContext& context, Module& wasm) {

    // The context has an operand for each param in the old function, each of
    // which may contain reverse-inlined content. A mismatch here means we did
    // not build the context right, or are using it with the wrong function.
    assert(context.operands.size() == func->getNumParams());

    // Pick a new name.
    auto newName = Names::getValidFunctionName(wasm, func->name);

    // Generate the new signature.
    std::vector<Type> newParams;
    for (auto* operand : context.operands) {
      newParams.push_back(operand->type);
    }
    // TODO: support changes to results.
    auto newResults = func->getResults();
    auto newType = HeapType(Signature(Type(newParams), newResults));

    // Copy the function's vars, though below we will need to re-index them, as
    // we are adjusting params.
    auto newVars = func->vars;

    // Make the new function.
    Builder builder(wasm);
    auto newFunc = builder.makeFunction(newName, newType, std::move(newVars));

    // We must update local indexes: the new function has a XXX
    // potentially different number of parameters, which are at the bottom of
    // the local index space. We are also replacing old params with vars. To
    // track this, map each old index to the new one.
    std::unordered_map<Index, Index> mappedLocals;
    auto newParamsMinusOld = newFunc->getParams().size() - func->getParams().size();
    for (Index i = 0; i < func->getNumLocals(); i++) {
      if (func->isParam(i)) {
        // Old params become new vars inside the function. Later, we'll copy the
        // proper values into these vars.
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

//for (auto [k, v] : mappedLocals) std::cout << "map " << k << " to " << v << '\n';

    // Surrounding the main body is the reverse-inlined content from the call
    // context, like this:
    //
    //  (func $refined
    //    (..reverse-inlined parameter..)
    //    (..old body..)
    //  )
    //
    // For example, if a function that simply returns its input is called with a
    // constant parameter, it will end up like this:
    //
    //  (func $refined
    //    (local $param i32)
    //    (local.set $param (i32.const 42))  ;; reverse-inlined parameter
    //    (local.get $param)                 ;; copied old body
    //  )
    //
    // We need to add such an entry for a parameter when it changes, like in the
    // example above, where a constant param turns from a param into a local. We
    // must also do so when the type changes, resulting in this:
    //
    //  (func $refined (param $param (ref $sub))
    //    (local $original (ref $super))
    //    (local.set $super (local.get $sub))
    //
    // We write the refined actual param into a local that replaces the old
    // param (and we then let optimizations propagate the refined type). To do
    // this, we build up a list of the expressions we will prepend:
    std::vector<Expression*> pre;

    for (Index i = 0; i < context.operands.size(); i++) {
      auto* operand = context.operands[i];

      // We've allocated a local for this, which we can write to.
      auto local = mappedLocals.at(i);
      auto* value = ExpressionManipulator::copy(operand, wasm);
      pre.push_back(builder.makeLocalSet(local, value));
    }

    // The main body of the function is simply copied from the original.
    auto* newBody = ExpressionManipulator::copy(func->body, wasm);

    // Map locals.
    struct LocalUpdater : public PostWalker<LocalUpdater> {
      const std::unordered_map<Index, Index>& mappedLocals;
      LocalUpdater(const std::unordered_map<Index, Index>& mappedLocals) : mappedLocals(mappedLocals) {}
      void visitLocalGet(LocalGet* curr) { updateIndex(curr->index); }
      void visitLocalSet(LocalSet* curr) { updateIndex(curr->index); }
      void updateIndex(Index& index) {
        auto iter = mappedLocals.find(index);
        assert(iter != mappedLocals.end());
        index = iter->second;
      }
    } localUpdater(mappedLocals);
    localUpdater.walk(newBody);

    if (!pre.empty()) {
      // Add the block after the prepends.
      pre.push_back(newBody);
      newBody = builder.makeBlock(pre);
    }
    newFunc->body = newBody;

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
    // TODO: propagate-locals too.
    runner.add("local-subtyping");
    // TODO Heap2Local and more of -O2+...
    runner.addDefaultFunctionOptimizationPasses();
    runner.setIsNested(true);
    runner.runOnFunction(func);
  }

  // Maps [func name, call info] to the name of a new function which is
  // specialized to that call info.
  //
  // Note that this can contain funcContextMap{A, ...} = A, that is, that maps
  // a function name to itself. That indicates we found no benefit from
  // refining with those particular types, and saves us from computing it again
  // later on.
  std::unordered_map<std::pair<Name, CallContext>, Name> funcContextMap;
};

} // anonymous namespace

Pass* createMonomorphizePass() { return new Monomorphize(true); }

Pass* createMonomorphizeAlwaysPass() { return new Monomorphize(false); }

} // namespace wasm
