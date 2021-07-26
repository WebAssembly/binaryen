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
#include "ir/bits.h"
#include "pretty_printing.h"
#include "support/bits.h"
#include "support/utilities.h"

namespace wasm {

template<int N> using LaneArray = std::array<Literal, N>;

Literal::Literal(Type type) : type(type) {
  if (type == Type::i31ref) {
    // i31ref is special in that it is non-nullable, so we construct with zero
    i32 = 0;
  } else {
    assert(type != Type::unreachable && !type.isNonNullable());
    if (isData()) {
      new (&gcData) std::shared_ptr<GCData>();
    } else if (type.isRtt()) {
      // Allocate a new RttSupers (with no data).
      new (&rttSupers) auto(std::make_unique<RttSupers>());
    } else {
      memset(&v128, 0, 16);
    }
  }
}

Literal::Literal(const uint8_t init[16]) : type(Type::v128) {
  memcpy(&v128, init, 16);
}

Literal::Literal(std::shared_ptr<GCData> gcData, Type type)
  : gcData(gcData), type(type) {
  // Null data is only allowed if nullable.
  assert(gcData || type.isNullable());
  // The type must be a proper type for GC data.
  assert(isData());
}

Literal::Literal(std::unique_ptr<RttSupers>&& rttSupers, Type type)
  : rttSupers(std::move(rttSupers)), type(type) {
  assert(type.isRtt());
}

Literal::Literal(const Literal& other) : type(other.type) {
  if (other.isData()) {
    new (&gcData) std::shared_ptr<GCData>(other.gcData);
    return;
  }
  if (type.isFunction()) {
    func = other.func;
    return;
  }
  if (type.isRtt()) {
    // Allocate a new RttSupers with a copy of the other's data.
    new (&rttSupers) auto(std::make_unique<RttSupers>(*other.rttSupers));
    return;
  }
  if (type.isRef()) {
    auto heapType = type.getHeapType();
    if (heapType.isBasic()) {
      switch (heapType.getBasic()) {
        case HeapType::any:
        case HeapType::ext:
        case HeapType::eq:
          return; // null
        case HeapType::i31:
          i32 = other.i32;
          return;
        case HeapType::func:
        case HeapType::data:
          WASM_UNREACHABLE("invalid type");
      }
    }
  }
  TODO_SINGLE_COMPOUND(type);
  switch (type.getBasic()) {
    case Type::i32:
    case Type::f32:
      i32 = other.i32;
      break;
    case Type::i64:
    case Type::f64:
      i64 = other.i64;
      break;
    case Type::v128:
      memcpy(&v128, other.v128, 16);
      break;
    case Type::none:
      break;
    case Type::unreachable:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
      WASM_UNREACHABLE("invalid type");
  }
}

Literal::~Literal() {
  if (isData()) {
    gcData.~shared_ptr();
  } else if (type.isRtt()) {
    rttSupers.~unique_ptr();
  } else if (type.isFunction() || type.isRef()) {
    // Nothing special to do for a function or a non-GC reference (GC data was
    // handled earlier). For references, this handles the case of (ref ? i31)
    // for example, which may or may not be basic.
  } else {
    // Basic types need no special handling.
    // TODO: change this to an assert after we figure out the underlying issue
    //       on the release builder
    //       https://github.com/WebAssembly/binaryen/issues/3459
    if (!type.isBasic()) {
      Fatal() << "~Literal on unhandled type: " << type << '\n';
    }
  }
}

Literal& Literal::operator=(const Literal& other) {
  if (this != &other) {
    this->~Literal();
    new (this) auto(other);
  }
  return *this;
}

template<typename LaneT, int Lanes>
static void extractBytes(uint8_t (&dest)[16], const LaneArray<Lanes>& lanes) {
  std::array<uint8_t, 16> bytes;
  const size_t lane_width = 16 / Lanes;
  for (size_t lane_index = 0; lane_index < Lanes; ++lane_index) {
    uint8_t bits[16];
    lanes[lane_index].getBits(bits);
    LaneT lane;
    memcpy(&lane, bits, sizeof(lane));
    for (size_t offset = 0; offset < lane_width; ++offset) {
      bytes.at(lane_index * lane_width + offset) =
        uint8_t(lane >> (8 * offset));
    }
  }
  memcpy(&dest, bytes.data(), sizeof(bytes));
}

Literal::Literal(const LaneArray<16>& lanes) : type(Type::v128) {
  extractBytes<uint8_t, 16>(v128, lanes);
}

Literal::Literal(const LaneArray<8>& lanes) : type(Type::v128) {
  extractBytes<uint16_t, 8>(v128, lanes);
}

Literal::Literal(const LaneArray<4>& lanes) : type(Type::v128) {
  extractBytes<uint32_t, 4>(v128, lanes);
}

Literal::Literal(const LaneArray<2>& lanes) : type(Type::v128) {
  extractBytes<uint64_t, 2>(v128, lanes);
}

Literals Literal::makeZeros(Type type) {
  assert(type.isConcrete());
  Literals zeroes;
  for (const auto& t : type) {
    zeroes.push_back(makeZero(t));
  }
  return zeroes;
}

Literals Literal::makeOnes(Type type) {
  assert(type.isConcrete());
  Literals units;
  for (const auto& t : type) {
    units.push_back(makeOne(t));
  }
  return units;
}

Literals Literal::makeNegOnes(Type type) {
  assert(type.isConcrete());
  Literals units;
  for (const auto& t : type) {
    units.push_back(makeNegOne(t));
  }
  return units;
}

Literal Literal::makeZero(Type type) {
  assert(type.isSingle());
  if (type.isRef()) {
    if (type == Type::i31ref) {
      return makeI31(0);
    } else {
      return makeNull(type);
    }
  } else if (type.isRtt()) {
    return Literal(type);
  } else {
    return makeFromInt32(0, type);
  }
}

Literal Literal::makeOne(Type type) {
  assert(type.isNumber());
  return makeFromInt32(1, type);
}

Literal Literal::makeNegOne(Type type) {
  assert(type.isNumber());
  return makeFromInt32(-1, type);
}

std::array<uint8_t, 16> Literal::getv128() const {
  assert(type == Type::v128);
  std::array<uint8_t, 16> ret;
  memcpy(ret.data(), v128, sizeof(ret));
  return ret;
}

std::shared_ptr<GCData> Literal::getGCData() const {
  assert(isData());
  return gcData;
}

const RttSupers& Literal::getRttSupers() const {
  assert(type.isRtt());
  return *rttSupers;
}

Literal Literal::castToF32() {
  assert(type == Type::i32);
  Literal ret(Type::f32);
  ret.i32 = i32;
  return ret;
}

Literal Literal::castToF64() {
  assert(type == Type::i64);
  Literal ret(Type::f64);
  ret.i64 = i64;
  return ret;
}

Literal Literal::castToI32() {
  assert(type == Type::f32);
  Literal ret(Type::i32);
  ret.i32 = i32;
  return ret;
}

Literal Literal::castToI64() {
  assert(type == Type::f64);
  Literal ret(Type::i64);
  ret.i64 = i64;
  return ret;
}

int64_t Literal::getInteger() const {
  switch (type.getBasic()) {
    case Type::i32:
      return i32;
    case Type::i64:
      return i64;
    default:
      abort();
  }
}

uint64_t Literal::getUnsigned() const {
  switch (type.getBasic()) {
    case Type::i32:
      return static_cast<uint32_t>(i32);
    case Type::i64:
      return i64;
    default:
      abort();
  }
}

double Literal::getFloat() const {
  switch (type.getBasic()) {
    case Type::f32:
      return getf32();
    case Type::f64:
      return getf64();
    default:
      abort();
  }
}

void Literal::getBits(uint8_t (&buf)[16]) const {
  memset(buf, 0, 16);
  switch (type.getBasic()) {
    case Type::i32:
    case Type::f32:
      memcpy(buf, &i32, sizeof(i32));
      break;
    case Type::i64:
    case Type::f64:
      memcpy(buf, &i64, sizeof(i64));
      break;
    case Type::v128:
      memcpy(buf, &v128, sizeof(v128));
      break;
    case Type::none:
    case Type::unreachable:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
      WASM_UNREACHABLE("invalid type");
  }
}

bool Literal::operator==(const Literal& other) const {
  if (type != other.type) {
    return false;
  }
  auto compareRef = [&]() {
    assert(type.isRef());
    if (isNull() || other.isNull()) {
      return isNull() == other.isNull();
    }
    if (type.isFunction()) {
      assert(func.is() && other.func.is());
      return func == other.func;
    }
    if (type.isData()) {
      return gcData == other.gcData;
    }
    // other non-null reference type literals cannot represent concrete values,
    // i.e. there is no concrete externref, anyref or eqref other than null.
    WASM_UNREACHABLE("unexpected type");
  };
  if (type.isBasic()) {
    switch (type.getBasic()) {
      case Type::none:
        return true; // special voided literal
      case Type::i32:
      case Type::f32:
      case Type::i31ref:
        return i32 == other.i32;
      case Type::i64:
      case Type::f64:
        return i64 == other.i64;
      case Type::v128:
        return memcmp(v128, other.v128, 16) == 0;
      case Type::funcref:
      case Type::externref:
      case Type::anyref:
      case Type::eqref:
      case Type::dataref:
        return compareRef();
      case Type::unreachable:
        break;
    }
  } else if (type.isRef()) {
    return compareRef();
  } else if (type.isRtt()) {
    return *rttSupers == *other.rttSupers;
  }
  WASM_UNREACHABLE("unexpected type");
}

bool Literal::operator!=(const Literal& other) const {
  return !(*this == other);
}

bool Literal::isNaN() {
  if (type == Type::f32 && std::isnan(getf32())) {
    return true;
  }
  if (type == Type::f64 && std::isnan(getf64())) {
    return true;
  }
  // TODO: SIMD?
  return false;
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

void Literal::printFloat(std::ostream& o, float f) {
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

void Literal::printVec128(std::ostream& o, const std::array<uint8_t, 16>& v) {
  o << std::hex;
  for (auto i = 0; i < 16; i += 4) {
    if (i) {
      o << " ";
    }
    o << "0x" << std::setfill('0') << std::setw(8)
      << uint32_t(v[i] | (v[i + 1] << 8) | (v[i + 2] << 16) | (v[i + 3] << 24));
  }
  o << std::dec;
}

std::ostream& operator<<(std::ostream& o, Literal literal) {
  prepareMinorColor(o);
  if (literal.type.isFunction()) {
    if (literal.isNull()) {
      o << "funcref(null)";
    } else {
      o << "funcref(" << literal.getFunc() << ")";
    }
  } else if (literal.type.isRef()) {
    if (literal.isData()) {
      auto data = literal.getGCData();
      if (data) {
        o << "[ref " << data->rtt << ' ' << data->values << ']';
      } else {
        o << "[ref null " << literal.type << ']';
      }
    } else {
      switch (literal.type.getHeapType().getBasic()) {
        case HeapType::ext:
          assert(literal.isNull() && "unexpected non-null externref literal");
          o << "externref(null)";
          break;
        case HeapType::any:
          assert(literal.isNull() && "unexpected non-null anyref literal");
          o << "anyref(null)";
          break;
        case HeapType::eq:
          assert(literal.isNull() && "unexpected non-null eqref literal");
          o << "eqref(null)";
          break;
        case HeapType::i31:
          o << "i31ref(" << literal.geti31() << ")";
          break;
        case HeapType::func:
        case HeapType::data:
          WASM_UNREACHABLE("type should have been handled above");
      }
    }
  } else if (literal.type.isRtt()) {
    o << "[rtt ";
    for (auto& super : literal.getRttSupers()) {
      o << super.type << " :> ";
      if (super.freshPtr) {
        o << " (fresh)";
      }
    }
    o << literal.type << ']';
  } else {
    TODO_SINGLE_COMPOUND(literal.type);
    switch (literal.type.getBasic()) {
      case Type::none:
        o << "?";
        break;
      case Type::i32:
        o << literal.geti32();
        break;
      case Type::i64:
        o << literal.geti64();
        break;
      case Type::f32:
        literal.printFloat(o, literal.getf32());
        break;
      case Type::f64:
        literal.printDouble(o, literal.getf64());
        break;
      case Type::v128:
        o << "i32x4 ";
        literal.printVec128(o, literal.getv128());
        break;
      case Type::funcref:
      case Type::externref:
      case Type::anyref:
      case Type::eqref:
      case Type::i31ref:
      case Type::dataref:
      case Type::unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  restoreNormalColor(o);
  return o;
}

std::ostream& operator<<(std::ostream& o, wasm::Literals literals) {
  if (literals.size() == 1) {
    return o << literals[0];
  } else {
    o << '(';
    if (literals.size() > 0) {
      o << literals[0];
    }
    for (size_t i = 1; i < literals.size(); ++i) {
      o << ", " << literals[i];
    }
    return o << ')';
  }
}

Literal Literal::countLeadingZeroes() const {
  if (type == Type::i32) {
    return Literal((int32_t)Bits::countLeadingZeroes(i32));
  }
  if (type == Type::i64) {
    return Literal((int64_t)Bits::countLeadingZeroes(i64));
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::countTrailingZeroes() const {
  if (type == Type::i32) {
    return Literal((int32_t)Bits::countTrailingZeroes(i32));
  }
  if (type == Type::i64) {
    return Literal((int64_t)Bits::countTrailingZeroes(i64));
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::popCount() const {
  if (type == Type::i32) {
    return Literal((int32_t)Bits::popCount(i32));
  }
  if (type == Type::i64) {
    return Literal((int64_t)Bits::popCount(i64));
  }
  WASM_UNREACHABLE("invalid type");
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
  if (type == Type::i32) {
    return Literal(int32_t(int8_t(geti32() & 0xFF)));
  }
  if (type == Type::i64) {
    return Literal(int64_t(int8_t(geti64() & 0xFF)));
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::extendS16() const {
  if (type == Type::i32) {
    return Literal(int32_t(int16_t(geti32() & 0xFFFF)));
  }
  if (type == Type::i64) {
    return Literal(int64_t(int16_t(geti64() & 0xFFFF)));
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::extendS32() const {
  if (type == Type::i64) {
    return Literal(int64_t(int32_t(geti64() & 0xFFFFFFFF)));
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::wrapToI32() const {
  assert(type == Type::i64);
  return Literal((int32_t)i64);
}

Literal Literal::convertSIToF32() const {
  if (type == Type::i32) {
    return Literal(float(i32));
  }
  if (type == Type::i64) {
    return Literal(float(i64));
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::convertUIToF32() const {
  if (type == Type::i32) {
    return Literal(float(uint32_t(i32)));
  }
  if (type == Type::i64) {
    return Literal(float(uint64_t(i64)));
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::convertSIToF64() const {
  if (type == Type::i32) {
    return Literal(double(i32));
  }
  if (type == Type::i64) {
    return Literal(double(i64));
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::convertUIToF64() const {
  if (type == Type::i32) {
    return Literal(double(uint32_t(i32)));
  }
  if (type == Type::i64) {
    return Literal(double(uint64_t(i64)));
  }
  WASM_UNREACHABLE("invalid type");
}

template<typename F> struct AsInt { using type = void; };
template<> struct AsInt<float> { using type = int32_t; };
template<> struct AsInt<double> { using type = int64_t; };

template<typename F, typename I, bool (*RangeCheck)(typename AsInt<F>::type)>
static Literal saturating_trunc(typename AsInt<F>::type val) {
  if (std::isnan(bit_cast<F>(val))) {
    return Literal(I(0));
  }
  if (!RangeCheck(val)) {
    if (std::signbit(bit_cast<F>(val))) {
      return Literal(std::numeric_limits<I>::min());
    } else {
      return Literal(std::numeric_limits<I>::max());
    }
  }
  return Literal(I(std::trunc(bit_cast<F>(val))));
}

Literal Literal::truncSatToSI32() const {
  if (type == Type::f32) {
    return saturating_trunc<float, int32_t, isInRangeI32TruncS>(
      Literal(*this).castToI32().geti32());
  }
  if (type == Type::f64) {
    return saturating_trunc<double, int32_t, isInRangeI32TruncS>(
      Literal(*this).castToI64().geti64());
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::truncSatToSI64() const {
  if (type == Type::f32) {
    return saturating_trunc<float, int64_t, isInRangeI64TruncS>(
      Literal(*this).castToI32().geti32());
  }
  if (type == Type::f64) {
    return saturating_trunc<double, int64_t, isInRangeI64TruncS>(
      Literal(*this).castToI64().geti64());
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::truncSatToUI32() const {
  if (type == Type::f32) {
    return saturating_trunc<float, uint32_t, isInRangeI32TruncU>(
      Literal(*this).castToI32().geti32());
  }
  if (type == Type::f64) {
    return saturating_trunc<double, uint32_t, isInRangeI32TruncU>(
      Literal(*this).castToI64().geti64());
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::truncSatToUI64() const {
  if (type == Type::f32) {
    return saturating_trunc<float, uint64_t, isInRangeI64TruncU>(
      Literal(*this).castToI32().geti32());
  }
  if (type == Type::f64) {
    return saturating_trunc<double, uint64_t, isInRangeI64TruncU>(
      Literal(*this).castToI64().geti64());
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::eqz() const {
  switch (type.getBasic()) {
    case Type::i32:
      return eq(Literal(int32_t(0)));
    case Type::i64:
      return eq(Literal(int64_t(0)));
    case Type::f32:
      return eq(Literal(float(0)));
    case Type::f64:
      return eq(Literal(double(0)));
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::neg() const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(-uint32_t(i32));
    case Type::i64:
      return Literal(-uint64_t(i64));
    case Type::f32:
      return Literal(i32 ^ 0x80000000).castToF32();
    case Type::f64:
      return Literal(int64_t(i64 ^ 0x8000000000000000ULL)).castToF64();
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("invalid type");
}

Literal Literal::abs() const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(std::abs(i32));
    case Type::i64:
      return Literal(std::abs(i64));
    case Type::f32:
      return Literal(i32 & 0x7fffffff).castToF32();
    case Type::f64:
      return Literal(int64_t(i64 & 0x7fffffffffffffffULL)).castToF64();
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("unexpected type");
}

Literal Literal::ceil() const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(std::ceil(getf32()));
    case Type::f64:
      return Literal(std::ceil(getf64()));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::floor() const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(std::floor(getf32()));
    case Type::f64:
      return Literal(std::floor(getf64()));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::trunc() const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(std::trunc(getf32()));
    case Type::f64:
      return Literal(std::trunc(getf64()));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::nearbyint() const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(std::nearbyint(getf32()));
    case Type::f64:
      return Literal(std::nearbyint(getf64()));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::sqrt() const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(std::sqrt(getf32()));
    case Type::f64:
      return Literal(std::sqrt(getf64()));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::demote() const {
  auto f64 = getf64();
  if (std::isnan(f64)) {
    return Literal(float(f64));
  }
  if (std::isinf(f64)) {
    return Literal(float(f64));
  }
  // when close to the limit, but still truncatable to a valid value, do that
  // see
  // https://github.com/WebAssembly/sexpr-wasm-prototype/blob/2d375e8d502327e814d62a08f22da9d9b6b675dc/src/wasm-interpreter.c#L247
  uint64_t bits = reinterpreti64();
  if (bits > 0x47efffffe0000000ULL && bits < 0x47effffff0000000ULL) {
    return Literal(std::numeric_limits<float>::max());
  }
  if (bits > 0xc7efffffe0000000ULL && bits < 0xc7effffff0000000ULL) {
    return Literal(-std::numeric_limits<float>::max());
  }
  // when we must convert to infinity, do that
  if (f64 < -std::numeric_limits<float>::max()) {
    return Literal(-std::numeric_limits<float>::infinity());
  }
  if (f64 > std::numeric_limits<float>::max()) {
    return Literal(std::numeric_limits<float>::infinity());
  }
  return Literal(float(getf64()));
}

// Wasm has nondeterministic rules for NaN propagation in some operations. For
// example. f32.neg is deterministic and just flips the sign, even of a NaN, but
// f32.add is nondeterministic, and if one or more of the inputs is a NaN, then
//
//  * if all NaNs are canonical NaNs, the output is some arbitrary canonical NaN
//  * otherwise the output is some arbitrary arithmetic NaN
//
// (canonical = NaN payload is 1000..000; arithmetic: 1???..???, that is, the
// high bit is 1 and all others can be 0 or 1)
//
// For many things we don't need to care, and can just do a normal C++ add for
// an f32.add, for example - the wasm rules are specified so that things like
// that just work (in order for such math to be fast). However, for our
// optimizer, it is useful to "standardize" NaNs when there is nondeterminism.
// That is, when there are multiple valid outputs, it's nice to emit the same
// one consistently, so that it doesn't look like the optimization changed
// something. In other words, if the valid output of an expression is a set of
// valid NaNs, and after optimization the output is still that same set, then
// the optimization is valid. And if the interpreter picks the same NaN in both
// cases from that identical set then nothing looks wrong to the fuzzer.
template<typename T> static Literal standardizeNaN(T result) {
  if (!std::isnan(result)) {
    return Literal(result);
  }
  // Pick a simple canonical payload, and positive.
  if (sizeof(T) == 4) {
    return Literal(Literal(uint32_t(0x7fc00000u)).reinterpretf32());
  } else if (sizeof(T) == 8) {
    return Literal(Literal(uint64_t(0x7ff8000000000000ull)).reinterpretf64());
  } else {
    WASM_UNREACHABLE("invalid float");
  }
}

Literal Literal::add(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) + uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) + uint64_t(other.i64));
    case Type::f32:
      return standardizeNaN(getf32() + other.getf32());
    case Type::f64:
      return standardizeNaN(getf64() + other.getf64());
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("unexpected type");
}

Literal Literal::sub(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) - uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) - uint64_t(other.i64));
    case Type::f32:
      return standardizeNaN(getf32() - other.getf32());
    case Type::f64:
      return standardizeNaN(getf64() - other.getf64());
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("unexpected type");
}

template<typename T> static T add_sat_s(T a, T b) {
  static_assert(std::is_signed<T>::value,
                "Trying to instantiate add_sat_s with unsigned type");
  using UT = typename std::make_unsigned<T>::type;
  UT ua = static_cast<UT>(a);
  UT ub = static_cast<UT>(b);
  UT ures = ua + ub;
  // overflow if sign of result is different from sign of a and b
  if (static_cast<T>((ures ^ ua) & (ures ^ ub)) < 0) {
    return (a < 0) ? std::numeric_limits<T>::min()
                   : std::numeric_limits<T>::max();
  }
  return static_cast<T>(ures);
}

template<typename T> static T sub_sat_s(T a, T b) {
  static_assert(std::is_signed<T>::value,
                "Trying to instantiate sub_sat_s with unsigned type");
  using UT = typename std::make_unsigned<T>::type;
  UT ua = static_cast<UT>(a);
  UT ub = static_cast<UT>(b);
  UT ures = ua - ub;
  // overflow if a and b have different signs and result and a differ in sign
  if (static_cast<T>((ua ^ ub) & (ures ^ ua)) < 0) {
    return (a < 0) ? std::numeric_limits<T>::min()
                   : std::numeric_limits<T>::max();
  }
  return static_cast<T>(ures);
}

template<typename T> static T add_sat_u(T a, T b) {
  static_assert(std::is_unsigned<T>::value,
                "Trying to instantiate add_sat_u with signed type");
  T res = a + b;
  // overflow if result is less than arguments
  return (res < a) ? std::numeric_limits<T>::max() : res;
}

template<typename T> static T sub_sat_u(T a, T b) {
  static_assert(std::is_unsigned<T>::value,
                "Trying to instantiate sub_sat_u with signed type");
  T res = a - b;
  // overflow if result is greater than a
  return (res > a) ? 0 : res;
}

Literal Literal::addSatSI8(const Literal& other) const {
  return Literal(add_sat_s<int8_t>(geti32(), other.geti32()));
}
Literal Literal::addSatUI8(const Literal& other) const {
  return Literal(add_sat_u<uint8_t>(geti32(), other.geti32()));
}
Literal Literal::addSatSI16(const Literal& other) const {
  return Literal(add_sat_s<int16_t>(geti32(), other.geti32()));
}
Literal Literal::addSatUI16(const Literal& other) const {
  return Literal(add_sat_u<uint16_t>(geti32(), other.geti32()));
}
Literal Literal::subSatSI8(const Literal& other) const {
  return Literal(sub_sat_s<int8_t>(geti32(), other.geti32()));
}
Literal Literal::subSatUI8(const Literal& other) const {
  return Literal(sub_sat_u<uint8_t>(geti32(), other.geti32()));
}
Literal Literal::subSatSI16(const Literal& other) const {
  return Literal(sub_sat_s<int16_t>(geti32(), other.geti32()));
}
Literal Literal::subSatUI16(const Literal& other) const {
  return Literal(sub_sat_u<uint16_t>(geti32(), other.geti32()));
}

Literal Literal::q15MulrSatSI16(const Literal& other) const {
  int64_t value =
    (int64_t(geti32()) * int64_t(other.geti32()) + 0x4000LL) >> 15LL;
  int64_t lower = std::numeric_limits<int16_t>::min();
  int64_t upper = std::numeric_limits<int16_t>::max();
  return Literal(int16_t(std::min(std::max(value, lower), upper)));
}

Literal Literal::mul(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) * uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) * uint64_t(other.i64));
    case Type::f32:
      return standardizeNaN(getf32() * other.getf32());
    case Type::f64:
      return standardizeNaN(getf64() * other.getf64());
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("unexpected type");
}

Literal Literal::div(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32: {
      float lhs = getf32(), rhs = other.getf32();
      float sign = std::signbit(lhs) == std::signbit(rhs) ? 0.f : -0.f;
      switch (std::fpclassify(rhs)) {
        case FP_ZERO:
          switch (std::fpclassify(lhs)) {
            case FP_NAN:
            case FP_ZERO:
              return standardizeNaN(lhs / rhs);
            case FP_NORMAL:    // fallthrough
            case FP_SUBNORMAL: // fallthrough
            case FP_INFINITE:
              return Literal(
                std::copysign(std::numeric_limits<float>::infinity(), sign));
            default:
              WASM_UNREACHABLE("invalid fp classification");
          }
        case FP_NAN:      // fallthrough
        case FP_INFINITE: // fallthrough
        case FP_NORMAL:   // fallthrough
        case FP_SUBNORMAL:
          return standardizeNaN(lhs / rhs);
        default:
          WASM_UNREACHABLE("invalid fp classification");
      }
    }
    case Type::f64: {
      double lhs = getf64(), rhs = other.getf64();
      double sign = std::signbit(lhs) == std::signbit(rhs) ? 0. : -0.;
      switch (std::fpclassify(rhs)) {
        case FP_ZERO:
          switch (std::fpclassify(lhs)) {
            case FP_NAN:
            case FP_ZERO:
              return standardizeNaN(lhs / rhs);
            case FP_NORMAL:    // fallthrough
            case FP_SUBNORMAL: // fallthrough
            case FP_INFINITE:
              return Literal(
                std::copysign(std::numeric_limits<double>::infinity(), sign));
            default:
              WASM_UNREACHABLE("invalid fp classification");
          }
        case FP_NAN:      // fallthrough
        case FP_INFINITE: // fallthrough
        case FP_NORMAL:   // fallthrough
        case FP_SUBNORMAL:
          return standardizeNaN(lhs / rhs);
        default:
          WASM_UNREACHABLE("invalid fp classification");
      }
    }
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::divS(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 / other.i32);
    case Type::i64:
      return Literal(i64 / other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::divU(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) / uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) / uint64_t(other.i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::remS(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 % other.i32);
    case Type::i64:
      return Literal(i64 % other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::remU(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) % uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) % uint64_t(other.i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::minInt(const Literal& other) const {
  return geti32() < other.geti32() ? *this : other;
}
Literal Literal::maxInt(const Literal& other) const {
  return geti32() > other.geti32() ? *this : other;
}
Literal Literal::minUInt(const Literal& other) const {
  return uint32_t(geti32()) < uint32_t(other.geti32()) ? *this : other;
}
Literal Literal::maxUInt(const Literal& other) const {
  return uint32_t(geti32()) > uint32_t(other.geti32()) ? *this : other;
}

Literal Literal::avgrUInt(const Literal& other) const {
  return Literal((geti32() + other.geti32() + 1) / 2);
}

Literal Literal::and_(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 & other.i32);
    case Type::i64:
      return Literal(i64 & other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::or_(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 | other.i32);
    case Type::i64:
      return Literal(i64 | other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::xor_(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 ^ other.i32);
    case Type::i64:
      return Literal(i64 ^ other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::shl(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32)
                     << Bits::getEffectiveShifts(other.i32, Type::i32));
    case Type::i64:
      return Literal(uint64_t(i64)
                     << Bits::getEffectiveShifts(other.i64, Type::i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::shrS(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 >> Bits::getEffectiveShifts(other.i32, Type::i32));
    case Type::i64:
      return Literal(i64 >> Bits::getEffectiveShifts(other.i64, Type::i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::shrU(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) >>
                     Bits::getEffectiveShifts(other.i32, Type::i32));
    case Type::i64:
      return Literal(uint64_t(i64) >>
                     Bits::getEffectiveShifts(other.i64, Type::i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::rotL(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(Bits::rotateLeft(uint32_t(i32), uint32_t(other.i32)));
    case Type::i64:
      return Literal(Bits::rotateLeft(uint64_t(i64), uint64_t(other.i64)));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::rotR(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(Bits::rotateRight(uint32_t(i32), uint32_t(other.i32)));
    case Type::i64:
      return Literal(Bits::rotateRight(uint64_t(i64), uint64_t(other.i64)));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::eq(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 == other.i32);
    case Type::i64:
      return Literal(i64 == other.i64);
    case Type::f32:
      return Literal(getf32() == other.getf32());
    case Type::f64:
      return Literal(getf64() == other.getf64());
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("unexpected type");
}

Literal Literal::ne(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 != other.i32);
    case Type::i64:
      return Literal(i64 != other.i64);
    case Type::f32:
      return Literal(getf32() != other.getf32());
    case Type::f64:
      return Literal(getf64() != other.getf64());
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("unexpected type");
}

Literal Literal::ltS(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 < other.i32);
    case Type::i64:
      return Literal(i64 < other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::ltU(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) < uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) < uint64_t(other.i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::lt(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(getf32() < other.getf32());
    case Type::f64:
      return Literal(getf64() < other.getf64());
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::leS(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 <= other.i32);
    case Type::i64:
      return Literal(i64 <= other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::leU(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) <= uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) <= uint64_t(other.i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::le(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(getf32() <= other.getf32());
    case Type::f64:
      return Literal(getf64() <= other.getf64());
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::gtS(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 > other.i32);
    case Type::i64:
      return Literal(i64 > other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::gtU(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) > uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) > uint64_t(other.i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::gt(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(getf32() > other.getf32());
    case Type::f64:
      return Literal(getf64() > other.getf64());
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::geS(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(i32 >= other.i32);
    case Type::i64:
      return Literal(i64 >= other.i64);
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::geU(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::i32:
      return Literal(uint32_t(i32) >= uint32_t(other.i32));
    case Type::i64:
      return Literal(uint64_t(i64) >= uint64_t(other.i64));
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::ge(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32:
      return Literal(getf32() >= other.getf32());
    case Type::f64:
      return Literal(getf64() >= other.getf64());
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::min(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32: {
      auto l = getf32(), r = other.getf32();
      if (std::isnan(l)) {
        return standardizeNaN(l);
      }
      if (std::isnan(r)) {
        return standardizeNaN(r);
      }
      if (l == r && l == 0) {
        return Literal(std::signbit(l) ? l : r);
      }
      return Literal(std::min(l, r));
    }
    case Type::f64: {
      auto l = getf64(), r = other.getf64();
      if (std::isnan(l)) {
        return standardizeNaN(l);
      }
      if (std::isnan(r)) {
        return standardizeNaN(r);
      }
      if (l == r && l == 0) {
        return Literal(std::signbit(l) ? l : r);
      }
      return Literal(std::min(l, r));
    }
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::max(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32: {
      auto l = getf32(), r = other.getf32();
      if (std::isnan(l)) {
        return standardizeNaN(l);
      }
      if (std::isnan(r)) {
        return standardizeNaN(r);
      }
      if (l == r && l == 0) {
        return Literal(std::signbit(l) ? r : l);
      }
      return Literal(std::max(l, r));
    }
    case Type::f64: {
      auto l = getf64(), r = other.getf64();
      if (std::isnan(l)) {
        return standardizeNaN(l);
      }
      if (std::isnan(r)) {
        return standardizeNaN(r);
      }
      if (l == r && l == 0) {
        return Literal(std::signbit(l) ? r : l);
      }
      return Literal(std::max(l, r));
    }
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::pmin(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32:
    case Type::f64:
      return other.lt(*this).geti32() ? other : *this;
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::pmax(const Literal& other) const {
  switch (type.getBasic()) {
    case Type::f32:
    case Type::f64:
      return this->lt(other).geti32() ? other : *this;
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

Literal Literal::copysign(const Literal& other) const {
  // operate on bits directly, to avoid signalling bit being set on a float
  switch (type.getBasic()) {
    case Type::f32:
      return Literal((i32 & 0x7fffffff) | (other.i32 & 0x80000000)).castToF32();
      break;
    case Type::f64:
      return Literal((i64 & 0x7fffffffffffffffUL) |
                     (other.i64 & 0x8000000000000000UL))
        .castToF64();
      break;
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

template<typename LaneT, int Lanes>
static LaneArray<Lanes> getLanes(const Literal& val) {
  assert(val.type == Type::v128);
  const size_t lane_width = 16 / Lanes;
  std::array<uint8_t, 16> bytes = val.getv128();
  LaneArray<Lanes> lanes;
  for (size_t lane_index = 0; lane_index < Lanes; ++lane_index) {
    LaneT lane(0);
    for (size_t offset = 0; offset < lane_width; ++offset) {
      lane |= LaneT(bytes.at(lane_index * lane_width + offset))
              << LaneT(8 * offset);
    }
    lanes.at(lane_index) = Literal(lane);
  }
  return lanes;
}

LaneArray<16> Literal::getLanesSI8x16() const {
  return getLanes<int8_t, 16>(*this);
}
LaneArray<16> Literal::getLanesUI8x16() const {
  return getLanes<uint8_t, 16>(*this);
}
LaneArray<8> Literal::getLanesSI16x8() const {
  return getLanes<int16_t, 8>(*this);
}
LaneArray<8> Literal::getLanesUI16x8() const {
  return getLanes<uint16_t, 8>(*this);
}
LaneArray<4> Literal::getLanesI32x4() const {
  return getLanes<int32_t, 4>(*this);
}
LaneArray<2> Literal::getLanesI64x2() const {
  return getLanes<int64_t, 2>(*this);
}
LaneArray<4> Literal::getLanesF32x4() const {
  auto lanes = getLanesI32x4();
  for (size_t i = 0; i < lanes.size(); ++i) {
    lanes[i] = lanes[i].castToF32();
  }
  return lanes;
}
LaneArray<2> Literal::getLanesF64x2() const {
  auto lanes = getLanesI64x2();
  for (size_t i = 0; i < lanes.size(); ++i) {
    lanes[i] = lanes[i].castToF64();
  }
  return lanes;
}

Literal Literal::shuffleV8x16(const Literal& other,
                              const std::array<uint8_t, 16>& mask) const {
  assert(type == Type::v128);
  uint8_t bytes[16];
  for (size_t i = 0; i < mask.size(); ++i) {
    bytes[i] = (mask[i] < 16) ? v128[mask[i]] : other.v128[mask[i] - 16];
  }
  return Literal(bytes);
}

template<Type::BasicType Ty, int Lanes>
static Literal splat(const Literal& val) {
  assert(val.type == Ty);
  LaneArray<Lanes> lanes;
  lanes.fill(val);
  return Literal(lanes);
}

Literal Literal::splatI8x16() const { return splat<Type::i32, 16>(*this); }
Literal Literal::splatI16x8() const { return splat<Type::i32, 8>(*this); }
Literal Literal::splatI32x4() const { return splat<Type::i32, 4>(*this); }
Literal Literal::splatI64x2() const { return splat<Type::i64, 2>(*this); }
Literal Literal::splatF32x4() const { return splat<Type::f32, 4>(*this); }
Literal Literal::splatF64x2() const { return splat<Type::f64, 2>(*this); }

Literal Literal::extractLaneSI8x16(uint8_t index) const {
  return getLanesSI8x16().at(index);
}
Literal Literal::extractLaneUI8x16(uint8_t index) const {
  return getLanesUI8x16().at(index);
}
Literal Literal::extractLaneSI16x8(uint8_t index) const {
  return getLanesSI16x8().at(index);
}
Literal Literal::extractLaneUI16x8(uint8_t index) const {
  return getLanesUI16x8().at(index);
}
Literal Literal::extractLaneI32x4(uint8_t index) const {
  return getLanesI32x4().at(index);
}
Literal Literal::extractLaneI64x2(uint8_t index) const {
  return getLanesI64x2().at(index);
}
Literal Literal::extractLaneF32x4(uint8_t index) const {
  return getLanesF32x4().at(index);
}
Literal Literal::extractLaneF64x2(uint8_t index) const {
  return getLanesF64x2().at(index);
}

template<int Lanes, LaneArray<Lanes> (Literal::*IntoLanes)() const>
static Literal
replace(const Literal& val, const Literal& other, uint8_t index) {
  LaneArray<Lanes> lanes = (val.*IntoLanes)();
  lanes.at(index) = other;
  auto ret = Literal(lanes);
  return ret;
}

Literal Literal::replaceLaneI8x16(const Literal& other, uint8_t index) const {
  return replace<16, &Literal::getLanesUI8x16>(*this, other, index);
}
Literal Literal::replaceLaneI16x8(const Literal& other, uint8_t index) const {
  return replace<8, &Literal::getLanesUI16x8>(*this, other, index);
}
Literal Literal::replaceLaneI32x4(const Literal& other, uint8_t index) const {
  return replace<4, &Literal::getLanesI32x4>(*this, other, index);
}
Literal Literal::replaceLaneI64x2(const Literal& other, uint8_t index) const {
  return replace<2, &Literal::getLanesI64x2>(*this, other, index);
}
Literal Literal::replaceLaneF32x4(const Literal& other, uint8_t index) const {
  return replace<4, &Literal::getLanesF32x4>(*this, other, index);
}
Literal Literal::replaceLaneF64x2(const Literal& other, uint8_t index) const {
  return replace<2, &Literal::getLanesF64x2>(*this, other, index);
}

template<int Lanes,
         LaneArray<Lanes> (Literal::*IntoLanes)() const,
         Literal (Literal::*UnaryOp)(void) const>
static Literal unary(const Literal& val) {
  LaneArray<Lanes> lanes = (val.*IntoLanes)();
  for (size_t i = 0; i < Lanes; ++i) {
    lanes[i] = (lanes[i].*UnaryOp)();
  }
  return Literal(lanes);
}

Literal Literal::notV128() const {
  std::array<uint8_t, 16> ones;
  ones.fill(0xff);
  return xorV128(Literal(ones.data()));
}
Literal Literal::absI8x16() const {
  return unary<16, &Literal::getLanesSI8x16, &Literal::abs>(*this);
}
Literal Literal::absI16x8() const {
  return unary<8, &Literal::getLanesSI16x8, &Literal::abs>(*this);
}
Literal Literal::absI32x4() const {
  return unary<4, &Literal::getLanesI32x4, &Literal::abs>(*this);
}
Literal Literal::absI64x2() const {
  return unary<2, &Literal::getLanesI64x2, &Literal::abs>(*this);
}
Literal Literal::negI8x16() const {
  return unary<16, &Literal::getLanesUI8x16, &Literal::neg>(*this);
}
Literal Literal::popcntI8x16() const {
  return unary<16, &Literal::getLanesUI8x16, &Literal::popCount>(*this);
}
Literal Literal::negI16x8() const {
  return unary<8, &Literal::getLanesUI16x8, &Literal::neg>(*this);
}
Literal Literal::negI32x4() const {
  return unary<4, &Literal::getLanesI32x4, &Literal::neg>(*this);
}
Literal Literal::negI64x2() const {
  return unary<2, &Literal::getLanesI64x2, &Literal::neg>(*this);
}
Literal Literal::absF32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::abs>(*this);
}
Literal Literal::negF32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::neg>(*this);
}
Literal Literal::sqrtF32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::sqrt>(*this);
}
Literal Literal::ceilF32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::ceil>(*this);
}
Literal Literal::floorF32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::floor>(*this);
}
Literal Literal::truncF32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::trunc>(*this);
}
Literal Literal::nearestF32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::nearbyint>(*this);
}
Literal Literal::absF64x2() const {
  return unary<2, &Literal::getLanesF64x2, &Literal::abs>(*this);
}
Literal Literal::negF64x2() const {
  return unary<2, &Literal::getLanesF64x2, &Literal::neg>(*this);
}
Literal Literal::sqrtF64x2() const {
  return unary<2, &Literal::getLanesF64x2, &Literal::sqrt>(*this);
}
Literal Literal::ceilF64x2() const {
  return unary<2, &Literal::getLanesF64x2, &Literal::ceil>(*this);
}
Literal Literal::floorF64x2() const {
  return unary<2, &Literal::getLanesF64x2, &Literal::floor>(*this);
}
Literal Literal::truncF64x2() const {
  return unary<2, &Literal::getLanesF64x2, &Literal::trunc>(*this);
}
Literal Literal::nearestF64x2() const {
  return unary<2, &Literal::getLanesF64x2, &Literal::nearbyint>(*this);
}
Literal Literal::truncSatToSI32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::truncSatToSI32>(*this);
}
Literal Literal::truncSatToUI32x4() const {
  return unary<4, &Literal::getLanesF32x4, &Literal::truncSatToUI32>(*this);
}
Literal Literal::convertSToF32x4() const {
  return unary<4, &Literal::getLanesI32x4, &Literal::convertSIToF32>(*this);
}
Literal Literal::convertUToF32x4() const {
  return unary<4, &Literal::getLanesI32x4, &Literal::convertUIToF32>(*this);
}

Literal Literal::anyTrueV128() const {
  auto lanes = getLanesI32x4();
  for (size_t i = 0; i < 4; ++i) {
    if (lanes[i].geti32() != 0) {
      return Literal(int32_t(1));
    }
  }
  return Literal(int32_t(0));
}

template<int Lanes, LaneArray<Lanes> (Literal::*IntoLanes)() const>
static Literal all_true(const Literal& val) {
  LaneArray<Lanes> lanes = (val.*IntoLanes)();
  for (size_t i = 0; i < Lanes; ++i) {
    if (lanes[i] == Literal::makeZero(lanes[i].type)) {
      return Literal(int32_t(0));
    }
  }
  return Literal(int32_t(1));
}

template<int Lanes, LaneArray<Lanes> (Literal::*IntoLanes)() const>
static Literal bitmask(const Literal& val) {
  uint32_t result = 0;
  LaneArray<Lanes> lanes = (val.*IntoLanes)();
  for (size_t i = 0; i < Lanes; ++i) {
    if (lanes[i].geti32() & (1 << 31)) {
      result = result | (1 << i);
    }
  }
  return Literal(result);
}

Literal Literal::allTrueI8x16() const {
  return all_true<16, &Literal::getLanesUI8x16>(*this);
}
Literal Literal::bitmaskI8x16() const {
  return bitmask<16, &Literal::getLanesSI8x16>(*this);
}
Literal Literal::allTrueI16x8() const {
  return all_true<8, &Literal::getLanesUI16x8>(*this);
}
Literal Literal::bitmaskI16x8() const {
  return bitmask<8, &Literal::getLanesSI16x8>(*this);
}
Literal Literal::allTrueI32x4() const {
  return all_true<4, &Literal::getLanesI32x4>(*this);
}
Literal Literal::bitmaskI32x4() const {
  return bitmask<4, &Literal::getLanesI32x4>(*this);
}
Literal Literal::allTrueI64x2() const {
  return all_true<2, &Literal::getLanesI64x2>(*this);
}
Literal Literal::bitmaskI64x2() const {
  uint32_t result = 0;
  LaneArray<2> lanes = getLanesI64x2();
  for (size_t i = 0; i < 2; ++i) {
    if (lanes[i].geti64() & (1ll << 63)) {
      result = result | (1 << i);
    }
  }
  return Literal(result);
}

template<int Lanes,
         LaneArray<Lanes> (Literal::*IntoLanes)() const,
         Literal (Literal::*ShiftOp)(const Literal&) const>
static Literal shift(const Literal& vec, const Literal& shift) {
  assert(shift.type == Type::i32);
  size_t lane_bits = 128 / Lanes;
  LaneArray<Lanes> lanes = (vec.*IntoLanes)();
  for (size_t i = 0; i < Lanes; ++i) {
    lanes[i] =
      (lanes[i].*ShiftOp)(Literal(int32_t(shift.geti32() % lane_bits)));
  }
  return Literal(lanes);
}

Literal Literal::shlI8x16(const Literal& other) const {
  return shift<16, &Literal::getLanesUI8x16, &Literal::shl>(*this, other);
}
Literal Literal::shrSI8x16(const Literal& other) const {
  return shift<16, &Literal::getLanesSI8x16, &Literal::shrS>(*this, other);
}
Literal Literal::shrUI8x16(const Literal& other) const {
  return shift<16, &Literal::getLanesUI8x16, &Literal::shrU>(*this, other);
}
Literal Literal::shlI16x8(const Literal& other) const {
  return shift<8, &Literal::getLanesUI16x8, &Literal::shl>(*this, other);
}
Literal Literal::shrSI16x8(const Literal& other) const {
  return shift<8, &Literal::getLanesSI16x8, &Literal::shrS>(*this, other);
}
Literal Literal::shrUI16x8(const Literal& other) const {
  return shift<8, &Literal::getLanesUI16x8, &Literal::shrU>(*this, other);
}
Literal Literal::shlI32x4(const Literal& other) const {
  return shift<4, &Literal::getLanesI32x4, &Literal::shl>(*this, other);
}
Literal Literal::shrSI32x4(const Literal& other) const {
  return shift<4, &Literal::getLanesI32x4, &Literal::shrS>(*this, other);
}
Literal Literal::shrUI32x4(const Literal& other) const {
  return shift<4, &Literal::getLanesI32x4, &Literal::shrU>(*this, other);
}
Literal Literal::shlI64x2(const Literal& other) const {
  return shift<2, &Literal::getLanesI64x2, &Literal::shl>(*this, other);
}
Literal Literal::shrSI64x2(const Literal& other) const {
  return shift<2, &Literal::getLanesI64x2, &Literal::shrS>(*this, other);
}
Literal Literal::shrUI64x2(const Literal& other) const {
  return shift<2, &Literal::getLanesI64x2, &Literal::shrU>(*this, other);
}

template<int Lanes,
         LaneArray<Lanes> (Literal::*IntoLanes)() const,
         Literal (Literal::*CompareOp)(const Literal&) const,
         typename LaneT = int32_t>
static Literal compare(const Literal& val, const Literal& other) {
  LaneArray<Lanes> lanes = (val.*IntoLanes)();
  LaneArray<Lanes> other_lanes = (other.*IntoLanes)();
  for (size_t i = 0; i < Lanes; ++i) {
    lanes[i] = (lanes[i].*CompareOp)(other_lanes[i]) == Literal(int32_t(1))
                 ? Literal(LaneT(-1))
                 : Literal(LaneT(0));
  }
  return Literal(lanes);
}

Literal Literal::eqI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesUI8x16, &Literal::eq>(*this, other);
}
Literal Literal::neI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesUI8x16, &Literal::ne>(*this, other);
}
Literal Literal::ltSI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesSI8x16, &Literal::ltS>(*this, other);
}
Literal Literal::ltUI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesUI8x16, &Literal::ltU>(*this, other);
}
Literal Literal::gtSI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesSI8x16, &Literal::gtS>(*this, other);
}
Literal Literal::gtUI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesUI8x16, &Literal::gtU>(*this, other);
}
Literal Literal::leSI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesSI8x16, &Literal::leS>(*this, other);
}
Literal Literal::leUI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesUI8x16, &Literal::leU>(*this, other);
}
Literal Literal::geSI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesSI8x16, &Literal::geS>(*this, other);
}
Literal Literal::geUI8x16(const Literal& other) const {
  return compare<16, &Literal::getLanesUI8x16, &Literal::geU>(*this, other);
}
Literal Literal::eqI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesUI16x8, &Literal::eq>(*this, other);
}
Literal Literal::neI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesUI16x8, &Literal::ne>(*this, other);
}
Literal Literal::ltSI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesSI16x8, &Literal::ltS>(*this, other);
}
Literal Literal::ltUI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesUI16x8, &Literal::ltU>(*this, other);
}
Literal Literal::gtSI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesSI16x8, &Literal::gtS>(*this, other);
}
Literal Literal::gtUI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesUI16x8, &Literal::gtU>(*this, other);
}
Literal Literal::leSI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesSI16x8, &Literal::leS>(*this, other);
}
Literal Literal::leUI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesUI16x8, &Literal::leU>(*this, other);
}
Literal Literal::geSI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesSI16x8, &Literal::geS>(*this, other);
}
Literal Literal::geUI16x8(const Literal& other) const {
  return compare<8, &Literal::getLanesUI16x8, &Literal::geU>(*this, other);
}
Literal Literal::eqI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::eq>(*this, other);
}
Literal Literal::neI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::ne>(*this, other);
}
Literal Literal::ltSI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::ltS>(*this, other);
}
Literal Literal::ltUI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::ltU>(*this, other);
}
Literal Literal::gtSI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::gtS>(*this, other);
}
Literal Literal::gtUI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::gtU>(*this, other);
}
Literal Literal::leSI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::leS>(*this, other);
}
Literal Literal::leUI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::leU>(*this, other);
}
Literal Literal::geSI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::geS>(*this, other);
}
Literal Literal::geUI32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesI32x4, &Literal::geU>(*this, other);
}
Literal Literal::eqI64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesI64x2, &Literal::eq, int64_t>(*this,
                                                                    other);
}
Literal Literal::neI64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesI64x2, &Literal::ne, int64_t>(*this,
                                                                    other);
}
Literal Literal::ltSI64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesI64x2, &Literal::ltS, int64_t>(*this,
                                                                     other);
}
Literal Literal::gtSI64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesI64x2, &Literal::gtS, int64_t>(*this,
                                                                     other);
}
Literal Literal::leSI64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesI64x2, &Literal::leS, int64_t>(*this,
                                                                     other);
}
Literal Literal::geSI64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesI64x2, &Literal::geS, int64_t>(*this,
                                                                     other);
}
Literal Literal::eqF32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesF32x4, &Literal::eq>(*this, other);
}
Literal Literal::neF32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesF32x4, &Literal::ne>(*this, other);
}
Literal Literal::ltF32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesF32x4, &Literal::lt>(*this, other);
}
Literal Literal::gtF32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesF32x4, &Literal::gt>(*this, other);
}
Literal Literal::leF32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesF32x4, &Literal::le>(*this, other);
}
Literal Literal::geF32x4(const Literal& other) const {
  return compare<4, &Literal::getLanesF32x4, &Literal::ge>(*this, other);
}
Literal Literal::eqF64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesF64x2, &Literal::eq, int64_t>(*this,
                                                                    other);
}
Literal Literal::neF64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesF64x2, &Literal::ne, int64_t>(*this,
                                                                    other);
}
Literal Literal::ltF64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesF64x2, &Literal::lt, int64_t>(*this,
                                                                    other);
}
Literal Literal::gtF64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesF64x2, &Literal::gt, int64_t>(*this,
                                                                    other);
}
Literal Literal::leF64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesF64x2, &Literal::le, int64_t>(*this,
                                                                    other);
}
Literal Literal::geF64x2(const Literal& other) const {
  return compare<2, &Literal::getLanesF64x2, &Literal::ge, int64_t>(*this,
                                                                    other);
}

template<int Lanes,
         LaneArray<Lanes> (Literal::*IntoLanes)() const,
         Literal (Literal::*BinaryOp)(const Literal&) const>
static Literal binary(const Literal& val, const Literal& other) {
  LaneArray<Lanes> lanes = (val.*IntoLanes)();
  LaneArray<Lanes> other_lanes = (other.*IntoLanes)();
  for (size_t i = 0; i < Lanes; ++i) {
    lanes[i] = (lanes[i].*BinaryOp)(other_lanes[i]);
  }
  return Literal(lanes);
}

Literal Literal::andV128(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::and_>(*this, other);
}
Literal Literal::orV128(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::or_>(*this, other);
}
Literal Literal::xorV128(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::xor_>(*this, other);
}
Literal Literal::addI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesUI8x16, &Literal::add>(*this, other);
}
Literal Literal::addSaturateSI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesUI8x16, &Literal::addSatSI8>(*this,
                                                                   other);
}
Literal Literal::addSaturateUI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesSI8x16, &Literal::addSatUI8>(*this,
                                                                   other);
}
Literal Literal::subI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesUI8x16, &Literal::sub>(*this, other);
}
Literal Literal::subSaturateSI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesUI8x16, &Literal::subSatSI8>(*this,
                                                                   other);
}
Literal Literal::subSaturateUI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesSI8x16, &Literal::subSatUI8>(*this,
                                                                   other);
}
Literal Literal::minSI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesSI8x16, &Literal::minInt>(*this, other);
}
Literal Literal::minUI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesUI8x16, &Literal::minInt>(*this, other);
}
Literal Literal::maxSI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesSI8x16, &Literal::maxInt>(*this, other);
}
Literal Literal::maxUI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesUI8x16, &Literal::maxInt>(*this, other);
}
Literal Literal::avgrUI8x16(const Literal& other) const {
  return binary<16, &Literal::getLanesUI8x16, &Literal::avgrUInt>(*this, other);
}
Literal Literal::addI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesUI16x8, &Literal::add>(*this, other);
}
Literal Literal::addSaturateSI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesUI16x8, &Literal::addSatSI16>(*this,
                                                                   other);
}
Literal Literal::addSaturateUI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesSI16x8, &Literal::addSatUI16>(*this,
                                                                   other);
}
Literal Literal::subI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesUI16x8, &Literal::sub>(*this, other);
}
Literal Literal::subSaturateSI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesUI16x8, &Literal::subSatSI16>(*this,
                                                                   other);
}
Literal Literal::subSaturateUI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesSI16x8, &Literal::subSatUI16>(*this,
                                                                   other);
}
Literal Literal::mulI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesUI16x8, &Literal::mul>(*this, other);
}
Literal Literal::minSI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesSI16x8, &Literal::minInt>(*this, other);
}
Literal Literal::minUI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesUI16x8, &Literal::minInt>(*this, other);
}
Literal Literal::maxSI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesSI16x8, &Literal::maxInt>(*this, other);
}
Literal Literal::maxUI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesUI16x8, &Literal::maxInt>(*this, other);
}
Literal Literal::avgrUI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesUI16x8, &Literal::avgrUInt>(*this, other);
}
Literal Literal::q15MulrSatSI16x8(const Literal& other) const {
  return binary<8, &Literal::getLanesSI16x8, &Literal::q15MulrSatSI16>(*this,
                                                                       other);
}
Literal Literal::addI32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::add>(*this, other);
}
Literal Literal::subI32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::sub>(*this, other);
}
Literal Literal::mulI32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::mul>(*this, other);
}
Literal Literal::minSI32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::minInt>(*this, other);
}
Literal Literal::minUI32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::minUInt>(*this, other);
}
Literal Literal::maxSI32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::maxInt>(*this, other);
}
Literal Literal::maxUI32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesI32x4, &Literal::maxUInt>(*this, other);
}
Literal Literal::addI64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesI64x2, &Literal::add>(*this, other);
}
Literal Literal::subI64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesI64x2, &Literal::sub>(*this, other);
}
Literal Literal::mulI64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesI64x2, &Literal::mul>(*this, other);
}
Literal Literal::addF32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesF32x4, &Literal::add>(*this, other);
}
Literal Literal::subF32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesF32x4, &Literal::sub>(*this, other);
}
Literal Literal::mulF32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesF32x4, &Literal::mul>(*this, other);
}
Literal Literal::divF32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesF32x4, &Literal::div>(*this, other);
}
Literal Literal::minF32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesF32x4, &Literal::min>(*this, other);
}
Literal Literal::maxF32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesF32x4, &Literal::max>(*this, other);
}
Literal Literal::pminF32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesF32x4, &Literal::pmin>(*this, other);
}
Literal Literal::pmaxF32x4(const Literal& other) const {
  return binary<4, &Literal::getLanesF32x4, &Literal::pmax>(*this, other);
}
Literal Literal::addF64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesF64x2, &Literal::add>(*this, other);
}
Literal Literal::subF64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesF64x2, &Literal::sub>(*this, other);
}
Literal Literal::mulF64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesF64x2, &Literal::mul>(*this, other);
}
Literal Literal::divF64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesF64x2, &Literal::div>(*this, other);
}
Literal Literal::minF64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesF64x2, &Literal::min>(*this, other);
}
Literal Literal::maxF64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesF64x2, &Literal::max>(*this, other);
}
Literal Literal::pminF64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesF64x2, &Literal::pmin>(*this, other);
}
Literal Literal::pmaxF64x2(const Literal& other) const {
  return binary<2, &Literal::getLanesF64x2, &Literal::pmax>(*this, other);
}

Literal Literal::dotSI16x8toI32x4(const Literal& other) const {
  LaneArray<8> lhs = getLanesSI16x8();
  LaneArray<8> rhs = other.getLanesSI16x8();
  LaneArray<4> result;
  for (size_t i = 0; i < 4; ++i) {
    result[i] = Literal(lhs[i * 2].geti32() * rhs[i * 2].geti32() +
                        lhs[i * 2 + 1].geti32() * rhs[i * 2 + 1].geti32());
  }
  return Literal(result);
}

Literal Literal::bitselectV128(const Literal& left,
                               const Literal& right) const {
  return andV128(left).orV128(notV128().andV128(right));
}

template<typename T> struct TwiceWidth {};
template<> struct TwiceWidth<int8_t> { using type = int16_t; };
template<> struct TwiceWidth<int16_t> { using type = int32_t; };

template<typename T>
Literal saturating_narrow(
  typename TwiceWidth<typename std::make_signed<T>::type>::type val) {
  using WideT = typename TwiceWidth<typename std::make_signed<T>::type>::type;
  if (val > WideT(std::numeric_limits<T>::max())) {
    val = std::numeric_limits<T>::max();
  } else if (val < WideT(std::numeric_limits<T>::min())) {
    val = std::numeric_limits<T>::min();
  }
  return Literal(int32_t(val));
}

template<size_t Lanes,
         typename T,
         LaneArray<Lanes / 2> (Literal::*IntoLanes)() const>
Literal narrow(const Literal& low, const Literal& high) {
  LaneArray<Lanes / 2> lowLanes = (low.*IntoLanes)();
  LaneArray<Lanes / 2> highLanes = (high.*IntoLanes)();
  LaneArray<Lanes> result;
  for (size_t i = 0; i < Lanes / 2; ++i) {
    result[i] = saturating_narrow<T>(lowLanes[i].geti32());
    result[Lanes / 2 + i] = saturating_narrow<T>(highLanes[i].geti32());
  }
  return Literal(result);
}

Literal Literal::narrowSToVecI8x16(const Literal& other) const {
  return narrow<16, int8_t, &Literal::getLanesSI16x8>(*this, other);
}
Literal Literal::narrowUToVecI8x16(const Literal& other) const {
  return narrow<16, uint8_t, &Literal::getLanesSI16x8>(*this, other);
}
Literal Literal::narrowSToVecI16x8(const Literal& other) const {
  return narrow<8, int16_t, &Literal::getLanesI32x4>(*this, other);
}
Literal Literal::narrowUToVecI16x8(const Literal& other) const {
  return narrow<8, uint16_t, &Literal::getLanesI32x4>(*this, other);
}

enum class LaneOrder { Low, High };

template<size_t Lanes, typename LaneFrom, typename LaneTo, LaneOrder Side>
Literal extend(const Literal& vec) {
  LaneArray<Lanes* 2> lanes = getLanes<LaneFrom, Lanes * 2>(vec);
  LaneArray<Lanes> result;
  for (size_t i = 0; i < Lanes; ++i) {
    size_t idx = (Side == LaneOrder::Low) ? i : i + Lanes;
    result[i] = Literal((LaneTo)(LaneFrom)lanes[idx].geti32());
  }
  return Literal(result);
}

Literal Literal::extendLowSToVecI16x8() const {
  return extend<8, int8_t, int16_t, LaneOrder::Low>(*this);
}
Literal Literal::extendHighSToVecI16x8() const {
  return extend<8, int8_t, int16_t, LaneOrder::High>(*this);
}
Literal Literal::extendLowUToVecI16x8() const {
  return extend<8, uint8_t, uint16_t, LaneOrder::Low>(*this);
}
Literal Literal::extendHighUToVecI16x8() const {
  return extend<8, uint8_t, uint16_t, LaneOrder::High>(*this);
}
Literal Literal::extendLowSToVecI32x4() const {
  return extend<4, int16_t, int32_t, LaneOrder::Low>(*this);
}
Literal Literal::extendHighSToVecI32x4() const {
  return extend<4, int16_t, int32_t, LaneOrder::High>(*this);
}
Literal Literal::extendLowUToVecI32x4() const {
  return extend<4, uint16_t, uint32_t, LaneOrder::Low>(*this);
}
Literal Literal::extendHighUToVecI32x4() const {
  return extend<4, uint16_t, uint32_t, LaneOrder::High>(*this);
}

Literal Literal::extMulLowSI16x8(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulHighSI16x8(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulLowUI16x8(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulHighUI16x8(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulLowSI32x4(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulHighSI32x4(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulLowUI32x4(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulHighUI32x4(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulLowSI64x2(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulHighSI64x2(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulLowUI64x2(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}
Literal Literal::extMulHighUI64x2(const Literal& other) const {
  WASM_UNREACHABLE("TODO: implement SIMD extending multiplications");
}

Literal Literal::convertLowSToVecF64x2() const {
  return extend<2, int32_t, double, LaneOrder::Low>(*this);
}
Literal Literal::convertLowUToVecF64x2() const {
  return extend<2, uint32_t, double, LaneOrder::Low>(*this);
}

template<int Lanes,
         LaneArray<Lanes> (Literal::*IntoLanes)() const,
         Literal (Literal::*UnaryOp)(void) const>
static Literal unary_zero(const Literal& val) {
  LaneArray<Lanes> lanes = (val.*IntoLanes)();
  for (size_t i = 0; i < Lanes; ++i) {
    lanes[i] = (lanes[i].*UnaryOp)();
  }
  for (size_t i = Lanes; i < Lanes; ++i) {
    lanes[i] = Literal::makeZero(lanes[0].type);
  }
  return Literal(lanes);
}

Literal Literal::truncSatZeroSToVecI32x4() const {
  return unary_zero<2, &Literal::getLanesF64x2, &Literal::truncSatToSI32>(*this);
}
Literal Literal::truncSatZeroUToVecI32x4() const {
  return unary_zero<2, &Literal::getLanesF64x2, &Literal::truncSatToUI32>(*this);
}

Literal Literal::demoteZeroToVecF32x4() const { WASM_UNREACHABLE("TODO:"); }
Literal Literal::promoteLowToVecF64x2() const { WASM_UNREACHABLE("TODO:"); }

Literal Literal::swizzleVec8x16(const Literal& other) const {
  auto lanes = getLanesUI8x16();
  auto indices = other.getLanesUI8x16();
  LaneArray<16> result;
  for (size_t i = 0; i < 16; ++i) {
    size_t index = indices[i].geti32();
    result[i] = index >= 16 ? Literal(int32_t(0)) : lanes[index];
  }
  return Literal(result);
}

bool Literal::isSubRtt(const Literal& other) const {
  assert(type.isRtt() && other.type.isRtt());
  // For this literal to be a sub-rtt of the other rtt, the supers must be a
  // superset. That is, if other is a->b->c then we should be a->b->c as well
  // with possibly ->d->.. added. The rttSupers array represents those chains,
  // but only the supers, which means the last item in the chain is simply the
  // type of the literal.
  const auto& supers = getRttSupers();
  const auto& otherSupers = other.getRttSupers();
  if (otherSupers.size() > supers.size()) {
    return false;
  }
  for (Index i = 0; i < otherSupers.size(); i++) {
    if (supers[i] != otherSupers[i]) {
      return false;
    }
  }
  // If we have more supers than other, compare that extra super. Otherwise,
  // we have the same amount of supers, and must be completely identical to
  // other.
  if (otherSupers.size() < supers.size()) {
    return other.type == supers[otherSupers.size()].type;
  } else {
    return other.type == type;
  }
}

} // namespace wasm
