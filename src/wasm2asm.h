
//
// WebAssembly-to-asm.js translator. Uses the Emscripten optimizer
// infrastructure.
//

#include "wasm.h"
#include "emscripten-optimizer/optimizer.h"
#include "mixed_arena.h"
#include "asm_v_wasm.h"
#include "shared-constants.h"

namespace wasm {

using namespace cashew;

IString ASM_FUNC("asmFunc"),
        ABORT_FUNC("abort"),
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
public:
  Ref processWasm(Module* wasm);
  Ref processFunction(Function* func);

  // The first pass on an expression: scan it to see whether it will
  // need to be statementized, and note spooky returns of values at
  // a distance (aka break with a value).
  void scanFunctionBody(Expression* curr);

  // The second pass on an expression: process it fully, generating
  // asm.js
  // @param result Whether the context we are in receives a value,
  //               and its type, or if not, then we can drop our return,
  //               if we have one.
  Ref processFunctionBody(Expression* curr, IString result);

  // Get a temp var.
  IString getTemp(WasmType type) {
    if (frees[type].size() > 0) {
      IString ret = frees[type].back();
      frees[type].pop_back();
      return ret;
    }
    size_t index = temps[type]++;
    return IString((std::string("wasm2asm_") + printWasmType(type) + "$" + std::to_string(index)).c_str(), false);
  }
  // Free a temp var.
  void freeTemp(WasmType type, IString temp) {
    frees[type].push_back(temp);
  }

  static IString fromName(Name name) {
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
  std::vector<int> temps; // type => num temps
  // Which are currently free to use
  std::vector<std::vector<IString>> frees; // type => list of free names

  // Expressions that will be a statement.
  std::set<Expression*> willBeStatement;

  // Label names to which we break with a value aka spooky-return-at-a-distance
  std::set<Name> breakedWithValue;
};

Ref Wasm2AsmBuilder::processWasm(Module* wasm) {
  Ref ret = ValueBuilder::makeToplevel();
  Ref asmFunc = ValueBuilder::makeFunction(ASM_FUNC);
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
  Ref ret = ValueBuilder::makeFunction(fromName(func->name));
  frees.clear();
  frees.resize(std::max(i32, std::max(f32, f64)) + 1);
  temps.clear();
  temps.resize(std::max(i32, std::max(f32, f64)) + 1);
  temps[i32] = temps[f32] = temps[f64] = 0;
  // arguments
  for (auto& param : func->params) {
    IString name = fromName(param.name);
    ValueBuilder::appendArgumentToFunction(ret, name);
    ret[3]->push_back(
      ValueBuilder::makeStatement(
        ValueBuilder::makeAssign(
          ValueBuilder::makeName(name),
          makeAsmCoercion(ValueBuilder::makeName(name), wasmToAsmType(param.type))
        )
      )
    );
  }
  Ref theVar = ValueBuilder::makeVar();
  ret[3]->push_back(theVar);
  // body
  scanFunctionBody(func->body);
  if (isStatement(func->body)) {
    IString result = func->result != none ? getTemp(func->result) : NO_RESULT;
    ret[3]->push_back(processFunctionBody(func->body, result));
    if (result != NO_RESULT) freeTemp(func->result, result);
  } else {
    // whole thing is an expression, just do a return
    ret[3]->push_back(ValueBuilder::makeStatement(ValueBuilder::makeReturn(processFunctionBody(func->body, EXPRESSION_RESULT))));
  }
  // locals, including new temp locals
  for (auto& local : func->locals) {
    ValueBuilder::appendToVar(theVar, fromName(local.name), makeAsmCoercedZero(wasmToAsmType(local.type)));
  }
  for (auto f : frees[i32]) {
    ValueBuilder::appendToVar(theVar, f, makeAsmCoercedZero(ASM_INT));
  }
  for (auto f : frees[f32]) {
    ValueBuilder::appendToVar(theVar, f, makeAsmCoercedZero(ASM_FLOAT));
  }
  for (auto f : frees[f64]) {
    ValueBuilder::appendToVar(theVar, f, makeAsmCoercedZero(ASM_DOUBLE));
  }
  // checks
  assert(frees[i32].size() == temps[i32]); // all temp vars should be free at the end
  assert(frees[f32].size() == temps[f32]); // all temp vars should be free at the end
  assert(frees[f64].size() == temps[f64]); // all temp vars should be free at the end
  // cleanups
  willBeStatement.clear();
  return ret;
}

void Wasm2AsmBuilder::scanFunctionBody(Expression* curr) {
  struct ExpressionScanner : public WasmWalker {
    Wasm2AsmBuilder* parent;

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

    // A scoped temporary variable.
    struct ScopedTemp {
      Wasm2AsmBuilder* parent;
      WasmType type;
      IString temp;
      bool needFree;
      // @param possible if provided, this is a variable we can use as our temp. it has already been
      //                 allocated in a higher scope, and we can just assign to it as our result is
      //                 going there anyhow.
      ScopedTemp(WasmType type, Wasm2AsmBuilder* parent, IString possible = IString()) : parent(parent), type(type) {
        assert(possible != EXPRESSION_RESULT);
        if (possible == NO_RESULT) {
          temp = parent->getTemp(type);
          needFree = true;
        } else {
          temp = possible;
          needFree = false;
        }
      }
      ~ScopedTemp() {
        if (needFree) {
          parent->freeTemp(type, temp);
        }
      }

      IString getName() {
        return temp;
      }
      Ref getAstName() {
        return ValueBuilder::makeName(temp);
      }
    };

    Ref visit(Expression* curr, IString nextResult) {
      IString old = result;
      result = nextResult;
      Ref ret = WasmVisitor::visit(curr);
      result = old; // keep it consistent for the rest of this frame, which may call visit on multiple children
      return ret;
    }

    Ref visit(Expression* curr, ScopedTemp& temp) {
      return visit(curr, temp.temp);
    }

    Ref visitForExpression(Expression* curr, WasmType type, IString& tempName) { // this result is for an asm expression slot, but it might be a statement
      if (isStatement(curr)) {
        ScopedTemp temp(type, parent);
        tempName = temp.temp;
        return visit(curr, temp);
      } else {
        return visit(curr, EXPRESSION_RESULT);
      }
    }

    Ref visitAndAssign(Expression* curr, IString result) {
      Ref ret = visit(curr, result);
      // if it's not already a statement, then it's an expression, and we need to assign it
      // (if it is a statement, it already assigns to the result var)
      if (!isStatement(curr)) {
        ret = ValueBuilder::makeStatement(ValueBuilder::makeAssign(ValueBuilder::makeName(result), ret));
      }
      return ret;
    }

    Ref visitAndAssign(Expression* curr, ScopedTemp& temp) {
      return visitAndAssign(curr, temp.getName());
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
      if (!(ast->size() >= 2 && ast[1]->size() > 0)) return Ref();
      Ref last = deStat(ast[1][ast[1]->size()-1]);
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
      ret[1]->push_back(ValueBuilder::makeAssign(ValueBuilder::makeName(temp), ast));
      return ret;
    }

    Ref blockifyWithResult(Ref ast, WasmType type) { // XXX needed?
      return blockifyWithTemp(ast, parent->getTemp(type));
    }

    // For spooky return-at-a-distance/break-with-result, this tells us
    // what the result var is for a specific label.
    std::map<Name, IString> breakResults;

    // Breaks to the top of a loop should be emitted as continues, to that loop's main label
    std::map<Name, Name> continueLabels;

    IString fromName(Name name) {
      return parent->fromName(name);
    }

    // Visitors

    Ref visitBlock(Block *curr) override {
      breakResults[curr->name] = result;
      Ref ret = ValueBuilder::makeBlock();
      size_t size = curr->list.size();
      for (size_t i = 0; i < size; i++) {
        // TODO: flatten out, if we receive a block, just insert the elements
        ret[1]->push_back(ValueBuilder::makeStatement(visit(curr->list[i], i < size-1 ? NO_RESULT : result)));
      }
      if (curr->name.is()) {
        ret = ValueBuilder::makeLabel(fromName(curr->name), ret);
      }
      return ret;
    }
    Ref visitIf(If *curr) override {
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
    Ref visitLoop(Loop *curr) override {
      Name asmLabel = curr->out.is() ? curr->out : curr->in; // label using the outside, normal for breaks. if no outside, then inside
      if (curr->in.is()) continueLabels[curr->in] = asmLabel;
      Ref body = visit(curr->body, result);
      if (asmLabel.is()) {
        body = ValueBuilder::makeLabel(fromName(asmLabel), body);
      }
      return ValueBuilder::makeDo(body, ValueBuilder::makeInt(0));
    }
    Ref visitLabel(Label *curr) override {
      return ValueBuilder::makeLabel(fromName(curr->name), visit(curr->body, result));
    }
    Ref visitBreak(Break *curr) override {
      if (curr->condition) {
        // we need an equivalent to an if here, so use that code
        Break fakeBreak = *curr;
        fakeBreak.condition = nullptr;
        If fakeIf;
        fakeIf.condition = curr->condition;
        fakeIf.ifTrue = &fakeBreak;
        return visit(&fakeIf, result);
      }
      Ref theBreak;
      auto iter = continueLabels.find(curr->name);
      if (iter == continueLabels.end()) {
        theBreak = ValueBuilder::makeBreak(fromName(curr->name));
      } else {
        theBreak = ValueBuilder::makeContinue(fromName(iter->second));
      }
      if (!curr->value) return theBreak;
      // generate the value, including assigning to the result, and then do the break
      Ref ret = visitAndAssign(curr->value, result);
      ret = blockify(ret);
      ret[1]->push_back(theBreak);
      return ret;
    }
    Ref visitSwitch(Switch *curr) override {
      abort(); // XXX TODO
    }
    Ref visitCall(Call *curr) override {
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
      for (auto& operand : curr->operands) {
        temps.emplace_back(operand->type, parent);
        IString temp = temps.back().temp;
        ret[1]->push_back(visitAndAssign(operand, temp));
        theCall[2]->push_back(ValueBuilder::makeName(temp));
      }
      if (result != NO_RESULT) {
        theCall = ValueBuilder::makeAssign(ValueBuilder::makeName(result), theCall);
      }
      ret[1]->push_back(theCall);
      return ret;
    }
    Ref visitCallImport(CallImport *curr) override {
      return visitCall(curr);
    }
    Ref visitCallIndirect(CallIndirect *curr) override {
      abort(); // XXX TODO
    }
    Ref visitGetLocal(GetLocal *curr) override {
      return ValueBuilder::makeName(fromName(curr->name));
    }
    Ref visitSetLocal(SetLocal *curr) override {
      if (!isStatement(curr)) {
        return ValueBuilder::makeAssign(ValueBuilder::makeName(fromName(curr->name)), visit(curr->value, EXPRESSION_RESULT));
      }
      ScopedTemp temp(curr->type, parent, result); // if result was provided, our child can just assign there. otherwise, allocate a temp for it to assign to.
      Ref ret = blockify(visit(curr->value, temp));
      // the output was assigned to result, so we can just assign it to our target
      ret[1]->push_back(ValueBuilder::makeAssign(ValueBuilder::makeName(fromName(curr->name)), temp.getAstName()));
      return ret;
    }
    Ref visitLoad(Load *curr) override {
      if (isStatement(curr)) {
        ScopedTemp temp(i32, parent);
        GetLocal fakeLocal;
        fakeLocal.name = temp.getName();
        Load fakeLoad = *curr;
        fakeLoad.ptr = &fakeLocal;
        Ref ret = blockify(visitAndAssign(curr->ptr, temp));
        ret[1]->push_back(visit(&fakeLoad, result));
        return ret;
      }
      // normal load
      assert(curr->bytes == curr->align); // TODO: unaligned, i64
      Ref ptr = visit(curr->ptr, EXPRESSION_RESULT);
      switch (curr->type) {
        case i32: {
          switch (curr->bytes) {
            case 1: return ValueBuilder::makeSub(ValueBuilder::makeName(curr->signed_ ? HEAP8  : HEAPU8 ), ValueBuilder::makePtrShift(ptr, 0));
            case 2: return ValueBuilder::makeSub(ValueBuilder::makeName(curr->signed_ ? HEAP16 : HEAPU16), ValueBuilder::makePtrShift(ptr, 1));
            case 4: return ValueBuilder::makeSub(ValueBuilder::makeName(curr->signed_ ? HEAP32 : HEAPU32), ValueBuilder::makePtrShift(ptr, 2));
            default: abort();
          }
        }
        case f32: return ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF32), ValueBuilder::makePtrShift(ptr, 2));
        case f64: return ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF64), ValueBuilder::makePtrShift(ptr, 3));
        default: abort();
      }
    }
    Ref visitStore(Store *curr) override {
      if (isStatement(curr)) {
        ScopedTemp tempPtr(i32, parent);
        ScopedTemp tempValue(curr->type, parent);
        GetLocal fakeLocalPtr;
        fakeLocalPtr.name = tempPtr.getName();
        GetLocal fakeLocalValue;
        fakeLocalValue.name = tempValue.getName();
        Store fakeStore = *curr;
        fakeStore.ptr = &fakeLocalPtr;
        fakeStore.value = &fakeLocalValue;
        Ref ret = blockify(visitAndAssign(curr->ptr, tempPtr));
        ret[1]->push_back(visitAndAssign(curr->value, tempValue));
        ret[1]->push_back(visit(&fakeStore, result));
        return ret;
      }
      // normal store
      assert(curr->bytes == curr->align); // TODO: unaligned, i64
      Ref ptr = visit(curr->ptr, EXPRESSION_RESULT);
      Ref value = visit(curr->value, EXPRESSION_RESULT);
      Ref ret;
      switch (curr->type) {
        case i32: {
          switch (curr->bytes) {
            case 1: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAP8),  ValueBuilder::makePtrShift(ptr, 0)); break;
            case 2: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAP16), ValueBuilder::makePtrShift(ptr, 1)); break;
            case 4: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAP32), ValueBuilder::makePtrShift(ptr, 2)); break;
            default: abort();
          }
        }
        case f32: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF32), ValueBuilder::makePtrShift(ptr, 2)); break;
        case f64: ret = ValueBuilder::makeSub(ValueBuilder::makeName(HEAPF64), ValueBuilder::makePtrShift(ptr, 3)); break;
        default: abort();
      }
      return ValueBuilder::makeAssign(ret, value);
    }
    Ref visitConst(Const *curr) override {
      switch (curr->type) {
        case i32: return ValueBuilder::makeInt(curr->value.i32);
        // TODO: i64. statementize?
        case f32: {
          Ref ret = ValueBuilder::makeCall(MATH_FROUND);
          ret[2]->push_back(ValueBuilder::makeDouble(curr->value.f32));
          return ret;
        }
        case f64: return ValueBuilder::makeDouble(curr->value.f64);
        default: abort();
      }
    }
    Ref visitUnary(Unary *curr) override {
      if (isStatement(curr)) {
        ScopedTemp temp(curr->value->type, parent);
        GetLocal fakeLocal;
        fakeLocal.name = temp.getName();
        Unary fakeUnary = *curr;
        fakeUnary.value = &fakeLocal;
        Ref ret = blockify(visitAndAssign(curr->value, temp));
        ret[1]->push_back(visit(&fakeUnary, result));
        return ret;
      }
      // normal unary
      Ref value = visit(curr->value, EXPRESSION_RESULT);
      switch (curr->type) {
        case i32: {
          switch (curr->op) {
            case Clz:     return ValueBuilder::makeCall(MATH_CLZ32, value);
            case Ctz:     return ValueBuilder::makeCall(MATH_CTZ32, value);
            case Popcnt:  return ValueBuilder::makeCall(MATH_POPCNT32, value);
            default: abort();
          }
        }
        case f64: {
          switch (curr->op) {
            case Neg:           return ValueBuilder::makeBinary(ValueBuilder::makeDouble(0), MINUS, value);
            case Abs:           return ValueBuilder::makeCall(MATH_ABS, value);
            case Ceil:          return ValueBuilder::makeCall(MATH_CEIL, value);
            case Floor:         return ValueBuilder::makeCall(MATH_FLOOR, value);
            case Trunc:         return ValueBuilder::makeCall(MATH_TRUNC, value);
            case Nearest:       return ValueBuilder::makeCall(MATH_NEAREST, value);
            case Sqrt:          return ValueBuilder::makeCall(MATH_SQRT, value);
            case TruncSFloat32: return ValueBuilder::makePrefix(B_NOT, ValueBuilder::makePrefix(B_NOT, value));
            case ConvertSInt32: return ValueBuilder::makePrefix(PLUS, value);
            default: std::cerr << curr->op << '\n'; abort();
          }
        }
        default: abort();
      }
    }
    Ref visitBinary(Binary *curr) override {
      if (isStatement(curr)) {
        ScopedTemp tempLeft(curr->left->type, parent);
        GetLocal fakeLocalLeft;
        fakeLocalLeft.name = tempLeft.getName();
        ScopedTemp tempRight(curr->right->type, parent);
        GetLocal fakeLocalRight;
        fakeLocalRight.name = tempRight.getName();
        Binary fakeBinary = *curr;
        fakeBinary.left = &fakeLocalLeft;
        fakeBinary.right = &fakeLocalRight;
        Ref ret = blockify(visitAndAssign(curr->left, tempLeft));
        ret[1]->push_back(visitAndAssign(curr->right, tempRight));
        ret[1]->push_back(visit(&fakeBinary, result));
        return ret;
      }
      // normal binary
      Ref left = visit(curr->left, EXPRESSION_RESULT);
      Ref right = visit(curr->right, EXPRESSION_RESULT);
      switch (curr->op) {
        case Add:      return ValueBuilder::makeBinary(left, PLUS, right);
        case Sub:      return ValueBuilder::makeBinary(left, MINUS, right);
        case Mul:      return ValueBuilder::makeBinary(left, MUL, right);
        case DivS:     return ValueBuilder::makeBinary(left, DIV, right);
        case DivU:     return ValueBuilder::makeBinary(left, DIV, right);
        case RemS:     return ValueBuilder::makeBinary(left, MOD, right);
        case RemU:     return ValueBuilder::makeBinary(left, MOD, right);
        case And:      return ValueBuilder::makeBinary(left, AND, right);
        case Or:       return ValueBuilder::makeBinary(left, OR, right);
        case Xor:      return ValueBuilder::makeBinary(left, XOR, right);
        case Shl:      return ValueBuilder::makeBinary(left, LSHIFT, right);
        case ShrU:     return ValueBuilder::makeBinary(left, TRSHIFT, right);
        case ShrS:     return ValueBuilder::makeBinary(left, RSHIFT, right);
        case Div:      return ValueBuilder::makeBinary(left, DIV, right);
        case Min:      return ValueBuilder::makeCall(MATH_MIN, left, right);
        case Max:      return ValueBuilder::makeCall(MATH_MAX, left, right);
        case Eq:       return ValueBuilder::makeBinary(left, EQ, right);
        case Ne:       return ValueBuilder::makeBinary(left, NE, right);
        case LtS:      return ValueBuilder::makeBinary(left, LT, right);
        case LtU:      return ValueBuilder::makeBinary(left, LT, right);
        case LeS:      return ValueBuilder::makeBinary(left, LE, right);
        case LeU:      return ValueBuilder::makeBinary(left, LE, right);
        case GtS:      return ValueBuilder::makeBinary(left, GT, right);
        case GtU:      return ValueBuilder::makeBinary(left, GT, right);
        case GeS:      return ValueBuilder::makeBinary(left, GE, right);
        case GeU:      return ValueBuilder::makeBinary(left, GE, right);
        case Lt:       return ValueBuilder::makeBinary(left, LT, right);
        case Le:       return ValueBuilder::makeBinary(left, LE, right);
        case Gt:       return ValueBuilder::makeBinary(left, GT, right);
        case Ge:       return ValueBuilder::makeBinary(left, GE, right);
        default: abort();
      }
    }
    Ref visitSelect(Select *curr) override {
      if (isStatement(curr)) {
        ScopedTemp tempCondition(i32, parent);
        GetLocal fakeCondition;
        fakeCondition.name = tempCondition.getName();
        ScopedTemp tempIfTrue(curr->ifTrue->type, parent);
        GetLocal fakeLocalIfTrue;
        fakeLocalIfTrue.name = tempIfTrue.getName();
        ScopedTemp tempIfFalse(curr->ifFalse->type, parent);
        GetLocal fakeLocalIfFalse;
        fakeLocalIfFalse.name = tempIfFalse.getName();
        Select fakeSelect = *curr;
        fakeSelect.condition = &fakeCondition;
        fakeSelect.ifTrue = &fakeLocalIfTrue;
        fakeSelect.ifFalse = &fakeLocalIfFalse;
        Ref ret = blockify(visitAndAssign(curr->condition, tempCondition));
        ret[1]->push_back(visitAndAssign(curr->ifTrue, tempIfTrue));
        ret[1]->push_back(visitAndAssign(curr->ifFalse, tempIfFalse));
        ret[1]->push_back(visit(&fakeSelect, result));
        return ret;
      }
      // normal select
      Ref condition = visit(curr->condition, EXPRESSION_RESULT);
      Ref ifTrue = visit(curr->ifTrue, EXPRESSION_RESULT);
      Ref ifFalse = visit(curr->ifFalse, EXPRESSION_RESULT);
      ScopedTemp tempCondition(i32, parent),
                 tempIfTrue(curr->type, parent),
                 tempIfFalse(curr->type, parent);
      return
        ValueBuilder::makeSeq(
          ValueBuilder::makeAssign(tempCondition.getAstName(), condition),
          ValueBuilder::makeSeq(
            ValueBuilder::makeAssign(tempIfTrue.getAstName(), ifTrue),
            ValueBuilder::makeSeq(
              ValueBuilder::makeAssign(tempIfFalse.getAstName(), ifFalse),
              ValueBuilder::makeConditional(tempCondition.getAstName(), tempIfTrue.getAstName(), tempIfFalse.getAstName())
            )
          )
        );
    }
    Ref visitHost(Host *curr) override {
      abort();
    }
    Ref visitNop(Nop *curr) override {
      return ValueBuilder::makeToplevel();
    }
    Ref visitUnreachable(Unreachable *curr) override {
      return ValueBuilder::makeCall(ABORT_FUNC);
    }
  };
  return ExpressionProcessor(this).visit(curr, result);
}

} // namespace wasm

