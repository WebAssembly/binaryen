/*
 * Copyright 2015 WebAssembly Community Group participants
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

#ifndef wasm_mixed_arena_h
#define wasm_mixed_arena_h

#include <vector>

#include "support/threads.h"

//
// Arena allocation for mixed-type data.
//

struct MixedArena {
  std::vector<char*> chunks;
  int index; // in last chunk

  template<class T>
  T* alloc() {
    // allocations must be on main thread, and single-threaded
    assert(wasm::Thread::onMainThread());
    assert(!wasm::ThreadPool::isRunning());

    const size_t CHUNK = 10000;
    size_t currSize = (sizeof(T) + 7) & (-8); // same alignment as malloc TODO optimize?
    assert(currSize < CHUNK);
    if (chunks.size() == 0 || index + currSize >= CHUNK) {
      chunks.push_back(new char[CHUNK]);
      index = 0;
    }
    T* ret = (T*)(chunks.back() + index);
    index += currSize;
    new (ret) T();
    return ret;
  }

  void clear() {
    assert(wasm::Thread::onMainThread());
    assert(!wasm::ThreadPool::isRunning());

    for (char* chunk : chunks) {
      delete[] chunk;
    }
    chunks.clear();
  }

  ~MixedArena() {
    clear();
  }
};

extern MixedArena globalAllocator;

#endif // wasm_mixed_arena_h
