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
// Stops using return values from set_local and store nodes.
//

#include <wasm.h>
#include <pass.h>
#include <ast_utils.h>
#include <wasm-builder.h>

namespace wasm {

struct DropReturnValues : public WalkerPass<PostWalker<DropReturnValues, Visitor<DropReturnValues>>> {
  bool isFunctionParallel() { return true; }

  std::vector<Expression*> expressionStack;

  void visitSetLocal(SetLocal* curr) {
    if (ExpressionAnalyzer::isResultUsed(expressionStack, getFunction())) {
      Builder builder(*getModule());
      replaceCurrent(builder.makeSequence(
        curr,
        builder.makeGetLocal(curr->index, curr->type)
      ));
    }
  }

  void visitStore(Store* curr) {
    if (ExpressionAnalyzer::isResultUsed(expressionStack, getFunction())) {
      Index index = getFunction()->getNumLocals();
      getFunction()->vars.emplace_back(curr->type);
      Builder builder(*getModule());
      replaceCurrent(builder.makeSequence(
        builder.makeSequence(
          builder.makeSetLocal(index, curr->value),
          curr
        ),
        builder.makeGetLocal(index, curr->type)
      ));
      curr->value = builder.makeGetLocal(index, curr->type);
    }
  }

  static void visitPre(DropReturnValues* self, Expression** currp) {
    self->expressionStack.push_back(*currp);
  }

  static void visitPost(DropReturnValues* self, Expression** currp) {
    self->expressionStack.pop_back();
  }

  static void scan(DropReturnValues* self, Expression** currp) {
    self->pushTask(visitPost, currp);

    WalkerPass<PostWalker<DropReturnValues, Visitor<DropReturnValues>>>::scan(self, currp);

    self->pushTask(visitPre, currp);
  }
};

static RegisterPass<DropReturnValues> registerPass("drop-return-values", "stops relying on return values from set_local and store");

} // namespace wasm

