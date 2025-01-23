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

// Constants that control fuzzing.

#ifndef wasm_tools_fuzzing_parameters_h
#define wasm_tools_fuzzing_parameters_h

#include "wasm.h"

namespace wasm {

// The maximum amount of params to each function.
constexpr int MAX_PARAMS = 10;

// The maximum amount of vars in each function.
constexpr int MAX_VARS = 20;

// The maximum number of globals in a module.
constexpr int MAX_GLOBALS = 30;

// The maximum number of tuple elements.
constexpr int MAX_TUPLE_SIZE = 6;

// The maximum number of struct fields.
static const int MAX_STRUCT_SIZE = 6;

// The maximum number of elements in an array.
static const int MAX_ARRAY_SIZE = 100;

// The number of nontrivial heap types to generate.
constexpr int MIN_HEAPTYPES = 4;
constexpr int MAX_HEAPTYPES = 20;

// some things require luck, try them a few times
constexpr int TRIES = 10;

// beyond a nesting limit, greatly decrease the chance to continue to nest
constexpr int NESTING_LIMIT = 11;

// the maximum size of a block
constexpr int BLOCK_FACTOR = 5;

// the memory that we use, a small portion so that we have a good chance of
// looking at writes (we also look outside of this region with small
// probability) this should be a power of 2
constexpr Address USABLE_MEMORY = 16;

// the number of runtime iterations (function calls, loop backbranches) we
// allow before we stop execution with a trap, to prevent hangs. 0 means
// no hang protection.
constexpr int HANG_LIMIT = 100;

// the maximum amount of new GC types (structs, etc.) to create
constexpr int MAX_NEW_GC_TYPES = 25;

// the maximum amount of catches in each try (not including a catch-all, if
// present).
constexpr int MAX_TRY_CATCHES = 4;

//
constexpr size_t VeryImportant = 4;
constexpr size_t Important = 2;

} // namespace wasm

#endif // wasm_tools_fuzzing_parameters_h
