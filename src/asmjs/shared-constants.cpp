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
                ARRAY_BUFFER("ArrayBuffer"),
                ASM_MODULE("asmModule"),
                IMPOSSIBLE_CONTINUE("impossible-continue"),
                MATH("Math"),
                IMUL("imul"),
                CLZ32("clz32"),
                FROUND("fround"),
                ASM2WASM("asm2wasm"),
                MIN("min"),
                MAX("max"),
                F64_REM("f64-rem"),
                F64_TO_INT("f64-to-int"),
                F64_TO_UINT("f64-to-uint"),
                F64_TO_INT64("f64-to-int64"),
                F64_TO_UINT64("f64-to-uint64"),
                F32_TO_INT("f32-to-int"),
                F32_TO_UINT("f32-to-uint"),
                F32_TO_INT64("f32-to-int64"),
                F32_TO_UINT64("f32-to-uint64"),
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
                ALMOST_ASM("almost asm"),
                BUFFER("buffer"),
                ENV("env"),
                INSTRUMENT("instrument"),
                MATH_IMUL("Math_imul"),
                MATH_ABS("Math_abs"),
                MATH_CEIL("Math_ceil"),
                MATH_CLZ32("Math_clz32"),
                MATH_FLOOR("Math_floor"),
                MATH_TRUNC("Math_trunc"),
                MATH_SQRT("Math_sqrt"),
                MATH_MIN("Math_min"),
                MATH_MAX("Math_max"),
                WASM_CTZ32("__wasm_ctz_i32"),
                WASM_CTZ64("__wasm_ctz_i64"),
                WASM_CLZ32("__wasm_clz_i32"),
                WASM_CLZ64("__wasm_clz_i64"),
                WASM_POPCNT32("__wasm_popcnt_i32"),
                WASM_POPCNT64("__wasm_popcnt_i64"),
                WASM_ROTL32("__wasm_rotl_i32"),
                WASM_ROTL64("__wasm_rotl_i64"),
                WASM_ROTR32("__wasm_rotr_i32"),
                WASM_ROTR64("__wasm_rotr_i64"),
                WASM_GROW_MEMORY("__wasm_grow_memory"),
                WASM_CURRENT_MEMORY("__wasm_current_memory"),
                WASM_FETCH_HIGH_BITS("__wasm_fetch_high_bits"),
                INT64_TO_32_HIGH_BITS("i64toi32_i32$HIGH_BITS"),
                WASM_NEAREST_F32("__wasm_nearest_f32"),
                WASM_NEAREST_F64("__wasm_nearest_f64"),
                WASM_TRUNC_F32("__wasm_trunc_f32"),
                WASM_TRUNC_F64("__wasm_trunc_f64"),
                WASM_I64_MUL("__wasm_i64_mul"),
                WASM_I64_SDIV("__wasm_i64_sdiv"),
                WASM_I64_UDIV("__wasm_i64_udiv"),
                WASM_I64_SREM("__wasm_i64_srem"),
                WASM_I64_UREM("__wasm_i64_urem");
}
