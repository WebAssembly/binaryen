#ifndef LOCAL_GOOGLE_HOME_NASHLEY_BINARYEN_SRC_PASSES_STRINGIFY_WALKER_H_
#define LOCAL_GOOGLE_HOME_NASHLEY_BINARYEN_SRC_PASSES_STRINGIFY_WALKER_H_

namespace wasm {

struct StringifyWalker : public PostWalker<StringifyWalker, UnifiedExpressionVisitor<StringifyWalker>> {

  static void scan(StringifyWalker* self, Expression** currp);
  void visitExpression(Expression *curr);
  void walkModule(Module *module);

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


#endif  // LOCAL_GOOGLE_HOME_NASHLEY_BINARYEN_SRC_PASSES_STRINGIFY_WALKER_H_
