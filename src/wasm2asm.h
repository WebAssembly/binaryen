
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

public:
  Asm2WasmBuilder(MixedArena& allocator) : allocator(allocator) {}

  Ref processWasm(Module* wasm);
  Ref processFunction(Function* func);

  // @param result Whether the context we are in receives a value,
  //               and its type, or if not, then we can drop our return,
  //               if we have one.
  Ref processExpression(Expression* curr, WasmType result);

  Ref processTypedExpression(Expression* curr) {
    return processExpression(curr, curr->type);
  }

  // Get a temp var.
  IString getTemp(WasmType type);
  // Free a temp var.
  void freeTemp(IString temp);
  // Get and immediately free a temp var.
  IString getTempAndFree(WasmType type);

  // break and continue stacks
  void pushBreak(Name name) {
    breakStack.push_back(name);
  }
  void popBreak() {
    breakStack.pop_back();
  }
  void pushContinue(Name name) {
    continueStack.push_back(name);
  }
  void popContinue() {
    continueStack.pop_back();
  }

  IString fromName(Name name) {
    return name; // TODO: add a "$" or other prefixing? sanitization of bad chars?
  }

private:
  // How many temp vars we need
  int i32s = 0, f32s = 0, f64s = 0;
  // Which are currently free to use
  std::vector<int> i32sFree, f32sFree, f64sFree;

  std::vector<Name> breakStack;
  std::vector<Name> continueStack;
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
  ret[3]->push_back(processExpression(func->body, func->result));
  // locals, including new temp locals XXX
  // checks
  assert(breakStack.empty() && continueStack.empty());
  assert(i32sFree.size() == i32s); // all temp vars should be free at the end
  assert(f32sFree.size() == f32s);
  assert(f64sFree.size() == f64s);
  return ret;
}

Ref Wasm2AsmBuilder::processExpression(Expression* curr) {
  struct ExpressionProcessor : public WasmVisitor<Ref> {
    Wasm2AsmBuilder* parent;
    WasmType result;
    ExpressionProcessor(Wasm2AsmBuilder* parent, WasmType result) : parent(parent), result(result) {}

    bool isStatement(Ref ast) {
      if (!ast) return false;
      IString what = ast[0]->getIString();
      return what == BLOCK || what == BREAK || what == IF || what == DO;
    }

    // Expressions with control flow turn into a block, which we must
    // then handle, even if we are an expression.
    bool isBlock(Ref ast) {
      return !!ast && ast[0] == BLOCK;
    }

    // Looks for a standard assign at the end of a block, which if this
    // block returns a value, it will have.
    Ref getBlockAssign(Ref ast) {
      if (!(ast.size() >= 2 && ast[1].size() > 0)) return Ref();
      Ref last = deStat(ast[1][ast[1].size()-1]);
      if (!(last[0] == ASSIGN && last[2][0] == NAME)) return Ref();
      return last;
    }

    // If we replace an expression with a block, and we need to return
    // a value, it will show up in the last element, as an assign. This
    // returns it.
    IString getBlockValue(Ref ast) {
      Ref assign = getBlockAssign(ast);
      assert(!!assign);
      return assign[2][1]->getIString();
    }

    Ref blockify(Ref ast) {
      if (isBlock(ast)) return ast;
      Ref ret = ValueBuilder::makeBlock();
      ret[1]->push_back(ast);
      return ret;
    }

    Ref blockifyWithTemp(Ref ast, IString temp) {
      if (isBlock(ast)) {
        Ref assign = getBlockAssign(ast);
        assert(!!assign); // if a block, must have a value returned
        assign[2][1]->setString(temp); // replace existing assign target
        return ast;
      }
      // not a block, so an expression. Just assign to the temp var.
      Ref ret = ValueBuilder::makeBlock();
      ret[1]->push_back(makeAssign(makeName(temp), ast));
      return ret;
    }

    Ref blockifyWithResult(Ref ast, WasmType type) {
      return blockifyWithTemp(ast, parent->getTemp(type));
    }

    // Visitors

    void visitBlock(Block *curr) override {
      Ref ret = ValueBuilder::makeBlock();
      size_t size = curr->list.size();
      for (size_t i = 0; i < size; i++) {
        ret[1]->push_back(processExpression(func->body, i < size-1 ? false : result);
      }
      return ret;
    }
    void visitIf(If *curr) override {
      assert(result ? !!curr->ifFalse : true); // an if without an else cannot be in a receiving context
      Ref condition = processTypedExpression(curr->condition);
      Ref ifTrue = processExpression(curr->ifTrue, result);
      Ref ifFalse;
      if (curr->ifFalse) {
        ifFalse = processExpression(curr->ifFalse, result);
      }
      if (result != none) {
        IString temp = parent->getTempAndFree(result);
        ifTrue = blockifyWithTemp(ifTrue, temp);
        if (curr->ifFalse) ifFalse = blockifyWithTemp(ifFalse, temp);
      }
      if (!isStatement(condition)) {
        return ValueBuilder::makeIf(condition, ifTrue, ifFalse); // simple if
      }
      condition = blockify(condition);
      // just add an if to the block
      condition[1]->push_back(ValueBuilder::makeIf(getBlockValue(condition), ifTrue, ifFalse));
      return condition;
    }
    void visitLoop(Loop *curr) override {
      if (curr->out.is()) parent->pushBreak(curr->out);
      if (curr->in.is()) parent->pushContinue(curr->in);
      Ref body = processExpression(curr->body, none);
      if (curr->in.is()) parent->popContinue();
      if (curr->out.is()) parent->popBreak();
      return ValueBuilder::makeDo(body, ValueBuilder::makeInt(0));
    }
    void visitLabel(Label *curr) override {
      assert(result == none);
      parent->pushBreak(curr->name);
      Ref ret = ValueBuilder::makeLabel(fromName(curr->name), blockify(processExpression(curr->body, none)));
      parent->popBreak();
      return ret;
    }
    void visitBreak(Break *curr) override {
      Ref theBreak = ValueBuilder::makeBreak(fromName(curr->name));
      if (!curr->condition && !curr->value) {
        return theBreak;
      }
      Ref ret = ValueBuilder::makeBlock();
      Ref condition;
      if (curr->condition) {
        condition = processTypedExpression(curr->condition);
      }
      Ref value;
      if (curr->value) {
        value = processTypedExpression(curr->value);
        value = blockifyWithResult(value);
        value[1]->push_back(theBreak);
        theBreak = value; // theBreak now sets the return value, then breaks
      }
      if (!condition) return theBreak;
      if (!isStatement(condition)) {
        return ValueBuilder::makeIf(condition, theBreak, Ref());
      }
      condition = blockify(condition);
      condition[1]->push_back(ValueBuilder::makeIf(getBlockValue(condition), theBreak, Ref()));
      return condition;
    }
    void visitSwitch(Switch *curr) override {
      abort();
    }
    void visitCall(Call *curr) override {
      std::vector<Ref> operands;
      bool hasStatement = false;
      for (auto operand : curr->operands) {
        Ref temp = processTypedExpression(curr->value);
        temp = temp || isStatement(temp)
        operands.push_back(temp);
      }
      // if any is statement, we must statementize them all
      if (hasStatement) {
        for (auto& operand : operands) {
          operand = blockifyWithTemp(// XXX);
        }
      }
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
  return ExpressionProcessor(this, result).visit(curr);
}

} // namespace wasm

