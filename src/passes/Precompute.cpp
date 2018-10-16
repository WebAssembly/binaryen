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
// Computes code at compile time where possible.
//
// Possible nondeterminism: WebAssembly NaN signs are nondeterministic,
// and this pass may optimize e.g. a float 0 / 0 into +nan while a VM may
// emit -nan, which can be a noticeable difference if the bits are
// looked at.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm-interpreter.h>
#include <ir/utils.h>
#include <ir/literal-utils.h>
#include <ir/local-graph.h>
#include <ir/manipulation.h>

namespace wasm {

static const Name NOTPRECOMPUTABLE_FLOW("Binaryen|notprecomputable");

typedef std::unordered_map<GetLocal*, Literal> GetValues;

// Precomputes an expression. Errors if we hit anything that can't be precomputed.
class PrecomputingExpressionRunner : public ExpressionRunner<PrecomputingExpressionRunner> {
  Module* module;

  // map gets to constant values, if they are known to be constant
  GetValues& getValues;

  // Whether we are trying to precompute down to an expression (which we can do on
  // say 5 + 6) or to a value (which we can't do on a tee_local that flows a 7
  // through it). When we want to replace the expression, we can only do so
  // when it has no side effects. When we don't care about replacing the expression,
  // we just want to know if it will contain a known constant.
  bool replaceExpression;

public:
  PrecomputingExpressionRunner(Module* module, GetValues& getValues, bool replaceExpression) : module(module), getValues(getValues), replaceExpression(replaceExpression) {}

  struct NonstandaloneException {}; // TODO: use a flow with a special name, as this is likely very slow

  Flow visitLoop(Loop* curr) {
    // loops might be infinite, so must be careful
    // but we can't tell if non-infinite, since we don't have state, so loops are just impossible to optimize for now
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }

  Flow visitCall(Call* curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitCallIndirect(CallIndirect* curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitGetLocal(GetLocal *curr) {
    auto iter = getValues.find(curr);
    if (iter != getValues.end()) {
      auto value = iter->second;
      if (value.isConcrete()) {
        return Flow(value);
      }
    }
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitSetLocal(SetLocal *curr) {
    // If we don't need to replace the whole expression, see if there
    // is a value flowing through a tee.
    if (!replaceExpression) {
      if (isConcreteType(curr->type)) {
        assert(curr->isTee());
        return visit(curr->value);
      }
    }
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitGetGlobal(GetGlobal *curr) {
    auto* global = module->getGlobal(curr->name);
    if (!global->imported() && !global->mutable_) {
      return visit(global->init);
    }
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitSetGlobal(SetGlobal *curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitLoad(Load *curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitStore(Store *curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitAtomicRMW(AtomicRMW *curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitAtomicCmpxchg(AtomicCmpxchg *curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitAtomicWait(AtomicWait *curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitAtomicWake(AtomicWake *curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }
  Flow visitHost(Host *curr) {
    return Flow(NOTPRECOMPUTABLE_FLOW);
  }

  void trap(const char* why) override {
    throw NonstandaloneException();
  }
};

struct Precompute : public WalkerPass<PostWalker<Precompute, UnifiedExpressionVisitor<Precompute>>> {
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

  void visitExpression(Expression* curr) {
    // TODO: if get_local, only replace with a constant if we don't care about size...?
    if (curr->is<Const>() || curr->is<Nop>()) return;
    // try to evaluate this into a const
    Flow flow = precomputeExpression(curr);
    if (flow.breaking()) {
      if (flow.breakTo == NOTPRECOMPUTABLE_FLOW) return;
      if (flow.breakTo == RETURN_FLOW) {
        // this expression causes a return. if it's already a return, reuse the node
        if (auto* ret = curr->dynCast<Return>()) {
          if (flow.value.type != none) {
            // reuse a const value if there is one
            if (ret->value) {
              if (auto* value = ret->value->dynCast<Const>()) {
                value->value = flow.value;
                value->finalize();
                return;
              }
            }
            ret->value = Builder(*getModule()).makeConst(flow.value);
          } else {
            ret->value = nullptr;
          }
        } else {
          Builder builder(*getModule());
          replaceCurrent(builder.makeReturn(flow.value.type != none ? builder.makeConst(flow.value) : nullptr));
        }
        return;
      }
      // this expression causes a break, emit it directly. if it's already a br, reuse the node.
      if (auto* br = curr->dynCast<Break>()) {
        br->name = flow.breakTo;
        br->condition = nullptr;
        if (flow.value.type != none) {
          // reuse a const value if there is one
          if (br->value) {
            if (auto* value = br->value->dynCast<Const>()) {
              value->value = flow.value;
              value->finalize();
              br->finalize();
              return;
            }
          }
          br->value = Builder(*getModule()).makeConst(flow.value);
        } else {
          br->value = nullptr;
        }
        br->finalize();
      } else {
        Builder builder(*getModule());
        replaceCurrent(builder.makeBreak(flow.breakTo, flow.value.type != none ? builder.makeConst(flow.value) : nullptr));
      }
      return;
    }
    // this was precomputed
    if (isConcreteType(flow.value.type)) {
      replaceCurrent(Builder(*getModule()).makeConst(flow.value));
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
    try {
      return PrecomputingExpressionRunner(getModule(), getValues, replaceExpression).visit(curr);
    } catch (PrecomputingExpressionRunner::NonstandaloneException&) {
      return Flow(NOTPRECOMPUTABLE_FLOW);
    }
  }

  // Precomputes the value of an expression, as opposed to the expression
  // itself. This differs from precomputeExpression in that we care about
  // the value the expression will have, which we cannot necessary replace
  // the expression with. For example,
  //  (tee_local (i32.const 1))
  // will have value 1 which we can optimize here, but in precomputeExpression
  // we could not do anything.
  Literal precomputeValue(Expression* curr) {
    // Note that we set replaceExpression to false, as we just care about
    // the value here.
    Flow flow = precomputeExpression(curr, false /* replaceExpression */);
    if (flow.breaking()) {
      return Literal();
    }
    return flow.value;
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
    // prepare the work list. we add things here that might change to a constant
    // initially, that means everything
    std::unordered_set<Expression*> work;
    for (auto& pair : localGraph.locations) {
      auto* curr = pair.first;
      work.insert(curr);
    }
    std::unordered_map<SetLocal*, Literal> setValues; // the constant value, or none if not a constant
    // propagate constant values
    while (!work.empty()) {
      auto iter = work.begin();
      auto* curr = *iter;
      work.erase(iter);
      // see if this set or get is actually a constant value, and if so,
      // mark it as such and add everything it influences to the work list,
      // as they may be constant too.
      if (auto* set = curr->dynCast<SetLocal>()) {
        if (setValues[set].isConcrete()) continue; // already known constant
        auto value = setValues[set] = precomputeValue(set->value);
        if (value.isConcrete()) {
          for (auto* get : localGraph.setInfluences[set]) {
            work.insert(get);
          }
        }
      } else {
        auto* get = curr->cast<GetLocal>();
        if (getValues[get].isConcrete()) continue; // already known constant
        // for this get to have constant value, all sets must agree
        Literal value;
        bool first = true;
        for (auto* set : localGraph.getSetses[get]) {
          Literal curr;
          if (set == nullptr) {
            if (getFunction()->isVar(get->index)) {
              curr = LiteralUtils::makeLiteralZero(getFunction()->getLocalType(get->index));
            } else {
              // it's a param, so it's hopeless
              value = Literal();
              break;
            }
          } else {
            curr = setValues[set];
          }
          if (curr.isNull()) {
            // not a constant, give up
            value = Literal();
            break;
          }
          // we found a concrete value. compare with the current one
          if (first) {
            value = curr; // this is the first
            first = false;
          } else {
            if (value != curr) {
              // not the same, give up
              value = Literal();
              break;
            }
          }
        }
        // we may have found a value
        if (value.isConcrete()) {
          // we did!
          getValues[get] = value;
          for (auto* set : localGraph.getInfluences[get]) {
            work.insert(set);
          }
        }
      }
    }
  }
};

Pass *createPrecomputePass() {
  return new Precompute(false);
}

Pass *createPrecomputePropagatePass() {
  return new Precompute(true);
}

} // namespace wasm

