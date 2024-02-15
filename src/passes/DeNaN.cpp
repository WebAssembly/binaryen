/*
 * Copyright 2020 WebAssembly Community Group participants
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
// Instrument the wasm to convert NaN values at runtime into 0s. That is, every
// operation that might produce a NaN will go through a helper function which
// filters out NaNs (replacing them with 0). This ensures that NaNs are never
// consumed by any instructions, which is useful when fuzzing between VMs that
// differ on wasm's nondeterminism around NaNs.
//

#include "ir/names.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct DeNaN : public WalkerPass<
                 ControlFlowWalker<DeNaN, UnifiedExpressionVisitor<DeNaN>>> {
  // Adds calls.
  bool addsEffects() override { return true; }

  Name deNan32, deNan64, deNan128;

  void visitExpression(Expression* expr) {
    // If the expression returns a floating-point value, ensure it is not a
    // NaN. If we can do this at compile time, do it now, which is useful for
    // initializations of global (which we can't do a function call in). Note
    // that we don't instrument local.gets, which would cause problems if we
    // ran this pass more than once (the added functions use gets, and we don't
    // want to instrument them).
    if (expr->is<LocalGet>()) {
      return;
    }
    // If the result just falls through without being modified, then we've
    // already fixed it up earlier.
    if (Properties::isResultFallthrough(expr)) {
      return;
    }
    Builder builder(*getModule());
    Expression* replacement = nullptr;
    auto* c = expr->dynCast<Const>();
    if (expr->type == Type::f32) {
      if (c && c->value.isNaN()) {
        replacement = builder.makeConst(float(0));
      } else {
        replacement = builder.makeCall(deNan32, {expr}, Type::f32);
      }
    } else if (expr->type == Type::f64) {
      if (c && c->value.isNaN()) {
        replacement = builder.makeConst(double(0));
      } else {
        replacement = builder.makeCall(deNan64, {expr}, Type::f64);
      }
    } else if (expr->type == Type::v128) {
      if (c && maybeNaN(c)) {
        uint8_t zero[16] = {};
        replacement = builder.makeConst(Literal(zero));
      } else {
        replacement = builder.makeCall(deNan128, {expr}, Type::v128);
      }
    }
    if (replacement) {
      // We can't do this outside of a function, like in a global initializer,
      // where a call would be illegal.
      if (replacement->is<Const>() || getFunction()) {
        replaceCurrent(replacement);
      } else {
        std::cerr << "warning: cannot de-nan outside of function context\n";
      }
    }
  }

  void visitFunction(Function* func) {
    if (func->imported()) {
      return;
    }
    // Instrument all locals as they enter the function.
    Builder builder(*getModule());
    std::vector<Expression*> fixes;
    auto num = func->getNumParams();
    for (Index i = 0; i < num; i++) {
      if (func->getLocalType(i) == Type::f32) {
        fixes.push_back(builder.makeLocalSet(
          i,
          builder.makeCall(
            deNan32, {builder.makeLocalGet(i, Type::f32)}, Type::f32)));
      } else if (func->getLocalType(i) == Type::f64) {
        fixes.push_back(builder.makeLocalSet(
          i,
          builder.makeCall(
            deNan64, {builder.makeLocalGet(i, Type::f64)}, Type::f64)));
      } else if (func->getLocalType(i) == Type::v128) {
        fixes.push_back(builder.makeLocalSet(
          i,
          builder.makeCall(
            deNan128, {builder.makeLocalGet(i, Type::v128)}, Type::v128)));
      }
    }
    if (!fixes.empty()) {
      fixes.push_back(func->body);
      func->body = builder.makeBlock(fixes);
      // Merge blocks so we don't add an unnecessary one.
      PassRunner runner(getModule(), getPassOptions());
      runner.setIsNested(true);
      runner.add("merge-blocks");
      runner.run();
    }
  }

  void doWalkModule(Module* module) {
    // Pick names for the helper functions.
    deNan32 = Names::getValidFunctionName(*module, "deNan32");
    deNan64 = Names::getValidFunctionName(*module, "deNan64");
    deNan128 = Names::getValidFunctionName(*module, "deNan128");

    ControlFlowWalker<DeNaN, UnifiedExpressionVisitor<DeNaN>>::doWalkModule(
      module);

    // Add helper functions after the walk, so they are not instrumented.
    Builder builder(*module);
    auto add = [&](Name name, Type type, Literal literal, BinaryOp op) {
      auto func = Builder::makeFunction(name, Signature(type, type), {});
      // Compare the value to itself to check if it is a NaN, and return 0 if
      // so:
      //
      //   (if (result f*)
      //     (f*.eq
      //       (local.get $0)
      //       (local.get $0)
      //     )
      //     (local.get $0)
      //     (f*.const 0)
      //   )
      func->body = builder.makeIf(
        builder.makeBinary(
          op, builder.makeLocalGet(0, type), builder.makeLocalGet(0, type)),
        builder.makeLocalGet(0, type),
        builder.makeConst(literal));
      module->addFunction(std::move(func));
    };
    add(deNan32, Type::f32, Literal(float(0)), EqFloat32);
    add(deNan64, Type::f64, Literal(double(0)), EqFloat64);

    // v128 is trickier as the 128 bits may contain f32s or f64s, and we need to
    // check for nans both ways. Note that the f32 NaN pattern is a subset of
    // f64, since f64 NaNs fill with 1 the 11 bits of their exponent, which
    // encompasses the 8 bits of the f32 exponent, but the position of those
    // bits matters (a v128 has 4 possible places for f32 exponents, and only 2
    // for f64), so we must test both.
    if (module->features.hasSIMD()) {
      auto func = Builder::makeFunction(deNan128, Signature(Type::v128, Type::v128), {});

      // Compare f32s to themselves, giving all 1's where equal and all 0's for
      // a nan.
      Expression* test32 =
        builder.makeBinary(
          EqVecF32x4, builder.makeLocalGet(0, Type::v128), builder.makeLocalGet(0, Type::v128));
      // Check if all were 1.
      test32 = builder.makeUnary(AllTrueVecI32x4, test32);

      // Ditto for f64.
      Expression* test64 =
        builder.makeBinary(
          EqVecF64x2, builder.makeLocalGet(0, Type::v128), builder.makeLocalGet(0, Type::v128));
      test64 = builder.makeUnary(AllTrueVecI64x2, test64);

      // If either is a nan, we have a nan situation.
      auto* testBoth = builder.makeBinary(OrInt32, test32, test64);

      uint8_t zero[16] = {};
      func->body = builder.makeIf(
        testBoth,
        builder.makeLocalGet(0, Type::v128),
        builder.makeConst(Literal(zero)));
      module->addFunction(std::move(func));
    }
  }

  // Check if a contant v128 may contain f32 or f64 NaNs. This does a sequence
  // of operations much like deNan128() that was constructed above.
  bool maybeNaN(Const* c) {
    assert(c->type == Type::v128);
    auto value = c->value;

    // Compute if all f32s are equal to themselves.
    auto test32 = value.eqF32x4(value);
    test32 = test32.allTrueI32x4();

    // Compute if all f64s are equal to themselves.
    auto test64 = value.eqF64x2(value);
    test64 = test64.allTrueI64x2();

    // If any was not equal, this might be a NaN.
    return !(test32.getInteger() && test64.getInteger());
  }
};

Pass* createDeNaNPass() { return new DeNaN(); }

} // namespace wasm
