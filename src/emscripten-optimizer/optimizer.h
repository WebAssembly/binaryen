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

#ifndef wasm_optimizer_h
#define wasm_optimizer_h

#include "simple_ast.h"

using IString = wasm::IString;

extern IString JS_FLOAT_ZERO;

extern IString SIMD_INT8X16_CHECK;
extern IString SIMD_INT16X8_CHECK;
extern IString SIMD_INT32X4_CHECK;
extern IString SIMD_FLOAT32X4_CHECK;
extern IString SIMD_FLOAT64X2_CHECK;

enum JsType {
  JS_INT = 0,
  JS_DOUBLE,
  JS_FLOAT,
  JS_FLOAT32X4,
  JS_FLOAT64X2,
  JS_INT8X16,
  JS_INT16X8,
  JS_INT32X4,
  JS_INT64,
  JS_REF,
  JS_NONE // number of types
};

enum JsSign {
  // small constants can be signed or unsigned, variables are also flexible
  JS_FLEXIBLE = 0,
  JS_SIGNED,
  JS_UNSIGNED,
  JS_NONSIGNED,
};

cashew::Ref makeJsCoercedZero(JsType type);
bool needsJsCoercion(JsType type);
cashew::Ref makeJsCoercion(cashew::Ref node, JsType type);
cashew::Ref makeSigning(cashew::Ref node, JsSign sign);

#endif // wasm_optimizer_h
