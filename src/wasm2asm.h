
//
// WebAssembly-to-asm.js translator. Uses the Emscripten optimizer
// infrastructure.
//

#include "wasm.h"
#include "emscripten-optimizer/optimizer.h"
#include "mixed_arena.h"

namespace wasm {

using namespace cashew;

IString ASM_FUNC("asmFunc");

//
// Wasm2AsmBuilder - converts a WebAssembly module into asm.js
//

class Wasm2AsmBuilder {
  MixedArena& allocator;

  // How many temp vars we need
  int i32s = 0, f32s = 0, f64s = 0;

public:
  Asm2WasmBuilder(MixedArena& allocator) : allocator(allocator) {}

  Ref processWasm(Module* wasm);
  Ref processFunction(Function* func);

  //
  // Tracks state while converting a function. We need to add new
  // temporaries, and overall handle the fact that statements ==
  // expressions in wasm, but not asm.js. That means that a wasm
  // expression may be turned into an asm.js statement, which we
  // cannot just place into an expression, but need to keep
  // creating statements until we reach a statement context.
  //

  // @param receives Whether the context we are in receives a value, or if not,
  //                 then we can drop our return, if we have one.
  Ref processExpression(Expression* curr, bool XXX WasmType receives);
};

Ref Wasm2AsmBuilder::processWasm(Module* wasm) {
  Ref ret = ValueBuilder::makeTopLevel();
  Ref asmFunc = ValueBuilder::makeFunction();
  asmFunc[1] = ValueBuilder::makeRawString(ASM_FUNC);
  ret[1]->push_back(asmFunc);
  // imports XXX
  // exports XXX
  // functions
  for (auto func : wasm->functions) {
    asmFunc[3]->push_back(processFunction(func));
  }
  // table XXX
  // memory XXX
  return ret;
}

Ref Wasm2AsmBuilder::processFunction(Function* func) {
  Ref ret = ValueBuilder::makeFunction();
  ret[1] = ValueBuilder::makeRawString(func->name);
  // arguments XXX
  // body
  ret[3]->push_back(processExpression(func->body, func->result != none));
  // locals, including new temp locals XXX
  return ret;
}

Ref Wasm2AsmBuilder::processExpression(Expression* curr) {
  struct ExpressionProcessor : public WasmVisitor<Ref> {
    bool receives;
    ExpressionProcessor(bool receives) : receives(receives) {}

    // Expressions with control flow turn into a block, which we must
    // then handle, even if we are an expression.
    bool isBlock(Ref ast) {
      return ast[0] == BLOCK;
    }

    // If we replace an expression with a block, and we need to return
    // a value, it will show up in the last element, as an assign. This
    // returns it.
    IString getBlockValue(Ref ast) {
      assert(ast.size() >= 2 && ast[1].size() > 0);
      Ref last = deStat(ast[1][ast[1].size()-1]);
      assert(last[0] == ASSIGN && last[2][0] == NAME);
      return last[2][1]->getIString();
    }

    Ref blockify(Ref ast) {
      if (isBlock(ast)) return ast;
      Ref ret = ValueBuilder::makeBlock();
      ret[1]->push_back(ast);
      return ret;
    }

    Ref blockifyWithValue(Ref ast) {
      if (isBlock(ast)) return ast;
      Ref ret = ValueBuilder::makeBlock();
      ret[1]->push_back(ast);
      return ret;
    }

    // Visitors

    void visitBlock(Block *curr) override {
      Ref ret = ValueBuilder::makeBlock();
      size_t size = curr->list.size();
      for (size_t i = 0; i < size; i++) {
        ret[1]->push_back(processExpression(func->body, i < size-1 ? false : receives);
      }
      return ret;
    }
    void visitIf(If *curr) override {
      assert(receives ? !!curr->ifFalse : true); // an if without an else cannot be in a receiving context
      Ref condition = processExpression(curr->condition, receives);
      Ref ifTrue = processExpression(curr->ifTrue, receives);
      Ref ifFalse;
      if (curr->ifFalse) {
        ifFalse = processExpression(curr->ifFalse, receives);
      }
      if (!isBlock(condition) && !receives) {
        return ValueBuilder::makeIf(condition, ifTrue, ifFalse); // simple if
      }
      if (receives) {
        IString parent->getTemp();
        ifTrue = blockifyWithValue(ifTrue);
        ifFalse = blockifyWithValue(ifFalse);
      }
      condition = blockify(blockify);
        // just add an if to the block
        IString check = getBlockValue(condition);
        condition[1]->push_back(ValueBuilder::makeIf(condition, ifTrue, ifFalse));
        return condition;
      if (isBlock(condition)) {
      }
    }
    void visitLoop(Loop *curr) override {
    }
    void visitLabel(Label *curr) override {
    }
    void visitBreak(Break *curr) override {
    }
    void visitSwitch(Switch *curr) override {
    }
    void visitCall(Call *curr) override {
    }
    void visitCallImport(CallImport *curr) override {
    }
    void visitCallIndirect(CallIndirect *curr) override {
    }
    void visitGetLocal(GetLocal *curr) override {
    }
    void visitSetLocal(SetLocal *curr) override {
    }
    void visitLoad(Load *curr) override {
    }
    void visitStore(Store *curr) override {
    }
    void visitConst(Const *curr) override {
    }
    void visitUnary(Unary *curr) override {
    }
    void visitBinary(Binary *curr) override {
    }
    void visitCompare(Compare *curr) override {
    }
    void visitConvert(Convert *curr) override {
    }
    void visitSelect(Select *curr) override {
    }
    void visitHost(Host *curr) override {
    }
    void visitNop(Nop *curr) override {
    }
    void visitUnreachable(Unreachable *curr) override {
    }
  };
  return ExpressionProcessor(state).visit(curr);
}

} // namespace wasm

