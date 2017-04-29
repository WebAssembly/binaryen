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
                IMPOSSIBLE_CONTINUE,
                MATH,
                IMUL,
                CLZ32,
                FROUND,
                ASM2WASM,
                F64_REM,
                F64_TO_INT,
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
                BUFFER,
                ENV,
                INSTRUMENT,
                MATH_IMUL,
                MATH_CLZ32,
                MATH_CTZ32,
                MATH_POPCNT32,
                MATH_ABS,
                MATH_CEIL,
                MATH_FLOOR,
                MATH_TRUNC,
                MATH_NEAREST,
                MATH_SQRT,
                MATH_MIN,
                MATH_MAX;

}

#endif // wasm_asmjs_shared_constants_h
