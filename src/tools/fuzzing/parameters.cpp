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

// Default values for fuzzing parameters

#include "tools/fuzzing/fuzzing.h"
#include "wasm.h"

namespace wasm {

int MAX_PARAMS = 10;

int MAX_VARS = 20;

int MAX_GLOBALS = 30;

int MAX_TUPLE_SIZE = 6;

static const int MAX_STRUCT_SIZE = 6;

static const int MAX_ARRAY_SIZE = 100;

int MIN_HEAPTYPES = 4;
int MAX_HEAPTYPES = 20;

int TRIES = 10;

int NESTING_LIMIT = 11;

int BLOCK_FACTOR = 5;

Address USABLE_MEMORY = 16;

int HANG_LIMIT = 100;

int MAX_NEW_GC_TYPES = 25;

int MAX_TRY_CATCHES = 4;

} // namespace wasm
