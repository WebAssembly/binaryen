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

#ifndef wasm_support_bits_h
#define wasm_support_bits_h

#include <climits>
#include <cstdint>
#include <type_traits>

/*
 * Portable bit functions.
 *
 * Not all platforms offer fast intrinsics for these functions, and some
 * compilers require checking CPUID at runtime before using the intrinsic.
 *
 * We instead use portable and reasonably-fast implementations, while
 * avoiding implementations with large lookup tables.
 */

namespace wasm::Bits {

int popCount(uint8_t);
int popCount(uint16_t);
int popCount(uint32_t);
int popCount(uint64_t);

inline int popCount(int8_t v) { return popCount(uint8_t(v)); }
inline int popCount(int16_t v) { return popCount(uint16_t(v)); }
inline int popCount(int32_t v) { return popCount(uint32_t(v)); }
inline int popCount(int64_t v) { return popCount(uint64_t(v)); }

uint32_t bitReverse(uint32_t);

int countTrailingZeroes(uint32_t);
int countTrailingZeroes(uint64_t);

inline int countTrailingZeroes(int32_t v) {
  return countTrailingZeroes(uint32_t(v));
}
inline int countTrailingZeroes(int64_t v) {
  return countTrailingZeroes(uint64_t(v));
}

int countLeadingZeroes(uint32_t);
int countLeadingZeroes(uint64_t);

inline int countLeadingZeroes(int32_t v) {
  return countLeadingZeroes(uint32_t(v));
}
inline int countLeadingZeroes(int64_t v) {
  return countLeadingZeroes(uint64_t(v));
}

int ceilLog2(uint32_t);
int ceilLog2(uint64_t);

inline int ceilLog2(int32_t v) { return ceilLog2(uint32_t(v)); }
inline int ceilLog2(int64_t v) { return ceilLog2(uint64_t(v)); }

template<typename T> bool isPowerOf2(T v) {
  return v != 0 && (v & (v - 1)) == 0;
}

bool isPowerOf2InvertibleFloat(float);
bool isPowerOf2InvertibleFloat(double);

template<typename T, typename U> inline static T rotateLeft(T val, U count) {
  auto value = typename std::make_unsigned<T>::type(val);
  U mask = sizeof(T) * CHAR_BIT - 1;
  count &= mask;
  return (value << count) | (value >> (-count & mask));
}
template<typename T, typename U> inline static T rotateRight(T val, U count) {
  auto value = typename std::make_unsigned<T>::type(val);
  U mask = sizeof(T) * CHAR_BIT - 1;
  count &= mask;
  return (value >> count) | (value << (-count & mask));
}

uint32_t log2(uint32_t v);
uint32_t pow2(uint32_t v);

} // namespace wasm::Bits

#endif // wasm_support_bits_h
