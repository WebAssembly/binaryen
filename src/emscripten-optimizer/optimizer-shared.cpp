/*
 * Copyright 2015 WebAssembly Community Group participants
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

#include <limits>

#include "optimizer.h"
#include "shared-constants.h"
#include "support/safe_integer.h"

using namespace cashew;

IString JS_FLOAT_ZERO;

IString SIMD_INT8X16_CHECK("SIMD_Int8x16_check");
IString SIMD_INT16X8_CHECK("SIMD_Int16x8_check");
IString SIMD_INT32X4_CHECK("SIMD_Int32x4_check");
IString SIMD_FLOAT32X4_CHECK("SIMD_Float32x4_check");
IString SIMD_FLOAT64X2_CHECK("SIMD_Float64x2_check");

Ref makeJsCoercedZero(JsType type) {
  switch (type) {
    case JS_INT:
      return ValueBuilder::makeNum(0);
    case JS_DOUBLE:
      return ValueBuilder::makeUnary(PLUS, ValueBuilder::makeNum(0));
    case JS_FLOAT: {
      if (!JS_FLOAT_ZERO.isNull()) {
        return ValueBuilder::makeName(JS_FLOAT_ZERO);
      } else {
        return ValueBuilder::makeCall(MATH_FROUND, ValueBuilder::makeNum(0));
      }
    }
    case JS_FLOAT32X4: {
      return ValueBuilder::makeCall(SIMD_FLOAT32X4,
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0));
    }
    case JS_FLOAT64X2: {
      return ValueBuilder::makeCall(
        SIMD_FLOAT64X2, ValueBuilder::makeNum(0), ValueBuilder::makeNum(0));
    }
    case JS_INT8X16: {
      return ValueBuilder::makeCall(SIMD_INT8X16,
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0));
    }
    case JS_INT16X8: {
      return ValueBuilder::makeCall(SIMD_INT16X8,
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0));
    }
    case JS_INT32X4: {
      return ValueBuilder::makeCall(SIMD_INT32X4,
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0));
    }
    case JS_REF: {
      return ValueBuilder::makeName(wasm::NULL_);
    }
    default:
      assert(0);
  }
  abort();
}

bool needsJsCoercion(JsType type) {
  // References need no coercion, but everything else does.
  return type != JS_REF;
}

Ref makeJsCoercion(Ref node, JsType type) {
  switch (type) {
    case JS_INT:
      return ValueBuilder::makeBinary(node, OR, ValueBuilder::makeNum(0));
    case JS_DOUBLE:
      return ValueBuilder::makeUnary(PLUS, node);
    case JS_FLOAT:
      return ValueBuilder::makeCall(MATH_FROUND, node);
    case JS_FLOAT32X4:
      return ValueBuilder::makeCall(SIMD_FLOAT32X4_CHECK, node);
    case JS_FLOAT64X2:
      return ValueBuilder::makeCall(SIMD_FLOAT64X2_CHECK, node);
    case JS_INT8X16:
      return ValueBuilder::makeCall(SIMD_INT8X16_CHECK, node);
    case JS_INT16X8:
      return ValueBuilder::makeCall(SIMD_INT16X8_CHECK, node);
    case JS_INT32X4:
      return ValueBuilder::makeCall(SIMD_INT32X4_CHECK, node);
    case JS_REF:
    case JS_NONE:
    default:
      // No coercion is needed.
      // TODO see if JS_NONE is actually used here.
      return node;
  }
}

Ref makeSigning(Ref node, JsSign sign) {
  assert(sign == JS_SIGNED || sign == JS_UNSIGNED);
  return ValueBuilder::makeBinary(
    node, sign == JS_SIGNED ? OR : TRSHIFT, ValueBuilder::makeNum(0));
}
