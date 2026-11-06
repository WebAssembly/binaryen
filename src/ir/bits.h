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

#include "ir/boolean.h"
#include "ir/literal-utils.h"
#include "ir/load-utils.h"
#include "ir/match.h"
#include "support/bits.h"
#include "wasm-builder.h"

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

inline Expression* makeSignExt(Expression* value, Index bytes, Module& wasm) {
  if (value->type == Type::i32) {
    if (bytes == 1 || bytes == 2) {
      auto shifts = bytes == 1 ? 24 : 16;
      Builder builder(wasm);
      return builder.makeBinary(
        ShrSInt32,
        builder.makeBinary(
          ShlInt32,
          value,
          LiteralUtils::makeFromInt32(shifts, Type::i32, wasm)),
        LiteralUtils::makeFromInt32(shifts, Type::i32, wasm));
    }
    assert(bytes == 4);
    return value; // nothing to do
  } else {
    assert(value->type == Type::i64);
    if (bytes == 1 || bytes == 2 || bytes == 4) {
      auto shifts = bytes == 1 ? 56 : (bytes == 2 ? 48 : 32);
      Builder builder(wasm);
      return builder.makeBinary(
        ShrSInt64,
        builder.makeBinary(
          ShlInt64,
          value,
          LiteralUtils::makeFromInt32(shifts, Type::i64, wasm)),
        LiteralUtils::makeFromInt32(shifts, Type::i64, wasm));
    }
    assert(bytes == 8);
    return value; // nothing to do
  }
}

// Given a value that is read from a field, as a replacement for a
// StructGet/ArrayGet that we inferred the value of, and given the signedness of
// the get and the field info, if we are doing a signed read of a packed field
// then sign-extend it, or if it is unsigned then truncate. This fixes up cases
// where we can replace the StructGet/ArrayGet with the value we know must be
// there (without making any assumptions about |value|, that is, we do not
// assume it has been truncated already).
inline Expression* makePackedFieldGet(Expression* value,
                                      const Field& field,
                                      bool signed_,
                                      Module& wasm) {
  if (!field.isPacked()) {
    return value;
  }

  if (signed_) {
    return makeSignExt(value, field.getByteSize(), wasm);
  }

  Builder builder(wasm);
  auto mask = Bits::lowBitMask(field.getByteSize() * 8);
  return builder.makeBinary(AndInt32, value, builder.makeConst(int32_t(mask)));
}

// Check if an expression is a sign-extend, and if so, returns the value
// that is extended, otherwise nullptr
inline Expression* getSignExtValue(Expression* curr) {
  // We only care about integers here, and ignore unreachables, etc.
  if (!curr->type.isInteger()) {
    return nullptr;
  }
  if (auto* unary = curr->dynCast<Unary>()) {
    switch (unary->op) {
      case ExtendS8Int32:
      case ExtendS16Int32:
      case ExtendS8Int64:
      case ExtendS16Int64:
      case ExtendS32Int64:
        // The operand may have become unreachable before refinalization updates
        // `curr->type`.
        return unary->value->type.isInteger() ? unary->value : nullptr;
      default:
        return nullptr;
    }
  }
  using namespace Abstract;
  using namespace Match;
  int64_t leftShift = 0, rightShift = 0;
  Expression* extended = nullptr;
  if (matches(curr,
              binary(ShrS,
                     binary(Shl, any(&extended), ival(&leftShift)),
                     ival(&rightShift)))) {
    auto leftShifts = getEffectiveShifts(leftShift, curr->type);
    auto rightShifts = getEffectiveShifts(rightShift, curr->type);
    if (leftShifts != 0 && leftShifts == rightShifts) {
      return extended;
    }
  }
  return nullptr;
}

// Check if an expression is almost a sign-extend: perhaps the inner shift
// is too large. We can split the shifts in that case, which is sometimes
// useful (e.g. if we can remove the signext)
inline Expression* getAlmostSignExt(Expression* curr) {
  using namespace Abstract;
  using namespace Match;
  int64_t leftShift = 0, rightShift = 0;
  Expression* extended = nullptr;
  if (matches(curr,
              binary(ShrS,
                     binary(Shl, any(&extended), ival(&leftShift)),
                     ival(&rightShift)))) {
    auto leftShifts = getEffectiveShifts(leftShift, curr->type);
    auto rightShifts = getEffectiveShifts(rightShift, curr->type);
    if (rightShifts != 0 && rightShifts <= leftShifts) {
      return extended;
    }
  }
  return nullptr;
}

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
inline Expression* getZeroExtValue(Expression* curr) {
  // We only care about i32s here, and ignore i64s, unreachables, etc.
  if (curr->type != Type::i32) {
    return nullptr;
  }
  using namespace Match;
  int32_t mask = 0;
  Expression* extended = nullptr;
  if (matches(curr, binary(AndInt32, any(&extended), i32(&mask))) &&
      getMaskedBits(mask) != 0) {
    return extended;
  }
  return nullptr;
}

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
  Index getMaxBits(Expression* curr) const {
    if (Properties::emitsBoolean(curr)) {
      return 1;
    }
    if (auto* c = curr->dynCast<Const>()) {
      switch (curr->type.getBasic()) {
        case Type::i32:
          return 32 - c->value.countLeadingZeroes().geti32();
        case Type::i64:
          return 64 - c->value.countLeadingZeroes().geti64();
        default:
          WASM_UNREACHABLE("invalid type");
      }
    } else if (auto* binary = curr->dynCast<Binary>()) {
      switch (binary->op) {
        // 32-bit
        case RotLInt32:
        case RotRInt32:
        case SubInt32:
          return 32;
        case AddInt32: {
          auto maxBitsLeft = getMaxBits(binary->left);
          auto maxBitsRight = getMaxBits(binary->right);
          return std::min(Index(32), std::max(maxBitsLeft, maxBitsRight) + 1);
        }
        case MulInt32: {
          auto maxBitsRight = getMaxBits(binary->right);
          auto maxBitsLeft = getMaxBits(binary->left);
          return std::min(Index(32), maxBitsLeft + maxBitsRight);
        }
        case DivSInt32: {
          if (auto* c = binary->right->dynCast<Const>()) {
            int32_t maxBitsLeft = getMaxBits(binary->left);
            // If either side might be negative, then the result will be
            // negative
            if (maxBitsLeft == 32 || c->value.geti32() < 0) {
              return 32;
            }
            int32_t bitsRight = getMaxBits(c);
            // Apply std::min: Result bits cannot exceed dividend bits
            return std::min(maxBitsLeft,
                            std::max(0, maxBitsLeft - bitsRight + 1));
          }
          return 32;
        }
        case DivUInt32: {
          int32_t maxBitsLeft = getMaxBits(binary->left);
          if (auto* c = binary->right->dynCast<Const>()) {
            int32_t bitsRight = getMaxBits(c);
            // Apply std::min: Result bits cannot exceed dividend bits
            return std::min(maxBitsLeft,
                            std::max(0, maxBitsLeft - bitsRight + 1));
          }
          return maxBitsLeft;
        }
        case RemSInt32: {
          if (auto* c = binary->right->dynCast<Const>()) {
            auto maxBitsLeft = getMaxBits(binary->left);
            // if left may be negative, the result may be negative
            if (maxBitsLeft == 32) {
              return 32;
            }
            auto bitsRight = Index(ceilLog2(c->value.geti32()));
            return std::min(maxBitsLeft, bitsRight);
          }
          return 32;
        }
        case RemUInt32: {
          if (auto* c = binary->right->dynCast<Const>()) {
            auto maxBitsLeft = getMaxBits(binary->left);
            auto bitsRight = Index(ceilLog2(c->value.geti32()));
            return std::min(maxBitsLeft, bitsRight);
          }
          return 32;
        }
        case AndInt32: {
          return std::min(getMaxBits(binary->left), getMaxBits(binary->right));
        }
        case OrInt32:
        case XorInt32: {
          return std::max(getMaxBits(binary->left), getMaxBits(binary->right));
        }
        case ShlInt32: {
          if (auto* shifts = binary->right->dynCast<Const>()) {
            return std::min(
              Index(32), getMaxBits(binary->left) + getEffectiveShifts(shifts));
          }
          return 32;
        }
        case ShrUInt32: {
          if (auto* shift = binary->right->dynCast<Const>()) {
            auto maxBits = getMaxBits(binary->left);
            auto shifts =
              std::min(Index(getEffectiveShifts(shift)),
                       maxBits); // can ignore more shifts than zero us out
            return std::max(Index(0), maxBits - shifts);
          }
          return 32;
        }
        case ShrSInt32: {
          if (auto* shift = binary->right->dynCast<Const>()) {
            auto maxBits = getMaxBits(binary->left);
            // if left may be negative, the result may be negative
            if (maxBits == 32) {
              return 32;
            }
            auto shifts =
              std::min(Index(getEffectiveShifts(shift)),
                       maxBits); // can ignore more shifts than zero us out
            return std::max(Index(0), maxBits - shifts);
          }
          return 32;
        }
        case RotLInt64:
        case RotRInt64:
        case SubInt64:
          return 64;
        case AddInt64: {
          auto maxBitsLeft = getMaxBits(binary->left);
          auto maxBitsRight = getMaxBits(binary->right);
          return std::min(Index(64), std::max(maxBitsLeft, maxBitsRight) + 1);
        }
        case MulInt64: {
          auto maxBitsRight = getMaxBits(binary->right);
          auto maxBitsLeft = getMaxBits(binary->left);
          return std::min(Index(64), maxBitsLeft + maxBitsRight);
        }
        case DivSInt64: {
          if (auto* c = binary->right->dynCast<Const>()) {
            int32_t maxBitsLeft = getMaxBits(binary->left);
            // if left or right const value is negative
            if (maxBitsLeft == 64 || c->value.geti64() < 0) {
              return 64;
            }
            int32_t bitsRight = getMaxBits(c);
            // Apply std::min: Result bits cannot exceed dividend bits
            return std::min(maxBitsLeft,
                            std::max(0, maxBitsLeft - bitsRight + 1));
          }
          return 64;
        }
        case DivUInt64: {
          int32_t maxBitsLeft = getMaxBits(binary->left);
          if (auto* c = binary->right->dynCast<Const>()) {
            int32_t bitsRight = getMaxBits(c);
            // Apply std::min: Result bits cannot exceed dividend bits
            return std::min(maxBitsLeft,
                            std::max(0, maxBitsLeft - bitsRight + 1));
          }
          return maxBitsLeft;
        }
        case RemSInt64: {
          if (auto* c = binary->right->dynCast<Const>()) {
            auto maxBitsLeft = getMaxBits(binary->left);
            // if left may be negative, the result may be negative
            if (maxBitsLeft == 64) {
              return 64;
            }
            auto bitsRight = Index(ceilLog2(c->value.geti64()));
            return std::min(maxBitsLeft, bitsRight);
          }
          return 64;
        }
        case RemUInt64: {
          if (auto* c = binary->right->dynCast<Const>()) {
            auto maxBitsLeft = getMaxBits(binary->left);
            auto bitsRight = Index(ceilLog2(c->value.geti64()));
            return std::min(maxBitsLeft, bitsRight);
          }
          return 64;
        }
        case AndInt64: {
          return std::min(getMaxBits(binary->left), getMaxBits(binary->right));
        }
        case OrInt64:
        case XorInt64: {
          return std::max(getMaxBits(binary->left), getMaxBits(binary->right));
        }
        case ShlInt64: {
          if (auto* shifts = binary->right->dynCast<Const>()) {
            auto maxBits = getMaxBits(binary->left);
            return std::min(Index(64), getEffectiveShifts(shifts) + maxBits);
          }
          return 64;
        }
        case ShrUInt64: {
          if (auto* shift = binary->right->dynCast<Const>()) {
            auto maxBits = getMaxBits(binary->left);
            auto shifts =
              std::min(Index(getEffectiveShifts(shift)),
                       maxBits); // can ignore more shifts than zero us out
            return std::max(Index(0), maxBits - shifts);
          }
          return 64;
        }
        case ShrSInt64: {
          if (auto* shift = binary->right->dynCast<Const>()) {
            auto maxBits = getMaxBits(binary->left);
            // if left may be negative, the result may be negative
            if (maxBits == 64) {
              return 64;
            }
            auto shifts =
              std::min(Index(getEffectiveShifts(shift)),
                       maxBits); // can ignore more shifts than zero us out
            return std::max(Index(0), maxBits - shifts);
          }
          return 64;
        }
        // comparisons
        case EqInt32:
        case NeInt32:
        case LtSInt32:
        case LtUInt32:
        case LeSInt32:
        case LeUInt32:
        case GtSInt32:
        case GtUInt32:
        case GeSInt32:
        case GeUInt32:

        case EqInt64:
        case NeInt64:
        case LtSInt64:
        case LtUInt64:
        case LeSInt64:
        case LeUInt64:
        case GtSInt64:
        case GtUInt64:
        case GeSInt64:
        case GeUInt64:

        case EqFloat32:
        case NeFloat32:
        case LtFloat32:
        case LeFloat32:
        case GtFloat32:
        case GeFloat32:

        case EqFloat64:
        case NeFloat64:
        case LtFloat64:
        case LeFloat64:
        case GtFloat64:
        case GeFloat64:
          WASM_UNREACHABLE("relationals handled before");
        default: {
        }
      }
    } else if (auto* unary = curr->dynCast<Unary>()) {
      switch (unary->op) {
        case ClzInt32:
        case CtzInt32:
        case PopcntInt32:
          return 6;
        case ClzInt64:
        case CtzInt64:
        case PopcntInt64:
          return 7;
        case EqZInt32:
        case EqZInt64:
          WASM_UNREACHABLE("relationals handled before");
        case WrapInt64:
        case ExtendUInt32:
          return std::min(Index(32), getMaxBits(unary->value));
        case ExtendS8Int32: {
          auto maxBits = getMaxBits(unary->value);
          return maxBits >= 8 ? Index(32) : maxBits;
        }
        case ExtendS16Int32: {
          auto maxBits = getMaxBits(unary->value);
          return maxBits >= 16 ? Index(32) : maxBits;
        }
        case ExtendS8Int64: {
          auto maxBits = getMaxBits(unary->value);
          return maxBits >= 8 ? Index(64) : maxBits;
        }
        case ExtendS16Int64: {
          auto maxBits = getMaxBits(unary->value);
          return maxBits >= 16 ? Index(64) : maxBits;
        }
        case ExtendS32Int64:
        case ExtendSInt32: {
          auto maxBits = getMaxBits(unary->value);
          return maxBits >= 32 ? Index(64) : maxBits;
        }
        default: {
        }
      }
    } else if (auto* set = curr->dynCast<LocalSet>()) {
      // a tee passes through the value
      return getMaxBits(set->value);
    } else if (auto* get = curr->dynCast<LocalGet>()) {
      return localInfoProvider.getMaxBitsForLocal(get);
    } else if (auto* load = curr->dynCast<Load>()) {
      // if signed, then the sign-extension might fill all the bits
      // if unsigned, then we have a limit
      if (LoadUtils::isSignRelevant(load) && !load->signed_) {
        return 8 * load->bytes;
      }
    } else if (auto* block = curr->dynCast<Block>()) {
      if (!block->name.is() && !block->list.empty() &&
          block->type.isConcrete()) {
        return getMaxBits(block->list.back());
      }
    }
    switch (curr->type.getBasic()) {
      case Type::i32:
        return 32;
      case Type::i64:
        return 64;
      case Type::unreachable:
        return 64; // not interesting, but don't crash
      default:
        WASM_UNREACHABLE("invalid type");
    }
  }

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
  Index getSignExtKeptBits(Expression* curr) const {
    if (auto* unary = curr->dynCast<Unary>();
        unary && unary->op == ExtendSInt32) {
      // i64.extend_i32_s sign-extends from 32 bits, or from a narrower width if
      // its i32 input is itself sign-extended (since any i32 sign extension is
      // narrower than 32 bits and extending to i64 replicates the same sign
      // bit).
      auto innerBits = getSignExtKeptBits(unary->value);
      return innerBits > 0 ? innerBits : 32;
    }
    if (getSignExtValue(curr)) {
      if (auto* unary = curr->dynCast<Unary>()) {
        switch (unary->op) {
          case ExtendS8Int32:
          case ExtendS8Int64:
            return 8;
          case ExtendS16Int32:
          case ExtendS16Int64:
            return 16;
          case ExtendS32Int64:
            return 32;
          default:
            WASM_UNREACHABLE("invalid unary operation");
        }
      } else {
        auto* rightShift = curr->cast<Binary>()->right;
        return curr->type.getByteSize() * 8 - getEffectiveShifts(rightShift);
      }
    }
    if (auto* load = curr->dynCast<Load>()) {
      if (LoadUtils::isSignRelevant(load) && load->signed_) {
        return load->bytes * 8;
      }
    }
    if (auto* get = curr->dynCast<LocalGet>()) {
      return localInfoProvider.getSignExtKeptBitsForLocal(get);
    }
    return 0;
  }
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
