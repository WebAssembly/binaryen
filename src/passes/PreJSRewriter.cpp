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

#include "ir/literal-utils.h"
#include "wasm-builder.h"

namespace wasm {

struct PreJSRewriterPass : public WalkerPass<PostWalker<PreJSRewriterPass>> {
  std::unique_ptr<Builder> builder;

  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new PreJSRewriterPass; }

  // Set to true when one of the visitors makes a change (either replacing the
  // node or modifying it).
  bool changed;

  // Used to avoid recursion in replaceCurrent, see below.
  bool inReplaceCurrent = false;

  void replaceCurrent(Expression* rep) {
    super::replaceCurrent(rep);
    // We may be able to apply multiple patterns as one may open opportunities
    // for others. NB: patterns must not have cycles

    // To avoid recursion, this uses the following pattern: the initial call to
    // this method comes from one of the visit*() methods. We then loop in here,
    // and if we are called again we set |changed| instead of recursing, so that
    // we can loop on that value.
    if (inReplaceCurrent) {
      // We are in the loop below so just note a change and return to there.
      changed = true;
      return;
    }
    // Loop on further changes.
    inReplaceCurrent = true;
    do {
      changed = false;
      visit(getCurrent());
    } while (changed);
    inReplaceCurrent = false;
  }

  void doWalkFunction(Function* func) {
    if (!builder) {
      builder = make_unique<Builder>(*getModule());
    }
    super::doWalkFunction(func);
  }

  void visitBinary(Binary* curr) {
    switch (curr->op) {
      case EqInt32:
      case EqInt64:
        // Rewrite popcnt(x) == 1   ==>   !(!x | (x & (x - 1))
        if (auto* lhs = curr->left->dynCast<Unary>()) {
          if (auto* rhs = curr->right->dynCast<Const>()) {
            if ((lhs->op == PopcntInt32 || lhs->op == PopcntInt64) &&
                rhs->value.getInteger() == 1LL) {
              rewritePopcntEqualOne(curr);
            }
          }
        }
        break;

      case CopySignFloat32:
      case CopySignFloat64:
        rewriteCopysign(curr);
        break;

      default:
        break;
    }
  }

  void rewriteCopysign(Binary* curr) {
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

      default:
        return;
    }

    replaceCurrent(builder->makeUnary(
      int2float,
      builder->makeBinary(
        bitOr,
        builder->makeBinary(bitAnd,
                            builder->makeUnary(float2int, curr->left),
                            builder->makeConst(otherBits)),
        builder->makeBinary(bitAnd,
                            builder->makeUnary(float2int, curr->right),
                            builder->makeConst(signBit)))));
  }

  void rewritePopcntEqualOne(Binary* curr) {
    // popcnt(x) == 1   ==>   !(!x | (x & (x - 1))
    Unary* lhs = curr->left->cast<Unary>();
    Expression* x = lhs->value;
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

    replaceCurrent(builder->makeUnary(
      eqzOp,
      builder->makeBinary(
        orOp,
        builder->makeUnary(eqzOp, x),
        builder->makeBinary(
          andOp,
          x,
          builder->makeBinary(subOp, x, builder->makeConst(litOne))))));
  }
};

Pass* createPreJSRewriterPass() { return new PreJSRewriterPass(); }

} // namespace wasm
