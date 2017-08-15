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
    static int nfs = 0;
    std::cerr << "finished lowering " << (++nfs) << std::endl;
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
    if (highBitsIt == labelIndices.end() ||
        highBitsIt->second == lastHighBits) {
      setOutParam(curr, lastHighBits);
      if (highBitsIt != labelIndices.end()) {
        labelIndices.erase(highBitsIt);
      }
      return;
    }
    Index highBits = highBitsIt->second;
    Index tmp = getTemp();
    labelIndices.erase(highBitsIt);
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
    assert(labelIndices.find(curr->name) == labelIndices.end());
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
    if (returnIndices.find(curr->value) == returnIndices.end()) return;
    Index outParam = fetchOutParam(curr->value);
    Index tmp = getTemp();
    bool didReuseOutParam = false;
    Expression* result = curr;
    std::vector<Name> targets;
    auto processTarget = [&](Name target) -> Name {
      auto labelIt = labelIndices.find(target);
      if (labelIt == labelIndices.end() || labelIt->second == outParam) {
        labelIndices[target] = outParam;
        didReuseOutParam = true;
        return target;
      }
      Index labelOutParam = labelIt->second;
      Name newLabel("$i64toi32_" + std::string(target.c_str()));
      result = builder->blockify(
        builder->makeSetLocal(tmp, builder->makeBlock(newLabel, result)),
        builder->makeSetLocal(
          labelOutParam,
          builder->makeGetLocal(outParam, i32)
        ),
        builder->makeGetLocal(tmp, i32)
      );
      return newLabel;
    };
    for (Name target : curr->targets) {
      targets.push_back(processTarget(target));
    }
    curr->default_ = processTarget(curr->default_);
    replaceCurrent(result);
    freeTemp(tmp);
    if (!didReuseOutParam) {
      freeTemp(outParam);
    }
  }

  template <typename T>
  using BuilderFunc = std::function<T*(std::vector<Expression*>, WasmType)>;

  template <typename T>
  void visitGenericCall(T* curr, BuilderFunc<T> callBuilder) {
    std::vector<Expression*> args;
    for (Expression* e : curr->operands) {
      args.push_back(e);
      if (returnIndices.find(e) != returnIndices.end()) {
        Index argHighBits = fetchOutParam(e);
        args.push_back(builder->makeGetLocal(argHighBits, i32));
        freeTemp(argHighBits);
      }
    }
    if (curr->type != i64) {
      replaceCurrent(callBuilder(args, curr->type));
      return;
    }
    Index lowBits = getTemp();
    Index highBits = getTemp();
    SetLocal* doCall = builder->makeSetLocal(
      lowBits,
      callBuilder(args, i32)
    );
    SetLocal* setHigh = builder->makeSetLocal(
      highBits,
      builder->makeGetGlobal(highBitsGlobal, i32)
    );
    GetLocal* getLow = builder->makeGetLocal(lowBits, i32);
    Block* result = builder->blockify(doCall, setHigh, getLow);
    freeTemp(lowBits);
    setOutParam(result, highBits);
    replaceCurrent(result);
  }
  void visitCall(Call* curr) {
    visitGenericCall<Call>(
      curr,
      [&](std::vector<Expression*> args, WasmType ty) {
        return builder->makeCall(curr->target, args, ty);
      }
    );
  }

  void visitCallImport(CallImport* curr) {
    // imports cannot contain i64s
    return;
  }

  void visitCallIndirect(CallIndirect* curr) {
    visitGenericCall<CallIndirect>(
      curr,
      [&](std::vector<Expression*> args, WasmType ty) {
        return builder->makeCallIndirect(
          curr->fullType,
          curr->target,
          args,
          ty
        );
      }
    );
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
    Index highBits = fetchOutParam(curr->value);
    Index tmp = getTemp();
    curr->index = indexMap[curr->index];
    curr->type = i32;
    SetLocal* setLow = builder->makeSetLocal(tmp, curr);
    SetLocal* setHigh = builder->makeSetLocal(
      curr->index + 1,
      builder->makeGetLocal(highBits, i32)
    );
    GetLocal* getLow = builder->makeGetLocal(tmp, i32);
    Block* result = builder->blockify(setLow, setHigh, getLow);
    replaceCurrent(result);
    setOutParam(result, highBits);
    freeTemp(tmp);
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
    if (curr->type != i64) return;
    assert(!curr->isAtomic && "atomic load not implemented");
    Index highBits = getTemp();
    Index ptrTemp = getTemp();
    SetLocal* setPtr = builder->makeSetLocal(ptrTemp, curr->ptr);
    SetLocal* loadHigh;
    if (curr->bytes > 4) {
      loadHigh = builder->makeSetLocal(
        highBits,
        builder->makeLoad(
          curr->bytes - 4,
          curr->signed_,
          curr->offset + 4,
          0,
          builder->makeGetLocal(ptrTemp, i32),
          i32
        )
      );
    } else {
      loadHigh = builder->makeSetLocal(
        highBits,
        builder->makeConst(Literal(int32_t(0)))
      );
    }
    curr->type = i32;
    curr->bytes = std::min(curr->bytes, uint8_t(4));
    curr->ptr = builder->makeGetLocal(ptrTemp, i32);
    Block* result = builder->blockify(setPtr, loadHigh, curr);
    replaceCurrent(result);
    setOutParam(result, highBits);
    freeTemp(ptrTemp);
  }

  void visitStore(Store* curr) {
    if (curr->valueType != i64) return;
    assert(curr->offset + 4 > curr->offset);
    assert(curr->bytes == 8 && "smaller stores not implemented");
    assert(!curr->isAtomic && "atomic store not implemented");
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
      curr->offset + 4,
      0,
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

  void lowerExtendUInt32(Unary* curr) {
    Index highBits = getTemp();
    Block* result = builder->blockify(
      builder->makeSetLocal(highBits, builder->makeConst(Literal(int32_t(0)))),
      curr->value
    );
    setOutParam(result, highBits);
    replaceCurrent(result);
  }

  void visitUnary(Unary* curr) {
    if (returnIndices.find(curr->value) == returnIndices.end() &&
        curr->type != i64) return;
    switch (curr->op) {
      case ClzInt64:
      case CtzInt64:
      case PopcntInt64:
      case EqZInt64:
      case ExtendSInt32:
        if (0) {
      case ExtendUInt32:
        return lowerExtendUInt32(curr);
        }
      case WrapInt64:
      case TruncSFloat32ToInt64:
      case TruncUFloat32ToInt64:
      case TruncSFloat64ToInt64:
      case TruncUFloat64ToInt64:
      case ReinterpretFloat64:
      case ConvertSInt64ToFloat32:
      case ConvertSInt64ToFloat64:
      case ConvertUInt64ToFloat32:
      case ConvertUInt64ToFloat64:
      case ReinterpretInt32:
      case ReinterpretInt64:
      default:
        std::cerr << "Unhandled unary operator: " << curr->op << std::endl;
        abort();
    }
  }

  Block* lowerAdd(Block* result, Index leftLow, Index leftHigh,
                  Index rightLow, Index rightHigh) {
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

  Block* lowerMul(Block* result, Index leftLow, Index leftHigh, Index rightLow,
                  Index rightHigh) {
    // high bits = ll*rh + lh*rl + ll1*rl1 + (ll0*rl1)>>16 + (ll1*rl0)>>16
    // low bits = ll*rl
    Index leftLow0 = getTemp();
    Index leftLow1 = getTemp();
    Index rightLow0 = getTemp();
    Index rightLow1 = getTemp();
    SetLocal* setLL0 = builder->makeSetLocal(
      leftLow0,
      builder->makeBinary(
        AndInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeConst(Literal(int32_t(0xffff)))
      )
    );
    SetLocal* setLL1 = builder->makeSetLocal(
      leftLow1,
      builder->makeBinary(
        ShrUInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeConst(Literal(int32_t(16)))
      )
    );
    SetLocal* setRL0 = builder->makeSetLocal(
      rightLow0,
      builder->makeBinary(
        AndInt32,
        builder->makeGetLocal(rightLow, i32),
        builder->makeConst(Literal(int32_t(0xffff)))
      )
    );
    SetLocal* setRL1 = builder->makeSetLocal(
      rightLow1,
      builder->makeBinary(
        ShrUInt32,
        builder->makeGetLocal(rightLow, i32),
        builder->makeConst(Literal(int32_t(16)))
      )
    );
    SetLocal* setLLRH = builder->makeSetLocal(
      rightHigh,
      builder->makeBinary(
        MulInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(rightHigh, i32)
      )
    );
    auto addToHighBits = [&](Expression* expr) -> SetLocal* {
      return builder->makeSetLocal(
        rightHigh,
        builder->makeBinary(
          AddInt32,
          builder->makeGetLocal(rightHigh, i32),
          expr
        )
      );
    };
    SetLocal* addLHRL = addToHighBits(
      builder->makeBinary(
        MulInt32,
        builder->makeGetLocal(leftHigh, i32),
        builder->makeGetLocal(rightLow, i32)
      )
    );
    SetLocal* addLL1RL1 = addToHighBits(
      builder->makeBinary(
        MulInt32,
        builder->makeGetLocal(leftLow1, i32),
        builder->makeGetLocal(rightLow1, i32)
      )
    );
    SetLocal* addLL0RL1 = addToHighBits(
      builder->makeBinary(
        ShrUInt32,
        builder->makeBinary(
          MulInt32,
          builder->makeGetLocal(leftLow0, i32),
          builder->makeGetLocal(rightLow1, i32)
        ),
        builder->makeConst(Literal(int32_t(16)))
      )
    );
    SetLocal* addLL1RL0 = addToHighBits(
      builder->makeBinary(
        ShrUInt32,
        builder->makeBinary(
          MulInt32,
          builder->makeGetLocal(leftLow1, i32),
          builder->makeGetLocal(rightLow0, i32)
        ),
        builder->makeConst(Literal(int32_t(16)))
      )
    );
    Binary* getLow = builder->makeBinary(
      MulInt32,
      builder->makeGetLocal(leftLow, i32),
      builder->makeGetLocal(rightLow, i32)
    );
    freeTemp(leftLow0);
    freeTemp(leftLow1);
    freeTemp(rightLow0);
    freeTemp(rightLow1);
    return builder->blockify(
      setLL0,
      setLL1,
      setRL0,
      setRL1,
      setLLRH,
      addLHRL,
      addLL1RL1,
      addLL0RL1,
      addLL1RL0,
      getLow
    );
  }

  Block* lowerBitwise(BinaryOp op, Block* result, Index leftLow, Index leftHigh,
                      Index rightLow, Index rightHigh) {
    BinaryOp op32;
    switch (op) {
      case AndInt64: op32 = AndInt32; break;
      case  OrInt64: op32 =  OrInt32; break;
      case XorInt64: op32 = XorInt32; break;
      default: abort();
    }
    return builder->blockify(
      builder->makeSetLocal(
        rightHigh,
        builder->makeBinary(
          op32,
          builder->makeGetLocal(leftHigh, i32),
          builder->makeGetLocal(rightHigh, i32)
        )
      ),
      builder->makeBinary(
        op32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(rightLow, i32)
      )
    );
  }

  Block* lowerShl(Block* result, Index leftLow, Index leftHigh,
                  Index rightLow, Index rightHigh) {
    // shift left lowered as:
    // if 32 <= rightLow % 64:
    //     high = leftLow << k; low = 0
    // else:
    //     high = (((1 << k) - 1) & (leftLow >> (32 - k))) | (leftHigh << k);
    //     low = leftLow << k
    // where k = shift % 32. Switch high and low and hshift dirs for shift right.
    Index shift = rightHigh; // repurpose useless temp
    SetLocal* setShift = builder->makeSetLocal(
      shift,
      builder->makeBinary(
        AndInt32,
        builder->makeGetLocal(rightLow, i32),
        builder->makeConst(Literal(int32_t(32 - 1)))
      )
    );
    Binary* isLargeShift = builder->makeBinary(
      LeUInt32,
      builder->makeConst(Literal(int32_t(32))),
      builder->makeBinary(
        AndInt32,
        builder->makeGetLocal(rightLow, i32),
        builder->makeConst(Literal(int32_t(64 - 1)))
      )
    );
    Block* largeShiftBlock = builder->blockify(
      builder->makeSetLocal(
        rightHigh,
        builder->makeBinary(
          ShlInt32,
          builder->makeGetLocal(leftLow, i32),
          builder->makeGetLocal(shift, i32)
        )
      ),
      builder->makeConst(Literal(int32_t(0)))
    );
    Binary* shiftMask = builder->makeBinary(
      SubInt32,
      builder->makeBinary(
        ShlInt32,
        builder->makeConst(Literal(int32_t(1))),
        builder->makeGetLocal(shift, i32)
      ),
      builder->makeConst(Literal(int32_t(1)))
    );
    Binary* widthLessShift = builder->makeBinary(
      SubInt32,
      builder->makeConst(Literal(int32_t(32))),
      builder->makeGetLocal(shift, i32)
    );
    Binary* shiftedInBits = builder->makeBinary(
      AndInt32,
      shiftMask,
      builder->makeBinary(
        ShrUInt32,
        builder->makeGetLocal(leftLow, i32),
        widthLessShift
      )
    );
    Binary* shiftHigh = builder->makeBinary(
      ShlInt32,
      builder->makeGetLocal(leftHigh, i32),
      builder->makeGetLocal(shift, i32)
    );
    Block* smallShiftBlock = builder->blockify(
      builder->makeSetLocal(
        rightHigh,
        builder->makeBinary(OrInt32, shiftedInBits, shiftHigh)
      ),
      builder->makeBinary(
        ShlInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(shift, i32)
      )
    );
    If* ifLargeShift = builder->makeIf(
      isLargeShift,
      largeShiftBlock,
      smallShiftBlock
    );
    return builder->blockify(result, setShift, ifLargeShift);
  }

  Block* lowerEq(Block* result, Index leftLow, Index leftHigh,
                    Index rightLow, Index rightHigh) {
    freeTemp(rightHigh); // no outparam for relational op
    return builder->blockify(
      result,
      builder->makeBinary(
        AndInt32,
        builder->makeBinary(
          EqInt32,
          builder->makeGetLocal(leftLow, i32),
          builder->makeGetLocal(rightLow, i32)
        ),
        builder->makeBinary(
          EqInt32,
          builder->makeGetLocal(leftHigh, i32),
          builder->makeGetLocal(rightHigh, i32)
        )
      )
    );
  }

  Block* lowerUComp(BinaryOp op, Block* result, Index leftLow, Index leftHigh,
                    Index rightLow, Index rightHigh) {
    freeTemp(rightHigh); // no outparam for relational op
    BinaryOp highOp, lowOp;
    switch (op) {
      case LtUInt64: highOp = LtUInt32; lowOp = LtUInt32; break;
      case LeUInt64: highOp = LtUInt32; lowOp = LeUInt32; break;
      case GtUInt64: highOp = GtUInt32; lowOp = GtUInt32; break;
      case GeUInt64: highOp = GtUInt32; lowOp = GeUInt32; break;
      default: abort();
    }
    Binary* compHigh = builder->makeBinary(
      highOp,
      builder->makeGetLocal(leftHigh, i32),
      builder->makeGetLocal(rightHigh, i32)
    );
    Binary* eqHigh = builder->makeBinary(
      EqInt32,
      builder->makeGetLocal(leftHigh, i32),
      builder->makeGetLocal(rightHigh, i32)
    );
    Binary* compLow = builder->makeBinary(
      lowOp,
      builder->makeGetLocal(leftLow, i32),
      builder->makeGetLocal(rightLow, i32)
    );
    return builder->blockify(
      result,
      builder->makeBinary(
        OrInt32,
        compHigh,
        builder->makeBinary(AndInt32, eqHigh, compLow)
      )
    );
  }


  void visitBinary(Binary* curr) {
    if (returnIndices.find(curr->left) == returnIndices.end()) return;
    assert(returnIndices.find(curr->right) != returnIndices.end());
    Index leftLow = getTemp();
    Index leftHigh = fetchOutParam(curr->left);
    Index rightLow = getTemp();
    Index rightHigh = fetchOutParam(curr->right);
    SetLocal* setRight = builder->makeSetLocal(rightLow, curr->right);
    SetLocal* setLeft = builder->makeSetLocal(leftLow, curr->left);
    Block* result = builder->blockify(setLeft, setRight);
    switch (curr->op) {
      case AddInt64: {
        result = lowerAdd(result, leftLow, leftHigh, rightLow, rightHigh);
        break;
      }
      case SubInt64: goto err;
      case MulInt64: {
        result = lowerMul(result, leftLow, leftHigh, rightLow, rightHigh);
        break;
      }
      case DivSInt64:
      case DivUInt64:
      case RemSInt64:
      case RemUInt64: goto err;
      case AndInt64:
      case OrInt64:
      case XorInt64: {
        result = lowerBitwise(curr->op, result, leftLow, leftHigh, rightLow,
                              rightHigh);
        break;
      }
      case ShlInt64: {
        result = lowerShl(result, leftLow, leftHigh, rightLow, rightHigh);
        break;
      }
      case ShrUInt64:
      case ShrSInt64:
      case RotLInt64:
      case RotRInt64: goto err;
      case EqInt64: {
        result = lowerEq(result, leftLow, leftHigh, rightLow, rightHigh);
        break;
      }
      case NeInt64:
      case LtSInt64:
      case LeSInt64:
      case GtSInt64:
      case GeSInt64: goto err;
      case LtUInt64:
      case LeUInt64:
      case GtUInt64:
      case GeUInt64: {
        result = lowerUComp(curr->op, result, leftLow, leftHigh, rightLow,
                            rightHigh);
        break;
      }
      err: default: {
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

  // TODO: deduplicate visitIf and visitSelect
  void visitSelect(Select* curr) {
    if (returnIndices.find(curr->ifTrue) == returnIndices.end()) return;
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

  void visitDrop(Drop* curr) {
    if (returnIndices.find(curr->value) == returnIndices.end()) return;
    freeTemp(fetchOutParam(curr->value));
  }

  void visitReturn(Return* curr) {
    if (returnIndices.find(curr->value) == returnIndices.end()) return;
    Index lowBits = getTemp();
    Index highBits = fetchOutParam(curr->value);
    SetLocal* setLow = builder->makeSetLocal(lowBits, curr->value);
    SetGlobal* setHigh = builder->makeSetGlobal(
      highBitsGlobal,
      builder->makeGetLocal(highBits, i32)
    );
    curr->value = builder->makeGetLocal(lowBits, i32);
    Block* result = builder->blockify(setLow, setHigh, curr);
    replaceCurrent(result);
    freeTemp(lowBits);
    freeTemp(highBits);
  }

private:
  Builder* builder;
  std::unordered_map<Index, Index> indexMap;
  std::unordered_map<Expression*, Index> returnIndices;
  std::unordered_map<Name, Index> labelIndices;
  std::vector<Index> freeTemps;
  Index nextTemp;

  Index getTemp() {
    Index ret;
    if (freeTemps.size() > 0) {
      ret = freeTemps.back();
      freeTemps.pop_back();
    } else {
      ret = nextTemp++;
    }
    return ret;
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
