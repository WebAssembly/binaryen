/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_ir_eh_h
#define wasm_ir_eh_h

#include "wasm.h"

namespace wasm {

namespace EHUtils {

// Returns true if a 'pop' instruction exists in a valid location, which means
// right after a 'catch' instruction in binary writing order.
// - This assumes there should be at least a single pop. So given a catch body
//   whose tag type is void or a catch_all's body, this returns false.
// - This returns true even if there are more pops after the first one within a
//   catch body, which is invalid. That will be taken care of in validation.
bool isPopValid(Expression* catchBody);

} // namespace EHUtils

} // namespace wasm

#endif // wasm_ir_eh_h
