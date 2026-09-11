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

#include <functional>
#include <memory>
#include <unordered_set>
#include <vector>

#include "analysis/cfg.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

using ReturnPoint = Expression*;

void addReturnPoints(Expression* expr, std::vector<ReturnPoint>& returnPoints) {
  if (!expr) {
    return;
  }

  if (auto* iff = expr->dynCast<If>()) {
    addReturnPoints(iff->ifTrue, returnPoints);
    addReturnPoints(iff->ifFalse, returnPoints);
    return;
  }

  if (auto* block = expr->dynCast<Block>()) {
    if (!block->list.empty()) {
      addReturnPoints(block->list.back(), returnPoints);
    }
    return;
  }

  returnPoints.push_back(expr);
}

std::vector<ReturnPoint> findReturnPoints(Module* module, Function* func) {
  auto cfg = analysis::CFG::fromFunction(func, module);
  const analysis::BasicBlock* exit = nullptr;
  for (const auto& block : cfg) {
    if (block.isExit()) {
      exit = &block;
      break;
    }
  }

  std::vector<ReturnPoint> returnPoints;
  if (!exit) {
    return returnPoints;
  }

  std::unordered_set<const analysis::BasicBlock*> visited;
  std::function<void(const analysis::BasicBlock*)> find =
    [&](const analysis::BasicBlock* block) {
      if (!block || !visited.insert(block).second) {
        return;
      }

      Expression* last = nullptr;
      Expression* secondLast = nullptr;
      for (auto it = block->rbegin(); it != block->rend(); ++it) {
        auto* expr = *it;
        if (expr->is<Block>() || expr->is<Loop>()) {
          continue;
        }
        if (!last) {
          last = expr;
        } else {
          secondLast = expr;
          break;
        }
      }

      auto visitPredecessors = [&]() {
        for (auto* pred : block->preds()) {
          find(pred);
        }
      };

      if (!last || last->is<If>()) {
        visitPredecessors();
      } else if (auto* ret = last->dynCast<Return>()) {
        if (ret->value) {
          addReturnPoints(ret->value, returnPoints);
        } else if (secondLast && secondLast->type != Type::unreachable) {
          addReturnPoints(secondLast, returnPoints);
        } else {
          visitPredecessors();
        }
      } else if (auto* br = last->dynCast<Break>()) {
        if (br->value) {
          addReturnPoints(br->value, returnPoints);
        } else if (secondLast && secondLast->type != Type::unreachable) {
          addReturnPoints(secondLast, returnPoints);
        } else {
          visitPredecessors();
        }
      } else if (auto* sw = last->dynCast<Switch>()) {
        if (sw->value) {
          addReturnPoints(sw->value, returnPoints);
        } else if (secondLast && secondLast->type != Type::unreachable) {
          addReturnPoints(secondLast, returnPoints);
        } else {
          visitPredecessors();
        }
      } else if (last->type != Type::unreachable) {
        addReturnPoints(last, returnPoints);
      }
    };

  find(exit);
  return returnPoints;
}

bool convertCall(Expression* expr, Module* module, Function* func) {
  if (auto* call = expr->dynCast<Call>()) {
    if (call->isReturn) {
      return false;
    }
    auto* target = module->getFunctionOrNull(call->target);
    if (!target || target->getResults() != func->getResults()) {
      return false;
    }
    call->isReturn = true;
    call->finalize();
    return true;
  }

  if (auto* call = expr->dynCast<CallIndirect>()) {
    if (call->isReturn ||
        call->heapType.getSignature().results != func->getResults()) {
      return false;
    }
    call->isReturn = true;
    call->finalize();
    return true;
  }

  if (auto* call = expr->dynCast<CallRef>()) {
    if (call->isReturn || !call->target->type.isRef() ||
        !call->target->type.getHeapType().isSignature() ||
        call->target->type.getHeapType().getSignature().results !=
          func->getResults()) {
      return false;
    }
    call->isReturn = true;
    call->finalize();
    return true;
  }

  return false;
}

struct TailCall : public Pass {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TailCall>();
  }

  void runOnFunction(Module* module, Function* func) override {
    if (!module->features.hasTailCall() || func->imported() || !func->body) {
      return;
    }

    bool converted = false;
    for (auto* point : findReturnPoints(module, func)) {
      converted |= convertCall(point, module, func);
    }

    if (converted) {
      PassRunner runner(module);
      runner.setIsNested(true);
      runner.add("dce");
      runner.runOnFunction(func);
    }
  }
};

} // anonymous namespace

Pass* createTailCallPass() { return new TailCall(); }

} // namespace wasm