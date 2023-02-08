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

inline EvaluationResult flipEvaluationResult(EvaluationResult result) {
  switch (result) {
    case Unknown:
      return Unknown;
    case Success:
      return Failure;
    case Failure:
      return Success;
    case SuccessOnlyIfNull:
      return SuccessOnlyIfNonNull;
    case SuccessOnlyIfNonNull:
      return SuccessOnlyIfNull;
  }
  WASM_UNREACHABLE("unexpected result");
}

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

  if (!heapTypesCompatible || castHeapType.isBottom()) {
    // If the heap types are incompatible or if it is impossible to have a
    // non-null reference to the target heap type, then the only way the cast
    // can succeed is if it allows nulls and the input is null.
    if (refType.isNonNullable() || castType.isNonNullable()) {
      return Failure;
    }

    // Both are nullable. A null is the only hope of success in either
    // situation.
    return SuccessOnlyIfNull;
  }

  // If the heap type part of the cast is compatible but the cast as a whole is
  // not, we must have a nullable input ref that we are casting to a
  // non-nullable type.
  if (refIsHeapSubType) {
    assert(refType.isNullable());
    assert(castType.isNonNullable());
    if (refHeapType.isBottom()) {
      // Non-null references to bottom types do not exist, so there's no value
      // that could make the cast succeed.
      return Failure;
    }
    return SuccessOnlyIfNonNull;
  }

  return Unknown;
}

} // namespace wasm::GCTypeUtils

#endif // wasm_ir_gc_type_utils_h
