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

#include <array>
#include <iostream>
#include <variant>

#include "compiler-support.h"
#include "support/hash.h"
#include "support/name.h"
#include "support/small_vector.h"
#include "support/utilities.h"
#include "wasm-type.h"

namespace wasm {

class Literals;
struct GCData;
struct RttSupers;

class Literal {
  // store only integers, whose bits are deterministic. floats
  // can have their signalling bit set, for example.
  union {
    int32_t i32;
    int64_t i64;
    uint8_t v128[16];
    // funcref function name. `isNull()` indicates a `null` value.
    Name func;
    // A reference to GC data, either a Struct or an Array. For both of those
    // we store the referred data as a Literals object (which is natural for an
    // Array, and for a Struct, is just the fields in order). The type is used
    // to indicate whether this is a Struct or an Array, and of what type.
    std::shared_ptr<GCData> gcData;
    // RTT values are "structural" in that the MVP doc says that multiple
    // invocations of ref.canon return things that are observably identical, and
    // the same is true for ref.sub. That is, what matters is the types; there
    // is no unique identifier created in each ref.canon/sub. To track the
    // types, we maintain a simple vector of the supertypes. Thus, an rtt.canon
    // of type A will have an empty vector; an rtt.sub of type B of that initial
    // canon would have a vector of size 1 containing A; a subsequent rtt.sub
    // would have A, B, and so forth.
    // (This encoding is very inefficient and not at all what a production VM
    // would do, but it is simple.)
    // The unique_ptr here is to avoid increasing the size of the union as well
    // as the Literal class itself.
    // To support the experimental RttFreshSub instruction, we not only store
    // the type, but also a reference to an allocation.
    std::unique_ptr<RttSupers> rttSupers;
    // TODO: Literals of type `externref` can only be `null` currently but we
    // will need to represent extern values eventually, to
    // 1) run the spec tests and fuzzer with reference types enabled and
    // 2) avoid bailing out when seeing a reference typed value in precompute
  };

public:
  // Type of the literal. Immutable because the literal's payload depends on it.
  const Type type;

  Literal() : v128(), type(Type::none) {}
  explicit Literal(Type type);
  explicit Literal(Type::BasicType type) : Literal(Type(type)) {}
  explicit Literal(int32_t init) : i32(init), type(Type::i32) {}
  explicit Literal(uint32_t init) : i32(init), type(Type::i32) {}
  explicit Literal(int64_t init) : i64(init), type(Type::i64) {}
  explicit Literal(uint64_t init) : i64(init), type(Type::i64) {}
  explicit Literal(float init)
    : i32(bit_cast<int32_t>(init)), type(Type::f32) {}
  explicit Literal(double init)
    : i64(bit_cast<int64_t>(init)), type(Type::f64) {}
  // v128 literal from bytes
  explicit Literal(const uint8_t init[16]);
  // v128 literal from lane value literals
  explicit Literal(const std::array<Literal, 16>&);
  explicit Literal(const std::array<Literal, 8>&);
  explicit Literal(const std::array<Literal, 4>&);
  explicit Literal(const std::array<Literal, 2>&);
  explicit Literal(Name func, Type type) : func(func), type(type) {}
  explicit Literal(std::shared_ptr<GCData> gcData, Type type);
  explicit Literal(std::unique_ptr<RttSupers>&& rttSupers, Type type);
  Literal(const Literal& other);
  Literal& operator=(const Literal& other);
  ~Literal();

  bool isConcrete() const { return type.isConcrete(); }
  bool isNone() const { return type == Type::none; }
  bool isFunction() const { return type.isFunction(); }
  bool isData() const { return type.isData(); }

  bool isNull() const {
    if (type.isNullable()) {
      if (type.isFunction()) {
        return func.isNull();
      }
      if (isData()) {
        return !gcData;
      }
      return true;
    }
    return false;
  }
  bool isZero() const {
    switch (type.getBasic()) {
      case Type::i32:
        return i32 == 0;
      case Type::i64:
        return i64 == 0LL;
      case Type::f32:
        return bit_cast<float>(i32) == 0.0f;
      case Type::f64:
        return bit_cast<double>(i64) == 0.0;
      case Type::v128: {
        uint8_t zeros[16] = {0};
        return memcmp(&v128, zeros, 16) == 0;
      }
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  bool isNegative() const {
    switch (type.getBasic()) {
      case Type::i32:
      case Type::f32:
        return i32 < 0;
      case Type::i64:
      case Type::f64:
        return i64 < 0;
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  bool isSignedMin() const {
    switch (type.getBasic()) {
      case Type::i32:
        return i32 == std::numeric_limits<int32_t>::min();
      case Type::i64:
        return i64 == std::numeric_limits<int64_t>::min();
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  bool isSignedMax() const {
    switch (type.getBasic()) {
      case Type::i32:
        return i32 == std::numeric_limits<int32_t>::max();
      case Type::i64:
        return i64 == std::numeric_limits<int64_t>::max();
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  bool isUnsignedMax() const {
    switch (type.getBasic()) {
      case Type::i32:
        return uint32_t(i32) == std::numeric_limits<uint32_t>::max();
      case Type::i64:
        return uint64_t(i64) == std::numeric_limits<uint64_t>::max();
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }

  static Literals makeZeros(Type type);
  static Literals makeOnes(Type type);
  static Literals makeNegOnes(Type type);
  static Literal makeZero(Type type);
  static Literal makeOne(Type type);
  static Literal makeNegOne(Type type);
  static Literal makeFromInt32(int32_t x, Type type) {
    switch (type.getBasic()) {
      case Type::i32:
        return Literal(int32_t(x));
      case Type::i64:
        return Literal(int64_t(x));
      case Type::f32:
        return Literal(float(x));
      case Type::f64:
        return Literal(double(x));
      case Type::v128:
        return Literal(std::array<Literal, 4>{{Literal(x),
                                               Literal(int32_t(0)),
                                               Literal(int32_t(0)),
                                               Literal(int32_t(0))}});
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  static Literal makeFromInt64(int64_t x, Type type) {
    switch (type.getBasic()) {
      case Type::i32:
        return Literal(int32_t(x));
      case Type::i64:
        return Literal(int64_t(x));
      case Type::f32:
        return Literal(float(x));
      case Type::f64:
        return Literal(double(x));
      case Type::v128:
        return Literal(
          std::array<Literal, 2>{{Literal(x), Literal(int64_t(0))}});
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  static Literal makeSignedMin(Type type) {
    switch (type.getBasic()) {
      case Type::i32:
        return Literal(std::numeric_limits<int32_t>::min());
      case Type::i64:
        return Literal(std::numeric_limits<int64_t>::min());
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  static Literal makeSignedMax(Type type) {
    switch (type.getBasic()) {
      case Type::i32:
        return Literal(std::numeric_limits<int32_t>::max());
      case Type::i64:
        return Literal(std::numeric_limits<int64_t>::max());
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  static Literal makeUnsignedMax(Type type) {
    switch (type.getBasic()) {
      case Type::i32:
        return Literal(std::numeric_limits<uint32_t>::max());
      case Type::i64:
        return Literal(std::numeric_limits<uint64_t>::max());
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  static Literal makeNull(Type type) {
    assert(type.isNullable());
    return Literal(type);
  }
  static Literal makeFunc(Name func, Type type = Type::funcref) {
    return Literal(func, type);
  }
  static Literal makeI31(int32_t value) {
    auto lit = Literal(Type::i31ref);
    lit.i32 = value & 0x7fffffff;
    return lit;
  }

  // Get the canonical RTT value for a given HeapType. For nominal types, the
  // canonical RTT reflects the static supertype chain.
  static Literal makeCanonicalRtt(HeapType type);

  Literal castToF32();
  Literal castToF64();
  Literal castToI32();
  Literal castToI64();

  int32_t geti32() const {
    assert(type == Type::i32);
    return i32;
  }
  int32_t geti31(bool signed_ = true) const {
    assert(type.getHeapType() == HeapType::i31);
    return signed_ ? (i32 << 1) >> 1 : i32;
  }
  int64_t geti64() const {
    assert(type == Type::i64);
    return i64;
  }
  float getf32() const {
    assert(type == Type::f32);
    return bit_cast<float>(i32);
  }
  double getf64() const {
    assert(type == Type::f64);
    return bit_cast<double>(i64);
  }
  std::array<uint8_t, 16> getv128() const;
  Name getFunc() const {
    assert(type.isFunction() && !func.isNull());
    return func;
  }
  std::shared_ptr<GCData> getGCData() const;
  const RttSupers& getRttSupers() const;

  // careful!
  int32_t* geti32Ptr() {
    assert(type == Type::i32);
    return &i32;
  }
  uint8_t* getv128Ptr() {
    assert(type == Type::v128);
    return v128;
  }
  const uint8_t* getv128Ptr() const {
    assert(type == Type::v128);
    return v128;
  }

  int32_t reinterpreti32() const {
    assert(type == Type::f32);
    return i32;
  }
  int64_t reinterpreti64() const {
    assert(type == Type::f64);
    return i64;
  }
  float reinterpretf32() const {
    assert(type == Type::i32);
    return bit_cast<float>(i32);
  }
  double reinterpretf64() const {
    assert(type == Type::i64);
    return bit_cast<double>(i64);
  }

  int64_t getInteger() const;
  uint64_t getUnsigned() const;
  double getFloat() const;
  // Obtains the bits of a basic value typed literal.
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

  static void printFloat(std::ostream& o, float f);
  static void printDouble(std::ostream& o, double d);
  static void printVec128(std::ostream& o, const std::array<uint8_t, 16>& v);

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
  Literal pmin(const Literal& other) const;
  Literal pmax(const Literal& other) const;
  Literal copysign(const Literal& other) const;

  // Fused multiply add and subtract.
  // Computes this + (left * right) to infinite precision then round once.
  Literal fma(const Literal& left, const Literal& right) const;
  Literal fms(const Literal& left, const Literal& right) const;

  std::array<Literal, 16> getLanesSI8x16() const;
  std::array<Literal, 16> getLanesUI8x16() const;
  std::array<Literal, 8> getLanesSI16x8() const;
  std::array<Literal, 8> getLanesUI16x8() const;
  std::array<Literal, 4> getLanesI32x4() const;
  std::array<Literal, 2> getLanesI64x2() const;
  std::array<Literal, 4> getLanesF32x4() const;
  std::array<Literal, 2> getLanesF64x2() const;

  Literal shuffleV8x16(const Literal& other,
                       const std::array<uint8_t, 16>& mask) const;
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
  Literal eqI64x2(const Literal& other) const;
  Literal neI64x2(const Literal& other) const;
  Literal ltSI64x2(const Literal& other) const;
  Literal gtSI64x2(const Literal& other) const;
  Literal leSI64x2(const Literal& other) const;
  Literal geSI64x2(const Literal& other) const;
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
  Literal anyTrueV128() const;
  Literal bitselectV128(const Literal& left, const Literal& right) const;
  Literal absI8x16() const;
  Literal negI8x16() const;
  Literal allTrueI8x16() const;
  Literal bitmaskI8x16() const;
  Literal shlI8x16(const Literal& other) const;
  Literal shrSI8x16(const Literal& other) const;
  Literal shrUI8x16(const Literal& other) const;
  Literal addI8x16(const Literal& other) const;
  Literal addSaturateSI8x16(const Literal& other) const;
  Literal addSaturateUI8x16(const Literal& other) const;
  Literal subI8x16(const Literal& other) const;
  Literal subSaturateSI8x16(const Literal& other) const;
  Literal subSaturateUI8x16(const Literal& other) const;
  Literal minSI8x16(const Literal& other) const;
  Literal minUI8x16(const Literal& other) const;
  Literal maxSI8x16(const Literal& other) const;
  Literal maxUI8x16(const Literal& other) const;
  Literal avgrUI8x16(const Literal& other) const;
  Literal popcntI8x16() const;
  Literal absI16x8() const;
  Literal negI16x8() const;
  Literal allTrueI16x8() const;
  Literal bitmaskI16x8() const;
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
  Literal minSI16x8(const Literal& other) const;
  Literal minUI16x8(const Literal& other) const;
  Literal maxSI16x8(const Literal& other) const;
  Literal maxUI16x8(const Literal& other) const;
  Literal avgrUI16x8(const Literal& other) const;
  Literal q15MulrSatSI16x8(const Literal& other) const;
  Literal extMulLowSI16x8(const Literal& other) const;
  Literal extMulHighSI16x8(const Literal& other) const;
  Literal extMulLowUI16x8(const Literal& other) const;
  Literal extMulHighUI16x8(const Literal& other) const;
  Literal absI32x4() const;
  Literal negI32x4() const;
  Literal allTrueI32x4() const;
  Literal bitmaskI32x4() const;
  Literal shlI32x4(const Literal& other) const;
  Literal shrSI32x4(const Literal& other) const;
  Literal shrUI32x4(const Literal& other) const;
  Literal addI32x4(const Literal& other) const;
  Literal subI32x4(const Literal& other) const;
  Literal mulI32x4(const Literal& other) const;
  Literal minSI32x4(const Literal& other) const;
  Literal minUI32x4(const Literal& other) const;
  Literal maxSI32x4(const Literal& other) const;
  Literal maxUI32x4(const Literal& other) const;
  Literal dotSI16x8toI32x4(const Literal& other) const;
  Literal extMulLowSI32x4(const Literal& other) const;
  Literal extMulHighSI32x4(const Literal& other) const;
  Literal extMulLowUI32x4(const Literal& other) const;
  Literal extMulHighUI32x4(const Literal& other) const;
  Literal absI64x2() const;
  Literal negI64x2() const;
  Literal bitmaskI64x2() const;
  Literal allTrueI64x2() const;
  Literal shlI64x2(const Literal& other) const;
  Literal shrSI64x2(const Literal& other) const;
  Literal shrUI64x2(const Literal& other) const;
  Literal addI64x2(const Literal& other) const;
  Literal subI64x2(const Literal& other) const;
  Literal mulI64x2(const Literal& other) const;
  Literal extMulLowSI64x2(const Literal& other) const;
  Literal extMulHighSI64x2(const Literal& other) const;
  Literal extMulLowUI64x2(const Literal& other) const;
  Literal extMulHighUI64x2(const Literal& other) const;
  Literal absF32x4() const;
  Literal negF32x4() const;
  Literal sqrtF32x4() const;
  Literal addF32x4(const Literal& other) const;
  Literal subF32x4(const Literal& other) const;
  Literal mulF32x4(const Literal& other) const;
  Literal divF32x4(const Literal& other) const;
  Literal minF32x4(const Literal& other) const;
  Literal maxF32x4(const Literal& other) const;
  Literal pminF32x4(const Literal& other) const;
  Literal pmaxF32x4(const Literal& other) const;
  Literal ceilF32x4() const;
  Literal floorF32x4() const;
  Literal truncF32x4() const;
  Literal nearestF32x4() const;
  Literal absF64x2() const;
  Literal negF64x2() const;
  Literal sqrtF64x2() const;
  Literal addF64x2(const Literal& other) const;
  Literal subF64x2(const Literal& other) const;
  Literal mulF64x2(const Literal& other) const;
  Literal divF64x2(const Literal& other) const;
  Literal minF64x2(const Literal& other) const;
  Literal maxF64x2(const Literal& other) const;
  Literal pminF64x2(const Literal& other) const;
  Literal pmaxF64x2(const Literal& other) const;
  Literal ceilF64x2() const;
  Literal floorF64x2() const;
  Literal truncF64x2() const;
  Literal nearestF64x2() const;
  Literal extAddPairwiseToSI16x8() const;
  Literal extAddPairwiseToUI16x8() const;
  Literal extAddPairwiseToSI32x4() const;
  Literal extAddPairwiseToUI32x4() const;
  Literal truncSatToSI32x4() const;
  Literal truncSatToUI32x4() const;
  Literal convertSToF32x4() const;
  Literal convertUToF32x4() const;
  Literal narrowSToI8x16(const Literal& other) const;
  Literal narrowUToI8x16(const Literal& other) const;
  Literal narrowSToI16x8(const Literal& other) const;
  Literal narrowUToI16x8(const Literal& other) const;
  Literal extendLowSToI16x8() const;
  Literal extendHighSToI16x8() const;
  Literal extendLowUToI16x8() const;
  Literal extendHighUToI16x8() const;
  Literal extendLowSToI32x4() const;
  Literal extendHighSToI32x4() const;
  Literal extendLowUToI32x4() const;
  Literal extendHighUToI32x4() const;
  Literal extendLowSToI64x2() const;
  Literal extendHighSToI64x2() const;
  Literal extendLowUToI64x2() const;
  Literal extendHighUToI64x2() const;
  Literal convertLowSToF64x2() const;
  Literal convertLowUToF64x2() const;
  Literal truncSatZeroSToI32x4() const;
  Literal truncSatZeroUToI32x4() const;
  Literal demoteZeroToF32x4() const;
  Literal promoteLowToF64x2() const;
  Literal swizzleI8x16(const Literal& other) const;
  Literal relaxedFmaF32x4(const Literal& left, const Literal& right) const;
  Literal relaxedFmsF32x4(const Literal& left, const Literal& right) const;
  Literal relaxedFmaF64x2(const Literal& left, const Literal& right) const;
  Literal relaxedFmsF64x2(const Literal& left, const Literal& right) const;

  // Checks if an RTT value is a sub-rtt of another, that is, whether GC data
  // with this object's RTT can be successfuly cast using the other RTT
  // according to the wasm rules for that.
  bool isSubRtt(const Literal& other) const;

private:
  Literal addSatSI8(const Literal& other) const;
  Literal addSatUI8(const Literal& other) const;
  Literal addSatSI16(const Literal& other) const;
  Literal addSatUI16(const Literal& other) const;
  Literal subSatSI8(const Literal& other) const;
  Literal subSatUI8(const Literal& other) const;
  Literal subSatSI16(const Literal& other) const;
  Literal subSatUI16(const Literal& other) const;
  Literal q15MulrSatSI16(const Literal& other) const;
  Literal minInt(const Literal& other) const;
  Literal maxInt(const Literal& other) const;
  Literal minUInt(const Literal& other) const;
  Literal maxUInt(const Literal& other) const;
  Literal avgrUInt(const Literal& other) const;
};

class Literals : public SmallVector<Literal, 1> {
public:
  Literals() = default;
  Literals(std::initializer_list<Literal> init)
    : SmallVector<Literal, 1>(init) {
#ifndef NDEBUG
    for (auto& lit : init) {
      assert(lit.isConcrete());
    }
#endif
  }
  Literals(size_t initialSize) : SmallVector(initialSize) {}

  Type getType() {
    if (empty()) {
      return Type::none;
    }
    if (size() == 1) {
      return (*this)[0].type;
    }
    std::vector<Type> types;
    for (auto& val : *this) {
      types.push_back(val.type);
    }
    return Type(types);
  }
  bool isNone() { return size() == 0; }
  bool isConcrete() { return size() != 0; }
};

std::ostream& operator<<(std::ostream& o, wasm::Literal literal);
std::ostream& operator<<(std::ostream& o, wasm::Literals literals);

// A GC Struct or Array is a set of values with a run-time type saying what it
// is. In the case of static (rtt-free) typing, the rtt is not present and
// instead we have a static type.
struct GCData {
  // The runtime type info for this struct or array.
  Literal rtt;

  // The element or field values.
  Literals values;

  GCData(Literal rtt, Literals values) : rtt(rtt), values(values) {}
};

struct RttSuper {
  // The type of the super.
  HeapType type;
  // A shared allocation, used to implement rtt.fresh_sub. This is null for a
  // normal sub, and for a fresh one we allocate a value here, which can then be
  // used to differentiate rtts. (The allocation is shared so that when copying
  // an rtt we remain equal.)
  // TODO: Remove or optimize this when the spec stabilizes.
  std::shared_ptr<size_t> freshPtr;

  RttSuper(HeapType type) : type(type) {}

  void makeFresh() { freshPtr = std::make_shared<size_t>(); }

  bool operator==(const RttSuper& other) const {
    return type == other.type && freshPtr == other.freshPtr;
  }
  bool operator!=(const RttSuper& other) const { return !(*this == other); }
};

struct RttSupers : std::vector<RttSuper> {};

} // namespace wasm

namespace std {
template<> struct hash<wasm::Literal> {
  size_t operator()(const wasm::Literal& a) const {
    auto digest = wasm::hash(a.type.getID());
    auto hashRef = [&]() {
      assert(a.type.isRef());
      if (a.isNull()) {
        return digest;
      }
      if (a.type.isFunction()) {
        wasm::rehash(digest, a.getFunc());
        return digest;
      }
      // other non-null reference type literals cannot represent concrete
      // values, i.e. there is no concrete externref, anyref or eqref other than
      // null.
      WASM_UNREACHABLE("unexpected type");
    };
    if (a.type.isBasic()) {
      switch (a.type.getBasic()) {
        case wasm::Type::i32:
          wasm::rehash(digest, a.geti32());
          return digest;
        case wasm::Type::f32:
          wasm::rehash(digest, a.reinterpreti32());
          return digest;
        case wasm::Type::i64:
          wasm::rehash(digest, a.geti64());
          return digest;
        case wasm::Type::f64:
          wasm::rehash(digest, a.reinterpreti64());
          return digest;
        case wasm::Type::v128:
          uint64_t chunks[2];
          memcpy(&chunks, a.getv128Ptr(), 16);
          wasm::rehash(digest, chunks[0]);
          wasm::rehash(digest, chunks[1]);
          return digest;
        case wasm::Type::funcref:
        case wasm::Type::externref:
        case wasm::Type::anyref:
        case wasm::Type::eqref:
        case wasm::Type::dataref:
          return hashRef();
        case wasm::Type::i31ref:
          wasm::rehash(digest, a.geti31(true));
          return digest;
        case wasm::Type::none:
        case wasm::Type::unreachable:
          break;
      }
    } else if (a.type.isRef()) {
      return hashRef();
    } else if (a.type.isRtt()) {
      const auto& supers = a.getRttSupers();
      wasm::rehash(digest, supers.size());
      for (auto super : supers) {
        wasm::rehash(digest, super.type.getID());
        wasm::rehash(digest, uintptr_t(super.freshPtr.get()));
      }
      return digest;
    }
    WASM_UNREACHABLE("unexpected type");
  }
};
template<> struct hash<wasm::Literals> {
  size_t operator()(const wasm::Literals& a) const {
    auto digest = wasm::hash(a.size());
    for (const auto& lit : a) {
      wasm::rehash(digest, lit);
    }
    return digest;
  }
};

} // namespace std

#endif // wasm_literal_h
