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

#include "wasm-rt.h"

#include "wasm-rt-exceptions.h"

#include <string.h>

#define MAX_EXCEPTION_SIZE 256

static WASM_RT_THREAD_LOCAL wasm_rt_tag_t g_active_exception_tag;
static WASM_RT_THREAD_LOCAL uint8_t g_active_exception[MAX_EXCEPTION_SIZE];
static WASM_RT_THREAD_LOCAL uint32_t g_active_exception_size;

static WASM_RT_THREAD_LOCAL wasm_rt_jmp_buf* g_unwind_target;

void wasm_rt_load_exception(const wasm_rt_tag_t tag,
                            uint32_t size,
                            const void* values) {
  if (size > MAX_EXCEPTION_SIZE) {
    wasm_rt_trap(WASM_RT_TRAP_EXHAUSTION);
  }

  g_active_exception_tag = tag;
  g_active_exception_size = size;

  if (size) {
    memcpy(g_active_exception, values, size);
  }
}

WASM_RT_NO_RETURN void wasm_rt_throw(void) {
  WASM_RT_LONGJMP(*g_unwind_target, WASM_RT_TRAP_UNCAUGHT_EXCEPTION);
}

WASM_RT_UNWIND_TARGET* wasm_rt_get_unwind_target(void) {
  return g_unwind_target;
}

void wasm_rt_set_unwind_target(WASM_RT_UNWIND_TARGET* target) {
  g_unwind_target = target;
}

wasm_rt_tag_t wasm_rt_exception_tag(void) {
  return g_active_exception_tag;
}

uint32_t wasm_rt_exception_size(void) {
  return g_active_exception_size;
}

void* wasm_rt_exception(void) {
  return g_active_exception;
}

// Include table operations for exnref
#define WASM_RT_TABLE_OPS_EXNREF
#include "wasm-rt-impl-tableops.inc"
#undef WASM_RT_TABLE_OPS_EXNREF
