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
#include "wasm.h"

namespace wasm {

JsType wasmToJsType(Type type);

char getSig(Type type);
std::string getSig(Type results, Type params);

template<typename ListType>
std::string getSig(Type result, const ListType& operands) {
  std::string ret;
  ret += getSig(result);
  for (auto operand : operands) {
    ret += getSig(operand->type);
  }
  return ret;
}

template<typename ListType>
std::string getSigFromStructs(Type result, const ListType& operands) {
  std::string ret;
  ret += getSig(result);
  for (auto operand : operands) {
    ret += getSig(operand.type);
  }
  return ret;
}

} // namespace wasm

#endif // wasm_asm_v_wasm_h
