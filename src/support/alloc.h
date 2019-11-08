/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Allocation helpers
//

#ifndef wasm_support_alloc_h
#define wasm_support_alloc_h

#include <stdlib.h>

#if defined(WIN32) || defined(_WIN32)
#include <malloc.h>
#endif

namespace wasm {

// An allocation of a specific size and a minimum alignment. Must be freed
// with aligned_free. Returns nullptr on failure.
inline void* aligned_malloc(size_t align, size_t size) {
#if defined(WIN32) || defined(_WIN32)
  _set_errno(0);
  void* ret = _aligned_malloc(size, align);
  if (errno == ENOMEM)
    ret = nullptr;
  return ret;
#elif defined(__APPLE__) || !defined(_ISOC11_SOURCE)
  void* ptr;
  int result = posix_memalign(&ptr, align, size);
  return result == 0 ? ptr : nullptr;
#else
  return aligned_alloc(align, size);
#endif
}

inline void aligned_free(void* ptr) {
#if defined(WIN32) || defined(_WIN32)
  _aligned_free(ptr);
#else
  free(ptr);
#endif
}

} // namespace wasm

#endif // wasm_support_alloc_h
