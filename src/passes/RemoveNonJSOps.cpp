/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Removes the `f32.copysign` and `f64.copysign` instructions and replaces them
// with equivalent bit operations. Primarily intended to be used with `wasm2asm`
// where `Math.copysign` doesn't exist.
//

#include <wasm.h>
#include <pass.h>

#include "asmjs/shared-constants.h"
#include "wasm-builder.h"

namespace wasm {

struct RemoveNonJSOpsPass : public WalkerPass<PostWalker<RemoveNonJSOpsPass>> {
  bool needNearestF32 = false;
  bool needNearestF64 = false;
  bool needTruncF32 = false;
  bool needTruncF64 = false;
  bool needCtzInt32 = false;
  bool needPopcntInt32 = false;
  bool needRotLInt32 = false;
  bool needRotRInt32 = false;

  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new RemoveNonJSOpsPass; }

  void doWalkModule(Module* module) {
    if (!builder) builder = make_unique<Builder>(*module);
    PostWalker<RemoveNonJSOpsPass>::doWalkModule(module);

    if (needNearestF32) {
      module->addFunction(createNearest(f32));
    }
    if (needNearestF64) {
      module->addFunction(createNearest(f64));
    }
    if (needTruncF32) {
      module->addFunction(createTrunc(f32));
    }
    if (needTruncF64) {
      module->addFunction(createTrunc(f64));
    }
    if (needCtzInt32) {
      module->addFunction(createCtz());
    }
    if (needPopcntInt32) {
      module->addFunction(createPopcnt());
    }
    if (needRotLInt32) {
      module->addFunction(createRot(RotLInt32));
    }
    if (needRotRInt32) {
      module->addFunction(createRot(RotRInt32));
    }
  }

  Function *createNearest(Type f) {
    // fn nearest(f: float) -> float {
    //    let ceil = ceil(f);
    //    let floor = floor(f);
    //    let fract = f - floor;
    //    if fract < 0.5 {
    //        floor
    //    } else if fract > 0.5 {
    //        ceil
    //    } else {
    //        let rem = floor / 2.0;
    //        if rem - floor(rem) == 0.0 {
    //            floor
    //        } else {
    //            ceil
    //        }
    //    }
    // }

    Index arg = 0;
    Index ceil = 1;
    Index floor = 2;
    Index fract = 3;
    Index rem = 4;

    UnaryOp ceilOp = CeilFloat32;
    UnaryOp floorOp = FloorFloat32;
    BinaryOp subOp = SubFloat32;
    BinaryOp ltOp = LtFloat32;
    BinaryOp gtOp = GtFloat32;
    BinaryOp divOp = DivFloat32;
    BinaryOp eqOp = EqFloat32;
    Literal litHalf((float) 0.5);
    Literal litOne((float) 1.0);
    Literal litZero((float) 0.0);
    Literal litTwo((float) 2.0);
    if (f == f64) {
      ceilOp = CeilFloat64;
      floorOp = FloorFloat64;
      subOp = SubFloat64;
      ltOp = LtFloat64;
      gtOp = GtFloat64;
      divOp = DivFloat64;
      eqOp = EqFloat64;
      litHalf = Literal((double) 0.5);
      litOne = Literal((double) 1.0);
      litZero = Literal((double) 0.0);
      litTwo = Literal((double) 2.0);
    }

    Expression *body = builder->blockify(
      builder->makeSetLocal(
        ceil,
        builder->makeUnary(ceilOp, builder->makeGetLocal(arg, f))
      ),
      builder->makeSetLocal(
        floor,
        builder->makeUnary(floorOp, builder->makeGetLocal(arg, f))
      ),
      builder->makeSetLocal(
        fract,
        builder->makeBinary(
          subOp,
          builder->makeGetLocal(arg, f),
          builder->makeGetLocal(floor, f)
        )
      ),
      builder->makeIf(
        builder->makeBinary(
          ltOp,
          builder->makeGetLocal(fract, f),
          builder->makeConst(litHalf)
        ),
        builder->makeGetLocal(floor, f),
        builder->makeIf(
          builder->makeBinary(
            gtOp,
            builder->makeGetLocal(fract, f),
            builder->makeConst(litHalf)
          ),
          builder->makeGetLocal(ceil, f),
          builder->blockify(
            builder->makeSetLocal(
              rem,
              builder->makeBinary(
                divOp,
                builder->makeGetLocal(floor, f),
                builder->makeConst(litTwo)
              )
            ),
            builder->makeIf(
              builder->makeBinary(
                eqOp,
                builder->makeBinary(
                  subOp,
                  builder->makeGetLocal(rem, f),
                  builder->makeUnary(
                    floorOp,
                    builder->makeGetLocal(rem, f)
                  )
                ),
                builder->makeConst(litZero)
              ),
              builder->makeGetLocal(floor, f),
              builder->makeGetLocal(ceil, f)
            )
          )
        )
      )
    );
    std::vector<Type> params = {f};
    std::vector<Type> vars = {f, f, f, f, f};
    Name name = f == f32 ? WASM_NEAREST_F32 : WASM_NEAREST_F64;
    return builder->makeFunction(name, std::move(params), f, std::move(vars), body);
  }

  Function *createTrunc(Type f) {
    // fn trunc(f: float) -> float {
    //    if f < 0.0 {
    //        ceil(f)
    //    } else {
    //        floor(f)
    //    }
    // }

    Index arg = 0;

    UnaryOp ceilOp = CeilFloat32;
    UnaryOp floorOp = FloorFloat32;
    BinaryOp ltOp = LtFloat32;
    Literal litZero((float) 0.0);
    if (f == f64) {
      ceilOp = CeilFloat64;
      floorOp = FloorFloat64;
      ltOp = LtFloat64;
      litZero = Literal((double) 0.0);
    }

    Expression *body = builder->makeIf(
      builder->makeBinary(
        ltOp,
        builder->makeGetLocal(arg, f),
        builder->makeConst(litZero)
      ),
      builder->makeUnary(ceilOp, builder->makeGetLocal(arg, f)),
      builder->makeUnary(floorOp, builder->makeGetLocal(arg, f))
    );
    std::vector<Type> params = {f};
    std::vector<Type> vars = {};
    Name name = f == f32 ? WASM_TRUNC_F32 : WASM_TRUNC_F64;
    return builder->makeFunction(name, std::move(params), f, std::move(vars), body);
  }

  Function* createCtz() {
    // if eqz(x) then 32 else (32 - clz(x ^ (x - 1)))
    Binary* xorExp = builder->makeBinary(
      XorInt32,
      builder->makeGetLocal(0, i32),
      builder->makeBinary(
        SubInt32,
        builder->makeGetLocal(0, i32),
        builder->makeConst(Literal(int32_t(1)))
      )
    );
    Binary* subExp = builder->makeBinary(
      SubInt32,
      builder->makeConst(Literal(int32_t(32 - 1))),
      builder->makeUnary(ClzInt32, xorExp)
    );
    If* body = builder->makeIf(
      builder->makeUnary(
        EqZInt32,
        builder->makeGetLocal(0, i32)
      ),
      builder->makeConst(Literal(int32_t(32))),
      subExp
    );
    return builder->makeFunction(
      WASM_CTZ32,
      std::vector<NameType>{NameType("x", i32)},
      i32,
      std::vector<NameType>{},
      body
    );
  }

  Function* createPopcnt() {
    // popcnt implemented as:
    // int c; for (c = 0; x != 0; c++) { x = x & (x - 1) }; return c
    Name loopName("l");
    Name blockName("b");
    Break* brIf = builder->makeBreak(
      blockName,
      builder->makeGetLocal(1, i32),
      builder->makeUnary(
        EqZInt32,
        builder->makeGetLocal(0, i32)
      )
    );
    SetLocal* update = builder->makeSetLocal(
      0,
      builder->makeBinary(
        AndInt32,
        builder->makeGetLocal(0, i32),
        builder->makeBinary(
          SubInt32,
          builder->makeGetLocal(0, i32),
          builder->makeConst(Literal(int32_t(1)))
        )
      )
    );
    SetLocal* inc = builder->makeSetLocal(
      1,
      builder->makeBinary(
        AddInt32,
        builder->makeGetLocal(1, i32),
        builder->makeConst(Literal(1))
      )
    );
    Break* cont = builder->makeBreak(loopName);
    Loop* loop = builder->makeLoop(
      loopName,
      builder->blockify(builder->makeDrop(brIf), update, inc, cont)
    );
    Block* loopBlock = builder->blockifyWithName(loop, blockName);
    // TODO: not sure why this is necessary...
    loopBlock->type = i32;
    SetLocal* initCount = builder->makeSetLocal(1, builder->makeConst(Literal(0)));
    return builder->makeFunction(
      WASM_POPCNT32,
      std::vector<NameType>{NameType("x", i32)},
      i32,
      std::vector<NameType>{NameType("count", i32)},
      builder->blockify(initCount, loopBlock)
    );
  }

  Function* createRot(BinaryOp op) {
    // left rotate is:
    // (((((~0) >>> k) & x) << k) | ((((~0) << (w - k)) & x) >>> (w - k)))
    // where k is shift modulo w. reverse shifts for right rotate
    bool isLRot  = op == RotLInt32;
    BinaryOp lshift = isLRot ? ShlInt32 : ShrUInt32;
    BinaryOp rshift = isLRot ? ShrUInt32 : ShlInt32;
    Literal widthMask(int32_t(32 - 1));
    Literal width(int32_t(32));
    auto shiftVal = [&]() {
      return builder->makeBinary(
        AndInt32,
        builder->makeGetLocal(1, i32),
        builder->makeConst(widthMask)
      );
    };
    auto widthSub = [&]() {
      return builder->makeBinary(SubInt32, builder->makeConst(width), shiftVal());
    };
    auto fullMask = [&]() {
      return builder->makeConst(Literal(~int32_t(0)));
    };
    Binary* maskRShift = builder->makeBinary(rshift, fullMask(), shiftVal());
    Binary* lowMask = builder->makeBinary(AndInt32, maskRShift, builder->makeGetLocal(0, i32));
    Binary* lowShift = builder->makeBinary(lshift, lowMask, shiftVal());
    Binary* maskLShift = builder->makeBinary(lshift, fullMask(), widthSub());
    Binary* highMask =
        builder->makeBinary(AndInt32, maskLShift, builder->makeGetLocal(0, i32));
    Binary* highShift = builder->makeBinary(rshift, highMask, widthSub());
    Binary* body = builder->makeBinary(OrInt32, lowShift, highShift);
    return builder->makeFunction(
      isLRot ? WASM_ROTL32 : WASM_ROTR32,
      std::vector<NameType>{NameType("x", i32),
            NameType("k", i32)},
      i32,
      std::vector<NameType>{},
      body
    );
  }

  void doWalkFunction(Function* func) {
    if (!builder) builder = make_unique<Builder>(*getModule());
    PostWalker<RemoveNonJSOpsPass>::doWalkFunction(func);
  }

  void visitBinary(Binary *curr) {
    Name name;
    switch (curr->op) {
      case CopySignFloat32:
      case CopySignFloat64:
        rewriteCopysign(curr);
        return;

      case RotLInt32:
        needRotLInt32 = true;
        name = WASM_ROTL32;
        break;
      case RotRInt32:
        needRotRInt32 = true;
        name = WASM_ROTR32;
        break;

      default: return;
    }
    replaceCurrent(builder->makeCall(name, {curr->left, curr->right}, curr->type));
  }

  void rewriteCopysign(Binary *curr) {
    Literal signBit, otherBits;
    UnaryOp int2float, float2int;
    BinaryOp bitAnd, bitOr;
    switch (curr->op) {
      case CopySignFloat32:
        float2int = ReinterpretFloat32;
        int2float = ReinterpretInt32;
        bitAnd = AndInt32;
        bitOr = OrInt32;
        signBit = Literal(uint32_t(1 << 31));
        otherBits = Literal(uint32_t(1 << 31) - 1);
        break;

      case CopySignFloat64:
        float2int = ReinterpretFloat64;
        int2float = ReinterpretInt64;
        bitAnd = AndInt64;
        bitOr = OrInt64;
        signBit = Literal(uint64_t(1) << 63);
        otherBits = Literal((uint64_t(1) << 63) - 1);
        break;

      default: return;
    }

    replaceCurrent(
      builder->makeUnary(
        int2float,
        builder->makeBinary(
          bitOr,
          builder->makeBinary(
            bitAnd,
            builder->makeUnary(
              float2int,
              curr->left
            ),
            builder->makeConst(otherBits)
          ),
          builder->makeBinary(
            bitAnd,
            builder->makeUnary(
              float2int,
              curr->right
            ),
            builder->makeConst(signBit)
          )
        )
      )
    );
  }

  void visitUnary(Unary *curr) {
    Name functionCall;
    switch (curr->op) {
      case NearestFloat32:
        needNearestF32 = true;
        functionCall = WASM_NEAREST_F32;
        break;
      case NearestFloat64:
        needNearestF64 = true;
        functionCall = WASM_NEAREST_F64;
        break;

      case TruncFloat32:
        needTruncF32 = true;
        functionCall = WASM_TRUNC_F32;
        break;
      case TruncFloat64:
        needTruncF64 = true;
        functionCall = WASM_TRUNC_F64;
        break;

      case PopcntInt32:
        needPopcntInt32 = true;
        functionCall = WASM_POPCNT32;
        break;

      case CtzInt32:
        needCtzInt32 = true;
        functionCall = WASM_CTZ32;
        break;

      default: return;
    }
    replaceCurrent(builder->makeCall(functionCall, {curr->value}, curr->type));
  }

private:
  std::unique_ptr<Builder> builder;
};

Pass *createRemoveNonJSOpsPass() {
  return new RemoveNonJSOpsPass();
}

} // namespace wasm

