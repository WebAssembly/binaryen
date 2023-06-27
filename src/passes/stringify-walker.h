#ifndef wasm_passes_stringify_walker_h
#define wasm_passes_stringify_walker_h

#include "ir/module-utils.h"
#include "wasm-traversal.h"
#include <queue>

namespace wasm {

/*
 * This walker performs a shallow visit of control-flow (try, if, block, loop)
 * expressions and their simple expression siblings before then visiting the
 * children of each control-flow expression in postorder. As a result, this
 * walker un-nests nested control flow structures, so the expression visit order
 * does not correspond to a normal postorder traversal of the function.
 *
 * For example, the below (contrived) wat:
 * 1: (block
 * 2:   (drop
 * 3:     (i32.add
 * 4:       (i32.const 20)
 * 5:       (i32.const 10)))
 * 6:   (if
 * 7:     (i32.const 0)
 * 8:     (then (return (i32.const 1)))
 * 9:     (else (return (i32.const 0)))))
 *
 * Would have its expressions visited in the following order (based on line
 * number):
 * 1, 4, 5, 3, 2, 7, 6, 8, 9
 *
 * Of note:
 *   - The add (line 3) binary operator's left and right children (lines 4 - 5)
 *     are visited first as they need to be on the stack before the add
 *     operation is executed
 *   - The if-condition (i32.const 0) on line 7 is visited before the if
 *     expression
 */

template<typename SubType>
struct StringifyWalker
  : public PostWalker<SubType, UnifiedExpressionVisitor<SubType>> {

  Module* wasm;
  std::queue<Expression**> controlFlowQueue;

  // Subclasses are meant to implement visitExpression and addUniqueSymbol
  void visitExpression(Expression* curr);
  static void addUniqueSymbol(SubType* self, Expression** currp);

  void walkModule(Module* module);
  static void scan(SubType* self, Expression** currp);
  static void doVisitExpression(SubType* self, Expression** currp);

private:
  static void dequeueControlFlow(SubType* self, Expression**);
  static void deferredScan(SubType* self, Expression** currp);
};

} // namespace wasm

#include "stringify-walker-impl.h"

#endif // wasm_passes_stringify_walker_h
