
#include "cfg/cfg-traversal.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include <algorithm>
#include <cassert>
#include <iostream>
#include <optional>
#include <stack>
#include <vector>

namespace wasm {

namespace {

struct Info {
  bool isStartWithReturn = false;
  bool isInsideTryBlock = false;
  Expression* lastExpr = nullptr;
};

struct NonReturnFinder
  : public CFGWalker<NonReturnFinder,
                     UnifiedExpressionVisitor<NonReturnFinder>,
                     Info> {
  using S =
    CFGWalker<NonReturnFinder, UnifiedExpressionVisitor<NonReturnFinder>, Info>;

  std::vector<Call*> tailCalls;
  std::vector<CallIndirect*> tailCallIndirects;

  void visitExpression(Expression* curr) {
    if (currBasicBlock == nullptr) {
      return;
    }
    if (curr->is<Block>() || curr->is<If>() || curr->is<Loop>()) {
      // skip all control flow instructions
      return;
    }

    Expression* const lastExpr = currBasicBlock->contents.lastExpr;
    currBasicBlock->contents.lastExpr = curr;

    if (!tryStack.empty()) {
      // skip all try stack
      currBasicBlock->contents.isInsideTryBlock = true;
    }
    if (curr->is<Return>()) {
      if (lastExpr == nullptr) {
        currBasicBlock->contents.isStartWithReturn = true;
      } else {
        pushPotentialTailCall(lastExpr);
      }
    }
  }

  void pushPotentialTailCall(Expression* curr) {
    if (curr) {
      if (curr->is<Call>()) {
        tailCalls.push_back(curr->cast<Call>());
      } else if (curr->is<CallIndirect>()) {
        tailCallIndirects.push_back(curr->cast<CallIndirect>());
      }
    }
  }

  void doWalkFunction(Function* func) {
    S::doWalkFunction(func);
    if (hasSyntheticExit && exit != nullptr) {
      exit->contents.isStartWithReturn = true;
    }
    if (exit != nullptr) {
      assert(tryStack.empty());
      pushPotentialTailCall(exit->contents.lastExpr);
    }
    // propagate start with return flag
    bool hasUpdated = true;
    while (hasUpdated) {
      hasUpdated = false;
      for (std::unique_ptr<BasicBlock> const& bb : basicBlocks) {
        if (bb->contents.isStartWithReturn) {
          continue;
        }
        if (bb->contents.lastExpr == nullptr) {
          const bool followBasicBlockStartWithReturn =
            std::all_of(bb->out.begin(), bb->out.end(), [](BasicBlock* b) {
              return b->contents.isStartWithReturn;
            });
          if (followBasicBlockStartWithReturn) {
            bb->contents.isStartWithReturn = true;
            hasUpdated = true;
          }
        }
      }
    }
    for (std::unique_ptr<BasicBlock> const& bb : basicBlocks) {
      Expression* const lastExpr = bb->contents.lastExpr;
      if (lastExpr == nullptr) {
        continue;
      }
      const bool followBasicBlockStartWithReturn =
        std::all_of(bb->out.begin(), bb->out.end(), [](BasicBlock* b) {
          return b->contents.isStartWithReturn;
        });
      if (!followBasicBlockStartWithReturn) {
        continue;
      }
      pushPotentialTailCall(lastExpr);
    }
  }
};

struct ReturnFinder : TryDepthWalker<ReturnFinder> {
  explicit ReturnFinder(const PassOptions& passOptions)
    : TryDepthWalker<ReturnFinder>(), passOptions(passOptions) {}
  const PassOptions& passOptions;
  std::vector<Call*> tailCalls;
  std::vector<CallIndirect*> tailCallIndirects;
  void visitFunction(Function* curr) { checkTailCall(curr->body); }
  void visitReturn(Return* curr) {
    if (tryDepth > 0) {
      // (return (call ...)) is not equal to (return_call ...) in try block
      return;
    }
    checkTailCall(curr->value);
  }

private:
  void checkTailCall(Expression* const curr) {
    std::stack<Expression*> workList{};
    workList.push(curr);
    while (!workList.empty()) {
      Expression* const target = workList.top();
      workList.pop();
      if (auto* call = target->dynCast<Call>()) {
        if (!call->isReturn && call->type == getFunction()->getResults()) {
          tailCalls.push_back(call);
        }
      } else if (auto* call = target->dynCast<CallIndirect>()) {
        if (!call->isReturn && call->type == getFunction()->getResults()) {
          tailCallIndirects.push_back(call);
        }
      } else if (auto* ifElse = target->dynCast<If>()) {
        workList.push(ifElse->ifTrue);
        workList.push(ifElse->ifFalse);
      } else if (auto* tryy = target->dynCast<Try>()) {
        for (Expression* catchBody : tryy->catchBodies) {
          workList.push(catchBody);
        }
      } else if (auto* block = target->dynCast<Block>()) {
        if (!block->list.empty()) {
          workList.push(block->list.back());
        }
      } else {
        Expression* const next = Properties::getImmediateFallthrough(
          target, passOptions, *getModule());
        if (next != target) {
          workList.push(next);
        }
      }
    }
  }
};

} // namespace

struct TailCallOptimizer : public Pass {
  bool isFunctionParallel() override { return true; }
  std::unique_ptr<Pass> create() override {
    return std::make_unique<TailCallOptimizer>();
  }

  static void modify(std::vector<Call*> const& tailCalls,
                     std::vector<CallIndirect*> const& tailCallIndirects) {
    for (Call* call : tailCalls) {
      if (!call->isReturn) {
        call->isReturn = true;
      }
    }
    for (CallIndirect* call : tailCallIndirects) {
      if (!call->isReturn) {
        call->isReturn = true;
      }
    }
  }
  void runOnFunction(Module* module, Function* function) override {
    if (!module->features.hasTailCall()) {
      return;
    }
    if (getPassOptions().shrinkLevel > 0 &&
        getPassOptions().optimizeLevel == 0) {
      // When we more force on the binary size, add return_call will increase
      // the code size.
      return;
    }
    if (function->getResults().size() == 0) {
      NonReturnFinder finder{};
      finder.walkFunctionInModule(function, module);
      modify(finder.tailCalls, finder.tailCallIndirects);
    } else {
      ReturnFinder finder{getPassOptions()};
      finder.walkFunctionInModule(function, module);
      modify(finder.tailCalls, finder.tailCallIndirects);
    }
    ReFinalize{}.walkFunctionInModule(function, module);
  }
};

Pass* createTailCallPass() { return new TailCallOptimizer(); }

} // namespace wasm
