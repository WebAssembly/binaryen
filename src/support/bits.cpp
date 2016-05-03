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

#define wasm_support_bits_definitions
#include "../compiler-support.h"
#include "support/bits.h"

namespace wasm {

template<>
int PopCount<uint8_t>(uint8_t v) {
  // Small table lookup.
  static const uint8_t tbl[32] = {
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5
  };
  return tbl[v & 0xf] + tbl[v >> 4];
}

template<>
int PopCount<uint16_t>(uint16_t v) {
  return PopCount((uint8_t)(v & 0xff)) + PopCount((uint8_t)(v >> 8));
}

template<>
int PopCount<uint32_t>(uint32_t v) {
  // See Stanford bithacks, counting bits set in parallel, "best method":
  // http://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
  v = v - ((v >> 1) & 0x55555555);
  v = (v & 0x33333333) + ((v >> 2) & 0x33333333);
  return (((v + (v >> 4)) & 0xF0F0F0F) * 0x1010101) >> 24;
}

template<>
int PopCount<uint64_t>(uint64_t v) {
  return PopCount((uint32_t)v) + PopCount((uint32_t)(v >> 32));
}

template<>
uint32_t BitReverse<uint32_t>(uint32_t v) {
  // See Hacker's Delight, first edition, figure 7-1.
  v = ((v & 0x55555555) << 1) | ((v >> 1) & 0x55555555);
  v = ((v & 0x33333333) << 2) | ((v >> 2) & 0x33333333);
  v = ((v & 0x0F0F0F0F) << 4) | ((v >> 4) & 0x0F0F0F0F);
  v = (v << 24) | ((v & 0xFF00) << 8) | ((v >> 8) & 0xFF00) | (v >> 24);
  return v;
}

template<>
int CountTrailingZeroes<uint32_t>(uint32_t v) {
  // See Stanford bithacks, count the consecutive zero bits (trailing) on the
  // right with multiply and lookup:
  // http://graphics.stanford.edu/~seander/bithacks.html#ZerosOnRightMultLookup
  static const uint8_t tbl[32] = {
    0,   1, 28,  2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17,  4, 8,
    31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18,  6, 11,  5, 10, 9
  };
  return v ? (int)tbl[((uint32_t)((v & -v) * 0x077CB531U)) >> 27] : 32;
}

template<>
int CountTrailingZeroes<uint64_t>(uint64_t v) {
  return (uint32_t)v ? CountTrailingZeroes((uint32_t)v)
                     : 32 + CountTrailingZeroes((uint32_t)(v >> 32));
}

template<>
int CountLeadingZeroes<uint32_t>(uint32_t v) {
  // See Stanford bithacks, find the log base 2 of an N-bit integer in
  // O(lg(N)) operations with multiply and lookup:
  // http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogDeBruijn
  static const uint8_t tbl[32] = {
    31, 22, 30, 21, 18, 10, 29,  2, 20, 17, 15, 13, 9,  6, 28, 1,
    23, 19, 11,  3, 16, 14,  7, 24, 12,  4,  8, 25, 5, 26, 27, 0
  };
  v = v | (v >> 1);
  v = v | (v >> 2);
  v = v | (v >> 4);
  v = v | (v >> 8);
  v = v | (v >> 16);
  return v ? (int)tbl[((uint32_t)(v * 0x07C4ACDDU)) >> 27] : 32;
}

template<>
int CountLeadingZeroes<uint64_t>(uint64_t v) {
  return v >> 32 ? CountLeadingZeroes((uint32_t)(v >> 32))
                 : 32 + CountLeadingZeroes((uint32_t)v);
}

uint32_t Log2(uint32_t v) {
  switch (v) {
    default: WASM_UNREACHABLE();
    case 1: return 0;
    case 2: return 1;
    case 4: return 2;
    case 8: return 3;
    case 16: return 4;
    case 32: return 5;
  }
}

uint32_t Pow2(uint32_t v) {
  switch (v) {
    default: WASM_UNREACHABLE();
    case 0: return 1;
    case 1: return 2;
    case 2: return 4;
    case 3: return 8;
    case 4: return 16;
    case 5: return 32;
  }
}

} // namespace wasm
