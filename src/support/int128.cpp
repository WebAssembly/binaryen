// Copyright 2024 WebAssembly Community Group participants
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

  if (static_cast<int64_t>(lhs) < 0) {
    high -= rhs;
  }
  if (static_cast<int64_t>(rhs) < 0) {
    high -= lhs;
  }

  return {high, low};
}

Int128 mul_wide_u_fallback(uint64_t lhs, uint64_t rhs) {
  uint32_t lhsLow = lhs & 0xffffffff;
  uint32_t lhsHigh = lhs >> 32;
  uint32_t rhsLow = rhs & 0xffffffff;
  uint32_t rhsHigh = rhs >> 32;

  uint64_t mulLowLow = static_cast<uint64_t>(lhsLow) * rhsLow;
  uint64_t mulLowHigh = static_cast<uint64_t>(lhsLow) * rhsHigh;
  uint64_t mulHighLow = static_cast<uint64_t>(lhsHigh) * rhsLow;
  uint64_t mulHighHigh = static_cast<uint64_t>(lhsHigh) * rhsHigh;

  uint64_t cross = mulLowHigh + (mulLowLow >> 32);
  uint64_t carry = cross >> 32;
  cross = (cross & 0xffffffff) + mulHighLow;

  // The lower 64 bits of the 128-bit result are formed by:
  //   (low * low) + ((low * high) << 32) + ((high * low) << 32)
  //
  // The upper 64 bits of the 128-bit result are formed by:
  //   (high * high) + the upper 32-bits of (low * high) + the upper 32-bits of
  //   (high * low) + carries from the lower 64 bits
  uint64_t lowResult = (cross << 32) | (mulLowLow & 0xffffffff);
  uint64_t highResult = mulHighHigh + carry + (cross >> 32);

  return {highResult, lowResult};
}

} // namespace detail

} // namespace wasm
