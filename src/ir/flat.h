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

#ifndef wasm_ir_flat_h
#define wasm_ir_flat_h

#include "wasm-traversal.h"
#include "ir/iteration.h"

namespace wasm {

namespace Flat {

inline bool isControlFlowStructure(Expression* curr) {
  return curr->is<Block>() || curr->is<If>() || curr->is<Loop>();
}

inline void verifyFlatness(Function* func) {
  struct VerifyFlatness : public PostWalker<VerifyFlatness, UnifiedExpressionVisitor<VerifyFlatness>> {
    void visitExpression(Expression* curr) {
      if (isControlFlowStructure(curr)) {
        verify(!isConcreteType(curr->type), "control flow structures must not flow values");
      } else if (curr->is<SetLocal>()) {
        verify(!isConcreteType(curr->type), "tees are not allowed, only sets");
      } else {
        for (auto* child : ChildIterator(curr)) {
          verify(child->is<Const>() || child->is<GetLocal>(), "instructions must only have const or local.get as children");
        }
      }
    }

    void verify(bool condition, const char* message) {
      if (!condition) {
        Fatal() << "IR must be flat: run --flatten beforehand (" << message << ')';
      }
    }
  };

  VerifyFlatness verifier;
  verifier.walkFunction(func);
  verifier.verify(!isConcreteType(func->body->type), "function bodies must not flow values");
}

inline void verifyFlatness(Module* module) {
  struct VerifyFlatness : public WalkerPass<PostWalker<VerifyFlatness, UnifiedExpressionVisitor<VerifyFlatness>>> {
    bool isFunctionParallel() override { return true; }

    VerifyFlatness* create() override {
      return new VerifyFlatness();
    }

    void doVisitFunction(Function* func) {
      verifyFlatness(func);
    }
  };

  PassRunner runner(module);
  runner.setIsNested(true);
  runner.add<VerifyFlatness>();
  runner.run();
}

} // namespace Fkat

} // namespace wasm

#endif // wasm_ir_flat_h
