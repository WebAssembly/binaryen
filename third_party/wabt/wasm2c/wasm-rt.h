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

#ifndef WASM_RT_H_
#define WASM_RT_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/** Maximum stack depth before trapping. This can be configured by defining
 * this symbol before including wasm-rt when building the generated c files,
 * for example:
 *
 * ```
 *   cc -c -DWASM_RT_MAX_CALL_STACK_DEPTH=100 my_module.c -o my_module.o
 * ```
 * */
#ifndef WASM_RT_MAX_CALL_STACK_DEPTH
#define WASM_RT_MAX_CALL_STACK_DEPTH 500
#endif

/** Enable memory checking via a signal handler via the following definition:
 *
 * #define WASM_RT_MEMCHECK_SIGNAL_HANDLER 1
 *
 * This is usually 10%-25% faster, but requires OS-specific support.
 * */

/** Check whether the signal handler is supported at all. */
#if (defined(__linux__) || defined(__unix__) || defined(__APPLE__)) && \
    defined(__WORDSIZE) && __WORDSIZE == 64

/* If the signal handler is supported, then use it by default. */
#ifndef WASM_RT_MEMCHECK_SIGNAL_HANDLER
#define WASM_RT_MEMCHECK_SIGNAL_HANDLER 1
#endif

#if WASM_RT_MEMCHECK_SIGNAL_HANDLER
#define WASM_RT_MEMCHECK_SIGNAL_HANDLER_POSIX 1
#endif

#else

/* The signal handler is not supported, error out if the user was trying to
 * enable it. */
#if WASM_RT_MEMCHECK_SIGNAL_HANDLER
#error "Signal handler is not supported for this OS/Architecture!"
#endif

#define WASM_RT_MEMCHECK_SIGNAL_HANDLER 0
#define WASM_RT_MEMCHECK_SIGNAL_HANDLER_POSIX 0

#endif

/** Reason a trap occurred. Provide this to `wasm_rt_trap`. */
typedef enum {
  WASM_RT_TRAP_NONE,         /** No error. */
  WASM_RT_TRAP_OOB,          /** Out-of-bounds access in linear memory. */
  WASM_RT_TRAP_INT_OVERFLOW, /** Integer overflow on divide or truncation. */
  WASM_RT_TRAP_DIV_BY_ZERO,  /** Integer divide by zero. */
  WASM_RT_TRAP_INVALID_CONVERSION, /** Conversion from NaN to integer. */
  WASM_RT_TRAP_UNREACHABLE,        /** Unreachable instruction executed. */
  WASM_RT_TRAP_CALL_INDIRECT,      /** Invalid call_indirect, for any reason. */
  WASM_RT_TRAP_EXHAUSTION,         /** Call stack exhausted. */
} wasm_rt_trap_t;

/** Value types. Used to define function signatures. */
typedef enum {
  WASM_RT_I32,
  WASM_RT_I64,
  WASM_RT_F32,
  WASM_RT_F64,
} wasm_rt_type_t;

/** A function type for all `anyfunc` functions in a Table. All functions are
 * stored in this canonical form, but must be cast to their proper signature to
 * call. */
typedef void (*wasm_rt_anyfunc_t)(void);

/** A single element of a Table. */
typedef struct {
  /** The index as returned from `wasm_rt_register_func_type`. */
  uint32_t func_type;
  /** The function. The embedder must know the actual C signature of the
   * function and cast to it before calling. */
  wasm_rt_anyfunc_t func;
} wasm_rt_elem_t;

/** A Memory object. */
typedef struct {
  /** The linear memory data, with a byte length of `size`. */
  uint8_t* data;
  /** The current and maximum page count for this Memory object. If there is no
   * maximum, `max_pages` is 0xffffffffu (i.e. UINT32_MAX). */
  uint32_t pages, max_pages;
  /** The current size of the linear memory, in bytes. */
  uint32_t size;
} wasm_rt_memory_t;

/** A Table object. */
typedef struct {
  /** The table element data, with an element count of `size`. */
  wasm_rt_elem_t* data;
  /** The maximum element count of this Table object. If there is no maximum,
   * `max_size` is 0xffffffffu (i.e. UINT32_MAX). */
  uint32_t max_size;
  /** The current element count of the table. */
  uint32_t size;
} wasm_rt_table_t;

/** Stop execution immediately and jump back to the call to `wasm_rt_try`.
 *  The result of `wasm_rt_try` will be the provided trap reason.
 *
 *  This is typically called by the generated code, and not the embedder. */
extern void wasm_rt_trap(wasm_rt_trap_t) __attribute__((noreturn));

/** Register a function type with the given signature. The returned function
 * index is guaranteed to be the same for all calls with the same signature.
 * The following varargs must all be of type `wasm_rt_type_t`, first the
 * params` and then the `results`.
 *
 *  ```
 *    // Register (func (param i32 f32) (result i64)).
 *    wasm_rt_register_func_type(2, 1, WASM_RT_I32, WASM_RT_F32, WASM_RT_I64);
 *    => returns 1
 *
 *    // Register (func (result i64)).
 *    wasm_rt_register_func_type(0, 1, WASM_RT_I32);
 *    => returns 2
 *
 *    // Register (func (param i32 f32) (result i64)) again.
 *    wasm_rt_register_func_type(2, 1, WASM_RT_I32, WASM_RT_F32, WASM_RT_I64);
 *    => returns 1
 *  ``` */
extern uint32_t wasm_rt_register_func_type(uint32_t params,
                                           uint32_t results,
                                           ...);

/** Initialize a Memory object with an initial page size of `initial_pages` and
 * a maximum page size of `max_pages`.
 *
 *  ```
 *    wasm_rt_memory_t my_memory;
 *    // 1 initial page (65536 bytes), and a maximum of 2 pages.
 *    wasm_rt_allocate_memory(&my_memory, 1, 2);
 *  ``` */
extern void wasm_rt_allocate_memory(wasm_rt_memory_t*,
                                    uint32_t initial_pages,
                                    uint32_t max_pages);

/** Grow a Memory object by `pages`, and return the previous page count. If
 * this new page count is greater than the maximum page count, the grow fails
 * and 0xffffffffu (UINT32_MAX) is returned instead.
 *
 *  ```
 *    wasm_rt_memory_t my_memory;
 *    ...
 *    // Grow memory by 10 pages.
 *    uint32_t old_page_size = wasm_rt_grow_memory(&my_memory, 10);
 *    if (old_page_size == UINT32_MAX) {
 *      // Failed to grow memory.
 *    }
 *  ``` */
extern uint32_t wasm_rt_grow_memory(wasm_rt_memory_t*, uint32_t pages);

/** Initialize a Table object with an element count of `elements` and a maximum
 * page size of `max_elements`.
 *
 *  ```
 *    wasm_rt_table_t my_table;
 *    // 5 elemnets and a maximum of 10 elements.
 *    wasm_rt_allocate_table(&my_table, 5, 10);
 *  ``` */
extern void wasm_rt_allocate_table(wasm_rt_table_t*,
                                   uint32_t elements,
                                   uint32_t max_elements);

/** Current call stack depth. */
extern uint32_t wasm_rt_call_stack_depth;

#ifdef __cplusplus
}
#endif

#endif /* WASM_RT_H_ */
