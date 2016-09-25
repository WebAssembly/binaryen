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

namespace wasm {

Name NONSTANDALONE("Binaryen|nonstandalone");

// Execute an expression by itself. Errors if we hit anything we need anything not in the expression itself standalone.
class StandaloneExpressionRunner : public ExpressionRunner<StandaloneExpressionRunner> {
public:
  struct NonstandaloneException {}; // TODO: use a flow with a special name, as this is likely very slow

  Flow visitLoop(Loop* curr) {
    // loops might be infinite, so must be careful
    // but we can't tell if non-infinite, since we don't have state, so loops are just impossible to optimize for now
    return Flow(NONSTANDALONE);
  }

  Flow visitCall(Call* curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitCallImport(CallImport* curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitCallIndirect(CallIndirect* curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitGetLocal(GetLocal *curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitSetLocal(SetLocal *curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitGetGlobal(GetGlobal *curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitSetGlobal(SetGlobal *curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitLoad(Load *curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitStore(Store *curr) {
    return Flow(NONSTANDALONE);
  }
  Flow visitHost(Host *curr) {
    return Flow(NONSTANDALONE);
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
    if (flow.breaking()) return; // TODO: can create a break as a replacement in some cases (not NONSTANDALONE)
    // this was precomputed
    if (isConcreteWasmType(flow.value.type)) {
      replaceCurrent(Builder(*getModule()).makeConst(flow.value));
    } else {
      ExpressionManipulator::nop(curr);
    }
  }
};

Pass *createPrecomputePass() {
  return new Precompute();
}

} // namespace wasm

