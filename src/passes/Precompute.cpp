/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Computes code at compile time where possible, replacing it with the
// computed constant.
//
// The "propagate" variant of this pass also propagates constants across
// sets and gets, which implements a standard constant propagation.
//
// Possible nondeterminism: WebAssembly NaN signs are nondeterministic,
// and this pass may optimize e.g. a float 0 / 0 into +nan while a VM may
// emit -nan, which can be a noticeable difference if the bits are
// looked at.
//

#include "ir/iteration.h"
#include "ir/literal-utils.h"
#include "ir/local-graph.h"
#include "ir/manipulation.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/insert_ordered.h"
#include "support/small_vector.h"
#include "wasm-builder.h"
#include "wasm-interpreter.h"
#include "wasm.h"

namespace wasm {

// A map of gets to their constant values. If a get does not have a constant
// value then it does not appear in the map (that avoids allocating for the
// majority of gets).
using GetValues = std::unordered_map<LocalGet*, Literals>;

// A map of values on the heap. This maps the expressions that create the
// heap data (struct.new, array.new, etc.) to the data they are created with.
// Each such expression gets its own GCData created for it. This allows
// computing identity between locals referring to the same GCData, by seeing
// if they point to the same thing.
//
// Note that a source expression may create different data each time it is
// reached in a loop,
//
// (loop
//  (if ..
//   (local.set $x
//    (struct.new ..
//   )
//  )
//  ..compare $x to something..
// )
//
// Just like in SSA form, this is not a problem because the loop entry must
// have a merge, if a value entering the loop might be noticed. In SSA form
// that means a phi is created, and identity is set there. In our
// representation, the merge will cause a local.get of $x to have more
// possible input values than that struct.new, which means we will not infer
// a value for it, and not attempt to say anything about comparisons of $x.
struct HeapValues {
  struct Entry {
    // The GC data for an expression.
    std::shared_ptr<GCData> data;
    // Whether the expression has effects. If it does then we must recompute it
    // each time we see it, even though we return |data| to represent it.
    // (Recomputing will apply those effects each time, so we don't forget them
    // when we read from the cache. This recomputing is rare, and doesn't happen
    // e.g. in global GC objects, where most of the work happens, so this cache
    // still saves a lot.)
    bool hasEffects;
  };

  std::unordered_map<Expression*, Entry> map;
};

// Precomputes an expression. Errors if we hit anything that can't be
// precomputed. Inherits most of its functionality from
// ConstantExpressionRunner, which it shares with the C-API, but adds handling
// of GetValues computed during the precompute pass.
class PrecomputingExpressionRunner
  : public ConstantExpressionRunner<PrecomputingExpressionRunner> {

  using Super = ConstantExpressionRunner<PrecomputingExpressionRunner>;

  // Concrete values of gets computed during the pass, which the runner does not
  // know about since it only records values of sets it visits.
  const GetValues& getValues;

  HeapValues& heapValues;

  // Limit evaluation depth for 2 reasons: first, it is highly unlikely
  // that we can do anything useful to precompute a hugely nested expression
  // (we should succed at smaller parts of it first). Second, a low limit is
  // helpful to avoid platform differences in native stack sizes.
  static const Index MAX_DEPTH = 50;

  // Limit loop iterations since loops might be infinite. Since we are going to
  // replace the expression and must preserve side effects, we limit this to the
  // very first iteration because a side effect would be necessary to achieve
  // more than one iteration before becoming concrete.
  static const Index MAX_LOOP_ITERATIONS = 1;

public:
  PrecomputingExpressionRunner(Module* module,
                               const GetValues& getValues,
                               HeapValues& heapValues,
                               bool replaceExpression)
    : ConstantExpressionRunner<PrecomputingExpressionRunner>(
        module,
        replaceExpression ? FlagValues::PRESERVE_SIDEEFFECTS
                          : FlagValues::DEFAULT,
        MAX_DEPTH,
        MAX_LOOP_ITERATIONS),
      getValues(getValues), heapValues(heapValues) {}

  Flow visitLocalGet(LocalGet* curr) {
    auto iter = getValues.find(curr);
    if (iter != getValues.end()) {
      auto values = iter->second;
      assert(values.isConcrete());
      return Flow(values);
    }
    return ConstantExpressionRunner<
      PrecomputingExpressionRunner>::visitLocalGet(curr);
  }

  // TODO: Use immutability for values
  Flow visitStructNew(StructNew* curr) {
    return getGCAllocation(curr, [&]() { return Super::visitStructNew(curr); });
  }
  Flow visitStructSet(StructSet* curr) { return Flow(NONCONSTANT_FLOW); }
  Flow visitStructGet(StructGet* curr) {
    if (curr->ref->type == Type::unreachable || curr->ref->type.isNull()) {
      return Flow(NONCONSTANT_FLOW);
    }
    switch (curr->order) {
      case MemoryOrder::Unordered:
        // This can always be precomputed.
        break;
      case MemoryOrder::SeqCst:
        // This can never be precomputed away because it synchronizes with other
        // threads.
        return Flow(NONCONSTANT_FLOW);
      case MemoryOrder::AcqRel:
        // This synchronizes only with writes to the same data, so it can still
        // be precomputed if the data is not shared with other threads.
        if (curr->ref->type.getHeapType().isShared()) {
          return Flow(NONCONSTANT_FLOW);
        }
        break;
    }
    // If this field is immutable then we may be able to precompute this, as
    // if we also created the data in this function (or it was created in an
    // immutable global) then we know the value in the field. If it is
    // immutable, call the super method which will do the rest here. That
    // includes checking for the data being properly created, as if it was
    // not then we will not have a constant value for it, which means the
    // local.get of that value will stop us.
    auto& field = curr->ref->type.getHeapType().getStruct().fields[curr->index];
    if (field.mutable_ == Mutable) {
      return Flow(NONCONSTANT_FLOW);
    }
    return Super::visitStructGet(curr);
  }
  Flow visitArrayNew(ArrayNew* curr) {
    return getGCAllocation(curr, [&]() { return Super::visitArrayNew(curr); });
  }
  Flow visitArrayNewFixed(ArrayNewFixed* curr) {
    return getGCAllocation(curr,
                           [&]() { return Super::visitArrayNewFixed(curr); });
  }
  Flow visitArraySet(ArraySet* curr) { return Flow(NONCONSTANT_FLOW); }
  Flow visitArrayGet(ArrayGet* curr) {
    if (curr->ref->type != Type::unreachable && !curr->ref->type.isNull()) {
      // See above with struct.get
      auto element = curr->ref->type.getHeapType().getArray().element;
      if (element.mutable_ == Immutable) {
        return Super::visitArrayGet(curr);
      }
    }

    // Otherwise, we've failed to precompute.
    return Flow(NONCONSTANT_FLOW);
  }
  // ArrayLen is not disallowed here as it is an immutable property.
  Flow visitArrayCopy(ArrayCopy* curr) { return Flow(NONCONSTANT_FLOW); }

  // Generates heap info for a heap-allocating expression.
  Flow getGCAllocation(Expression* curr, std::function<Flow()> visitFunc) {
    // We must return a literal that refers to the canonical location for this
    // source expression, so that each time we compute a specific *.new then
    // we get the same identity.
    auto iter = heapValues.map.find(curr);
    if (iter != heapValues.map.end()) {
      auto& [data, hasEffects] = iter->second;
      if (hasEffects) {
        // Visit, so we recompute the effects. (This is rare, see comment
        // above.)
        auto flow = visitFunc();
        // Also check the result of the effects - if it is non-constant, we
        // cannot use it. (This can happen during propagation, when we see that
        // other inputs exist to something we depend on.)
        if (flow.breaking()) {
          return flow;
        }
      }
      // Refer to the same canonical GCData that we already created.
      return Literal(data, curr->type.getHeapType());
    }
    // Only call the visitor function here, so we do it once per allocation. See
    // if we have effects while doing so.
    auto flow = visitFunc();
    if (flow.breaking()) {
      return flow;
    }
    heapValues.map[curr] =
      HeapValues::Entry{flow.getSingleValue().getGCData(), hasEffectfulSets()};
    return flow;
  }

  Flow visitStringNew(StringNew* curr) {
    if (curr->op != StringNewWTF16Array) {
      // TODO: handle other string ops. For now we focus on JS-like strings.
      return Flow(NONCONSTANT_FLOW);
    }

    // string.new_wtf16_array is effectively an Array read operation, so
    // we cannot optimize mutable arrays. Unfortunately, it is only valid with
    // mutable arrays, so we cannot generally precompute it. As a special
    // exception, we can precompute if the child is an array allocation because
    // then we know the allocation will not escape anywhere else.
    auto refType = curr->ref->type;
    if (refType.isRef() &&
        (curr->ref->is<ArrayNew>() || curr->ref->is<ArrayNewData>() ||
         curr->ref->is<ArrayNewFixed>())) {
      return Super::visitStringNew(curr);
    }

    // TODO: Handle more general cases as well.
    return Flow(NONCONSTANT_FLOW);
  }

  Flow visitStringEncode(StringEncode* curr) {
    // string.encode_wtf16_array is effectively an Array write operation, so
    // just like ArraySet and ArrayCopy above we must mark it as disallowed
    // (due to side effects). (And we do not support other operations than
    // string.encode_wtf16_array anyhow.)
    return Flow(NONCONSTANT_FLOW);
  }
};

struct Precompute
  : public WalkerPass<
      PostWalker<Precompute, UnifiedExpressionVisitor<Precompute>>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Precompute>(propagate);
  }

  bool propagate = false;

  Precompute(bool propagate) : propagate(propagate) {}

  GetValues getValues;
  HeapValues heapValues;

  bool canPartiallyPrecompute;

  void doWalkFunction(Function* func) {
    // Perform partial precomputing only when the optimization level is non-
    // trivial, as it is slower and less likely to help.
    canPartiallyPrecompute = getPassOptions().optimizeLevel >= 2;

    // Walk the function and precompute things.
    Super::doWalkFunction(func);
    partiallyPrecompute(func);
    if (!propagate) {
      return;
    }
    // When propagating, we can utilize the graph of local operations to
    // precompute the values from a local.set to a local.get. This populates
    // getValues which is then used by a subsequent walk that applies those
    // values.
    bool propagated = propagateLocals(func);
    if (propagated) {
      // We found constants to propagate and entered them in getValues. Do
      // another walk to apply them and perhaps other optimizations that are
      // unlocked.
      Super::doWalkFunction(func);
      // We could also try to partially precompute again, but that is a somewhat
      // heavy operation, so we only do it the first time, and leave such things
      // for later runs of this pass and for --converge.
    }
    // Note that in principle even more cycles could find further work here, in
    // very rare cases. To avoid constructing a LocalGraph again just for that
    // unlikely chance, we leave such things for later.
  }

  void visitExpression(Expression* curr) {
    // Ignore trivial things like constants, nops, local/global.set (which have
    // an effect we cannot remove, and it is simpler to ignore them here than
    // later below), return (which we cannot improve), and loop (which it is
    // simpler to leave for other passes).
    if (Properties::isConstantExpression(curr) || curr->is<Nop>() ||
        curr->is<LocalSet>() || curr->is<GlobalSet>() || curr->is<Return>() ||
        curr->is<Loop>()) {
      return;
    }
    // Breaks with conditions can be simplified, but unconditional ones are like
    // returns, and we cannot improve.
    if (auto* br = curr->dynCast<Break>()) {
      if (!br->condition) {
        return;
      }
    }

    // See if we can precompute the value that flows out. We set
    // |replaceExpression| to false because we do not necessarily want to
    // replace it entirely, see below - we may keep parts, in some cases, if we
    // can still simplify it to a precomputed value.
    Flow flow;
    PrecomputingExpressionRunner runner(
      getModule(), getValues, heapValues, false /* replaceExpression */);
    try {
      flow = runner.visit(curr);
    } catch (NonconstantException&) {
      return;
    }
    // The resulting value must be of a type we can emit a constant for (or
    // there must be no value at all, in which case the value is a nop).
    if (!canEmitConstantFor(flow.values)) {
      return;
    }
    if (flow.breakTo == NONCONSTANT_FLOW) {
      // This cannot be turned into a constant, but perhaps we can partially
      // precompute it.
      considerPartiallyPrecomputing(curr);
      return;
    }
    // TODO: Handle suspends somehow?
    if (flow.suspendTag) {
      return;
    }

    // This looks like a promising precomputation: We have found that its value,
    // if any, can be emitted as a constant (or there is no value, and it is a
    // nop or break etc.). Build that value, so we can replace the expression
    // with it.
    Builder builder(*getModule());
    Expression* value = nullptr;
    if (flow.values.isConcrete()) {
      value = flow.getConstExpression(*getModule());
    }
    if (flow.breaking()) {
      if (flow.breakTo == RETURN_FLOW) {
        // We avoided trivial returns earlier (by doing so, we avoid wasted
        // work replacing a return with itself).
        assert(!curr->is<Return>());
        value = builder.makeReturn(value);
      } else {
        value = builder.makeBreak(flow.breakTo, value);
      }
      // Note we don't need to handle RETURN_CALL_FLOW, as the call there has
      // effects that would stop us earlier.
    }

    // We have something to replace the expression. While precomputing the
    // expression, we verified it has no effects that cause problems - no traps
    // or exceptions etc., as those things would lead to NONCONSTANT_FLOW. We
    // can therefore replace this with what flows out of it. The only exception
    // is that we set replaceExpression to false, above, which means we run the
    // interpreter without PRESERVE_SIDEEFFECTS. That allows local and global
    // sets to happen (to help optimize small code fragments with sets and
    // gets). To handle that, keep relevant children if we have such sets.
    if (runner.hasEffectfulSets()) {
      if (curr->is<Block>() || curr->is<If>() || curr->is<Try>()) {
        // These control flow structures have children that might not execute.
        // We know that some of the children have effectful sets, but not which,
        // and we can't just keep them all, so give up.
        // TODO: Check if this would be useful to improve, but other passes
        //       might do enough already.
        return;
      }

      // To keep things simple, stop here if we are precomputing to a break/
      // return. Handling that case requires ordering considerations:
      //
      //  (foo
      //    (br)
      //    (call)
      //  )
      //
      // Here we know we need to keep the call, and can remove foo, but this
      // would be wrong:
      //
      //  (block
      //    ;; removed br
      //    (call)
      //    (br) ;; the value we precompute to, added at the end
      //  )
      //
      // Instead we must keep the br, leaving this for later opts to improve:
      //
      //  (block
      //    (br)
      //    (call)
      //    (br)
      //  )
      //
      // That is, we cannot remove unneeded children easily in this case, where
      // control flow might transfer, so we need to keep all children when we
      // remove foo. In that case, it's not clear we are helping much, and other
      // passes can do better with the break/return anyhow. After dismissing
      // this situation, we know no transfer of control flow needs to be handled
      // in the code below (because we executed the code, and found it did not
      // do so).
      if (flow.breaking()) {
        return;
      }

      // Find the necessary children that we must keep.
      SmallVector<Expression*, 10> kept;
      for (auto* child : ChildIterator(curr)) {
        EffectAnalyzer effects(getPassOptions(), *getModule(), child);
        if (!effects.localsWritten.empty() || !effects.globalsWritten.empty()) {
          kept.push_back(builder.makeDrop(child));
        }
      }
      // Find all the things we must keep, which might include |value|.
      if (!kept.empty()) {
        if (value) {
          kept.push_back(value);
        }
        if (kept.size() == 1) {
          value = kept[0];
        } else {
          // We are returning a block with some kept children + some value. This
          // may seem to increase code size in some cases, but it cannot do so
          // monotonically: while doing all this we are definitely removing
          // |curr| itself, so we are making progress, even if we emit a new
          // constant that we weren't before. That is, we are not in this
          // situation:
          //
          //   (foo A B) => (block (foo A B) (value))
          //
          // We are in this one:
          //
          //   (foo A B) => (block A B (value))
          //
          // where foo vanishes.
          value = builder.makeBlock(kept);
        }
      }
    }
    if (!value) {
      // We don't need to replace this with anything: there is no value or other
      // code that we need. Just nop it.
      ExpressionManipulator::nop(curr);
      return;
    }
    replaceCurrent(value);
  }

  void visitBlock(Block* curr) {
    // When block precomputation fails, it can lead to quadratic slowness due to
    // the "tower of blocks" pattern used to implement switches:
    //
    //  (block
    //    (block
    //      ...
    //        (block
    //          (br_table ..
    //
    // If we try to precompute each block here, and fail on each, then we end up
    // doing quadratic work. This is also wasted work as once a nested block
    // fails to precompute there is not really a chance to succeed on the
    // parent. If we do *not* fail to precompute, however, then we do want to
    // precompute such nested blocks, e.g.:
    //
    //  (block $out
    //    (block
    //      (br $out)
    //    )
    //  )
    //
    // Here we *can* precompute the inner block, so when we get to the outer one
    // we see this:
    //
    //  (block $out
    //    (br $out)
    //  )
    //
    // And that precomputes to nothing. Therefore when we see a child of the
    // block that is another block (it failed to precompute to something
    // simpler) then we leave early here.
    //
    // Note that in theory we could still precompute here if wasm had
    // instructions that allow such things, e.g.:
    //
    //  (block $out
    //    (block
    //      (cause side effect1)
    //      (cause side effect2)
    //    )
    //    (undo those side effects exactly)
    //  )
    //
    // We are forced to invent a side effect that we can precisely undo (unlike,
    // say locals - a local.set would persist outside of the block, and even if
    // we did another set to the original value, this pass doesn't track values
    // that way). Only with that can we make the inner block un-precomputable
    // (because there are side effects) but the outer one is (because those
    // effects are undone). Note that it is critical that we have two things in
    // the block, so that we can't precompute it to one of them (which is what
    // we did to the br in the previous example). Note also that this is still
    // optimizable using other passes, as merge-blocks will fold the two blocks
    // together.
    if (!curr->list.empty() && curr->list[0]->is<Block>()) {
      // The first child is a block, that is, it could not be simplified, so
      // this looks like the "tower of blocks" pattern. Avoid quadratic time
      // here as explained above. (We could also look at other children of the
      // block, but the only real-world pattern identified so far is on the
      // first child, so keep things simple here.)
      return;
    }

    // Otherwise, precompute normally like all other expressions.
    visitExpression(curr);
  }

  // If we failed to precompute a constant, perhaps we can still precompute part
  // of an expression. Specifically, consider this case:
  //
  //  (A
  //    (select
  //      (B)
  //      (C)
  //      (condition)
  //    )
  //  )
  //
  // Perhaps we can compute A(B) and A(C). If so, we can emit a better select:
  //
  //  (select
  //    (constant result of A(B))
  //    (constant result of A(C))
  //    (condition)
  //  )
  //
  // Note that in general for code size we want to move operations *out* of
  // selects and ifs (OptimizeInstructions does that), but here we are
  // computing two constants which replace three expressions, so it is
  // worthwhile.
  //
  // To do such partial precomputing, in the main pass we note selects that look
  // promising. If we find any then we do a second pass later just for that (as
  // doing so requires walking up the stack in a manner that we want to avoid in
  // the main pass for overhead reasons; see below).
  //
  // Note that selects are all we really need here: Other passes would turn an
  // if into a select if the arms are simple enough, and only in those cases
  // (simple arms) do we have a chance at partially precomputing. For example,
  // if an arm is a constant then we can, but if it is a call then we can't.)
  // However, there are cases like an if with arms with side effects that end in
  // precomputable things, that are missed atm TODO
  std::unordered_set<Select*> partiallyPrecomputable;

  void considerPartiallyPrecomputing(Expression* curr) {
    if (!canPartiallyPrecompute) {
      return;
    }

    if (auto* select = curr->dynCast<Select>()) {
      // We only have a reasonable hope of success if the select arms are things
      // like constants or global gets. At a first approximation, allow the set
      // of things we allow in constant initializers (but we can probably allow
      // more here TODO).
      //
      // We also ignore selects with no parent (that are the entire function
      // body) as then there is nothing to optimize into their arms.
      auto& wasm = *getModule();
      if (Properties::isValidConstantExpression(wasm, select->ifTrue) &&
          Properties::isValidConstantExpression(wasm, select->ifFalse) &&
          getFunction()->body != select) {
        partiallyPrecomputable.insert(select);
      }
    }
  }

  // To partially precompute selects we walk up the stack from them, like this:
  //
  //  (A
  //    (B
  //      (select
  //        (C)
  //        (D)
  //        (condition)
  //      )
  //    )
  //  )
  //
  // First we try to apply B to C and D. If that works, we arrive at this:
  //
  //  (A
  //    (select
  //      (constant result of B(C))
  //      (constant result of B(D))
  //      (condition)
  //    )
  //  )
  //
  // We can then proceed to perhaps apply A. However, even if we failed to apply
  // B then we can try to apply A and B together, because that combination may
  // succeed where incremental work fails, for example:
  //
  //  (global $C
  //    (struct.new    ;; outer
  //      (struct.new  ;; inner
  //        (i32.const 10)
  //      )
  //    )
  //  )
  //
  //  (struct.get    ;; outer
  //    (struct.get  ;; inner
  //      (select
  //        (global.get $C)
  //        (global.get $D)
  //        (condition)
  //      )
  //    )
  //  )
  //
  // Applying the inner struct.get to $C leads us to the inner struct.new, but
  // that is an interior pointer in the global - it is not something we can
  // refer to using a global.get, so precomputing it fails. However, when we
  // apply both struct.gets at once we arrive at the outer struct.new, which is
  // in fact the global $C, and we succeed.
  void partiallyPrecompute(Function* func) {
    if (!canPartiallyPrecompute || partiallyPrecomputable.empty()) {
      // Nothing to do.
      return;
    }

    // Walk the function to find the parent stacks of the promising selects. We
    // copy the stacks and process them later. We do it like this because if we
    // wanted to process stacks as we reached them then we'd trip over
    // ourselves: when we optimize we replace a parent, but that parent is an
    // expression we'll reach later in the walk, so modifying it is unsafe.
    struct StackFinder : public ExpressionStackWalker<StackFinder> {
      Precompute& parent;

      StackFinder(Precompute& parent) : parent(parent) {}

      // We will later iterate on this in the order of insertion, which keeps
      // things deterministic, and also usually lets us do consecutive work
      // like a select nested in another select's condition, simply because we
      // will traverse the selects in postorder (however, because we cannot
      // always succeed in an incremental manner - see the comment on this
      // function - it is possible in theory that some work can happen only in a
      // later execution of the pass).
      InsertOrderedMap<Select*, ExpressionStack> stackMap;

      void visitSelect(Select* curr) {
        if (parent.partiallyPrecomputable.count(curr)) {
          stackMap[curr] = expressionStack;
        }
      }
    } stackFinder(*this);
    stackFinder.walkFunction(func);

    // Note which expressions we've modified as we go, as it is invalid to
    // modify more than once. This could happen in theory in a situation like
    // this:
    //
    //  (ternary.f32.max  ;; fictional instruction for explanatory purposes
    //    (select ..)
    //    (select ..)
    //    (f32.infinity)
    //  )
    //
    // When we consider the first select we can see that the computation result
    // is always infinity, so we can optimize here and replace the ternary. Then
    // the same thing happens with the second select, causing the ternary to be
    // replaced again, which is unsafe because it no longer exists after we
    // precomputed it the first time. (Note that in this example the result is
    // the same either way, but at least in theory an instruction could exist
    // for whom there was a difference.) In practice it does not seem that wasm
    // has instructions capable of this atm but this code is still useful to
    // guard against future problems, and as a minor speedup (quickly skip code
    // if it was already modified).
    std::unordered_set<Expression*> modified;

    for (auto& [select, stack] : stackFinder.stackMap) {
      // Each stack ends in the select itself, and contains more than the select
      // itself (otherwise we'd have ignored the select), i.e., the select has a
      // parent that we can try to optimize into the arms.
      assert(stack.back() == select);
      assert(stack.size() >= 2);
      Index selectIndex = stack.size() - 1;
      assert(selectIndex >= 1);

      if (modified.count(select)) {
        // This select was modified; go to the next one.
        continue;
      }

      // Go up through the parents, until we can't do any more work. At each
      // parent we'll try to execute it and all intermediate parents into the
      // select arms.
      for (Index parentIndex = selectIndex - 1; parentIndex != Index(-1);
           parentIndex--) {
        auto* parent = stack[parentIndex];
        if (modified.count(parent)) {
          // This parent was modified; exit the loop on parents as no upper
          // parent is valid to try either.
          break;
        }

        // If the parent lacks a concrete type then we can't move it into the
        // select: the select needs a concrete (and non-tuple) type. For example
        // if the parent is a drop or is unreachable, those are things we don't
        // want to handle, and we stop here (once we see one such parent we
        // can't expect to make any more progress).
        if (!parent->type.isConcrete() || parent->type.isTuple()) {
          break;
        }

        // We are precomputing the select arms, but leaving the condition as-is.
        // If the condition breaks to the parent, then we can't move the parent
        // into the select arms:
        //
        //  (block $name ;; this must stay outside of the select
        //    (select
        //      (B)
        //      (C)
        //      (block ;; condition
        //        (br_if $target
        //
        // Ignore all control flow for simplicity, as they aren't interesting
        // for us, and other passes should have removed them anyhow.
        if (Properties::isControlFlowStructure(parent)) {
          break;
        }

        // This looks promising, so try to precompute here. What we do is
        // precompute twice, once with the select replaced with the left arm,
        // and once with the right. If both succeed then we can create a new
        // select (with the same condition as before) whose arms are the
        // precomputed values.
        auto isValidPrecomputation = [&](const Flow& flow) {
          // For now we handle simple concrete values. We could also handle
          // breaks in principle TODO
          return canEmitConstantFor(flow.values) && !flow.breaking() &&
                 flow.values.isConcrete();
        };

        // Find the pointer to the select in its immediate parent so that we can
        // replace it first with one arm and then the other.
        auto** pointerToSelect =
          getChildPointerInImmediateParent(stack, selectIndex, func);
        *pointerToSelect = select->ifTrue;
        // When we perform these speculative precomputations, we must not use
        // the normal heapValues, as we are testing modified versions of
        // |parent|. Results here must not be cached for later.
        HeapValues temp;
        auto ifTrue = precomputeExpression(parent, true, &temp);
        temp.map.clear();
        if (isValidPrecomputation(ifTrue)) {
          *pointerToSelect = select->ifFalse;
          auto ifFalse = precomputeExpression(parent, true, &temp);
          if (isValidPrecomputation(ifFalse)) {
            // Wonderful, we can precompute here! The select can now contain the
            // computed values in its arms.
            select->ifTrue = ifTrue.getConstExpression(*getModule());
            select->ifFalse = ifFalse.getConstExpression(*getModule());
            select->finalize();

            // The parent of the select is now replaced by the select.
            auto** pointerToParent =
              getChildPointerInImmediateParent(stack, parentIndex, func);
            *pointerToParent = select;

            // Update state for further iterations: Mark everything modified and
            // move the select to the parent's location.
            for (Index i = parentIndex; i <= selectIndex; i++) {
              modified.insert(stack[i]);
            }
            selectIndex = parentIndex;
            stack[selectIndex] = select;
            stack.resize(selectIndex + 1);
          }
        }

        // Whether we succeeded to precompute here or not, restore the parent's
        // pointer to its original state (if we precomputed, the parent is no
        // longer in use, but there is no harm in modifying it).
        *pointerToSelect = select;
      }
    }
  }

  void visitFunction(Function* curr) {
    // removing breaks can alter types
    ReFinalize().walkFunctionInModule(curr, getModule());
  }

private:
  // Precompute an expression, returning a flow, which may be a constant
  // (that we can replace the expression with if replaceExpression is set). When
  // |usedHeapValues| is provided, we use those values instead of the normal
  // |heapValues| (that is, we do not use the normal heap value cache).
  Flow precomputeExpression(Expression* curr,
                            bool replaceExpression = true,
                            HeapValues* usedHeapValues = nullptr) {
    if (!usedHeapValues) {
      usedHeapValues = &heapValues;
    }
    Flow flow;
    try {
      flow = PrecomputingExpressionRunner(
               getModule(), getValues, *usedHeapValues, replaceExpression)
               .visit(curr);
    } catch (NonconstantException&) {
      return Flow(NONCONSTANT_FLOW);
    }
    // If we are replacing the expression, then the resulting value must be of
    // a type we can emit a constant for.
    if (!flow.breaking() && replaceExpression &&
        !canEmitConstantFor(flow.values)) {
      return Flow(NONCONSTANT_FLOW);
    }
    return flow;
  }

  // Precomputes the value of an expression, as opposed to the expression
  // itself. This differs from precomputeExpression in that we care about
  // the value the expression will have, which we cannot necessary replace
  // the expression with. For example,
  //  (local.tee (i32.const 1))
  // will have value 1 which we can optimize here, but in precomputeExpression
  // we could not do anything.
  Literals precomputeValue(Expression* curr) {
    // Note that we set replaceExpression to false, as we just care about
    // the value here.
    Flow flow = precomputeExpression(curr, false /* replaceExpression */);
    if (flow.breaking()) {
      return {};
    }
    return flow.values;
  }

  // Propagates values around. Returns whether we propagated.
  bool propagateLocals(Function* func) {
    bool propagated = false;

    // Using the graph of get-set interactions, do a constant-propagation type
    // operation: note which sets are assigned locals, then see if that lets us
    // compute other sets as locals (since some of the gets they read may be
    // constant). We do this lazily as most locals do not end up with constant
    // values that we can propagate.
    LazyLocalGraph localGraph(func, getModule());

    // A map of sets to their constant values. If a set does not appear here
    // then it is not constant, like |getValues|.
    std::unordered_map<LocalSet*, Literals> setValues;

    // The work list, which will contain sets and gets that have just been
    // found to have a constant value. As we only add them to the list when they
    // are found to be constant, each can only be added once, and a simple
    // vector is enough here (which we can make a small vector to avoid any
    // allocation in small-enough functions).
    SmallVector<Expression*, 10> work;

    // Given a set, see if it has a constant value. If so, note that on
    // setValues and add to the work list.
    auto checkConstantSet = [&](LocalSet* set) {
      if (setValues.count(set)) {
        // Already known to be constant.
        return;
      }

      // Precompute the value. Note that this executes the code from scratch
      // each time we reach this point, and so we need to be careful about
      // repeating side effects if those side effects are expressed *in the
      // value*. A case where that can happen is GC data (each struct.new
      // creates a new, unique struct, even if the data is equal), and so
      // PrecomputingExpressionRunner has special logic to make sure that
      // reference identity is preserved properly.
      //
      // (Other side effects are fine; if an expression does a call and we
      // somehow know the entire expression precomputes to a 42, then we can
      // propagate that 42 along to the users, regardless of whatever the call
      // did globally.)
      auto values = precomputeValue(
        Properties::getFallthrough(set->value, getPassOptions(), *getModule()));

      // We precomputed the *fallthrough* value (which allows us to look through
      // some things that would otherwise block us). But in some cases, like a
      // ref.cast, the fallthrough value can have an incompatible type for the
      // entire expression, which would be invalid for us to propagate, e.g.:
      //
      //  (ref.cast (ref struct)
      //    (ref.null any)
      //  )
      //
      // In such a case the value cannot actually fall through. Ignore such
      // cases (which other optimizations can handle) by making sure that we
      // only propagate a valid subtype.
      if (values.isConcrete() &&
          Type::isSubType(values.getType(), set->value->type)) {
        setValues[set] = values;
        work.push_back(set);
      }
    };

    // The same, for a get.
    auto checkConstantGet = [&](LocalGet* get) {
      if (getValues.count(get)) {
        // Already known to be constant.
        return;
      }

      // For this get to have constant value, all sets must agree on a constant.
      Literals values;
      bool first = true;
      for (auto* set : localGraph.getSets(get)) {
        Literals curr;
        if (set == nullptr) {
          if (getFunction()->isVar(get->index)) {
            auto localType = getFunction()->getLocalType(get->index);
            if (!localType.isDefaultable()) {
              // This is a nondefaultable local that seems to read the default
              // value at the function entry. This is either an internal error
              // or a case of unreachable code; the latter is possible as
              // LocalGraph is not precise in unreachable code. Give up.
              return;
            } else {
              curr = Literal::makeZeros(localType);
            }
          } else {
            // It's a param, so the value is non-constant. Give up.
            return;
          }
        } else {
          // If there is an entry for the set, use that constant. Otherwise, the
          // set is not constant, and we give up.
          auto iter = setValues.find(set);
          if (iter == setValues.end()) {
            return;
          }
          curr = iter->second;
        }

        // We found a concrete value, so there is a chance, if it matches all
        // the rest.
        assert(curr.isConcrete());
        if (first) {
          // This is the first ever value we see. All later ones must match it.
          values = curr;
          first = false;
        } else if (values != curr) {
          // This later value is not the same as before, give up.
          return;
        }
      }

      if (values.isConcrete()) {
        // We found a constant value!
        getValues[get] = values;
        work.push_back(get);
        propagated = true;
      } else {
        // If it is not concrete then, since we early-exited before on any
        // possible problem, there must be no sets for this get, which means it
        // is in unreachable code. In that case, we never switched |first| from
        // true to false.
        assert(first == true);
        // We could optimize using unreachability here, but we leave that for
        // other passes.
      }
    };

    // Check all gets and sets to find which are constant, mark them as such,
    // and add propagation work based on that.
    for (auto& [curr, _] : localGraph.getLocations()) {
      if (auto* set = curr->dynCast<LocalSet>()) {
        checkConstantSet(set);
      } else {
        checkConstantGet(curr->cast<LocalGet>());
      }
    }

    // Propagate constant values while work remains.
    while (!work.empty()) {
      auto* curr = work.back();
      work.pop_back();

      // This get or set is a constant value. Check if the things it influences
      // become constant.
      if (auto* set = curr->dynCast<LocalSet>()) {
        for (auto* get : localGraph.getSetInfluences(set)) {
          checkConstantGet(get);
        }
      } else {
        auto* get = curr->cast<LocalGet>();
        for (auto* set : localGraph.getGetInfluences(get)) {
          checkConstantSet(set);
        }
      }
    }

    return propagated;
  }

  bool canEmitConstantFor(const Literals& values) {
    for (auto& value : values) {
      if (!canEmitConstantFor(value)) {
        return false;
      }
    }
    return true;
  }

  bool canEmitConstantFor(const Literal& value) {
    // A null is fine to emit a constant for - we'll emit a RefNull. Otherwise,
    // see below about references to GC data.
    if (value.isNull()) {
      return true;
    }

    auto type = value.type;
    // A function is fine to emit a constant for - we'll emit a RefFunc, which
    // is compact and immutable, so there can't be a problem.
    if (type.isFunction()) {
      return true;
    }
    // We can emit a StringConst for a string constant if the string is a
    // UTF-16 string.
    if (type.isString()) {
      return isValidUTF16Literal(value);
    }
    // All other reference types cannot be precomputed. Even an immutable GC
    // reference is not currently something this pass can handle, as it will
    // evaluate and reevaluate code multiple times in e.g. propagateLocals, see
    // the comment above.
    if (type.isRef()) {
      return false;
    }

    return true;
  }

  // TODO: move this logic to src/support/string, and refactor to share code
  // with wasm/literal.cpp string printing's conversion from a Literal to a raw
  // string.
  bool isValidUTF16Literal(const Literal& value) {
    bool expectLowSurrogate = false;
    for (auto& v : value.getGCData()->values) {
      auto c = v.getInteger();
      if (c >= 0xDC00 && c <= 0xDFFF) {
        if (expectLowSurrogate) {
          expectLowSurrogate = false;
          continue;
        }
        // We got a low surrogate but weren't expecting one.
        return false;
      }
      if (expectLowSurrogate) {
        // We are expecting a low surrogate but didn't get one.
        return false;
      }
      if (c >= 0xD800 && c <= 0xDBFF) {
        expectLowSurrogate = true;
      }
    }
    return !expectLowSurrogate;
  }

  // Helpers for partial precomputing.

  // Given a stack of expressions and the index of an expression in it, find
  // the pointer to that expression in the parent. This gives us a pointer that
  // allows us to replace the expression.
  Expression** getChildPointerInImmediateParent(const ExpressionStack& stack,
                                                Index index,
                                                Function* func) {
    if (index == 0) {
      // There is nothing above this expression, so the pointer referring to it
      // is the function's body.
      return &func->body;
    }

    auto* child = stack[index];
    auto childIterator = ChildIterator(stack[index - 1]);
    for (auto** currChild : childIterator.children) {
      if (*currChild == child) {
        return currChild;
      }
    }

    WASM_UNREACHABLE("child not found in parent");
  }
};

Pass* createPrecomputePass() { return new Precompute(false); }

Pass* createPrecomputePropagatePass() { return new Precompute(true); }

} // namespace wasm
