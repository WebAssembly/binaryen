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
#include "ir/match.h"
#include "wasm.h"

namespace wasm::Properties {

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

    case EqFloat32:
    case NeFloat32:
    case EqFloat64:
    case NeFloat64:
      return true;

    default:
      return false;
  }
}

inline bool isControlFlowStructure(Expression* curr) {
  return curr->is<Block>() || curr->is<If>() || curr->is<Loop>() ||
         curr->is<Try>();
}

// Check if an expression is a control flow construct with a name, which implies
// it may have breaks or delegates to it.
inline bool isNamedControlFlow(Expression* curr) {
  if (auto* block = curr->dynCast<Block>()) {
    return block->name.is();
  } else if (auto* loop = curr->dynCast<Loop>()) {
    return loop->name.is();
  } else if (auto* try_ = curr->dynCast<Try>()) {
    return try_->name.is();
  }
  return false;
}

// A constant expression is something like a Const: it has a fixed value known
// at compile time, and passes that propagate constants can try to propagate it.
// Constant expressions are also allowed in global initializers in wasm. Also
// when two constant expressions compare equal at compile time, their values at
// runtime will be equal as well.
// TODO: look into adding more things here like RttCanon.
inline bool isSingleConstantExpression(const Expression* curr) {
  return curr->is<Const>() || curr->is<RefNull>() || curr->is<RefFunc>();
}

inline bool isConstantExpression(const Expression* curr) {
  if (isSingleConstantExpression(curr)) {
    return true;
  }
  if (auto* tuple = curr->dynCast<TupleMake>()) {
    for (auto* op : tuple->operands) {
      if (!isSingleConstantExpression(op)) {
        return false;
      }
    }
    return true;
  }
  return false;
}

inline bool isBranch(const Expression* curr) {
  return curr->is<Break>() || curr->is<Switch>() || curr->is<BrOn>();
}

inline Literal getLiteral(const Expression* curr) {
  if (auto* c = curr->dynCast<Const>()) {
    return c->value;
  } else if (auto* n = curr->dynCast<RefNull>()) {
    return Literal(n->type);
  } else if (auto* r = curr->dynCast<RefFunc>()) {
    return Literal(r->func, r->type);
  } else if (auto* i = curr->dynCast<I31New>()) {
    if (auto* c = i->value->dynCast<Const>()) {
      return Literal::makeI31(c->value.geti32());
    }
  }
  WASM_UNREACHABLE("non-constant expression");
}

inline Literals getLiterals(const Expression* curr) {
  if (isSingleConstantExpression(curr)) {
    return {getLiteral(curr)};
  } else if (auto* tuple = curr->dynCast<TupleMake>()) {
    Literals literals;
    for (auto* op : tuple->operands) {
      literals.push_back(getLiteral(op));
    }
    return literals;
  } else {
    WASM_UNREACHABLE("non-constant expression");
  }
}

// Check if an expression is a sign-extend, and if so, returns the value
// that is extended, otherwise nullptr
inline Expression* getSignExtValue(Expression* curr) {
  // We only care about i32s here, and ignore i64s, unreachables, etc.
  if (curr->type != Type::i32) {
    return nullptr;
  }
  if (auto* unary = curr->dynCast<Unary>()) {
    if (unary->op == ExtendS8Int32 || unary->op == ExtendS16Int32) {
      return unary->value;
    }
    return nullptr;
  }
  using namespace Match;
  int32_t leftShift = 0, rightShift = 0;
  Expression* extended = nullptr;
  if (matches(curr,
              binary(ShrSInt32,
                     binary(ShlInt32, any(&extended), i32(&leftShift)),
                     i32(&rightShift))) &&
      leftShift == rightShift && leftShift != 0) {
    return extended;
  }
  return nullptr;
}

// gets the size of the sign-extended value
inline Index getSignExtBits(Expression* curr) {
  assert(curr->type == Type::i32);
  if (auto* unary = curr->dynCast<Unary>()) {
    switch (unary->op) {
      case ExtendS8Int32:
        return 8;
      case ExtendS16Int32:
        return 16;
      default:
        WASM_UNREACHABLE("invalid unary operation");
    }
  } else {
    auto* rightShift = curr->cast<Binary>()->right;
    return 32 - Bits::getEffectiveShifts(rightShift);
  }
}

// Check if an expression is almost a sign-extend: perhaps the inner shift
// is too large. We can split the shifts in that case, which is sometimes
// useful (e.g. if we can remove the signext)
inline Expression* getAlmostSignExt(Expression* curr) {
  using namespace Match;
  int32_t leftShift = 0, rightShift = 0;
  Expression* extended = nullptr;
  if (matches(curr,
              binary(ShrSInt32,
                     binary(ShlInt32, any(&extended), i32(&leftShift)),
                     i32(&rightShift))) &&
      Bits::getEffectiveShifts(rightShift, Type::i32) <=
        Bits::getEffectiveShifts(leftShift, Type::i32) &&
      rightShift != 0) {
    return extended;
  }
  return nullptr;
}

// gets the size of the almost sign-extended value, as well as the
// extra shifts, if any
inline Index getAlmostSignExtBits(Expression* curr, Index& extraLeftShifts) {
  auto* leftShift = curr->cast<Binary>()->left->cast<Binary>()->right;
  auto* rightShift = curr->cast<Binary>()->right;
  extraLeftShifts =
    Bits::getEffectiveShifts(leftShift) - Bits::getEffectiveShifts(rightShift);
  return getSignExtBits(curr);
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
      Bits::getMaskedBits(mask) != 0) {
    return extended;
  }
  return nullptr;
}

// gets the size of the sign-extended value
inline Index getZeroExtBits(Expression* curr) {
  assert(curr->type == Type::i32);
  int32_t mask = curr->cast<Binary>()->right->cast<Const>()->value.geti32();
  return Bits::getMaskedBits(mask);
}

// Returns a falling-through value, that is, it looks through a local.tee
// and other operations that receive a value and let it flow through them. If
// there is no value falling through, returns the node itself (as that is the
// value that trivially falls through, with 0 steps in the middle).
//
// Note that this returns the value that would fall through if one does in fact
// do so. For example, the final element in a block may not fall through if we
// hit a return or a trap or an exception is thrown before we get there.
//
// This method returns the 'immediate' fallthrough, that is, the immediate
// child of this expression. See getFallthrough for a method that looks all the
// way to the final value falling through, potentially through multiple
// intermediate expressions.
//
// TODO: Receive a Module instead of FeatureSet, to pass to EffectAnalyzer?
inline Expression* getImmediateFallthrough(Expression* curr,
                                           const PassOptions& passOptions,
                                           Module& module) {
  // If the current node is unreachable, there is no value
  // falling through.
  if (curr->type == Type::unreachable) {
    return curr;
  }
  if (auto* set = curr->dynCast<LocalSet>()) {
    if (set->isTee()) {
      return set->value;
    }
  } else if (auto* block = curr->dynCast<Block>()) {
    // if no name, we can't be broken to, and then can look at the fallthrough
    if (!block->name.is() && block->list.size() > 0) {
      return block->list.back();
    }
  } else if (auto* loop = curr->dynCast<Loop>()) {
    return loop->body;
  } else if (auto* iff = curr->dynCast<If>()) {
    if (iff->ifFalse) {
      // Perhaps just one of the two actually returns.
      if (iff->ifTrue->type == Type::unreachable) {
        return iff->ifFalse;
      } else if (iff->ifFalse->type == Type::unreachable) {
        return iff->ifTrue;
      }
    }
  } else if (auto* br = curr->dynCast<Break>()) {
    if (br->condition && br->value) {
      return br->value;
    }
  } else if (auto* tryy = curr->dynCast<Try>()) {
    if (!EffectAnalyzer(passOptions, module, tryy->body).throws()) {
      return tryy->body;
    }
  } else if (auto* as = curr->dynCast<RefCast>()) {
    return as->ref;
  } else if (auto* as = curr->dynCast<RefAs>()) {
    return as->value;
  } else if (auto* br = curr->dynCast<BrOn>()) {
    return br->ref;
  }
  return curr;
}

// Similar to getImmediateFallthrough, but looks through multiple children to
// find the final value that falls through.
inline Expression* getFallthrough(Expression* curr,
                                  const PassOptions& passOptions,
                                  Module& module) {
  while (1) {
    auto* next = getImmediateFallthrough(curr, passOptions, module);
    if (next == curr) {
      return curr;
    }
    curr = next;
  }
}

inline Index getNumChildren(Expression* curr) {
  Index ret = 0;

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id)                                                     \
  auto* cast = curr->cast<id>();                                               \
  WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_CHILD(id, field) ret++;

#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  if (cast->field) {                                                           \
    ret++;                                                                     \
  }

#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"

  return ret;
}

// Returns whether the resulting value here must fall through without being
// modified. For example, a tee always does so. That is, this returns false if
// and only if the return value may have some computation performed on it to
// change it from the inputs the instruction receives.
// This differs from getFallthrough() which returns a single value that falls
// through - here if more than one value can fall through, like in if-else,
// we can return true. That is, there we care about a value falling through and
// for us to get that actual value to look at; here we just care whether the
// value falls through without being changed, even if it might be one of
// several options.
inline bool isResultFallthrough(Expression* curr) {
  // Note that we don't check if there is a return value here; the node may be
  // unreachable, for example, but then there is no meaningful answer to give
  // anyhow.
  return curr->is<LocalSet>() || curr->is<Block>() || curr->is<If>() ||
         curr->is<Loop>() || curr->is<Try>() || curr->is<Select>() ||
         curr->is<Break>();
}

inline bool canEmitSelectWithArms(Expression* ifTrue, Expression* ifFalse) {
  // A select only allows a single value in its arms in the spec:
  // https://webassembly.github.io/spec/core/valid/instructions.html#xref-syntax-instructions-syntax-instr-parametric-mathsf-select-t-ast
  return ifTrue->type.isSingle() && ifFalse->type.isSingle();
}

// A "generative" expression is one that can generate different results for the
// same inputs, and that difference is *not* explained by other expressions that
// interact with this one. This is an intrinsic/internal property of the
// expression.
//
// To see the issue more concretely, consider these:
//
//    x = load(100);
//    ..
//    y = load(100);
//
//  versus
//
//    x = struct.new();
//    ..
//    y = struct.new();
//
// Are x and y identical in both cases? For loads, we can look at the code
// in ".." to see: if there are no possible stores to memory, then the
// result is identical (and we have EffectAnalyzer for that). For the GC
// allocations, though, it doesn't matter what is in "..": there is nothing
// in the wasm that we can check to find out if the results are the same or
// not. (In fact, in this case they are always not the same.) So the
// generativity is "intrinsic" to the expression and it is because each call to
// struct.new generates a new value.
//
// Thus, loads are nondeterministic but not generative, while GC allocations
// are in fact generative. Note that "generative" need not mean "allocation" as
// if wasm were to add "get current time" or "get a random number" instructions
// then those would also be generative - generating a new current time value or
// a new random number on each execution, respectively.
//
//  * Note that NaN nondeterminism is ignored here. It is a valid wasm
//    implementation to have deterministic NaN behavior, and we optimize under
//    that simplifying assumption.
//  * Note that calls are ignored here. In theory this concept could be defined
//    either way for them - that is, we could potentially define them as
//    generative, as they might contain such an instruction, or we could define
//    this property as only looking at code in the current function. We choose
//    the latter because calls are already handled best in other manners (using
//    EffectAnalyzer).
//
bool isGenerative(Expression* curr, FeatureSet features);

} // namespace wasm::Properties

#endif // wasm_ir_properties_h
