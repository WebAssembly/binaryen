/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef wasm_passes_string_utils_h
#define wasm_passes_string_utils_h

#include "support/name.h"

namespace wasm {

// The name of the module to import from, for imported JS strings. See
// https://github.com/WebAssembly/js-string-builtins/blob/main/proposals/js-string-builtins/Overview.md
extern const Name WasmStringsModule;

// The default module to import string constants from, for magical imported JS
// strings.
extern const char* WasmStringConstsModule;

} // namespace wasm

#endif // wasm_passes_string_utils_h
