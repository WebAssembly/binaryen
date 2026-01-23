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

#ifndef wasm_interpreter_exception_h
#define wasm_interpreter_exception_h

namespace wasm {

// An exception emitted when exit() is called.
struct ExitException {};

// An exception emitted when a wasm trap occurs.
struct TrapException {};

// An exception emitted when a host limitation is hit. (These are not wasm traps
// as they are not in the spec; for example, the spec has no limit on how much
// GC memory may be allocated, but hosts have limits.)
struct HostLimitException {};

} // namespace wasm

#endif // wasm_interpreter_exception_h
