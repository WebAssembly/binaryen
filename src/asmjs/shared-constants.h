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

#include "support/istring.h"

namespace wasm {

extern IString TOPMOST;
extern IString INT8ARRAY;
extern IString INT16ARRAY;
extern IString INT32ARRAY;
extern IString UINT8ARRAY;
extern IString UINT16ARRAY;
extern IString UINT32ARRAY;
extern IString FLOAT32ARRAY;
extern IString FLOAT64ARRAY;
extern IString ARRAY_BUFFER;
extern IString ASM_MODULE;
extern IString MATH;
extern IString IMUL;
extern IString CLZ32;
extern IString FROUND;
extern IString ASM2WASM;
extern IString MIN;
extern IString MAX;
extern IString F64_REM;
extern IString F64_TO_INT;
extern IString F64_TO_UINT;
extern IString F64_TO_INT64;
extern IString F64_TO_UINT64;
extern IString F32_TO_INT;
extern IString F32_TO_UINT;
extern IString F32_TO_INT64;
extern IString F32_TO_UINT64;
extern IString I32S_DIV;
extern IString I32U_DIV;
extern IString I32S_REM;
extern IString I32U_REM;
extern IString ABS;
extern IString FLOOR;
extern IString CEIL;
extern IString TRUNC;
extern IString SQRT;
extern IString POW;
extern IString I32_TEMP;
extern IString DEBUGGER;
extern IString BUFFER;
extern IString ENV;
extern IString STACKTOP;
extern IString STACK_MAX;
extern IString INSTRUMENT;
extern IString LENGTH;
extern IString MATH_IMUL;
extern IString MATH_ABS;
extern IString MATH_CLZ32;
extern IString MATH_CEIL;
extern IString MATH_FLOOR;
extern IString MATH_TRUNC;
extern IString MATH_SQRT;
extern IString MATH_MIN;
extern IString MATH_MAX;
extern IString WASM_CTZ32;
extern IString WASM_CTZ64;
extern IString WASM_CLZ32;
extern IString WASM_CLZ64;
extern IString WASM_POPCNT32;
extern IString WASM_POPCNT64;
extern IString WASM_ROTL32;
extern IString WASM_ROTL64;
extern IString WASM_ROTR32;
extern IString WASM_ROTR64;
extern IString WASM_MEMORY_GROW;
extern IString WASM_MEMORY_SIZE;
extern IString WASM_FETCH_HIGH_BITS;
extern IString INT64_TO_32_HIGH_BITS;
extern IString WASM_NEAREST_F32;
extern IString WASM_NEAREST_F64;
extern IString WASM_I64_MUL;
extern IString WASM_I64_SDIV;
extern IString WASM_I64_UDIV;
extern IString WASM_I64_SREM;
extern IString WASM_I64_UREM;
// wasm2js constants
extern IString ASM_FUNC;
extern IString FUNCTION_TABLE;
extern IString NO_RESULT;
extern IString EXPRESSION_RESULT;
} // namespace wasm

#endif // wasm_asmjs_shared_constants_h
