/*
 * Copyright 2025 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "interpreter/interpreter.h"
#include "interpreter/expression-iterator.h"
#include "interpreter/store.h"
#include "wasm-traversal.h"

namespace wasm {

using namespace interpreter;

// Provides access to the interpreter's private store.
class InterpreterImpl {
public:
  static WasmStore& getStore(Interpreter& interpreter) {
    return interpreter.store;
  }
};

namespace {

struct Branch {
  Name label;
};

// TODO: Handle other forms of control flow.
struct Flow : std::variant<std::monostate, Branch> {
  operator bool() { return !std::get_if<std::monostate>(this); }
};

struct ExpressionInterpreter : OverriddenVisitor<ExpressionInterpreter, Flow> {
  Interpreter& parent;
  ExpressionInterpreter(Interpreter& parent) : parent(parent) {}

  WasmStore& store() { return InterpreterImpl::getStore(parent); }
  Frame& frame() { return store().callStack.back(); }
  Instance& instance() { return frame().instance; }

  void push(Literal val) { store().push(val); }
  Literal pop() { return store().pop(); }

  Flow visitNop(Nop* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitBlock(Block* curr) { return {}; }
  Flow visitIf(If* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitLoop(Loop* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitBreak(Break* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSwitch(Switch* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitCall(Call* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitCallIndirect(CallIndirect* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitLocalGet(LocalGet* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitLocalSet(LocalSet* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitGlobalGet(GlobalGet* curr) {
    push(instance().globalValues[curr->name]);
    return {};
  }
  Flow visitGlobalSet(GlobalSet* curr) {
    instance().globalValues[curr->name] = pop();
    return {};
  }
  Flow visitLoad(Load* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStore(Store* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitAtomicRMW(AtomicRMW* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitAtomicCmpxchg(AtomicCmpxchg* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitAtomicWait(AtomicWait* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitAtomicNotify(AtomicNotify* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitAtomicFence(AtomicFence* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitPause(Pause* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSIMDExtract(SIMDExtract* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSIMDReplace(SIMDReplace* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSIMDShuffle(SIMDShuffle* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSIMDTernary(SIMDTernary* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSIMDShift(SIMDShift* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSIMDLoad(SIMDLoad* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    WASM_UNREACHABLE("TODO");
  }
  Flow visitMemoryInit(MemoryInit* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitDataDrop(DataDrop* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitMemoryCopy(MemoryCopy* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitMemoryFill(MemoryFill* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitConst(Const* curr) {
    push(curr->value);
    return {};
  }
  Flow visitUnary(Unary* curr) {
    auto value = pop();
    switch (curr->op) {
      case SqrtFloat32:
      case SqrtFloat64:
        push(value.sqrt());
        return {};
      case CeilFloat32:
      case CeilFloat64:
        push(value.ceil());
        return {};
      case FloorFloat32:
      case FloorFloat64:
        push(value.floor());
        return {};
      case TruncFloat32:
      case TruncFloat64:
        push(value.trunc());
        return {};
      case NearestFloat32:
      case NearestFloat64:
        push(value.nearbyint());
        return {};
      default:
        WASM_UNREACHABLE("TODO");
    }
  }
  Flow visitBinary(Binary* curr) {
    auto rhs = pop();
    auto lhs = pop();
    // TODO: add support for all operations.
    switch (curr->op) {
      case AddInt32:
      case AddInt64:
      case AddFloat32:
      case AddFloat64:
        push(lhs.add(rhs));
        return {};
      case SubInt32:
      case SubInt64:
      case SubFloat32:
      case SubFloat64:
        push(lhs.sub(rhs));
        return {};
      case MulInt32:
      case MulInt64:
      case MulFloat32:
      case MulFloat64:
        push(lhs.mul(rhs));
        return {};
      case DivFloat32:
      case DivFloat64:
        push(lhs.div(rhs));
        return {};
      case AndInt32:
      case AndInt64:
        push(lhs.and_(rhs));
        return {};
      case OrInt32:
      case OrInt64:
        push(lhs.or_(rhs));
        return {};
      case XorInt32:
      case XorInt64:
        push(lhs.xor_(rhs));
        return {};
      case ShlInt32:
      case ShlInt64:
        push(lhs.shl(rhs));
        return {};
      case ShrUInt32:
      case ShrUInt64:
        push(lhs.shrU(rhs));
        return {};
      case ShrSInt32:
      case ShrSInt64:
        push(lhs.shrS(rhs));
        return {};
      case RotLInt32:
      case RotLInt64:
        push(lhs.rotL(rhs));
        return {};
      case RotRInt32:
      case RotRInt64:
        push(lhs.rotR(rhs));
        return {};
      case EqInt32:
      case EqInt64:
      case EqFloat32:
      case EqFloat64:
        push(lhs.eq(rhs));
        return {};
      case LtSInt32:
      case LtSInt64:
        push(lhs.ltS(rhs));
        return {};
      case LtUInt32:
      case LtUInt64:
        push(lhs.ltU(rhs));
        return {};
      case GtSInt32:
      case GtSInt64:
        push(lhs.gtS(rhs));
        return {};
      case GtUInt32:
      case GtUInt64:
        push(lhs.gtU(rhs));
        return {};
      case MinFloat32:
      case MinFloat64:
        push(lhs.min(rhs));
        return {};
      case MaxFloat32:
      case MaxFloat64:
        push(lhs.max(rhs));
        return {};
      default:
        WASM_UNREACHABLE("TODO");
    }
  }
  Flow visitSelect(Select* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitDrop(Drop* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitReturn(Return* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitMemorySize(MemorySize* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitMemoryGrow(MemoryGrow* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitUnreachable(Unreachable* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitPop(Pop* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefNull(RefNull* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefIsNull(RefIsNull* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefFunc(RefFunc* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefEq(RefEq* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTableGet(TableGet* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTableSet(TableSet* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTableSize(TableSize* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTableGrow(TableGrow* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTableFill(TableFill* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTableCopy(TableCopy* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTableInit(TableInit* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitElemDrop(ElemDrop* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTry(Try* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTryTable(TryTable* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitThrow(Throw* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRethrow(Rethrow* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitThrowRef(ThrowRef* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTupleMake(TupleMake* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitTupleExtract(TupleExtract* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefI31(RefI31* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitI31Get(I31Get* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitCallRef(CallRef* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefTest(RefTest* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefCast(RefCast* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefGetDesc(RefGetDesc* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitBrOn(BrOn* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStructNew(StructNew* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStructGet(StructGet* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStructSet(StructSet* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStructRMW(StructRMW* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStructCmpxchg(StructCmpxchg* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayNew(ArrayNew* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayNewData(ArrayNewData* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayNewElem(ArrayNewElem* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayNewFixed(ArrayNewFixed* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayGet(ArrayGet* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArraySet(ArraySet* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayLen(ArrayLen* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayCopy(ArrayCopy* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayFill(ArrayFill* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayInitData(ArrayInitData* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayInitElem(ArrayInitElem* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayRMW(ArrayRMW* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitArrayCmpxchg(ArrayCmpxchg* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitRefAs(RefAs* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringNew(StringNew* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringConst(StringConst* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringMeasure(StringMeasure* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringEncode(StringEncode* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringConcat(StringConcat* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringEq(StringEq* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringTest(StringTest* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringWTF16Get(StringWTF16Get* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStringSliceWTF(StringSliceWTF* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitContNew(ContNew* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitContBind(ContBind* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitSuspend(Suspend* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitResume(Resume* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitResumeThrow(ResumeThrow* curr) { WASM_UNREACHABLE("TODO"); }
  Flow visitStackSwitch(StackSwitch* curr) { WASM_UNREACHABLE("TODO"); }
};

} // anonymous namespace

Result<> Interpreter::addInstance(std::shared_ptr<Module> wasm) {
  return instantiate(store.instances.emplace_back(wasm));
}

Result<> Interpreter::instantiate(Instance& instance) {
  for (auto& global : instance.wasm->globals) {
    store.callStack.emplace_back(instance, ExpressionIterator(global->init));
    auto results = run();
    assert(results.size() == 1);
    instance.globalValues[global->name] = results[0];
  }
  return Ok{};
}

// This is a temporary convenience while stil using gTests to validate this
// interpreter. Once spec tests can run, this shall be deleted.
std::vector<Literal> Interpreter::runTest(Expression* root) {
  static std::shared_ptr<wasm::Module> dummyModule = std::make_shared<Module>();
  if (store.instances.empty()) {
    auto result = addInstance(dummyModule);
  }
  store.callStack.emplace_back(store.instances.back(),
                               ExpressionIterator(root));
  return run();
}

std::vector<Literal> Interpreter::run() {
  ExpressionInterpreter interpreter(*this);
  while (auto& it = store.callStack.back().exprs) {
    if (auto flow = interpreter.visit(*it)) {
      // TODO: Handle control flow transfers.
    } else {
      ++it;
    }
  }

  auto valueStack = store.callStack.back().valueStack;
  store.callStack.pop_back();
  return valueStack;
}

} // namespace wasm
