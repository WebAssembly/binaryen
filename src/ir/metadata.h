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

#ifndef wasm_ir_metadata_h
#define wasm_ir_metadata_h

#include "wasm.h"

namespace wasm::metadata {

// Given an expression and a copy of it in another function, copy the all
// metadata - debug info, code annotations - into the second function.
void copyBetweenFunctions(Expression* origin,
                          Expression* copy,
                          Function* originFunc,
                          Function* copyFunc);

// Check if two functions have identical metadata. We consider differences like
// one being imported and the other not, or having different numbers of
// instructions, to mean they are not equal (as the meaning of comparisons
// becomes hard in such cases, and the main use here is to compare metadata
// after all else is known equal).
bool equal(Function* a, Function* b);

} // namespace wasm::metadata

#endif // wasm_ir_metadata_h
