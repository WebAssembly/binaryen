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

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm-interpreter.h>
#include <ir/utils.h>
#include <ir/literal-utils.h>
#include <ir/local-graph.h>
#include <ir/manipulation.h>

namespace wasm {

static const Name NONSTANDALONE_FLOW("Binaryen|nonstandalone");

typedef std::unordered_map<GetLocal*, Literal> GetValues;

// Execute an expression by itself. Errors if we hit anything we need anything not in the expression itself standalone.
class StandaloneExpressionRunner : public ExpressionRunner<StandaloneExpressionRunner> {
  // map gets to constant values, if they are known to be constant
  GetValues& getValues;

public:
  StandaloneExpressionRunner(GetValues& getValues) : getValues(getValues) {}

  struct NonstandaloneException {}; // TODO: use a flow with a special name, as this is likely very slow

  Flow visitLoop(Loop* curr) {
    // loops might be infinite, so must be careful
    // but we can't tell if non-infinite, since we don't have state, so loops are just impossible to optimize for now
    return Flow(NONSTANDALONE_FLOW);
  }

  Flow visitCall(Call* curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitCallImport(CallImport* curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitCallIndirect(CallIndirect* curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitGetLocal(GetLocal *curr) {
    auto iter = getValues.find(curr);
    if (iter != getValues.end()) {
      auto value = iter->second;
      if (value.isConcrete()) {
        return Flow(value);
      }
    }
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitSetLocal(SetLocal *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitGetGlobal(GetGlobal *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitSetGlobal(SetGlobal *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitLoad(Load *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitStore(Store *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitAtomicRMW(AtomicRMW *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitAtomicCmpxchg(AtomicCmpxchg *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitAtomicWait(AtomicWait *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitAtomicWake(AtomicWake *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }
  Flow visitHost(Host *curr) {
    return Flow(NONSTANDALONE_FLOW);
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

  void doWalkFunction(Function* func) {
    // with extra effort, we can utilize the get-set graph to precompute
    // things that use locals that are known to be constant. otherwise,
    // we just look at what is immediately before us
    if (propagate) {
      optimizeLocals(func);
    }
    // do the main and final walk over everything
    super::doWalkFunction(func);
  }

  void visitExpression(Expression* curr) {
    // TODO: if get_local, only replace with a constant if we don't care about size...?
    if (curr->is<Const>() || curr->is<Nop>()) return;
    // try to evaluate this into a const
    Flow flow = precomputeFlow(curr);
    if (flow.breaking()) {
      if (flow.breakTo == NONSTANDALONE_FLOW) return;
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
    } else {
      ExpressionManipulator::nop(curr);
    }
  }

  void visitFunction(Function* curr) {
    // removing breaks can alter types
    ReFinalize().walkFunctionInModule(curr, getModule());
  }

private:
  Flow precomputeFlow(Expression* curr) {
    try {
      return StandaloneExpressionRunner(getValues).visit(curr);
    } catch (StandaloneExpressionRunner::NonstandaloneException& e) {
      return Flow(NONSTANDALONE_FLOW);
    }
  }

  Literal precomputeValue(Expression* curr) {
    Flow flow = precomputeFlow(curr);
    if (flow.breaking()) {
      return Literal();
    }
    return flow.value;
  }

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
            if (!value.bitwiseEqual(curr)) {
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

