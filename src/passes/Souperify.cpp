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
// This needs 'flatten' to be run before it, as it assumes the IR is in
// flat form.
//
// See https://github.com/google/souper/issues/323
//

#include <string>

#include "wasm.h"
#include "pass.h"
#include "ir/find_all.h"

namespace wasm {

struct SouperifyFunction : public Visitor<SouperifyFunction, std::string> {
  // Tracks the state of locals in a control flow path:
  //   localState[i] = the SSA local for that i
  // A special value means the zero init.
  typedef std::vector<Index> LocalState;

  const static Index ZeroInit = Index(-1);

  // The current local state in the control flow path being emitted.
  LocalState localState;

  // The next index for a new SSA variable.
  Index nextIndex;

  // The function being processed.
  Function* func;

  // Check if a function is relevant for us.
  static bool check(Function* func) {
    // TODO handle loops. for now, just ignore the entire function
    if (!FindAll<Loop>(func->body).list.empty()) {
      return false;
    }
    return true;
  }

  // Main entry: processes a function
  void process(Function* funcInit) {
    func = funcInit;
    std::cout << "; function: " << func->name << '\n';
    // Print out params, which are ironically of value 'var' in
    // Souper IR despite not being of type 'var' in ours...
    for (Index i = 0; i < func->getNumParams(); i++) {
      std::cout << func->getLocalNameOrGeneric(i) << " = var\n";
    }
    // Set up current state
    localState.resize(func->getNumLocals());
    for (Index i = 0; i < func->getNumParams(); i++) {
      if (func->isParam(i)) {
        localState[i] = i;
      } else {
        localState[i] = ZeroInit;
      }
    }
    nextIndex = func->getNumLocals();
    // Emit the function body.
    std::cout << visit(func->body) << '\n';
    // TODO: handle value flowing out
  }

  // Local emitting.
  std::string emitLocal(Index SSAIndex, Type type) {
    if (SSAIndex < func->getNumLocals()) {
      return func->getLocalNameOrGeneric(SSAIndex).str;
    } else if (SSAIndex == ZeroInit) {
      return std::string("0:") + printType(type);
    } else {
      return std::string("%") + std::to_string(SSAIndex);
    }
  }

  // Merge local state for two control flow paths
  // TODO: more than 2
  std::string merge(const LocalState& aState, const LocalState& bState, Index blockIndex, LocalState& out) {
    assert(out.size() == func->getNumLocals());
    std::string ret;
    for (Index i = 0; i < func->getNumLocals(); i++) {
      auto a = aState[i];
      auto b = bState[i];
      if (a == b) {
        out[i] = a;
      } else {
        // We need to actually merge some stuff.
        auto phi = nextIndex++;
        out[i] = phi;
        ret += "%" + std::to_string(phi) + " = phi %" + std::to_string(blockIndex) + ", ";
        auto type = func->getLocalType(i);
        emitLocal(a, type);
        ret += ", ";
        emitLocal(b, type);
      }
    }
    return ret;
  }

  // Visitors.

  std::string visitBlock(Block* curr) {
    // TODO: handle super-deep nesting
    // TODO: handle breaks to here
    std::string ret;
    for (auto* child : curr->list) {
      auto str = visit(child);
      if (!str.empty()) {
        ret += str + '\n';
      }
    }
    return ret;
  }
  std::string visitIf(If* curr) {
    // TODO: emit a path condition for the if-then, if it's a local
    // (otherwise, it's a constant, and not interesting)
    //if (auto* get = curr->condition->dynCast<GetLocal>()) {
    //  std::cout << "pc " << emitLocal(get->index) << " 1\n";
    //}
    // TODO: don't generate a blockIndex if we don't need one?
    // TODO: blockpc
    auto blockIndex = nextIndex++;
    std::string ret = "%" + std::to_string(blockIndex) + " = block 2\n";
    auto initialState = localState;
    ret += visit(curr->ifTrue);
    auto afterIfTrueState = localState;
    if (curr->ifFalse) {
      localState = initialState;
      ret += visit(curr->ifFalse);
      auto afterIfFalseState = localState; // TODO: optimize
      ret += merge(afterIfTrueState, afterIfFalseState, blockIndex, localState);
    } else {
      ret += merge(initialState, afterIfTrueState, blockIndex, localState);
    }
    return ret;
  }
  std::string visitLoop(Loop* curr) {
    // No loops in Souper.
    WASM_UNREACHABLE();
  }
  std::string visitBreak(Break* curr) { WASM_UNREACHABLE(); }
  std::string visitSwitch(Switch* curr) { WASM_UNREACHABLE(); }
  std::string visitCall(Call* curr) { WASM_UNREACHABLE(); }
  std::string visitCallImport(CallImport* curr) { WASM_UNREACHABLE(); }
  std::string visitCallIndirect(CallIndirect* curr) { WASM_UNREACHABLE(); }
  std::string visitGetLocal(GetLocal* curr) {
    return emitLocal(localState[curr->index], func->getLocalType(curr->index));
  }
  std::string visitSetLocal(SetLocal* curr) {
    // If we are doing a copy, just do the copy.
    if (auto* get = curr->value->dynCast<GetLocal>()) {
      localState[curr->index] = localState[get->index];
      return "";
    }
    Index currSSAIndex;
    if (localState[curr->index] == ZeroInit) {
      // First assignment: it is ok to use the current index and name here.
      currSSAIndex = curr->index;
    } else {
      // Time for a new SSA index.
      currSSAIndex = nextIndex++;
    }
    localState[curr->index] = currSSAIndex;
    auto ret = emitLocal(currSSAIndex, func->getLocalType(curr->index));
    ret += " = ";
    ret += visit(curr->value);
    return ret;
  }
  std::string visitGetGlobal(GetGlobal* curr) { WASM_UNREACHABLE(); }
  std::string visitSetGlobal(SetGlobal* curr) { WASM_UNREACHABLE(); }
  std::string visitLoad(Load* curr) { WASM_UNREACHABLE(); }
  std::string visitStore(Store* curr) { WASM_UNREACHABLE(); }
  std::string visitAtomicRMW(AtomicRMW* curr) { WASM_UNREACHABLE(); }
  std::string visitAtomicCmpxchg(AtomicCmpxchg* curr) { WASM_UNREACHABLE(); }
  std::string visitAtomicWait(AtomicWait* curr) { WASM_UNREACHABLE(); }
  std::string visitAtomicWake(AtomicWake* curr) { WASM_UNREACHABLE(); }
  std::string visitConst(Const* curr) {
    std::string ret;
    if (isIntegerType(curr->type)) {
      ret = curr->value.getInteger();
    } else {
      ret = curr->value.getFloat();
    }
    ret += std::string(":") + printType(curr->type);
    return ret;
  }
  std::string visitUnary(Unary* curr) { WASM_UNREACHABLE(); }
  std::string visitBinary(Binary *curr) {
    std::string ret;
    switch (curr->op) {
      case AddInt32:
      case AddInt64:  ret = "add";  break;
      case SubInt32:
      case SubInt64:  ret = "sub";  break;
      case MulInt32:
      case MulInt64:  ret = "mul";  break;
      case DivSInt32:
      case DivSInt64: ret = "sdiv"; break;
      case DivUInt32:
      case DivUInt64: ret = "udiv"; break;
      case RemSInt32:
      case RemSInt64: ret = "srem"; break;
      case RemUInt32:
      case RemUInt64: ret = "urem"; break;
      case AndInt32:
      case AndInt64:  ret = "and";  break;
      case OrInt32:
      case OrInt64:   ret = "or";   break;
      case XorInt32:
      case XorInt64:  ret = "xor";  break;
      case ShlInt32:
      case ShlInt64:  ret = "shl";  break;
      case ShrUInt32:
      case ShrUInt64: ret = "ushr"; break;
      case ShrSInt32:
      case ShrSInt64: ret = "sshr"; break;
      case RotLInt32:
      case RotLInt64: ret = "rotl"; break;
      case RotRInt32:
      case RotRInt64: ret = "rotr"; break;
      case EqInt32:
      case EqInt64:   ret = "eq";   break;
      case NeInt32:
      case NeInt64:   ret = "ne";   break;
      case LtSInt32:
      case LtSInt64:  ret = "slt";  break;
      case LtUInt32:
      case LtUInt64:  ret = "ult";  break;
      case LeSInt32:
      case LeSInt64:  ret = "sle";  break;
      case LeUInt32:
      case LeUInt64:  ret = "ule";  break;
      case GtSInt32:
      case GtSInt64:  ret = "sgt";  break;
      case GtUInt32:
      case GtUInt64:  ret = "ugt";  break;
      case GeSInt32:
      case GeSInt64:  ret = "sge";  break;
      case GeUInt32:
      case GeUInt64:  ret = "uge";  break;

      default: WASM_UNREACHABLE();
    }
    ret += ' ';
    ret += visit(curr->left);
    ret += ", ";
    ret += visit(curr->right);
    return ret;
  }
  std::string visitSelect(Select* curr) { WASM_UNREACHABLE(); }
  std::string visitDrop(Drop* curr) { WASM_UNREACHABLE(); }
  std::string visitReturn(Return* curr) {
    // TODO something here?
    return "; return";
  }
  std::string visitHost(Host* curr) { WASM_UNREACHABLE(); }
  std::string visitNop(Nop* curr) {
    return "";
  }
  std::string visitUnreachable(Unreachable* curr) {
    return "; unreachable";
  }
};

struct Souperify : public WalkerPass<PostWalker<Souperify>> {
  // Not parallel, for now - could parallelize and combine outputs at the end.
  // If Souper is thread-safe, we could also run it in parallel.

  void doWalkFunction(Function* func) {
    if (SouperifyFunction::check(func)) {
      SouperifyFunction().process(func);
    }
  }
};

Pass *createSouperifyPass() {
  return new Souperify();
}

} // namespace wasm

