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

//
// wasm.h: WebAssembly representation and processing library, in one
//         header file.
//
// This represents WebAssembly in an AST format, with a focus on making
// it easy to not just inspect but also to process. For example, some
// things that this enables are:
//
//  * Interpreting: See wasm-interpreter.h.
//  * Optimizing: See asm2wasm.h, which performs some optimizations
//                after code generation.
//  * Validation: See wasm-validator.h.
//  * Pretty-printing: See Print.cpp.
//

//
// wasm.js internal WebAssembly representation design:
//
//  * Unify where possible. Where size isn't a concern, combine
//    classes, so binary ops and relational ops are joined. This
//    simplifies that AST and makes traversals easier.
//  * Optimize for size? This might justify separating if and if_else
//    (so that if doesn't have an always-empty else; also it avoids
//    a branch).
//

#ifndef wasm_wasm_h
#define wasm_wasm_h

#include <cassert>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <map>
#include <string>
#include <vector>

#include "compiler-support.h"
#include "emscripten-optimizer/simple_ast.h"
#include "mixed_arena.h"
#include "pretty_printing.h"
#include "support/bits.h"
#include "support/utilities.h"

namespace wasm {

// We use a Name for all of the identifiers. These are IStrings, so they are
// all interned - comparisons etc are just pointer comparisons, so there is no
// perf loss. Having names everywhere makes using the AST much nicer (for
// example, block names are strings and not offsets, which makes composition
// - adding blocks, removing blocks - easy). One exception is local variables,
// where we do use indices, as they are a large proportion of the AST,
// perf matters a lot there, and compositionality is not a problem.
// TODO: as an optimization, IString values < some threshold could be considered
//       numerical indices directly.

struct Name : public cashew::IString {
  Name() : cashew::IString() {}
  Name(const char *str) : cashew::IString(str, false) {}
  Name(cashew::IString str) : cashew::IString(str) {}
  Name(const std::string &str) : cashew::IString(str.c_str(), false) {}

  friend std::ostream& operator<<(std::ostream &o, Name name) {
    assert(name.str);
    return o << '$' << name.str; // reference interpreter requires we prefix all names
  }

  static Name fromInt(size_t i) {
    return cashew::IString(std::to_string(i).c_str(), false);
  }
};

// An index in a wasm module
typedef uint32_t Index;

// An address in linear memory. For now only wasm32
struct Address {
  typedef uint32_t address_t;
  address_t addr;
  Address() : addr(0) {}
  Address(uint64_t a) : addr(static_cast<address_t>(a)) {
    assert(a <= std::numeric_limits<address_t>::max());
  }
  Address& operator=(uint64_t a) {
    assert(a <= std::numeric_limits<address_t>::max());
    addr = static_cast<address_t>(a);
    return *this;
  }
  operator address_t() const { return addr; }
  Address& operator++() { ++addr; return *this; }
};

// Types

enum WasmType {
  none,
  i32,
  i64,
  f32,
  f64,
  unreachable // none means no type, e.g. a block can have no return type. but
              // unreachable is different, as it can be "ignored" when doing
              // type checking across branches
};

inline const char* printWasmType(WasmType type) {
  switch (type) {
    case WasmType::none: return "none";
    case WasmType::i32: return "i32";
    case WasmType::i64: return "i64";
    case WasmType::f32: return "f32";
    case WasmType::f64: return "f64";
    case WasmType::unreachable: return "unreachable";
    default: WASM_UNREACHABLE();
  }
}

inline unsigned getWasmTypeSize(WasmType type) {
  switch (type) {
    case WasmType::none: abort();
    case WasmType::i32: return 4;
    case WasmType::i64: return 8;
    case WasmType::f32: return 4;
    case WasmType::f64: return 8;
    default: WASM_UNREACHABLE();
  }
}

inline bool isWasmTypeFloat(WasmType type) {
  switch (type) {
    case f32:
    case f64: return true;
    default: return false;
  }
}

inline WasmType getWasmType(unsigned size, bool float_) {
  if (size < 4) return WasmType::i32;
  if (size == 4) return float_ ? WasmType::f32 : WasmType::i32;
  if (size == 8) return float_ ? WasmType::f64 : WasmType::i64;
  abort();
}

inline WasmType getReachableWasmType(WasmType a, WasmType b) {
  return a != unreachable ? a : b;
}

inline bool isConcreteWasmType(WasmType type) {
  return type != none && type != unreachable;
}

// Literals

class Literal {
public:
  WasmType type;

private:
  // store only integers, whose bits are deterministic. floats
  // can have their signalling bit set, for example.
  union {
    int32_t i32;
    int64_t i64;
  };

  // The RHS of shl/shru/shrs must be masked by bitwidth.
  template <typename T>
  static T shiftMask(T val) {
    return val & (sizeof(T) * 8 - 1);
  }

 public:
  Literal() : type(WasmType::none), i64(0) {}
  explicit Literal(WasmType type) : type(type), i64(0) {}
  explicit Literal(int32_t  init) : type(WasmType::i32), i32(init) {}
  explicit Literal(uint32_t init) : type(WasmType::i32), i32(init) {}
  explicit Literal(int64_t  init) : type(WasmType::i64), i64(init) {}
  explicit Literal(uint64_t init) : type(WasmType::i64), i64(init) {}
  explicit Literal(float    init) : type(WasmType::f32), i32(bit_cast<int32_t>(init)) {}
  explicit Literal(double   init) : type(WasmType::f64), i64(bit_cast<int64_t>(init)) {}

  Literal castToF32() {
    assert(type == WasmType::i32);
    Literal ret(i32);
    ret.type = WasmType::f32;
    return ret;
  }
  Literal castToF64() {
    assert(type == WasmType::i64);
    Literal ret(i64);
    ret.type = WasmType::f64;
    return ret;
  }
  Literal castToI32() {
    assert(type == WasmType::f32);
    Literal ret(i32);
    ret.type = WasmType::i32;
    return ret;
  }
  Literal castToI64() {
    assert(type == WasmType::f64);
    Literal ret(i64);
    ret.type = WasmType::i64;
    return ret;
  }

  int32_t geti32() const { assert(type == WasmType::i32); return i32; }
  int64_t geti64() const { assert(type == WasmType::i64); return i64; }
  float   getf32() const { assert(type == WasmType::f32); return bit_cast<float>(i32); }
  double  getf64() const { assert(type == WasmType::f64); return bit_cast<double>(i64); }

  int32_t* geti32Ptr() { assert(type == WasmType::i32); return &i32; } // careful!

  int32_t reinterpreti32() const { assert(type == WasmType::f32); return i32; }
  int64_t reinterpreti64() const { assert(type == WasmType::f64); return i64; }
  float   reinterpretf32() const { assert(type == WasmType::i32); return bit_cast<float>(i32); }
  double  reinterpretf64() const { assert(type == WasmType::i64); return bit_cast<double>(i64); }

  int64_t getInteger() {
    switch (type) {
      case WasmType::i32: return i32;
      case WasmType::i64: return i64;
      default: abort();
    }
  }

  double getFloat() {
    switch (type) {
      case WasmType::f32: return getf32();
      case WasmType::f64: return getf64();
      default: abort();
    }
  }

  bool operator==(const Literal& other) const {
    if (type != other.type) return false;
    switch (type) {
      case WasmType::none: return true;
      case WasmType::i32: return i32 == other.i32;
      case WasmType::f32: return getf32() == other.getf32();
      case WasmType::i64: return i64 == other.i64;
      case WasmType::f64: return getf64() == other.getf64();
      default: abort();
    }
  }

  static uint32_t NaNPayload(float f) {
    assert(std::isnan(f) && "expected a NaN");
    // SEEEEEEE EFFFFFFF FFFFFFFF FFFFFFFF
    // NaN has all-one exponent and non-zero fraction.
    return ~0xff800000u & bit_cast<uint32_t>(f);
  }

  static uint64_t NaNPayload(double f) {
    assert(std::isnan(f) && "expected a NaN");
    // SEEEEEEE EEEEFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF
    // NaN has all-one exponent and non-zero fraction.
    return ~0xfff0000000000000ull & bit_cast<uint64_t>(f);
  }

  static float setQuietNaN(float f) {
    assert(std::isnan(f) && "expected a NaN");
    // An SNaN is a NaN with the most significant fraction bit clear.
    return bit_cast<float>(0x00400000u | bit_cast<uint32_t>(f));
  }

  static double setQuietNaN(double f) {
    assert(std::isnan(f) && "expected a NaN");
    // An SNaN is a NaN with the most significant fraction bit clear.
    return bit_cast<double>(0x0008000000000000ull | bit_cast<uint64_t>(f));
  }

  static void printFloat(std::ostream &o, float f) {
    if (std::isnan(f)) {
      const char *sign = std::signbit(f) ? "-" : "";
      o << sign << "nan";
      if (uint32_t payload = NaNPayload(f)) {
        o << ":0x" << std::hex << payload << std::dec;
      }
      return;
    }
    printDouble(o, f);
  }

  static void printDouble(std::ostream &o, double d) {
    if (d == 0 && std::signbit(d)) {
      o << "-0";
      return;
    }
    if (std::isnan(d)) {
      const char *sign = std::signbit(d) ? "-" : "";
      o << sign << "nan";
      if (uint64_t payload = NaNPayload(d)) {
        o << ":0x" << std::hex << payload << std::dec;
      }
      return;
    }
    if (!std::isfinite(d)) {
      o << (std::signbit(d) ? "-infinity" : "infinity");
      return;
    }
    const char *text = cashew::JSPrinter::numToString(d);
    // spec interpreter hates floats starting with '.'
    if (text[0] == '.') {
      o << '0';
    } else if (text[0] == '-' && text[1] == '.') {
      o << "-0";
      text++;
    }
    o << text;
  }

  friend std::ostream& operator<<(std::ostream &o, Literal literal) {
    o << '(';
    prepareMinorColor(o) << printWasmType(literal.type) << ".const ";
    switch (literal.type) {
      case none: o << "?"; break;
      case WasmType::i32: o << literal.i32; break;
      case WasmType::i64: o << literal.i64; break;
      case WasmType::f32: literal.printFloat(o, literal.getf32()); break;
      case WasmType::f64: literal.printDouble(o, literal.getf64()); break;
      default: WASM_UNREACHABLE();
    }
    restoreNormalColor(o);
    return o << ')';
  }

  Literal countLeadingZeroes() const {
    if (type == WasmType::i32) return Literal((int32_t)CountLeadingZeroes(i32));
    if (type == WasmType::i64) return Literal((int64_t)CountLeadingZeroes(i64));
    WASM_UNREACHABLE();
  }
  Literal countTrailingZeroes() const {
    if (type == WasmType::i32) return Literal((int32_t)CountTrailingZeroes(i32));
    if (type == WasmType::i64) return Literal((int64_t)CountTrailingZeroes(i64));
    WASM_UNREACHABLE();
  }
  Literal popCount() const {
    if (type == WasmType::i32) return Literal((int32_t)PopCount(i32));
    if (type == WasmType::i64) return Literal((int64_t)PopCount(i64));
    WASM_UNREACHABLE();
  }

  Literal extendToSI64() const {
    assert(type == WasmType::i32);
    return Literal((int64_t)i32);
  }
  Literal extendToUI64() const {
    assert(type == WasmType::i32);
    return Literal((uint64_t)(uint32_t)i32);
  }
  Literal extendToF64() const {
    assert(type == WasmType::f32);
    return Literal(double(getf32()));
  }
  Literal truncateToI32() const {
    assert(type == WasmType::i64);
    return Literal((int32_t)i64);
  }
  Literal truncateToF32() const {
    assert(type == WasmType::f64);
    return Literal(float(getf64()));
  }

  Literal convertSToF32() const {
    if (type == WasmType::i32) return Literal(float(i32));
    if (type == WasmType::i64) return Literal(float(i64));
    WASM_UNREACHABLE();
  }
  Literal convertUToF32() const {
    if (type == WasmType::i32) return Literal(float(uint32_t(i32)));
    if (type == WasmType::i64) return Literal(float(uint64_t(i64)));
    WASM_UNREACHABLE();
  }
  Literal convertSToF64() const {
    if (type == WasmType::i32) return Literal(double(i32));
    if (type == WasmType::i64) return Literal(double(i64));
    WASM_UNREACHABLE();
  }
  Literal convertUToF64() const {
    if (type == WasmType::i32) return Literal(double(uint32_t(i32)));
    if (type == WasmType::i64) return Literal(double(uint64_t(i64)));
    WASM_UNREACHABLE();
  }

  Literal neg() const {
    switch (type) {
      case WasmType::i32: return Literal(i32 ^ 0x80000000);
      case WasmType::i64: return Literal(int64_t(i64 ^ 0x8000000000000000ULL));
      case WasmType::f32: return Literal(i32 ^ 0x80000000).castToF32();
      case WasmType::f64: return Literal(int64_t(i64 ^ 0x8000000000000000ULL)).castToF64();
      default: WASM_UNREACHABLE();
    }
  }
  Literal abs() const {
    switch (type) {
      case WasmType::i32: return Literal(i32 & 0x7fffffff);
      case WasmType::i64: return Literal(int64_t(i64 & 0x7fffffffffffffffULL));
      case WasmType::f32: return Literal(i32 & 0x7fffffff).castToF32();
      case WasmType::f64: return Literal(int64_t(i64 & 0x7fffffffffffffffULL)).castToF64();
      default: WASM_UNREACHABLE();
    }
  }
  Literal ceil() const {
    switch (type) {
      case WasmType::f32: return Literal(std::ceil(getf32()));
      case WasmType::f64: return Literal(std::ceil(getf64()));
      default: WASM_UNREACHABLE();
    }
  }
  Literal floor() const {
    switch (type) {
      case WasmType::f32: return Literal(std::floor(getf32()));
      case WasmType::f64: return Literal(std::floor(getf64()));
      default: WASM_UNREACHABLE();
    }
  }
  Literal trunc() const {
    switch (type) {
      case WasmType::f32: return Literal(std::trunc(getf32()));
      case WasmType::f64: return Literal(std::trunc(getf64()));
      default: WASM_UNREACHABLE();
    }
  }
  Literal nearbyint() const {
    switch (type) {
      case WasmType::f32: return Literal(std::nearbyint(getf32()));
      case WasmType::f64: return Literal(std::nearbyint(getf64()));
      default: WASM_UNREACHABLE();
    }
  }
  Literal sqrt() const {
    switch (type) {
      case WasmType::f32: return Literal(std::sqrt(getf32()));
      case WasmType::f64: return Literal(std::sqrt(getf64()));
      default: WASM_UNREACHABLE();
    }
  }

  Literal add(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) + uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) + uint64_t(other.i64));
      case WasmType::f32: return Literal(getf32() + other.getf32());
      case WasmType::f64: return Literal(getf64() + other.getf64());
      default: WASM_UNREACHABLE();
    }
  }
  Literal sub(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) - uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) - uint64_t(other.i64));
      case WasmType::f32: return Literal(getf32() - other.getf32());
      case WasmType::f64: return Literal(getf64() - other.getf64());
      default: WASM_UNREACHABLE();
    }
  }
  Literal mul(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) * uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) * uint64_t(other.i64));
      case WasmType::f32: return Literal(getf32() * other.getf32());
      case WasmType::f64: return Literal(getf64() * other.getf64());
      default: WASM_UNREACHABLE();
    }
  }
  Literal div(const Literal& other) const {
    switch (type) {
      case WasmType::f32: {
        float lhs = getf32(), rhs = other.getf32();
        float sign = std::signbit(lhs) == std::signbit(rhs) ? 0.f : -0.f;
        switch (std::fpclassify(rhs)) {
          case FP_ZERO:
          switch (std::fpclassify(lhs)) {
            case FP_NAN: return Literal(setQuietNaN(lhs));
            case FP_ZERO: return Literal(std::copysign(std::numeric_limits<float>::quiet_NaN(), sign));
            case FP_NORMAL: // fallthrough
            case FP_SUBNORMAL: // fallthrough
            case FP_INFINITE: return Literal(std::copysign(std::numeric_limits<float>::infinity(), sign));
            default: WASM_UNREACHABLE();
          }
          case FP_NAN: // fallthrough
          case FP_INFINITE: // fallthrough
          case FP_NORMAL: // fallthrough
          case FP_SUBNORMAL: return Literal(lhs / rhs);
          default: WASM_UNREACHABLE();
        }
      }
      case WasmType::f64: {
        double lhs = getf64(), rhs = other.getf64();
        double sign = std::signbit(lhs) == std::signbit(rhs) ? 0. : -0.;
        switch (std::fpclassify(rhs)) {
          case FP_ZERO:
          switch (std::fpclassify(lhs)) {
            case FP_NAN: return Literal(setQuietNaN(lhs));
            case FP_ZERO: return Literal(std::copysign(std::numeric_limits<double>::quiet_NaN(), sign));
            case FP_NORMAL: // fallthrough
            case FP_SUBNORMAL: // fallthrough
            case FP_INFINITE: return Literal(std::copysign(std::numeric_limits<double>::infinity(), sign));
            default: WASM_UNREACHABLE();
          }
          case FP_NAN: // fallthrough
          case FP_INFINITE: // fallthrough
          case FP_NORMAL: // fallthrough
          case FP_SUBNORMAL: return Literal(lhs / rhs);
          default: WASM_UNREACHABLE();
        }
      }
      default: WASM_UNREACHABLE();
    }
  }
  Literal divS(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 / other.i32);
      case WasmType::i64: return Literal(i64 / other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal divU(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) / uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) / uint64_t(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal remS(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 % other.i32);
      case WasmType::i64: return Literal(i64 % other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal remU(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) % uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) % uint64_t(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal and_(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 & other.i32);
      case WasmType::i64: return Literal(i64 & other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal or_(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 | other.i32);
      case WasmType::i64: return Literal(i64 | other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal xor_(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 ^ other.i32);
      case WasmType::i64: return Literal(i64 ^ other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal shl(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) << shiftMask(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) << shiftMask(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal shrS(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 >> shiftMask(other.i32));
      case WasmType::i64: return Literal(i64 >> shiftMask(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal shrU(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) >> shiftMask(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) >> shiftMask(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal rotL(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(RotateLeft(uint32_t(i32), uint32_t(other.i32)));
      case WasmType::i64: return Literal(RotateLeft(uint64_t(i64), uint64_t(other.i64)));
      default: WASM_UNREACHABLE();
    }
  }
  Literal rotR(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(RotateRight(uint32_t(i32), uint32_t(other.i32)));
      case WasmType::i64: return Literal(RotateRight(uint64_t(i64), uint64_t(other.i64)));
      default: WASM_UNREACHABLE();
    }
  }

  Literal eq(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 == other.i32);
      case WasmType::i64: return Literal(i64 == other.i64);
      case WasmType::f32: return Literal(getf32() == other.getf32());
      case WasmType::f64: return Literal(getf64() == other.getf64());
      default: WASM_UNREACHABLE();
    }
  }
  Literal ne(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 != other.i32);
      case WasmType::i64: return Literal(i64 != other.i64);
      case WasmType::f32: return Literal(getf32() != other.getf32());
      case WasmType::f64: return Literal(getf64() != other.getf64());
      default: WASM_UNREACHABLE();
    }
  }
  Literal ltS(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 < other.i32);
      case WasmType::i64: return Literal(i64 < other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal ltU(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) < uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) < uint64_t(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal lt(const Literal& other) const {
    switch (type) {
      case WasmType::f32: return Literal(getf32() < other.getf32());
      case WasmType::f64: return Literal(getf64() < other.getf64());
      default: WASM_UNREACHABLE();
    }
  }
  Literal leS(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 <= other.i32);
      case WasmType::i64: return Literal(i64 <= other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal leU(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) <= uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) <= uint64_t(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal le(const Literal& other) const {
    switch (type) {
      case WasmType::f32: return Literal(getf32() <= other.getf32());
      case WasmType::f64: return Literal(getf64() <= other.getf64());
      default: WASM_UNREACHABLE();
    }
  }

  Literal gtS(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 > other.i32);
      case WasmType::i64: return Literal(i64 > other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal gtU(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) > uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) > uint64_t(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal gt(const Literal& other) const {
    switch (type) {
      case WasmType::f32: return Literal(getf32() > other.getf32());
      case WasmType::f64: return Literal(getf64() > other.getf64());
      default: WASM_UNREACHABLE();
    }
  }
  Literal geS(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(i32 >= other.i32);
      case WasmType::i64: return Literal(i64 >= other.i64);
      default: WASM_UNREACHABLE();
    }
  }
  Literal geU(const Literal& other) const {
    switch (type) {
      case WasmType::i32: return Literal(uint32_t(i32) >= uint32_t(other.i32));
      case WasmType::i64: return Literal(uint64_t(i64) >= uint64_t(other.i64));
      default: WASM_UNREACHABLE();
    }
  }
  Literal ge(const Literal& other) const {
    switch (type) {
      case WasmType::f32: return Literal(getf32() >= other.getf32());
      case WasmType::f64: return Literal(getf64() >= other.getf64());
      default: WASM_UNREACHABLE();
    }
  }

  Literal min(const Literal& other) const {
    switch (type) {
      case WasmType::f32: {
        auto l = getf32(), r = other.getf32();
        if (l == r && l == 0) return Literal(std::signbit(l) ? l : r);
        auto result = std::min(l, r);
        bool lnan = std::isnan(l), rnan = std::isnan(r);
        if (!std::isnan(result) && !lnan && !rnan) return Literal(result);
        if (!lnan && !rnan) return Literal((int32_t)0x7fc00000).castToF32();
        return Literal(lnan ? l : r).castToI32().or_(Literal(0xc00000)).castToF32();
      }
      case WasmType::f64: {
        auto l = getf64(), r = other.getf64();
        if (l == r && l == 0) return Literal(std::signbit(l) ? l : r);
        auto result = std::min(l, r);
        bool lnan = std::isnan(l), rnan = std::isnan(r);
        if (!std::isnan(result) && !lnan && !rnan) return Literal(result);
        if (!lnan && !rnan) return Literal((int64_t)0x7ff8000000000000LL).castToF64();
        return Literal(lnan ? l : r).castToI64().or_(Literal(int64_t(0x8000000000000LL))).castToF64();
      }
      default: WASM_UNREACHABLE();
    }
  }
  Literal max(const Literal& other) const {
    switch (type) {
      case WasmType::f32: {
        auto l = getf32(), r = other.getf32();
        if (l == r && l == 0) return Literal(std::signbit(l) ? r : l);
        auto result = std::max(l, r);
        bool lnan = std::isnan(l), rnan = std::isnan(r);
        if (!std::isnan(result) && !lnan && !rnan) return Literal(result);
        if (!lnan && !rnan) return Literal((int32_t)0x7fc00000).castToF32();
        return Literal(lnan ? l : r).castToI32().or_(Literal(0xc00000)).castToF32();
      }
      case WasmType::f64: {
        auto l = getf64(), r = other.getf64();
        if (l == r && l == 0) return Literal(std::signbit(l) ? r : l);
        auto result = std::max(l, r);
        bool lnan = std::isnan(l), rnan = std::isnan(r);
        if (!std::isnan(result) && !lnan && !rnan) return Literal(result);
        if (!lnan && !rnan) return Literal((int64_t)0x7ff8000000000000LL).castToF64();
        return Literal(lnan ? l : r).castToI64().or_(Literal(int64_t(0x8000000000000LL))).castToF64();
      }
      default: WASM_UNREACHABLE();
    }
  }
  Literal copysign(const Literal& other) const {
    // operate on bits directly, to avoid signalling bit being set on a float
    switch (type) {
      case WasmType::f32: return Literal((i32 & 0x7fffffff) | (other.i32 & 0x80000000)).castToF32(); break;
      case WasmType::f64: return Literal((i64 & 0x7fffffffffffffffUL) | (other.i64 & 0x8000000000000000UL)).castToF64(); break;
      default: WASM_UNREACHABLE();
    }
  }
};

// Operators

enum UnaryOp {
  ClzInt32, ClzInt64, CtzInt32, CtzInt64, PopcntInt32, PopcntInt64, // int
  NegFloat32, NegFloat64, AbsFloat32, AbsFloat64, CeilFloat32, CeilFloat64, FloorFloat32, FloorFloat64, TruncFloat32, TruncFloat64, NearestFloat32, NearestFloat64, SqrtFloat32, SqrtFloat64, // float
  // relational
  EqZInt32, EqZInt64,
  // conversions
  ExtendSInt32, ExtendUInt32, // extend i32 to i64
  WrapInt64, // i64 to i32
  TruncSFloat32ToInt32, TruncSFloat32ToInt64, TruncUFloat32ToInt32, TruncUFloat32ToInt64, TruncSFloat64ToInt32, TruncSFloat64ToInt64, TruncUFloat64ToInt32, TruncUFloat64ToInt64, // float to int
  ReinterpretFloat32, ReinterpretFloat64, // reintepret bits to int
  ConvertSInt32ToFloat32, ConvertSInt32ToFloat64, ConvertUInt32ToFloat32, ConvertUInt32ToFloat64, ConvertSInt64ToFloat32, ConvertSInt64ToFloat64, ConvertUInt64ToFloat32, ConvertUInt64ToFloat64, // int to float
  PromoteFloat32, // f32 to f64
  DemoteFloat64, // f64 to f32
  ReinterpretInt32, ReinterpretInt64 // reinterpret bits to float
};

enum BinaryOp {
  AddInt32, SubInt32, MulInt32, // int or float
  DivSInt32, DivUInt32, RemSInt32, RemUInt32, AndInt32, OrInt32, XorInt32, ShlInt32, ShrUInt32, ShrSInt32, RotLInt32, RotRInt32, // int
  // relational ops
  EqInt32, NeInt32, // int or float
  LtSInt32, LtUInt32, LeSInt32, LeUInt32, GtSInt32, GtUInt32, GeSInt32, GeUInt32, // int

  AddInt64, SubInt64, MulInt64, // int or float
  DivSInt64, DivUInt64, RemSInt64, RemUInt64, AndInt64, OrInt64, XorInt64, ShlInt64, ShrUInt64, ShrSInt64, RotLInt64, RotRInt64, // int
  // relational ops
  EqInt64, NeInt64, // int or float
  LtSInt64, LtUInt64, LeSInt64, LeUInt64, GtSInt64, GtUInt64, GeSInt64, GeUInt64, // int

  AddFloat32, SubFloat32, MulFloat32, // int or float
  DivFloat32, CopySignFloat32, MinFloat32, MaxFloat32, // float
  // relational ops
  EqFloat32, NeFloat32, // int or float
  LtFloat32, LeFloat32, GtFloat32, GeFloat32, // float

  AddFloat64, SubFloat64, MulFloat64, // int or float
  DivFloat64, CopySignFloat64, MinFloat64, MaxFloat64, // float
  // relational ops
  EqFloat64, NeFloat64, // int or float
  LtFloat64, LeFloat64, GtFloat64, GeFloat64, // float
};

enum HostOp {
  PageSize, CurrentMemory, GrowMemory, HasFeature
};

//
// Expressions
//
// Note that little is provided in terms of constructors for these. The rationale
// is that writing  new Something(a, b, c, d, e)  is not the clearest, and it would
// be better to write   new Something(name=a, leftOperand=b...  etc., but C++
// lacks named operands, so in asm2wasm etc. you will see things like
//   auto x = new Something();
//   x->name = a;
//   x->leftOperand = b;
//   ..
// which is less compact but less ambiguous. See wasm-builder.h for a more
// friendly API for building nodes.
//
// Most nodes have no need of internal allocation, and when arena-allocated
// they drop the provided arena on the floor. You can create random instances
// of those that are not in an arena without issue. However, the nodes that
// have internal allocation will need an allocator provided to them in order
// to be constructed.

class Expression {
public:
  enum Id {
    InvalidId = 0,
    BlockId,
    IfId,
    LoopId,
    BreakId,
    SwitchId,
    CallId,
    CallImportId,
    CallIndirectId,
    GetLocalId,
    SetLocalId,
    LoadId,
    StoreId,
    ConstId,
    UnaryId,
    BinaryId,
    SelectId,
    ReturnId,
    HostId,
    NopId,
    UnreachableId,
    NumExpressionIds
  };
  Id _id;

  WasmType type; // the type of the expression: its *output*, not necessarily its input(s)

  Expression(Id id) : _id(id), type(none) {}

  void finalize() {}

  template<class T>
  bool is() {
    return int(_id) == int(T::SpecificId);
  }

  template<class T>
  T* dynCast() {
    return int(_id) == int(T::SpecificId) ? (T*)this : nullptr;
  }

  template<class T>
  T* cast() {
    assert(int(_id) == int(T::SpecificId));
    return (T*)this;
  }
};

inline const char *getExpressionName(Expression *curr) {
  switch (curr->_id) {
    case Expression::Id::InvalidId: abort();
    case Expression::Id::BlockId: return "block";
    case Expression::Id::IfId: return "if";
    case Expression::Id::LoopId: return "loop";
    case Expression::Id::BreakId: return "break";
    case Expression::Id::SwitchId: return "switch";
    case Expression::Id::CallId: return "call";
    case Expression::Id::CallImportId: return "call_import";
    case Expression::Id::CallIndirectId: return "call_indirect";
    case Expression::Id::GetLocalId: return "get_local";
    case Expression::Id::SetLocalId: return "set_local";
    case Expression::Id::LoadId: return "load";
    case Expression::Id::StoreId: return "store";
    case Expression::Id::ConstId: return "const";
    case Expression::Id::UnaryId: return "unary";
    case Expression::Id::BinaryId: return "binary";
    case Expression::Id::SelectId: return "select";
    case Expression::Id::ReturnId: return "return";
    case Expression::Id::HostId: return "host";
    case Expression::Id::NopId: return "nop";
    case Expression::Id::UnreachableId: return "unreachable";
    default: WASM_UNREACHABLE();
  }
}

typedef ArenaVector<Expression*> ExpressionList;

template<Expression::Id SID>
class SpecificExpression : public Expression {
public:
  enum {
    SpecificId = SID // compile-time access to the type for the class
  };

  SpecificExpression() : Expression(SID) {}
};

class Nop : public SpecificExpression<Expression::NopId> {
public:
  Nop() {}
  Nop(MixedArena& allocator) {}
};

class Block : public SpecificExpression<Expression::BlockId> {
public:
  Block(MixedArena& allocator) : list(allocator) {}

  Name name;
  ExpressionList list;

  // set the type of a block if you already know it
  void finalize(WasmType type_) {
    type = type_;
  }

  // set the type of a block based on its contents. this scans the block, so it is not fast
  void finalize();
};

class If : public SpecificExpression<Expression::IfId> {
public:
  If() : ifFalse(nullptr) {}
  If(MixedArena& allocator) : If() {}

  Expression *condition, *ifTrue, *ifFalse;

  void finalize() {
    if (ifFalse) {
      type = getReachableWasmType(ifTrue->type, ifFalse->type);
    }
  }
};

class Loop : public SpecificExpression<Expression::LoopId> {
public:
  Loop() {}
  Loop(MixedArena& allocator) {}

  Name out, in;
  Expression *body;

  // set the type of a loop if you already know it
  void finalize(WasmType type_) {
    type = type_;
  }

  // set the type of a loop based on its contents. this scans the loop, so it is not fast
  void finalize();
};

class Break : public SpecificExpression<Expression::BreakId> {
public:
  Break() : value(nullptr), condition(nullptr) {}
  Break(MixedArena& allocator) : Break() {
    type = unreachable;
  }

  Name name;
  Expression *value;
  Expression *condition;

  void finalize() {
    if (condition) {
      type = none;
    }
  }
};

class Switch : public SpecificExpression<Expression::SwitchId> {
public:
  Switch(MixedArena& allocator) : targets(allocator), condition(nullptr), value(nullptr) {
    type = unreachable;
  }

  ArenaVector<Name> targets;
  Name default_;
  Expression *condition;
  Expression *value;
};

class Call : public SpecificExpression<Expression::CallId> {
public:
  Call(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name target;
};

class CallImport : public SpecificExpression<Expression::CallImportId> {
public:
  CallImport(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name target;
};

class FunctionType {
public:
  Name name;
  WasmType result;
  std::vector<WasmType> params;

  FunctionType() : result(none) {}

  bool operator==(FunctionType& b) {
    if (name != b.name) return false; // XXX
    if (result != b.result) return false;
    if (params.size() != b.params.size()) return false;
    for (size_t i = 0; i < params.size(); i++) {
      if (params[i] != b.params[i]) return false;
    }
    return true;
  }
  bool operator!=(FunctionType& b) {
    return !(*this == b);
  }
};

class CallIndirect : public SpecificExpression<Expression::CallIndirectId> {
public:
  CallIndirect(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  FunctionType *fullType;
  Expression *target;

  void finalize() {
    type = fullType->result;
  }
};

class GetLocal : public SpecificExpression<Expression::GetLocalId> {
public:
  GetLocal() {}
  GetLocal(MixedArena& allocator) {}

  Index index;
};

class SetLocal : public SpecificExpression<Expression::SetLocalId> {
public:
  SetLocal() {}
  SetLocal(MixedArena& allocator) {}

  Index index;
  Expression *value;

  void finalize() {
    type = value->type;
  }
};

class Load : public SpecificExpression<Expression::LoadId> {
public:
  Load() {}
  Load(MixedArena& allocator) {}

  uint8_t bytes;
  bool signed_;
  Address offset;
  Address align;
  Expression *ptr;

  // type must be set during creation, cannot be inferred
};

class Store : public SpecificExpression<Expression::StoreId> {
public:
  Store() {}
  Store(MixedArena& allocator) {}

  uint8_t bytes;
  Address offset;
  Address align;
  Expression *ptr, *value;

  void finalize() {
    type = value->type;
  }
};

class Const : public SpecificExpression<Expression::ConstId> {
public:
  Const() {}
  Const(MixedArena& allocator) {}

  Literal value;

  Const* set(Literal value_) {
    value = value_;
    type = value.type;
    return this;
  }
};

class Unary : public SpecificExpression<Expression::UnaryId> {
public:
  Unary() {}
  Unary(MixedArena& allocator) {}

  UnaryOp op;
  Expression *value;

  bool isRelational() { return op == EqZInt32 || op == EqZInt64; }

  void finalize() {
    switch (op) {
      case ClzInt32:
      case CtzInt32:
      case PopcntInt32:
      case NegFloat32:
      case AbsFloat32:
      case CeilFloat32:
      case FloorFloat32:
      case TruncFloat32:
      case NearestFloat32:
      case SqrtFloat32:
      case ClzInt64:
      case CtzInt64:
      case PopcntInt64:
      case NegFloat64:
      case AbsFloat64:
      case CeilFloat64:
      case FloorFloat64:
      case TruncFloat64:
      case NearestFloat64:
      case SqrtFloat64: type = value->type; break;
      case EqZInt32:
      case EqZInt64: type = i32; break;
      case ExtendSInt32: case ExtendUInt32: type = i64; break;
      case WrapInt64: type = i32; break;
      case PromoteFloat32: type = f64; break;
      case DemoteFloat64: type = f32; break;
      case TruncSFloat32ToInt32:
      case TruncUFloat32ToInt32:
      case TruncSFloat64ToInt32:
      case TruncUFloat64ToInt32:
      case ReinterpretFloat32: type = i32; break;
      case TruncSFloat32ToInt64:
      case TruncUFloat32ToInt64:
      case TruncSFloat64ToInt64:
      case TruncUFloat64ToInt64:
      case ReinterpretFloat64: type = i64; break;
      case ReinterpretInt32:
      case ConvertSInt32ToFloat32:
      case ConvertUInt32ToFloat32:
      case ConvertSInt64ToFloat32:
      case ConvertUInt64ToFloat32: type = f32; break;
      case ReinterpretInt64:
      case ConvertSInt32ToFloat64:
      case ConvertUInt32ToFloat64:
      case ConvertSInt64ToFloat64:
      case ConvertUInt64ToFloat64: type = f64; break;
      default: std::cerr << "waka " << op << '\n'; WASM_UNREACHABLE();
    }
  }
};

class Binary : public SpecificExpression<Expression::BinaryId> {
public:
  Binary() {}
  Binary(MixedArena& allocator) {}

  BinaryOp op;
  Expression *left, *right;

  // the type is always the type of the operands,
  // except for relationals

  bool isRelational() {
    switch (op) {
      case EqFloat64:
      case NeFloat64:
      case LtFloat64: 
      case LeFloat64: 
      case GtFloat64: 
      case GeFloat64:
      case EqInt32: 
      case NeInt32:
      case LtSInt32: 
      case LtUInt32: 
      case LeSInt32: 
      case LeUInt32: 
      case GtSInt32: 
      case GtUInt32: 
      case GeSInt32: 
      case GeUInt32:
      case EqInt64: 
      case NeInt64:
      case LtSInt64: 
      case LtUInt64: 
      case LeSInt64: 
      case LeUInt64: 
      case GtSInt64: 
      case GtUInt64: 
      case GeSInt64: 
      case GeUInt64:
      case EqFloat32: 
      case NeFloat32:
      case LtFloat32: 
      case LeFloat32: 
      case GtFloat32: 
      case GeFloat32: return true;
      default: return false;
    }
  }

  void finalize() {
    if (isRelational()) {
      type = i32;
    } else {
      type = getReachableWasmType(left->type, right->type);
    }
  }
};

class Select : public SpecificExpression<Expression::SelectId> {
public:
  Select() {}
  Select(MixedArena& allocator) {}

  Expression *ifTrue, *ifFalse, *condition;

  void finalize() {
    type = getReachableWasmType(ifTrue->type, ifFalse->type);
  }
};

class Return : public SpecificExpression<Expression::ReturnId> {
public:
  Return() : value(nullptr) {
    type = unreachable;
  }
  Return(MixedArena& allocator) : Return() {}

  Expression *value;
};

class Host : public SpecificExpression<Expression::HostId> {
public:
  Host(MixedArena& allocator) : operands(allocator) {}

  HostOp op;
  Name nameOperand;
  ExpressionList operands;

  void finalize() {
    switch (op) {
      case PageSize: case CurrentMemory: case HasFeature: {
        type = i32;
        break;
      }
      case GrowMemory: {
        type = i32;
        break;
      }
      default: abort();
    }
  }
};

class Unreachable : public SpecificExpression<Expression::UnreachableId> {
public:
  Unreachable() {}
  Unreachable(MixedArena& allocator) {
    type = unreachable;
  }
};

// Globals

class Function {
public:
  Name name;
  WasmType result;
  std::vector<WasmType> params; // function locals are
  std::vector<WasmType> vars;   // params plus vars
  Name type; // if null, it is implicit in params and result
  Expression *body;

  // local names. these are optional.
  std::vector<Name> localNames;
  std::map<Name, Index> localIndices;

  Function() : result(none) {}

  size_t getNumParams() {
    return params.size();
  }
  size_t getNumVars() {
    return vars.size();
  }
  size_t getNumLocals() {
    return params.size() + vars.size();
  }

  bool isParam(Index index) {
    return index < params.size();
  }
  bool isVar(Index index) {
    return index >= params.size();
  }

  Name getLocalName(Index index) {
    assert(index < localNames.size() && localNames[index].is());
    return localNames[index];
  }
  Name tryLocalName(Index index) {
    if (index < localNames.size() && localNames[index].is()) {
      return localNames[index];
    }
    // this is an unnamed local
    return Name();
  }
  Index getLocalIndex(Name name) {
    assert(localIndices.count(name) > 0);
    return localIndices[name];
  }
  Index getVarIndexBase() {
    return params.size();
  }
  WasmType getLocalType(Index index) {
    if (isParam(index)) {
      return params[index];
    } else if (isVar(index)) {
      return vars[index - getVarIndexBase()];
    } else {
      WASM_UNREACHABLE();
    }
  }
};

class Import {
public:
  Import() : type(nullptr) {}

  Name name, module, base; // name = module.base
  FunctionType* type;
};

class Export {
public:
  Name name;  // exported name
  Name value; // internal name
};

class Table {
public:
  std::vector<Name> names;
};

class Memory {
public:
  static const Address::address_t kPageSize = 64 * 1024;
  static const Address::address_t kMaxSize = ~Address::address_t(0) / kPageSize;
  static const Address::address_t kPageMask = ~(kPageSize - 1);
  struct Segment {
    Address offset;
    std::vector<char> data; // TODO: optimize
    Segment() {}
    Segment(Address offset, const char *init, Address size) : offset(offset) {
      data.resize(size);
      std::copy_n(init, size, data.begin());
    }
    Segment(Address offset, std::vector<char>& init) : offset(offset) {
      data.swap(init);
    }
  };

  Address initial, max; // sizes are in pages
  std::vector<Segment> segments;
  Name exportName;

  Memory() : initial(0), max(kMaxSize) {}
};

class Module {
public:
  // wasm contents (generally you shouldn't access these from outside, except maybe for iterating; use add*() and the get() functions)
  std::vector<std::unique_ptr<FunctionType>> functionTypes;
  std::vector<std::unique_ptr<Import>> imports;
  std::vector<std::unique_ptr<Export>> exports;
  std::vector<std::unique_ptr<Function>> functions;

  Table table;
  Memory memory;
  Name start;

  MixedArena allocator;

private:
  // TODO: add a build option where Names are just indices, and then these methods are not needed
  std::map<Name, FunctionType*> functionTypesMap;
  std::map<Name, Import*> importsMap;
  std::map<Name, Export*> exportsMap;
  std::map<Name, Function*> functionsMap;

public:
  Module() : functionTypeIndex(0), importIndex(0), exportIndex(0), functionIndex(0) {}

  FunctionType* getFunctionType(size_t i) { assert(i < functionTypes.size()); return functionTypes[i].get(); }
  Import* getImport(size_t i) { assert(i < imports.size()); return imports[i].get(); }
  Export* getExport(size_t i) { assert(i < exports.size()); return exports[i].get(); }
  Function* getFunction(size_t i) { assert(i < functions.size()); return functions[i].get(); }

  FunctionType* getFunctionType(Name name) { assert(functionTypesMap[name]); return functionTypesMap[name]; }
  Import* getImport(Name name) { assert(importsMap[name]); return importsMap[name]; }
  Export* getExport(Name name) { assert(exportsMap[name]); return exportsMap[name]; }
  Function* getFunction(Name name) { assert(functionsMap[name]); return functionsMap[name]; }

  FunctionType* checkFunctionType(Name name) { if (functionTypesMap.find(name) == functionTypesMap.end()) return nullptr; return functionTypesMap[name]; }
  Import* checkImport(Name name) { if (importsMap.find(name) == importsMap.end()) return nullptr; return importsMap[name]; }
  Export* checkExport(Name name) { if (exportsMap.find(name) == exportsMap.end()) return nullptr; return exportsMap[name]; }
  Function* checkFunction(Name name) { if (functionsMap.find(name) == functionsMap.end()) return nullptr; return functionsMap[name]; }

  void addFunctionType(FunctionType* curr) {
    Name numericName = Name::fromInt(functionTypeIndex); // TODO: remove all these, assert on names already existing, do numeric stuff in wasm-s-parser etc.
    if (curr->name.isNull()) {
      curr->name = numericName;
    }
    functionTypes.push_back(std::unique_ptr<FunctionType>(curr));
    functionTypesMap[curr->name] = curr;
    functionTypesMap[numericName] = curr;
    functionTypeIndex++;
  }
  void addImport(Import* curr) {
    Name numericName = Name::fromInt(importIndex);
    if (curr->name.isNull()) {
      curr->name = numericName;
    }
    imports.push_back(std::unique_ptr<Import>(curr));
    importsMap[curr->name] = curr;
    importsMap[numericName] = curr;
    importIndex++;
  }
  void addExport(Export* curr) {
    Name numericName = Name::fromInt(exportIndex);
    if (curr->name.isNull()) {
      curr->name = numericName;
    }
    exports.push_back(std::unique_ptr<Export>(curr));
    exportsMap[curr->name] = curr;
    exportsMap[numericName] = curr;
    exportIndex++;
  }
  void addFunction(Function* curr) {
    Name numericName = Name::fromInt(functionIndex);
    if (curr->name.isNull()) {
      curr->name = numericName;
    }
    functions.push_back(std::unique_ptr<Function>(curr));
    functionsMap[curr->name] = curr;
    functionsMap[numericName] = curr;
    functionIndex++;
  }
  void addStart(const Name &s) {
    start = s;
  }

  void removeImport(Name name) {
    for (size_t i = 0; i < imports.size(); i++) {
      if (imports[i]->name == name) {
        imports.erase(imports.begin() + i);
        break;
      }
    }
    importsMap.erase(name);
  }

private:
  size_t functionTypeIndex, importIndex, exportIndex, functionIndex;
};

} // namespace wasm

namespace std {
template<> struct hash<wasm::Address> {
  size_t operator()(const wasm::Address a) const {
    return std::hash<wasm::Address::address_t>()(a.addr);
  }
};
}

#endif // wasm_wasm_h
