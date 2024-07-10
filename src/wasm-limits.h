/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_wasm_limits_h
#define wasm_wasm_limits_h

#include <stdint.h>

namespace wasm {

// wasm VMs on the web have decided to impose some limits on what they
// accept (see e.g. https://github.com/v8/v8/blob/main/src/wasm/wasm-limits.h).
enum WebLimitations : uint32_t {
  MaxDataSegments = 100 * 1000,
  MaxTableSize = 10 * 1000 * 1000,
  MaxFunctionBodySize = 128 * 1024,
  MaxFunctionLocals = 50 * 1000,
  MaxFunctionParams = 1000
};

} // namespace wasm

#endif // wasm_wasm_limits_h
