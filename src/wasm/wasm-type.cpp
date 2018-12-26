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

#include "wasm-type.h"

#include <cstdlib>
#include "compiler-support.h"

namespace wasm {

const char* printType(Type type) {
  switch (type) {
    case Type::none: return "none";
    case Type::i32: return "i32";
    case Type::i64: return "i64";
    case Type::f32: return "f32";
    case Type::f64: return "f64";
    case Type::v128: return "v128";
    case Type::unreachable: return "unreachable";
  }
  WASM_UNREACHABLE();
}

unsigned getTypeSize(Type type) {
  switch (type) {
    case Type::i32: return 4;
    case Type::i64: return 8;
    case Type::f32: return 4;
    case Type::f64: return 8;
    case Type::v128: return 16;
    case Type::none:
    case Type::unreachable: WASM_UNREACHABLE();
  }
  WASM_UNREACHABLE();
}

Type getType(unsigned size, bool float_) {
  if (size < 4) return Type::i32;
  if (size == 4) return float_ ? Type::f32 : Type::i32;
  if (size == 8) return float_ ? Type::f64 : Type::i64;
  if (size == 16) return Type::v128;
  WASM_UNREACHABLE();
}

Type getReachableType(Type a, Type b) {
  return a != unreachable ? a : b;
}

bool isConcreteType(Type type) {
  return type != none && type != unreachable;
}

bool isIntegerType(Type type) {
  switch (type) {
    case i32:
    case i64: return true;
    default: return false;
  }
}

bool isFloatType(Type type) {
  switch (type) {
    case f32:
    case f64: return true;
    default: return false;
  }
}

bool isVectorType(Type type) {
  return type == v128;
}

} // namespace wasm
