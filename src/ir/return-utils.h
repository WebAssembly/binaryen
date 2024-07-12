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

#ifndef wasm_ir_return_h
#define wasm_ir_return_h

#include "wasm.h"

namespace wasm::ReturnUtils {

// Removes values from both explicit returns and implicit ones (values that flow
// from the body). This is useful after changing a function's type to no longer
// return anything.
//
// This does *not* handle return calls, and will error on them. Removing a
// return call may change the semantics of the program, so we do not do it
// automatically here.
void removeReturns(Function* func, Module& wasm);

// Return a map of every function to whether it does a return call.
using ReturnCallersMap = std::unordered_map<Function*, bool>;
ReturnCallersMap findReturnCallers(Module& wasm);

} // namespace wasm::ReturnUtils

#endif // wasm_ir_return_h
