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

inline bool isUninhabitable(Type type) {
  return type.isNonNullable() && type.getHeapType().isBottom();
}

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
  // The cast will not even be reached. This can occur if the value being cast
  // has unreachable type, or is uninhabitable (like a non-nullable bottom
  // type).
  Unreachable,
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
    case Unreachable:
      return Unreachable;
  }
  WASM_UNREACHABLE("unexpected result");
}

// Given the type of a reference and a type to attempt to cast it to, return
// what we know about the result.
inline EvaluationResult evaluateCastCheck(Type refType, Type castType) {
  if (!refType.isRef() || !castType.isRef()) {
    if (refType == Type::unreachable) {
      return Unreachable;
    }
    // If the cast type is unreachable, we can't tell - perhaps this is a br
    // instruction of some kind, that has unreachable type normally.
    return Unknown;
  }

  if (isUninhabitable(refType)) {
    // No value can appear in the ref, so the cast cannot be reached.
    return Unreachable;
  }

  auto refHeapType = refType.getHeapType();

  if (castType.isNonNullable() && refHeapType.isBottom()) {
    // Non-null references to bottom types do not exist, so there's no value
    // that could make the cast succeed.
    //
    // Note that there is an interesting corner case that is relevant here: if
    // the ref type is uninhabitable, say (ref nofunc), and the cast type is
    // non-nullable, say (ref func), then we have two contradictory rules that
    // seem to apply:
    //
    //  * A non-nullable cast of a bottom type must fail.
    //  * A cast of a subtype must succeed.
    //
    // In practice the uninhabitable type means that the cast is not even
    // reached, which is why there is no contradiction here. To avoid ambiguity,
    // we already checked for uninhabitability earlier, and returned
    // Unreachable.
    return Failure;
  }

  auto castHeapType = castType.getHeapType();
  auto refIsHeapSubType = HeapType::isSubType(refHeapType, castHeapType);

  if (refIsHeapSubType) {
    // The heap type is a subtype. All we need is for nullability to work out as
    // well, and then the cast must succeed.
    if (castType.isNullable() || refType.isNonNullable()) {
      return Success;
    }

    // If the heap type part of the cast is compatible but the cast as a whole
    // is not, we must have a nullable input ref that we are casting to a
    // non-nullable type.
    assert(refType.isNullable());
    assert(castType.isNonNullable());
    return SuccessOnlyIfNonNull;
  }

  auto castIsHeapSubType = HeapType::isSubType(castHeapType, refHeapType);
  bool heapTypesCompatible = refIsHeapSubType || castIsHeapSubType;

  if (!heapTypesCompatible || castHeapType.isBottom()) {
    // If the heap types are incompatible or if it is impossible to have a
    // non-null reference to the target heap type, then the only way the cast
    // can succeed is if it allows nulls and the input is null.
    //
    // Note that this handles uninhabitability of the cast type.
    if (refType.isNonNullable() || castType.isNonNullable()) {
      return Failure;
    }

    // Both are nullable. A null is the only hope of success in either
    // situation.
    return SuccessOnlyIfNull;
  }

  return Unknown;
}

// Given a reference and a field index, return the field for it, if one exists.
// One may not exist if the reference is unreachable, or a bottom type.
//
// The index is optional as it does not matter for an array.
//
// TODO: use in more places
inline std::optional<Field> getField(HeapType type, Index index = 0) {
  switch (type.getKind()) {
    case HeapTypeKind::Struct:
      return type.getStruct().fields[index];
    case HeapTypeKind::Array:
      return type.getArray().element;
    case HeapTypeKind::Func:
    case HeapTypeKind::Cont:
    case HeapTypeKind::Basic:
      break;
  }
  return {};
}

inline std::optional<Field> getField(Type type, Index index = 0) {
  if (type.isRef()) {
    return getField(type.getHeapType(), index);
  }
  return {};
}

} // namespace wasm::GCTypeUtils

#endif // wasm_ir_gc_type_utils_h
