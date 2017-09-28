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
// Pass that supports potentially-trapping wasm operations.
// For example, integer division traps when dividing by zero, so this pass
// generates a check and replaces the result with zero in that case.
//

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ast/trapping.h"
#include "mixed_arena.h"
#include "pass.h"
#include "wasm.h"
#include "wasm-builder.h"
#include "wasm-printing.h"
#include "wasm-type.h"
#include "support/name.h"

namespace wasm {

Name I64S_REM("i64s-rem"),
     I64U_REM("i64u-rem"),
     I64S_DIV("i64s-div"),
     I64U_DIV("i64u-div");

Name getBinaryFuncName(Binary* curr) {
  switch (curr->op) {
    case RemSInt32: return I32S_REM;
    case RemUInt32: return I32U_REM;
    case DivSInt32: return I32S_DIV;
    case DivUInt32: return I32U_DIV;
    case RemSInt64: return I64S_REM;
    case RemUInt64: return I64U_REM;
    case DivSInt64: return I64S_DIV;
    case DivUInt64: return I64U_DIV;
    default:
      return Name();
  }
}

Name getUnaryFuncName(Unary* curr) {
  switch (curr->op) {
  case TruncSFloat32ToInt32:
  case TruncUFloat32ToInt32:
    return F32_TO_INT;
  case TruncSFloat32ToInt64:
  case TruncUFloat32ToInt64:
    return F32_TO_INT64;
  case TruncSFloat64ToInt32:
  case TruncUFloat64ToInt32:
    return F64_TO_INT;
  case TruncSFloat64ToInt64:
  case TruncUFloat64ToInt64:
    return F64_TO_INT64;
  default:
    return Name();
  }
}

UnaryOp getSignedTruncOp(UnaryOp op) {
  switch (op) {
  case TruncUFloat32ToInt32:
    return TruncSFloat32ToInt32;
  case TruncUFloat32ToInt64:
    return TruncSFloat32ToInt64;
  case TruncUFloat64ToInt32:
    return TruncSFloat64ToInt32;
  case TruncUFloat64ToInt64:
    return TruncSFloat64ToInt64;
  default:
    return op;
  }
}

Function* generateBinaryFunc(Module& wasm, Binary *curr) {
  BinaryOp op = curr->op;
  WasmType type = curr->type;
  bool isI64 = type == i64;
  Builder builder(wasm);
  Expression* result = builder.makeBinary(op,
    builder.makeGetLocal(0, type),
    builder.makeGetLocal(1, type)
  );
  BinaryOp divSIntOp = isI64 ? DivSInt64 : DivSInt32;
  UnaryOp eqZOp = isI64 ? EqZInt64 : EqZInt32;
  Literal minLit = isI64 ? Literal(std::numeric_limits<int64_t>::min())
                         : Literal(std::numeric_limits<int32_t>::min());
  Literal zeroLit = isI64 ? Literal(int64_t(0)) : Literal(int32_t(0));
  if (op == divSIntOp) {
    // guard against signed division overflow
    BinaryOp eqOp = isI64 ? EqInt64 : EqInt32;
    Literal negLit = isI64 ? Literal(int64_t(-1)) : Literal(int32_t(-1));
    result = builder.makeIf(
      builder.makeBinary(AndInt32,
        builder.makeBinary(eqOp,
          builder.makeGetLocal(0, type),
          builder.makeConst(minLit)
        ),
        builder.makeBinary(eqOp,
          builder.makeGetLocal(1, type),
          builder.makeConst(negLit)
        )
      ),
      builder.makeConst(zeroLit),
      result
    );
  }
  auto func = new Function;
  func->name = getBinaryFuncName(curr);
  func->params.push_back(type);
  func->params.push_back(type);
  func->result = type;
  func->body = builder.makeIf(
    builder.makeUnary(eqZOp,
      builder.makeGetLocal(1, type)
    ),
    builder.makeConst(zeroLit),
    result
  );
  return func;
}

Function* generateUnaryFunc(Module& wasm, Unary *curr) {
  WasmType type = curr->value->type;
  WasmType retType = curr->type;
  bool isF64 = type == f64;
  bool isI64 = retType == i64;

  Builder builder(wasm);

  UnaryOp truncOp = getSignedTruncOp(curr->op);
  BinaryOp leOp = isF64 ? LeFloat64 : LeFloat32;
  BinaryOp geOp = isF64 ? GeFloat64 : GeFloat32;
  BinaryOp neOp = isF64 ? NeFloat64 : NeFloat32;
  Literal iMin = isI64 ? Literal(std::numeric_limits<int64_t>::min())
                       : Literal(std::numeric_limits<int32_t>::min());
  Literal iMax = isI64 ? Literal(std::numeric_limits<int64_t>::max())
                       : Literal(std::numeric_limits<int32_t>::max());
  Literal fMin = isF64 ? Literal(double(iMin.getInteger()) - 1)
                       : Literal( float(iMin.getInteger()) - 1);
  Literal fMax = isF64 ? Literal(double(iMax.getInteger()) + 1)
                       : Literal( float(iMax.getInteger()) + 1);

  auto func = new Function;
  func->name = getUnaryFuncName(curr);
  func->params.push_back(type);
  func->result = retType;
  func->body = builder.makeUnary(truncOp,
    builder.makeGetLocal(0, type)
  );
  // too small XXX this is different than asm.js, which does frem. here we
  // clamp, which is much simpler/faster, and similar to native builds
  func->body = builder.makeIf(
    builder.makeBinary(leOp,
      builder.makeGetLocal(0, type),
      builder.makeConst(fMin)
    ),
    builder.makeConst(iMin),
    func->body
  );
  // too big XXX see above
  func->body = builder.makeIf(
    builder.makeBinary(geOp,
      builder.makeGetLocal(0, type),
      builder.makeConst(fMax)
    ),
    // NB: min here as well. anything out of range => to the min
    builder.makeConst(iMin),
    func->body
  );
  // nan
  func->body = builder.makeIf(
    builder.makeBinary(neOp,
      builder.makeGetLocal(0, type),
      builder.makeGetLocal(0, type)
    ),
    // NB: min here as well. anything invalid => to the min
    builder.makeConst(iMin),
    func->body
  );
  return func;
}

void ensureBinaryFunc(Binary* curr, Module& wasm,
                      GeneratedTrappingFunctions &generated) {
  Name name = getBinaryFuncName(curr);
  if (generated.hasFunction(name)) {
    return;
  }
  generated.addFunction(generateBinaryFunc(wasm, curr));
}

void ensureUnaryFunc(Unary *curr, Module& wasm,
                     GeneratedTrappingFunctions &generated) {
  Name name = getUnaryFuncName(curr);
  if (generated.hasFunction(name)) {
    return;
  }
  generated.addFunction(generateUnaryFunc(wasm, curr));
}

void ensureF64ToI64JSImport(Module& wasm, GeneratedTrappingFunctions &generated) {
  if (generated.hasImport(F64_TO_INT)) {
    return;
  }

  auto import = new Import; // f64-to-int = asm2wasm.f64-to-int;
  import->name = F64_TO_INT;
  import->module = ASM2WASM;
  import->base = F64_TO_INT;
  import->functionType = ensureFunctionType("id", &wasm)->name;
  import->kind = ExternalKind::Function;
  generated.addImport(import);
}

Expression* makeTrappingBinary(Binary* curr, Module& wasm,
                               GeneratedTrappingFunctions &generated) {
  Name name = getBinaryFuncName(curr);
  if (!name.is()) {
    return curr;
  }

  // the wasm operation might trap if done over 0, so generate a safe call
  WasmType type = curr->type;
  Builder builder(wasm);
  ensureBinaryFunc(curr, wasm, generated);
  return builder.makeCall(name, {curr->left, curr->right}, type);
}

Expression* makeTrappingUnary(Unary* curr, TrapMode mode, Module& wasm,
                              GeneratedTrappingFunctions &generated) {
  Name name = getUnaryFuncName(curr);
  if (!name.is()) {
    return curr;
  }

  Builder builder(wasm);
  // WebAssembly traps on float-to-int overflows, but asm.js wouldn't, so we must do something
  // We can handle this in one of two ways: clamping, which is fast, or JS, which
  // is precisely like JS but in order to do that we do a slow ffi
  // If i64, there is no "JS" way to handle this, as no i64s in JS, so always clamp if we don't allow traps
  if (curr->type != i64 && mode == TrapMode::JS) {
    // WebAssembly traps on float-to-int overflows, but asm.js wouldn't, so we must emulate that
    ensureF64ToI64JSImport(wasm, generated);
    Expression* f64Value = ensureDouble(curr->value, wasm.allocator);
    return builder.makeCallImport(F64_TO_INT, {f64Value}, i32);
  }

  ensureUnaryFunc(curr, wasm, generated);
  return builder.makeCall(name, {curr->value}, curr->type);
}

struct TrapModePass : public WalkerPass<PostWalker<TrapModePass>> {
public:

  // Needs to be non-parallel so that visitModule gets called after visiting
  // each node in the module, so we can add the functions that we created.
  bool isFunctionParallel() override { return false; }

  TrapModePass(TrapMode mode) : mode(mode) {
    assert(mode != TrapMode::Allow);
  }

  Pass* create() override { return new TrapModePass(mode); }

  void visitUnary(Unary* curr) {
    replaceCurrent(makeTrappingUnary(curr, mode, *getModule(), generated));
  }

  void visitBinary(Binary* curr) {
    replaceCurrent(makeTrappingBinary(curr, *getModule(), generated));
  }

  void visitModule(Module* curr) {
    generated.addToModule(*curr);
  }

private:
  TrapMode mode;
  // Need to defer adding generated functions because adding functions while
  // iterating over existing functions causes problems.
  GeneratedTrappingFunctions generated;
};

Pass *createTrapModeClamp() {
  return new TrapModePass(TrapMode::Clamp);
}

Pass *createTrapModeJS() {
  return new TrapModePass(TrapMode::JS);
}

} // namespace wasm
