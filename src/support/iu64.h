/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_support_i65_h
#define wasm_support_i65_h

#include <cstdint>
#include <iostream>
#include <limits>

namespace wasm {

// An integer capable of representing numbers in the combined range of 32 and
// 64-bit integers, both signed and unsigned. That is, in the range
//
//  std::numeric_limits<int64_t>::min() .. std::numeric_limits<uint64_t>::max()
//
// This is basically an i64 combined with a u64 in terms of range, hence "IU64".
struct IU64 {
  // A 64-bit payload with an extra 65th sign bit.
  uint64_t value = 0;
  bool negative = false;

  constexpr IU64() = default;

  // Unsigned values are simple.
  constexpr IU64(uint32_t x) : value(x) {}
  constexpr IU64(uint64_t x) : value(x) {}

  // Signed values need to be checked for being negative.
  constexpr IU64(int32_t x) {
    if (x >= 0) {
      value = x;
    } else {
      negative = true;
      value = -int64_t(x);
    }
  }
  constexpr IU64(int64_t x) {
    if (x >= 0) {
      value = x;
    } else {
      negative = true;

      // One does not simply negate MIN_INT64.
      if (x == std::numeric_limits<int64_t>::min()) {
        value = uint64_t(1) << 63;
      } else {
        value = -int64_t(x);
      }
    }
  }

  constexpr bool operator==(const IU64& other) const {
    return value == other.value && negative == other.negative;
  }
  constexpr bool operator!=(const IU64& other) const {
    return !(*this == other);
  }

  constexpr bool operator<(const IU64& other) const {
    if (negative) {
      if (other.negative) {
        // Both negative; we are smaller if absolute value is larger.
        return value > other.value;
      } else {
        // Only we are negative, so we are smaller.
        return true;
      }
    } else {
      if (other.negative) {
        // Only the other is negative, so we are larger.
        return false;
      } else {
        // Both positive; we are smaller if absolute value is smaller.
        return value < other.value;
      }
    }
  }
  constexpr bool operator<=(const IU64& other) const {
    return *this < other || *this == other;
  }
  constexpr bool operator>(const IU64& other) const { return !(*this <= other); }
  constexpr bool operator>=(const IU64& other) const { return !(*this < other); }
};

inline std::ostream& operator<<(std::ostream& os, const IU64& x) {
  if (x.negative) {
    os << '-';
  }
  return os << x.value;
}

} // namespace wasm

namespace std {

template<> class numeric_limits<wasm::IU64> {
public:
  static constexpr bool is_specialized = true;
  static constexpr bool is_signed = true;
  static constexpr bool is_integer = true;
  static constexpr bool is_exact = true;
  static constexpr bool has_infinity = false;
  static constexpr bool has_quiet_NaN = false;
  static constexpr bool has_signaling_NaN = false;
  static constexpr float_denorm_style has_denorm = denorm_absent;
  static constexpr bool has_denorm_loss = false;
  static constexpr float_round_style round_style = round_toward_zero;
  static constexpr bool is_iec559 = false;
  static constexpr bool is_bounded = true;
  static constexpr bool is_modulo = false;
  static constexpr int digits = 65;
  static constexpr int digits10 = 19;
  static constexpr int max_digits10 = 0;
  static constexpr int radix = 2;
  static constexpr int min_exponent = 0;
  static constexpr int min_exponent10 = 0;
  static constexpr int max_exponent = 0;
  static constexpr int max_exponent10 = 0;
  static constexpr bool traps = false;
  static constexpr bool tinyness_before = false;

  static constexpr wasm::IU64 min() noexcept {
    return wasm::IU64(std::numeric_limits<int64_t>::min());
  }
  static constexpr wasm::IU64 lowest() noexcept { return min(); }
  static constexpr wasm::IU64 max() noexcept {
    return wasm::IU64(std::numeric_limits<uint64_t>::max());
  }
};

} // namespace std

#endif // wasm_support_i65_h
