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
#define wasm_shared_constants_h

#include "wasm.h"

namespace wasm {

extern Name STACK_POINTER;
extern Name MODULE;
extern Name START;
extern Name FUNC;
extern Name CONT;
extern Name PARAM;
extern Name RESULT;
extern Name MEMORY;
extern Name DATA;
extern Name PASSIVE;
extern Name EXPORT;
extern Name IMPORT;
extern Name TABLE;
extern Name GLOBAL;
extern Name ELEM;
extern Name LOCAL;
extern Name TYPE;
extern Name REF;
extern Name NULL_;
extern Name CALL;
extern Name CALL_IMPORT;
extern Name CALL_INDIRECT;
extern Name BLOCK;
extern Name BR_IF;
extern Name THEN;
extern Name ELSE;
extern Name _NAN;
extern Name _INFINITY;
extern Name NEG_INFINITY;
extern Name NEG_NAN;
extern Name CASE;
extern Name BR;
extern Name FUNCREF;
extern Name FAKE_RETURN;
extern Name DELEGATE_CALLER_TARGET;
extern Name MUT;
extern Name SPECTEST;
extern Name PRINT;
extern Name EXIT;
extern Name SHARED;
extern Name TAG;
extern Name TUPLE;

} // namespace wasm

#endif // wasm_shared_constants_h
