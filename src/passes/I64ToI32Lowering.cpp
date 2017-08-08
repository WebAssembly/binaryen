/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Lowers i64s to i32s by splitting variables and arguments
// into pairs of i32s. i64 return values are lowered by
// returning the low half and storing the high half into a
// global.
//

#include "wasm.h"
#include "pass.h"
#include "emscripten-optimizer/istring.h"
#include "support/name.h"
#include "wasm-builder.h"

namespace wasm {

static Name makeHighName(Name n) {
  return Name(
    cashew::IString((std::string(n.c_str()) + "$hi").c_str(), false)
  );
}

struct I64ToI32Lowering : public WalkerPass<PostWalker<I64ToI32Lowering>> {
  static Name highBitsGlobal;

  // bool isFunctionParallel() override { return true; }
  bool isFunctionParallel() override { return false; }

  void doWalkModule(Module* module) {
    builder = new Builder(*module);
    PostWalker<I64ToI32Lowering>::doWalkModule(module);
    delete builder;
  }

  void visitFunctionType(FunctionType* curr) {
    std::vector<WasmType> params;
    for (WasmType t : curr->params) {
      if (t == i64) {
        params.push_back(i32);
        params.push_back(i32);
      } else {
        params.push_back(t);
      }
    }
    std::swap(params, curr->params);
    if (curr->result == i64) {
      curr->result = i32;
    }
  }

  void visitGlobal(Global* curr) {
    if (curr->type == i64) {
      curr->type = i32;
      Global* high = new Global(*curr);
      high->name = makeHighName(curr->name);
      getModule()->addGlobal(high);
    }
  }

  void doWalkFunction(Function* func) {
    indexMap.clear();
    returnIndices.clear();
    labelIndices.clear();
    freeTemps.clear();
    Function oldFunc(*func);
    func->params.clear();
    func->vars.clear();
    func->localNames.clear();
    func->localIndices.clear();
    Index newIdx = 0;
    for (Index i = 0; i < oldFunc.getNumLocals(); ++i) {
      assert(oldFunc.hasLocalName(i));
      Name lowName = oldFunc.getLocalName(i);
      Name highName = makeHighName(lowName);
      WasmType paramType = oldFunc.getLocalType(i);
      auto builderFunc = (i < oldFunc.getVarIndexBase()) ?
          Builder::addParam :
          static_cast<Index (*)(Function*, Name, WasmType)>(Builder::addVar);
      if (paramType == i64) {
        builderFunc(func, lowName, i32);
        builderFunc(func, highName, i32);
        indexMap[i] = newIdx;
        newIdx += 2;
      } else {
        builderFunc(func, lowName, paramType);
        indexMap[i] = newIdx++;
      }
    }
    nextTemp = func->getNumLocals();
    PostWalker<I64ToI32Lowering>::doWalkFunction(func);
  }

  void visitFunction(Function* func) {
    if (func->result == i64) {
      func->result = i32;
      Index highBits = fetchOutParam(func->body);
      Index lowBits = getTemp();
      SetLocal* setLow = builder->makeSetLocal(
        lowBits,
        func->body
      );
      SetGlobal* setHigh = builder->makeSetGlobal(
        highBitsGlobal,
        builder->makeGetLocal(highBits, i32)
      );
      GetLocal* getLow = builder->makeGetLocal(lowBits, i32);
      func->body = builder->blockify(setLow, setHigh, getLow);
      freeTemp(highBits);
      freeTemp(lowBits);
    }
    assert(freeTemps.size() == nextTemp - func->getNumLocals());
    int idx = 0;
    for (size_t i = func->getNumLocals(); i < nextTemp; i++) {
      Name tmpName("i64toi32_i32$" + std::to_string(idx++));
      builder->addVar(func, tmpName, i32);
    }
  }

  void visitBlock(Block* curr) {
    size_t lastIdx = curr->list.size() - 1;
    for (size_t i = 0; i < lastIdx; ++i) {
      if (curr->list[i]->type != i64) continue;
      freeTemp(fetchOutParam(curr->list[i]));
    }
    Index lastHighBits = fetchOutParam(curr->list.back());
    auto highBitsIt = labelIndices.find(curr->name);
    if (highBitsIt == labelIndices.end()) {
      setOutParam(curr, lastHighBits);
      labelIndices.erase(curr->name);
      return;
    }
    Index highBits = highBitsIt->second;
    Index tmp = getTemp();
    labelIndices.erase(curr->name);
    SetLocal* setLow = builder->makeSetLocal(tmp, curr->list[lastIdx]);
    SetLocal* setHigh = builder->makeSetLocal(
      highBits,
      builder->makeGetLocal(lastHighBits, i32)
    );
    GetLocal* getLow = builder->makeGetLocal(tmp, i32);
    curr->list[lastIdx] = builder->blockify(setLow, setHigh, getLow);
    setOutParam(curr, highBits);
    freeTemp(lastHighBits);
    freeTemp(tmp);
  }

  void visitIf(If* curr) {
    if (returnIndices.find(curr->ifTrue) == returnIndices.end()) return;
    assert(curr->ifFalse != nullptr);
    Index highBits = fetchOutParam(curr->ifTrue);
    Index falseBits = fetchOutParam(curr->ifFalse);
    Index tmp = getTemp();
    curr->ifFalse = builder->blockify(
      builder->makeSetLocal(tmp, curr->ifFalse),
      builder->makeSetLocal(
        highBits,
        builder->makeGetLocal(falseBits, i32)
      ),
      builder->makeGetLocal(tmp, i32)
    );
    freeTemp(falseBits);
    setOutParam(curr, highBits);
  }

  void visitLoop(Loop* curr) {
    if (curr->type != i64) return;
    curr->type = i32;
    setOutParam(curr, fetchOutParam(curr->body));
  }

  void visitBreak(Break* curr) {
    if (curr->type != i64) return;
    assert(curr->value != nullptr);
    Index valHighBits = fetchOutParam(curr->value);
    auto blockHighBitsIt = labelIndices.find(curr->name);
    if (blockHighBitsIt == labelIndices.end()) {
      labelIndices[curr->name] = valHighBits;
      curr->type = i32;
      return;
    }
    Index blockHighBits = blockHighBitsIt->second;
    Index tmp = getTemp();
    SetLocal* setLow = builder->makeSetLocal(tmp, curr->value);
    SetLocal* setHigh = builder->makeSetLocal(
      blockHighBits,
      builder->makeGetLocal(valHighBits, i32)
    );
    curr->value = builder->makeGetLocal(tmp, i32);
    curr->type = i32;
    replaceCurrent(builder->blockify(setLow, setHigh, curr));
    freeTemp(tmp);
  }

  void visitSwitch(Switch* curr) {
    assert(false && "Switch not implemented");
  }

  void visitCall(Call* curr) {
    assert(false && "Call not implemented");
  }

  void visitCallImport(CallImport* curr) {
    assert(false && "CallImport not implemented");
  }

  void visitCallIndirect(CallIndirect* curr) {
    assert(false && "CallIndirect not implemented");
  }

  void visitGetLocal(GetLocal* curr) {
    if (curr->type != i64) return;
    curr->index = indexMap[curr->index];
    curr->type = i32;
    Index highBits = getTemp();
    SetLocal *setHighBits = builder->makeSetLocal(
      highBits,
      builder->makeGetLocal(
        curr->index + 1,
        i32
      )
    );
    Block* result = builder->blockify(setHighBits, curr);
    replaceCurrent(result);
    setOutParam(result, highBits);
  }

  void lowerTee(SetLocal* curr) {
    assert(false && "Tee not implemented");
  }

  void visitSetLocal(SetLocal* curr) {
    if (returnIndices.find(curr->value) == returnIndices.end()) return;
    if (curr->isTee()) {
      lowerTee(curr);
      return;
    }
    Index highBits = fetchOutParam(curr->value);
    curr->index = indexMap[curr->index];
    curr->type = i32;
    SetLocal* setHigh = builder->makeSetLocal(
      curr->index + 1,
      builder->makeGetLocal(highBits, i32)
    );
    Block* result = builder->blockify(curr, setHigh);
    replaceCurrent(result);
    freeTemp(highBits);
  }

  void visitGetGlobal(GetGlobal* curr) {
    assert(false && "GetGlobal not implemented");
  }

  void visitSetGlobal(SetGlobal* curr) {
    assert(false && "SetGlobal not implemented");
  }

  void visitLoad(Load* curr) {
    assert(false && "Load not implemented");
  }

  void visitStore(Store* curr) {
    if (curr->valueType != i64) return;
    assert(curr->offset + 4 > curr->offset);
    assert(curr->bytes == 8 && "smaller stores not implemented");
    Index highBits = fetchOutParam(curr->value);
    Index ptrTemp = getTemp();
    SetLocal* setPtr = builder->makeSetLocal(ptrTemp, curr->ptr);
    Store* storeLow = builder->makeStore(
      4,
      curr->offset,
      curr->align,
      builder->makeGetLocal(ptrTemp, i32),
      curr->value,
      i32
    );
    Store* storeHigh = builder->makeStore(
      4,
      Address(curr->offset + 4),
      Address(4),
      builder->makeGetLocal(ptrTemp, i32),
      builder->makeGetLocal(highBits, i32),
      i32
    );
    replaceCurrent(builder->blockify(setPtr, storeLow, storeHigh));
    freeTemp(highBits);
    freeTemp(ptrTemp);
  }

  void visitAtomicRMW(AtomicRMW* curr) {
    assert(false && "AtomicRMW not implemented");
  }

  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    assert(false && "AtomicCmpxchg not implemented");
  }

  void visitConst(Const* curr) {
    if (curr->type != i64) return;
    Index highBits = getTemp();
    Const* lowVal = builder->makeConst(
      Literal(int32_t(curr->value.geti64() & 0xffffffff))
    );
    SetLocal* setHigh = builder->makeSetLocal(
      highBits,
      builder->makeConst(
        Literal(int32_t(uint64_t(curr->value.geti64()) >> 32))
      )
    );
    Block* result = builder->blockify(setHigh, lowVal);
    setOutParam(result, highBits);
    replaceCurrent(result);
  }

  void visitUnary(Unary* curr) {
    if (curr->value->type != i64) return;
    assert(false && "Unary not implemented");
  }

  Block* lowerAdd(Block* result, Index leftLow, Index leftHigh,
                       Index rightLow, Index rightHigh) {
    std::cerr << "Lowering AddInt64" << std::endl;
    SetLocal* addLow = builder->makeSetLocal(
      leftHigh,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(rightLow, i32)
      )
    );
    SetLocal* addHigh = builder->makeSetLocal(
      rightHigh,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(leftHigh, i32),
        builder->makeGetLocal(rightHigh, i32)
      )
    );
    SetLocal* carryBit = builder->makeSetLocal(
      rightHigh,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(rightHigh, i32),
        builder->makeConst(Literal(int32_t(1)))
      )
    );
    If* checkOverflow = builder->makeIf(
      builder->makeBinary(
        LtUInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(rightLow,i32)
      ),
      carryBit
    );
    GetLocal* getLow = builder->makeGetLocal(leftHigh, i32);
    return builder->blockify(result, addLow, addHigh, checkOverflow, getLow);
  }

  void visitBinary(Binary* curr) {
    if (returnIndices.find(curr->left) == returnIndices.end()) return;
    Index leftLow = getTemp();
    Index leftHigh = fetchOutParam(curr->left);
    Index rightLow = getTemp();
    Index rightHigh = fetchOutParam(curr->right);
    SetLocal* setLeft = builder->makeSetLocal(leftLow, curr->left);
    SetLocal* setRight = builder->makeSetLocal(rightLow, curr->right);
    Block* result = builder->blockify(setLeft, setRight);
    switch (curr->op) {
      case AddInt64: {
        result = lowerAdd(result, leftLow, leftHigh, rightLow, rightHigh);
        break;
      }
      case SubInt64:
      case MulInt64:
      case DivSInt64:
      case DivUInt64:
      case RemSInt64:
      case RemUInt64:
      case AndInt64:
      case OrInt64:
      case XorInt64:
      case ShlInt64:
      case ShrUInt64:
      case ShrSInt64:
      case RotLInt64:
      case RotRInt64:
      case EqInt64:
      case NeInt64:
      case LtSInt64:
      case LtUInt64:
      case LeSInt64:
      case LeUInt64:
      case GtSInt64:
      case GtUInt64:
      case GeSInt64:
      case GeUInt64:
      default: {
        std::cerr << "Unhandled binary op " << curr->op << std::endl;
        abort();
      }
    }
    freeTemp(leftLow);
    freeTemp(leftHigh);
    freeTemp(rightLow);
    replaceCurrent(result);
    setOutParam(result, rightHigh);
  }

  void visitSelect(Select* curr) {
    assert(false && "Select not implemented");
  }

  void visitDrop(Drop* curr) {
    if (returnIndices.find(curr->value) == returnIndices.end()) return;
    freeTemp(fetchOutParam(curr->value));
  }

  void visitReturn(Return* curr) {
    assert(false && "Return not implemented");
  }

private:
  Builder* builder;
  std::unordered_map<Index, Index> indexMap;
  std::unordered_map<Expression*, Index> returnIndices;
  std::unordered_map<Name, Index> labelIndices;
  std::vector<Index> freeTemps;
  Index nextTemp;

  Index getTemp() {
    if (freeTemps.size() > 0) {
      Index ret = freeTemps.back();
      freeTemps.pop_back();
      return ret;
    }
    return nextTemp++;
  }

  void freeTemp(Index t) {
    freeTemps.push_back(t);
  }

  void setOutParam(Expression* e, Index idx) {
    returnIndices[e] = idx;
  }

  Index fetchOutParam(Expression* e) {
    Index ret = returnIndices[e];
    returnIndices.erase(e);
    return ret;
  }
};

Name I64ToI32Lowering::highBitsGlobal("i64toi32_i32$HIGH_BITS");

Pass *createI64ToI32LoweringPass() {
  return new I64ToI32Lowering();
}

}
