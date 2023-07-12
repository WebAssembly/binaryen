#ifndef wasm_passes_stringify_walker_h
#define wasm_passes_stringify_walker_h

#include "ir/iteration.h"
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "wasm-traversal.h"
#include <queue>

namespace wasm {

/*
 * This walker does a normal postorder traversal except that it defers
 * traversing the contents of control flow structures it encounters. This
 * effectively un-nests control flow.
 *
 * For example, the below (contrived) wat:
 * 1 : (block
 * 2 :   (if
 * 3 :     (i32.const 0)
 * 4 :     (then (return (i32.const 1)))
 * 5 :     (else (return (i32.const 0)))))
 * 6 :   (drop
 * 7 :     (i32.add
 * 8 :       (i32.const 20)
 * 9 :       (i32.const 10)))
 * 10:   (if
 * 11:     (i32.const 1)
 * 12:     (then (return (i32.const 2)))
 * 14: )
 * Would have its expressions visited in the following order (based on line
 * number):
 * 1, 3, 2, 8, 9, 7, 6, 11, 10, 4, 5, 12
 *
 * Of note:
 *   - The visits to if-True on line 4 and if-False on line 5 are deferred until
 *     after the rest of the siblings of the if expression on line 2 are visited
 *   - The if-condition (i32.const 0) on line 3 is visited before the if
 *     expression on line 2. Similarly, the if-condition (i32.const 1) on line
 *     11 is visited before the if expression on line 10.
 *   - The add (line 7) binary operator's left and right children (lines 8 - 9)
 *     are visited first as they need to be on the stack before the add
 *     operation is executed
 */

template<typename SubType>
struct StringifyWalker
  : public PostWalker<SubType, UnifiedExpressionVisitor<SubType>> {

  using Super = PostWalker<SubType, UnifiedExpressionVisitor<SubType>>;

  std::queue<Expression**> controlFlowQueue;

  /*
   * To initiate the walk, subclasses should call walkModule with a pointer to
   * the wasm module.
   *
   * Member functions addUniqueSymbol and visitExpression are provided as
   * extension points for subclasses. These functions will be called at
   * appropriate points during the walk and should be implemented by subclasses.
   */
  void visitExpression(Expression* curr);
  void addUniqueSymbol();

  void doWalkModule(Module* module);
  void doWalkFunction(Function* func);
  void walk(Expression* curr);
  static void scan(SubType* self, Expression** currp);
  static void doVisitExpression(SubType* self, Expression** currp);

private:
  void dequeueControlFlow();
};

} // namespace wasm

#include "stringify-walker-impl.h"

namespace wasm {

struct StringifyHasher {
  size_t operator()(Expression* curr) const {
    if (Properties::isControlFlowStructure(curr)) {
      if (auto* iff = curr->dynCast<If>()) {
        return hashIfNoCondition(iff);
      }

      return ExpressionAnalyzer::hash(curr);
    }

    return ExpressionAnalyzer::shallowHash(curr);
  }

  static uint64_t hashIfNoCondition(If* iff) {
    size_t digest = wasm::hash(0);
    rehash(digest, iff->_id);
    rehash(digest, iff->type.getID());
    rehash(digest, ExpressionAnalyzer::hash(iff->ifTrue));
    rehash(digest, iff->ifTrue->_id);
    rehash(digest, iff->ifTrue->type.getID());

    if (iff->ifFalse) {
      rehash(digest, ExpressionAnalyzer::hash(iff->ifFalse));
      rehash(digest, iff->ifFalse->_id);
      rehash(digest, iff->ifFalse->type.getID());
    }

    return digest;
  }
};

struct StringifyEquator {
  bool operator()(Expression* lhs, Expression* rhs) const {
    if (Properties::isControlFlowStructure(lhs) &&
        Properties::isControlFlowStructure(rhs)) {
      auto* iffl = lhs->dynCast<If>();
      auto* iffr = rhs->dynCast<If>();

      if (iffl && iffr) {
        return equalIfNoCondition(iffl, iffr);
      }

      return ExpressionAnalyzer::equal(lhs, rhs);
    }

    return ExpressionAnalyzer::shallowEqual(lhs, rhs);
  }

  bool equalIfNoCondition(If* iffl, If* iffr) const {
    return ExpressionAnalyzer::equal(iffl->ifTrue, iffr->ifTrue) &&
           ExpressionAnalyzer::equal(iffl->ifFalse, iffr->ifFalse);
  }
};

struct HashStringifyWalker : public StringifyWalker<HashStringifyWalker> {
  // After calling walkModule, this vector contains the result of encoding a
  // wasm module as a string
  std::vector<uint64_t> hashString;
  uint64_t monotonic = 0;
  // Contains a mapping of expression pointer to monotonic value to ensure we
  // use the same monotonic value for matching expressions.
  std::unordered_map<Expression*, uint64_t, StringifyHasher, StringifyEquator>
    exprToCounter;

  void addUniqueSymbol();
  void visitExpression(Expression* curr);
};

} // namespace wasm

#include "hash-stringify-walker-impl.h"

#endif // wasm_passes_stringify_walker_h
