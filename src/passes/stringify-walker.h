#ifndef passes_stringify_walker_module_h
#define passes_stringify_walker_module_h

namespace wasm {

struct StringifyWalker : public PostWalker<StringifyWalker, UnifiedExpressionVisitor<StringifyWalker>> {

  void walkModule(Module *module);
  static void scan(StringifyWalker* self, Expression** currp);
  void visitExpression(Expression *curr);

 private:
  std::queue<Expression **> queue;
  static void handler(StringifyWalker *stringify, Expression**);
  static void scanChildren(StringifyWalker *stringify, Expression **currp);

  uint64_t monotonic = 0;
  std::vector<uint64_t> string;
  // Change key to Expression
  // [[maybe_unused]] std::unordered_map<Expression *, uint64_t> exprToCounter;
  [[maybe_unused]] std::unordered_map<uint64_t, uint64_t> exprToCounter;

  void insertGloballyUniqueChar();
  void insertHash(uint64_t hash, Expression *curr);
  static void emitFunctionBegin(StringifyWalker *self);
  static void visitControlFlow(StringifyWalker* self, Expression** currp);
  void printString();
};

}


#endif  // passes_stringify_walker_module_h
