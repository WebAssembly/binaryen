
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
// In general, asm.js => wasm is very straightforward, as can
// be seen in asm2wasm.h. Just a single pass, plus a little
// state bookkeeping (breakStack, etc.), and a few after-the
// fact corrections for imports, etc. However, wasm => asm.js
// is tricky because wasm has statements == expressions, or in
// other words, things like `break` and `if` can show up
// in places where asm.js can't handle them, like inside an
// a loop's condition check.
//
// We therefore need the ability to lower an expression into
// a block of statements, and we keep statementizing until we
// reach a context in which we can emit those statments. This
// requires that we create temp variables to store values
// that would otherwise flow directly into their targets if
// we were an expression (e.g. if a loop's condition check
// is a bunch of statements, we execute those statements,
// then use the computed value in the loop's condition;
// we might also be able to avoid an assign to a temp var
// at the end of those statements, and put just that
// value in the loop's condition).
//
// It is possible to do this in a single pass, if we just
// allocate temp vars freely. However, pathological cases
// can easily show bad behavior here, with many unnecessary
// temp vars. We could rely on optimization passes like
// Emscripten's eliminate/registerize pair, but we want
// wasm2asm to be fairly fast to run, as it might run on
// the client.
//
// The approach taken here therefore performs 2 passes on
// each function. First, it finds which expression will need to
// be statementized. It also sees which labels can receive a break
// with a value. Given that information, in the second pass we can
// allocate // temp vars in an efficient manner, as we know when we
// need them and when their use is finished. They are allocated
// using an RAII class, so that they are automatically freed
// when the scope ends. This means that a node cannot allocate
// its own temp var; instead, the parent - which knows the
// child will return a value in a temp var - allocates it,
// and tells the child what temp var to emit to. The child
// can then pass forward that temp var to its children,
// optimizing away unnecessary forwarding.


class Wasm2AsmBuilder {
  MixedArena& allocator;

public:
  Asm2WasmBuilder(MixedArena& allocator) : allocator(allocator) {}

  Ref processWasm(Module* wasm);
  Ref processFunction(Function* func);

  // The first pass on an expression: scan it to see whether it will
  // need to be statementized, and note spooky returns of values at
  // a distance (aka break with a value).
  bool scanFunctionBody(Expression* curr);

  // The second pass on an expression: process it fully, generating
  // asm.js
  // @param result Whether the context we are in receives a value,
  //               and its type, or if not, then we can drop our return,
  //               if we have one.
  Ref processFunctionBody(Expression* curr, WasmType result);

  Ref XXX processTypedExpression(Expression* curr) {
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

  void setStatement(Expression* curr) {
    willBeStatement.insert(curr);
  }
  bool isStatement(Expression* curr) {
    return curr && willBeStatement.find(curr) != willBeStatement.end();
  }

  void setBreakedWithValue(Name name) {
    breakedWithValue.insert(name);
  }
  bool isBreakedWithValue(Name name) {
    return breakedWithValue.find(name) != breakedWithValue.end();
  }

private:
  // How many temp vars we need
  int i32s = 0, f32s = 0, f64s = 0;
  // Which are currently free to use
  std::vector<int> i32sFree, f32sFree, f64sFree;

  // Expressions that will be a statement.
  std::set<Expression*> willBeStatement;

  // Label names to which we break with a value aka spooky-return-at-a-distance
  std::set<Name> breakedWithValue;

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
  scanFunctionBody(func->body);
  ret[3]->push_back(processFunctionBody(func->body, func->result));
  // locals, including new temp locals XXX
  // checks
  assert(breakStack.empty() && continueStack.empty());
  assert(i32sFree.size() == i32s); // all temp vars should be free at the end
  assert(f32sFree.size() == f32s);
  assert(f64sFree.size() == f64s);
  // cleanups
  willBeStatement.clear();
  return ret;
}

void Wasm2AsmBuilder::scanFunctionBody(Expression* curr) {
  struct ExpressionScanner : public WasmWalker {
    ExpressionScanner(Wasm2AsmBuilder* parent) : parent(parent) {}

    // Visitors

    void visitBlock(Block *curr) override {
      parent->setStatement(curr);
    }
    void visitIf(If *curr) override {
      parent->setStatement(curr);
    }
    void visitLoop(Loop *curr) override {
      parent->setStatement(curr);
    }
    void visitLabel(Label *curr) override {
      parent->setStatement(curr);
    }
    void visitBreak(Break *curr) override {
      if (curr->value) {
        // spooky return-at-a-distance
        parent->setBreakedWithValue(curr->name);
      }
      parent->setStatement(curr);
    }
    void visitSwitch(Switch *curr) override {
      parent->setStatement(curr);
    }
    void visitCall(Call *curr) override {
      for (auto item : curr->operands) {
        if (parent->isStatement(item)) {
          parent->setStatement(curr);
          break;
        }
      }
    }
    void visitCallImport(CallImport *curr) override {
      visitCall(curr);
    }
    void visitCallIndirect(CallIndirect *curr) override {
      if (parent->isStatement(curr->target)) {
        parent->setStatement(curr);
        return;
      }
      for (auto item : curr->operands) {
        if (parent->isStatement(item)) {
          parent->setStatement(curr);
          break;
        }
      }
    }
    void visitSetLocal(SetLocal *curr) override {
      if (parent->isStatement(curr->value)) {
        parent->setStatement(curr);
      }
    }
    void visitLoad(Load *curr) override {
      if (parent->isStatement(curr->ptr)) {
        parent->setStatement(curr);
      }
    }
    void visitStore(Store *curr) override {
      if (parent->isStatement(curr->ptr) || parent->isStatement(curr->value)) {
        parent->setStatement(curr);
      }
    }
    void visitUnary(Unary *curr) override {
      if (parent->isStatement(curr->value)) {
        parent->setStatement(curr);
      }
    }
    void visitBinary(Binary *curr) override {
      if (parent->isStatement(curr->left) || parent->isStatement(curr->right)) {
        parent->setStatement(curr);
      }
    }
    void visitCompare(Compare *curr) override {
      if (parent->isStatement(curr->left) || parent->isStatement(curr->right)) {
        parent->setStatement(curr);
      }
    }
    void visitConvert(Convert *curr) override {
      if (parent->isStatement(curr->value)) {
        parent->setStatement(curr);
      }
    }
    void visitSelect(Select *curr) override {
      if (parent->isStatement(curr->condition) || parent->isStatement(curr->ifTrue) || parent->isStatement(curr->ifFalse)) {
        parent->setStatement(curr);
      }
    }
    void visitHost(Host *curr) override {
      for (auto item : curr->operands) {
        if (parent->isStatement(item)) {
          parent->setStatement(curr);
          break;
        }
      }
    }
  };
  ExpressionScanner(this).visit(curr);
}

Ref Wasm2AsmBuilder::processFunctionBody(Expression* curr) {
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
        ret[1]->push_back(processExpression( XXX func->body XXX , i < size-1 ? false : result);
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

