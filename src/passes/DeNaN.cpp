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
      } else if (!c) {
        replacement = builder.makeCall(deNan32, {expr}, Type::f32);
      }
    } else if (expr->type == Type::f64) {
      if (c && c->value.isNaN()) {
        replacement = builder.makeConst(double(0));
      } else if (!c) {
        replacement = builder.makeCall(deNan64, {expr}, Type::f64);
      }
    } else if (expr->type == Type::v128) {
      if (c && hasNaNLane(c)) {
        uint8_t zero[16] = {};
        replacement = builder.makeConst(Literal(zero));
      } else if (!c) {
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
    addFunc(module, deNan32, Type::f32, Literal(float(0)), EqFloat32);
    addFunc(module, deNan64, Type::f64, Literal(double(0)), EqFloat64);

    if (module->features.hasSIMD()) {
      uint8_t zero128[16] = {};
      addFunc(module, deNan128, Type::v128, Literal(zero128));
    }
  }

  // Add a de-NaN-ing helper function.
  void addFunc(Module* module,
               Name name,
               Type type,
               Literal literal,
               std::optional<BinaryOp> op = {}) {
    Builder builder(*module);
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
    Expression* condition;
    if (type != Type::v128) {
      // Generate a simple condition.
      assert(op);
      condition = builder.makeBinary(
        *op, builder.makeLocalGet(0, type), builder.makeLocalGet(0, type));
    } else {
      assert(!op);
      // v128 is trickier as the 128 bits may contain f32s or f64s, and we
      // need to check for nans both ways in principle. However, the f32 NaN
      // pattern is a superset of f64, since it checks less bits (8 bit
      // exponent vs 11), and it is checked in more places (4 32-bit values vs
      // 2 64-bit ones), so we can just check that. That is, this reduces to 4
      // checks of f32s, but is otherwise the same as a check of a single f32.
      //
      // However there is additional complexity, which is that if we do
      // EqVecF32x4 then we get all-1s for each case where we compare equal.
      // That itself is a NaN pattern, which means that running this pass
      // twice would interfere with itself. To avoid that we'd need a way to
      // detect our previous instrumentation and not instrument it, but that
      // is tricky (we can't depend on function names etc. while fuzzing).
      // Instead, extract the lanes and use f32 checks.
      auto getLane = [&](Index index) {
        return builder.makeSIMDExtract(
          ExtractLaneVecF32x4, builder.makeLocalGet(0, type), index);
      };
      auto getLaneCheck = [&](Index index) {
        return builder.makeBinary(EqFloat32, getLane(index), getLane(index));
      };
      auto* firstTwo =
        builder.makeBinary(AndInt32, getLaneCheck(0), getLaneCheck(1));
      auto* lastTwo =
        builder.makeBinary(AndInt32, getLaneCheck(2), getLaneCheck(3));
      condition = builder.makeBinary(AndInt32, firstTwo, lastTwo);
    }
    func->body = builder.makeIf(
      condition, builder.makeLocalGet(0, type), builder.makeConst(literal));
    module->addFunction(std::move(func));
  };

  // Check if a contant v128 may contain f32 or f64 NaNs.
  bool hasNaNLane(Const* c) {
    assert(c->type == Type::v128);
    auto value = c->value;

    // Compute if all f32s are equal to themselves.
    auto test32 = value.eqF32x4(value);
    test32 = test32.allTrueI32x4();

    return !test32.getInteger();
  }
};

Pass* createDeNaNPass() { return new DeNaN(); }

} // namespace wasm
