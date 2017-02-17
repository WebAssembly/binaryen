/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_ast_bits_h
#define wasm_ast_bits_h

#include "support/bits.h"

namespace wasm {

struct Bits {
  // get a mask to keep only the low # of bits
  static int32_t lowBitMask(int32_t bits) {
    uint32_t ret = -1;
    if (bits >= 32) return ret;
    return ret >> (32 - bits);
  }

  // checks if the input is a mask of lower bits, i.e., all 1s up to some high bit, and all zeros
  // from there. returns the number of masked bits, or 0 if this is not such a mask
  static uint32_t getMaskedBits(uint32_t mask) {
    if (mask == uint32_t(-1)) return 32; // all the bits
    if (mask == 0) return 0; // trivially not a mask
    // otherwise, see if adding one turns this into a 1-bit thing, 00011111 + 1 => 00100000
    if (PopCount(mask + 1) != 1) return 0;
    // this is indeed a mask
    return 32 - CountLeadingZeroes(mask);
  }
};

} // namespace wasm

#endif // wasm_ast_bits_h

