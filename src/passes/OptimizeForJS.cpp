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

struct OptimizeForJSPass : public WalkerPass<PostWalker<OptimizeForJSPass>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new OptimizeForJSPass; }

  void visitBinary(Binary* curr) {
    using namespace Abstract;
    using namespace Match;
    {
      // Rewrite popcnt(x) == 1   ==>   !!x & !(x & (x - 1))
      Expression* x;
      if (matches(curr, binary(Eq, unary(Popcnt, any(&x)), ival(1)))) {
        rewritePopcntEqualOne(x);
      }
    }
  }

  void rewritePopcntEqualOne(Expression* expr) {
    // popcnt(x) == 1   ==>   !!x & !(x & (x - 1))
    BinaryOp andOp, subOp;
    UnaryOp eqzOp;
    Literal litOne;
    Type type = expr->type;

    switch (type.getBasic()) {
      case Type::i32:
        eqzOp = EqZInt32;
        andOp = AndInt32;
        subOp = SubInt32;
        litOne = Literal::makeOne(Type::i32);
        break;

      case Type::i64:
        eqzOp = EqZInt64;
        andOp = AndInt64;
        subOp = SubInt64;
        litOne = Literal::makeOne(Type::i64);
        break;

      default:
        return;
    }

    Localizer temp(expr, getFunction(), getModule());
    Builder builder(*getModule());

    replaceCurrent(builder.makeBinary(
      AndInt32,
      builder.makeUnary(
        EqZInt32,
        builder.makeUnary(eqzOp, builder.makeLocalGet(temp.index, type))),
      builder.makeUnary(
        eqzOp,
        builder.makeBinary(
          andOp,
          builder.makeLocalGet(temp.index, type),
          builder.makeBinary(subOp,
                             builder.makeLocalGet(temp.index, type),
                             builder.makeConst(litOne))))));
  }
};

Pass* createOptimizeForJSPass() { return new OptimizeForJSPass(); }

} // namespace wasm
