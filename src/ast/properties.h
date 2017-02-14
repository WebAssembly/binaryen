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

#ifndef wasm_ast_properties_h
#define wasm_ast_properties_h

#include "wasm.h"
#include "ast/bits.h"

namespace wasm {

struct Properties {
  static bool emitsBoolean(Expression* curr) {
    if (auto* unary = curr->dynCast<Unary>()) {
      return unary->isRelational();
    } else if (auto* binary = curr->dynCast<Binary>()) {
      return binary->isRelational();
    }
    return false;
  }

  static bool isSymmetric(Binary* binary) {
    switch (binary->op) {
      case AddInt32:
      case MulInt32: 
      case AndInt32:
      case OrInt32:
      case XorInt32:
      case EqInt32:
      case NeInt32:

      case AddInt64:
      case MulInt64: 
      case AndInt64:
      case OrInt64:
      case XorInt64:
      case EqInt64:
      case NeInt64: return true;

      default: return false;
    }
  }

  // Check if an expression is a sign-extend, and if so, returns the value
  // that is extended, otherwise nullptr
  static Expression* getSignExtValue(Expression* curr) {
    if (auto* outer = curr->dynCast<Binary>()) {
      if (outer->op == ShrSInt32) {
        if (auto* outerConst = outer->right->dynCast<Const>()) {
          if (auto* inner = outer->left->dynCast<Binary>()) {
            if (inner->op == ShlInt32) {
              if (auto* innerConst = inner->right->dynCast<Const>()) {
                if (outerConst->value == innerConst->value) {
                  return inner->left;
                }
              }
            }
          }
        }
      }
    }
    return nullptr;
  }

  // gets the size of the sign-extended value
  static Index getSignExtBits(Expression* curr) {
    return 32 - curr->cast<Binary>()->right->cast<Const>()->value.geti32();
  }

  // Check if an expression is almost a sign-extend: perhaps the inner shift
  // is too large. We can split the shifts in that case, which is sometimes
  // useful (e.g. if we can remove the signext)
  static Expression* getAlmostSignExt(Expression* curr) {
    if (auto* outer = curr->dynCast<Binary>()) {
      if (outer->op == ShrSInt32) {
        if (auto* outerConst = outer->right->dynCast<Const>()) {
          if (auto* inner = outer->left->dynCast<Binary>()) {
            if (inner->op == ShlInt32) {
              if (auto* innerConst = inner->right->dynCast<Const>()) {
                if (outerConst->value.leU(innerConst->value).geti32()) {
                  return inner->left;
                }
              }
            }
          }
        }
      }
    }
    return nullptr;
  }

  // gets the size of the almost sign-extended value, as well as the
  // extra shifts, if any
  static Index getAlmostSignExtBits(Expression* curr, Index& extraShifts) {
    extraShifts = curr->cast<Binary>()->left->cast<Binary>()->right->cast<Const>()->value.geti32() -
                  curr->cast<Binary>()->right->cast<Const>()->value.geti32();
    return getSignExtBits(curr);
  }

  // Check if an expression is a zero-extend, and if so, returns the value
  // that is extended, otherwise nullptr
  static Expression* getZeroExtValue(Expression* curr) {
    if (auto* binary = curr->dynCast<Binary>()) {
      if (binary->op == AndInt32) {
        if (auto* c = binary->right->dynCast<Const>()) {
          if (Bits::getMaskedBits(c->value.geti32())) {
            return binary->right;
          }
        }
      }
    }
    return nullptr;
  }

  // gets the size of the sign-extended value
  static Index getZeroExtBits(Expression* curr) {
    return Bits::getMaskedBits(curr->cast<Binary>()->right->cast<Const>()->value.geti32());
  }
};

} // wasm

#endif // wams_ast_properties_h

