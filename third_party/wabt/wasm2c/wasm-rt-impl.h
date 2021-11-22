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

#ifndef WASM_RT_IMPL_H_
#define WASM_RT_IMPL_H_

#include <setjmp.h>

#include "wasm-rt.h"

#ifdef __cplusplus
extern "C" {
#endif

/** A setjmp buffer used for handling traps. */
extern jmp_buf g_jmp_buf;

/** Saved call stack depth that will be restored in case a trap occurs. */
extern uint32_t g_saved_call_stack_depth;

#if WASM_RT_MEMCHECK_SIGNAL_HANDLER_POSIX
#define WASM_RT_SETJMP(buf) sigsetjmp(buf, 1)
#define WASM_RT_LONGJMP(buf, val) siglongjmp(buf, val)
#else
#define WASM_RT_SETJMP(buf) setjmp(buf)
#define WASM_RT_LONGJMP(buf, val) longjmp(buf, val)
#endif

/** Convenience macro to use before calling a wasm function. On first execution
 * it will return `WASM_RT_TRAP_NONE` (i.e. 0). If the function traps, it will
 * jump back and return the trap that occurred.
 *
 * ```
 *   wasm_rt_trap_t code = wasm_rt_impl_try();
 *   if (code != 0) {
 *     printf("A trap occurred with code: %d\n", code);
 *     ...
 *   }
 *
 *   // Call the potentially-trapping function.
 *   my_wasm_func();
 * ```
 */
#define wasm_rt_impl_try()                              \
  (g_saved_call_stack_depth = wasm_rt_call_stack_depth, \
   WASM_RT_SETJMP(g_jmp_buf))

#ifdef __cplusplus
}
#endif

#endif // WASM_RT_IMPL_H_
