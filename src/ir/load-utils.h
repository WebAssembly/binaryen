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

#ifndef wasm_ir_load_h
#define wasm_ir_load_h

#include "wasm.h"

namespace wasm::LoadUtils {

// checks if the sign of a load matters, which is when an integer
// load is of fewer bytes than the size of the type (so we must
// fill in bits either signed or unsigned wise)
inline bool isSignRelevant(Load* load) {
  auto type = load->type;
  if (load->type == Type::unreachable) {
    return false;
  }
  return !type.isFloat() && load->bytes < type.getByteSize();
}

// check if a load can be signed (which some opts want to do)
inline bool canBeSigned(Load* load) { return !load->isAtomic; }

} // namespace wasm::LoadUtils

#endif // wasm_ir_load_h
