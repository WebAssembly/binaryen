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

#include "support/hash.h"
#include "support/utilities.h"
#include "compiler-support.h"
#include "wasm-type.h"

namespace wasm {

class Literal {
public:
  Type type;

private:
  // store only integers, whose bits are deterministic. floats
  // can have their signalling bit set, for example.
  union {
    int32_t i32;
    int64_t i64;
  };

public:
  Literal() : type(Type::none), i64(0) {}
  explicit Literal(Type type) : type(type), i64(0) {}
  explicit Literal(int32_t  init) : type(Type::i32), i32(init) {}
  explicit Literal(uint32_t init) : type(Type::i32), i32(init) {}
  explicit Literal(int64_t  init) : type(Type::i64), i64(init) {}
  explicit Literal(uint64_t init) : type(Type::i64), i64(init) {}
  explicit Literal(float    init) : type(Type::f32), i32(bit_cast<int32_t>(init)) {}
  explicit Literal(double   init) : type(Type::f64), i64(bit_cast<int64_t>(init)) {}

  bool isConcrete() { return type != none; }
  bool isNull() { return type == none; }

  Literal castToF32();
  Literal castToF64();
  Literal castToI32();
  Literal castToI64();

  int32_t geti32() const { assert(type == Type::i32); return i32; }
  int64_t geti64() const { assert(type == Type::i64); return i64; }
  float   getf32() const { assert(type == Type::f32); return bit_cast<float>(i32); }
  double  getf64() const { assert(type == Type::f64); return bit_cast<double>(i64); }

  int32_t* geti32Ptr() { assert(type == Type::i32); return &i32; } // careful!

  int32_t reinterpreti32() const { assert(type == Type::f32); return i32; }
  int64_t reinterpreti64() const { assert(type == Type::f64); return i64; }
  float   reinterpretf32() const { assert(type == Type::i32); return bit_cast<float>(i32); }
  double  reinterpretf64() const { assert(type == Type::i64); return bit_cast<double>(i64); }

  int64_t getInteger() const;
  double getFloat() const;
  int64_t getBits() const;
  // Equality checks for the type and the bits, so a nan float would
  // be compared bitwise (which means that a Literal containing a nan
  // would be equal to itself, if the bits are equal).
  bool operator==(const Literal& other) const;
  bool operator!=(const Literal& other) const;

  static uint32_t NaNPayload(float f);
  static uint64_t NaNPayload(double f);
  static float setQuietNaN(float f);
  static double setQuietNaN(double f);

  static void printFloat(std::ostream &o, float f);
  static void printDouble(std::ostream& o, double d);

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
  Literal truncateToI32() const;
  Literal truncateToF32() const;

  Literal convertSToF32() const;
  Literal convertUToF32() const;
  Literal convertSToF64() const;
  Literal convertUToF64() const;

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
};

} // namespace wasm

namespace std {
template<> struct hash<wasm::Literal> {
  size_t operator()(const wasm::Literal& a) const {
    return wasm::rehash(
      uint64_t(hash<size_t>()(size_t(a.type))),
      uint64_t(hash<int64_t>()(a.getBits()))
    );
  }
};
template<> struct less<wasm::Literal> {
  bool operator()(const wasm::Literal& a, const wasm::Literal& b) const {
    if (a.type < b.type) return true;
    if (a.type > b.type) return false;
    return a.getBits() < b.getBits();
  }
};
}

#endif // wasm_literal_h
