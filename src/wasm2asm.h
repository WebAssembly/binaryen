
//
// WebAssembly-to-asm.js translator. Uses the Emscripten optimizer
// infrastructure.
//

#include "wasm.h"
#include "emscripten-optimizer/optimizer.h"
#include "mixed_arena.h"

namespace wasm {

using namespace cashew;

IString ASM_FUNC("asmFunc"),
        NO_RESULT("wasm2asm$noresult"), // no result at all
        EXPRESSION_RESULT("wasm2asm$expresult"); // result in an expression, no temp var

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
  Ref processFunctionBody(Expression* curr, IString result);

  // Get a temp var.
  IString getTemp(WasmType type);
  // Free a temp var.
  void freeTemp(IString temp);

  IString fromName(Name name) {
    return name; // TODO: add a "$" or other prefixing? sanitization of bad chars?
  }

  void setStatement(Expression* curr) {
    willBeStatement.insert(curr);
  }
  bool isStatement(Expression* curr) {
    return curr && willBeStatement.find(curr) != willBeStatement.end();
  }

  void setBreakedWithValue(Name name) { // XXX needed? maybe we should just fill breakResults unconditionally?
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
  IString result = func->result != none ? getTemp(func->result) : NO_RESULT;
  ret[3]->push_back(processFunctionBody(func->body, result));
  if (result != NO_RESULT) freeTemp(result);
  // locals, including new temp locals XXX
  // checks
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

Ref Wasm2AsmBuilder::processFunctionBody(Expression* curr, IString result) {
  struct ExpressionProcessor : public WasmVisitor<Ref> {
    Wasm2AsmBuilder* parent;
    IString result;
    ExpressionProcessor(Wasm2AsmBuilder* parent) : parent(parent) {}

    struct ScopedTemp {
      Wasm2AsmBuilder* parent;
      IString temp;
      ScopedTemp(WasmType type, Wasm2AsmBuilder* parent) : parent(parent) {
        temp = parent->getTemp(type);
      }
      ~ScopedTemp() {
        parent->freeTemp(temp);
      }
    };

    Ref visit(Expression* curr, IString nextResult) {
      IString old = result;
      result = nextResult;
      Ref ret = visit(curr);
      result = old; // keep it consistent for the rest of this frame, which may call visit on multiple children
      return ret;
    }

    Ast visit(Expression* curr, ScopedTemp& temp) {
      return visit(curr, temp.temp);
    }

    Ref visitForExpression(Expression* curr, WasmType type, IString& tempName) { // this result is for an asm expression slot, but it might be a statement
      if (isStatement(curr)) {
        ScopedTemp temp(type, parent);
        tempName = temp.temp;
        return visit(curr, temp);
      } else {
        return visitExpression(curr, EXPRESSION_RESULT);
      }
    }

    Ref visitAndAssign(Expression* curr, IString result) {
      Ref ret = visit(curr, result);
      // if it's not already a statement, then it's an expression, and we need to assign it
      // (if it is a statement, it already assigns to the result var)
      if (!isStatement(curr)) {
        ret = ValueBuilder::makeStatement(ValueBuilder::makeAssign(makeName(result), ret)));
      }
      return ret;
    }

    bool isStatement(Expression* curr) {
      return parent->isStatement(curr);
    }

    // Expressions with control flow turn into a block, which we must
    // then handle, even if we are an expression.
    bool isBlock(Ref ast) { // XXX needed?
      return !!ast && ast[0] == BLOCK;
    }

    // Looks for a standard assign at the end of a block, which if this
    // block returns a value, it will have.
    Ref getBlockAssign(Ref ast) { // XXX needed?
      if (!(ast.size() >= 2 && ast[1].size() > 0)) return Ref();
      Ref last = deStat(ast[1][ast[1].size()-1]);
      if (!(last[0] == ASSIGN && last[2][0] == NAME)) return Ref();
      return last;
    }

    // If we replace an expression with a block, and we need to return
    // a value, it will show up in the last element, as an assign. This
    // returns it.
    IString getBlockValue(Ref ast) { // XXX needed?
      Ref assign = getBlockAssign(ast);
      assert(!!assign);
      return assign[2][1]->getIString();
    }

    Ref blockify(Ref ast) { // XXX needed?
      if (isBlock(ast)) return ast;
      Ref ret = ValueBuilder::makeBlock();
      ret[1]->push_back(ast);
      return ret;
    }

    Ref blockifyWithTemp(Ref ast, IString temp) { // XXX needed?
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

    Ref blockifyWithResult(Ref ast, WasmType type) { // XXX needed?
      return blockifyWithTemp(ast, parent->getTemp(type));
    }

    // For spooky return-at-a-distance/break-with-result, this tells us
    // what the result var is for a specific label.
    std::map<Name, IString> breakResults;

    // Breaks to the top of a loop should be emitted as continues, to that loop's main label
    std::map<Name, Name> actualBreakLabel;

    Name getActualBreakLabel(Name name) {
      auto iter = actualBreakLabel.find(name);
      if (iter == actualBreakLabel.end()) return name;
      return iter->second;
    }

    // Visitors

    void visitBlock(Block *curr) override {
      breakResults[curr->name] = result;
      Ref ret = ValueBuilder::makeBlock();
      size_t size = curr->list.size();
      for (size_t i = 0; i < size; i++) {
        // TODO: flatten out, if we receive a block, just insert the elements
        ret[1]->push_back(visit(curr->list[i], i < size-1 ? none : result);
      }
      if (curr->name.is()) {
        ret = ValueBuilder::makeLabel(fromName(curr->name), ret);
      }
      return ret;
    }
    void visitIf(If *curr) override {
      IString temp;
      Ref condition = visitForExpression(curr->condition, i32, temp);
      Ref ifTrue = visit(curr->ifTrue, result);
      Ref ifFalse;
      if (curr->ifFalse) {
        ifFalse = visit(curr->ifFalse, result);
      }
      if (temp.isNull()) {
        return ValueBuilder::makeIf(condition, ifTrue, ifFalse); // simple if
      }
      condition = blockify(condition);
      // just add an if to the block
      condition[1]->push_back(ValueBuilder::makeIf(ValueBuilder::makeName(temp), ifTrue, ifFalse));
      return condition;
    }
    void visitLoop(Loop *curr) override {
      Name asmLabel = curr->out.is() ? curr->out : curr->in; // label using the outside, normal for breaks. if no outside, then inside
      if (curr->in.is()) continues[curr->in] = asmLabel;
      Ref body = visit(curr->body, result);
      if (asmLabel.is()) {
        body = ValueBuilder::makeLabel(fromName(asmLabel), body);
      }
      return ValueBuilder::makeDo(body, ValueBuilder::makeInt(0));
    }
    void visitLabel(Label *curr) override {
      return ValueBuilder::makeLabel(fromName(curr->name), visit(curr->body, result)));
    }
    void visitBreak(Break *curr) override {
      if (curr->condition) {
        // we need an equivalent to an if here, so use that code
        Break fakeBreak = *curr;
        fakeBreak->condition = nullptr;
        If fakeIf;
        fakeIf.condition = curr->condition;
        fakeIf.ifTrue = fakeBreak;
        return visit(fake, result);
      }
      Ref theBreak = ValueBuilder::makeBreak(fromName(getActualBreakLabel(curr->name)));
      if (!curr->value) return theBreak;
      // generate the value, including assigning to the result, and then do the break
      Ref ret = visitAndAssign(curr->value, result);
      ret = blockify(ret);
      ret[1]->push_back(theBreak);
      return ret;
    }
    void visitSwitch(Switch *curr) override {
      abort(); // XXX TODO
    }
    void visitCall(Call *curr) override {
      Ref theCall = ValueBuilder::makeCall(fromName(curr->target));
      if (!isStatement(curr)) {
        // none of our operands is a statement; go right ahead and create a simple expression
        Ref theCall = ValueBuilder::makeCall(fromName(curr->target));
        for (auto operand : curr->operands) {
          theCall[2]->push_back(visit(operand, EXPRESSION_RESULT));
        }
        return theCall;
      }
      // we must statementize them all
      Ref ret = ValueBuilder::makeBlock();
      std::vector<ScopedTemp> temps;
      for (auto& operand : operands) {
        temps.emplace_back(operand->type, parent);
        IString temp = temps.back().temp;
        ret[1]->push_back(visitAndAssign(operand, temp));
        theCall[2]->push_back(makeName(temp));
      }
      if (result != NO_RESULT) {
        theCall = ValueBuilder::makeAssign(ValueBuilder::makeName(result), theCall);
      }
      ret[1]->push_back(theCall);
      return ret;
    }
    void visitCallImport(CallImport *curr) override {
      return visitCall(curr);
    }
    void visitCallIndirect(CallIndirect *curr) override {
      abort(); // XXX TODO
    }
    void visitGetLocal(GetLocal *curr) override {
      return ValueBuilder::makeName(fromName(curr->name));
    }
    void visitSetLocal(SetLocal *curr) override {
      if (!isStatement(curr)) {
        return ValueBuilder::makeAssign(ValueBuilder::makeName(fromName(curr->name)), visit(curr->value, EXPRESSION_RESULT));
      }
      Ref ret = blockify(visit(curr->value, result));
      // the output was assigned to result, so we can just assign it to our target
      ret[1]->push_back(ValueBuilder::makeAssign(ValueBuilder::makeName(fromName(curr->name)), ValueBuilder::makeName(result)));
      return ret;
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
  return ExpressionProcessor(this).visit(curr, result);
}

} // namespace wasm

