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

#include "wasm.h"
#include "wasm-traversal.h"
#include "ast_utils.h"

namespace wasm {

// shared constants

Name WASM("wasm"),
     RETURN_FLOW("*return:)*");

const char* printWasmType(WasmType type) {
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

unsigned getWasmTypeSize(WasmType type) {
  switch (type) {
    case WasmType::none: abort();
    case WasmType::i32: return 4;
    case WasmType::i64: return 8;
    case WasmType::f32: return 4;
    case WasmType::f64: return 8;
    default: WASM_UNREACHABLE();
  }
}

bool isWasmTypeFloat(WasmType type) {
  switch (type) {
    case f32:
    case f64: return true;
    default: return false;
  }
}

WasmType getWasmType(unsigned size, bool float_) {
  if (size < 4) return WasmType::i32;
  if (size == 4) return float_ ? WasmType::f32 : WasmType::i32;
  if (size == 8) return float_ ? WasmType::f64 : WasmType::i64;
  abort();
}

WasmType getReachableWasmType(WasmType a, WasmType b) {
  return a != unreachable ? a : b;
}

bool isConcreteWasmType(WasmType type) {
  return type != none && type != unreachable;
}


// Literals

Literal Literal::castToF32() {
  assert(type == WasmType::i32);
  Literal ret(i32);
  ret.type = WasmType::f32;
  return ret;
}

Literal Literal::castToF64() {
  assert(type == WasmType::i64);
  Literal ret(i64);
  ret.type = WasmType::f64;
  return ret;
}

Literal Literal::castToI32() {
  assert(type == WasmType::f32);
  Literal ret(i32);
  ret.type = WasmType::i32;
  return ret;
}

Literal Literal::castToI64() {
  assert(type == WasmType::f64);
  Literal ret(i64);
  ret.type = WasmType::i64;
  return ret;
}

int64_t Literal::getInteger() {
  switch (type) {
    case WasmType::i32: return i32;
    case WasmType::i64: return i64;
    default: abort();
  }
}

double Literal::getFloat() {
  switch (type) {
    case WasmType::f32: return getf32();
    case WasmType::f64: return getf64();
    default: abort();
  }
}

int64_t Literal::getBits() {
  switch (type) {
    case WasmType::i32: case WasmType::f32: return i32;
    case WasmType::i64: case WasmType::f64: return i64;
    default: abort();
  }
}

bool Literal::operator==(const Literal& other) const {
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
    o << (std::signbit(d) ? "-infinity" : "infinity");
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

Literal Literal::countLeadingZeroes() const {
  if (type == WasmType::i32) return Literal((int32_t)CountLeadingZeroes(i32));
  if (type == WasmType::i64) return Literal((int64_t)CountLeadingZeroes(i64));
  WASM_UNREACHABLE();
}

Literal Literal::countTrailingZeroes() const {
  if (type == WasmType::i32) return Literal((int32_t)CountTrailingZeroes(i32));
  if (type == WasmType::i64) return Literal((int64_t)CountTrailingZeroes(i64));
  WASM_UNREACHABLE();
}

Literal Literal::popCount() const {
  if (type == WasmType::i32) return Literal((int32_t)PopCount(i32));
  if (type == WasmType::i64) return Literal((int64_t)PopCount(i64));
  WASM_UNREACHABLE();
}

Literal Literal::extendToSI64() const {
  assert(type == WasmType::i32);
  return Literal((int64_t)i32);
}

Literal Literal::extendToUI64() const {
  assert(type == WasmType::i32);
  return Literal((uint64_t)(uint32_t)i32);
}

Literal Literal::extendToF64() const {
  assert(type == WasmType::f32);
  return Literal(double(getf32()));
}

Literal Literal::truncateToI32() const {
  assert(type == WasmType::i64);
  return Literal((int32_t)i64);
}

Literal Literal::truncateToF32() const {
  assert(type == WasmType::f64);
  return Literal(float(getf64()));
}

Literal Literal::convertSToF32() const {
  if (type == WasmType::i32) return Literal(float(i32));
  if (type == WasmType::i64) return Literal(float(i64));
  WASM_UNREACHABLE();
}

Literal Literal::convertUToF32() const {
  if (type == WasmType::i32) return Literal(float(uint32_t(i32)));
  if (type == WasmType::i64) return Literal(float(uint64_t(i64)));
  WASM_UNREACHABLE();
}

Literal Literal::convertSToF64() const {
  if (type == WasmType::i32) return Literal(double(i32));
  if (type == WasmType::i64) return Literal(double(i64));
  WASM_UNREACHABLE();
}

Literal Literal::convertUToF64() const {
  if (type == WasmType::i32) return Literal(double(uint32_t(i32)));
  if (type == WasmType::i64) return Literal(double(uint64_t(i64)));
  WASM_UNREACHABLE();
}

Literal Literal::neg() const {
  switch (type) {
    case WasmType::i32: return Literal(i32 ^ 0x80000000);
    case WasmType::i64: return Literal(int64_t(i64 ^ 0x8000000000000000ULL));
    case WasmType::f32: return Literal(i32 ^ 0x80000000).castToF32();
    case WasmType::f64: return Literal(int64_t(i64 ^ 0x8000000000000000ULL)).castToF64();
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::abs() const {
  switch (type) {
    case WasmType::i32: return Literal(i32 & 0x7fffffff);
    case WasmType::i64: return Literal(int64_t(i64 & 0x7fffffffffffffffULL));
    case WasmType::f32: return Literal(i32 & 0x7fffffff).castToF32();
    case WasmType::f64: return Literal(int64_t(i64 & 0x7fffffffffffffffULL)).castToF64();
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ceil() const {
  switch (type) {
    case WasmType::f32: return Literal(std::ceil(getf32()));
    case WasmType::f64: return Literal(std::ceil(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::floor() const {
  switch (type) {
    case WasmType::f32: return Literal(std::floor(getf32()));
    case WasmType::f64: return Literal(std::floor(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::trunc() const {
  switch (type) {
    case WasmType::f32: return Literal(std::trunc(getf32()));
    case WasmType::f64: return Literal(std::trunc(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::nearbyint() const {
  switch (type) {
    case WasmType::f32: return Literal(std::nearbyint(getf32()));
    case WasmType::f64: return Literal(std::nearbyint(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::sqrt() const {
  switch (type) {
    case WasmType::f32: return Literal(std::sqrt(getf32()));
    case WasmType::f64: return Literal(std::sqrt(getf64()));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::add(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) + uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) + uint64_t(other.i64));
    case WasmType::f32: return Literal(getf32() + other.getf32());
    case WasmType::f64: return Literal(getf64() + other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::sub(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) - uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) - uint64_t(other.i64));
    case WasmType::f32: return Literal(getf32() - other.getf32());
    case WasmType::f64: return Literal(getf64() - other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::mul(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) * uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) * uint64_t(other.i64));
    case WasmType::f32: return Literal(getf32() * other.getf32());
    case WasmType::f64: return Literal(getf64() * other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::div(const Literal& other) const {
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

Literal Literal::divS(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 / other.i32);
    case WasmType::i64: return Literal(i64 / other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::divU(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) / uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) / uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::remS(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 % other.i32);
    case WasmType::i64: return Literal(i64 % other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::remU(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) % uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) % uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::and_(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 & other.i32);
    case WasmType::i64: return Literal(i64 & other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::or_(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 | other.i32);
    case WasmType::i64: return Literal(i64 | other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::xor_(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 ^ other.i32);
    case WasmType::i64: return Literal(i64 ^ other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::shl(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) << shiftMask(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) << shiftMask(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::shrS(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 >> shiftMask(other.i32));
    case WasmType::i64: return Literal(i64 >> shiftMask(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::shrU(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) >> shiftMask(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) >> shiftMask(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::rotL(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(RotateLeft(uint32_t(i32), uint32_t(other.i32)));
    case WasmType::i64: return Literal(RotateLeft(uint64_t(i64), uint64_t(other.i64)));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::rotR(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(RotateRight(uint32_t(i32), uint32_t(other.i32)));
    case WasmType::i64: return Literal(RotateRight(uint64_t(i64), uint64_t(other.i64)));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::eq(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 == other.i32);
    case WasmType::i64: return Literal(i64 == other.i64);
    case WasmType::f32: return Literal(getf32() == other.getf32());
    case WasmType::f64: return Literal(getf64() == other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ne(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 != other.i32);
    case WasmType::i64: return Literal(i64 != other.i64);
    case WasmType::f32: return Literal(getf32() != other.getf32());
    case WasmType::f64: return Literal(getf64() != other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ltS(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 < other.i32);
    case WasmType::i64: return Literal(i64 < other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ltU(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) < uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) < uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::lt(const Literal& other) const {
  switch (type) {
    case WasmType::f32: return Literal(getf32() < other.getf32());
    case WasmType::f64: return Literal(getf64() < other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::leS(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 <= other.i32);
    case WasmType::i64: return Literal(i64 <= other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::leU(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) <= uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) <= uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::le(const Literal& other) const {
  switch (type) {
    case WasmType::f32: return Literal(getf32() <= other.getf32());
    case WasmType::f64: return Literal(getf64() <= other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::gtS(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 > other.i32);
    case WasmType::i64: return Literal(i64 > other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::gtU(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) > uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) > uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::gt(const Literal& other) const {
  switch (type) {
    case WasmType::f32: return Literal(getf32() > other.getf32());
    case WasmType::f64: return Literal(getf64() > other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::geS(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(i32 >= other.i32);
    case WasmType::i64: return Literal(i64 >= other.i64);
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::geU(const Literal& other) const {
  switch (type) {
    case WasmType::i32: return Literal(uint32_t(i32) >= uint32_t(other.i32));
    case WasmType::i64: return Literal(uint64_t(i64) >= uint64_t(other.i64));
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::ge(const Literal& other) const {
  switch (type) {
    case WasmType::f32: return Literal(getf32() >= other.getf32());
    case WasmType::f64: return Literal(getf64() >= other.getf64());
    default: WASM_UNREACHABLE();
  }
}

Literal Literal::min(const Literal& other) const {
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

Literal Literal::max(const Literal& other) const {
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

Literal Literal::copysign(const Literal& other) const {
  // operate on bits directly, to avoid signalling bit being set on a float
  switch (type) {
    case WasmType::f32: return Literal((i32 & 0x7fffffff) | (other.i32 & 0x80000000)).castToF32(); break;
    case WasmType::f64: return Literal((i64 & 0x7fffffffffffffffUL) | (other.i64 & 0x8000000000000000UL)).castToF64(); break;
    default: WASM_UNREACHABLE();
  }
}

namespace BinaryConsts {
namespace UserSections {
const char* Name = "name";
}
}

Name GROW_WASM_MEMORY("__growWasmMemory"),
     NEW_SIZE("newSize"),
     MODULE("module"),
     START("start"),
     FUNC("func"),
     PARAM("param"),
     RESULT("result"),
     MEMORY("memory"),
     DATA("data"),
     SEGMENT("segment"),
     EXPORT("export"),
     IMPORT("import"),
     TABLE("table"),
     ELEM("elem"),
     LOCAL("local"),
     TYPE("type"),
     CALL("call"),
     CALL_IMPORT("call_import"),
     CALL_INDIRECT("call_indirect"),
     BLOCK("block"),
     BR_IF("br_if"),
     THEN("then"),
     ELSE("else"),
     _NAN("NaN"),
     _INFINITY("Infinity"),
     NEG_INFINITY("-infinity"),
     NEG_NAN("-nan"),
     CASE("case"),
     BR("br"),
     ANYFUNC("anyfunc"),
     FAKE_RETURN("fake_return_waka123"),
     MUT("mut"),
     SPECTEST("spectest"),
     PRINT("print"),
     EXIT("exit");

// core AST type checking

struct TypeSeeker : public PostWalker<TypeSeeker> {
  Expression* target; // look for this one
  Name targetName;
  std::vector<WasmType> types;

  TypeSeeker(Expression* target, Name targetName) : target(target), targetName(targetName) {
    Expression* temp = target;
    walk(temp);
  }

  void visitBreak(Break* curr) {
    if (curr->name == targetName) {
      types.push_back(curr->value ? curr->value->type : none);
    }
  }

  void visitSwitch(Switch* curr) {
    for (auto name : curr->targets) {
      if (name == targetName) types.push_back(curr->value ? curr->value->type : none);
    }
    if (curr->default_ == targetName) types.push_back(curr->value ? curr->value->type : none);
  }

  void visitBlock(Block* curr) {
    if (curr == target) {
      if (curr->list.size() > 0) {
        types.push_back(curr->list.back()->type);
      } else {
        types.push_back(none);
      }
    } else if (curr->name == targetName) {
      types.clear(); // ignore all breaks til now, they were captured by someone with the same name
    }
  }

  void visitLoop(Loop* curr) {
    if (curr == target) {
      types.push_back(curr->body->type);
    } else if (curr->name == targetName) {
      types.clear(); // ignore all breaks til now, they were captured by someone with the same name
    }
  }
};

static WasmType mergeTypes(std::vector<WasmType>& types) {
  WasmType type = unreachable;
  for (auto other : types) {
    // once none, stop. it then indicates a poison value, that must not be consumed
    // and ignore unreachable
    if (type != none) {
      if (other == none) {
        type = none;
      } else if (other != unreachable) {
        if (type == unreachable) {
          type = other;
        } else if (type != other) {
          type = none; // poison value, we saw multiple types; this should not be consumed
        }
      }
    }
  }
  return type;
}

// a block is unreachable if one of its elements is unreachable,
// and there are no branches to it
static void handleUnreachable(Block* block) {
  if (block->type == unreachable) return; // nothing to do
  for (auto* child : block->list) {
    if (child->type == unreachable) {
      // there is an unreachable child, so we are unreachable, unless we have a break
      BreakSeeker seeker(block->name);
      Expression* expr = block;
      seeker.walk(expr);
      if (!seeker.found) {
        block->type = unreachable;
      } else {
        block->type = seeker.valueType;
      }
      return;
    }
  }
}

void Block::finalize(WasmType type_) {
  type = type_;
  if (type == none && list.size() > 0) {
    handleUnreachable(this);
  }
}

void Block::finalize() {
  if (!name.is()) {
    // nothing branches here, so this is easy
    if (list.size() > 0) {
      type = list.back()->type;
    } else {
      type = none;
    }
    return;
  }

  TypeSeeker seeker(this, this->name);
  type = mergeTypes(seeker.types);
  handleUnreachable(this);
}

void If::finalize(WasmType type_) {
  type = type_;
  if (type == none && (condition->type == unreachable || (ifFalse && ifTrue->type && ifFalse->type == unreachable))) {
    type = unreachable;
  }
}

void If::finalize() {
  if (condition->type == unreachable) {
    type = unreachable;
  } else if (ifFalse) {
    if (ifTrue->type == ifFalse->type) {
      type = ifTrue->type;
    } else if (isConcreteWasmType(ifTrue->type) && ifFalse->type == unreachable) {
      type = ifTrue->type;
    } else if (isConcreteWasmType(ifFalse->type) && ifTrue->type == unreachable) {
      type = ifFalse->type;
    } else {
      type = none;
    }
  } else {
    type = none; // if without else
  }
}

void Loop::finalize(WasmType type_) {
  type = type_;
  if (type == none && body->type == unreachable) {
    type = unreachable;
  }
}

void Loop::finalize() {
  type = body->type;
}

} // namespace wasm
