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

// Utilities for dealing with Wasm modules embedded as literal byte arrays in JS
// files.

#ifndef wasm_support_js_embedded_module_h
#define wasm_support_js_embedded_module_h

#include <cstddef>
#include <string>
#include <string_view>
#include <vector>

namespace wasm {

struct EmbeddedModule {
  // Index of '[' in the JS source string.
  size_t start;
  // Index immediately after ']' in the JS source string.
  size_t end;
  // Decoded binary Wasm module bytes.
  std::vector<char> bytes;

  bool operator==(const EmbeddedModule& other) const {
    return start == other.start && end == other.end && bytes == other.bytes;
  }
};

// Scans JavaScript source code `js` and returns all embedded byte array
// literals (`[...]`) whose initial bytes match the WebAssembly magic header
// (`0x00, 0x61, 0x73, 0x6d`).
std::vector<EmbeddedModule> findEmbeddedModules(std::string_view js);

// Formats a binary WebAssembly byte buffer as a JavaScript hex byte array
// literal (`[\n  0x00, 0x61, 0x73, 0x6d, ...\n]`).
std::string formatByteArray(const std::vector<char>& bytes);

} // namespace wasm

#endif // wasm_support_js_embedded_module_h
