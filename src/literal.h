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

#ifndef wasm_literal_h
#define wasm_literal_h

#include <iostream>
#include <array>

#include "support/hash.h"
#include "support/utilities.h"
#include "compiler-support.h"
#include "wasm-type.h"

namespace wasm {

class Literal {
  // store only integers, whose bits are deterministic. floats
  // can have their signalling bit set, for example.
  union {
    int32_t i32;
    int64_t i64;
    uint8_t v128[16];
  };

public:
  Type type;

public:
  Literal()                       : v128(),                       type(Type::none) {}
  explicit Literal(Type type)     : v128(),                       type(type)       {}
  explicit Literal(int32_t  init) : i32(init),                    type(Type::i32)  {}
  explicit Literal(uint32_t init) : i32(init),                    type(Type::i32)  {}
  explicit Literal(int64_t  init) : i64(init),                    type(Type::i64)  {}
  explicit Literal(uint64_t init) : i64(init),                    type(Type::i64)  {}
  explicit Literal(float    init) : i32(bit_cast<int32_t>(init)), type(Type::f32)  {}
  explicit Literal(double   init) : i64(bit_cast<int64_t>(init)), type(Type::f64)  {}
  // v128 literal from bytes
  explicit Literal(const uint8_t init[16]);
  // v128 literal from lane value literals
  explicit Literal(const std::array<Literal, 16>&);
  explicit Literal(const std::array<Literal, 8>&);
  explicit Literal(const std::array<Literal, 4>&);
  explicit Literal(const std::array<Literal, 2>&);

  bool isConcrete() { return type != none; }
  bool isNull() { return type == none; }

  inline static Literal makeFromInt32(int32_t x, Type type) {
    switch (type) {
      case Type::i32: return Literal(int32_t(x)); break;
      case Type::i64: return Literal(int64_t(x)); break;
      case Type::f32: return Literal(float(x)); break;
      case Type::f64: return Literal(double(x)); break;
      case Type::v128: return Literal(
        std::array<Literal, 4>{{
          Literal(x), Literal(int32_t(0)), Literal(int32_t(0)), Literal(int32_t(0))
        }}
      );
      case none:
      case unreachable: WASM_UNREACHABLE();
    }
    WASM_UNREACHABLE();
  }

  inline static Literal makeZero(Type type) {
    return makeFromInt32(0, type);
  }

  Literal castToF32();
  Literal castToF64();
  Literal castToI32();
  Literal castToI64();

  int32_t geti32() const { assert(type == Type::i32); return i32; }
  int64_t geti64() const { assert(type == Type::i64); return i64; }
  float   getf32() const { assert(type == Type::f32); return bit_cast<float>(i32); }
  double  getf64() const { assert(type == Type::f64); return bit_cast<double>(i64); }
  std::array<uint8_t, 16> getv128() const;

  // careful!
  int32_t* geti32Ptr() { assert(type == Type::i32); return &i32; }
  uint8_t* getv128Ptr() { assert(type == Type::v128); return v128; }
  const uint8_t* getv128Ptr() const { assert(type == Type::v128); return v128; }

  int32_t reinterpreti32() const { assert(type == Type::f32); return i32; }
  int64_t reinterpreti64() const { assert(type == Type::f64); return i64; }
  float   reinterpretf32() const { assert(type == Type::i32); return bit_cast<float>(i32); }
  double  reinterpretf64() const { assert(type == Type::i64); return bit_cast<double>(i64); }

  int64_t getInteger() const;
  double getFloat() const;
  void getBits(uint8_t (&buf)[16]) const;
  // Equality checks for the type and the bits, so a nan float would
  // be compared bitwise (which means that a Literal containing a nan
  // would be equal to itself, if the bits are equal).
  bool operator==(const Literal& other) const;
  bool operator!=(const Literal& other) const;

  bool isNaN();

  static uint32_t NaNPayload(float f);
  static uint64_t NaNPayload(double f);
  static float setQuietNaN(float f);
  static double setQuietNaN(double f);

  static void printFloat(std::ostream &o, float f);
  static void printDouble(std::ostream& o, double d);
  static void printVec128(std::ostream& o, const std::array<uint8_t, 16>& v);

  friend std::ostream& operator<<(std::ostream& o, Literal literal);

  Literal countLeadingZeroes() const;
  Literal countTrailingZeroes() const;
  Literal popCount() const;

  Literal extendToSI64() const;
  Literal extendToUI64() const;
  Literal extendToF64() const;
  Literal extendS8() const;
  Literal extendS16() const;
  Literal extendS32() const;
  Literal wrapToI32() const;

  Literal convertSIToF32() const;
  Literal convertUIToF32() const;
  Literal convertSIToF64() const;
  Literal convertUIToF64() const;

  Literal truncSatToSI32() const;
  Literal truncSatToSI64() const;
  Literal truncSatToUI32() const;
  Literal truncSatToUI64() const;

  Literal eqz() const;
  Literal neg() const;
  Literal abs() const;
  Literal ceil() const;
  Literal floor() const;
  Literal trunc() const;
  Literal nearbyint() const;
  Literal sqrt() const;
  Literal demote() const;

  Literal add(const Literal& other) const;
  Literal sub(const Literal& other) const;
  Literal mul(const Literal& other) const;
  Literal div(const Literal& other) const;
  Literal divS(const Literal& other) const;
  Literal divU(const Literal& other) const;
  Literal remS(const Literal& other) const;
  Literal remU(const Literal& other) const;
  Literal and_(const Literal& other) const;
  Literal or_(const Literal& other) const;
  Literal xor_(const Literal& other) const;
  Literal shl(const Literal& other) const;
  Literal shrS(const Literal& other) const;
  Literal shrU(const Literal& other) const;
  Literal rotL(const Literal& other) const;
  Literal rotR(const Literal& other) const;

  // Note that these functions perform equality checks based
  // on the type of the literal, so that (unlike the == operator)
  // a float nan would not be identical to itself.
  Literal eq(const Literal& other) const;
  Literal ne(const Literal& other) const;
  Literal ltS(const Literal& other) const;
  Literal ltU(const Literal& other) const;
  Literal lt(const Literal& other) const;
  Literal leS(const Literal& other) const;
  Literal leU(const Literal& other) const;
  Literal le(const Literal& other) const;

  Literal gtS(const Literal& other) const;
  Literal gtU(const Literal& other) const;
  Literal gt(const Literal& other) const;
  Literal geS(const Literal& other) const;
  Literal geU(const Literal& other) const;
  Literal ge(const Literal& other) const;

  Literal min(const Literal& other) const;
  Literal max(const Literal& other) const;
  Literal copysign(const Literal& other) const;

  std::array<Literal, 16> getLanesSI8x16() const;
  std::array<Literal, 16> getLanesUI8x16() const;
  std::array<Literal, 8> getLanesSI16x8() const;
  std::array<Literal, 8> getLanesUI16x8() const;
  std::array<Literal, 4> getLanesI32x4() const;
  std::array<Literal, 2> getLanesI64x2() const;
  std::array<Literal, 4> getLanesF32x4() const;
  std::array<Literal, 2> getLanesF64x2() const;

  Literal shuffleV8x16(const Literal& other, const std::array<uint8_t, 16>& mask) const;
  Literal splatI8x16() const;
  Literal extractLaneSI8x16(uint8_t index) const;
  Literal extractLaneUI8x16(uint8_t index) const;
  Literal replaceLaneI8x16(const Literal& other, uint8_t index) const;
  Literal splatI16x8() const;
  Literal extractLaneSI16x8(uint8_t index) const;
  Literal extractLaneUI16x8(uint8_t index) const;
  Literal replaceLaneI16x8(const Literal& other, uint8_t index) const;
  Literal splatI32x4() const;
  Literal extractLaneI32x4(uint8_t index) const;
  Literal replaceLaneI32x4(const Literal& other, uint8_t index) const;
  Literal splatI64x2() const;
  Literal extractLaneI64x2(uint8_t index) const;
  Literal replaceLaneI64x2(const Literal& other, uint8_t index) const;
  Literal splatF32x4() const;
  Literal extractLaneF32x4(uint8_t index) const;
  Literal replaceLaneF32x4(const Literal& other, uint8_t index) const;
  Literal splatF64x2() const;
  Literal extractLaneF64x2(uint8_t index) const;
  Literal replaceLaneF64x2(const Literal& other, uint8_t index) const;
  Literal eqI8x16(const Literal& other) const;
  Literal neI8x16(const Literal& other) const;
  Literal ltSI8x16(const Literal& other) const;
  Literal ltUI8x16(const Literal& other) const;
  Literal gtSI8x16(const Literal& other) const;
  Literal gtUI8x16(const Literal& other) const;
  Literal leSI8x16(const Literal& other) const;
  Literal leUI8x16(const Literal& other) const;
  Literal geSI8x16(const Literal& other) const;
  Literal geUI8x16(const Literal& other) const;
  Literal eqI16x8(const Literal& other) const;
  Literal neI16x8(const Literal& other) const;
  Literal ltSI16x8(const Literal& other) const;
  Literal ltUI16x8(const Literal& other) const;
  Literal gtSI16x8(const Literal& other) const;
  Literal gtUI16x8(const Literal& other) const;
  Literal leSI16x8(const Literal& other) const;
  Literal leUI16x8(const Literal& other) const;
  Literal geSI16x8(const Literal& other) const;
  Literal geUI16x8(const Literal& other) const;
  Literal eqI32x4(const Literal& other) const;
  Literal neI32x4(const Literal& other) const;
  Literal ltSI32x4(const Literal& other) const;
  Literal ltUI32x4(const Literal& other) const;
  Literal gtSI32x4(const Literal& other) const;
  Literal gtUI32x4(const Literal& other) const;
  Literal leSI32x4(const Literal& other) const;
  Literal leUI32x4(const Literal& other) const;
  Literal geSI32x4(const Literal& other) const;
  Literal geUI32x4(const Literal& other) const;
  Literal eqF32x4(const Literal& other) const;
  Literal neF32x4(const Literal& other) const;
  Literal ltF32x4(const Literal& other) const;
  Literal gtF32x4(const Literal& other) const;
  Literal leF32x4(const Literal& other) const;
  Literal geF32x4(const Literal& other) const;
  Literal eqF64x2(const Literal& other) const;
  Literal neF64x2(const Literal& other) const;
  Literal ltF64x2(const Literal& other) const;
  Literal gtF64x2(const Literal& other) const;
  Literal leF64x2(const Literal& other) const;
  Literal geF64x2(const Literal& other) const;
  Literal notV128() const;
  Literal andV128(const Literal& other) const;
  Literal orV128(const Literal& other) const;
  Literal xorV128(const Literal& other) const;
  Literal bitselectV128(const Literal& left, const Literal& right) const;
  Literal negI8x16() const;
  Literal anyTrueI8x16() const;
  Literal allTrueI8x16() const;
  Literal shlI8x16(const Literal& other) const;
  Literal shrSI8x16(const Literal& other) const;
  Literal shrUI8x16(const Literal& other) const;
  Literal addI8x16(const Literal& other) const;
  Literal addSaturateSI8x16(const Literal& other) const;
  Literal addSaturateUI8x16(const Literal& other) const;
  Literal subI8x16(const Literal& other) const;
  Literal subSaturateSI8x16(const Literal& other) const;
  Literal subSaturateUI8x16(const Literal& other) const;
  Literal mulI8x16(const Literal& other) const;
  Literal negI16x8() const;
  Literal anyTrueI16x8() const;
  Literal allTrueI16x8() const;
  Literal shlI16x8(const Literal& other) const;
  Literal shrSI16x8(const Literal& other) const;
  Literal shrUI16x8(const Literal& other) const;
  Literal addI16x8(const Literal& other) const;
  Literal addSaturateSI16x8(const Literal& other) const;
  Literal addSaturateUI16x8(const Literal& other) const;
  Literal subI16x8(const Literal& other) const;
  Literal subSaturateSI16x8(const Literal& other) const;
  Literal subSaturateUI16x8(const Literal& other) const;
  Literal mulI16x8(const Literal& other) const;
  Literal negI32x4() const;
  Literal anyTrueI32x4() const;
  Literal allTrueI32x4() const;
  Literal shlI32x4(const Literal& other) const;
  Literal shrSI32x4(const Literal& other) const;
  Literal shrUI32x4(const Literal& other) const;
  Literal addI32x4(const Literal& other) const;
  Literal subI32x4(const Literal& other) const;
  Literal mulI32x4(const Literal& other) const;
  Literal negI64x2() const;
  Literal anyTrueI64x2() const;
  Literal allTrueI64x2() const;
  Literal shlI64x2(const Literal& other) const;
  Literal shrSI64x2(const Literal& other) const;
  Literal shrUI64x2(const Literal& other) const;
  Literal addI64x2(const Literal& other) const;
  Literal subI64x2(const Literal& other) const;
  Literal absF32x4() const;
  Literal negF32x4() const;
  Literal sqrtF32x4() const;
  Literal addF32x4(const Literal& other) const;
  Literal subF32x4(const Literal& other) const;
  Literal mulF32x4(const Literal& other) const;
  Literal divF32x4(const Literal& other) const;
  Literal minF32x4(const Literal& other) const;
  Literal maxF32x4(const Literal& other) const;
  Literal absF64x2() const;
  Literal negF64x2() const;
  Literal sqrtF64x2() const;
  Literal addF64x2(const Literal& other) const;
  Literal subF64x2(const Literal& other) const;
  Literal mulF64x2(const Literal& other) const;
  Literal divF64x2(const Literal& other) const;
  Literal minF64x2(const Literal& other) const;
  Literal maxF64x2(const Literal& other) const;
  Literal truncSatToSI32x4() const;
  Literal truncSatToUI32x4() const;
  Literal truncSatToSI64x2() const;
  Literal truncSatToUI64x2() const;
  Literal convertSToF32x4() const;
  Literal convertUToF32x4() const;
  Literal convertSToF64x2() const;
  Literal convertUToF64x2() const;

 private:
  Literal addSatSI8(const Literal& other) const;
  Literal addSatUI8(const Literal& other) const;
  Literal addSatSI16(const Literal& other) const;
  Literal addSatUI16(const Literal& other) const;
  Literal subSatSI8(const Literal& other) const;
  Literal subSatUI8(const Literal& other) const;
  Literal subSatSI16(const Literal& other) const;
  Literal subSatUI16(const Literal& other) const;
};

} // namespace wasm

namespace std {
template<> struct hash<wasm::Literal> {
  size_t operator()(const wasm::Literal& a) const {
    uint8_t bytes[16];
    a.getBits(bytes);
    int64_t chunks[2];
    memcpy(chunks, bytes, sizeof(chunks));
    return wasm::rehash(
      wasm::rehash(
        uint64_t(hash<size_t>()(size_t(a.type))),
        uint64_t(hash<int64_t>()(chunks[0]))
      ),
      uint64_t(hash<int64_t>()(chunks[1]))
    );
  }
};
template<> struct less<wasm::Literal> {
  bool operator()(const wasm::Literal& a, const wasm::Literal& b) const {
    if (a.type < b.type) return true;
    if (a.type > b.type) return false;
    switch (a.type) {
      case wasm::Type::i32: return a.geti32() < b.geti32();
      case wasm::Type::f32: return a.reinterpreti32() < b.reinterpreti32();
      case wasm::Type::i64: return a.geti64() < b.geti64();
      case wasm::Type::f64: return a.reinterpreti64() < b.reinterpreti64();
      case wasm::Type::v128: return memcmp(a.getv128Ptr(), b.getv128Ptr(), 16) < 0;
      case wasm::Type::none:
      case wasm::Type::unreachable: return false;
    }
    WASM_UNREACHABLE();
  }
};
}

#endif // wasm_literal_h
