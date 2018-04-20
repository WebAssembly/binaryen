/*
 * Copyright 2016 WebAssembly Community Group participants
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

//
// Souperify - convert to Souper IR in text form.
//
// See https://github.com/google/souper/issues/323
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct SouperifyExpression : public Visitor<SouperifyExpression> {
  Function* func;

  SouperifyExpression(Function* func) : func(func) {}

  void visitBlock(Block* curr) {
    // TODO: handle super-deep nesting
    for (auto* child : curr->list) {
      visit(child);
      std::cout << '\n';
    }
  }
  void visitIf(If* curr) {
    // emit a path condition for the if-then, if it's a local
    // (otherwise, it's a constant, and not interesting)
    if (auto* get = curr->condition->dynCast<GetLocal>()) {
      std::cout << "pc " << func->getLocalNameOrGeneric(get->index) << " 1\n";
    }
    visit(curr->ifTrue);
    // TODO: what to do with the if-else?
  }
  void visitLoop(Loop* curr) { WASM_UNREACHABLE(); }
  void visitBreak(Break* curr) { WASM_UNREACHABLE(); }
  void visitSwitch(Switch* curr) { WASM_UNREACHABLE(); }
  void visitCall(Call* curr) { WASM_UNREACHABLE(); }
  void visitCallImport(CallImport* curr) { WASM_UNREACHABLE(); }
  void visitCallIndirect(CallIndirect* curr) { WASM_UNREACHABLE(); }
  void visitGetLocal(GetLocal* curr) {
    std::cout << func->getLocalNameOrGeneric(curr->index);
  }
  void visitSetLocal(SetLocal* curr) {
    std::cout << func->getLocalNameOrGeneric(curr->index) << " = ";
    visit(curr->value);
  }
  void visitGetGlobal(GetGlobal* curr) { WASM_UNREACHABLE(); }
  void visitSetGlobal(SetGlobal* curr) { WASM_UNREACHABLE(); }
  void visitLoad(Load* curr) { WASM_UNREACHABLE(); }
  void visitStore(Store* curr) { WASM_UNREACHABLE(); }
  void visitAtomicRMW(AtomicRMW* curr) { WASM_UNREACHABLE(); }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) { WASM_UNREACHABLE(); }
  void visitAtomicWait(AtomicWait* curr) { WASM_UNREACHABLE(); }
  void visitAtomicWake(AtomicWake* curr) { WASM_UNREACHABLE(); }
  void visitConst(Const* curr) {
    if (isIntegerType(curr->type)) {
      std::cout << curr->value.getInteger();
    } else {
      std::cout << curr->value.getFloat();
    }
    std::cout << ":" << printType(curr->type);
  }
  void visitUnary(Unary* curr) { WASM_UNREACHABLE(); }
  void visitBinary(Binary *curr) {
    switch (curr->op) {
      case AddInt32:
      case AddInt64:  std::cout << "add";  break;
      case SubInt32:
      case SubInt64:  std::cout << "sub";  break;
      case MulInt32:
      case MulInt64:  std::cout << "mul";  break;
      case DivSInt32:
      case DivSInt64: std::cout << "sdiv"; break;
      case DivUInt32:
      case DivUInt64: std::cout << "udiv"; break;
      case RemSInt32:
      case RemSInt64: std::cout << "srem"; break;
      case RemUInt32:
      case RemUInt64: std::cout << "urem"; break;
      case AndInt32:
      case AndInt64:  std::cout << "and";  break;
      case OrInt32:
      case OrInt64:   std::cout << "or";   break;
      case XorInt32:
      case XorInt64:  std::cout << "xor";  break;
      case ShlInt32:
      case ShlInt64:  std::cout << "shl";  break;
      case ShrUInt32:
      case ShrUInt64: std::cout << "ushr"; break;
      case ShrSInt32:
      case ShrSInt64: std::cout << "sshr"; break;
      case RotLInt32:
      case RotLInt64: std::cout << "rotl"; break;
      case RotRInt32:
      case RotRInt64: std::cout << "rotr"; break;
      case EqInt32:
      case EqInt64:   std::cout << "eq";   break;
      case NeInt32:
      case NeInt64:   std::cout << "ne";   break;
      case LtSInt32:
      case LtSInt64:  std::cout << "slt";  break;
      case LtUInt32:
      case LtUInt64:  std::cout << "ult";  break;
      case LeSInt32:
      case LeSInt64:  std::cout << "sle";  break;
      case LeUInt32:
      case LeUInt64:  std::cout << "ule";  break;
      case GtSInt32:
      case GtSInt64:  std::cout << "sgt";  break;
      case GtUInt32:
      case GtUInt64:  std::cout << "ugt";  break;
      case GeSInt32:
      case GeSInt64:  std::cout << "sge";  break;
      case GeUInt32:
      case GeUInt64:  std::cout << "uge";  break;

      default: WASM_UNREACHABLE();
    }
    std::cout << ' ';
    visit(curr->left);
    std::cout << ", ";
    visit(curr->right);
  }
  void visitSelect(Select* curr) { WASM_UNREACHABLE(); }
  void visitDrop(Drop* curr) { WASM_UNREACHABLE(); }
  void visitReturn(Return* curr) {
    if (curr->value) {
      // a returned value is something we want to infer
      std::cout << "infer ";
      visit(curr->value);
    } else {
      std::cout << "; return";
    }
  }
  void visitHost(Host* curr) { WASM_UNREACHABLE(); }
  void visitNop(Nop* curr) {}
  void visitUnreachable(Unreachable* curr) {
    std::cout << "; unreachable";
  }
};

struct SouperifyFunction : public WalkerPass<PostWalker<SouperifyFunction>> {
  // Not parallel, for now - could parallelize and combine outputs at the end

  void doWalkFunction(Function* func) {
    std::cout << "; function: " << func->name << '\n';
    // Print out locals, first
    for (Index i = 0; i < func->getNumParams(); i++) {
      std::cout << func->getLocalNameOrGeneric(i) << " = var\n";
    }
    SouperifyExpression(func).visit(func->body);
    std::cout << '\n';
  }
};

struct Souperify : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // We flatten the IR, then convert
    PassRunner inner(module, runner->options);
    inner.setIsNested(true);
    //inner.add("flatten");
    inner.add<SouperifyFunction>();
    inner.run();
  }
};

Pass *createSouperifyPass() {
  return new Souperify();
}

} // namespace wasm

