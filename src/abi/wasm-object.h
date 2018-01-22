/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Contains definitions used for wasm object files.
// See: https://github.com/WebAssembly/tool-conventions/blob/master/Linking.md
//

#ifndef wasm_abi_wasm_object_h
#define wasm_abi_wasm_object_h

namespace wasm {

namespace ABI {
  enum LinkType : unsigned {
    WASM_STACK_POINTER  = 0x1,
    WASM_SYMBOL_INFO    = 0x2,
    WASM_DATA_SIZE      = 0x3,
    WASM_DATA_ALIGNMENT = 0x4,
    WASM_SEGMENT_INFO   = 0x5,
    WASM_INIT_FUNCS     = 0x6,
  };
} // namespace ABI

} // namespace wasm

#endif // wasm_abi_wasm_object_h
