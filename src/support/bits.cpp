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

#include "support/bits.h"
#include "../compiler-support.h"
#include "support/utilities.h"

#ifdef _MSC_VER
#include <intrin.h>
#endif

namespace wasm::Bits {

int popCount(uint8_t v) {
  // Small table lookup.
  static const uint8_t tbl[32] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2,
                                  3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3,
                                  3, 4, 2, 3, 3, 4, 3, 4, 4, 5};
  return tbl[v & 0xf] + tbl[v >> 4];
}

int popCount(uint16_t v) {
#if __has_builtin(__builtin_popcount) || defined(__GNUC__)
  return __builtin_popcount(v);
#else
  return popCount((uint8_t)(v & 0xFF)) + popCount((uint8_t)(v >> 8));
#endif
}

int popCount(uint32_t v) {
#if __has_builtin(__builtin_popcount) || defined(__GNUC__)
  return __builtin_popcount(v);
#else
  // See Stanford bithacks, counting bits set in parallel, "best method":
  // http://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
  v = v - ((v >> 1) & 0x55555555);
  v = (v & 0x33333333) + ((v >> 2) & 0x33333333);
  return (((v + (v >> 4)) & 0xF0F0F0F) * 0x1010101) >> 24;
#endif
}

int popCount(uint64_t v) {
#if __has_builtin(__builtin_popcount) || defined(__GNUC__)
  return __builtin_popcountll(v);
#else
  return popCount((uint32_t)v) + popCount((uint32_t)(v >> 32));
#endif
}

uint32_t bitReverse(uint32_t v) {
  // See Hacker's Delight, first edition, figure 7-1.
  v = ((v & 0x55555555) << 1) | ((v >> 1) & 0x55555555);
  v = ((v & 0x33333333) << 2) | ((v >> 2) & 0x33333333);
  v = ((v & 0x0F0F0F0F) << 4) | ((v >> 4) & 0x0F0F0F0F);
  v = (v << 24) | ((v & 0xFF00) << 8) | ((v >> 8) & 0xFF00) | (v >> 24);
  return v;
}

int countTrailingZeroes(uint32_t v) {
  if (v == 0) {
    return 32;
  }
#if __has_builtin(__builtin_ctz) || defined(__GNUC__)
  return __builtin_ctz(v);
#elif defined(_MSC_VER)
  unsigned long count;
  _BitScanForward(&count, v);
  return (int)count;
#else
  // See Stanford bithacks, count the consecutive zero bits (trailing) on the
  // right with multiply and lookup:
  // http://graphics.stanford.edu/~seander/bithacks.html#ZerosOnRightMultLookup
  static const uint8_t tbl[32] = {0,  1,  28, 2,  29, 14, 24, 3,  30, 22, 20,
                                  15, 25, 17, 4,  8,  31, 27, 13, 23, 21, 19,
                                  16, 7,  26, 12, 18, 6,  11, 5,  10, 9};
  return (int)tbl[((uint32_t)((v & -v) * 0x077CB531U)) >> 27];
#endif
}

int countTrailingZeroes(uint64_t v) {
  if (v == 0) {
    return 64;
  }
#if __has_builtin(__builtin_ctzll) || defined(__GNUC__)
  return __builtin_ctzll(v);
#elif defined(_MSC_VER) && defined(_M_X64)
  unsigned long count;
  _BitScanForward64(&count, v);
  return (int)count;
#else
  return (uint32_t)v ? countTrailingZeroes((uint32_t)v)
                     : 32 + countTrailingZeroes((uint32_t)(v >> 32));
#endif
}

int countLeadingZeroes(uint32_t v) {
  if (v == 0) {
    return 32;
  }
#if __has_builtin(__builtin_clz) || defined(__GNUC__)
  return __builtin_clz(v);
#elif defined(_MSC_VER)
  unsigned long count;
  _BitScanReverse(&count, v);
  // BitScanReverse gives the bit position (0 for the LSB, then 1, etc.) of the
  // first bit that is 1, when looking from the MSB. To count leading zeros, we
  // need to adjust that.
  return 31 - int(count);
#else
  // See Stanford bithacks, find the log base 2 of an N-bit integer in
  // O(lg(N)) operations with multiply and lookup:
  // http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogDeBruijn
  static const uint8_t tbl[32] = {31, 22, 30, 21, 18, 10, 29, 2,  20, 17, 15,
                                  13, 9,  6,  28, 1,  23, 19, 11, 3,  16, 14,
                                  7,  24, 12, 4,  8,  25, 5,  26, 27, 0};
  v = v | (v >> 1);
  v = v | (v >> 2);
  v = v | (v >> 4);
  v = v | (v >> 8);
  v = v | (v >> 16);
  return (int)tbl[((uint32_t)(v * 0x07C4ACDDU)) >> 27];
#endif
}

int countLeadingZeroes(uint64_t v) {
  if (v == 0) {
    return 64;
  }
#if __has_builtin(__builtin_clzll) || defined(__GNUC__)
  return __builtin_clzll(v);
#elif defined(_MSC_VER) && defined(_M_X64)
  unsigned long count;
  _BitScanReverse64(&count, v);
  return 63 - int(count);
#else
  return v >> 32 ? countLeadingZeroes((uint32_t)(v >> 32))
                 : 32 + countLeadingZeroes((uint32_t)v);
#endif
}

int ceilLog2(uint32_t v) { return 32 - countLeadingZeroes(v - 1); }

int ceilLog2(uint64_t v) { return 64 - countLeadingZeroes(v - 1); }

bool isPowerOf2InvertibleFloat(float v) {
  // Power of two floating points should have zero as their significands,
  // so here we just mask the exponent range of "v" and compare it with the
  // unmasked input value. If they are equal, our value is a power of
  // two. Also, we reject all values which are less than the minimal possible
  // power of two or greater than the maximum possible power of two.
  // We check values only with exponent in more limited ranges
  // [-126..+126] for floats and [-1022..+1022] for doubles for avoiding
  // overflows and reject NaNs, infinity and denormals. We also reject
  // "asymmetric exponents", like +1023, because the range of
  // (non-NaN, non-infinity) values is -1022..+1023, and it is convenient in
  // optimizations to depend on being able to invert a power of two without
  // losing precision.
  // This function used in OptimizeInstruction pass.
  const uint32_t MIN_POT = 0x01U << 23;  // 0x1p-126
  const uint32_t MAX_POT = 0xFDU << 23;  // 0x1p+126
  const uint32_t EXP_MASK = 0xFFU << 23; // mask only exponent
  const uint32_t SIGN_MASK = ~0U >> 1;   // mask everything except sign
  auto u = bit_cast<uint32_t>(v) & SIGN_MASK;
  return u >= MIN_POT && u <= MAX_POT && (u & EXP_MASK) == u;
}

bool isPowerOf2InvertibleFloat(double v) {
  // See isPowerOf2InvertibleFloat(float)
  const uint64_t MIN_POT = 0x001ULL << 52;  // 0x1p-1022
  const uint64_t MAX_POT = 0x7FDULL << 52;  // 0x1p+1022
  const uint64_t EXP_MASK = 0x7FFULL << 52; // mask only exponent
  const uint64_t SIGN_MASK = ~0ULL >> 1;    // mask everything except sign
  auto u = bit_cast<uint64_t>(v) & SIGN_MASK;
  return u >= MIN_POT && u <= MAX_POT && (u & EXP_MASK) == u;
}

uint32_t log2(uint32_t v) {
  if (!isPowerOf2(v)) {
    WASM_UNREACHABLE("value should be a power of two");
  }
  return 31 - countLeadingZeroes(v);
}

uint32_t pow2(uint32_t v) { return v < 32 ? 1 << v : 0; }

} // namespace wasm::Bits
