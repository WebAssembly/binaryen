// Copyright 2014 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef wasm_div_by_const_h
#define wasm_div_by_const_h

#include <stdint.h>

namespace wasm {

// ----------------------------------------------------------------------------

// The magic numbers for division via multiplication, see Warren's "Hacker's
// Delight", chapter 10. The template parameter must be one of the unsigned
// integral types.
template <class T>
struct MagicNumbersForDivision {
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
