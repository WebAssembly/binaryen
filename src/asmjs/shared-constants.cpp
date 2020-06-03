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

cashew::IString GLOBAL("global");
cashew::IString NAN_("NaN");
cashew::IString INFINITY_("Infinity");
cashew::IString NAN__("nan");
cashew::IString INFINITY__("infinity");
cashew::IString TOPMOST("topmost");
cashew::IString INT8ARRAY("Int8Array");
cashew::IString INT16ARRAY("Int16Array");
cashew::IString INT32ARRAY("Int32Array");
cashew::IString UINT8ARRAY("Uint8Array");
cashew::IString UINT16ARRAY("Uint16Array");
cashew::IString UINT32ARRAY("Uint32Array");
cashew::IString FLOAT32ARRAY("Float32Array");
cashew::IString FLOAT64ARRAY("Float64Array");
cashew::IString ARRAY_BUFFER("ArrayBuffer");
cashew::IString ASM_MODULE("asmModule");
cashew::IString IMPOSSIBLE_CONTINUE("impossible-continue");
cashew::IString MATH("Math");
cashew::IString IMUL("imul");
cashew::IString CLZ32("clz32");
cashew::IString FROUND("fround");
cashew::IString ASM2WASM("asm2wasm");
cashew::IString MIN("min");
cashew::IString MAX("max");
cashew::IString F64_REM("f64-rem");
cashew::IString F64_TO_INT("f64-to-int");
cashew::IString F64_TO_UINT("f64-to-uint");
cashew::IString F64_TO_INT64("f64-to-int64");
cashew::IString F64_TO_UINT64("f64-to-uint64");
cashew::IString F32_TO_INT("f32-to-int");
cashew::IString F32_TO_UINT("f32-to-uint");
cashew::IString F32_TO_INT64("f32-to-int64");
cashew::IString F32_TO_UINT64("f32-to-uint64");
cashew::IString I32S_DIV("i32s-div");
cashew::IString I32U_DIV("i32u-div");
cashew::IString I32S_REM("i32s-rem");
cashew::IString I32U_REM("i32u-rem");
cashew::IString GLOBAL_MATH("global.Math");
cashew::IString ABS("abs");
cashew::IString FLOOR("floor");
cashew::IString CEIL("ceil");
cashew::IString SQRT("sqrt");
cashew::IString POW("pow");
cashew::IString I32_TEMP("asm2wasm_i32_temp");
cashew::IString DEBUGGER("debugger");
cashew::IString BUFFER("buffer");
cashew::IString ENV("env");
cashew::IString STACKTOP("STACKTOP");
cashew::IString STACK_MAX("STACK_MAX");
cashew::IString INSTRUMENT("instrument");
cashew::IString MATH_IMUL("Math_imul");
cashew::IString MATH_ABS("Math_abs");
cashew::IString MATH_CEIL("Math_ceil");
cashew::IString MATH_CLZ32("Math_clz32");
cashew::IString MATH_FLOOR("Math_floor");
cashew::IString MATH_TRUNC("Math_trunc");
cashew::IString MATH_SQRT("Math_sqrt");
cashew::IString MATH_MIN("Math_min");
cashew::IString MATH_MAX("Math_max");
cashew::IString WASM_CTZ32("__wasm_ctz_i32");
cashew::IString WASM_CTZ64("__wasm_ctz_i64");
cashew::IString WASM_CLZ32("__wasm_clz_i32");
cashew::IString WASM_CLZ64("__wasm_clz_i64");
cashew::IString WASM_POPCNT32("__wasm_popcnt_i32");
cashew::IString WASM_POPCNT64("__wasm_popcnt_i64");
cashew::IString WASM_ROTL32("__wasm_rotl_i32");
cashew::IString WASM_ROTL64("__wasm_rotl_i64");
cashew::IString WASM_ROTR32("__wasm_rotr_i32");
cashew::IString WASM_ROTR64("__wasm_rotr_i64");
cashew::IString WASM_MEMORY_GROW("__wasm_memory_grow");
cashew::IString WASM_MEMORY_SIZE("__wasm_memory_size");
cashew::IString WASM_FETCH_HIGH_BITS("__wasm_fetch_high_bits");
cashew::IString INT64_TO_32_HIGH_BITS("i64toi32_i32$HIGH_BITS");
cashew::IString WASM_NEAREST_F32("__wasm_nearest_f32");
cashew::IString WASM_NEAREST_F64("__wasm_nearest_f64");
cashew::IString WASM_TRUNC_F32("__wasm_trunc_f32");
cashew::IString WASM_TRUNC_F64("__wasm_trunc_f64");
cashew::IString WASM_I64_MUL("__wasm_i64_mul");
cashew::IString WASM_I64_SDIV("__wasm_i64_sdiv");
cashew::IString WASM_I64_UDIV("__wasm_i64_udiv");
cashew::IString WASM_I64_SREM("__wasm_i64_srem");
cashew::IString WASM_I64_UREM("__wasm_i64_urem");

namespace ABI {
namespace wasm2js {

cashew::IString SCRATCH_LOAD_I32("wasm2js_scratch_load_i32");
cashew::IString SCRATCH_STORE_I32("wasm2js_scratch_store_i32");
cashew::IString SCRATCH_LOAD_I64("wasm2js_scratch_load_i64");
cashew::IString SCRATCH_STORE_I64("wasm2js_scratch_store_i64");
cashew::IString SCRATCH_LOAD_F32("wasm2js_scratch_load_f32");
cashew::IString SCRATCH_STORE_F32("wasm2js_scratch_store_f32");
cashew::IString SCRATCH_LOAD_F64("wasm2js_scratch_load_f64");
cashew::IString SCRATCH_STORE_F64("wasm2js_scratch_store_f64");

} // namespace wasm2js
} // namespace ABI

} // namespace wasm
