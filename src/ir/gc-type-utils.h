/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_ir_gc_type_utils_h
#define wasm_ir_gc_type_utils_h

#include "wasm.h"

namespace wasm::GCTypeUtils {

// Helper code to evaluate a reference at compile time and check if it is of a
// certain kind. Various wasm instructions check if something is a function or
// data etc., and that code is shared here.

enum Kind { Func, Data, I31, Other };

enum EvaluationResult {
  // The result is not known at compile time.
  Unknown,
  // The evaluation is known to succeed (i.e., we find what we are looking
  // for), or fail, at compile time.
  Success,
  Failure,
  // The cast will only succeed if the input is a null, or is not
  SuccessOnlyIfNull,
  SuccessOnlyIfNonNull,
};

// Given the type of a reference and a type to attempt to cast it to, return
// what we know about the result.
inline EvaluationResult evaluateCastCheck(Type refType, Type castType) {
  if (!refType.isRef() || !castType.isRef()) {
    // Unreachable etc. are meaningless situations in which we can inform the
    // caller about nothing useful.
    return Unknown;
  }

  if (Type::isSubType(refType, castType)) {
    return Success;
  }

  auto refHeapType = refType.getHeapType();
  auto castHeapType = castType.getHeapType();
  auto refIsHeapSubType = HeapType::isSubType(refHeapType, castHeapType);
  auto castIsHeapSubType = HeapType::isSubType(castHeapType, refHeapType);
  bool heapTypesCompatible = refIsHeapSubType || castIsHeapSubType;

  if (!heapTypesCompatible) {
    // If at least one is not null, then since the heap types are not compatible
    // we must fail.
    if (refType.isNonNullable() || castType.isNonNullable()) {
      return Failure;
    }

    // Otherwise, both are nullable and a null is the only hope of success.
    return SuccessOnlyIfNull;
  }

  // The cast will not definitely succeed nor will it definitely fail.
  //
  // Perhaps the heap type part of the cast can be reasoned about, at least.
  // E.g. if the heap type part of the cast is definitely compatible, but the
  // cast as a whole is not, that would leave only nullability as an issue,
  // that is, this means that the input ref is nullable but we are casting to
  // non-null.
  if (refIsHeapSubType) {
    assert(refType.isNullable());
    assert(castType.isNonNullable());
    return SuccessOnlyIfNonNull;
  }

  return Unknown;
}

// Given an instruction that checks if the child reference is of a certain kind
// (like br_on_func checks if it is a function), see if type info lets us
// determine that at compile time.
// This ignores nullability - it just checks the kind.
inline EvaluationResult evaluateKindCheck(Expression* curr) {
  Kind expected;
  Expression* child;

  // Some operations flip the condition.
  bool flip = false;

  if (auto* br = curr->dynCast<BrOn>()) {
    switch (br->op) {
      // We don't check nullability here.
      case BrOnNull:
      case BrOnNonNull:
        return Unknown;
      case BrOnCastFail:
        flip = true;
        [[fallthrough]];
      case BrOnCast: {
        auto result =
          GCTypeUtils::evaluateCastCheck(br->ref->type, br->castType);
        if (result == Success) {
          return flip ? Failure : Success;
        } else if (result == Failure) {
          return flip ? Success : Failure;
        }
        return Unknown;
      }
      default:
        WASM_UNREACHABLE("unhandled BrOn");
    }
    child = br->ref;
  } else {
    WASM_UNREACHABLE("invalid input to evaluateKindCheck");
  }

  auto childType = child->type;

  Kind actual;

  if (childType == Type::unreachable) {
    return Unknown;
  } else if (childType.isFunction()) {
    actual = Func;
  } else if (childType.isData()) {
    actual = Data;
  } else if (childType.getHeapType() == HeapType::i31) {
    actual = I31;
  } else {
    return Unknown;
  }

  auto success = actual == expected;
  if (flip) {
    success = !success;
  }
  return success ? Success : Failure;
}

} // namespace wasm::GCTypeUtils

#endif // wasm_ir_gc_type_utils_h
