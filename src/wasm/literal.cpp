/*
 * Copyright 2016 WebAssembly Community Group participants
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

#include "literal.h"

#include <cassert>
#include <cmath>

#include "emscripten-optimizer/simple_ast.h"
#include "pretty_printing.h"
#include "support/bits.h"
#include "ir/bits.h"


namespace wasm {

Literal Literal::castToF32() {
  assert(type == Type::i32);
  Literal ret(i32);
  ret.type = Type::f32;
  return ret;
}

Literal Literal::castToF64() {
  assert(type == Type::i64);
  Literal ret(i64);
  ret.type = Type::f64;
  return ret;
}

Literal Literal::castToI32() {
  assert(type == Type::f32);
  Literal ret(i32);
  ret.type = Type::i32;
  return ret;
}

Literal Literal::castToI64() {
  assert(type == Type::f64);
  Literal ret(i64);
  ret.type = Type::i64;
  return ret;
}

int64_t Literal::getInteger() const {
  switch (type) {
    case Type::i32: return i32;
    case Type::i64: return i64;
    default: abort();
  }
}

double Literal::getFloat() const {
  switch (type) {
    case Type::f32: return getf32();
    case Type::f64: return getf64();
    default: abort();
  }
}

int64_t Literal::getBits() const {
  switch (type) {
    case Type::i32: case Type::f32: return i32;
    case Type::i64: case Type::f64: return i64;
    default: abort();
  }
}

bool Literal::operator==(const Literal& other) const {
  if (type != other.type) return false;
  if (type == none) return true;
  return getBits() == other.getBits();
}

bool Literal::operator!=(const Literal& other) const {
  return !(*this == other);
}

uint32_t Literal::NaNPayload(float f) {
  assert(std::isnan(f) && "expected a NaN");
  // SEEEEEEE EFFFFFFF FFFFFFFF FFFFFFFF
  // NaN has all-one exponent and non-zero fraction.
  return ~0xff800000u & bit_cast<uint32_t>(f);
}

uint64_t Literal::NaNPayload(double f) {
  assert(std::isnan(f) && "expected a NaN");
  // SEEEEEEE EEEEFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF
  // NaN has all-one exponent and non-zero fraction.
  return ~0xfff0000000000000ull & bit_cast<uint64_t>(f);
}

float Literal::setQuietNaN(float f) {
  assert(std::isnan(f) && "expected a NaN");
  // An SNaN is a NaN with the most significant fraction bit clear.
  return bit_cast<float>(0x00400000u | bit_cast<uint32_t>(f));
}

double Literal::setQuietNaN(double f) {
  assert(std::isnan(f) && "expected a NaN");
  // An SNaN is a NaN with the most significant fraction bit clear.
  return bit_cast<double>(0x0008000000000000ull | bit_cast<uint64_t>(f));
}

void Literal::printFloat(std::ostream &o, float f) {
  if (std::isnan(f)) {
    const char* sign = std::signbit(f) ? "-" : "";
    o << sign << "nan";
    if (uint32_t payload = NaNPayload(f)) {
      o << ":0x" << std::hex << payload << std::dec;
    }
    return;
  }
  printDouble(o, f);
}

void Literal::printDouble(std::ostream& o, double d) {
  if (d == 0 && std::signbit(d)) {
    o << "-0";
    return;
  }
  if (std::isnan(d)) {
    const char* sign = std::signbit(d) ? "-" : "";
    o << sign << "nan";
    if (uint64_t payload = NaNPayload(d)) {
      o << ":0x" << std::hex << payload << std::dec;
    }
    return;
  }
  if (!std::isfinite(d)) {
    o << (std::signbit(d) ? "-inf" : "inf");
    return;
  }
  const char* text = cashew::JSPrinter::numToString(d);
  // spec interpreter hates floats starting with '.'
  if (text[0] == '.') {
    o << '0';
  } else if (text[0] == '-' && text[1] == '.') {
    o << "-0";
    text++;
  }
  o << text;
}

std::ostream& operator<<(std::ostream& o, Literal literal) {
  prepareMinorColor(o) << printType(literal.type) << ".const ";
  switch (literal.type) {
    case none: o << "?"; break;
    case Type::i32: o << literal.i32; break;
    case Type::i64: o << literal.i64; break;
    case Type::f32: literal.printFloat(o, literal.getf32()); break;
    case Type::f64: literal.printDouble(o, literal.getf64()); break;
    default: WASM_UNREACHABLE();
  }
  restoreNormalColor(o);
  return o;
}

Literal Literal::countLeadingZeroes() const {
  if (type == Type::i32) return Literal((int32_t)CountLeadingZeroes(i32));
  if (type == Type::i64) return Literal((int64_t)CountLeadingZeroes(i64));
  WASM_UNREACHABLE();
}

Literal Literal::countTrailingZeroes() const {
  if (type == Type::i32) return Literal((int32_t)CountTrailingZeroes(i32));
  if (type == Type::i64) return Literal((int64_t)CountTrailingZeroes(i64));
  WASM_UNREACHABLE();
}

Literal Literal::popCount() const {
  if (type == Type::i32) return Literal((int32_t)PopCount(i32));
  if (type == Type::i64) return Literal((int64_t)PopCount(i64));
  WASM_UNREACHABLE();
}

Literal Literal::extendToSI64() const {
  assert(type == Type::i32);
  return Literal((int64_t)i32);
}

Literal Literal::extendToUI64() const {
  assert(type == Type::i32);
  return Literal((uint64_t)(uint32_t)i32);
}

Literal Literal::extendToF64() const {
  assert(type == Type::f32);
  return Literal(double(getf32()));
}

Literal Literal::extendS8() const {
  if (type == Type::i32) return Literal(int32_t(int8_t(geti32() & 0xFF)));
  if (type == Type::i64) return Literal(int64_t(int8_t(geti64() & 0xFF)));
  WASM_UNREACHABLE();
}

Literal Literal::extendS16() const {
  if (type == Type::i32) return Literal(int32_t(int16_t(geti32() & 0xFFFF)));
  if (type == Type::i64) return Literal(int64_t(int16_t(geti64() & 0xFFFF)));
  WASM_UNREACHABLE();
}

Literal Literal::extendS32() const {
  if (type == Type::i64) return Literal(int64_t(int32_t(geti64() & 0xFFFFFFFF)));
  WASM_UNREACHABLE();
}

Literal Literal::truncateToI32() const {
  assert(type == Type::i64);
  return Literal((int32_t)i64);
}

Literal Literal::truncateToF32() const {
  assert(type == Type::f64);
  return Literal(float(getf64()));
}

Literal Literal::convertSToF32() const {
  if (type == Type::i32) return Literal(float(i32));
  if (type == Type::i64) return Literal(float(i64));
  WASM_UNREACHABLE();
}

Literal Literal::convertUToF32() const {
  if (type == Type::i32) return Literal(float(uint32_t(i32)));
  if (type == Type::i64) return Literal(float(uint64_t(i64)));
  WASM_UNREACHABLE();
}

Literal Literal::convertSToF64() const {
  if (type == Type::i32) return Literal(double(i32));
  if (type == Type::i64) return Literal(double(i64));
  WASM_UNREACHABLE();
}

Literal Literal::convertUToF64() const {
  if (type == Type::i32) return Literal(double(uint32_t(i32)));
  if (type == Type::i64) return Literal(double(uint64_t(i64)));
  WASM_UNREACHABLE();
}

Literal Literal::eqz() const {
  switch (type) {
    case Type::i32: return eq(Literal(int32_t(0)));
    case Type::i64: return eq(Literal(int64_t(0)));
    case Type::f32: return eq(Literal(float(0)));
    case Type::f64: return eq(Literal(double(0)));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::neg() const {
  switch (type) {
    case Type::i32: return Literal(-uint32_t(i32));
    case Type::i64: return Literal(-uint64_t(i64));
    case Type::f32: return Literal(i32 ^ 0x80000000).castToF32();
    case Type::f64: return Literal(int64_t(i64 ^ 0x8000000000000000ULL)).castToF64();
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::abs() const {
  switch (type) {
    case Type::i32: return Literal(i32 & 0x7fffffff);
    case Type::i64: return Literal(int64_t(i64 & 0x7fffffffffffffffULL));
    case Type::f32: return Literal(i32 & 0x7fffffff).castToF32();
    case Type::f64: return Literal(int64_t(i64 & 0x7fffffffffffffffULL)).castToF64();
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ceil() const {
  switch (type) {
    case Type::f32: return Literal(std::ceil(getf32()));
    case Type::f64: return Literal(std::ceil(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::floor() const {
  switch (type) {
    case Type::f32: return Literal(std::floor(getf32()));
    case Type::f64: return Literal(std::floor(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::trunc() const {
  switch (type) {
    case Type::f32: return Literal(std::trunc(getf32()));
    case Type::f64: return Literal(std::trunc(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::nearbyint() const {
  switch (type) {
    case Type::f32: return Literal(std::nearbyint(getf32()));
    case Type::f64: return Literal(std::nearbyint(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::sqrt() const {
  switch (type) {
    case Type::f32: return Literal(std::sqrt(getf32()));
    case Type::f64: return Literal(std::sqrt(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::demote() const {
  auto f64 = getf64();
  if (std::isnan(f64)) return Literal(float(f64));
  if (std::isinf(f64)) return Literal(float(f64));
  // when close to the limit, but still truncatable to a valid value, do that
  // see https://github.com/WebAssembly/sexpr-wasm-prototype/blob/2d375e8d502327e814d62a08f22da9d9b6b675dc/src/wasm-interpreter.c#L247
  uint64_t bits = reinterpreti64();
  if (bits > 0x47efffffe0000000ULL && bits < 0x47effffff0000000ULL) return Literal(std::numeric_limits<float>::max());
  if (bits > 0xc7efffffe0000000ULL && bits < 0xc7effffff0000000ULL) return Literal(-std::numeric_limits<float>::max());
  // when we must convert to infinity, do that
  if (f64 < -std::numeric_limits<float>::max()) return Literal(-std::numeric_limits<float>::infinity());
  if (f64 > std::numeric_limits<float>::max()) return Literal(std::numeric_limits<float>::infinity());
  return truncateToF32();
}

Literal Literal::add(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) + uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) + uint64_t(other.i64));
    case Type::f32: return Literal(getf32() + other.getf32());
    case Type::f64: return Literal(getf64() + other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::sub(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) - uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) - uint64_t(other.i64));
    case Type::f32: return Literal(getf32() - other.getf32());
    case Type::f64: return Literal(getf64() - other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::mul(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) * uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) * uint64_t(other.i64));
    case Type::f32: return Literal(getf32() * other.getf32());
    case Type::f64: return Literal(getf64() * other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::div(const Literal& other) const {
  switch (type) {
    case Type::f32: {
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
    case Type::f64: {
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

Literal Literal::divS(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 / other.i32);
    case Type::i64: return Literal(i64 / other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::divU(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) / uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) / uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::remS(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 % other.i32);
    case Type::i64: return Literal(i64 % other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::remU(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) % uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) % uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::and_(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 & other.i32);
    case Type::i64: return Literal(i64 & other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::or_(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 | other.i32);
    case Type::i64: return Literal(i64 | other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::xor_(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 ^ other.i32);
    case Type::i64: return Literal(i64 ^ other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::shl(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) << Bits::getEffectiveShifts(other.i32, Type::i32));
    case Type::i64: return Literal(uint64_t(i64) << Bits::getEffectiveShifts(other.i64, Type::i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::shrS(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 >> Bits::getEffectiveShifts(other.i32, Type::i32));
    case Type::i64: return Literal(i64 >> Bits::getEffectiveShifts(other.i64, Type::i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::shrU(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) >> Bits::getEffectiveShifts(other.i32, Type::i32));
    case Type::i64: return Literal(uint64_t(i64) >> Bits::getEffectiveShifts(other.i64, Type::i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::rotL(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(RotateLeft(uint32_t(i32), uint32_t(other.i32)));
    case Type::i64: return Literal(RotateLeft(uint64_t(i64), uint64_t(other.i64)));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::rotR(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(RotateRight(uint32_t(i32), uint32_t(other.i32)));
    case Type::i64: return Literal(RotateRight(uint64_t(i64), uint64_t(other.i64)));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::eq(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 == other.i32);
    case Type::i64: return Literal(i64 == other.i64);
    case Type::f32: return Literal(getf32() == other.getf32());
    case Type::f64: return Literal(getf64() == other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ne(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 != other.i32);
    case Type::i64: return Literal(i64 != other.i64);
    case Type::f32: return Literal(getf32() != other.getf32());
    case Type::f64: return Literal(getf64() != other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ltS(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 < other.i32);
    case Type::i64: return Literal(i64 < other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ltU(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) < uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) < uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::lt(const Literal& other) const {
  switch (type) {
    case Type::f32: return Literal(getf32() < other.getf32());
    case Type::f64: return Literal(getf64() < other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::leS(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 <= other.i32);
    case Type::i64: return Literal(i64 <= other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::leU(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) <= uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) <= uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::le(const Literal& other) const {
  switch (type) {
    case Type::f32: return Literal(getf32() <= other.getf32());
    case Type::f64: return Literal(getf64() <= other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::gtS(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 > other.i32);
    case Type::i64: return Literal(i64 > other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::gtU(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) > uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) > uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::gt(const Literal& other) const {
  switch (type) {
    case Type::f32: return Literal(getf32() > other.getf32());
    case Type::f64: return Literal(getf64() > other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::geS(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(i32 >= other.i32);
    case Type::i64: return Literal(i64 >= other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::geU(const Literal& other) const {
  switch (type) {
    case Type::i32: return Literal(uint32_t(i32) >= uint32_t(other.i32));
    case Type::i64: return Literal(uint64_t(i64) >= uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ge(const Literal& other) const {
  switch (type) {
    case Type::f32: return Literal(getf32() >= other.getf32());
    case Type::f64: return Literal(getf64() >= other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::min(const Literal& other) const {
  switch (type) {
    case Type::f32: {
      auto l = getf32(), r = other.getf32();
      if (l == r && l == 0) return Literal(std::signbit(l) ? l : r);
      auto result = std::min(l, r);
      bool lnan = std::isnan(l), rnan = std::isnan(r);
      if (!std::isnan(result) && !lnan && !rnan) return Literal(result);
      if (!lnan && !rnan) return Literal((int32_t)0x7fc00000).castToF32();
      return Literal(lnan ? l : r).castToI32().or_(Literal(0xc00000)).castToF32();
    }
    case Type::f64: {
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

Literal Literal::max(const Literal& other) const {
  switch (type) {
    case Type::f32: {
      auto l = getf32(), r = other.getf32();
      if (l == r && l == 0) return Literal(std::signbit(l) ? r : l);
      auto result = std::max(l, r);
      bool lnan = std::isnan(l), rnan = std::isnan(r);
      if (!std::isnan(result) && !lnan && !rnan) return Literal(result);
      if (!lnan && !rnan) return Literal((int32_t)0x7fc00000).castToF32();
      return Literal(lnan ? l : r).castToI32().or_(Literal(0xc00000)).castToF32();
    }
    case Type::f64: {
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

Literal Literal::copysign(const Literal& other) const {
  // operate on bits directly, to avoid signalling bit being set on a float
  switch (type) {
    case Type::f32: return Literal((i32 & 0x7fffffff) | (other.i32 & 0x80000000)).castToF32(); break;
    case Type::f64: return Literal((i64 & 0x7fffffffffffffffUL) | (other.i64 & 0x8000000000000000UL)).castToF64(); break;
    default: WASM_UNREACHABLE();
  }
}

} // namespace wasm
