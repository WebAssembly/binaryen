/*
 * Copyright 2019 WebAssembly Community Group participants
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

//
// Comprehensive debug info support (beyond source maps).
//

#ifndef wasm_wasm_debug_h
#define wasm_wasm_debug_h

#include <string>

#include "wasm.h"

namespace wasm {

namespace Debug {

bool isDWARFSection(Name name);

bool hasDWARFSections(const Module& wasm);

// Dump the DWARF sections to stdout.
void dumpDWARF(const Module& wasm);

// Update the DWARF sections.
void writeDWARFSections(Module& wasm);

} // namespace Debug

} // namespace wasm

#undef DEBUG_TYPE

#endif // wasm_wasm_debug_h
