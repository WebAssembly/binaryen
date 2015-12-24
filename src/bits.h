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

#ifndef wasm_bits_h
#define wasm_bits_h

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

namespace wasm {

// Only the specialized templates should be instantiated, getting
// a linker error with these functions means an unsupported type was used.

template<typename T> inline int PopCount(T /* v */);
template<typename T> inline T BitReverse(T /* v */);
template<typename T> inline int CountTrailingZeroes(T /* v */);
template<typename T> inline int CountLeadingZeroes(T /* v */);

// Convenience signed -> unsigned. It usually doesn't make much sense to use bit
// functions on signed types.
template <typename T> inline int PopCount(T v) {
  return PopCount(typename std::make_unsigned<T>::type(v));
}
template <typename T> inline int CountTrailingZeroes(T v) {
  return CountTrailingZeroes(typename std::make_unsigned<T>::type(v));
}
template <typename T> inline int CountLeadingZeroes(T v) {
  return CountLeadingZeroes(typename std::make_unsigned<T>::type(v));
}

// Implementations for the above templates.

template<> inline int PopCount<uint8_t>(uint8_t v) {
  // Small table lookup.
  static const uint8_t tbl[32] = {
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5
  };
  return tbl[v & 0xf] + tbl[v >> 4];
}
template<> inline int PopCount<uint16_t>(uint16_t v) {
  return PopCount<uint8_t>(v & 0xff) + PopCount<uint8_t>(v >> 8);
}
template<> inline int PopCount<uint32_t>(uint32_t v) {
  // See Stanford bithacks, counting bits set in parallel, "best method":
  // http://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
  v = v - ((v >> 1) & 0x55555555);
  v = (v & 0x33333333) + ((v >> 2) & 0x33333333);
  return (((v + (v >> 4)) & 0xF0F0F0F) * 0x1010101) >> 24;
}
template<> inline int PopCount<uint64_t>(uint64_t v) {
  return PopCount<uint32_t>((uint32_t)v) + PopCount<uint32_t>(v >> 32);
}

template<> inline uint32_t BitReverse<uint32_t>(uint32_t v) {
  // See Hacker's Delight, first edition, figure 7-1.
  v = ((v & 0x55555555) << 1) | ((v >> 1) & 0x55555555);
  v = ((v & 0x33333333) << 2) | ((v >> 2) & 0x33333333);
  v = ((v & 0x0F0F0F0F) << 4) | ((v >> 4) & 0x0F0F0F0F);
  v = (v << 24) | ((v & 0xFF00) << 8) |
      ((v >> 8) & 0xFF00) | (v >> 24);
  return v;
}

template<> inline int CountTrailingZeroes<uint32_t>(uint32_t v) {
  // See Stanford bithacks, count the consecutive zero bits (trailing) on the
  // right with multiply and lookup:
  // http://graphics.stanford.edu/~seander/bithacks.html#ZerosOnRightMultLookup
  static const uint8_t tbl[32] = {
    0,   1, 28,  2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17,  4, 8,
    31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18,  6, 11,  5, 10, 9
  };
  return v ?
      (int)tbl[((uint32_t)((v & -(int32_t)v) * 0x077CB531U)) >> 27] :
      32;
}

template<> inline int CountTrailingZeroes<uint64_t>(uint64_t v) {
  return (uint32_t)v ? CountTrailingZeroes<uint32_t>(v)
                     : 32 + CountTrailingZeroes<uint32_t>(v >> 32);
}

template<> inline int CountLeadingZeroes<uint32_t>(uint32_t v) {
  // See Stanford bithacks, find the log base 2 of an N-bit integer in
  // O(lg(N)) operations with multiply and lookup:
  // http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogDeBruijn
  static const uint8_t tbl[32] = {
    31, 22, 30, 21, 18, 10, 29,  2, 20, 17, 15, 13, 9,  6, 28, 1,
    23, 19, 11,  3, 16, 14,  7, 24, 12,  4,  8, 25, 5, 26, 27, 0
  };
  v = v | (v >>  1);
  v = v | (v >>  2);
  v = v | (v >>  4);
  v = v | (v >>  8);
  v = v | (v >> 16);
  return v ?
      (int)tbl[((uint32_t)(v * 0x07C4ACDDU)) >> 27] :
      32;
}

template<> inline int CountLeadingZeroes<uint64_t>(uint64_t v) {
  return v >> 32 ? CountLeadingZeroes<uint32_t>(v >> 32)
                 : 32 + CountLeadingZeroes<uint32_t>(v);
}

} // namespace wasm

#endif // wasm_bits_h
