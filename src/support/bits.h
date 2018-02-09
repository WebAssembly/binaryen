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
 *
 * TODO: The convention here should be changed PopCount => popCount,
 *       initial lowercase, to match the rest of the codebase.
 */

namespace wasm {

template<typename T> int PopCount(T);
template<typename T> uint32_t BitReverse(T);
template<typename T> int CountTrailingZeroes(T);
template<typename T> int CountLeadingZeroes(T);

#ifndef wasm_support_bits_definitions
// The template specializations are provided elsewhere.
extern template int PopCount(uint8_t);
extern template int PopCount(uint16_t);
extern template int PopCount(uint32_t);
extern template int PopCount(uint64_t);
extern template uint32_t BitReverse(uint32_t);
extern template int CountTrailingZeroes(uint32_t);
extern template int CountTrailingZeroes(uint64_t);
extern template int CountLeadingZeroes(uint32_t);
extern template int CountLeadingZeroes(uint64_t);
#endif

// Convenience signed -> unsigned. It usually doesn't make much sense to use bit
// functions on signed types.
template <typename T>
int PopCount(T v) {
  return PopCount(typename std::make_unsigned<T>::type(v));
}
template <typename T>
int CountTrailingZeroes(T v) {
  return CountTrailingZeroes(typename std::make_unsigned<T>::type(v));
}
template <typename T>
int CountLeadingZeroes(T v) {
  return CountLeadingZeroes(typename std::make_unsigned<T>::type(v));
}
template <typename T>
bool IsPowerOf2(T v) {
  return v != 0 && PopCount(v) == 1;
}

template <typename T, typename U>
inline static T RotateLeft(T val, U count) {
  T mask = sizeof(T) * CHAR_BIT - 1;
  count &= mask;
  return (val << count) | (val >> (-count & mask));
}
template <typename T, typename U>
inline static T RotateRight(T val, U count) {
  T mask = sizeof(T) * CHAR_BIT - 1;
  count &= mask;
  return (val >> count) | (val << (-count & mask));
}

extern uint32_t Log2(uint32_t v);
extern uint32_t Pow2(uint32_t v);

}  // namespace wasm

#endif  // wasm_support_bits_h
