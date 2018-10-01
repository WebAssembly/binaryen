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
 // Source maps VLQ encoding helpers.
 //

#ifndef wasm_support_vlq_h
#define wasm_support_vlq_h

#include <ostream>

namespace wasm {

void writeBase64VLQ(std::ostream& out, int32_t n);

} // namespace wasm

#endif // wasm_support_vlq_h