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

namespace wasm {

namespace GCTypeUtils {

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
  Failure
};

// Given an instruction that checks if the child reference is of a certain kind
// (like br_on_func checks if it is a function), see if type info lets us
// determine that at compile time.
// This ignores nullability - it just checks the kind.
inline EvaluationResult evaluateKindCheck(Expression* curr) {
  Kind expected;
  Expression* child;

  if (auto* br = curr->dynCast<BrOn>()) {
    switch (br->op) {
      // We don't check nullability here.
      case BrOnNull:
      // Casts can only be known at runtime using RTTs.
      case BrOnCast:
        return Unknown;
      case BrOnFunc:
        expected = Func;
        break;
      case BrOnData:
        expected = Data;
        break;
      case BrOnI31:
        expected = I31;
        break;
      default:
        WASM_UNREACHABLE("unhandled BrOn");
    }
    child = br->ref;
  } else if (auto* is = curr->dynCast<RefIs>()) {
    switch (is->op) {
      // We don't check nullability here.
      case RefIsNull:
        return Unknown;
      case RefIsFunc:
        expected = Func;
        break;
      case RefIsData:
        expected = Data;
        break;
      case RefIsI31:
        expected = I31;
        break;
      default:
        WASM_UNREACHABLE("unhandled BrOn");
    }
    child = is->value;
  } else if (auto* as = curr->dynCast<RefAs>()) {
    switch (as->op) {
      // We don't check nullability here.
      case RefAsNonNull:
        return Unknown;
      case RefAsFunc:
        expected = Func;
        break;
      case RefAsData:
        expected = Data;
        break;
      case RefAsI31:
        expected = I31;
        break;
      default:
        WASM_UNREACHABLE("unhandled BrOn");
    }
    child = as->value;
  } else {
    WASM_UNREACHABLE("invalid input to evaluateKindCheck");
  }

  auto childType = child->type;

  Kind actual;

  if (childType.isFunction()) {
    actual = Func;
  } else if (childType.isData()) {
    actual = Data;
  } else if (childType.getHeapType() == HeapType::i31) {
    actual = I31;
  } else {
    return Unknown;
  }

  return actual == expected ? Success : Failure;
}

} // namespace GCTypeUtils

} // namespace wasm

#endif // wasm_ir_gc_type_utils_h
