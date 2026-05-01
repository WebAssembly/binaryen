// Copyright 2026 WebAssembly Community Group participants
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "support/int128.h"

namespace wasm {

#ifdef __SIZEOF_INT128__

Int128 mul_wide_s(uint64_t lhs, uint64_t rhs) {
  __int128 result = static_cast<__int128>(static_cast<int64_t>(lhs)) *
                    static_cast<__int128>(static_cast<int64_t>(rhs));
  return {static_cast<uint64_t>(result >> 64), static_cast<uint64_t>(result)};
}

Int128 mul_wide_u(uint64_t lhs, uint64_t rhs) {
  unsigned __int128 result =
    static_cast<unsigned __int128>(lhs) * static_cast<unsigned __int128>(rhs);
  return {static_cast<uint64_t>(result >> 64), static_cast<uint64_t>(result)};
}

#else

Int128 mul_wide_s(uint64_t lhs, uint64_t rhs) {
  return detail::mul_wide_s_fallback(lhs, rhs);
}

Int128 mul_wide_u(uint64_t lhs, uint64_t rhs) {
  return detail::mul_wide_u_fallback(lhs, rhs);
}

#endif

namespace detail {

Int128 mul_wide_s_fallback(uint64_t lhs, uint64_t rhs) {
  auto [high, low] = mul_wide_u_fallback(lhs, rhs);

  // If lhs is negative, then it looks like 2**64 is added to its unsigned value
  // so we computed
  //   (lhs + 2**64) * rhs
  // = lhs * rhs + 2**64 * rhs
  // We need to subtract 2**64 * rhs, so just subtract rhs directly from the
  // high bits.
  //
  // If lhs AND rhs are negative then we computed
  //   (lhs + 2**64) * (rhs + 2**64)
  // = lhs * rhs + 2**64 * rhs + 2**64 * lhs + 2**128
  // The last term overflowed and had no effect, so it's enough to do the two
  // subtractions in the two different branches.
  if (static_cast<int64_t>(lhs) < 0) {
    high -= rhs;
  }
  if (static_cast<int64_t>(rhs) < 0) {
    high -= lhs;
  }

  return {high, low};
}

Int128 mul_wide_u_fallback(uint64_t lhs, uint64_t rhs) {
  // Decompose lhs and rhs into 4 32-bit numbers and distribute to compute:
  // (lhsHigh * 2^32 + lhsLow) * (rhsHigh * 2^32 + rhsLow)
  //
  // (lhsHigh * rhsHigh) * 2^64                     [Upper 64 bits]
  // (lhsHigh * rhsLow + lhsLow * rhsHigh) * 2^32   [Middle 64 bits]
  // (lhsLow * rhsLow)                              [Lower 64 bits]

  uint64_t lhsLow = lhs & 0xffffffff;
  uint64_t lhsHigh = lhs >> 32;
  uint64_t rhsLow = rhs & 0xffffffff;
  uint64_t rhsHigh = rhs >> 32;

  uint64_t lowLow = lhsLow * rhsLow;
  uint64_t lowHigh = lhsLow * rhsHigh;
  uint64_t highLow = lhsHigh * rhsLow;
  uint64_t highHigh = lhsHigh * rhsHigh;

  // The lowest 32 bits consist only of lowLow (without its carry)
  //
  // The next 32 bits consist of `lowHigh + highLow + the carry of lowlow`
  // (again this may carry to the next 32) Start by adding the carry which is
  // guaranteed to not overflow 64 bits. Overflow can't happen because lowHigh
  // is max (2**32 - 1)**2 and `lowLow >> 32` is no more than 32 bits, (2**32 -
  // 1)**2 + (2**32 -1) < 2**64 - 1
  uint64_t highOfLow = (lowLow >> 32) + lowHigh;

  // We might have a carry into the next 32 (the low of the high), mask it out
  // now so we can add highLow.
  uint64_t carry = highOfLow >> 32;

  // This is also guaranteed to not overflow by the same logic.
  highOfLow = (highOfLow & 0xffffffff) + highLow;

  // highOfLow might have exceeded 32 bits again, carry it again
  uint64_t carry2 = highOfLow >> 32;

  uint64_t lower = (lowLow & 0xffffffff) | (highOfLow << 32);

  // No need to worry about overflow here, since 128 bits is always enough to
  // store the product of two 64-bit ints.
  uint64_t higher = carry + carry2 + highHigh;

  return {higher, lower};
}

} // namespace detail

} // namespace wasm
