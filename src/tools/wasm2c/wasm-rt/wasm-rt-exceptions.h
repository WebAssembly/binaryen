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

#ifndef WASM_RT_EXCEPTIONS_H_
#define WASM_RT_EXCEPTIONS_H_

#include "wasm-rt.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * A tag is represented as an arbitrary pointer.
 */
typedef const void* wasm_rt_tag_t;

/**
 * Set the active exception to given tag, size, and contents.
 */
void wasm_rt_load_exception(const wasm_rt_tag_t tag,
                            uint32_t size,
                            const void* values);

/**
 * Throw the active exception.
 */
WASM_RT_NO_RETURN void wasm_rt_throw(void);

/**
 * The type of an unwind target if an exception is thrown and caught.
 */
#define WASM_RT_UNWIND_TARGET wasm_rt_jmp_buf

/**
 * Get the current unwind target if an exception is thrown.
 */
WASM_RT_UNWIND_TARGET* wasm_rt_get_unwind_target(void);

/**
 * Set the unwind target if an exception is thrown.
 */
void wasm_rt_set_unwind_target(WASM_RT_UNWIND_TARGET* target);

/**
 * Tag of the active exception.
 */
wasm_rt_tag_t wasm_rt_exception_tag(void);

/**
 * Size of the active exception.
 */
uint32_t wasm_rt_exception_size(void);

/**
 * Contents of the active exception.
 */
void* wasm_rt_exception(void);

/**
 * The maximum size of an exception.
 */
#define WASM_EXN_MAX_SIZE 256

/**
 * An exception instance (the runtime representation of a function).
 * These can be stored in tables of type exnref, or used as values.
 */
typedef struct {
  /** The exceptions's tag. */
  wasm_rt_tag_t tag;
  /** The size of the exception. */
  uint32_t size;
  /**
   * The actual contents of the exception are stored inline.
   */
  char data[WASM_EXN_MAX_SIZE];
} wasm_rt_exnref_t;

/** Default (null) value of an exnref */
#define wasm_rt_exnref_null_value ((wasm_rt_exnref_t){NULL, 0, {0}})

/** A Table of type exnref. */
typedef struct {
  /** The table element data, with an element count of `size`. */
  wasm_rt_exnref_t* data;
  /**
   * The maximum element count of this Table object. If there is no maximum,
   * `max_size` is 0xffffffffu (i.e. UINT32_MAX).
   */
  uint32_t max_size;
  /** The current element count of the table. */
  uint32_t size;
} wasm_rt_exnref_table_t;

/**
 * Initialize an exnref Table object with an element count of `elements` and a
 * maximum size of `max_elements`.
 *
 *  ```
 *    wasm_rt_exnref_table_t my_table;
 *    // 5 elements and a maximum of 10 elements.
 *    wasm_rt_allocate_exnref_table(&my_table, 5, 10);
 *  ```
 */
void wasm_rt_allocate_exnref_table(wasm_rt_exnref_table_t*,
                                   uint32_t elements,
                                   uint32_t max_elements);

/** Free an exnref Table object. */
void wasm_rt_free_exnref_table(wasm_rt_exnref_table_t*);

/**
 * Grow a Table object by `delta` elements (giving the new elements the value
 * `init`), and return the previous element count. If this new element count is
 * greater than the maximum element count, the grow fails and 0xffffffffu
 * (UINT32_MAX) is returned instead.
 */
uint32_t wasm_rt_grow_exnref_table(wasm_rt_exnref_table_t*,
                                   uint32_t delta,
                                   wasm_rt_exnref_t init);

#ifdef __cplusplus
}
#endif

#endif
