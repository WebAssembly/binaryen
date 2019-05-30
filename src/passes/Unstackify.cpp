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

#include "ir/stackification.h"
#include "pass.h"
#include "wasm-builder.h"

namespace wasm {

struct Unstackify
  : public WalkerPass<PushPopStackWalker<Unstackify, std::pair<Index, Type>>> {
  // Locals replacing pushes
public:
  void visitPush(Push* curr) {
    Builder builder(*getModule());
    Index var = builder.addVar(getFunction(), curr->value->type);
    doPush({var, curr->value->type});
    replaceCurrent(builder.makeLocalSet(var, curr->value));
  }
  void visitPop(Pop* curr) { super::visitPop(curr); }
  void visitPop(Pop* curr, std::pair<Index, Type> var) {
    Builder builder(*getModule());
    replaceCurrent(builder.makeLocalGet(var.first, var.second));
  }
};

namespace Stackification {

void verifyUnstackified(Function* func) {
  struct VerifyUnstackified
    : public PostWalker<VerifyUnstackified,
                        UnifiedExpressionVisitor<VerifyUnstackified>> {
    void visitExpression(Expression* curr) {
      // TODO: extend for multivalue
      verify(!curr->is<Push>(), "pushes not allowed");
      verify(!curr->is<Pop>(), "pops not allowed");
    }

    void verify(bool condition, const char* message) {
      if (!condition) {
        Fatal() << "IR must be unstackified: run --unstackify beforehand ("
                << message << ", in " << getFunction()->name << ')';
      }
    }
  };

  VerifyUnstackified verifier;
  verifier.walkFunction(func);
}

} // namespace Stackification

Pass* createUnstackifyPass() { return new Unstackify(); }

} // namespace wasm
