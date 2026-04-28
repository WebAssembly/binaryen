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

#ifndef wasm_support_int128_h
#define wasm_support_int128_h

#include <cstdint>

namespace wasm {

struct Int128 {
  uint64_t high;
  uint64_t low;

  bool operator==(const Int128& other) const {
    return high == other.high && low == other.low;
  }
};

// Computes the 128-bit product of two signed 64-bit integers.
Int128 mul_wide_s(uint64_t lhs, uint64_t rhs);

// Computes the 128-bit product of two unsigned 64-bit integers.
Int128 mul_wide_u(uint64_t lhs, uint64_t rhs);

namespace detail {
// Fallback implementations exposed for testing.
Int128 mul_wide_s_fallback(uint64_t lhs, uint64_t rhs);
Int128 mul_wide_u_fallback(uint64_t lhs, uint64_t rhs);
} // namespace detail

} // namespace wasm

#endif // wasm_support_i128_h
