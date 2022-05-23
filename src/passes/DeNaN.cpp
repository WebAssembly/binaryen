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

  Name deNan32, deNan64;

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
  }
};

Pass* createDeNaNPass() { return new DeNaN(); }

} // namespace wasm
