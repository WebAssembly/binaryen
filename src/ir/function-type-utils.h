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

#ifndef wasm_ir_function_type_utils_h
#define wasm_ir_function_type_utils_h


namespace wasm {

namespace FunctionTypeUtils {

// Fills in function info from a function type
inline void fillFunction(Function* func, FunctionType* type) {
  func->params = type->params;
  func->result = type->result;
}

} // namespace FunctionTypeUtils

} // namespace wasm

#endif // wasm_ir_function_type_utils_h
