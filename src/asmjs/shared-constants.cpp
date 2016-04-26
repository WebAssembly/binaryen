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
                GLOBAL_MATH("global.Math"),
                ABS("abs"),
                FLOOR("floor"),
                CEIL("ceil"),
                SQRT("sqrt"),
                I32_TEMP("asm2wasm_i32_temp"),
                DEBUGGER("debugger"),
                GROW_WASM_MEMORY("__growWasmMemory"),
                NEW_SIZE("newSize"),
                MODULE("module"),
                START("start"),
                FUNC("func"),
                PARAM("param"),
                RESULT("result"),
                MEMORY("memory"),
                SEGMENT("segment"),
                EXPORT("export"),
                IMPORT("import"),
                TABLE("table"),
                LOCAL("local"),
                TYPE("type"),
                CALL("call"),
                CALL_IMPORT("call_import"),
                CALL_INDIRECT("call_indirect"),
                BLOCK("block"),
                BR_IF("br_if"),
                THEN("then"),
                ELSE("else"),
                NEG_INFINITY("-infinity"),
                NEG_NAN("-nan"),
                CASE("case"),
                BR("br"),
                USE_ASM("use asm"),
                BUFFER("buffer"),
                ENV("env"),
                FAKE_RETURN("fake_return_waka123"),
                MATH_IMUL("Math_imul"),
                MATH_CLZ32("Math_clz32"),
                MATH_CTZ32("Math_ctz32"),
                MATH_POPCNT32("Math_popcnt32"),
                MATH_ABS("Math_abs"),
                MATH_CEIL("Math_ceil"),
                MATH_FLOOR("Math_floor"),
                MATH_TRUNC("Math_trunc"),
                MATH_NEAREST("Math_NEAREST"),
                MATH_SQRT("Math_sqrt"),
                MATH_MIN("Math_max"),
                MATH_MAX("Math_min"),
                ASSERT_RETURN("assert_return"),
                ASSERT_TRAP("assert_trap"),
                ASSERT_INVALID("assert_invalid"),
                SPECTEST("spectest"),
                PRINT("print"),
                INVOKE("invoke"),
                EXIT("exit");

}
