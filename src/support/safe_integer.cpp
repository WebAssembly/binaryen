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

#include <cassert>
#include <cmath>
#include <limits>

#include "support/safe_integer.h"

using namespace wasm;

bool wasm::isInteger(double x) { return fmod(x, 1) == 0; }

bool wasm::isUInteger32(double x) {
  return !std::signbit(x) && isInteger(x) &&
         x <= std::numeric_limits<uint32_t>::max();
}

bool wasm::isSInteger32(double x) {
  return isInteger(x) && x >= std::numeric_limits<int32_t>::min() &&
         x <= std::numeric_limits<int32_t>::max();
}

uint32_t wasm::toUInteger32(double x) {
  return std::signbit(x) ? 0 : (x < std::numeric_limits<uint32_t>::max()
                                    ? (uint32_t)x
                                    : std::numeric_limits<uint32_t>::max());
}

int32_t wasm::toSInteger32(double x) {
  return (x > std::numeric_limits<int32_t>::min() &&
          x < std::numeric_limits<int32_t>::max())
             ? (int32_t)x
             : (std::signbit(x) ? std::numeric_limits<int32_t>::min()
                                : std::numeric_limits<int32_t>::max());
}

bool wasm::isUInteger64(double x) {
  return !std::signbit(x) && isInteger(x) &&
         x <= std::numeric_limits<uint64_t>::max();
}

bool wasm::isSInteger64(double x) {
  return isInteger(x) && x >= std::numeric_limits<int64_t>::min() &&
         x <= std::numeric_limits<int64_t>::max();
}

uint64_t wasm::toUInteger64(double x) {
  return std::signbit(x) ? 0 : (x < (double)std::numeric_limits<uint64_t>::max()
                                    ? (uint64_t)x
                                    : std::numeric_limits<uint64_t>::max());
}

int64_t wasm::toSInteger64(double x) {
  return (x > (double)std::numeric_limits<int64_t>::min() &&
          x < (double)std::numeric_limits<int64_t>::max())
             ? (int64_t)x
             : (std::signbit(x) ? std::numeric_limits<int64_t>::min()
                                : std::numeric_limits<int64_t>::max());
}

/* 3 32222222 222...00
 * 1 09876543 210...10
 * -------------------
 * 0 00000000 000...00 => 0x00000000 => 0
 * 0 10011101 111...11 => 0x4effffff => 2147483520                  (~INT32_MAX)
 * 0 10011110 000...00 => 0x4f000000 => 2147483648
 * 0 10011110 111...11 => 0x4f7fffff => 4294967040                 (~UINT32_MAX)
 * 0 10111110 111...11 => 0x5effffff => 9223371487098961920         (~INT64_MAX)
 * 0 10111110 000...00 => 0x5f000000 => 9223372036854775808
 * 0 10111111 111...11 => 0x5f7fffff => 18446742974197923840       (~UINT64_MAX)
 * 0 10111111 000...00 => 0x5f800000 => 18446744073709551616
 * 0 11111111 000...00 => 0x7f800000 => inf
 * 0 11111111 000...01 => 0x7f800001 => nan(0x1)
 * 0 11111111 111...11 => 0x7fffffff => nan(0x7fffff)
 * 1 00000000 000...00 => 0x80000000 => -0
 * 1 01111110 111...11 => 0xbf7fffff => -1 + ulp      (~UINT32_MIN, ~UINT64_MIN)
 * 1 01111111 000...00 => 0xbf800000 => -1
 * 1 10011110 000...00 => 0xcf000000 => -2147483648                  (INT32_MIN)
 * 1 10111110 000...00 => 0xdf000000 => -9223372036854775808         (INT64_MIN)
 * 1 11111111 000...00 => 0xff800000 => -inf
 * 1 11111111 000...01 => 0xff800001 => -nan(0x1)
 * 1 11111111 111...11 => 0xffffffff => -nan(0x7fffff)
 */

bool wasm::isInRangeI32TruncS(int32_t i) {
  uint32_t u = i;
  return (u < 0x4f000000U) || (u >= 0x80000000U && u <= 0xcf000000U);
}

bool wasm::isInRangeI64TruncS(int32_t i) {
  uint32_t u = i;
  return (u < 0x5f000000U) || (u >= 0x80000000U && u <= 0xdf000000U);
}

bool wasm::isInRangeI32TruncU(int32_t i) {
  uint32_t u = i;
  return (u < 0x4f800000U) || (u >= 0x80000000U && u < 0xbf800000U);
}

bool wasm::isInRangeI64TruncU(int32_t i) {
  uint32_t u = i;
  return (u < 0x5f800000U) || (u >= 0x80000000U && u < 0xbf800000U);
}

/*
 * 6 66655555555 5544...222221...000
 * 3 21098765432 1098...432109...210
 * ---------------------------------
 * 0 00000000000 0000...000000...000 0x0000000000000000 => 0
 * 0 10000011101 1111...111000...000 0x41dfffffffc00000 => 2147483647               (INT32_MAX)
 * 0 10000011110 1111...111100...000 0x41efffffffe00000 => 4294967295              (UINT32_MAX)
 * 0 10000111101 1111...111111...111 0x43dfffffffffffff => 9223372036854774784     (~INT64_MAX)
 * 0 10000111110 0000...000000...000 0x43e0000000000000 => 9223372036854775808
 * 0 10000111110 1111...111111...111 0x43efffffffffffff => 18446744073709549568   (~UINT64_MAX)
 * 0 10000111111 0000...000000...000 0x43f0000000000000 => 18446744073709551616
 * 0 11111111111 0000...000000...000 0x7ff0000000000000 => inf
 * 0 11111111111 0000...000000...001 0x7ff0000000000001 => nan(0x1)
 * 0 11111111111 1111...111111...111 0x7fffffffffffffff => nan(0xfff...)
 * 1 00000000000 0000...000000...000 0x8000000000000000 => -0
 * 1 01111111110 1111...111111...111 0xbfefffffffffffff => -1 + ulp  (~UINT32_MIN, ~UINT64_MIN)
 * 1 01111111111 0000...000000...000 0xbff0000000000000 => -1
 * 1 10000011110 0000...000000...000 0xc1e0000000000000 => -2147483648              (INT32_MIN)
 * 1 10000111110 0000...000000...000 0xc3e0000000000000 => -9223372036854775808     (INT64_MIN)
 * 1 11111111111 0000...000000...000 0xfff0000000000000 => -inf
 * 1 11111111111 0000...000000...001 0xfff0000000000001 => -nan(0x1)
 * 1 11111111111 1111...111111...111 0xffffffffffffffff => -nan(0xfff...)
 */

bool wasm::isInRangeI32TruncS(int64_t i) {
  uint64_t u = i;
  return (u <= 0x41dfffffffc00000ULL) ||
         (u >= 0x8000000000000000ULL && u <= 0xc1e0000000000000ULL);
}

bool wasm::isInRangeI32TruncU(int64_t i) {
  uint64_t u = i;
  return (u <= 0x41efffffffe00000ULL) ||
         (u >= 0x8000000000000000ULL && u <= 0xbfefffffffffffffULL);
}

bool wasm::isInRangeI64TruncS(int64_t i) {
  uint64_t u = i;
  return (u < 0x43e0000000000000ULL) ||
         (u >= 0x8000000000000000ULL && u <= 0xc3e0000000000000ULL);
}

bool wasm::isInRangeI64TruncU(int64_t i) {
  uint64_t u = i;
  return (u < 0x43f0000000000000ULL) ||
         (u >= 0x8000000000000000ULL && u <= 0xbfefffffffffffffULL);
}
