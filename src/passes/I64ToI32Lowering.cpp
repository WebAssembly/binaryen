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

#include "abi/js.h"
#include "ir/flat.h"
#include "ir/iteration.h"
#include "ir/memory-utils.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "support/istring.h"
#include "support/name.h"
#include "wasm-builder.h"
#include "wasm.h"
#include <algorithm>

namespace wasm {

static Name makeHighName(Name n) { return n.toString() + "$hi"; }

struct I64ToI32Lowering : public WalkerPass<PostWalker<I64ToI32Lowering>> {
  // Adds calls to helper functions.
  bool addsEffects() override { return true; }

  struct TempVar {
    TempVar(Index idx, Type ty, I64ToI32Lowering& pass)
      : idx(idx), pass(pass), moved(false), ty(ty) {}

    TempVar(TempVar&& other)
      : idx(other), pass(other.pass), moved(false), ty(other.ty) {
      assert(!other.moved);
      other.moved = true;
    }

    TempVar& operator=(TempVar&& rhs) {
      assert(!rhs.moved);
      // free overwritten idx
      if (!moved) {
        freeIdx();
      }
      idx = rhs.idx;
      rhs.moved = true;
      moved = false;
      return *this;
    }

    ~TempVar() {
      if (!moved) {
        freeIdx();
      }
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
      auto& freeList = pass.freeTemps[ty.getBasic()];
      assert(std::find(freeList.begin(), freeList.end(), idx) ==
             freeList.end());
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<I64ToI32Lowering>();
  }

  void doWalkModule(Module* module) {
    if (!builder) {
      builder = std::make_unique<Builder>(*module);
    }
    // add new globals for high bits
    for (size_t i = 0, globals = module->globals.size(); i < globals; ++i) {
      auto* curr = module->globals[i].get();
      if (curr->type != Type::i64) {
        continue;
      }
      originallyI64Globals.insert(curr->name);
      curr->type = Type::i32;
      auto high = builder->makeGlobal(makeHighName(curr->name),
                                      Type::i32,
                                      builder->makeConst(int32_t(0)),
                                      curr->mutable_ ? Builder::Mutable
                                                     : Builder::Immutable);
      if (curr->imported()) {
        Fatal() << "TODO: imported i64 globals";
      } else {
        if (auto* c = curr->init->dynCast<Const>()) {
          uint64_t value = c->value.geti64();
          c->value = Literal(uint32_t(value));
          c->type = Type::i32;
          high->init = builder->makeConst(uint32_t(value >> 32));
        } else if (auto* get = curr->init->dynCast<GlobalGet>()) {
          high->init =
            builder->makeGlobalGet(makeHighName(get->name), Type::i32);
        } else {
          WASM_UNREACHABLE("unexpected expression type");
        }
        curr->init->type = Type::i32;
      }
      module->addGlobal(std::move(high));
    }

    // For functions that return 64-bit values, we use this global variable
    // to return the high 32 bits.
    auto* highBits = new Global();
    highBits->type = Type::i32;
    highBits->name = INT64_TO_32_HIGH_BITS;
    highBits->init = builder->makeConst(int32_t(0));
    highBits->mutable_ = true;
    module->addGlobal(highBits);
    PostWalker<I64ToI32Lowering>::doWalkModule(module);
  }

  void doWalkFunction(Function* func) {
    Flat::verifyFlatness(func);
    // create builder here if this is first entry to module for this object
    if (!builder) {
      builder = std::make_unique<Builder>(*getModule());
    }
    indexMap.clear();
    highBitVars.clear();
    freeTemps.clear();
    Module temp;
    auto* oldFunc = ModuleUtils::copyFunction(func, temp);
    func->setParams(Type::none);
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
      auto builderFunc =
        (i < oldFunc->getVarIndexBase())
          ? Builder::addParam
          : static_cast<Index (*)(Function*, Name, Type)>(Builder::addVar);
      if (paramType == Type::i64) {
        builderFunc(func, lowName, Type::i32);
        builderFunc(func, highName, Type::i32);
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
    if (func->getResults() == Type::i64) {
      func->setResults(Type::i32);
      // body may not have out param if it ends with control flow
      if (hasOutParam(func->body)) {
        TempVar highBits = fetchOutParam(func->body);
        TempVar lowBits = getTemp();
        LocalSet* setLow = builder->makeLocalSet(lowBits, func->body);
        GlobalSet* setHigh = builder->makeGlobalSet(
          INT64_TO_32_HIGH_BITS, builder->makeLocalGet(highBits, Type::i32));
        LocalGet* getLow = builder->makeLocalGet(lowBits, Type::i32);
        func->body = builder->blockify(setLow, setHigh, getLow);
      }
    }
    int idx = 0;
    for (size_t i = func->getNumLocals(); i < nextTemp; i++) {
      Name tmpName("i64toi32_i32$" + std::to_string(idx++));
      builder->addVar(func, tmpName, tempTypes[i]);
    }
  }

  template<typename T>
  using BuilderFunc = std::function<T*(std::vector<Expression*>&, Type)>;

  // Fixes up a call. If we performed fixups, returns the call; otherwise
  // returns nullptr;
  template<typename T>
  T* visitGenericCall(T* curr, BuilderFunc<T> callBuilder) {
    if (handleUnreachable(curr)) {
      return nullptr;
    }
    bool fixed = false;
    std::vector<Expression*> args;
    for (auto* e : curr->operands) {
      args.push_back(e);
      if (hasOutParam(e)) {
        TempVar argHighBits = fetchOutParam(e);
        args.push_back(builder->makeLocalGet(argHighBits, Type::i32));
        fixed = true;
      }
    }
    if (curr->type != Type::i64) {
      auto* ret = callBuilder(args, curr->type);
      replaceCurrent(ret);
      return fixed ? ret : nullptr;
    }
    TempVar lowBits = getTemp();
    TempVar highBits = getTemp();
    auto* call = callBuilder(args, Type::i32);
    LocalSet* doCall = builder->makeLocalSet(lowBits, call);
    LocalSet* setHigh = builder->makeLocalSet(
      highBits, builder->makeGlobalGet(INT64_TO_32_HIGH_BITS, Type::i32));
    LocalGet* getLow = builder->makeLocalGet(lowBits, Type::i32);
    Block* result = builder->blockify(doCall, setHigh, getLow);
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
    return call;
  }
  void visitCall(Call* curr) {
    if (curr->isReturn &&
        getModule()->getFunction(curr->target)->getResults() == Type::i64) {
      Fatal()
        << "i64 to i32 lowering of return_call values not yet implemented";
    }
    auto* fixedCall = visitGenericCall<Call>(
      curr, [&](std::vector<Expression*>& args, Type results) {
        return builder->makeCall(curr->target, args, results, curr->isReturn);
      });
    // If this was to an import, we need to call the legal version. This assumes
    // that legalize-js-interface has been run before.
    if (fixedCall && getModule()->getFunction(fixedCall->target)->imported()) {
      fixedCall->target =
        std::string("legalfunc$") + fixedCall->target.toString();
      return;
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (curr->isReturn && curr->heapType.getSignature().results == Type::i64) {
      Fatal()
        << "i64 to i32 lowering of return_call values not yet implemented";
    }
    visitGenericCall<CallIndirect>(
      curr, [&](std::vector<Expression*>& args, Type results) {
        std::vector<Type> params;
        for (const auto& param : curr->heapType.getSignature().params) {
          if (param == Type::i64) {
            params.push_back(Type::i32);
            params.push_back(Type::i32);
          } else {
            params.push_back(param);
          }
        }
        return builder->makeCallIndirect(curr->table,
                                         curr->target,
                                         args,
                                         Signature(Type(params), results),
                                         curr->isReturn);
      });
  }

  void visitLocalGet(LocalGet* curr) {
    const auto mappedIndex = indexMap[curr->index];
    // Need to remap the local into the new naming scheme, regardless of
    // the type of the local.
    curr->index = mappedIndex;
    if (curr->type != Type::i64) {
      return;
    }
    curr->type = Type::i32;
    TempVar highBits = getTemp();
    LocalSet* setHighBits = builder->makeLocalSet(
      highBits, builder->makeLocalGet(mappedIndex + 1, Type::i32));
    Block* result = builder->blockify(setHighBits, curr);
    replaceCurrent(result);
    setOutParam(result, std::move(highBits));
  }

  void lowerTee(LocalSet* curr) {
    TempVar highBits = fetchOutParam(curr->value);
    TempVar tmp = getTemp();
    curr->type = Type::i32;
    LocalSet* setLow = builder->makeLocalSet(tmp, curr);
    LocalSet* setHigh = builder->makeLocalSet(
      curr->index + 1, builder->makeLocalGet(highBits, Type::i32));
    LocalGet* getLow = builder->makeLocalGet(tmp, Type::i32);
    Block* result = builder->blockify(setLow, setHigh, getLow);
    replaceCurrent(result);
    setOutParam(result, std::move(highBits));
  }

  void visitLocalSet(LocalSet* curr) {
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
    auto* setHigh = builder->makeLocalSet(
      mappedIndex + 1, builder->makeLocalGet(highBits, Type::i32));
    Block* result = builder->blockify(curr, setHigh);
    replaceCurrent(result);
  }

  void visitGlobalGet(GlobalGet* curr) {
    if (!getFunction()) {
      return; // if in a global init, skip - we already handled that.
    }
    if (!originallyI64Globals.count(curr->name)) {
      return;
    }
    curr->type = Type::i32;
    TempVar highBits = getTemp();
    LocalSet* setHighBits = builder->makeLocalSet(
      highBits, builder->makeGlobalGet(makeHighName(curr->name), Type::i32));
    Block* result = builder->blockify(setHighBits, curr);
    replaceCurrent(result);
    setOutParam(result, std::move(highBits));
  }

  void visitGlobalSet(GlobalSet* curr) {
    if (!originallyI64Globals.count(curr->name)) {
      return;
    }
    if (handleUnreachable(curr)) {
      return;
    }
    TempVar highBits = fetchOutParam(curr->value);
    auto* setHigh = builder->makeGlobalSet(
      makeHighName(curr->name), builder->makeLocalGet(highBits, Type::i32));
    replaceCurrent(builder->makeSequence(curr, setHigh));
  }

  void visitLoad(Load* curr) {
    if (curr->type != Type::i64) {
      return;
    }
    assert(!curr->isAtomic && "64-bit atomic load not implemented");
    TempVar lowBits = getTemp();
    TempVar highBits = getTemp();
    TempVar ptrTemp = getTemp();
    LocalSet* setPtr = builder->makeLocalSet(ptrTemp, curr->ptr);
    LocalSet* loadHigh;
    if (curr->bytes == 8) {
      loadHigh = builder->makeLocalSet(
        highBits,
        builder->makeLoad(4,
                          curr->signed_,
                          curr->offset + 4,
                          std::min(uint32_t(curr->align), uint32_t(4)),
                          builder->makeLocalGet(ptrTemp, Type::i32),
                          Type::i32,
                          curr->memory));
    } else if (curr->signed_) {
      loadHigh = builder->makeLocalSet(
        highBits,
        builder->makeBinary(ShrSInt32,
                            builder->makeLocalGet(lowBits, Type::i32),
                            builder->makeConst(int32_t(31))));
    } else {
      loadHigh =
        builder->makeLocalSet(highBits, builder->makeConst(int32_t(0)));
    }
    curr->type = Type::i32;
    curr->bytes = std::min(curr->bytes, uint8_t(4));
    curr->align = std::min(uint32_t(curr->align), uint32_t(4));
    curr->ptr = builder->makeLocalGet(ptrTemp, Type::i32);
    Block* result =
      builder->blockify(setPtr,
                        builder->makeLocalSet(lowBits, curr),
                        loadHigh,
                        builder->makeLocalGet(lowBits, Type::i32));
    replaceCurrent(result);
    setOutParam(result, std::move(highBits));
  }

  void visitStore(Store* curr) {
    if (!hasOutParam(curr->value)) {
      return;
    }
    assert(curr->offset + 4 > curr->offset);
    assert(!curr->isAtomic && "atomic store not implemented");
    TempVar highBits = fetchOutParam(curr->value);
    uint8_t bytes = curr->bytes;
    curr->bytes = std::min(curr->bytes, uint8_t(4));
    curr->align = std::min(uint32_t(curr->align), uint32_t(4));
    curr->valueType = Type::i32;
    if (bytes == 8) {
      TempVar ptrTemp = getTemp();
      LocalSet* setPtr = builder->makeLocalSet(ptrTemp, curr->ptr);
      curr->ptr = builder->makeLocalGet(ptrTemp, Type::i32);
      curr->finalize();
      Store* storeHigh =
        builder->makeStore(4,
                           curr->offset + 4,
                           std::min(uint32_t(curr->align), uint32_t(4)),
                           builder->makeLocalGet(ptrTemp, Type::i32),
                           builder->makeLocalGet(highBits, Type::i32),
                           Type::i32,
                           curr->memory);
      replaceCurrent(builder->blockify(setPtr, curr, storeHigh));
    }
  }

  void visitAtomicRMW(AtomicRMW* curr) {
    if (handleUnreachable(curr)) {
      return;
    }
    if (curr->type != Type::i64) {
      return;
    }
    // We cannot break this up into smaller operations as it must be atomic.
    // Lower to an instrinsic function that wasm2js will implement.
    TempVar lowBits = getTemp();
    TempVar highBits = getTemp();
    auto* getLow = builder->makeCall(
      ABI::wasm2js::ATOMIC_RMW_I64,
      {builder->makeConst(int32_t(curr->op)),
       builder->makeConst(int32_t(curr->bytes)),
       builder->makeConst(int32_t(curr->offset)),
       curr->ptr,
       curr->value,
       builder->makeLocalGet(fetchOutParam(curr->value), Type::i32)},
      Type::i32);
    auto* getHigh =
      builder->makeCall(ABI::wasm2js::GET_STASHED_BITS, {}, Type::i32);
    auto* setLow = builder->makeLocalSet(lowBits, getLow);
    auto* setHigh = builder->makeLocalSet(highBits, getHigh);
    auto* finalGet = builder->makeLocalGet(lowBits, Type::i32);
    auto* result = builder->makeBlock({setLow, setHigh, finalGet});
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    assert(curr->type != Type::i64 && "64-bit AtomicCmpxchg not implemented");
  }

  void visitAtomicWait(AtomicWait* curr) {
    // The last parameter is an i64, so we cannot leave it as it is
    replaceCurrent(builder->makeCall(
      ABI::wasm2js::ATOMIC_WAIT_I32,
      {builder->makeConst(int32_t(curr->offset)),
       curr->ptr,
       curr->expected,
       curr->timeout,
       builder->makeLocalGet(fetchOutParam(curr->timeout), Type::i32)},
      Type::i32));
  }

  void visitConst(Const* curr) {
    if (!getFunction()) {
      return; // if in a global init, skip - we already handled that.
    }
    if (curr->type != Type::i64) {
      return;
    }
    TempVar highBits = getTemp();
    Const* lowVal =
      builder->makeConst(int32_t(curr->value.geti64() & 0xffffffff));
    LocalSet* setHigh = builder->makeLocalSet(
      highBits,
      builder->makeConst(int32_t(uint64_t(curr->value.geti64()) >> 32)));
    Block* result = builder->blockify(setHigh, lowVal);
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerEqZInt64(Unary* curr) {
    TempVar highBits = fetchOutParam(curr->value);

    auto* result = builder->makeUnary(
      EqZInt32,
      builder->makeBinary(
        OrInt32, curr->value, builder->makeLocalGet(highBits, Type::i32)));

    replaceCurrent(result);
  }

  void lowerExtendUInt32(Unary* curr) {
    TempVar highBits = getTemp();
    Block* result = builder->blockify(
      builder->makeLocalSet(highBits, builder->makeConst(int32_t(0))),
      curr->value);
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerExtendSInt32(Unary* curr) {
    TempVar highBits = getTemp();
    TempVar lowBits = getTemp();

    LocalSet* setLow = builder->makeLocalSet(lowBits, curr->value);
    LocalSet* setHigh = builder->makeLocalSet(
      highBits,
      builder->makeBinary(ShrSInt32,
                          builder->makeLocalGet(lowBits, Type::i32),
                          builder->makeConst(int32_t(31))));

    Block* result = builder->blockify(
      setLow, setHigh, builder->makeLocalGet(lowBits, Type::i32));

    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerExtendSInt64(Unary* curr) {
    TempVar highBits = getTemp();
    TempVar lowBits = getTemp();

    // free the temp var
    fetchOutParam(curr->value);

    Expression* lowValue = curr->value;
    switch (curr->op) {
      case ExtendS8Int64:
        lowValue = builder->makeUnary(ExtendS8Int32, lowValue);
        break;
      case ExtendS16Int64:
        lowValue = builder->makeUnary(ExtendS16Int32, lowValue);
        break;
      default:
        break;
    }

    LocalSet* setLow = builder->makeLocalSet(lowBits, lowValue);
    LocalSet* setHigh = builder->makeLocalSet(
      highBits,
      builder->makeBinary(ShrSInt32,
                          builder->makeLocalGet(lowBits, Type::i32),
                          builder->makeConst(int32_t(31))));

    Block* result = builder->blockify(
      setLow, setHigh, builder->makeLocalGet(lowBits, Type::i32));

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
    Block* result = builder->blockify(
      builder->makeCall(
        ABI::wasm2js::SCRATCH_STORE_F64, {curr->value}, Type::none),
      builder->makeLocalSet(highBits,
                            builder->makeCall(ABI::wasm2js::SCRATCH_LOAD_I32,
                                              {builder->makeConst(int32_t(1))},
                                              Type::i32)),
      builder->makeCall(ABI::wasm2js::SCRATCH_LOAD_I32,
                        {builder->makeConst(int32_t(0))},
                        Type::i32));
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
    MemoryUtils::ensureExists(getModule());
    ABI::wasm2js::ensureHelpers(getModule());
  }

  void lowerReinterpretInt64(Unary* curr) {
    // Assume that the wasm file assumes the address 0 is invalid and roundtrip
    // our i64 through memory at address 0
    TempVar highBits = fetchOutParam(curr->value);
    Block* result = builder->blockify(
      builder->makeCall(ABI::wasm2js::SCRATCH_STORE_I32,
                        {builder->makeConst(int32_t(0)), curr->value},
                        Type::none),
      builder->makeCall(ABI::wasm2js::SCRATCH_STORE_I32,
                        {builder->makeConst(int32_t(1)),
                         builder->makeLocalGet(highBits, Type::i32)},
                        Type::none),
      builder->makeCall(ABI::wasm2js::SCRATCH_LOAD_F64, {}, Type::f64));
    replaceCurrent(result);
    MemoryUtils::ensureExists(getModule());
    ABI::wasm2js::ensureHelpers(getModule());
  }

  void lowerTruncFloatToInt(Unary* curr) {
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
        litZero = Literal((float)0);
        litOne = Literal((float)1);
        u32Max = Literal(((float)UINT_MAX) + 1);
        trunc = TruncUFloat32ToInt32;
        convert = ConvertUInt32ToFloat32;
        localType = Type::f32;
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
        litZero = Literal((double)0);
        litOne = Literal((double)1);
        u32Max = Literal(((double)UINT_MAX) + 1);
        trunc = TruncUFloat64ToInt32;
        convert = ConvertUInt32ToFloat64;
        localType = Type::f64;
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
      default:
        abort();
    }

    TempVar f = getTemp(localType);
    TempVar highBits = getTemp();

    Expression* gtZeroBranch = builder->makeBinary(
      min,
      builder->makeUnary(
        floor,
        builder->makeBinary(div,
                            builder->makeLocalGet(f, localType),
                            builder->makeConst(u32Max))),
      builder->makeBinary(
        sub, builder->makeConst(u32Max), builder->makeConst(litOne)));
    Expression* ltZeroBranch = builder->makeUnary(
      ceil,
      builder->makeBinary(
        div,
        builder->makeBinary(
          sub,
          builder->makeLocalGet(f, localType),
          builder->makeUnary(
            convert,
            builder->makeUnary(trunc, builder->makeLocalGet(f, localType)))),
        builder->makeConst(u32Max)));

    If* highBitsCalc = builder->makeIf(
      builder->makeBinary(
        gt, builder->makeLocalGet(f, localType), builder->makeConst(litZero)),
      builder->makeUnary(trunc, gtZeroBranch),
      builder->makeUnary(trunc, ltZeroBranch));
    If* highBitsVal = builder->makeIf(
      builder->makeBinary(
        ge,
        builder->makeUnary(abs, builder->makeLocalGet(f, localType)),
        builder->makeConst(litOne)),
      highBitsCalc,
      builder->makeConst(int32_t(0)));
    Block* result = builder->blockify(
      builder->makeLocalSet(f, curr->value),
      builder->makeLocalSet(highBits, highBitsVal),
      builder->makeUnary(trunc, builder->makeLocalGet(f, localType)));
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void lowerConvertIntToFloat(Unary* curr) {
    // Here the same strategy as `emcc` is taken which takes the two halves of
    // the 64-bit integer and creates a mathematical expression using float
    // arithmetic to reassemble the final floating point value.
    //
    // For example for i64 -> f32 we generate:
    //
    //  ((double) (unsigned) lowBits) +
    //      ((double) U32_MAX) * ((double) (int) highBits)
    //
    // Mostly just shuffling things around here with coercions and whatnot!
    // Note though that all arithmetic is done with f64 to have as much
    // precision as we can.
    //
    // NB: this is *not* accurate for i64 -> f32. Using f64s for intermediate
    // operations can give slightly inaccurate results in some cases, as we
    // round to an f64, then round again to an f32, which is not always the
    // same as a single rounding of i64 to f32 directly. Example:
    //
    //   #include <stdio.h>
    //   int main() {
    //     unsigned long long x = 18446743523953737727ULL;
    //     float y = x;
    //     double z = x;
    //     float w = z;
    //     printf("i64          : %llu\n"
    //            "i64->f32     : %f\n"
    //            "i64->f64     : %f\n"
    //            "i64->f64->f32: %f\n", x, y, z, w);
    //   }
    //
    //   i64          : 18446743523953737727
    //   i64->f32     : 18446742974197923840.000000 ;; correct rounding to f32
    //   i64->f64     : 18446743523953737728.000000 ;; correct rounding to f64
    //   i64->f64->f32: 18446744073709551616.000000 ;; incorrect rounding to f32
    //
    // This is even a problem if we use BigInts in JavaScript to represent
    // i64s, as Math.fround(BigInt) is not supported - the BigInt must be
    // converted to a Number first, so we again have that extra rounding.
    //
    // A more precise approach could use compiled floatdisf/floatundisf from
    // compiler-rt, but that is much larger and slower. (Note that we are in the
    // interesting situation of having f32 and f64 operations and only missing
    // i64 ones, so we have a different problem to solve than compiler-rt, and
    // maybe there is a better solution we haven't found yet.)
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
      default:
        abort();
    }

    Expression* result = builder->blockify(
      builder->makeLocalSet(lowBits, curr->value),
      builder->makeLocalSet(highResult, builder->makeConst(int32_t(0))),
      builder->makeBinary(
        AddFloat64,
        builder->makeUnary(ConvertUInt32ToFloat64,
                           builder->makeLocalGet(lowBits, Type::i32)),
        builder->makeBinary(
          MulFloat64,
          builder->makeConst((double)UINT_MAX + 1),
          builder->makeUnary(convertHigh,
                             builder->makeLocalGet(highBits, Type::i32)))));

    switch (curr->op) {
      case ConvertSInt64ToFloat32:
      case ConvertUInt64ToFloat32: {
        result = builder->makeUnary(DemoteFloat64, result);
        break;
      }
      default:
        break;
    }

    replaceCurrent(result);
  }

  void lowerCountZeros(Unary* curr) {
    auto lower = [&](Block* result,
                     UnaryOp op32,
                     TempVar&& first,
                     TempVar&& second) {
      TempVar highResult = getTemp();
      TempVar firstResult = getTemp();
      LocalSet* setFirst = builder->makeLocalSet(
        firstResult,
        builder->makeUnary(op32, builder->makeLocalGet(first, Type::i32)));

      Binary* check =
        builder->makeBinary(EqInt32,
                            builder->makeLocalGet(firstResult, Type::i32),
                            builder->makeConst(int32_t(32)));

      If* conditional = builder->makeIf(
        check,
        builder->makeBinary(
          AddInt32,
          builder->makeUnary(op32, builder->makeLocalGet(second, Type::i32)),
          builder->makeConst(int32_t(32))),
        builder->makeLocalGet(firstResult, Type::i32));

      LocalSet* setHigh =
        builder->makeLocalSet(highResult, builder->makeConst(int32_t(0)));

      setOutParam(result, std::move(highResult));

      replaceCurrent(builder->blockify(result, setFirst, setHigh, conditional));
    };

    TempVar highBits = fetchOutParam(curr->value);
    TempVar lowBits = getTemp();
    LocalSet* setLow = builder->makeLocalSet(lowBits, curr->value);
    Block* result = builder->blockify(setLow);

    switch (curr->op) {
      case ClzInt64:
        lower(result, ClzInt32, std::move(highBits), std::move(lowBits));
        break;
      case CtzInt64:
        WASM_UNREACHABLE("i64.ctz should be removed already");
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
      case ReinterpretInt64:
      case ExtendS8Int64:
      case ExtendS16Int64:
      case ExtendS32Int64:
        return true;
      default:
        return false;
    }
  }

  void visitUnary(Unary* curr) {
    if (!unaryNeedsLowering(curr->op)) {
      return;
    }
    if (handleUnreachable(curr)) {
      return;
    }
    assert(hasOutParam(curr->value) || curr->type == Type::i64 ||
           curr->type == Type::f64);
    switch (curr->op) {
      case ClzInt64:
      case CtzInt64:
        lowerCountZeros(curr);
        break;
      case EqZInt64:
        lowerEqZInt64(curr);
        break;
      case ExtendSInt32:
        lowerExtendSInt32(curr);
        break;
      case ExtendUInt32:
        lowerExtendUInt32(curr);
        break;
      case WrapInt64:
        lowerWrapInt64(curr);
        break;
      case ReinterpretFloat64:
        lowerReinterpretFloat64(curr);
        break;
      case ReinterpretInt64:
        lowerReinterpretInt64(curr);
        break;
      case TruncSFloat32ToInt64:
      case TruncUFloat32ToInt64:
      case TruncSFloat64ToInt64:
      case TruncUFloat64ToInt64:
        lowerTruncFloatToInt(curr);
        break;
      case ConvertSInt64ToFloat32:
      case ConvertSInt64ToFloat64:
      case ConvertUInt64ToFloat32:
      case ConvertUInt64ToFloat64:
        lowerConvertIntToFloat(curr);
        break;
      case ExtendS8Int64:
      case ExtendS16Int64:
      case ExtendS32Int64:
        lowerExtendSInt64(curr);
        break;
      case PopcntInt64:
        WASM_UNREACHABLE("i64.popcnt should already be removed");
      default:
        std::cerr << "Unhandled unary operator: " << curr->op << std::endl;
        abort();
    }
  }

  Block* lowerAdd(Block* result,
                  TempVar&& leftLow,
                  TempVar&& leftHigh,
                  TempVar&& rightLow,
                  TempVar&& rightHigh) {
    TempVar lowResult = getTemp();
    TempVar highResult = getTemp();
    LocalSet* addLow = builder->makeLocalSet(
      lowResult,
      builder->makeBinary(AddInt32,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(rightLow, Type::i32)));
    LocalSet* addHigh = builder->makeLocalSet(
      highResult,
      builder->makeBinary(AddInt32,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(rightHigh, Type::i32)));
    LocalSet* carryBit = builder->makeLocalSet(
      highResult,
      builder->makeBinary(AddInt32,
                          builder->makeLocalGet(highResult, Type::i32),
                          builder->makeConst(int32_t(1))));
    If* checkOverflow = builder->makeIf(
      builder->makeBinary(LtUInt32,
                          builder->makeLocalGet(lowResult, Type::i32),
                          builder->makeLocalGet(rightLow, Type::i32)),
      carryBit);
    LocalGet* getLow = builder->makeLocalGet(lowResult, Type::i32);
    result = builder->blockify(result, addLow, addHigh, checkOverflow, getLow);
    setOutParam(result, std::move(highResult));
    return result;
  }

  Block* lowerSub(Block* result,
                  TempVar&& leftLow,
                  TempVar&& leftHigh,
                  TempVar&& rightLow,
                  TempVar&& rightHigh) {
    TempVar lowResult = getTemp();
    TempVar highResult = getTemp();
    TempVar borrow = getTemp();
    LocalSet* subLow = builder->makeLocalSet(
      lowResult,
      builder->makeBinary(SubInt32,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(rightLow, Type::i32)));
    LocalSet* borrowBit = builder->makeLocalSet(
      borrow,
      builder->makeBinary(LtUInt32,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(rightLow, Type::i32)));
    LocalSet* subHigh1 = builder->makeLocalSet(
      highResult,
      builder->makeBinary(AddInt32,
                          builder->makeLocalGet(borrow, Type::i32),
                          builder->makeLocalGet(rightHigh, Type::i32)));
    LocalSet* subHigh2 = builder->makeLocalSet(
      highResult,
      builder->makeBinary(SubInt32,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(highResult, Type::i32)));
    LocalGet* getLow = builder->makeLocalGet(lowResult, Type::i32);
    result =
      builder->blockify(result, subLow, borrowBit, subHigh1, subHigh2, getLow);
    setOutParam(result, std::move(highResult));
    return result;
  }

  Block* lowerBitwise(BinaryOp op,
                      Block* result,
                      TempVar&& leftLow,
                      TempVar&& leftHigh,
                      TempVar&& rightLow,
                      TempVar&& rightHigh) {
    BinaryOp op32;
    switch (op) {
      case AndInt64:
        op32 = AndInt32;
        break;
      case OrInt64:
        op32 = OrInt32;
        break;
      case XorInt64:
        op32 = XorInt32;
        break;
      default:
        abort();
    }
    result = builder->blockify(
      result,
      builder->makeLocalSet(
        rightHigh,
        builder->makeBinary(op32,
                            builder->makeLocalGet(leftHigh, Type::i32),
                            builder->makeLocalGet(rightHigh, Type::i32))),
      builder->makeBinary(op32,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(rightLow, Type::i32)));
    setOutParam(result, std::move(rightHigh));
    return result;
  }

  Block* makeLargeShl(Index highBits, Index leftLow, Index shift) {
    return builder->blockify(
      builder->makeLocalSet(
        highBits,
        builder->makeBinary(ShlInt32,
                            builder->makeLocalGet(leftLow, Type::i32),
                            builder->makeLocalGet(shift, Type::i32))),
      builder->makeConst(int32_t(0)));
  }

  // a >> b where `b` >= 32
  //
  // implement as:
  //
  // hi = leftHigh >> 31 // copy sign bit
  // lo = leftHigh >> (b - 32)
  Block* makeLargeShrS(Index highBits, Index leftHigh, Index shift) {
    return builder->blockify(
      builder->makeLocalSet(
        highBits,
        builder->makeBinary(ShrSInt32,
                            builder->makeLocalGet(leftHigh, Type::i32),
                            builder->makeConst(int32_t(31)))),
      builder->makeBinary(ShrSInt32,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(shift, Type::i32)));
  }

  Block* makeLargeShrU(Index highBits, Index leftHigh, Index shift) {
    return builder->blockify(
      builder->makeLocalSet(highBits, builder->makeConst(int32_t(0))),
      builder->makeBinary(ShrUInt32,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(shift, Type::i32)));
  }

  Block* makeSmallShl(Index highBits,
                      Index leftLow,
                      Index leftHigh,
                      Index shift,
                      Binary* shiftMask,
                      Binary* widthLessShift) {
    Binary* shiftedInBits = builder->makeBinary(
      AndInt32,
      shiftMask,
      builder->makeBinary(
        ShrUInt32, builder->makeLocalGet(leftLow, Type::i32), widthLessShift));
    Binary* shiftHigh =
      builder->makeBinary(ShlInt32,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(shift, Type::i32));
    return builder->blockify(
      builder->makeLocalSet(
        highBits, builder->makeBinary(OrInt32, shiftedInBits, shiftHigh)),
      builder->makeBinary(ShlInt32,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(shift, Type::i32)));
  }

  // a >> b where `b` < 32
  //
  // implement as:
  //
  // hi = leftHigh >> b
  // lo = (leftLow >>> b) | (leftHigh << (32 - b))
  Block* makeSmallShrS(Index highBits,
                       Index leftLow,
                       Index leftHigh,
                       Index shift,
                       Binary* shiftMask,
                       Binary* widthLessShift) {
    Binary* shiftedInBits = builder->makeBinary(
      ShlInt32,
      builder->makeBinary(
        AndInt32, shiftMask, builder->makeLocalGet(leftHigh, Type::i32)),
      widthLessShift);
    Binary* shiftLow =
      builder->makeBinary(ShrUInt32,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(shift, Type::i32));
    return builder->blockify(
      builder->makeLocalSet(
        highBits,
        builder->makeBinary(ShrSInt32,
                            builder->makeLocalGet(leftHigh, Type::i32),
                            builder->makeLocalGet(shift, Type::i32))),
      builder->makeBinary(OrInt32, shiftedInBits, shiftLow));
  }

  Block* makeSmallShrU(Index highBits,
                       Index leftLow,
                       Index leftHigh,
                       Index shift,
                       Binary* shiftMask,
                       Binary* widthLessShift) {
    Binary* shiftedInBits = builder->makeBinary(
      ShlInt32,
      builder->makeBinary(
        AndInt32, shiftMask, builder->makeLocalGet(leftHigh, Type::i32)),
      widthLessShift);
    Binary* shiftLow =
      builder->makeBinary(ShrUInt32,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(shift, Type::i32));
    return builder->blockify(
      builder->makeLocalSet(
        highBits,
        builder->makeBinary(ShrUInt32,
                            builder->makeLocalGet(leftHigh, Type::i32),
                            builder->makeLocalGet(shift, Type::i32))),
      builder->makeBinary(OrInt32, shiftedInBits, shiftLow));
  }

  Block* lowerShift(BinaryOp op,
                    Block* result,
                    TempVar&& leftLow,
                    TempVar&& leftHigh,
                    TempVar&& rightLow,
                    TempVar&& rightHigh) {
    assert(op == ShlInt64 || op == ShrUInt64 || op == ShrSInt64);
    // shift left lowered as:
    // if 32 <= rightLow % 64:
    //     high = leftLow << k; low = 0
    // else:
    //     high = (((1 << k) - 1) & (leftLow >> (32 - k))) | (leftHigh << k);
    //     low = leftLow << k
    // where k = shift % 32. shift right is similar.
    TempVar shift = getTemp();
    LocalSet* setShift = builder->makeLocalSet(
      shift,
      builder->makeBinary(AndInt32,
                          builder->makeLocalGet(rightLow, Type::i32),
                          builder->makeConst(int32_t(32 - 1))));
    Binary* isLargeShift = builder->makeBinary(
      LeUInt32,
      builder->makeConst(int32_t(32)),
      builder->makeBinary(AndInt32,
                          builder->makeLocalGet(rightLow, Type::i32),
                          builder->makeConst(int32_t(64 - 1))));
    Block* largeShiftBlock;
    switch (op) {
      case ShlInt64:
        largeShiftBlock = makeLargeShl(rightHigh, leftLow, shift);
        break;
      case ShrSInt64:
        largeShiftBlock = makeLargeShrS(rightHigh, leftHigh, shift);
        break;
      case ShrUInt64:
        largeShiftBlock = makeLargeShrU(rightHigh, leftHigh, shift);
        break;
      default:
        abort();
    }
    Binary* shiftMask = builder->makeBinary(
      SubInt32,
      builder->makeBinary(ShlInt32,
                          builder->makeConst(int32_t(1)),
                          builder->makeLocalGet(shift, Type::i32)),
      builder->makeConst(int32_t(1)));
    Binary* widthLessShift =
      builder->makeBinary(SubInt32,
                          builder->makeConst(int32_t(32)),
                          builder->makeLocalGet(shift, Type::i32));
    Block* smallShiftBlock;
    switch (op) {
      case ShlInt64: {
        smallShiftBlock = makeSmallShl(
          rightHigh, leftLow, leftHigh, shift, shiftMask, widthLessShift);
        break;
      }
      case ShrSInt64: {
        smallShiftBlock = makeSmallShrS(
          rightHigh, leftLow, leftHigh, shift, shiftMask, widthLessShift);
        break;
      }
      case ShrUInt64: {
        smallShiftBlock = makeSmallShrU(
          rightHigh, leftLow, leftHigh, shift, shiftMask, widthLessShift);
        break;
      }
      default:
        abort();
    }
    If* ifLargeShift =
      builder->makeIf(isLargeShift, largeShiftBlock, smallShiftBlock);
    result = builder->blockify(result, setShift, ifLargeShift);
    setOutParam(result, std::move(rightHigh));
    return result;
  }

  Block* lowerEq(Block* result,
                 TempVar&& leftLow,
                 TempVar&& leftHigh,
                 TempVar&& rightLow,
                 TempVar&& rightHigh) {
    return builder->blockify(
      result,
      builder->makeBinary(
        AndInt32,
        builder->makeBinary(EqInt32,
                            builder->makeLocalGet(leftLow, Type::i32),
                            builder->makeLocalGet(rightLow, Type::i32)),
        builder->makeBinary(EqInt32,
                            builder->makeLocalGet(leftHigh, Type::i32),
                            builder->makeLocalGet(rightHigh, Type::i32))));
  }

  Block* lowerNe(Block* result,
                 TempVar&& leftLow,
                 TempVar&& leftHigh,
                 TempVar&& rightLow,
                 TempVar&& rightHigh) {
    return builder->blockify(
      result,
      builder->makeBinary(
        OrInt32,
        builder->makeBinary(NeInt32,
                            builder->makeLocalGet(leftLow, Type::i32),
                            builder->makeLocalGet(rightLow, Type::i32)),
        builder->makeBinary(NeInt32,
                            builder->makeLocalGet(leftHigh, Type::i32),
                            builder->makeLocalGet(rightHigh, Type::i32))));
  }

  Block* lowerUComp(BinaryOp op,
                    Block* result,
                    TempVar&& leftLow,
                    TempVar&& leftHigh,
                    TempVar&& rightLow,
                    TempVar&& rightHigh) {
    BinaryOp highOp, lowOp;
    switch (op) {
      case LtUInt64:
        highOp = LtUInt32;
        lowOp = LtUInt32;
        break;
      case LeUInt64:
        highOp = LtUInt32;
        lowOp = LeUInt32;
        break;
      case GtUInt64:
        highOp = GtUInt32;
        lowOp = GtUInt32;
        break;
      case GeUInt64:
        highOp = GtUInt32;
        lowOp = GeUInt32;
        break;
      default:
        abort();
    }
    Binary* compHigh =
      builder->makeBinary(highOp,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(rightHigh, Type::i32));
    Binary* eqHigh =
      builder->makeBinary(EqInt32,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(rightHigh, Type::i32));
    Binary* compLow =
      builder->makeBinary(lowOp,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(rightLow, Type::i32));
    return builder->blockify(
      result,
      builder->makeBinary(
        OrInt32, compHigh, builder->makeBinary(AndInt32, eqHigh, compLow)));
  }

  Block* lowerSComp(BinaryOp op,
                    Block* result,
                    TempVar&& leftLow,
                    TempVar&& leftHigh,
                    TempVar&& rightLow,
                    TempVar&& rightHigh) {
    BinaryOp highOp1, highOp2, lowOp;
    switch (op) {
      case LtSInt64:
        highOp1 = LtSInt32;
        highOp2 = LeSInt32;
        lowOp = GeUInt32;
        break;
      case LeSInt64:
        highOp1 = LtSInt32;
        highOp2 = LeSInt32;
        lowOp = GtUInt32;
        break;
      case GtSInt64:
        highOp1 = GtSInt32;
        highOp2 = GeSInt32;
        lowOp = LeUInt32;
        break;
      case GeSInt64:
        highOp1 = GtSInt32;
        highOp2 = GeSInt32;
        lowOp = LtUInt32;
        break;
      default:
        abort();
    }
    Binary* compHigh1 =
      builder->makeBinary(highOp1,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(rightHigh, Type::i32));
    Binary* compHigh2 =
      builder->makeBinary(highOp2,
                          builder->makeLocalGet(leftHigh, Type::i32),
                          builder->makeLocalGet(rightHigh, Type::i32));
    Binary* compLow =
      builder->makeBinary(lowOp,
                          builder->makeLocalGet(leftLow, Type::i32),
                          builder->makeLocalGet(rightLow, Type::i32));
    If* lowIf = builder->makeIf(
      compLow, builder->makeConst(int32_t(0)), builder->makeConst(int32_t(1)));
    If* highIf2 =
      builder->makeIf(compHigh2, lowIf, builder->makeConst(int32_t(0)));
    If* highIf1 =
      builder->makeIf(compHigh1, builder->makeConst(int32_t(1)), highIf2);
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
      case GeUInt64:
        return true;
      default:
        return false;
    }
  }

  void visitBinary(Binary* curr) {
    if (handleUnreachable(curr)) {
      return;
    }
    if (!binaryNeedsLowering(curr->op)) {
      return;
    }
    // left and right reachable, lower normally
    TempVar leftLow = getTemp();
    TempVar leftHigh = fetchOutParam(curr->left);
    TempVar rightLow = getTemp();
    TempVar rightHigh = fetchOutParam(curr->right);
    LocalSet* setRight = builder->makeLocalSet(rightLow, curr->right);
    LocalSet* setLeft = builder->makeLocalSet(leftLow, curr->left);
    Block* result = builder->blockify(setLeft, setRight);
    switch (curr->op) {
      case AddInt64: {
        replaceCurrent(lowerAdd(result,
                                std::move(leftLow),
                                std::move(leftHigh),
                                std::move(rightLow),
                                std::move(rightHigh)));
        break;
      }
      case SubInt64: {
        replaceCurrent(lowerSub(result,
                                std::move(leftLow),
                                std::move(leftHigh),
                                std::move(rightLow),
                                std::move(rightHigh)));
        break;
      }
      case MulInt64:
      case DivSInt64:
      case DivUInt64:
      case RemSInt64:
      case RemUInt64:
      case RotLInt64:
      case RotRInt64:
        WASM_UNREACHABLE("should have been removed by now");

      case AndInt64:
      case OrInt64:
      case XorInt64: {
        replaceCurrent(lowerBitwise(curr->op,
                                    result,
                                    std::move(leftLow),
                                    std::move(leftHigh),
                                    std::move(rightLow),
                                    std::move(rightHigh)));
        break;
      }
      case ShlInt64:
      case ShrSInt64:
      case ShrUInt64: {
        replaceCurrent(lowerShift(curr->op,
                                  result,
                                  std::move(leftLow),
                                  std::move(leftHigh),
                                  std::move(rightLow),
                                  std::move(rightHigh)));
        break;
      }
      case EqInt64: {
        replaceCurrent(lowerEq(result,
                               std::move(leftLow),
                               std::move(leftHigh),
                               std::move(rightLow),
                               std::move(rightHigh)));
        break;
      }
      case NeInt64: {
        replaceCurrent(lowerNe(result,
                               std::move(leftLow),
                               std::move(leftHigh),
                               std::move(rightLow),
                               std::move(rightHigh)));
        break;
      }
      case LtSInt64:
      case LeSInt64:
      case GtSInt64:
      case GeSInt64:
        replaceCurrent(lowerSComp(curr->op,
                                  result,
                                  std::move(leftLow),
                                  std::move(leftHigh),
                                  std::move(rightLow),
                                  std::move(rightHigh)));
        break;
      case LtUInt64:
      case LeUInt64:
      case GtUInt64:
      case GeUInt64: {
        replaceCurrent(lowerUComp(curr->op,
                                  result,
                                  std::move(leftLow),
                                  std::move(leftHigh),
                                  std::move(rightLow),
                                  std::move(rightHigh)));
        break;
      }
      default: {
        std::cerr << "Unhandled binary op " << curr->op << std::endl;
        abort();
      }
    }
  }

  void visitSelect(Select* curr) {
    if (handleUnreachable(curr)) {
      return;
    }
    if (!hasOutParam(curr->ifTrue)) {
      assert(!hasOutParam(curr->ifFalse));
      return;
    }
    assert(hasOutParam(curr->ifFalse));
    TempVar highBits = getTemp();
    TempVar lowBits = getTemp();
    TempVar cond = getTemp();
    Block* result = builder->blockify(
      builder->makeLocalSet(cond, curr->condition),
      builder->makeLocalSet(
        lowBits,
        builder->makeSelect(
          builder->makeLocalGet(cond, Type::i32), curr->ifTrue, curr->ifFalse)),
      builder->makeLocalSet(
        highBits,
        builder->makeSelect(
          builder->makeLocalGet(cond, Type::i32),
          builder->makeLocalGet(fetchOutParam(curr->ifTrue), Type::i32),
          builder->makeLocalGet(fetchOutParam(curr->ifFalse), Type::i32))),
      builder->makeLocalGet(lowBits, Type::i32));
    setOutParam(result, std::move(highBits));
    replaceCurrent(result);
  }

  void visitDrop(Drop* curr) {
    if (!hasOutParam(curr->value)) {
      return;
    }
    // free temp var
    fetchOutParam(curr->value);
  }

  void visitReturn(Return* curr) {
    if (!hasOutParam(curr->value)) {
      return;
    }
    TempVar lowBits = getTemp();
    TempVar highBits = fetchOutParam(curr->value);
    LocalSet* setLow = builder->makeLocalSet(lowBits, curr->value);
    GlobalSet* setHigh = builder->makeGlobalSet(
      INT64_TO_32_HIGH_BITS, builder->makeLocalGet(highBits, Type::i32));
    curr->value = builder->makeLocalGet(lowBits, Type::i32);
    Block* result = builder->blockify(setLow, setHigh, curr);
    replaceCurrent(result);
  }

private:
  std::unique_ptr<Builder> builder;
  std::unordered_map<Index, Index> indexMap;
  std::unordered_map<int, std::vector<Index>> freeTemps;
  std::unordered_map<Expression*, TempVar> highBitVars;
  std::unordered_map<Index, Type> tempTypes;
  std::unordered_set<Name> originallyI64Globals;
  Index nextTemp;

  TempVar getTemp(Type ty = Type::i32) {
    Index ret;
    auto& freeList = freeTemps[ty.getBasic()];
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

  // If e.g. a select is unreachable, then one arm may have an out param
  // but not the other. In this case dce should really have been run
  // before; handle it in a simple way here by replacing the node with
  // a block of its children.
  // This is valid only for nodes that execute their children
  // unconditionally before themselves, so it is not valid for an if,
  // in particular.
  bool handleUnreachable(Expression* curr) {
    if (curr->type != Type::unreachable) {
      return false;
    }
    std::vector<Expression*> children;
    bool hasUnreachable = false;
    for (auto* child : ChildIterator(curr)) {
      if (child->type.isConcrete()) {
        child = builder->makeDrop(child);
      } else if (child->type == Type::unreachable) {
        hasUnreachable = true;
      }
      children.push_back(child);
    }
    if (!hasUnreachable) {
      return false;
    }
    // This has an unreachable child, so we can replace it with
    // the children.
    auto* block = builder->makeBlock(children);
    assert(block->type == Type::unreachable);
    replaceCurrent(block);
    return true;
  }
};

Pass* createI64ToI32LoweringPass() { return new I64ToI32Lowering(); }

} // namespace wasm
