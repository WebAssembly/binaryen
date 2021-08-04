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

#include "abi/js.h"
#include "asmjs/shared-constants.h"
#include "passes/intrinsics-module.h"
#include "wasm-builder.h"
#include "wasm-s-parser.h"
#include <ir/abstract.h>
#include <ir/literal-utils.h>
#include <ir/localize.h>
#include <ir/match.h>
#include <ir/module-utils.h>
#include <limits>
#include <support/bits.h>
#include <support/div-by-const.h>

namespace wasm {

struct OptimizeForJSPass : public WalkerPass<PostWalker<OptimizeForJSPass>> {
  std::unordered_set<Name> neededIntrinsics;

  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new OptimizeForJSPass; }

  void doWalkModule(Module* module) {
    super::doWalkModule(module);

    // neededIntrinsics.insert(WASM_I64_MUL_HIGH);

    // if (neededIntrinsics.size() == 0) {
    //   return;
    // }

    // Module intrinsicsModule;
    // std::string input(IntrinsicsModuleWast);
    // SExpressionParser parser(const_cast<char*>(input.c_str()));
    // Element& root = *parser.root;
    // SExpressionWasmBuilder builder(
    //   intrinsicsModule, *root[0], IRProfile::Normal);

    // std::set<Name> neededFunctions;

    // while (neededIntrinsics.size() > 0) {
    //   for (auto& name : neededIntrinsics) {
    //     addNeededFunctions(intrinsicsModule, name, neededFunctions);
    //   }
    //   neededIntrinsics.clear();
    //   // Link in everything that wasn't already linked in. After we've done the
    //   // copy we then walk the function to rewrite any non-js operations it has
    //   // as well.
    //   for (auto& name : neededFunctions) {
    //     auto* func = module->getFunctionOrNull(name);
    //     if (!func) {
    //       func = ModuleUtils::copyFunction(intrinsicsModule.getFunction(name),
    //                                        *module);
    //     }
    //     doWalkFunction(func);
    //   }
    //   neededFunctions.clear();
    // }

    Name name = WASM_I64_MUL_HIGH;
    Module intrinsicsModule;
    std::string input(IntrinsicsModuleWast);
    SExpressionParser parser(const_cast<char*>(input.c_str()));
    Element& root = *parser.root;
    SExpressionWasmBuilder builder(
      intrinsicsModule, *root[0], IRProfile::Normal);

    auto* func = ModuleUtils::copyFunction(intrinsicsModule.getFunction(name), *module);
    doWalkFunction(func);

    // auto* func = intrinsicsModule.getFunction(name);
    // module->addFunction(std::move(func));
  }

  void visitBinary(Binary* curr) {
    using namespace Abstract;
    using namespace Match;
    {
      // popcnt(x) == 1   ==>   !!x & !(x & (x - 1))
      Expression* x;
      if (matches(curr, binary(Eq, unary(Popcnt, any(&x)), ival(1)))) {
        rewritePopcntEqualOne(x);
      }
    }
    {
      // i64(x) / C   ==>   mulh(x, M') >> S'
      //   where M' and S' are magic constants
      Const* c;
      Expression* x;
      if (matches(curr, binary(DivU, any(&x), i64(&c)))) {
        rewriteDivByConstU64(x, (uint64_t)c->value.geti64());
      }
    }
    {
      // i64(x) / C   ==>   mulh(x, M') >> S'
      //   where M' and S' are magic constants
      Const* c;
      Expression* x;
      if (matches(curr, binary(DivS, any(&x), i64(&c)))) {
        rewriteDivByConstS64(x, c->value.geti64());
      }
    }
    {
      // i64(x) % C   ==>   mulh(x, M') >> S'
      //   where M' and S' are magic constants
      Const* c;
      Expression* x;
      if (matches(curr, binary(RemU, any(&x), i64(&c)))) {
        rewriteRemByConstU64(x, (uint64_t)c->value.geti64());
      }
    }
    {
      // i64(x) % C   ==>   mulh(x, M') >> S'
      //   where M' and S' are magic constants
      Const* c;
      Expression* x;
      if (matches(curr, binary(RemS, any(&x), i64(&c)))) {
        rewriteRemByConstS64(x, c->value.geti64());
      }
    }
  }

  void rewritePopcntEqualOne(Expression* expr) {
    // popcnt(x) == 1   ==>   !!x & !(x & (x - 1))
    using namespace Abstract;

    Type type = expr->type;

    UnaryOp eqzOp = getUnary(type, EqZ);
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
          getBinary(type, And),
          builder.makeLocalGet(temp.index, type),
          builder.makeBinary(
            getBinary(type, Sub),
            builder.makeLocalGet(temp.index, type),
            builder.makeConst(Literal::makeOne(type.getBasic())))))));
  }

  void rewriteDivByConstU64(Expression* dividend, uint64_t divisor) {
    Builder builder(*getModule());

    if (divisor == 0) {
      // dividend / 0   ->   0
      //
      // This valid case in JavaScript
      replaceCurrent(builder.makeConst(uint64_t(0)));
      return;
    }

    const unsigned shift = Bits::countTrailingZeroes(divisor);
    if (shift) {
      divisor >>= shift;
      dividend = builder.makeBinary(
        ShrUInt64, dividend, builder.makeConst(uint64_t(shift)));
    }

    const auto payload = unsignedDivisionByConstant(divisor, shift);

    Type type = dividend->type;

    Name mul64HighName = WASM_I64_MUL_HIGH;
    neededIntrinsics.insert(name);

    // quotient = mulh(dividend, M')
    Index tempIndex = Builder::addVar(getFunction(), type);
    Expression* quotient = builder.makeLocalTee(
      tempIndex,
      builder.makeCall(
        mul64HighName, {dividend, builder.makeConst(payload.multiplier)}, type),
      type);

    if (payload.add) {
      // t1 = dividend - quotient
      // t2 = (t1 >> 1) + quotient
      // res = t2 >> (S' - 1)
      assert(payload.shift > 0);
      quotient = builder.makeBinary(
        ShrUInt64,
        builder.makeBinary(
          AddInt64,
          builder.makeBinary(ShrUInt64,
                             builder.makeBinary(SubInt64, dividend, quotient),
                             builder.makeConst(uint64_t(1))),
          builder.makeLocalGet(tempIndex, type)),
        builder.makeConst(uint64_t(payload.shift - 1)));
    } else {
      // res = quot >> shift
      quotient = builder.makeBinary(
        ShrUInt64, quotient, builder.makeConst(uint64_t(payload.shift)));
    }

    // use following control flow logic:
    //
    // if (!(dividend >> 32)) { // if high word is empty
    //   return i64(i32(dividend) / i32(C)) // or 0 if C > 2 ** 32
    // } else {
    //   return mulh(dividend, M') >> S'
    // }
    Expression* quotient32;
    Expression* cond = builder.makeUnary(
      EqZInt64,
      builder.makeBinary(ShrUInt64, dividend, builder.makeConst(uint64_t(32))));

    if (divisor <= (uint64_t)std::numeric_limits<uint32_t>::max()) {
      // i64(i32(dividend) / i32(C))
      quotient32 = builder.makeUnary(
        ExtendUInt32,
        builder.makeBinary(DivUInt32,
                           builder.makeUnary(WrapInt64, dividend),
                           builder.makeConst(uint32_t(divisor))));
    } else {
      // i32(dividend) / C, where C > 2 ** 32   ->   0
      quotient32 = builder.makeConst(uint64_t(0));
    }

    replaceCurrent(builder.makeIf(cond, quotient32, quotient));
  }

  void rewriteDivByConstS64(Expression* dividend, int64_t divisor) {
    // This case should never happen in view of the fact that
    // previous optimizations rewrite such case.
    assert(divisor != std::numeric_limits<int64_t>::min());

    Builder builder(*getModule());

    if (divisor == 0) {
      // dividend / 0   ->   0
      //
      // This valid case in JavaScript
      replaceCurrent(builder.makeConst(uint64_t(0)));
      return;
    }

    if (divisor == -1LL) {
      // dividend / -1   ->   0 - dividend
      //
      // Note: i64.min / -1 special case leads to overflow (trap) in WebAssembly
      // but valid in JavaScript (0 - i64.min ->  i64.min).
      replaceCurrent(
        builder.makeBinary(SubInt64, builder.makeConst(uint64_t(0)), dividend));
      return;
    }

    const auto payload = signedDivisionByConstant(uint64_t(divisor));

    Name mul64HighName = WASM_I64_MUL_HIGH;
    neededIntrinsics.insert(name);

    // quotient = mulh(dividend, M')
    Expression* quotient =
      builder.makeCall(mul64HighName,
                       {dividend, builder.makeConst(payload.multiplier)},
                       dividend->type);

    if (divisor > 0 && int64_t(payload.multiplier) < 0) {
      quotient = builder.makeBinary(AddInt64, quotient, dividend);
    } else if (divisor < 0 && int64_t(payload.multiplier) > 0) {
      quotient = builder.makeBinary(SubInt64, quotient, dividend);
    }

    quotient = builder.makeBinary(
      AddInt64,
      builder.makeBinary(
        ShrSInt64, quotient, builder.makeConst(int64_t(payload.shift))),
      builder.makeBinary(ShrUInt64, dividend, builder.makeConst(int64_t(63))));

    // use following control flow logic:
    //
    // if (!(dividend >> 32)) { // if high word is empry
    //   return i64(i32(dividend) / i32(C)) // or 0 if C > 2 ** 32
    // } else {
    //   return mulh(dividend, M') >> S'
    // }
    Expression* quotient32;
    Expression* cond = builder.makeUnary(
      EqZInt64,
      builder.makeBinary(ShrUInt64, dividend, builder.makeConst(uint64_t(32))));

    if (divisor <= (int64_t)std::numeric_limits<uint32_t>::max()) {
      // i64(i32(dividend) / i32(C))
      quotient32 = builder.makeUnary(
        ExtendSInt32,
        builder.makeBinary(DivSInt32,
                           builder.makeUnary(WrapInt64, dividend),
                           builder.makeConst(int32_t(divisor))));
    } else {
      // i32(dividend) / C, where C > 2 ** 32   ->   0
      quotient32 = builder.makeConst(int64_t(0));
    }

    replaceCurrent(builder.makeIf(cond, quotient32, quotient));
  }

  void rewriteRemByConstU64(Expression* dividend, uint64_t divisor) {
    // assert(divisor != 0);

    // TODO:
  }

  void rewriteRemByConstS64(Expression* dividend, int64_t divisor) {
    // assert(divisor != 0);
    // assert(divisor != std::numeric_limits<int64_t>::min());

    // TODO:
  }

  void addNeededFunctions(Module& m, Name name, std::set<Name>& needed) {
    if (needed.count(name)) {
      return;
    }
    needed.insert(name);

    auto function = m.getFunction(name);
    FindAll<Call> calls(function->body);
    for (auto* call : calls.list) {
      auto* called = m.getFunction(call->target);
      if (!called->imported()) {
        this->addNeededFunctions(m, call->target, needed);
      }
    }
  }
};

Pass* createOptimizeForJSPass() { return new OptimizeForJSPass(); }

} // namespace wasm
