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

extern cashew::IString GLOBAL;
extern cashew::IString NAN_;
extern cashew::IString INFINITY_;
extern cashew::IString NAN__;
extern cashew::IString INFINITY__;
extern cashew::IString TOPMOST;
extern cashew::IString INT8ARRAY;
extern cashew::IString INT16ARRAY;
extern cashew::IString INT32ARRAY;
extern cashew::IString UINT8ARRAY;
extern cashew::IString UINT16ARRAY;
extern cashew::IString UINT32ARRAY;
extern cashew::IString FLOAT32ARRAY;
extern cashew::IString FLOAT64ARRAY;
extern cashew::IString ARRAY_BUFFER;
extern cashew::IString ASM_MODULE;
extern cashew::IString IMPOSSIBLE_CONTINUE;
extern cashew::IString MATH;
extern cashew::IString IMUL;
extern cashew::IString CLZ32;
extern cashew::IString FROUND;
extern cashew::IString ASM2WASM;
extern cashew::IString MIN;
extern cashew::IString MAX;
extern cashew::IString F64_REM;
extern cashew::IString F64_TO_INT;
extern cashew::IString F64_TO_UINT;
extern cashew::IString F64_TO_INT64;
extern cashew::IString F64_TO_UINT64;
extern cashew::IString F32_TO_INT;
extern cashew::IString F32_TO_UINT;
extern cashew::IString F32_TO_INT64;
extern cashew::IString F32_TO_UINT64;
extern cashew::IString I32S_DIV;
extern cashew::IString I32U_DIV;
extern cashew::IString I32S_REM;
extern cashew::IString I32U_REM;
extern cashew::IString GLOBAL_MATH;
extern cashew::IString ABS;
extern cashew::IString FLOOR;
extern cashew::IString CEIL;
extern cashew::IString SQRT;
extern cashew::IString POW;
extern cashew::IString I32_TEMP;
extern cashew::IString DEBUGGER;
extern cashew::IString BUFFER;
extern cashew::IString ENV;
extern cashew::IString STACKTOP;
extern cashew::IString STACK_MAX;
extern cashew::IString INSTRUMENT;
extern cashew::IString MATH_IMUL;
extern cashew::IString MATH_ABS;
extern cashew::IString MATH_CEIL;
extern cashew::IString MATH_CLZ32;
extern cashew::IString MATH_FLOOR;
extern cashew::IString MATH_TRUNC;
extern cashew::IString MATH_SQRT;
extern cashew::IString MATH_MIN;
extern cashew::IString MATH_MAX;
extern cashew::IString WASM_CTZ32;
extern cashew::IString WASM_CTZ64;
extern cashew::IString WASM_CLZ32;
extern cashew::IString WASM_CLZ64;
extern cashew::IString WASM_POPCNT32;
extern cashew::IString WASM_POPCNT64;
extern cashew::IString WASM_ROTL32;
extern cashew::IString WASM_ROTL64;
extern cashew::IString WASM_ROTR32;
extern cashew::IString WASM_ROTR64;
extern cashew::IString WASM_MEMORY_GROW;
extern cashew::IString WASM_MEMORY_SIZE;
extern cashew::IString WASM_FETCH_HIGH_BITS;
extern cashew::IString INT64_TO_32_HIGH_BITS;
extern cashew::IString WASM_NEAREST_F32;
extern cashew::IString WASM_NEAREST_F64;
extern cashew::IString WASM_TRUNC_F32;
extern cashew::IString WASM_TRUNC_F64;
extern cashew::IString WASM_I64_MUL;
extern cashew::IString WASM_I64_SDIV;
extern cashew::IString WASM_I64_UDIV;
extern cashew::IString WASM_I64_SREM;
extern cashew::IString WASM_I64_UREM;
} // namespace wasm

#endif // wasm_asmjs_shared_constants_h
