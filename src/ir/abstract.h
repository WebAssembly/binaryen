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

namespace wasm::Abstract {

enum Op {
  // Unary
  Abs,
  Neg,
  Popcnt,
  // Binary
  Add,
  Sub,
  Mul,
  DivU,
  DivS,
  RemU,
  RemS,
  Shl,
  ShrU,
  ShrS,
  RotL,
  RotR,
  And,
  Or,
  Xor,
  CopySign,
  // Relational
  EqZ,
  Eq,
  Ne,
  LtS,
  LtU,
  LeS,
  LeU,
  GtS,
  GtU,
  GeS,
  GeU
};

inline bool hasAnyRotateShift(BinaryOp op) {
  return op == RotLInt32 || op == RotRInt32 || op == RotLInt64 ||
         op == RotRInt64;
}

inline bool hasAnyShift(BinaryOp op) {
  return hasAnyRotateShift(op) || op == ShlInt32 || op == ShrSInt32 ||
         op == ShrUInt32 || op == ShlInt64 || op == ShrSInt64 ||
         op == ShrUInt64;
}

inline bool hasAnyReinterpret(UnaryOp op) {
  return op == ReinterpretInt32 || op == ReinterpretInt64 ||
         op == ReinterpretFloat32 || op == ReinterpretFloat64;
}

// Provide a wasm type and an abstract op and get the concrete one. For example,
// you can provide i32 and Add and receive the specific opcode for a 32-bit
// addition, AddInt32. If the op does not exist, it returns Invalid.
inline UnaryOp getUnary(Type type, Op op) {
  switch (type.getBasic()) {
    case Type::i32: {
      switch (op) {
        case EqZ:
          return EqZInt32;
        case Popcnt:
          return PopcntInt32;
        default:
          return InvalidUnary;
      }
      break;
    }
    case Type::i64: {
      switch (op) {
        case EqZ:
          return EqZInt64;
        case Popcnt:
          return PopcntInt64;
        default:
          return InvalidUnary;
      }
      break;
    }
    case Type::f32: {
      switch (op) {
        case Abs:
          return AbsFloat32;
        case Neg:
          return NegFloat32;
        default:
          return InvalidUnary;
      }
      break;
    }
    case Type::f64: {
      switch (op) {
        case Abs:
          return AbsFloat64;
        case Neg:
          return NegFloat64;
        default:
          return InvalidUnary;
      }
      break;
    }
    case Type::v128:
    case Type::none:
    case Type::unreachable: {
      return InvalidUnary;
    }
  }
  WASM_UNREACHABLE("invalid type");
}

inline BinaryOp getBinary(Type type, Op op) {
  switch (type.getBasic()) {
    case Type::i32: {
      switch (op) {
        case Add:
          return AddInt32;
        case Sub:
          return SubInt32;
        case Mul:
          return MulInt32;
        case DivU:
          return DivUInt32;
        case DivS:
          return DivSInt32;
        case RemU:
          return RemUInt32;
        case RemS:
          return RemSInt32;
        case Shl:
          return ShlInt32;
        case ShrU:
          return ShrUInt32;
        case ShrS:
          return ShrSInt32;
        case RotL:
          return RotLInt32;
        case RotR:
          return RotRInt32;
        case And:
          return AndInt32;
        case Or:
          return OrInt32;
        case Xor:
          return XorInt32;
        case Eq:
          return EqInt32;
        case Ne:
          return NeInt32;
        case LtS:
          return LtSInt32;
        case LtU:
          return LtUInt32;
        case LeS:
          return LeSInt32;
        case LeU:
          return LeUInt32;
        case GtS:
          return GtSInt32;
        case GtU:
          return GtUInt32;
        case GeS:
          return GeSInt32;
        case GeU:
          return GeUInt32;
        default:
          return InvalidBinary;
      }
      break;
    }
    case Type::i64: {
      switch (op) {
        case Add:
          return AddInt64;
        case Sub:
          return SubInt64;
        case Mul:
          return MulInt64;
        case DivU:
          return DivUInt64;
        case DivS:
          return DivSInt64;
        case RemU:
          return RemUInt64;
        case RemS:
          return RemSInt64;
        case Shl:
          return ShlInt64;
        case ShrU:
          return ShrUInt64;
        case ShrS:
          return ShrSInt64;
        case RotL:
          return RotLInt64;
        case RotR:
          return RotRInt64;
        case And:
          return AndInt64;
        case Or:
          return OrInt64;
        case Xor:
          return XorInt64;
        case Eq:
          return EqInt64;
        case Ne:
          return NeInt64;
        case LtS:
          return LtSInt64;
        case LtU:
          return LtUInt64;
        case LeS:
          return LeSInt64;
        case LeU:
          return LeUInt64;
        case GtS:
          return GtSInt64;
        case GtU:
          return GtUInt64;
        case GeS:
          return GeSInt64;
        case GeU:
          return GeUInt64;
        default:
          return InvalidBinary;
      }
      break;
    }
    case Type::f32: {
      switch (op) {
        case Add:
          return AddFloat32;
        case Sub:
          return SubFloat32;
        case Mul:
          return MulFloat32;
        case DivU:
          return DivFloat32;
        case DivS:
          return DivFloat32;
        case CopySign:
          return CopySignFloat32;
        case Eq:
          return EqFloat32;
        case Ne:
          return NeFloat32;
        default:
          return InvalidBinary;
      }
      break;
    }
    case Type::f64: {
      switch (op) {
        case Add:
          return AddFloat64;
        case Sub:
          return SubFloat64;
        case Mul:
          return MulFloat64;
        case DivU:
          return DivFloat64;
        case DivS:
          return DivFloat64;
        case CopySign:
          return CopySignFloat64;
        case Eq:
          return EqFloat64;
        case Ne:
          return NeFloat64;
        default:
          return InvalidBinary;
      }
      break;
    }
    case Type::v128:
    case Type::none:
    case Type::unreachable: {
      return InvalidBinary;
    }
  }
  WASM_UNREACHABLE("invalid type");
}

} // namespace wasm::Abstract

#endif // wasm_ir_abstract_h
