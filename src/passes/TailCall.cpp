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
// Convert calls in tail position to return calls (tail calls).
//

#include "ir/effects.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

struct TailCall : public WalkerPass<ExpressionStackWalker<TailCall>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TailCall>();
  }

  bool changed = false;

  bool isProtectedByLocalHandler() {
    for (size_t i = 0; i + 1 < expressionStack.size(); ++i) {
      if (auto* t = expressionStack[i]->dynCast<TryTable>()) {
        if (!t->catchTags.empty()) {
          return true;
        }
      } else if (auto* t = expressionStack[i]->dynCast<Try>()) {
        if (expressionStack[i + 1] == t->body &&
            (!t->isDelegate() || t->delegateTarget != DELEGATE_CALLER_TARGET)) {
          return true;
        }
      }
    }
    return false;
  }

  bool isTailPosition() {
    for (int i = int(expressionStack.size()) - 1; i > 0; --i) {
      auto* curr = expressionStack[i];
      auto* parent = expressionStack[i - 1];

      if (auto* ret = parent->dynCast<Return>()) {
        return ret->value == curr;
      }
      if (auto* block = parent->dynCast<Block>()) {
        if (block->list.back() == curr) {
          continue;
        }
        if (curr->type == Type::none) {
          auto it = std::find(block->list.begin(), block->list.end(), curr);
          if (it + 1 < block->list.end() && (*(it + 1))->is<Return>()) {
            return true;
          }
        }
        return false;
      }
      if (auto* iff = parent->dynCast<If>()) {
        if (curr == iff->ifTrue &&
            (iff->ifFalse || getFunction()->getResults() == Type::none)) {
          continue;
        }
        if (curr == iff->ifFalse) {
          continue;
        }
        return false;
      }
      if (auto* tryy = parent->dynCast<Try>()) {
        if (curr == tryy->body || std::find(tryy->catchBodies.begin(),
                                            tryy->catchBodies.end(),
                                            curr) != tryy->catchBodies.end()) {
          continue;
        }
        return false;
      }
      if (auto* tryTable = parent->dynCast<TryTable>()) {
        if (curr == tryTable->body) {
          continue;
        }
        return false;
      }
      if (!parent->is<RefCast>() && !parent->is<RefAs>() &&
          !parent->is<BrOn>() && !parent->is<Break>() &&
          Properties::getImmediateFallthrough(
            parent, getPassOptions(), *getModule()) == curr) {
        continue;
      }
      return false;
    }
    return true;
  }

  template<typename T> void handleCall(T* call) {
    if (call->isReturn ||
        !Type::isSubType(call->type, getFunction()->getResults()) ||
        !isTailPosition() ||
        (isProtectedByLocalHandler() &&
         ShallowEffectAnalyzer(getPassOptions(), *getModule(), call)
           .throws())) {
      return;
    }
    call->isReturn = true;
    call->finalize();
    changed = true;
  }

  void visitCall(Call* curr) { handleCall(curr); }
  void visitCallIndirect(CallIndirect* curr) { handleCall(curr); }
  void visitCallRef(CallRef* curr) { handleCall(curr); }

  void doWalkFunction(Function* func) {
    if (!getModule()->features.hasTailCall() || func->imported()) {
      return;
    }
    Super::doWalkFunction(func);
    if (changed) {
      ReFinalize().walkFunctionInModule(func, getModule());
      PassRunner runner(getModule(), getPassOptions());
      runner.setIsNested(true);
      runner.add("dce");
      runner.runOnFunction(func);
    }
  }
};

} // anonymous namespace

Pass* createTailCallPass() { return new TailCall(); }

} // namespace wasm
