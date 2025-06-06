
#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include <vector>

namespace wasm {

namespace {

struct Finder : PostWalker<Finder> {
  std::vector<Call*> tailCalls;
  std::vector<CallIndirect*> tailCallIndirects;
  void visitFunction(Function* curr) { checkTailCall(curr->body); }
  void visitReturn(Return* curr) { checkTailCall(curr->value); }

private:
  void checkTailCall(Expression* expr) {
    if (expr == nullptr) {
      return;
    }
    if (auto* call = expr->dynCast<Call>()) {
      if (!call->isReturn && call->type == getFunction()->getResults()) {
        tailCalls.push_back(call);
      }
      return;
    }
    if (auto* call = expr->dynCast<CallIndirect>()) {
      if (!call->isReturn && call->type == getFunction()->getResults()) {
        tailCallIndirects.push_back(call);
      }
      return;
    }
    if (auto* block = expr->dynCast<Block>()) {
      return checkTailCall(block->list);
    }
    if (auto* ifElse = expr->dynCast<If>()) {
      checkTailCall(ifElse->ifTrue);
      checkTailCall(ifElse->ifFalse);
      return;
    }
  }
  void checkTailCall(ExpressionList const& exprs) {
    if (exprs.empty()) {
      return;
    }
    checkTailCall(exprs.back());
    return;
  }
};

} // namespace

struct TailCallOptimizer : public Pass {
  bool isFunctionParallel() override { return true; }
  std::unique_ptr<Pass> create() override {
    return std::make_unique<TailCallOptimizer>();
  }
  void runOnFunction(Module* module, Function* function) override {
    if (!module->features.hasTailCall()) {
      return;
    }
    Finder finder{};
    finder.walkFunctionInModule(function, module);
    for (Call* call : finder.tailCalls) {
      if (!call->isReturn) {
        call->isReturn = true;
        call->finalize();
      }
    }
    for (CallIndirect* call : finder.tailCallIndirects) {
      if (!call->isReturn) {
        call->isReturn = true;
        call->finalize();
      }
    }
  }
};

Pass* createTailCallPass() { return new TailCallOptimizer(); }

} // namespace wasm
