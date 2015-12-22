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

#ifndef wasm_asm_v_wasm_h
#define wasm_asm_v_wasm_h

#include "emscripten-optimizer/optimizer.h"

namespace wasm {

WasmType asmToWasmType(AsmType asmType) {
  switch (asmType) {
    case ASM_INT: return WasmType::i32;
    case ASM_DOUBLE: return WasmType::f64;
    case ASM_FLOAT: return WasmType::f32;
    case ASM_NONE: return WasmType::none;
    default: {}
  }
  abort();
}

AsmType wasmToAsmType(WasmType type) {
  switch (type) {
    case WasmType::i32: return ASM_INT;
    case WasmType::f32: return ASM_FLOAT;
    case WasmType::f64: return ASM_DOUBLE;
    case WasmType::none: return ASM_NONE;
    default: {}
  }
  abort();
}

char getSig(WasmType type) {
  switch (type) {
    case i32:  return 'i';
    case f32:  return 'f';
    case f64:  return 'd';
    case none: return 'v';
    default: abort();
  }
}

std::string getSig(FunctionType *type) {
  std::string ret;
  ret += getSig(type->result);
  for (auto param : type->params) {
    ret += getSig(param);
  }
  return ret;
}

std::string getSig(Function *func) {
  std::string ret;
  ret += getSig(func->result);
  for (auto param : func->params) {
    ret += getSig(param.type);
  }
  return ret;
}

std::string getSig(CallBase *call) {
  std::string ret;
  ret += getSig(call->type);
  for (auto operand : call->operands) {
    ret += getSig(operand->type);
  }
  return ret;
}

} // namespace wasm

#endif // wasm_asm_v_wasm_h
