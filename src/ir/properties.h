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

#ifndef wasm_ir_properties_h
#define wasm_ir_properties_h

#include "ir/bits.h"
#include "ir/effects.h"
#include "ir/iteration.h"
#include "wasm.h"

namespace wasm {

namespace Properties {

inline bool emitsBoolean(Expression* curr) {
  if (auto* unary = curr->dynCast<Unary>()) {
    return unary->isRelational();
  } else if (auto* binary = curr->dynCast<Binary>()) {
    return binary->isRelational();
  }
  return false;
}

inline bool isSymmetric(Binary* binary) {
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
    case NeInt64:
      return true;

    default:
      return false;
  }
}

// Check if an expression is a control flow construct with a name,
// which implies it may have breaks to it.
inline bool isNamedControlFlow(Expression* curr) {
  if (auto* block = curr->dynCast<Block>()) {
    return block->name.is();
  } else if (auto* loop = curr->dynCast<Loop>()) {
    return loop->name.is();
  }
  return false;
}

inline bool isConstantExpression(const Expression* curr) {
  if (curr->is<Const>() || curr->is<RefNull>() || curr->is<RefFunc>()) {
    return true;
  }
  if (auto* tuple = curr->dynCast<TupleMake>()) {
    for (auto* op : tuple->operands) {
      if (!op->is<Const>() && !op->is<RefNull>() && !op->is<RefFunc>()) {
        return false;
      }
    }
    return true;
  }
  return false;
}

inline Literal getSingleLiteral(const Expression* curr) {
  if (auto* c = curr->dynCast<Const>()) {
    return c->value;
  } else if (curr->is<RefNull>()) {
    return Literal(Type::nullref);
  } else if (auto* c = curr->dynCast<RefFunc>()) {
    return Literal(c->func);
  } else {
    WASM_UNREACHABLE("non-constant expression");
  }
}

inline Literals getLiterals(const Expression* curr) {
  if (curr->is<Const>() || curr->is<RefNull>() || curr->is<RefFunc>()) {
    return {getSingleLiteral(curr)};
  } else if (auto* tuple = curr->dynCast<TupleMake>()) {
    Literals literals;
    for (auto* op : tuple->operands) {
      literals.push_back(getSingleLiteral(op));
    }
    return literals;
  } else {
    WASM_UNREACHABLE("non-constant expression");
  }
}

// Check if an expression is a sign-extend, and if so, returns the value
// that is extended, otherwise nullptr
inline Expression* getSignExtValue(Expression* curr) {
  if (auto* outer = curr->dynCast<Binary>()) {
    if (outer->op == ShrSInt32) {
      if (auto* outerConst = outer->right->dynCast<Const>()) {
        if (outerConst->value.geti32() != 0) {
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
  }
  return nullptr;
}

// gets the size of the sign-extended value
inline Index getSignExtBits(Expression* curr) {
  return 32 - Bits::getEffectiveShifts(curr->cast<Binary>()->right);
}

// Check if an expression is almost a sign-extend: perhaps the inner shift
// is too large. We can split the shifts in that case, which is sometimes
// useful (e.g. if we can remove the signext)
inline Expression* getAlmostSignExt(Expression* curr) {
  if (auto* outer = curr->dynCast<Binary>()) {
    if (outer->op == ShrSInt32) {
      if (auto* outerConst = outer->right->dynCast<Const>()) {
        if (outerConst->value.geti32() != 0) {
          if (auto* inner = outer->left->dynCast<Binary>()) {
            if (inner->op == ShlInt32) {
              if (auto* innerConst = inner->right->dynCast<Const>()) {
                if (Bits::getEffectiveShifts(outerConst) <=
                    Bits::getEffectiveShifts(innerConst)) {
                  return inner->left;
                }
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
inline Index getAlmostSignExtBits(Expression* curr, Index& extraShifts) {
  extraShifts = Bits::getEffectiveShifts(
                  curr->cast<Binary>()->left->cast<Binary>()->right) -
                Bits::getEffectiveShifts(curr->cast<Binary>()->right);
  return getSignExtBits(curr);
}

// Check if an expression is a zero-extend, and if so, returns the value
// that is extended, otherwise nullptr
inline Expression* getZeroExtValue(Expression* curr) {
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
inline Index getZeroExtBits(Expression* curr) {
  return Bits::getMaskedBits(
    curr->cast<Binary>()->right->cast<Const>()->value.geti32());
}

// Returns a falling-through value, that is, it looks through a local.tee
// and other operations that receive a value and let it flow through them.
inline Expression* getFallthrough(Expression* curr,
                                  const PassOptions& passOptions,
                                  FeatureSet features) {
  // If the current node is unreachable, there is no value
  // falling through.
  if (curr->type == Type::unreachable) {
    return curr;
  }
  if (auto* set = curr->dynCast<LocalSet>()) {
    if (set->isTee()) {
      return getFallthrough(set->value, passOptions, features);
    }
  } else if (auto* block = curr->dynCast<Block>()) {
    // if no name, we can't be broken to, and then can look at the fallthrough
    if (!block->name.is() && block->list.size() > 0) {
      return getFallthrough(block->list.back(), passOptions, features);
    }
  } else if (auto* loop = curr->dynCast<Loop>()) {
    return getFallthrough(loop->body, passOptions, features);
  } else if (auto* iff = curr->dynCast<If>()) {
    if (iff->ifFalse) {
      // Perhaps just one of the two actually returns.
      if (iff->ifTrue->type == Type::unreachable) {
        return getFallthrough(iff->ifFalse, passOptions, features);
      } else if (iff->ifFalse->type == Type::unreachable) {
        return getFallthrough(iff->ifTrue, passOptions, features);
      }
    }
  } else if (auto* br = curr->dynCast<Break>()) {
    if (br->condition && br->value) {
      return getFallthrough(br->value, passOptions, features);
    }
  } else if (auto* tryy = curr->dynCast<Try>()) {
    if (!EffectAnalyzer(passOptions, features, tryy->body).throws) {
      return getFallthrough(tryy->body, passOptions, features);
    }
  }
  return curr;
}

} // namespace Properties

} // namespace wasm

#endif // wasm_ir_properties_h
