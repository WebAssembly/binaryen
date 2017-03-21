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

WasmType asmToWasmType(AsmType asmType) {
  switch (asmType) {
    case ASM_INT: return WasmType::i32;
    case ASM_DOUBLE: return WasmType::f64;
    case ASM_FLOAT: return WasmType::f32;
    case ASM_INT64: return WasmType::i64;
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
    case WasmType::i64: return ASM_INT64;
    case WasmType::none: return ASM_NONE;
    default: {}
  }
  abort();
}

char getSig(WasmType type) {
  switch (type) {
    case i32:  return 'i';
    case i64:  return 'j';
    case f32:  return 'f';
    case f64:  return 'd';
    case none: return 'v';
    default: abort();
  }
}

std::string getSig(const FunctionType *type) {
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
  for (auto type : func->params) {
    ret += getSig(type);
  }
  return ret;
}

WasmType sigToWasmType(char sig) {
  switch (sig) {
    case 'i': return i32;
    case 'j': return i64;
    case 'f': return f32;
    case 'd': return f64;
    case 'v': return none;
    default: abort();
  }
}

FunctionType* sigToFunctionType(std::string sig) {
  auto ret = new FunctionType;
  ret->result = sigToWasmType(sig[0]);
  for (size_t i = 1; i < sig.size(); i++) {
    ret->params.push_back(sigToWasmType(sig[i]));
  }
  return ret;
}

FunctionType* ensureFunctionType(std::string sig, Module* wasm) {
  cashew::IString name(("FUNCSIG$" + sig).c_str(), false);
  if (wasm->getFunctionTypeOrNull(name)) {
    return wasm->getFunctionType(name);
  }
  // add new type
  auto type = new FunctionType;
  type->name = name;
  type->result = sigToWasmType(sig[0]);
  for (size_t i = 1; i < sig.size(); i++) {
    type->params.push_back(sigToWasmType(sig[i]));
  }
  wasm->addFunctionType(type);
  return type;
}

} // namespace wasm
