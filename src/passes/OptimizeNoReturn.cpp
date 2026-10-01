/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Optimizes using the @binaryen.noreturn intrinsic: when a function is marked
// as not returning, we can place an unreachable right after it. DCE can then
// remove code.
//
// Note that this pass does not add new markings of the intrinsic. Another pass
// (DeadArgumentElimination) is a convenient place to do that.
//

#include "ir/intrinsics.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct OptimizeNoReturn
  : public WalkerPass<PostWalker<OptimizeNoReturn,
                                 UnifiedExpressionVisitor<OptimizeNoReturn>>> {

  using Super = WalkerPass<
    PostWalker<OptimizeNoReturn, UnifiedExpressionVisitor<OptimizeNoReturn>>>;
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<OptimizeNoReturn>();
  }

  // To avoid adding unneeded unreachables, see if a call to a noreturn function
  // is followed by an unreachable already, or a drop and then an unreachable.
  // In both those cases we don't need to add an unreachable ourselves. To track
  // that, we keep note of the last call and drop.
  Expression** callp = nullptr;
  Expression** dropp = nullptr;

  void visitExpression(Expression* curr) {
    if (auto* call = curr->dynCast<Call>()) {
      if (callp) {
        // There was a call before us, handle it first.
        addUnreachable();
      }

      // No need to add an unreachable after an already-unreachable call (like a
      // return call, or one with an unreachable operand).
      if (call->type == Type::unreachable) {
        return;
      }

      auto* func = getModule()->getFunctionOrNull(call->target);
      if (!func) {
        // No target: this can happen during Asyncify or if a code generator is
        // optimizing something before the entire module is ready.
        return;
      }

      if (Intrinsics::getAnnotations(func).noReturn) {
        callp = getCurrentPointer();
      }
      return;
    }

    if (!callp) {
      // We are not right after a relevant call, so there is nothing to do.
      return;
    }

    if (curr->dynCast<Drop>()) {
      // We are the call's drop.
      dropp = getCurrentPointer();
      return;
    } else if (curr->dynCast<Unreachable>()) {
      // We are an unreachable after the call (or maybe the call + drop). We
      // don't need to add anything.
      callp = nullptr;
      dropp = nullptr;
      return;
    }

    // Something else, so we need to add an unreachable here.
    addUnreachable();
  }

  static void scan(OptimizeNoReturn* self, Expression** currp) {
    // Whenever we scan a control flow structure, we are entering it, which
    // means there is something in the wasm, and we can clear our state.
    if (Properties::isControlFlowStructure(*currp)) {
      self->callp = nullptr;
      self->dropp = nullptr;
    }

    Super::scan(self, currp);
  }

  void visitFunction(Function* curr) {
    // The walk ended, but perhaps it ended on something that needs an
    // unreachable.
    if (callp) {
      addUnreachable();
    }
  }

  void addUnreachable() {
    Builder builder(*getModule());
    if (dropp) {
      // Put the unreachable after the drop (so the call stays dropped); other
      // passes can remove the return value entirely.
      *dropp = builder.makeSequence(*dropp, builder.makeUnreachable());
      dropp = nullptr;
    } else {
      // Put the unreachable after the call.
      *callp = builder.makeSequence(*callp, builder.makeUnreachable());
    }
    callp = nullptr;
  }
};

Pass* createOptimizeNoReturnPass() { return new OptimizeNoReturn(); }

} // namespace wasm
