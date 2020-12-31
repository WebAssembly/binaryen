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

#include <ir/literal-utils.h>
#include <ir/local-graph.h>
#include <ir/manipulation.h>
#include <ir/properties.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm-interpreter.h>
#include <wasm.h>

namespace wasm {

typedef std::unordered_map<LocalGet*, Literals> GetValues;

// Precomputes an expression. Errors if we hit anything that can't be
// precomputed. Inherits most of its functionality from
// ConstantExpressionRunner, which it shares with the C-API, but adds handling
// of GetValues computed during the precompute pass.
class PrecomputingExpressionRunner
  : public ConstantExpressionRunner<PrecomputingExpressionRunner> {

  // Concrete values of gets computed during the pass, which the runner does not
  // know about since it only records values of sets it visits.
  GetValues& getValues;

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
                               bool replaceExpression)
    : ConstantExpressionRunner<PrecomputingExpressionRunner>(
        module,
        replaceExpression ? FlagValues::PRESERVE_SIDEEFFECTS
                          : FlagValues::DEFAULT,
        MAX_DEPTH,
        MAX_LOOP_ITERATIONS),
      getValues(getValues) {}

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
};

struct Precompute
  : public WalkerPass<
      PostWalker<Precompute, UnifiedExpressionVisitor<Precompute>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Precompute(propagate); }

  bool propagate = false;

  Precompute(bool propagate) : propagate(propagate) {}

  GetValues getValues;

  bool worked;

  void doWalkFunction(Function* func) {
    // if propagating, we may need multiple rounds: each propagation can
    // lead to the main walk removing code, which might open up more
    // propagation opportunities
    do {
      getValues.clear();
      // with extra effort, we can utilize the get-set graph to precompute
      // things that use locals that are known to be constant. otherwise,
      // we just look at what is immediately before us
      if (propagate) {
        optimizeLocals(func);
      }
      // do the main walk over everything
      worked = false;
      super::doWalkFunction(func);
    } while (propagate && worked);
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
        } else if (singleValue.type == Type::funcref) {
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
    // Until engines implement v128.const and we have SIMD-aware optimizations
    // that can break large v128.const instructions into smaller consts and
    // splats, do not try to precompute v128 expressions.
    if (curr->type.isVector()) {
      return;
    }
    // try to evaluate this into a const
    Flow flow = precomputeExpression(curr);
    if (flow.getType().hasVector()) {
      return;
    }
    if (flow.breaking()) {
      if (flow.breakTo == NONCONSTANT_FLOW) {
        return;
      }
      if (!canEmitConstantFor(flow.values)) {
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
      worked = true;
    } else {
      ExpressionManipulator::nop(curr);
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
    if (!canEmitConstantFor(curr->type)) {
      return Flow(NONCONSTANT_FLOW);
    }
    try {
      return PrecomputingExpressionRunner(
               getModule(), getValues, replaceExpression)
        .visit(curr);
    } catch (PrecomputingExpressionRunner::NonconstantException&) {
      return Flow(NONCONSTANT_FLOW);
    }
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
  void optimizeLocals(Function* func) {
    // using the graph of get-set interactions, do a constant-propagation type
    // operation: note which sets are assigned locals, then see if that lets us
    // compute other sets as locals (since some of the gets they read may be
    // constant).
    // compute all dependencies
    LocalGraph localGraph(func);
    localGraph.computeInfluences();
    localGraph.computeSSAIndexes();
    // prepare the work list. we add things here that might change to a constant
    // initially, that means everything
    std::unordered_set<Expression*> work;
    for (auto& pair : localGraph.locations) {
      auto* curr = pair.first;
      work.insert(curr);
    }
    // the constant value, or none if not a constant
    std::unordered_map<LocalSet*, Literals> setValues;
    // propagate constant values
    while (!work.empty()) {
      auto iter = work.begin();
      auto* curr = *iter;
      work.erase(iter);
      // see if this set or get is actually a constant value, and if so,
      // mark it as such and add everything it influences to the work list,
      // as they may be constant too.
      if (auto* set = curr->dynCast<LocalSet>()) {
        if (setValues[set].isConcrete()) {
          continue; // already known constant
        }
        auto values = setValues[set] =
          precomputeValue(Properties::getFallthrough(
            set->value, getPassOptions(), getModule()->features));
        if (values.isConcrete()) {
          for (auto* get : localGraph.setInfluences[set]) {
            work.insert(get);
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
              curr =
                Literal::makeZeros(getFunction()->getLocalType(get->index));
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
            work.insert(set);
          }
        }
      }
    }
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
    // A function is fine to emit a constant for - we'll emit a RefFunc, which
    // is compact and immutable, so there can't be a problem.
    if (value.type.isFunction()) {
      return true;
    }
    return canEmitConstantFor(value.type);
  }

  bool canEmitConstantFor(Type type) {
    // Don't try to precompute a reference. We can't replace it with a constant
    // expression, as that would make a copy of it by value.
    // For now, don't try to precompute an Rtt. TODO figure out when that would
    // be safe and useful.
    return !type.isRef() && !type.isRtt();
  }
};

Pass* createPrecomputePass() { return new Precompute(false); }

Pass* createPrecomputePropagatePass() { return new Precompute(true); }

} // namespace wasm
