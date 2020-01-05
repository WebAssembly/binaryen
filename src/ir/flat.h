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
//     local.get, a const, or an unreachable. Anything else is written
//     to a local earlier.
//  2. Disallow block, loop, and if return values, and do not allow the
//     function body to have a concrete type, i.e., do not use
//     control flow to pass around values.
//  3. Disallow local.tee, setting a local is always done in a local.set
//     on a non-nested-expression location.
//

#ifndef wasm_ir_flat_h
#define wasm_ir_flat_h

#include "ir/iteration.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-traversal.h"

namespace wasm {

namespace Flat {

inline bool isControlFlowStructure(Expression* curr) {
  return curr->is<Block>() || curr->is<If>() || curr->is<Loop>() ||
         curr->is<Try>();
}

// Returns true if the given control flow structure preserves all its childrens'
// preludes within it. For example, blocks satisfy this property, because when
// the original block is in the form of
// (block
//   (some expression)
//   ...
// )
// And we replaced (some expression) with a local.get whose prelude is (some
// expression), the final block will be in the form of
// (block
//   (some expression)
//   (local.get ...)
//   ...
// )
// So the block's children's preludes do not escape the boundary of the block.
// 'if' does not satisfy this property, because the prelude of its condition
// ends up preceding (= escaping) the if. For example, if the original 'if' is
// in the form of
// (if
//   (some expression)
//   ...
// )
// And (some expression) is replaced with a local.get whose prelude is (some
// expression), the final 'if' will be something like
// (some expression)
// (if
//   (local.get ...)
//   ...
// )
// So 'if''s condition's preludes escapes the boundary of 'if'. Refer to Flatten
// pass for detailed algorithms.
inline bool containsChildrensPreludes(Expression* curr) {
  return curr->is<Block>() || curr->is<Loop>() || curr->is<Try>();
}

inline void verifyFlatness(Function* func) {
  struct VerifyFlatness
    : public PostWalker<VerifyFlatness,
                        UnifiedExpressionVisitor<VerifyFlatness>> {
    void visitExpression(Expression* curr) {
      if (isControlFlowStructure(curr)) {
        verify(!curr->type.isConcrete(),
               "control flow structures must not flow values");
      } else if (curr->is<LocalSet>()) {
        verify(!curr->type.isConcrete(), "tees are not allowed, only sets");
      } else {
        for (auto* child : ChildIterator(curr)) {
          verify(Properties::isConstantExpression(child) ||
                   child->is<LocalGet>() || child->is<Unreachable>(),
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

    VerifyFlatness* create() override { return new VerifyFlatness(); }

    void doVisitFunction(Function* func) { verifyFlatness(func); }
  };

  PassRunner runner(module);
  VerifyFlatness().run(&runner, module);
}

} // namespace Flat

} // namespace wasm

#endif // wasm_ir_flat_h
