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
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm-interpreter.h"
#include "wasm.h"

namespace wasm {

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
using HeapValues = std::unordered_map<Expression*, std::shared_ptr<GCData>>;

// Precomputes an expression. Errors if we hit anything that can't be
// precomputed. Inherits most of its functionality from
// ConstantExpressionRunner, which it shares with the C-API, but adds handling
// of GetValues computed during the precompute pass.
class PrecomputingExpressionRunner
  : public ConstantExpressionRunner<PrecomputingExpressionRunner> {

  using Super = ConstantExpressionRunner<PrecomputingExpressionRunner>;

  // Concrete values of gets computed during the pass, which the runner does not
  // know about since it only records values of sets it visits.
  GetValues& getValues;

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
                               GetValues& getValues,
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
      if (values.isConcrete()) {
        return Flow(values);
      }
    }
    return ConstantExpressionRunner<
      PrecomputingExpressionRunner>::visitLocalGet(curr);
  }

  // TODO: Use immutability for values
  Flow visitStructNew(StructNew* curr) {
    auto flow = Super::visitStructNew(curr);
    if (flow.breaking()) {
      return flow;
    }
    return getHeapCreationFlow(flow, curr);
  }
  Flow visitStructSet(StructSet* curr) { return Flow(NONCONSTANT_FLOW); }
  Flow visitStructGet(StructGet* curr) {
    if (curr->ref->type != Type::unreachable && !curr->ref->type.isNull()) {
      // If this field is immutable then we may be able to precompute this, as
      // if we also created the data in this function (or it was created in an
      // immutable global) then we know the value in the field. If it is
      // immutable, call the super method which will do the rest here. That
      // includes checking for the data being properly created, as if it was
      // not then we will not have a constant value for it, which means the
      // local.get of that value will stop us.
      auto& field =
        curr->ref->type.getHeapType().getStruct().fields[curr->index];
      if (field.mutable_ == Immutable) {
        return Super::visitStructGet(curr);
      }
    }

    // Otherwise, we've failed to precompute.
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitArrayNew(ArrayNew* curr) {
    auto flow = Super::visitArrayNew(curr);
    if (flow.breaking()) {
      return flow;
    }
    return getHeapCreationFlow(flow, curr);
  }
  Flow visitArrayNewFixed(ArrayNewFixed* curr) {
    auto flow = Super::visitArrayNewFixed(curr);
    if (flow.breaking()) {
      return flow;
    }
    return getHeapCreationFlow(flow, curr);
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
  template<typename T> Flow getHeapCreationFlow(Flow flow, T* curr) {
    // We must return a literal that refers to the canonical location for this
    // source expression, so that each time we compute a specific struct.new
    // we get the same identity.
    std::shared_ptr<GCData>& canonical = heapValues[curr];
    std::shared_ptr<GCData> newGCData = flow.getSingleValue().getGCData();
    if (!canonical) {
      canonical = std::make_shared<GCData>(*newGCData);
    } else {
      *canonical = *newGCData;
    }
    return Literal(canonical, curr->type.getHeapType());
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
    super::doWalkFunction(func);
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
      super::doWalkFunction(func);
      // We could also try to partially precompute again, but that is a somewhat
      // heavy operation, so we only do it the first time, and leave such things
      // for later runs of this pass and for --converge.
    }
    // Note that in principle even more cycles could find further work here, in
    // very rare cases. To avoid constructing a LocalGraph again just for that
    // unlikely chance, we leave such things for later.
  }

  template<typename T> void reuseConstantNode(T* curr, Flow flow) {
    if (flow.values.isConcrete()) {
      // reuse a const / ref.null / ref.func node if there is one
      if (curr->value && flow.values.size() == 1) {
        Literal singleValue = flow.getSingleValue();
        if (singleValue.type.isNumber()) {
          if (auto* c = curr->value->template dynCast<Const>()) {
            c->value = singleValue;
            c->finalize();
            curr->finalize();
            return;
          }
        } else if (singleValue.isNull()) {
          if (auto* n = curr->value->template dynCast<RefNull>()) {
            n->finalize(singleValue.type);
            curr->finalize();
            return;
          }
        } else if (singleValue.type.isRef() &&
                   singleValue.type.getHeapType() == HeapType::func) {
          if (auto* r = curr->value->template dynCast<RefFunc>()) {
            r->func = singleValue.getFunc();
            r->finalize();
            curr->finalize();
            return;
          }
        }
      }
      curr->value = flow.getConstExpression(*getModule());
    } else {
      curr->value = nullptr;
    }
    curr->finalize();
  }

  void visitExpression(Expression* curr) {
    // TODO: if local.get, only replace with a constant if we don't care about
    // size...?
    if (Properties::isConstantExpression(curr) || curr->is<Nop>()) {
      return;
    }
    // try to evaluate this into a const
    Flow flow = precomputeExpression(curr);
    if (!canEmitConstantFor(flow.values)) {
      return;
    }
    if (flow.breaking()) {
      if (flow.breakTo == NONCONSTANT_FLOW) {
        // This cannot be turned into a constant, but perhaps we can partially
        // precompute it.
        considerPartiallyPrecomputing(curr);
        return;
      }
      if (flow.breakTo == RETURN_FLOW) {
        // this expression causes a return. if it's already a return, reuse the
        // node
        if (auto* ret = curr->dynCast<Return>()) {
          reuseConstantNode(ret, flow);
        } else {
          Builder builder(*getModule());
          replaceCurrent(builder.makeReturn(
            flow.values.isConcrete() ? flow.getConstExpression(*getModule())
                                     : nullptr));
        }
        return;
      }
      // this expression causes a break, emit it directly. if it's already a br,
      // reuse the node.
      if (auto* br = curr->dynCast<Break>()) {
        br->name = flow.breakTo;
        br->condition = nullptr;
        reuseConstantNode(br, flow);
      } else {
        Builder builder(*getModule());
        replaceCurrent(builder.makeBreak(
          flow.breakTo,
          flow.values.isConcrete() ? flow.getConstExpression(*getModule())
                                   : nullptr));
      }
      return;
    }
    // this was precomputed
    if (flow.values.isConcrete()) {
      replaceCurrent(flow.getConstExpression(*getModule()));
    } else {
      ExpressionManipulator::nop(curr);
    }
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
        auto ifTrue = precomputeExpression(parent);
        if (isValidPrecomputation(ifTrue)) {
          *pointerToSelect = select->ifFalse;
          auto ifFalse = precomputeExpression(parent);
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
  // (that we can replace the expression with if replaceExpression is set).
  Flow precomputeExpression(Expression* curr, bool replaceExpression = true) {
    Flow flow;
    try {
      flow = PrecomputingExpressionRunner(
               getModule(), getValues, heapValues, replaceExpression)
               .visit(curr);
    } catch (PrecomputingExpressionRunner::NonconstantException&) {
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
    // using the graph of get-set interactions, do a constant-propagation type
    // operation: note which sets are assigned locals, then see if that lets us
    // compute other sets as locals (since some of the gets they read may be
    // constant).
    // compute all dependencies
    LocalGraph localGraph(func, getModule());
    localGraph.computeInfluences();
    // prepare the work list. we add things here that might change to a constant
    // initially, that means everything
    UniqueDeferredQueue<Expression*> work;
    for (auto& [curr, _] : localGraph.locations) {
      work.push(curr);
    }
    // the constant value, or none if not a constant
    std::unordered_map<LocalSet*, Literals> setValues;
    // propagate constant values
    while (!work.empty()) {
      auto* curr = work.pop();
      // see if this set or get is actually a constant value, and if so,
      // mark it as such and add everything it influences to the work list,
      // as they may be constant too.
      if (auto* set = curr->dynCast<LocalSet>()) {
        if (setValues[set].isConcrete()) {
          continue; // already known constant
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
        auto values = precomputeValue(Properties::getFallthrough(
          set->value, getPassOptions(), *getModule()));
        // Fix up the value. The computation we just did was to look at the
        // fallthrough, then precompute that; that looks through expressions
        // that pass through the value. Normally that does not matter here,
        // for example, (block .. (value)) returns the value unmodified.
        // However, some things change the type, for example RefAsNonNull has
        // a non-null type, while its input may be nullable. That does not
        // matter either, as if we managed to precompute it then the value had
        // the more specific (in this example, non-nullable) type. But there
        // is a situation where this can cause an issue: RefCast. An attempt to
        // perform a "bad" cast, say of a function to a struct, is a case where
        // the fallthrough value's type is very different than the actually
        // returned value's type. To handle that, if we precomputed a value and
        // if it has the wrong type then precompute it again without looking
        // through to the fallthrough.
        if (values.isConcrete() &&
            !Type::isSubType(values.getType(), set->value->type)) {
          values = precomputeValue(set->value);
        }
        setValues[set] = values;
        if (values.isConcrete()) {
          for (auto* get : localGraph.setInfluences[set]) {
            work.push(get);
          }
        }
      } else {
        auto* get = curr->cast<LocalGet>();
        if (getValues[get].size() >= 1) {
          continue; // already known constant
        }
        // for this get to have constant value, all sets must agree
        Literals values;
        bool first = true;
        for (auto* set : localGraph.getSetses[get]) {
          Literals curr;
          if (set == nullptr) {
            if (getFunction()->isVar(get->index)) {
              auto localType = getFunction()->getLocalType(get->index);
              if (!localType.isDefaultable()) {
                // This is a nondefaultable local that seems to read the default
                // value at the function entry. This is either an internal error
                // or a case of unreachable code; the latter is possible as
                // LocalGraph is not precise in unreachable code.
                //
                // We cannot set zeros here (as applying them, even in
                // unreachable code, would not validate), so just mark this as
                // a hopeless case to ignore.
                values = {};
              } else {
                curr = Literal::makeZeros(localType);
              }
            } else {
              // it's a param, so it's hopeless
              values = {};
              break;
            }
          } else {
            curr = setValues[set];
          }
          if (curr.isNone()) {
            // not a constant, give up
            values = {};
            break;
          }
          // we found a concrete value. compare with the current one
          if (first) {
            values = curr; // this is the first
            first = false;
          } else {
            if (values != curr) {
              // not the same, give up
              values = {};
              break;
            }
          }
        }
        // we may have found a value
        if (values.isConcrete()) {
          // we did!
          getValues[get] = values;
          for (auto* set : localGraph.getInfluences[get]) {
            work.push(set);
          }
          propagated = true;
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
    return canEmitConstantFor(value.type);
  }

  bool canEmitConstantFor(Type type) {
    // A function is fine to emit a constant for - we'll emit a RefFunc, which
    // is compact and immutable, so there can't be a problem.
    if (type.isFunction()) {
      return true;
    }
    // We can emit a StringConst for a string constant.
    if (type.isString()) {
      return true;
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
    for (auto** currChild : ChildIterator(stack[index - 1]).children) {
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
