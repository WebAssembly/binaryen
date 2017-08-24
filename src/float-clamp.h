/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Helper functions for supporting potentially-trapping float operations.
//

#ifndef wasm_float_clamp_h
#define wasm_float_clamp_h

namespace wasm {

enum class FloatTrapMode {
  Allow,
  Clamp,
  JS
};

} // namespace wasm

#endif // wasm_float_clamp_h
