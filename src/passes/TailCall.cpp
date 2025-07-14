
#include "ir/properties.h"
#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include <stack>
#include <vector>

namespace wasm {

namespace {

struct Finder : TryDepthWalker<Finder> {
  explicit Finder(const PassOptions& passOptions)
    : TryDepthWalker<Finder>(), passOptions(passOptions) {}
  const PassOptions& passOptions;
  std::vector<Call*> tailCalls;
  std::vector<CallIndirect*> tailCallIndirects;
  void visitFunction(Function* curr) {
    if (passOptions.shrinkLevel > 0 && passOptions.optimizeLevel == 0) {
      // When we more force on the binary size, add return_call will increase
      // the code size.
      return;
    }
    checkTailCall(curr->body);
  }
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
  void runOnFunction(Module* module, Function* function) override {
    if (!module->features.hasTailCall()) {
      return;
    }
    Finder finder{getPassOptions()};
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
