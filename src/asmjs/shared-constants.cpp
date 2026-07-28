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

IString TOPMOST("topmost");
IString INT8ARRAY("Int8Array");
IString INT16ARRAY("Int16Array");
IString INT32ARRAY("Int32Array");
IString UINT8ARRAY("Uint8Array");
IString UINT16ARRAY("Uint16Array");
IString UINT32ARRAY("Uint32Array");
IString FLOAT32ARRAY("Float32Array");
IString FLOAT64ARRAY("Float64Array");
IString ARRAY_BUFFER("ArrayBuffer");
IString ASM_MODULE("asmModule");
IString MATH("Math");
IString IMUL("imul");
IString CLZ32("clz32");
IString FROUND("fround");
IString ASM2WASM("asm2wasm");
IString MIN("min");
IString MAX("max");
IString F64_REM("f64-rem");
IString F64_TO_INT("f64-to-int");
IString F64_TO_UINT("f64-to-uint");
IString F32_TO_INT("f32-to-int");
IString F32_TO_UINT("f32-to-uint");
IString I32S_DIV("i32s-div");
IString I32U_DIV("i32u-div");
IString I32S_REM("i32s-rem");
IString I32U_REM("i32u-rem");
IString ABS("abs");
IString FLOOR("floor");
IString CEIL("ceil");
IString TRUNC("trunc");
IString SQRT("sqrt");
IString POW("pow");
IString I32_TEMP("asm2wasm_i32_temp");
IString DEBUGGER("debugger");
IString BUFFER("buffer");
IString ENV("env");
IString STACKTOP("STACKTOP");
IString STACK_MAX("STACK_MAX");
IString INSTRUMENT("instrument");
IString LENGTH("length");
IString MATH_IMUL("Math_imul");
IString MATH_ABS("Math_abs");
IString MATH_CEIL("Math_ceil");
IString MATH_CLZ32("Math_clz32");
IString MATH_FLOOR("Math_floor");
IString MATH_TRUNC("Math_trunc");
IString MATH_SQRT("Math_sqrt");
IString MATH_MIN("Math_min");
IString MATH_MAX("Math_max");
IString WASM_MEMORY_GROW("__wasm_memory_grow");
IString WASM_MEMORY_SIZE("__wasm_memory_size");
IString WASM_FETCH_HIGH_BITS("__wasm_fetch_high_bits");
IString INT64_TO_32_HIGH_BITS("i64toi32_i32$HIGH_BITS");

IString ASM_FUNC("asmFunc");
IString FUNCTION_TABLE("FUNCTION_TABLE");
IString NO_RESULT("wasm2js$noresult"); // no result at all
// result in an expression, no temp var
IString EXPRESSION_RESULT("wasm2js$expresult");

namespace ABI {
namespace wasm2js {

IString SCRATCH_LOAD_I32("wasm2js_scratch_load_i32");
IString SCRATCH_STORE_I32("wasm2js_scratch_store_i32");
IString SCRATCH_LOAD_F32("wasm2js_scratch_load_f32");
IString SCRATCH_STORE_F32("wasm2js_scratch_store_f32");
IString SCRATCH_LOAD_F64("wasm2js_scratch_load_f64");
IString SCRATCH_STORE_F64("wasm2js_scratch_store_f64");
IString MEMORY_INIT("wasm2js_memory_init");
IString MEMORY_FILL("wasm2js_memory_fill");
IString MEMORY_COPY("wasm2js_memory_copy");
IString TABLE_GROW("wasm2js_table_grow");
IString TABLE_FILL("wasm2js_table_fill");
IString TABLE_COPY("wasm2js_table_copy");
IString DATA_DROP("wasm2js_data_drop");
IString ATOMIC_WAIT_I32("wasm2js_atomic_wait_i32");
IString ATOMIC_RMW_I64("wasm2js_atomic_rmw_i64");
IString GET_STASHED_BITS("wasm2js_get_stashed_bits");
IString TRAP("wasm2js_trap");

} // namespace wasm2js
} // namespace ABI

} // namespace wasm
