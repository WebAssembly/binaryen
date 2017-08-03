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

#include "asmjs/shared-constants.h"

namespace wasm {

cashew::IString GLOBAL("global"),
                NAN_("NaN"),
                INFINITY_("Infinity"),
                NAN__("nan"),
                INFINITY__("infinity"),
                TOPMOST("topmost"),
                INT8ARRAY("Int8Array"),
                INT16ARRAY("Int16Array"),
                INT32ARRAY("Int32Array"),
                UINT8ARRAY("Uint8Array"),
                UINT16ARRAY("Uint16Array"),
                UINT32ARRAY("Uint32Array"),
                FLOAT32ARRAY("Float32Array"),
                FLOAT64ARRAY("Float64Array"),
                IMPOSSIBLE_CONTINUE("impossible-continue"),
                MATH("Math"),
                IMUL("imul"),
                CLZ32("clz32"),
                FROUND("fround"),
                ASM2WASM("asm2wasm"),
                F64_REM("f64-rem"),
                F64_TO_INT("f64-to-int"),
                F64_TO_INT64("f64-to-int64"),
                I32S_DIV("i32s-div"),
                I32U_DIV("i32u-div"),
                I32S_REM("i32s-rem"),
                I32U_REM("i32u-rem"),
                GLOBAL_MATH("global.Math"),
                ABS("abs"),
                FLOOR("floor"),
                CEIL("ceil"),
                SQRT("sqrt"),
                POW("pow"),
                I32_TEMP("asm2wasm_i32_temp"),
                DEBUGGER("debugger"),
                USE_ASM("use asm"),
                BUFFER("buffer"),
                ENV("env"),
                INSTRUMENT("instrument"),
                MATH_IMUL("Math_imul"),
                MATH_ABS("Math_abs"),
                MATH_CEIL("Math_ceil"),
                MATH_FLOOR("Math_floor"),
                MATH_TRUNC("Math_trunc"),
                MATH_NEAREST("Math_NEAREST"),
                MATH_SQRT("Math_sqrt"),
                MATH_MIN("Math_min"),
                MATH_MAX("Math_max"),
                CTZ32("__ctz_i32"),
                CTZ64("__ctz_i64"),
                POPCNT32("__popcnt_i32"),
                POPCNT64("__popcnt_i64"),
                ROTL32("__rotl_i32"),
                ROTL64("__rotl_i64"),
                ROTR32("__rotr_i32"),
                ROTR64("__rotr_i64");
}
