/*
 * Copyright 2006-2011, the V8 project authors. All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *   * Neither the name of Google Inc. nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef wasm_div_by_const_h
#define wasm_div_by_const_h

#include <stdint.h>

namespace wasm {

// ----------------------------------------------------------------------------

// The magic numbers for division via multiplication, see Warren's "Hacker's
// Delight", chapter 10. The template parameter must be one of the unsigned
// integral types.
template<class T> struct MagicNumbersForDivision {
  MagicNumbersForDivision(T m, unsigned s, bool a)
    : multiplier(m), shift(s), add(a) {}
  bool operator==(const MagicNumbersForDivision& rhs) const {
    return multiplier == rhs.multiplier && shift == rhs.shift && add == rhs.add;
  }

  T multiplier;
  unsigned shift;
  bool add;
};

// Calculate the multiplier and shift for signed division via multiplication.
// The divisor must not be -1, 0 or 1 when interpreted as a signed value.
template<class T> MagicNumbersForDivision<T> signedDivisionByConstant(T d);

// Calculate the multiplier and shift for unsigned division via multiplication,
// see Warren's "Hacker's Delight", chapter 10. The divisor must not be 0 and
// leading_zeros can be used to speed up the calculation if the given number of
// upper bits of the dividend value are known to be zero.
template<class T>
MagicNumbersForDivision<T>
unsignedDivisionByConstant(T d, unsigned leading_zeros = 0);

// Explicit instantiation declarations.
extern template struct MagicNumbersForDivision<uint32_t>;
extern template struct MagicNumbersForDivision<uint64_t>;

extern template MagicNumbersForDivision<uint32_t>
signedDivisionByConstant(uint32_t d);

extern template MagicNumbersForDivision<uint64_t>
signedDivisionByConstant(uint64_t d);

extern template MagicNumbersForDivision<uint32_t>
unsignedDivisionByConstant(uint32_t d, unsigned leading_zeros);

extern template MagicNumbersForDivision<uint64_t>
unsignedDivisionByConstant(uint64_t d, unsigned leading_zeros);

} // namespace wasm

#endif // wasm_div_by_const_h
