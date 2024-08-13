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
//  * If a call is dropped. TODO also other stuff on the outside, e.g. eqz?
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
// This pass takes an argument:
//
//   --pass-arg=monomorphize-min-benefit@N
//
//      The minimum amount of benefit we require in order to decide to optimize,
//      as a percentage of the original cost. If this is 0 then we always
//      optimize, if the cost improves by even 0.0001%. If this is 50 then we
//      optimize only when the optimized monomorphized function has half the
//      cost of the original, and so forth, that is higher values are more
//      careful (and 100 will only optimize when the cost goes to nothing at
//      all).
//
// TODO: We may also want more arguments here:
//  * Max function size on which to operate (to not even try to optimize huge
//    functions, which could be slow).
//  * Max optimized size (if the max optimized size is less than the size we
//    inline, then all optimized cases would end up inlined; that would also
//    put a limit on the size increase).
//  * Max absolute size increase (total of all added code).
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
// TODO: Should we look at no-inline flags? We do move code between functions,
//       but it isn't normal inlining.
//

#include "ir/cost.h"
#include "ir/effects.h"
#include "ir/find_all.h"
#include "ir/iteration.h"
#include "ir/manipulation.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/properties.h"
#include "ir/return-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/hash.h"
#include "wasm-limits.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

// Pass arguments. See descriptions in the comment above.
Index MinPercentBenefit = 95;

// A limit on the number of parameters we are willing to have on monomorphized
// functions. Large numbers can lead to large stack frames, which can be slow
// and lead to stack overflows.
// TODO: Tune this and perhaps make it a flag.
const Index MaxParams = 20;
// This must be less than the corresponding Web limitation, so we do not emit
// invalid binaries.
static_assert(MaxParams < WebLimitations::MaxFunctionParams);

// Core information about a call: the call itself, and if it is dropped, the
// drop.
struct CallInfo {
  Call* call;
  // Store a reference to the drop's pointer so that we can replace it, as when
  // we optimize a dropped call we need to replace (drop (call)) with (call).
  // Or, if the call is not dropped, this is nullptr.
  Expression** drop;
};

// Finds the calls and whether each one of them is dropped.
struct CallFinder : public PostWalker<CallFinder> {
  std::vector<CallInfo> infos;

  void visitCall(Call* curr) {
    // Add the call as not having a drop, and update the drop later if we are.
    infos.push_back(CallInfo{curr, nullptr});
  }

  void visitDrop(Drop* curr) {
    if (curr->value->is<Call>()) {
      // The call we just added to |infos| is dropped.
      assert(!infos.empty());
      auto& back = infos.back();
      assert(back.call == curr->value);
      back.drop = getCurrentPointer();
    }
  }
};

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
  //
  // The approach implemented here tries to move as much code into the call
  // context as possible. That may not always be helpful, say in situations like
  // this:
  //
  //  (call $foo
  //    (i32.add
  //      (local.get $x)
  //      (local.get $y)
  //    )
  //  )
  //
  // If we move the i32.add into $foo then it will still be adding two unknown
  // values (which will be parameters rather than locals). Moving the add might
  // just increase code size if so. However, there are many other situations
  // where the more code, the better:
  //
  //  (call $foo
  //    (i32.eqz
  //      (local.get $x)
  //    )
  //  )
  //
  // While the value remains unknown, after moving the i32.eqz into the target
  // function we may be able to use the fact that it has at most 1 bit set.
  // Even larger benefits can happen in WasmGC:
  //
  //  (call $foo
  //    (struct.new $T
  //      (local.get $x)
  //      (local.get $y)
  //    )
  //  )
  //
  // If the struct never escapes then we may be able to remove the allocation
  // after monomorphization, even if we know nothing about the values in its
  // fields.
  //
  // TODO: Explore other options that are more careful about how much code is
  //       moved.
  void buildFromCall(CallInfo& info,
                     std::vector<Expression*>& newOperands,
                     Module& wasm,
                     const PassOptions& options) {
    Builder builder(wasm);

    // First, find the things we can move into the context and the things we
    // cannot. Some things simply cannot be moved out of the calling function,
    // such as a local.set, but also we need to handle effect interactions among
    // the operands, because each time we move code into the context we are
    // pushing it into the called function, which changes the order of
    // operations, for example:
    //
    //  (call $foo
    //    (first
    //      (a)
    //    )
    //    (second
    //      (b)
    //    )
    //  )
    //
    //  (func $foo (param $first) (param $second)
    //  )
    //
    // If we move |first| and |a| into the context then we get this:
    //
    //  (call $foo
    //    ;; |first| and |a| were removed from here.
    //    (second
    //      (b)
    //    )
    //  )
    //
    //  (func $foo (param $second)
    //    ;; |first| is now a local, and we assign it inside the called func.
    //    (local $first)
    //    (local.set $first
    //      (first
    //        (a)
    //      )
    //    )
    //  )
    //
    // After this code motion we execute |second| and |b| *before* the call, and
    // |first| and |a| after, so we cannot do this transformation if the order
    // of operations between them matters.
    //
    // The key property here is that all things that are moved into the context
    // (moved into the monomorphized function) remain ordered with respect to
    // each other, but must be moved past all non-moving things after them. For
    // example, say we want to move B and D in this list (of expressions in
    // execution order):
    //
    //  A, B, C, D, E
    //
    // After moving B and D we end up with this:
    //
    //  A, C, E  and executing later in the monomorphized function:  B, D
    //
    // Then we must be able to move B past C and E, and D past E. It is simplest
    // to compute this in reverse order, starting from E and going back, and
    // then each time we want to move something we can check if it can cross
    // over all the non-moving effects we've seen so far. To compute this, first
    // list out the post-order of the expressions, and then we'll iterate in
    // reverse.
    struct Lister
      : public PostWalker<Lister, UnifiedExpressionVisitor<Lister>> {
      std::vector<Expression*> list;
      void visitExpression(Expression* curr) { list.push_back(curr); }
    } lister;
    // As a quick estimate, we need space for at least the operands.
    lister.list.reserve(operands.size());

    for (auto* operand : info.call->operands) {
      lister.walk(operand);
    }

    // Go in reverse post-order as explained earlier, noting what cannot be
    // moved into the context, and while accumulating the effects that are not
    // moving.
    std::unordered_set<Expression*> immovable;
    EffectAnalyzer nonMovingEffects(options, wasm);
    for (auto i = int64_t(lister.list.size()) - 1; i >= 0; i--) {
      auto* curr = lister.list[i];

      // This may have been marked as immovable because of the parent. We do
      // that because if a parent is immovable then we can't move the children
      // into the context (if we did, they would execute after the parent, but
      // it needs their values).
      bool currImmovable = immovable.count(curr) > 0;
      if (!currImmovable) {
        // This might be movable or immovable. Check both effect interactions
        // (as described before, we want to move this past immovable code) and
        // reasons intrinsic to the expression itself that might prevent moving.
        ShallowEffectAnalyzer currEffects(options, wasm, curr);
        if (currEffects.invalidates(nonMovingEffects) ||
            !canBeMovedIntoContext(curr, currEffects)) {
          immovable.insert(curr);
          currImmovable = true;
        }
      }

      if (currImmovable) {
        // Regardless of whether this was marked immovable because of the
        // parent, or because we just found it cannot be moved, accumulate the
        // effects, and also mark its immediate children (so that we do the same
        // when we get to them).
        nonMovingEffects.visit(curr);
        for (auto* child : ChildIterator(curr)) {
          immovable.insert(child);
        }
      }
    }

    // We now know which code can be moved and which cannot, so we can do the
    // final processing of the call operands. We do this as a copy operation,
    // copying as much as possible into the call context. Code that cannot be
    // moved ends up as values sent to the monomorphized function.
    //
    // The copy operation works in pre-order, which allows us to override
    // entire children as needed:
    //
    //  (call $foo
    //    (problem
    //      (a)
    //    )
    //    (later)
    //  )
    //
    // We visit |problem| first, and if there is a problem that prevents us
    // moving it into the context then we override the copy and then it and
    // its child |a| remain in the caller (and |a| is never visited in the
    // copy).
    for (auto* operand : info.call->operands) {
      operands.push_back(ExpressionManipulator::flexibleCopy(
        operand, wasm, [&](Expression* child) -> Expression* {
          if (!child) {
            // This is an optional child that is not present. Let the copy of
            // the nullptr happen.
            return nullptr;
          }

          if (!immovable.count(child)) {
            // This can be moved; let the copy happen.
            return nullptr;
          }

          // This cannot be moved. Do not copy it into the call context. In the
          // example above, |problem| remains as an operand on the call (so we
          // add it to |newOperands|), and in the call context all we have is a
          // local.get that reads that sent value.
          auto paramIndex = newOperands.size();
          newOperands.push_back(child);
          // TODO: If one operand is a tee and another a get, we could actually
          //       reuse the local, effectively showing the monomorphized
          //       function that the values are the same. EquivalentSets may
          //       help here.
          return builder.makeLocalGet(paramIndex, child->type);
        }));
    }

    dropped = !!info.drop;
  }

  // Checks whether an expression can be moved into the context.
  bool canBeMovedIntoContext(Expression* curr,
                             const ShallowEffectAnalyzer& effects) {
    // Pretty much everything can be moved into the context if we can copy it
    // between functions, such as constants, globals, etc. The things we cannot
    // copy are now checked for.
    if (effects.branchesOut || effects.hasExternalBreakTargets()) {
      // This branches or returns. We can't move control flow between functions.
      return false;
    }
    if (effects.accessesLocal()) {
      // Reads/writes to local state cannot be moved around.
      return false;
    }
    if (effects.calls) {
      // We can in principle move calls, but for simplicity we avoid such
      // situations (which might involve recursion etc.).
      return false;
    }
    if (Properties::isControlFlowStructure(curr)) {
      // We can in principle move entire control flow structures with their
      // children, but for simplicity stop when we see one rather than look
      // inside to see if we could transfer all its contents. (We would also
      // need to be careful when handling If arms, etc.)
      return false;
    }
    for (auto* child : ChildIterator(curr)) {
      if (child->type.isTuple()) {
        // Consider this:
        //
        //  (call $target
        //    (tuple.extract 2 1
        //      (local.get $tuple)
        //    )
        //  )
        //
        // We cannot move the tuple.extract into the context, because then the
        // call would have a tuple param. While it is possible to split up the
        // tuple, or to check if we can also move the children with the parent,
        // for simplicity just ignore this rare situation.
        return false;
      }
    }
    return true;
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

    applyArguments();

    // Find all the return-calling functions. We cannot remove their returns
    // (because turning a return call into a normal call may break the program
    // by using more stack).
    auto returnCallersMap = ReturnUtils::findReturnCallers(*module);

    // Note the list of all functions. We'll be adding more, and do not want to
    // operate on those.
    std::vector<Name> funcNames;
    ModuleUtils::iterDefinedFunctions(
      *module, [&](Function* func) { funcNames.push_back(func->name); });

    // Find the calls in each function and optimize where we can, changing them
    // to call the monomorphized targets.
    for (auto name : funcNames) {
      auto* func = module->getFunction(name);

      CallFinder callFinder;
      callFinder.walk(func->body);
      for (auto& info : callFinder.infos) {
        if (info.call->type == Type::unreachable) {
          // Ignore unreachable code.
          // TODO: return_call?
          continue;
        }

        if (info.call->target == name) {
          // Avoid recursion, which adds some complexity (as we'd be modifying
          // ourselves if we apply optimizations).
          continue;
        }

        // If the target function does a return call, then as noted earlier we
        // cannot remove its returns, so do not consider the drop as part of the
        // context in such cases (as if we reverse-inlined the drop into the
        // target then we'd be removing the returns).
        if (returnCallersMap[module->getFunction(info.call->target)]) {
          info.drop = nullptr;
        }

        processCall(info, *module);
      }
    }
  }

  void applyArguments() {
    MinPercentBenefit = std::stoul(getArgumentOrDefault(
      "monomorphize-min-benefit", std::to_string(MinPercentBenefit)));
  }

  // Try to optimize a call.
  void processCall(CallInfo& info, Module& wasm) {
    auto* call = info.call;
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
    context.buildFromCall(info, newOperands, wasm, getPassOptions());

    // See if we've already evaluated this function + call context. If so, then
    // we've memoized the result.
    auto iter = funcContextMap.find({target, context});
    if (iter != funcContextMap.end()) {
      auto newTarget = iter->second;
      if (newTarget != target) {
        // We saw benefit to optimizing this case. Apply that.
        updateCall(info, newTarget, newOperands, wasm);
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

    // If we ended up with too many params, give up. In theory we could try to
    // monomorphize in ways that use less params, but this is a rare situation
    // that is not easy to handle (when we move something into the context, it
    // *removes* a param, which is good, but if it has many children and end up
    // not moved, that is where the problem happens, so we'd need to backtrack).
    // TODO: Consider doing more here.
    if (monoFunc->getNumParams() >= MaxParams) {
      return;
    }

    // Decide whether it is worth using the monomorphized function.
    auto worthwhile = true;
    if (onlyWhenHelpful) {
      // Run the optimizer on both functions, hopefully just enough to see if
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
      doOpts(func);

      // The cost before monomorphization is the old body + the context
      // operands. The operands will be *removed* from the calling code if we
      // optimize, and moved into the monomorphized function, so the proper
      // comparison is the context + the old body, versus the new body (which
      // includes the reverse-inlined call context).
      //
      // Note that we use a double here because we are going to subtract and
      // multiply this value later (and want to avoid unsigned integer overflow,
      // etc.).
      double costBefore = CostAnalyzer(func->body).cost;
      for (auto* operand : context.operands) {
        // Note that a slight oddity is that we have *not* optimized the
        // operands before. We optimize func before and after, but the operands
        // are in the calling function, which we are not modifying here. In
        // theory that might lead to false positives, if the call's operands are
        // very unoptimized.
        costBefore += CostAnalyzer(operand).cost;
      }
      if (costBefore == 0) {
        // Nothing to optimize away here. (And it would be invalid to divide by
        // this amount in the code below.)
        worthwhile = false;
      } else {
        // There is a point to optimizing the monomorphized function, do so.
        doOpts(monoFunc.get());

        double costAfter = CostAnalyzer(monoFunc->body).cost;

        // Compute the percentage of benefit we see here.
        auto benefit = 100 - ((100 * costAfter) / costBefore);
        if (benefit <= MinPercentBenefit) {
          worthwhile = false;
        }
      }
    }

    // Memoize what we decided to call here.
    funcContextMap[{target, context}] = worthwhile ? monoFunc->name : target;

    if (worthwhile) {
      // We are using the monomorphized function, so update the call and add it
      // to the module.
      updateCall(info, monoFunc->name, newOperands, wasm);

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

    // A local.get is a value that arrives in a parameter. Anything else is
    // something that we are reverse-inlining into the function, so we don't
    // need a param for it. Note that we might have multiple gets nested here,
    // if we are copying part of the original parameter but not all children, so
    // we scan each operand for all such local.gets.
    //
    // Use this information to generate the new signature, and apply it to the
    // new function.
    std::vector<Type> newParams;
    for (auto* operand : context.operands) {
      FindAll<LocalGet> gets(operand);
      for (auto* get : gets.list) {
        newParams.push_back(get->type);
      }
    }
    // If we were dropped then we are pulling the drop into the monomorphized
    // function, which means we return nothing.
    auto newResults = context.dropped ? Type::none : func->getResults();
    newFunc->type = Signature(Type(newParams), newResults);

    // We must update local indexes: the new function has a potentially
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
    // We need to add such a local.set in the prelude of the function for each
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

    if (context.dropped) {
      ReturnUtils::removeReturns(newFunc.get(), wasm);
    }

    return newFunc;
  }

  // Given a call and a new target it should be calling, apply that new target,
  // including updating the operands and handling dropping.
  void updateCall(const CallInfo& info,
                  Name newTarget,
                  const std::vector<Expression*>& newOperands,
                  Module& wasm) {
    info.call->target = newTarget;
    info.call->operands.set(newOperands);

    if (info.drop) {
      // Replace (drop (call)) with (call), that is, replace the drop with the
      // (updated) call which now has type none. Note we should have handled
      // unreachability before getting here.
      assert(info.call->type != Type::unreachable);
      info.call->type = Type::none;
      *info.drop = info.call;
    }
  }

  // Run some function-level optimizations on a function. Ideally we would run a
  // minimal amount of optimizations here, but we do want to give the optimizer
  // as much of a chance to work as possible, so for now do all of -O3 (in
  // particular, we really need to run --precompute-propagate so constants are
  // applied in the optimized function).
  // TODO: Perhaps run -O2 or even -O1 if the function is large (or has many
  //       locals, etc.), to ensure linear time, but we could miss out.
  void doOpts(Function* func) {
    PassRunner runner(getPassRunner());
    runner.options.optimizeLevel = 3;
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
