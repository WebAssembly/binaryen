/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_ir_string_builtin_names_h
#define wasm_ir_string_builtin_names_h

#include "ir/import-names.h"
#include <array>

namespace wasm {

namespace StringBuiltins {

extern const ImportNames fromCharCodeArray;
extern const ImportNames fromCodePoint;
extern const ImportNames concat;
extern const ImportNames intoCharCodeArray;
extern const ImportNames equals;
extern const ImportNames test;
extern const ImportNames compare;
extern const ImportNames length;
extern const ImportNames charCodeAt;
extern const ImportNames substring;

extern const std::array<ImportNames, 10> allBuiltins;

} // namespace StringBuiltins

} // namespace wasm

#endif // wasm_ir_string_builtin_names_h
