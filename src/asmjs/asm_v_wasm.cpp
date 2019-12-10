/*
 * Copyright 2015 WebAssembly Community Group participants
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

#include "asm_v_wasm.h"
#include "wasm.h"

namespace wasm {

Type asmToWasmType(AsmType asmType) {
  switch (asmType) {
    case ASM_INT:
      return Type::i32;
    case ASM_DOUBLE:
      return Type::f64;
    case ASM_FLOAT:
      return Type::f32;
    case ASM_INT64:
      return Type::i64;
    case ASM_NONE:
      return Type::none;
    case ASM_FLOAT32X4:
    case ASM_FLOAT64X2:
    case ASM_INT8X16:
    case ASM_INT16X8:
    case ASM_INT32X4:
      return Type::v128;
  }
  WASM_UNREACHABLE("invalid type");
}

AsmType wasmToAsmType(Type type) {
  switch (type) {
    case i32:
      return ASM_INT;
    case f32:
      return ASM_FLOAT;
    case f64:
      return ASM_DOUBLE;
    case i64:
      return ASM_INT64;
    case v128:
      assert(false && "v128 not implemented yet");
    case anyref:
      assert(false && "anyref is not supported by asm2wasm");
    case exnref:
      assert(false && "exnref is not supported by asm2wasm");
    case none:
      return ASM_NONE;
    case unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

char getSig(Type type) {
  switch (type) {
    case i32:
      return 'i';
    case i64:
      return 'j';
    case f32:
      return 'f';
    case f64:
      return 'd';
    case v128:
      return 'V';
    case anyref:
      return 'a';
    case exnref:
      return 'e';
    case none:
      return 'v';
    case unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

std::string getSig(Function* func) {
  return getSig(func->sig.results, func->sig.params);
}

std::string getSig(Type results, Type params) {
  assert(!results.isMulti());
  std::string sig;
  sig += getSig(results);
  for (Type t : params.expand()) {
    sig += getSig(t);
  }
  return sig;
}

Expression* ensureDouble(Expression* expr, MixedArena& allocator) {
  if (expr->type == f32) {
    auto conv = allocator.alloc<Unary>();
    conv->op = PromoteFloat32;
    conv->value = expr;
    conv->type = Type::f64;
    return conv;
  }
  assert(expr->type == f64);
  return expr;
}

} // namespace wasm
