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

#include "mixed_arena.h"
#include "emscripten-optimizer/optimizer.h"
#include "wasm.h"

namespace wasm {

WasmType asmToWasmType(AsmType asmType);

AsmType wasmToAsmType(WasmType type);

char getSig(WasmType type);

std::string getSig(const FunctionType *type);

std::string getSig(Function *func);

template<typename T,
         typename std::enable_if<std::is_base_of<Expression, T>::value>::type* = nullptr>
std::string getSig(T *call) {
  std::string ret;
  ret += getSig(call->type);
  for (auto operand : call->operands) {
    ret += getSig(operand->type);
  }
  return ret;
}

template<typename ListType>
std::string getSig(WasmType result, const ListType& operands) {
  std::string ret;
  ret += getSig(result);
  for (auto operand : operands) {
    ret += getSig(operand->type);
  }
  return ret;
}

template<typename ListType>
std::string getSigFromStructs(WasmType result, const ListType& operands) {
  std::string ret;
  ret += getSig(result);
  for (auto operand : operands) {
    ret += getSig(operand.type);
  }
  return ret;
}

WasmType sigToWasmType(char sig);

FunctionType* sigToFunctionType(std::string sig);

FunctionType* ensureFunctionType(std::string sig, Module* wasm);

} // namespace wasm

#endif // wasm_asm_v_wasm_h
