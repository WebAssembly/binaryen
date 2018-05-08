/*
 * Copyright 2018 WebAssembly Community Group participants
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

// Abstracts out operations from specific opcodes.

#ifndef wasm_ir_abstract_h
#define wasm_ir_abstract_h

#include <wasm.h>

namespace wasm {

namespace Abstract {

enum Op {
  // Unary
  Neg,
  // Binary
  Add, Sub, Mul, DivU, DivS, Rem, RemU, RemS,
  Shl, ShrU, ShrS,
  And, Or, Xor,
  // Relational
  Eq, Ne,
};

// Provide a wasm type and an abstract op and get the concrete one. For example, you can
// provide i32 and Add and receive the specific opcode for a 32-bit addition,
// AddInt32.
// If the op does not exist, it returns Invalid.
inline UnaryOp getUnary(Type type, Op op) {
  switch (type) {
    case i32: {
      return InvalidUnary;
    }
    case i64: {
      return InvalidUnary;
    }
    case f32: {
      switch (op) {
        case Neg: return NegFloat32;
        default:  return InvalidUnary;
      }
      break;
    }
    case f64: {
      switch (op) {
        case Neg: return NegFloat64;
        default:  return InvalidUnary;
      }
      break;
    }
    default: return InvalidUnary;
  }
  WASM_UNREACHABLE();
}

inline BinaryOp getBinary(Type type, Op op) {
  switch (type) {
    case i32: {
      switch (op) {
        case Add:  return AddInt32;
        case Sub:  return SubInt32;
        case Mul:  return MulInt32;
        case DivU: return DivUInt32;
        case DivS: return DivSInt32;
        case RemU: return RemUInt32;
        case RemS: return RemSInt32;
        case Shl:  return ShlInt32;
        case ShrU: return ShrUInt32;
        case ShrS: return ShrSInt32;
        case And:  return AndInt32;
        case Or:   return OrInt32;
        case Xor:  return XorInt32;
        case Eq:   return EqInt32;
        case Ne:   return NeInt32;
        default:   return InvalidBinary;
      }
      break;
    }
    case i64: {
      switch (op) {
        case Add:  return AddInt64;
        case Sub:  return SubInt64;
        case Mul:  return MulInt64;
        case DivU: return DivUInt64;
        case DivS: return DivSInt64;
        case RemU: return RemUInt64;
        case RemS: return RemSInt64;
        case Shl:  return ShlInt64;
        case ShrU: return ShrUInt64;
        case ShrS: return ShrSInt64;
        case And:  return AndInt64;
        case Or:   return OrInt64;
        case Xor:  return XorInt64;
        case Eq:   return EqInt64;
        case Ne:   return NeInt64;
        default:   return InvalidBinary;
      }
      break;
    }
    case f32: {
      switch (op) {
        case Add:  return AddFloat32;
        case Sub:  return SubFloat32;
        case Mul:  return MulFloat32;
        case DivU: return DivFloat32;
        case DivS: return DivFloat32;
        case Eq:   return EqFloat32;
        case Ne:   return NeFloat32;
        default:   return InvalidBinary;
      }
      break;
    }
    case f64: {
      switch (op) {
        case Add:  return AddFloat64;
        case Sub:  return SubFloat64;
        case Mul:  return MulFloat64;
        case DivU: return DivFloat64;
        case DivS: return DivFloat64;
        case Eq:   return EqFloat64;
        case Ne:   return NeFloat64;
        default:   return InvalidBinary;
      }
      break;
    }
    default: return InvalidBinary;
  }
  WASM_UNREACHABLE();
}

} // namespace Abstract

} // namespace wasm

#endif // wasm_ir_abstract_h

