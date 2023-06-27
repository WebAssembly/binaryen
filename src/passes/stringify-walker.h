#ifndef passes_stringify_walker_module_h
#define passes_stringify_walker_module_h

#include "wasm-traversal.h"
#include <queue>

namespace wasm {

template<typename SubType>
struct StringifyWalker
  : public PostWalker<SubType, UnifiedExpressionVisitor<SubType>> {

  Module* wasm;
  std::queue<Expression**> controlFlowQueue;

  static void walkModule(SubType* self, Module* module);
  static void scan(SubType* self, Expression** currp);
  static void addUniqueSymbol(SubType* self, Expression** currp);
  static void doVisitExpression(SubType* self, Expression** currp);
  void visitExpression(Expression* curr);

private:
  static void dequeueControlFlow(SubType* self, Expression**);
  static void deferredScan(SubType* self, Expression** currp);
};

} // namespace wasm

#endif // passes_stringify_walker_module_h
