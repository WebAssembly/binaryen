#ifndef passes_stringify_walker_module_h
#define passes_stringify_walker_module_h

#include "wasm-traversal.h"
#include <queue>

namespace wasm {

template<typename SubType>
struct StringifyWalker
  : public PostWalker<SubType, UnifiedExpressionVisitor<SubType>> {

  Module* wasm;
  std::queue<Expression**> queue;

  static void walkModule(SubType* self, Module* module);
  static void scan(SubType* self, Expression** currp);
  static void addUniqueSymbol(SubType* self, Expression** currp);
  static void visitControlFlow(SubType* self, Expression** currp);
  void visitExpression(Expression* curr);

private:
  static void handler(SubType* self, Expression**);
  static void deferredScan(SubType* self, Expression** currp);
};

struct HashStringifyWalker : public StringifyWalker<HashStringifyWalker> {

  void walkModule(Module* module);
  static void addUniqueSymbol(HashStringifyWalker* self, Expression** currp);
  static void visitControlFlow(HashStringifyWalker* self, Expression** currp);
  void visitExpression(Expression* curr);

private:
  std::vector<uint64_t> string;
  uint64_t monotonic = 0;
  // Change key to Expression
  // [[maybe_unused]] std::unordered_map<Expression *, uint64_t> exprToCounter;
  [[maybe_unused]] std::unordered_map<uint64_t, uint64_t> exprToCounter;

  void addExpressionHash(Expression* curr, uint64_t hash);
};

struct TestStringifyWalker : public StringifyWalker<TestStringifyWalker> {

  std::ostream& os;

  TestStringifyWalker(std::ostream& os);

  void walkModule(Module* module);
  static void addUniqueSymbol(TestStringifyWalker* self, Expression** currp);
  static void visitControlFlow(TestStringifyWalker* self, Expression** currp);
  void visitExpression(Expression* curr);
  void print(std::ostream& os);
};

} // namespace wasm

#endif // passes_stringify_walker_module_h
