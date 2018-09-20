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

#include <algorithm>
#include "wasm.h"
#include "pass.h"
#include "emscripten-optimizer/istring.h"
#include "support/name.h"
#include "wasm-builder.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "asmjs/shared-constants.h"

namespace wasm {

static Name makeHighName(Name n) {
  return Name(
    cashew::IString((std::string(n.c_str()) + "$hi").c_str(), false)
  );
}

struct I64ToI32Lowering : public WalkerPass<PostWalker<I64ToI32Lowering>> {
  struct TempVar {
    TempVar(Index idx, Type ty, I64ToI32Lowering& pass) :
      idx(idx), pass(pass), moved(false), ty(ty) {}

    TempVar(TempVar&& other) : idx(other), pass(other.pass), moved(false), ty(other.ty) {
      assert(!other.moved);
      other.moved = true;
    }

    TempVar& operator=(TempVar&& rhs) {
      assert(!rhs.moved);
      // free overwritten idx
      if (!moved) freeIdx();
      idx = rhs.idx;
      rhs.moved = true;
      moved = false;
      return *this;
    }

    ~TempVar() {
      if (!moved) freeIdx();
    }

    bool operator==(const TempVar& rhs) {
      assert(!moved && !rhs.moved);
      return idx == rhs.idx;
    }

    operator Index() {
      assert(!moved);
      return idx;
    }

    // disallow copying
    TempVar(const TempVar&) = delete;
    TempVar& operator=(const TempVar&) = delete;

  private:
    void freeIdx() {
      auto &freeList = pass.freeTemps[(int) ty];
      assert(std::find(freeList.begin(), freeList.end(), idx) == freeList.end());
      freeList.push_back(idx);
    }

    Index idx;
    I64ToI32Lowering& pass;
    bool moved; // since C++ will still destruct moved-from values
    Type ty;
  };

  // false since function types need to be lowered
  // TODO: allow module-level transformations in parallel passes
  bool isFunctionParallel() override { return false; }

  Pass* create() override {
    return new I64ToI32Lowering;
  }

  void doWalkModule(Module* module) {
    if (!builder) builder = make_unique<Builder>(*module);
    // add new globals for high bits
    for (size_t i = 0, globals = module->globals.size(); i < globals; ++i) {
      auto& curr = module->globals[i];
      if (curr->type != i64) continue;
      curr->type = i32;
      auto* high = ModuleUtils::copyGlobal(curr.get(), *module);
      high->name = makeHighName(curr->name);
      module->addGlobal(high);
    }

    // For functions that return 64-bit values, we use this global variable
    // to return the high 32 bits.
    auto* highBits = new Global();
    highBits->type = i32;
    highBits->name = INT64_TO_32_HIGH_BITS;
    highBits->init = builder->makeConst(Literal(int32_t(0)));
    highBits->mutable_ = true;
    module->addGlobal(highBits);
    PostWalker<I64ToI32Lowering>::doWalkModule(module);
  }

  void visitFunctionType(FunctionType* curr) {
    std::vector<Type> params;
    for (auto t : curr->params) {
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

  void doWalkFunction(Function* func) {
    // create builder here if this is first entry to module for this object
    if (!builder) builder = make_unique<Builder>(*getModule());
    indexMap.clear();
    highBitVars.clear();
    labelHighBitVars.clear();
    freeTemps.clear();
    Module temp;
    auto* oldFunc = ModuleUtils::copyFunction(func, temp);
    func->params.clear();
    func->vars.clear();
    func->localNames.clear();
    func->localIndices.clear();
    Index newIdx = 0;
    Names::ensureNames(oldFunc);
    for (Index i = 0; i < oldFunc->getNumLocals(); ++i) {
      assert(oldFunc->hasLocalName(i));
      Name lowName = oldFunc->getLocalName(i);
      Name highName = makeHighName(lowName);
      Type paramType = oldFunc->getLocalType(i);
      auto builderFunc = (i < oldFunc->getVarIndexBase()) ?
          Builder::addParam :
          static_cast<Index (*)(Function*, Name, Type)>(Builder::addVar);
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
    if (func->imported()) {
      return;
    }
    if (func->result == i64) {
      func->result = i32;
      // body may not have out param if it ends with control flow
      if (hasOutParam(func->body)) {
        TempVar highBits = fetchOutParam(func->body);
        TempVar lowBits = getTemp();
        SetLocal* setLow = builder->makeSetLocal(
          lowBits,
          func->body
        );
        SetGlobal* setHigh = builder->makeSetGlobal(
          INT64_TO_32_HIGH_BITS,
          builder->makeGetLocal(highBits, i32)
        );
        GetLocal* getLow = builder->makeGetLocal(lowBits, i32);
        func->body = builder->blockify(setLow, setHigh, getLow);
      }
    }
    int idx = 0;
    for (size_t i = func->getNumLocals(); i < nextTemp; i++) {
      Name tmpName("i64toi32_i32$" + std::to_string(idx++));
      builder->addVar(func, tmpName, tempTypes[i]);
    }
  }

  void visitBlock(Block* curr) {
    if (curr->list.size() == 0) return;
    if (curr->type == i64) curr->type = i32;
    auto highBitsIt = labelHighBitVars.find(curr->name);
    if (!hasOutParam(curr->list.back())) {
      if (highBitsIt != labelHighBitVars.end()) {
        setOutParam(curr, std::move(highBitsIt->second));
      }
      return;
    }
    TempVar lastHighBits = fetchOutParam(curr->list.back());
    if (highBitsIt == labelHighBitVars.end() ||
        highBitsIt->second == lastHighBits) {
      setOutParam(curr, std::move(lastHighBits));
      if (highBitsIt != labelHighBitVars.end()) {
        labelHighBitVars.erase(highBitsIt);
      }
      return;
    }
    TempVar highBits = std::move(highBitsIt->second);
    TempVar tmp = getTemp();
    labelHighBitVars.erase(highBitsIt);
    SetLocal* setLow = builder->makeSetLocal(tmp, curr->list.back());
    SetLocal* setHigh = builder->makeSetLocal(
      highBits,
      builder->makeGetLocal(lastHighBits, i32)
    );
    GetLocal* getLow = builder->makeGetLocal(tmp, i32);
    curr->list.back() = builder->blockify(setLow, setHigh, getLow);
    setOutParam(curr, std::move(highBits));
  }

  // If and Select have identical code
  template <typename T>
  void visitBranching(T* curr) {
    if (!hasOutParam(curr->ifTrue)) return;
    assert(curr->ifFalse != nullptr && "Nullable ifFalse found");
    TempVar highBits = fetchOutParam(curr->ifTrue);
    TempVar falseBits = fetchOutParam(curr->ifFalse);
    TempVar tmp = getTemp();
    curr->type = i32;
    curr->ifFalse = builder->blockify(
      builder->makeSetLocal(tmp, curr->ifFalse),
      builder->makeSetLocal(
        highBits,
        builder->makeGetLocal(falseBits, i32)
      ),
      builder->makeGetLocal(tmp, i32)
    );
    setOutParam(curr, std::move(highBits));
  }

  void visitIf(If* curr) {
    visitBranching<If>(curr);
  }

  void visitLoop(Loop* curr) {
    assert(labelHighBitVars.find(curr->name) == labelHighBitVars.end());
    if (curr->type != i64) return;
    curr->type = i32;
    setOutParam(curr, fetchOutParam(curr->body));
  }

  void visitBreak(Break* curr) {
    if (!hasOutParam(curr->value)) return;
    assert(curr->value != nullptr);
    TempVar valHighBits = fetchOutParam(curr->value);
    auto blockHighBitsIt = labelHighBitVars.find(curr->name);
    if (blockHighBitsIt == labelHighBitVars.end()) {
      labelHighBitVars.emplace(curr->name, std::move(valHighBits));
      curr->type = i32;
      return;
    }
    TempVar blockHighBits = std::move(blockHighBitsIt->second);
    TempVar tmp = getTemp();
    SetLocal* setLow = builder->makeSetLocal(tmp, curr->value);
    SetLocal* setHigh = builder->makeSetLocal(
      blockHighBits,
      builder->makeGetLocal(valHighBits, i32)
    );
    curr->value = builder->makeGetLocal(tmp, i32);
    curr->type = i32;
    replaceCurrent(builder->blockify(setLow, setHigh, curr));
  }

  void visitSwitch(Switch* curr) {
    if (!hasOutParam(curr->value)) return;
    TempVar outParam = fetchOutParam(curr->value);
    TempVar tmp = getTemp();
    Expression* result = curr;
    std::vector<Name> targets;
    size_t blockID = 0;
    auto processTarget = [&](Name target) -> Name {
      auto labelIt = labelHighBitVars.find(target);
      if (labelIt == labelHighBitVars.end()) {
        labelHighBitVars.emplace(target, getTemp());
        labelIt = labelHighBitVars.find(target);
      }
      Name newLabel("$i64toi32_" + std::string(target.c_str()) +
                    "_" + std::to_string(blockID++));
      Block* trampoline = builder->makeBlock(newLabel, result);
      trampoline->type = i32;
      result = builder->blockify(
        builder->makeSetLocal(tmp, trampoline),
        builder->makeSetLocal(
          labelIt->second,
          builder->makeGetLocal(outParam, i32)
        ),
        builder->makeBreak(target, builder->makeGetLocal(tmp, i32))
      );
      return newLabel;
    };
    for (auto target : curr->targets) {
      targets.push_back(processTarget(target));
    }
    curr->targets.set(targets);
    curr->default_ = processTarget(curr->default_);
    replaceCurrent(result);
  }

  template <typename T>
  using BuilderFunc = std::function<T*(std::vector<Expression*>&, Type)>;

  template <typename T>
  void visitGenericCall(T* curr, BuilderFunc<T> callBuilder) {
    std::vector<Expression*> args;
    for (auto* e : curr->operands) {
      args.push_back(e);
      if (hasOutParam(e)) {
        TempVar argHighBits = fetchOutParam(e);
        args.push_back(builder->makeGetLocal(argHighBits, i32));
      }
    }
    if (curr->type != i64) {
      replaceCurrent(callBuilder(args, curr->type));
      return;
    }
    TempVar lowBits = getTemp();
    TempVar highBits = getTemp();
    SetLocal* doCall = builder->makeSetLocal(
      lowBits,
      callBuilder(args, i32)
    );
    SetLocal* setHigh = builder->makeSetLocal(
      highBits,
      builder->makeGetGlobal(INT64_TO_32_HIGH_BITS, i32)
    );
    GetLocal* getLow = builder->makeGetLocal(lowBits, i32);
    Block* result = builder->blockify(doCall, setHigh, getLow);
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }
  void visitCall(Call* curr) {
    visitGenericCall<Call>(
      curr,
      [&](std::vector<Expression*>& args, Type ty) {
        return builder->makeCall(curr->target, args, ty);
      }
    );
  }

  void visitCallIndirect(CallIndirect* curr) {
    visitGenericCall<CallIndirect>(
      curr,
      [&](std::vector<Expression*>& args, Type ty) {
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
    const auto mappedIndex = indexMap[curr->index];
    // Need to remap the local into the new naming scheme, regardless of
    // the type of the local.
    curr->index = mappedIndex;
    if (curr->type != i64) {
      return;
    }
    curr->type = i32;
    TempVar highBits = getTemp();
    SetLocal *setHighBits = builder->makeSetLocal(
      highBits,
      builder->makeGetLocal(
        mappedIndex + 1,
        i32
      )
    );
    Block* result = builder->blockify(setHighBits, curr);
    replaceCurrent(result);
    setOutParam(result, std::move(highBits));
  }

  void lowerTee(SetLocal* curr) {
    TempVar highBits = fetchOutParam(curr->value);
    TempVar tmp = getTemp();
    curr->type = i32;
    SetLocal* setLow = builder->makeSetLocal(tmp, curr);
    SetLocal* setHigh = builder->makeSetLocal(
      curr->index + 1,
      builder->makeGetLocal(highBits, i32)
    );
    GetLocal* getLow = builder->makeGetLocal(tmp, i32);
    Block* result = builder->blockify(setLow, setHigh, getLow);
    replaceCurrent(result);
    setOutParam(result, std::move(highBits));
  }

  void visitSetLocal(SetLocal* curr) {
    const auto mappedIndex = indexMap[curr->index];
    // Need to remap the local into the new naming scheme, regardless of
    // the type of the local.  Note that lowerTee depends on this happening.
    curr->index = mappedIndex;
    if (!hasOutParam(curr->value)) {
      return;
    }
    if (curr->isTee()) {
      lowerTee(curr);
      return;
    }
    TempVar highBits = fetchOutParam(curr->value);
    SetLocal* setHigh = builder->makeSetLocal(
      mappedIndex + 1,
      builder->makeGetLocal(highBits, i32)
    );
    Block* result = builder->blockify(curr, setHigh);
    replaceCurrent(result);
  }

  void visitGetGlobal(GetGlobal* curr) {
    if (curr->type != i64) return;
    assert(false && "GetGlobal not implemented");
  }

  void visitSetGlobal(SetGlobal* curr) {
    if (curr->type != i64) return;
    assert(false && "SetGlobal not implemented");
  }

  void visitLoad(Load* curr) {
    if (curr->type != i64) return;
    assert(!curr->isAtomic && "atomic load not implemented");
    TempVar lowBits = getTemp();
    TempVar highBits = getTemp();
    TempVar ptrTemp = getTemp();
    SetLocal* setPtr = builder->makeSetLocal(ptrTemp, curr->ptr);
    SetLocal* loadHigh;
    if (curr->bytes == 8) {
      loadHigh = builder->makeSetLocal(
        highBits,
        builder->makeLoad(
          4,
          curr->signed_,
          curr->offset + 4,
          1,
          builder->makeGetLocal(ptrTemp, i32),
          i32
        )
      );
    } else if (curr->signed_) {
      loadHigh = builder->makeSetLocal(
        highBits,
        builder->makeBinary(
          ShrSInt32,
          builder->makeGetLocal(lowBits, i32),
          builder->makeConst(Literal(int32_t(31)))
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
    curr->align = std::min(uint32_t(curr->align), uint32_t(4));
    curr->ptr = builder->makeGetLocal(ptrTemp, i32);
    Block* result = builder->blockify(
      setPtr,
      builder->makeSetLocal(lowBits, curr),
      loadHigh,
      builder->makeGetLocal(lowBits, i32)
    );
    replaceCurrent(result);
    setOutParam(result, std::move(highBits));
  }

  void visitStore(Store* curr) {
    if (!hasOutParam(curr->value)) return;
    assert(curr->offset + 4 > curr->offset);
    assert(!curr->isAtomic && "atomic store not implemented");
    TempVar highBits = fetchOutParam(curr->value);
    uint8_t bytes = curr->bytes;
    curr->bytes = std::min(curr->bytes, uint8_t(4));
    curr->align = std::min(uint32_t(curr->align), uint32_t(4));
    curr->valueType = i32;
    if (bytes == 8) {
      TempVar ptrTemp = getTemp();
      SetLocal* setPtr = builder->makeSetLocal(ptrTemp, curr->ptr);
      curr->ptr = builder->makeGetLocal(ptrTemp, i32);
      Store* storeHigh = builder->makeStore(
        4,
        curr->offset + 4,
        1,
        builder->makeGetLocal(ptrTemp, i32),
        builder->makeGetLocal(highBits, i32),
        i32
      );
      replaceCurrent(builder->blockify(setPtr, curr, storeHigh));
    }
  }

  void visitAtomicRMW(AtomicRMW* curr) {
    assert(false && "AtomicRMW not implemented");
  }

  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    assert(false && "AtomicCmpxchg not implemented");
  }

  void visitConst(Const* curr) {
    if (curr->type != i64) return;
    TempVar highBits = getTemp();
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
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerEqZInt64(Unary* curr) {
    TempVar highBits = fetchOutParam(curr->value);

    auto* result = builder->makeUnary(
      EqZInt32,
      builder->makeBinary(
        OrInt32,
        curr->value,
        builder->makeGetLocal(highBits, i32)
      )
    );

    replaceCurrent(result);
  }

  void lowerExtendUInt32(Unary* curr) {
    TempVar highBits = getTemp();
    Block* result = builder->blockify(
      builder->makeSetLocal(highBits, builder->makeConst(Literal(int32_t(0)))),
      curr->value
    );
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerExtendSInt32(Unary* curr) {
    TempVar highBits = getTemp();
    TempVar lowBits = getTemp();

    SetLocal* setLow = builder->makeSetLocal(lowBits, curr->value);
    SetLocal* setHigh = builder->makeSetLocal(
      highBits,
      builder->makeBinary(
        ShrSInt32,
        builder->makeGetLocal(lowBits, i32),
        builder->makeConst(Literal(int32_t(31)))
      )
    );

    Block* result = builder->blockify(
      setLow,
      setHigh,
      builder->makeGetLocal(lowBits, i32)
    );

    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerWrapInt64(Unary* curr) {
    // free the temp var
    fetchOutParam(curr->value);
    replaceCurrent(curr->value);
  }

  void lowerReinterpretFloat64(Unary* curr) {
    // Assume that the wasm file assumes the address 0 is invalid and roundtrip
    // our f64 through memory at address 0
    TempVar highBits = getTemp();
    Block *result = builder->blockify(
      builder->makeStore(8, 0, 8, builder->makeConst(Literal(int32_t(0))), curr->value, f64),
      builder->makeSetLocal(
        highBits,
        builder->makeLoad(4, true, 4, 4, builder->makeConst(Literal(int32_t(0))), i32)
      ),
      builder->makeLoad(4, true, 0, 4, builder->makeConst(Literal(int32_t(0))), i32)
    );
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerReinterpretInt64(Unary* curr) {
    // Assume that the wasm file assumes the address 0 is invalid and roundtrip
    // our i64 through memory at address 0
    TempVar highBits = fetchOutParam(curr->value);
    Block *result = builder->blockify(
      builder->makeStore(4, 0, 4, builder->makeConst(Literal(int32_t(0))), curr->value, i32),
      builder->makeStore(4, 4, 4, builder->makeConst(Literal(int32_t(0))), builder->makeGetLocal(highBits, i32), i32),
      builder->makeLoad(8, true, 0, 8, builder->makeConst(Literal(int32_t(0))), f64)
    );
    replaceCurrent(result);
  }

  void lowerTruncFloatToInt(Unary *curr) {
    // hiBits = if abs(f) >= 1.0 {
    //    if f > 0.0 {
    //        (unsigned) min(
    //          floor(f / (float) U32_MAX),
    //          (float) U32_MAX - 1,
    //        )
    //    } else {
    //        (unsigned) ceil((f - (float) (unsigned) f) / ((float) U32_MAX))
    //    }
    // } else {
    //    0
    // }
    //
    // loBits = (unsigned) f;

    Literal litZero, litOne, u32Max;
    UnaryOp trunc, convert, abs, floor, ceil;
    Type localType;
    BinaryOp ge, gt, min, div, sub;
    switch (curr->op) {
      case TruncSFloat32ToInt64:
      case TruncUFloat32ToInt64: {
        litZero = Literal((float) 0);
        litOne = Literal((float) 1);
        u32Max = Literal(((float) UINT_MAX) + 1);
        trunc = TruncUFloat32ToInt32;
        convert = ConvertUInt32ToFloat32;
        localType = f32;
        abs = AbsFloat32;
        ge = GeFloat32;
        gt = GtFloat32;
        min = MinFloat32;
        floor = FloorFloat32;
        ceil = CeilFloat32;
        div = DivFloat32;
        sub = SubFloat32;
        break;
      }
      case TruncSFloat64ToInt64:
      case TruncUFloat64ToInt64: {
        litZero = Literal((double) 0);
        litOne = Literal((double) 1);
        u32Max = Literal(((double) UINT_MAX) + 1);
        trunc = TruncUFloat64ToInt32;
        convert = ConvertUInt32ToFloat64;
        localType = f64;
        abs = AbsFloat64;
        ge = GeFloat64;
        gt = GtFloat64;
        min = MinFloat64;
        floor = FloorFloat64;
        ceil = CeilFloat64;
        div = DivFloat64;
        sub = SubFloat64;
        break;
      }
      default: abort();
    }

    TempVar f = getTemp(localType);
    TempVar highBits = getTemp();

    Expression *gtZeroBranch = builder->makeBinary(
        min,
        builder->makeUnary(
          floor,
          builder->makeBinary(
            div,
            builder->makeGetLocal(f, localType),
            builder->makeConst(u32Max)
          )
        ),
        builder->makeBinary(sub, builder->makeConst(u32Max), builder->makeConst(litOne))
    );
    Expression *ltZeroBranch = builder->makeUnary(
        ceil,
        builder->makeBinary(
          div,
          builder->makeBinary(
            sub,
            builder->makeGetLocal(f, localType),
            builder->makeUnary(convert,
              builder->makeUnary(trunc, builder->makeGetLocal(f, localType))
            )
          ),
          builder->makeConst(u32Max)
        )
    );

    If *highBitsCalc = builder->makeIf(
      builder->makeBinary(
        gt,
        builder-> makeGetLocal(f, localType),
        builder->makeConst(litZero)
      ),
      builder->makeUnary(trunc, gtZeroBranch),
      builder->makeUnary(trunc, ltZeroBranch)
    );
    If *highBitsVal = builder->makeIf(
      builder->makeBinary(
        ge,
        builder->makeUnary(abs, builder->makeGetLocal(f, localType)),
        builder->makeConst(litOne)
      ),
      highBitsCalc,
      builder->makeConst(Literal(int32_t(0)))
    );
    Block *result = builder->blockify(
      builder->makeSetLocal(f, curr->value),
      builder->makeSetLocal(highBits, highBitsVal),
      builder->makeUnary(trunc, builder->makeGetLocal(f, localType))
    );
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerConvertIntToFloat(Unary *curr) {
    // Here the same strategy as `emcc` is taken which takes the two halves of
    // the 64-bit integer and creates a mathematical expression using float
    // arithmetic to reassemble the final floating point value.
    //
    // For example for i64 -> f32 we generate:
    //
    //  ((double) (unsigned) lowBits) + ((double) U32_MAX) * ((double) (int) highBits)
    //
    // Mostly just shuffling things around here with coercions and whatnot!
    // Note though that all arithmetic is done with f64 to have as much
    // precision as we can.
    TempVar highBits = fetchOutParam(curr->value);
    TempVar lowBits = getTemp();
    TempVar highResult = getTemp();

    UnaryOp convertHigh;
    switch (curr->op) {
      case ConvertSInt64ToFloat32:
      case ConvertSInt64ToFloat64:
        convertHigh = ConvertSInt32ToFloat64;
        break;
      case ConvertUInt64ToFloat32:
      case ConvertUInt64ToFloat64:
        convertHigh = ConvertUInt32ToFloat64;
        break;
      default: abort();
    }

    Expression *result = builder->blockify(
      builder->makeSetLocal(lowBits, curr->value),
      builder->makeSetLocal(
        highResult,
        builder->makeConst(Literal(int32_t(0)))
      ),
      builder->makeBinary(
        AddFloat64,
        builder->makeUnary(
          ConvertUInt32ToFloat64,
          builder->makeGetLocal(lowBits, i32)
        ),
        builder->makeBinary(
          MulFloat64,
          builder->makeConst(Literal((double)UINT_MAX + 1)),
          builder->makeUnary(
            convertHigh,
            builder->makeGetLocal(highBits, i32)
          )
        )
      )
    );

    switch (curr->op) {
      case ConvertSInt64ToFloat32:
      case ConvertUInt64ToFloat32: {
        result = builder->makeUnary(DemoteFloat64, result);
        break;
      }
      default: break;
    }

    replaceCurrent(result);
  }

  void lowerCountZeros(Unary* curr) {
    auto lower = [&](Block* result, UnaryOp op32, TempVar&& first, TempVar&& second) {
      TempVar highResult = getTemp();
      TempVar firstResult = getTemp();
      SetLocal* setFirst = builder->makeSetLocal(
        firstResult,
        builder->makeUnary(op32, builder->makeGetLocal(first, i32))
      );

      Binary* check = builder->makeBinary(
        EqInt32,
        builder->makeGetLocal(firstResult, i32),
        builder->makeConst(Literal(int32_t(32)))
      );

      If* conditional = builder->makeIf(
        check,
        builder->makeBinary(
          AddInt32,
          builder->makeUnary(op32, builder->makeGetLocal(second, i32)),
          builder->makeConst(Literal(int32_t(32)))
        ),
        builder->makeGetLocal(firstResult, i32)
      );

      SetLocal* setHigh = builder->makeSetLocal(
        highResult,
        builder->makeConst(Literal(int32_t(0)))
      );

      setOutParam(result, std::move(highResult));

      replaceCurrent(
        builder->blockify(
          result,
          setFirst,
          setHigh,
          conditional
        )
      );
    };

    TempVar highBits = fetchOutParam(curr->value);
    TempVar lowBits = getTemp();
    SetLocal* setLow = builder->makeSetLocal(lowBits, curr->value);
    Block* result = builder->blockify(setLow);

    switch (curr->op) {
      case ClzInt64:
        lower(result, ClzInt32, std::move(highBits), std::move(lowBits));
        break;
      case CtzInt64:
        std::cerr << "i64.ctz should be removed already" << std::endl;
        WASM_UNREACHABLE();
        break;
      default:
        abort();
    }
  }

  bool unaryNeedsLowering(UnaryOp op) {
    switch (op) {
      case ClzInt64:
      case CtzInt64:
      case PopcntInt64:
      case EqZInt64:
      case ExtendSInt32:
      case ExtendUInt32:
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
      case ReinterpretInt64: return true;
      default: return false;
    }
  }

  void visitUnary(Unary* curr) {
    if (!unaryNeedsLowering(curr->op)) return;
    if (curr->type == unreachable || curr->value->type == unreachable) {
      assert(!hasOutParam(curr->value));
      replaceCurrent(curr->value);
      return;
    }
    assert(hasOutParam(curr->value) || curr->type == i64 || curr->type == f64);
    switch (curr->op) {
      case ClzInt64:
      case CtzInt64:               lowerCountZeros(curr);   break;
      case EqZInt64:               lowerEqZInt64(curr);     break;
      case ExtendSInt32:           lowerExtendSInt32(curr); break;
      case ExtendUInt32:           lowerExtendUInt32(curr); break;
      case WrapInt64:              lowerWrapInt64(curr);    break;
      case ReinterpretFloat64:     lowerReinterpretFloat64(curr); break;
      case ReinterpretInt64:       lowerReinterpretInt64(curr);   break;
      case TruncSFloat32ToInt64:
      case TruncUFloat32ToInt64:
      case TruncSFloat64ToInt64:
      case TruncUFloat64ToInt64:   lowerTruncFloatToInt(curr);   break;
      case ConvertSInt64ToFloat32:
      case ConvertSInt64ToFloat64:
      case ConvertUInt64ToFloat32:
      case ConvertUInt64ToFloat64: lowerConvertIntToFloat(curr); break;
      case PopcntInt64:
        std::cerr << "i64.popcnt should already be removed" << std::endl;
        WASM_UNREACHABLE();
      default:
        std::cerr << "Unhandled unary operator: " << curr->op << std::endl;
        abort();
    }
  }

  Block* lowerAdd(Block* result, TempVar&& leftLow, TempVar&& leftHigh,
                  TempVar&& rightLow, TempVar&& rightHigh) {
    TempVar lowResult = getTemp();
    TempVar highResult = getTemp();
    SetLocal* addLow = builder->makeSetLocal(
      lowResult,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(rightLow, i32)
      )
    );
    SetLocal* addHigh = builder->makeSetLocal(
      highResult,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(leftHigh, i32),
        builder->makeGetLocal(rightHigh, i32)
      )
    );
    SetLocal* carryBit = builder->makeSetLocal(
      highResult,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(highResult, i32),
        builder->makeConst(Literal(int32_t(1)))
      )
    );
    If* checkOverflow = builder->makeIf(
      builder->makeBinary(
        LtUInt32,
        builder->makeGetLocal(lowResult, i32),
        builder->makeGetLocal(rightLow, i32)
      ),
      carryBit
    );
    GetLocal* getLow = builder->makeGetLocal(lowResult, i32);
    result = builder->blockify(result, addLow, addHigh, checkOverflow, getLow);
    setOutParam(result, std::move(highResult));
    return result;
  }

  Block* lowerSub(Block* result, TempVar&& leftLow, TempVar&& leftHigh,
                  TempVar&& rightLow, TempVar&& rightHigh) {
    TempVar lowResult = getTemp();
    TempVar highResult = getTemp();
    TempVar borrow = getTemp();
    SetLocal* subLow = builder->makeSetLocal(
      lowResult,
      builder->makeBinary(
        SubInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(rightLow, i32)
      )
    );
    SetLocal* borrowBit = builder->makeSetLocal(
      borrow,
      builder->makeBinary(
        LtUInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(rightLow, i32)
      )
    );
    SetLocal* subHigh1 = builder->makeSetLocal(
      highResult,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(borrow, i32),
        builder->makeGetLocal(rightHigh, i32)
      )
    );
    SetLocal* subHigh2 = builder->makeSetLocal(
      highResult,
      builder->makeBinary(
        SubInt32,
        builder->makeGetLocal(leftHigh, i32),
        builder->makeGetLocal(highResult, i32)
      )
    );
    GetLocal* getLow = builder->makeGetLocal(lowResult, i32);
    result = builder->blockify(result, subLow, borrowBit, subHigh1, subHigh2, getLow);
    setOutParam(result, std::move(highResult));
    return result;
  }

  Block* lowerBitwise(BinaryOp op, Block* result, TempVar&& leftLow,
                      TempVar&& leftHigh, TempVar&& rightLow,
                      TempVar&& rightHigh) {
    BinaryOp op32;
    switch (op) {
      case AndInt64: op32 = AndInt32; break;
      case  OrInt64: op32 =  OrInt32; break;
      case XorInt64: op32 = XorInt32; break;
      default: abort();
    }
    result = builder->blockify(
      result,
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
    setOutParam(result, std::move(rightHigh));
    return result;
  }

  Block* makeLargeShl(Index highBits, Index leftLow, Index shift) {
    return builder->blockify(
      builder->makeSetLocal(
        highBits,
        builder->makeBinary(
          ShlInt32,
          builder->makeGetLocal(leftLow, i32),
          builder->makeGetLocal(shift, i32)
        )
      ),
      builder->makeConst(Literal(int32_t(0)))
    );
  }

  // a >> b where `b` >= 32
  //
  // implement as:
  //
  // hi = leftHigh >> 31 // copy sign bit
  // lo = leftHigh >> (b - 32)
  Block* makeLargeShrS(Index highBits, Index leftHigh, Index shift) {
    return builder->blockify(
      builder->makeSetLocal(
        highBits,
        builder->makeBinary(
          ShrSInt32,
          builder->makeGetLocal(leftHigh, i32),
          builder->makeConst(Literal(int32_t(31)))
        )
      ),
      builder->makeBinary(
        ShrSInt32,
        builder->makeGetLocal(leftHigh, i32),
        builder->makeGetLocal(shift, i32)
      )
    );
  }

  Block* makeLargeShrU(Index highBits, Index leftHigh, Index shift) {
    return builder->blockify(
      builder->makeSetLocal(highBits, builder->makeConst(Literal(int32_t(0)))),
      builder->makeBinary(
        ShrUInt32,
        builder->makeGetLocal(leftHigh, i32),
        builder->makeGetLocal(shift, i32)
      )
    );
  }

  Block* makeSmallShl(Index highBits, Index leftLow, Index leftHigh,
                      Index shift, Binary* shiftMask, Binary* widthLessShift) {
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
    return builder->blockify(
      builder->makeSetLocal(
        highBits,
        builder->makeBinary(OrInt32, shiftedInBits, shiftHigh)
      ),
      builder->makeBinary(
        ShlInt32,
        builder->makeGetLocal(leftLow, i32),
        builder->makeGetLocal(shift, i32)
      )
    );
  }

  // a >> b where `b` < 32
  //
  // implement as:
  //
  // hi = leftHigh >> b
  // lo = (leftLow >>> b) | (leftHigh << (32 - b))
  Block* makeSmallShrS(Index highBits, Index leftLow, Index leftHigh,
                       Index shift, Binary* shiftMask, Binary* widthLessShift) {
    Binary* shiftedInBits = builder->makeBinary(
      ShlInt32,
      builder->makeBinary(
        AndInt32,
        shiftMask,
        builder->makeGetLocal(leftHigh, i32)
      ),
      widthLessShift
    );
    Binary* shiftLow = builder->makeBinary(
      ShrUInt32,
      builder->makeGetLocal(leftLow, i32),
      builder->makeGetLocal(shift, i32)
    );
    return builder->blockify(
      builder->makeSetLocal(
        highBits,
        builder->makeBinary(
          ShrSInt32,
          builder->makeGetLocal(leftHigh, i32),
          builder->makeGetLocal(shift, i32)
        )
      ),
      builder->makeBinary(OrInt32, shiftedInBits, shiftLow)
    );
  }

  Block* makeSmallShrU(Index highBits, Index leftLow, Index leftHigh,
                       Index shift, Binary* shiftMask, Binary* widthLessShift) {
    Binary* shiftedInBits = builder->makeBinary(
      ShlInt32,
      builder->makeBinary(
        AndInt32,
        shiftMask,
        builder->makeGetLocal(leftHigh, i32)
      ),
      widthLessShift
    );
    Binary* shiftLow = builder->makeBinary(
      ShrUInt32,
      builder->makeGetLocal(leftLow, i32),
      builder->makeGetLocal(shift, i32)
    );
    return builder->blockify(
      builder->makeSetLocal(
        highBits,
        builder->makeBinary(
          ShrUInt32,
          builder->makeGetLocal(leftHigh, i32),
          builder->makeGetLocal(shift, i32)
        )
      ),
      builder->makeBinary(OrInt32, shiftedInBits, shiftLow)
    );
  }

  Block* lowerShift(BinaryOp op, Block* result, TempVar&& leftLow,
                    TempVar&& leftHigh, TempVar&& rightLow, TempVar&& rightHigh) {
    assert(op == ShlInt64 || op == ShrUInt64 || op == ShrSInt64);
    // shift left lowered as:
    // if 32 <= rightLow % 64:
    //     high = leftLow << k; low = 0
    // else:
    //     high = (((1 << k) - 1) & (leftLow >> (32 - k))) | (leftHigh << k);
    //     low = leftLow << k
    // where k = shift % 32. shift right is similar.
    TempVar shift = getTemp();
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
    Block* largeShiftBlock;
    switch (op) {
      case ShlInt64:
        largeShiftBlock = makeLargeShl(rightHigh, leftLow, shift); break;
      case ShrSInt64:
        largeShiftBlock = makeLargeShrS(rightHigh, leftHigh, shift); break;
      case ShrUInt64:
        largeShiftBlock = makeLargeShrU(rightHigh, leftHigh, shift); break;
      default: abort();
    }
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
    Block* smallShiftBlock;
    switch(op) {
      case ShlInt64: {
        smallShiftBlock = makeSmallShl(rightHigh, leftLow, leftHigh,
                                       shift, shiftMask, widthLessShift);
        break;
      }
      case ShrSInt64: {
        smallShiftBlock = makeSmallShrS(rightHigh, leftLow, leftHigh,
                                        shift, shiftMask, widthLessShift);
        break;
      }
      case ShrUInt64: {
        smallShiftBlock = makeSmallShrU(rightHigh, leftLow, leftHigh,
                                        shift, shiftMask, widthLessShift);
        break;
      }
      default: abort();
    }
    If* ifLargeShift = builder->makeIf(
      isLargeShift,
      largeShiftBlock,
      smallShiftBlock
    );
    result = builder->blockify(result, setShift, ifLargeShift);
    setOutParam(result, std::move(rightHigh));
    return result;
  }

  Block* lowerEq(Block* result, TempVar&& leftLow, TempVar&& leftHigh,
                    TempVar&& rightLow, TempVar&& rightHigh) {
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

  Block* lowerNe(Block* result, TempVar&& leftLow, TempVar&& leftHigh,
                 TempVar&& rightLow, TempVar&& rightHigh) {
    return builder->blockify(
      result,
      builder->makeBinary(
        OrInt32,
        builder->makeBinary(
          NeInt32,
          builder->makeGetLocal(leftLow, i32),
          builder->makeGetLocal(rightLow, i32)
        ),
        builder->makeBinary(
          NeInt32,
          builder->makeGetLocal(leftHigh, i32),
          builder->makeGetLocal(rightHigh, i32)
        )
      )
    );
  }

  Block* lowerUComp(BinaryOp op, Block* result, TempVar&& leftLow,
                    TempVar&& leftHigh, TempVar&& rightLow,
                    TempVar&& rightHigh) {
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

  Block* lowerSComp(BinaryOp op, Block* result, TempVar&& leftLow,
		    TempVar&& leftHigh, TempVar&& rightLow,
		    TempVar&& rightHigh) {
    BinaryOp highOp1, highOp2, lowOp;
    switch (op) {
      case LtSInt64: highOp1 = LtSInt32; highOp2 = LeSInt32; lowOp = GeUInt32; break;
      case LeSInt64: highOp1 = LtSInt32; highOp2 = LeSInt32; lowOp = GtUInt32; break;
      case GtSInt64: highOp1 = GtSInt32; highOp2 = GeSInt32; lowOp = LeUInt32; break;
      case GeSInt64: highOp1 = GtSInt32; highOp2 = GeSInt32; lowOp = LtUInt32; break;
      default: abort();
    }
    Binary* compHigh1 = builder->makeBinary(
      highOp1,
      builder->makeGetLocal(leftHigh, i32),
      builder->makeGetLocal(rightHigh, i32)
    );
    Binary* compHigh2 = builder->makeBinary(
      highOp2,
      builder->makeGetLocal(leftHigh, i32),
      builder->makeGetLocal(rightHigh, i32)
    );
    Binary* compLow = builder->makeBinary(
      lowOp,
      builder->makeGetLocal(leftLow, i32),
      builder->makeGetLocal(rightLow, i32)
    );
    If* lowIf = builder->makeIf(
      compLow,
      builder->makeConst(Literal(int32_t(0))),
      builder->makeConst(Literal(int32_t(1)))
    );
    If* highIf2 = builder->makeIf(
      compHigh2,
      lowIf,
      builder->makeConst(Literal(int32_t(0)))
    );
    If* highIf1 = builder->makeIf(
      compHigh1,
      builder->makeConst(Literal(int32_t(1))),
      highIf2
    );
    return builder->blockify(result, highIf1);
  }

  bool binaryNeedsLowering(BinaryOp op) {
    switch (op) {
      case AddInt64:
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
      case GeUInt64: return true;
      default: return false;
    }
  }

  void visitBinary(Binary* curr) {
    if (!binaryNeedsLowering(curr->op)) return;
    if (!hasOutParam(curr->left)) {
      // left unreachable, replace self with left
      replaceCurrent(curr->left);
      if (hasOutParam(curr->right)) {
        // free temp var
        fetchOutParam(curr->right);
      }
      return;
    }
    if (!hasOutParam(curr->right)) {
      // right unreachable, replace self with left then right
      replaceCurrent(
        builder->blockify(builder->makeDrop(curr->left), curr->right)
      );
      // free temp var
      fetchOutParam(curr->left);
      return;
    }
    // left and right reachable, lower normally
    TempVar leftLow = getTemp();
    TempVar leftHigh = fetchOutParam(curr->left);
    TempVar rightLow = getTemp();
    TempVar rightHigh = fetchOutParam(curr->right);
    SetLocal* setRight = builder->makeSetLocal(rightLow, curr->right);
    SetLocal* setLeft = builder->makeSetLocal(leftLow, curr->left);
    Block* result = builder->blockify(setLeft, setRight);
    switch (curr->op) {
      case AddInt64: {
        replaceCurrent(
          lowerAdd(result, std::move(leftLow), std::move(leftHigh),
                   std::move(rightLow), std::move(rightHigh)));
        break;
      }
      case SubInt64: {
        replaceCurrent(
          lowerSub(result, std::move(leftLow), std::move(leftHigh),
                   std::move(rightLow), std::move(rightHigh)));
        break;
      }
      case MulInt64:
      case DivSInt64:
      case DivUInt64:
      case RemSInt64:
      case RemUInt64:
      case RotLInt64:
      case RotRInt64:
        std::cerr << "should have been removed by now " << curr->op << std::endl;
        WASM_UNREACHABLE();

      case AndInt64:
      case OrInt64:
      case XorInt64: {
        replaceCurrent(
          lowerBitwise(curr->op, result, std::move(leftLow),
                       std::move(leftHigh), std::move(rightLow),
                       std::move(rightHigh))
        );
        break;
      }
      case ShlInt64:
      case ShrSInt64:
      case ShrUInt64: {
        replaceCurrent(
          lowerShift(curr->op, result, std::move(leftLow), std::move(leftHigh),
                     std::move(rightLow), std::move(rightHigh))
        );
        break;
      }
      case EqInt64: {
        replaceCurrent(
          lowerEq(result, std::move(leftLow), std::move(leftHigh),
                  std::move(rightLow), std::move(rightHigh))
        );
        break;
      }
      case NeInt64: {
        replaceCurrent(
          lowerNe(result, std::move(leftLow), std::move(leftHigh),
                  std::move(rightLow), std::move(rightHigh))
        );
        break;
      }
      case LtSInt64:
      case LeSInt64:
      case GtSInt64:
      case GeSInt64:
        replaceCurrent(
          lowerSComp(curr->op, result, std::move(leftLow), std::move(leftHigh),
                     std::move(rightLow), std::move(rightHigh))
        );
	break;
      case LtUInt64:
      case LeUInt64:
      case GtUInt64:
      case GeUInt64: {
        replaceCurrent(
          lowerUComp(curr->op, result, std::move(leftLow), std::move(leftHigh),
                     std::move(rightLow), std::move(rightHigh))
        );
        break;
      }
      default: {
        std::cerr << "Unhandled binary op " << curr->op << std::endl;
        abort();
      }
    }
  }

  void visitSelect(Select* curr) {
    visitBranching<Select>(curr);
  }

  void visitDrop(Drop* curr) {
    if (!hasOutParam(curr->value)) return;
    // free temp var
    fetchOutParam(curr->value);
  }

  void visitReturn(Return* curr) {
    if (!hasOutParam(curr->value)) return;
    TempVar lowBits = getTemp();
    TempVar highBits = fetchOutParam(curr->value);
    SetLocal* setLow = builder->makeSetLocal(lowBits, curr->value);
    SetGlobal* setHigh = builder->makeSetGlobal(
      INT64_TO_32_HIGH_BITS,
      builder->makeGetLocal(highBits, i32)
    );
    curr->value = builder->makeGetLocal(lowBits, i32);
    Block* result = builder->blockify(setLow, setHigh, curr);
    replaceCurrent(result);
  }

private:
  std::unique_ptr<Builder> builder;
  std::unordered_map<Index, Index> indexMap;
  std::unordered_map<int, std::vector<Index>> freeTemps;
  std::unordered_map<Expression*, TempVar> highBitVars;
  std::unordered_map<Name, TempVar> labelHighBitVars;
  std::unordered_map<Index, Type> tempTypes;
  Index nextTemp;

  TempVar getTemp(Type ty = i32) {
    Index ret;
    auto &freeList = freeTemps[(int) ty];
    if (freeList.size() > 0) {
      ret = freeList.back();
      freeList.pop_back();
    } else {
      ret = nextTemp++;
      tempTypes[ret] = ty;
    }
    assert(tempTypes[ret] == ty);
    return TempVar(ret, ty, *this);
  }

  bool hasOutParam(Expression* e) {
    return highBitVars.find(e) != highBitVars.end();
  }

  void setOutParam(Expression* e, TempVar&& var) {
    highBitVars.emplace(e, std::move(var));
  }

  TempVar fetchOutParam(Expression* e) {
    auto outParamIt = highBitVars.find(e);
    assert(outParamIt != highBitVars.end());
    TempVar ret = std::move(outParamIt->second);
    highBitVars.erase(e);
    return ret;
  }
};

Pass *createI64ToI32LoweringPass() {
  return new I64ToI32Lowering();
}

}
