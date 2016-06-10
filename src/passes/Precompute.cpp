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
// Removes dead, i.e. unreachable, code.
//
// We keep a record of when control flow is reachable. When it isn't, we
// kill (turn into unreachable). We then fold away entire unreachable
// expressions.
//
// When dead code causes an operation to not happen, like a store, a call
// or an add, we replace with a block with a list of what does happen.
// That isn't necessarily smaller, but blocks are friendlier to other
// optimizations: blocks can be merged and eliminated, and they clearly
// have no side effects.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm-interpreter.h>

namespace wasm {

// Execute an expression by itself. Errors if we hit anything we need anything not in the expression itself standalone.
class StandaloneExpressionRunner : public ExpressionRunner<StandaloneExpressionRunner> {
public:
  struct NonstandaloneException {}; // TODO: use a flow with a special name, as this is likely very slow

  Flow visitLoop(Loop* curr) {
    // loops might be infinite, so must be careful
    // but we can't tell if non-infinite, since we don't have state, so loops are just impossible to optimize for now
    throw NonstandaloneException();
  }

  Flow visitCall(Call* curr) {
    throw NonstandaloneException();
  }
  Flow visitCallImport(CallImport* curr) {
    throw NonstandaloneException();
  }
  Flow visitCallIndirect(CallIndirect* curr) {
    throw NonstandaloneException();
  }
  Flow visitGetLocal(GetLocal *curr) {
    throw NonstandaloneException();
  }
  Flow visitSetLocal(SetLocal *curr) {
    throw NonstandaloneException();
  }
  Flow visitLoad(Load *curr) {
    throw NonstandaloneException();
  }
  Flow visitStore(Store *curr) {
    throw NonstandaloneException();
  }
  Flow visitHost(Host *curr) {
    throw NonstandaloneException();
  }

  void trap(const char* why) override {
    throw NonstandaloneException();
  }
};

struct Precompute : public WalkerPass<PostWalker<Precompute, UnifiedExpressionVisitor<Precompute>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Precompute; }

  void visitExpression(Expression* curr) {
    if (curr->is<Const>()) return;
    // try to evaluate this into a const
    Flow flow;
    try {
      flow = StandaloneExpressionRunner().visit(curr);
    } catch (StandaloneExpressionRunner::NonstandaloneException& e) {
      return;
    }
    if (flow.breaking()) return; // TODO: can create a break as a replacement
    if (isConcreteWasmType(flow.value.type)) {
      replaceCurrent(Builder(*getModule()).makeConst(flow.value));
    }
  }
};

Pass *createPrecomputePass() {
  return new Precompute();
}

} // namespace wasm

