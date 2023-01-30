/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Flattens code, removing nesting.e.g. an if return value would be
// converted to a local
//
//  (i32.add
//    (if (..condition..)
//      (..if true..)
//      (..if false..)
//    )
//    (i32.const 1)
//  )
// =>
//  (if (..condition..)
//    (local.set $temp
//      (..if true..)
//    )
//    (local.set $temp
//      (..if false..)
//    )
//  )
//  (i32.add
//    (local.get $temp)
//    (i32.const 1)
//  )
//
// Formally, this pass flattens in the precise sense of
// making the AST have these properties:
//
//  1. Aside from a local.set, the operands of an instruction must be a
//     local.get, a const, an unreachable, or a ref.as_non_null. Anything else
//     is written to a local earlier.
//  2. Disallow control flow (block, loop, if, and try) return values, and do
//     not allow the function body to have a concrete type, i.e., do not use
//     control flow to pass around values.
//  3. Disallow local.tee, setting a local is always done in a local.set
//     on a non-nested-expression location.
//  4. local.set cannot have an operand that is control flow (control flow with
//     values is prohibited already, but e.g. a block ending in unreachable,
//     which can normally be nested, is also disallowed).
//
// Note: ref.as_non_null must be allowed in a nested position because we cannot
// spill it to a local - the result is non-null, which is not allowable in a
// local.
//

#ifndef wasm_ir_flat_h
#define wasm_ir_flat_h

#include "ir/iteration.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-traversal.h"

namespace wasm::Flat {

inline void verifyFlatness(Function* func) {
  struct VerifyFlatness
    : public PostWalker<VerifyFlatness,
                        UnifiedExpressionVisitor<VerifyFlatness>> {
    void visitExpression(Expression* curr) {
      if (Properties::isControlFlowStructure(curr)) {
        verify(!curr->type.isConcrete(),
               "control flow structures must not flow values");
      } else if (auto* set = curr->dynCast<LocalSet>()) {
        verify(!set->isTee() || set->type == Type::unreachable,
               "tees are not allowed, only sets");
        verify(!Properties::isControlFlowStructure(set->value),
               "set values cannot be control flow");
      } else {
        for (auto* child : ChildIterator(curr)) {
          bool isRefAsNonNull =
            child->is<RefAs>() && child->cast<RefAs>()->op == RefAsNonNull;
          verify(Properties::isConstantExpression(child) ||
                   child->is<LocalGet>() || child->is<Unreachable>() ||
                   isRefAsNonNull,
                 "instructions must only have constant expressions, local.get, "
                 "or unreachable as children");
        }
      }
    }

    void verify(bool condition, const char* message) {
      if (!condition) {
        Fatal() << "IR must be flat: run --flatten beforehand (" << message
                << ", in " << getFunction()->name << ')';
      }
    }
  };

  VerifyFlatness verifier;
  verifier.walkFunction(func);
  verifier.setFunction(func);
  verifier.verify(!func->body->type.isConcrete(),
                  "function bodies must not flow values");
}

inline void verifyFlatness(Module* module) {
  struct VerifyFlatness
    : public WalkerPass<
        PostWalker<VerifyFlatness, UnifiedExpressionVisitor<VerifyFlatness>>> {
    bool isFunctionParallel() override { return true; }

    bool modifiesBinaryenIR() override { return false; }

    std::unique_ptr<Pass> create() override {
      return std::make_unique<VerifyFlatness>();
    }

    void visitFunction(Function* func) { verifyFlatness(func); }
  };

  PassRunner runner(module);
  VerifyFlatness().run(&runner, module);
}

} // namespace wasm::Flat

#endif // wasm_ir_flat_h
