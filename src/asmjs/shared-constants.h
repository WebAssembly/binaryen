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

#ifndef wasm_asmjs_shared_constants_h
#define wasm_asmjs_shared_constants_h

#include "emscripten-optimizer/istring.h"

namespace wasm {

extern cashew::IString GLOBAL,
                NAN_,
                INFINITY_,
                NAN__,
                INFINITY__,
                TOPMOST,
                INT8ARRAY,
                INT16ARRAY,
                INT32ARRAY,
                UINT8ARRAY,
                UINT16ARRAY,
                UINT32ARRAY,
                FLOAT32ARRAY,
                FLOAT64ARRAY,
                ARRAY_BUFFER,
                ASM_MODULE,
                IMPOSSIBLE_CONTINUE,
                MATH,
                IMUL,
                CLZ32,
                FROUND,
                ASM2WASM,
                MIN,
                MAX,
                F64_REM,
                F64_TO_INT,
                F64_TO_UINT,
                F64_TO_INT64,
                F64_TO_UINT64,
                F32_TO_INT,
                F32_TO_UINT,
                F32_TO_INT64,
                F32_TO_UINT64,
                I32S_DIV,
                I32U_DIV,
                I32S_REM,
                I32U_REM,
                GLOBAL_MATH,
                ABS,
                FLOOR,
                CEIL,
                SQRT,
                POW,
                I32_TEMP,
                DEBUGGER,
                USE_ASM,
                ALMOST_ASM,
                BUFFER,
                ENV,
                INSTRUMENT,
                MATH_IMUL,
                MATH_ABS,
                MATH_CEIL,
                MATH_CLZ32,
                MATH_FLOOR,
                MATH_TRUNC,
                MATH_SQRT,
                MATH_MIN,
                MATH_MAX,
                WASM_CTZ32,
                WASM_CTZ64,
                WASM_CLZ32,
                WASM_CLZ64,
                WASM_POPCNT32,
                WASM_POPCNT64,
                WASM_ROTL32,
                WASM_ROTL64,
                WASM_ROTR32,
                WASM_ROTR64,
                WASM_GROW_MEMORY,
                WASM_CURRENT_MEMORY,
                WASM_FETCH_HIGH_BITS,
                INT64_TO_32_HIGH_BITS,
                WASM_NEAREST_F32,
                WASM_NEAREST_F64,
                WASM_TRUNC_F32,
                WASM_TRUNC_F64,
                WASM_I64_MUL,
                WASM_I64_SDIV,
                WASM_I64_UDIV,
                WASM_I64_SREM,
                WASM_I64_UREM;
}

#endif // wasm_asmjs_shared_constants_h
