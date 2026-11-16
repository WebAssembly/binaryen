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

#ifndef wasm_ir_bits_h
#define wasm_ir_bits_h

#include <cassert>
#include <cstdint>

#include "support/bits.h"
#include "support/index.h"
#include "support/utilities.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm::Bits {

// Get a mask to keep only the low # of bits.
inline int32_t lowBitMask(int32_t bits) {
  uint32_t ret = -1;
  if (bits <= 0) {
    return 0;
  }
  if (bits >= 32) {
    return ret;
  }
  return ret >> (32 - bits);
}

inline int64_t lowBitMask64(int64_t bits) {
  uint64_t ret = -1;
  if (bits <= 0) {
    return 0;
  }
  if (bits >= 64) {
    return ret;
  }
  return ret >> (64 - bits);
}

// checks if the input is a mask of lower bits, i.e., all 1s up to some high
// bit, and all zeros from there. returns the number of masked bits, or 0 if
// this is not such a mask
inline uint32_t getMaskedBits(uint32_t mask) {
  if (mask == uint32_t(-1)) {
    return 32; // all the bits
  }
  if (mask == 0) {
    return 0; // trivially not a mask
  }
  // otherwise, see if x & (x + 1) turns this into non-zero value
  // 00011111 & (00011111 + 1) => 0
  if (mask & (mask + 1)) {
    return 0;
  }
  // this is indeed a mask
  return 32 - countLeadingZeroes(mask);
}

// gets the number of effective shifts a shift operation does. In
// wasm, only 5 bits matter for 32-bit shifts, and 6 for 64.
inline Index getEffectiveShifts(Index amount, Type type) {
  if (type == Type::i32) {
    return amount & 31;
  } else if (type == Type::i64) {
    return amount & 63;
  }
  WASM_UNREACHABLE("unexpected type");
}

inline Index getEffectiveShifts(Expression* expr) {
  auto* amount = expr->cast<Const>();
  if (amount->type == Type::i32) {
    return getEffectiveShifts(amount->value.geti32(), Type::i32);
  } else if (amount->type == Type::i64) {
    return getEffectiveShifts(amount->value.geti64(), Type::i64);
  }
  WASM_UNREACHABLE("unexpected type");
}

Expression* makeSignExt(Expression* value, Index bytes, Module& wasm);

// Given a value that is read from a field, as a replacement for a
// StructGet/ArrayGet that we inferred the value of, and given the signedness of
// the get and the field info, if we are doing a signed read of a packed field
// then sign-extend it, or if it is unsigned then truncate. This fixes up cases
// where we can replace the StructGet/ArrayGet with the value we know must be
// there (without making any assumptions about |value|, that is, we do not
// assume it has been truncated already).
Expression* makePackedFieldGet(Expression* value,
                               const Field& field,
                               bool signed_,
                               Module& wasm);

// Check if an expression is a sign-extend, and if so, returns the value
// that is extended, otherwise nullptr
Expression* getSignExtValue(Expression* curr);

// Check if an expression is almost a sign-extend: perhaps the inner shift
// is too large. We can split the shifts in that case, which is sometimes
// useful (e.g. if we can remove the signext)
Expression* getAlmostSignExt(Expression* curr);

// Returns the number of low bits kept by an almost-sign-extend (including any
// extra left-shifted zero bits), and sets |extraLeftShifts| to the number of
// extra left shifts.
inline Index getAlmostSignExtKeptBits(Expression* curr,
                                      Index& extraLeftShifts) {
  auto* leftShift = curr->cast<Binary>()->left->cast<Binary>()->right;
  auto* rightShift = curr->cast<Binary>()->right;
  extraLeftShifts =
    getEffectiveShifts(leftShift) - getEffectiveShifts(rightShift);
  return curr->type.getByteSize() * 8 - getEffectiveShifts(rightShift);
}

// Check if an expression is a zero-extend, and if so, returns the value
// that is extended, otherwise nullptr
Expression* getZeroExtValue(Expression* curr);

// Returns the number of low bits kept by a zero-extend operation.
inline Index getZeroExtKeptBits(Expression* curr) {
  assert(curr->type == Type::i32);
  int32_t mask = curr->cast<Binary>()->right->cast<Const>()->value.geti32();
  return getMaskedBits(mask);
}

// Interface for providing known bit properties of locals.
struct LocalInfoProvider {
  virtual ~LocalInfoProvider() = default;
  virtual Index getMaxBitsForLocal(LocalGet* get) const = 0;
  virtual Index getSignExtKeptBitsForLocal(LocalGet* get) const = 0;
};

// LocalInfoProvider helper that has pessimistic results for the bits used in
// locals.
struct DummyLocalInfoProvider : LocalInfoProvider {
  Index getMaxBitsForLocal(LocalGet* get) const override {
    if (get->type == Type::i32) {
      return 32;
    } else if (get->type == Type::i64) {
      return 64;
    }
    WASM_UNREACHABLE("type has no integer bit size");
  }

  Index getSignExtKeptBitsForLocal(LocalGet* get) const override { return 0; }
};

class Provider {
  const LocalInfoProvider& localInfoProvider;

  static inline const DummyLocalInfoProvider dummyLocalInfoProvider{};

public:
  Provider(const LocalInfoProvider* localInfoProvider = nullptr)
    : localInfoProvider(localInfoProvider ? *localInfoProvider
                                          : dummyLocalInfoProvider) {}

  // Returns the maximum amount of bits used in an integer expression
  // not extremely precise (doesn't look into add operands, etc.)
  Index getMaxBits(Expression* curr) const;

  // As getMaxBits, but returns the minimum amount of bits.
  Index getMinBits(Expression* curr) const {
    if (auto* c = curr->dynCast<Const>()) {
      // Constants are simple: the min and max are identical.
      return getMaxBits(c);
    }

    // TODO: everything else
    return 0;
  }

  // If |curr| is known to be sign-extended, returns the number of low bits kept
  // before sign-extending into the upper bits, or 0 otherwise.
  Index getSignExtKeptBits(Expression* curr) const;
};

inline Index getMaxBits(Expression* curr) {
  return Provider().getMaxBits(curr);
}

inline Index getMinBits(Expression* curr) {
  return Provider().getMinBits(curr);
}

inline Index getSignExtKeptBits(Expression* curr) {
  return Provider().getSignExtKeptBits(curr);
}

} // namespace wasm::Bits

#endif // wasm_ir_bits_h
