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

#include <limits>

namespace wasm {

// A 65-bit integer, capable of representing numbers in the range
//
//  std::numeric_limits<int64_t>::min() .. std::numeric_limits<uint64_t>::max()
//
// This allows an I65 to represent any 32 or 64-bit number, signed *or*
// unsigned.
struct I65 {
  // A 64-bit payload with an extra 65th sign bit.
  uint64_t value = 0;
  bool negative = false;

  // Unsigned values are simple.
  I65(uint32_t x) : value(x) {}
  I65(uint64_t x) : value(x) {}

  // Signed values need to be checked for being negative.
  I65(int32_t x) {
    if (x >= 0) {
      value = x;
    } else {
      negative = true;
      value = -int64_t(x);
    }
  }
  I65(int64_t x) {
    if (x >= 0) {
      value = x;
    } else {
      negative = true;

      // We cannot simply negate MIN_INT64.
      if (x == std::numeric_limits<int64_t>::min()) {
        value = uint64_t(1) << 31;
      } else {
        value = -int64_t(x);
      }
    }
  }

} // namespace wasm

#endif // wasm_support_i65_h
