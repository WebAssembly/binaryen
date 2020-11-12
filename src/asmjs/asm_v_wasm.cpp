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

AsmType wasmToAsmType(Type type) {
  TODO_SINGLE_COMPOUND(type);
  switch (type.getBasic()) {
    case Type::i32:
      return ASM_INT;
    case Type::f32:
      return ASM_FLOAT;
    case Type::f64:
      return ASM_DOUBLE;
    case Type::i64:
      return ASM_INT64;
    case Type::v128:
      assert(false && "v128 not implemented yet");
    case Type::funcref:
    case Type::externref:
    case Type::exnref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
      assert(false && "reference types are not supported by asm2wasm");
    case Type::none:
      return ASM_NONE;
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

char getSig(Type type) {
  TODO_SINGLE_COMPOUND(type);
  switch (type.getBasic()) {
    case Type::i32:
      return 'i';
    case Type::i64:
      return 'j';
    case Type::f32:
      return 'f';
    case Type::f64:
      return 'd';
    case Type::v128:
      return 'V';
    case Type::funcref:
      return 'F';
    case Type::externref:
      return 'X';
    case Type::exnref:
      return 'E';
    case Type::anyref:
      return 'A';
    case Type::eqref:
      return 'Q';
    case Type::i31ref:
      return 'I';
    case Type::none:
      return 'v';
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

std::string getSig(Type results, Type params) {
  assert(!results.isTuple());
  std::string sig;
  sig += getSig(results);
  for (const auto& param : params) {
    sig += getSig(param);
  }
  return sig;
}

} // namespace wasm
