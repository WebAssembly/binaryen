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
#include <ast_utils.h>
#include "ast/manipulation.h"

namespace wasm {

static const Name NONSTANDALONE_FLOW("Binaryen|nonstandalone");

// Execute an expression by itself. Errors if we hit anything we need anything not in the expression itself standalone.
class StandaloneExpressionRunner : public ExpressionRunner<StandaloneExpressionRunner> {
public:
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
  Flow visitHost(Host *curr) {
    return Flow(NONSTANDALONE_FLOW);
  }

  void trap(const char* why) override {
    throw NonstandaloneException();
  }
};

struct Precompute : public WalkerPass<PostWalker<Precompute, UnifiedExpressionVisitor<Precompute>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Precompute; }

  void visitExpression(Expression* curr) {
    if (curr->is<Const>() || curr->is<Nop>()) return;
    // try to evaluate this into a const
    Flow flow;
    try {
      flow = StandaloneExpressionRunner().visit(curr);
    } catch (StandaloneExpressionRunner::NonstandaloneException& e) {
      return;
    }
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
        br->finalize(); // if we removed a condition, the type may change
        if (flow.value.type != none) {
          // reuse a const value if there is one
          if (br->value) {
            if (auto* value = br->value->dynCast<Const>()) {
              value->value = flow.value;
              return;
            }
          }
          br->value = Builder(*getModule()).makeConst(flow.value);
        } else {
          br->value = nullptr;
        }
      } else {
        Builder builder(*getModule());
        replaceCurrent(builder.makeBreak(flow.breakTo, flow.value.type != none ? builder.makeConst(flow.value) : nullptr));
      }
      return;
    }
    // this was precomputed
    if (isConcreteWasmType(flow.value.type)) {
      replaceCurrent(Builder(*getModule()).makeConst(flow.value));
    } else {
      ExpressionManipulator::nop(curr);
    }
  }

  void visitFunction(Function* curr) {
    // removing breaks can alter types
    ReFinalize().walkFunctionInModule(curr, getModule());
  }
};

Pass *createPrecomputePass() {
  return new Precompute();
}

} // namespace wasm

