/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include <pass.h>
#include <wasm.h>

#include "wasm-builder.h"
#include <ir/abstract.h>
#include <ir/literal-utils.h>
#include <ir/localize.h>
#include <ir/match.h>

namespace wasm {

struct PreJSRewriterPass : public WalkerPass<PostWalker<PreJSRewriterPass>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new PreJSRewriterPass; }

  void visitBinary(Binary* curr) {
    using namespace Abstract;
    using namespace Match;
    {
      // Rewrite popcnt(x) == 1   ==>   !(!x | (x & (x - 1))
      Expression* x;
      if (matches(curr, binary(Eq, unary(Popcnt, any(&x)), ival(1)))) {
        rewritePopcntEqualOne(curr);
      }
    }

    if (curr->op == CopySignFloat32 || curr->op == CopySignFloat64) {
      rewriteCopysign(curr);
    }
  }

  void rewriteCopysign(Binary* curr) {
    // copysign(x, y)  =>
    //    (reinterpret(x) & ~SignMask) | (reinterpret(y) & SignMask)
    //
    // where SignMask <- 1 << 31, when i32
    //       SignMask <- 1 << 63, when i64

    Literal signBit, otherBits;
    UnaryOp int2float, float2int;
    BinaryOp bitAnd, bitOr;

    switch (curr->op) {
      case CopySignFloat32:
        float2int = ReinterpretFloat32;
        int2float = ReinterpretInt32;
        bitAnd = AndInt32;
        bitOr = OrInt32;
        signBit = Literal(1U << 31);
        otherBits = Literal(~(1U << 31));
        break;

      case CopySignFloat64:
        float2int = ReinterpretFloat64;
        int2float = ReinterpretInt64;
        bitAnd = AndInt64;
        bitOr = OrInt64;
        signBit = Literal(1ULL << 63);
        otherBits = Literal(~(1ULL << 63));
        break;

      default:
        return;
    }

    Builder builder(*getModule());

    replaceCurrent(builder.makeUnary(
      int2float,
      builder.makeBinary(
        bitOr,
        builder.makeBinary(bitAnd,
                           builder.makeUnary(float2int, curr->left),
                           builder.makeConst(otherBits)),
        builder.makeBinary(bitAnd,
                           builder.makeUnary(float2int, curr->right),
                           builder.makeConst(signBit)))));
  }

  void rewritePopcntEqualOne(Binary* curr) {
    // popcnt(x) == 1   ==>   !(!x | (x & (x - 1))
    Unary* lhs = curr->left->cast<Unary>();
    BinaryOp orOp, andOp, subOp;
    UnaryOp eqzOp;
    Literal litOne;

    switch (lhs->op) {
      case PopcntInt32:
        eqzOp = EqZInt32;
        orOp = OrInt32;
        andOp = AndInt32;
        subOp = SubInt32;
        litOne = Literal::makeOne(Type::i32);
        break;

      case PopcntInt64:
        eqzOp = EqZInt64;
        orOp = OrInt64;
        andOp = AndInt64;
        subOp = SubInt64;
        litOne = Literal::makeOne(Type::i64);
        break;

      default:
        return;
    }

    Type type = lhs->value->type;
    Localizer temp(lhs->value, getFunction(), getModule());
    Builder builder(*getModule());

    replaceCurrent(builder.makeUnary(
      eqzOp,
      builder.makeBinary(
        orOp,
        builder.makeUnary(eqzOp, builder.makeLocalGet(temp.index, type)),
        builder.makeBinary(
          andOp,
          builder.makeLocalGet(temp.index, type),
          builder.makeBinary(subOp,
                             builder.makeLocalGet(temp.index, type),
                             builder.makeConst(litOne))))));
  }
};

Pass* createPreJSRewriterPass() { return new PreJSRewriterPass(); }

} // namespace wasm
