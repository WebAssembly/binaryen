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

#ifndef wasm_abi_abi_h
#define wasm_abi_abi_h

#include "wasm.h"

namespace wasm {

namespace ABI {

enum class LegalizationLevel {
  Full = 0,
  Minimal = 1
};

inline std::string getLegalizationPass(LegalizationLevel level) {
  if (level == LegalizationLevel::Full) {
    return "legalize-js-interface";
  } else {
    return "legalize-js-interface-minimally";
  }
}

} // namespace ABI

} // namespace wasm

#endif // wasm_abi_abi_h
