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

#ifndef wasm_shared_constants_h

#include "wasm.h"

namespace wasm {

extern Name GROW_WASM_MEMORY,
            MEMORY_BASE,
            TABLE_BASE,
            NEW_SIZE,
            MODULE,
            START,
            FUNC,
            PARAM,
            RESULT,
            MEMORY,
            DATA,
            SEGMENT,
            EXPORT,
            IMPORT,
            TABLE,
            ELEM,
            LOCAL,
            TYPE,
            CALL,
            CALL_IMPORT,
            CALL_INDIRECT,
            BLOCK,
            BR_IF,
            THEN,
            ELSE,
            _NAN,
            _INFINITY,
            NEG_INFINITY,
            NEG_NAN,
            CASE,
            BR,
            ANYFUNC,
            FAKE_RETURN,
            MUT,
            SPECTEST,
            PRINT,
            EXIT;

} // namespace wasm

#endif // wasm_shared_constants_h
