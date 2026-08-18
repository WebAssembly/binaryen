/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_support_i65_h
#define wasm_support_i65_h

namespace wasm {

// A 65-bit integer, capable of representing numbers in the range
//
//  std::numeric_limits<int64_t>::min() .. std::numeric_limits<uint64_t>::max()
//
// This allows an I65 to represent any 32 or 64-bit number, signed *or*
// unsigned.
struct I65 {};

} // namespace wasm

#endif // wasm_support_i65_h
