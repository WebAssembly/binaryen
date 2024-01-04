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

#include "ir/effects.h"
#include "ir/iteration.h"
#include "ir/literal-utils.h"
#include "ir/local-graph.h"
#include "ir/manipulation.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
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
  Flow visitArrayLen(ArrayLen* curr) { return Flow(NONCONSTANT_FLOW); }
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

  void doWalkFunction(Function* func) {
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
      partiallyPrecompute(func);
    }
    // Note that in principle even more cycles could find further work here, in
    // very rare cases. To avoid constructing a LocalGraph again just for that
    // unlikely chance, we leave such things for later runs of this pass and for
    // --converge.
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
  //    (select
  //      (constant result of A(B))
  //      (constant result of A(C))
  //      (condition)
  //    )
  //  )
  //
  // Note that in general for code size we want to move operations *out* of
  // selects and ifs (OptimizeInstructions does that), but here we are
  // computing two constant which replace four expressions, so it is worthwhile.
  //
  // To do such partial precomputing, in the main pass we note selects that look
  // promising. If we find any then we do a second pass later just for that (as
  // doing so requires walking up the stack in a manner that we want to avoid in
  // main pass, for overhead reasons; see below).
  //
  // Note that selects are all we really need here: Other passes would turn an
  // if into a select if the arms are simple enough, and only in those cases
  // (simple arms) do we have a chance at partially precomputing. (For example,
  // if an arm is a constant then we can, but if it is a call then we can't.)
  std::unordered_set<Select*> partiallyPrecomputable;

  void considerPartiallyPrecomputing(Expression* curr) {
    if (auto* select = curr->dynCast<Select>()) {
      // We only have a reasonable hope of success if the select arms are things
      // like constants or global gets.
      auto isValid = [](Expression* arm) {
        // TODO: more?
        return arm->is<Const>() || arm->is<RefFunc>() || arm->is<GlobalGet>();
      };
      if (isValid(select->ifTrue) && isValid(select->ifFalse)) {
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
  // apply the outer struct.get we arrive at the outer struct.new, which is in
  // fact the global $C, and we succeed.
  void partiallyPrecompute(Function* func) {
    // Walk the function to find the parent stacks of the selects.
    struct StackFinder : public ExpressionStackWalker<StackFinder> {
      Precompute& parent;

      StackFinder(Precompute& parent) : parent(parent) {}

      std::unordered_map<Select*, ExpressionStack> stackMap;

      void visitSelect(Select* curr) {
        if (parent.partiallyPrecomputable.count(curr)) {
          if (expressionStack.size() == 1) {
            // There is nothing above this select, so nothing we can precompute
            // into it.
            return;
          }

          // Check if this is nested in another select, which is a case that for
          // simplicity we don't handle yet TODO
          for (auto* item : expressionStack) {
            if (item != curr && item->is<Select>()) {
              // This is another select in the middle somewhere; give up.
              return;
            }
          }

          // This select looks promising, note it and its stack.
          stackMap[curr] = expressionStack;
        }
      }
    } stackFinder(*this);
    stackFinder.walkFunction(func);

    // TODO determinism

    for (auto& [select, stack] : stackFinder.stackMap) {
      // Each stack ends in the select itself, and contains more than the select
      // itself.
      assert(stack.back() == select);
      assert(stack.size() >= 2);

      // Go up through the parents, until we can't do any more work.
      Index i = stack.size() - 2;
      while (1) {
        auto* parent = stack[i];
        if (!parent->type.isConcrete()) {
          // The parent does not have a concrete type, so we can't move it
          // into the select: the select needs a concrete type. (For example,
          // if the parent is a drop or is unreachable, those are things we
          // don't want to handle.) We stop here, as once we see one such
          // parent we can't expect to make any more progress.
          break;
        }

        // We are precomputing the select arms, but leaving the condition as-is.
        // If the condition breaks to the parent, then we can't move the parent
        // into the select arms:
        //
        //  (block $name ;; this must stack outside of the select
        //    (select
        //      (B)
        //      (C)
        //      (block ;; condition
        //        (br_if $target
        //
        // Ignore all control flow for simplicity, as they aren't interesting
        // for us (other passes remove them when possibly anyhow), and assume
        // we can't do anything else later.
        if (Properties::isControlFlowStructure(parent)) {
          break;
        }

        // Continue to the next parent, if there is one.
        if (i == 0) {
          break;
        }
        i--;
      }



    // We are looking for a single child which is a select.
    ChildIterator children(curr);
    if (children.getNumChildren() != 1) {
      return;
    }
    // TODO: maybe only do this if the select arms have depth 1? They must be
    //       constant, or global, for us to have any hope..? avoids N^2 too
    auto* select = children.getChild(0)->dynCast<Select>();
    if (!select) {
      return;
    }

    // This has the general shape, so do the more intensive work to see if it
    // can be optimized. First, exit early if there are any side effects that
    // would prevent us from optimizing. Specifically, we need to check the
    // operation outside the select and the select's arms, but not the select's
    // condition (which will remain as-is). We can also ignore trap side effects
    // as those will be handled in precomputeExpression below (if we trap, we'll
    // fail to precompute). TODO: We could also ignore exceptions, like traps,
    // if they are not actually thrown, if/when wasm gets throwing variants of
    // trapping operations.
    auto& options = getPassOptions();
    auto& wasm = *getModule();
    if (ShallowEffectAnalyzer(options, wasm, curr).hasNonTrapSideEffects() ||
        EffectAnalyzer(options, wasm, select->ifTrue).hasNonTrapSideEffects() ||
        EffectAnalyzer(options, wasm, select->ifFalse)
          .hasNonTrapSideEffects()) {
      return;
    }

    // Copy the entire expression. Then in the copy, replace the select with
    // each of its arms and precompute those.
    // TODO: must we copy? Can we not replace twice or thrice?
    auto* copy = ExpressionManipulator::copy(curr, *getModule());
    ChildIterator copyChildren(copy);
    copyChildren.getChild(0) = select->ifTrue;
    auto ifTrue = precomputeExpression(copy);
    if (!canEmitConstantFor(ifTrue.values) || !ifTrue.values.isConcrete()) {
      // We failed to precompute anything, or it is a break and not a value.
      // TODO: optimize breaks
      return;
    }
    copyChildren.getChild(0) = select->ifFalse;
    auto ifFalse = precomputeExpression(copy);
    if (!canEmitConstantFor(ifFalse.values) || !ifFalse.values.isConcrete()) {
      return;
    }

    // We precomputed them both successfully! Apply them.
    select->ifTrue = ifTrue.getConstExpression(*getModule());
    select->ifFalse = ifFalse.getConstExpression(*getModule());
    select->type = select->ifTrue->type;
    replaceCurrent(select);
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
};

Pass* createPrecomputePass() { return new Precompute(false); }

Pass* createPrecomputePropagatePass() { return new Precompute(true); }

} // namespace wasm
