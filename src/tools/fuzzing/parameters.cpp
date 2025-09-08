/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include "tools/fuzzing.h"
#include "wasm.h"

namespace wasm {

void FuzzParams::setDefaults() {
  MAX_PARAMS = 10;

  MAX_VARS = 20;

  MAX_GLOBALS = 30;

  MAX_TUPLE_SIZE = 6;

  MAX_STRUCT_SIZE = 6;

  MAX_ARRAY_SIZE = 100;

  MIN_HEAPTYPES = 4;
  MAX_HEAPTYPES = 20;

  TRIES = 10;

  NESTING_LIMIT = 11;

  BLOCK_FACTOR = 5;

  USABLE_MEMORY = 16;

  HANG_LIMIT = 100;

  MAX_NEW_GC_TYPES = 25;

  MAX_TRY_CATCHES = 4;
}

} // namespace wasm
