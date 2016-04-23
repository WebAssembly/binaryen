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

#include <atomic>
#include <cassert>
#include <memory>
#include <mutex>
#include <thread>
#include <vector>

//
// Arena allocation for mixed-type data.
//
// Arena-style bump allocation is important for two reasons: First, so that
// allocation is quick, and second, so that allocated items are close together,
// which is cache-friendy. Arena allocation is also useful for a minor third
// reason which is to make freeing all the items in an arena very quick.
//
// Each WebAssembly Module has an arena allocator, which should be used
// for all of its AST nodes and so forth. When the Module is destroyed, the
// entire arena is cleaned up.
//
// When allocating an object in an arena, the object's proper constructor
// is called. Note that destructors are not called, because to make the
// arena simple and fast we do not track internal allocations inside it
// (and we can also avoid the need for virtual destructors).
//
// In general, optimization passes avoid allocation as much as possible.
// Many passes only remove or modify nodes anyhow, others can often
// reuse nodes that are being optimized out. This keeps things
// cache-friendly, and also makes the operations trivially thread-safe.
// In the rare case that a pass does need to allocate, and it is a
// parallel pass (so multiple threads might access the allocator),
// the MixedArena instance will notice if it is on a different thread
// than that arena's original thread, and will perform the allocation
// in a side arena for that other thread. This is done in a transparent
// way to the outside; as a result, it is always safe to allocate using
// a MixedArena, no matter which thread you are on. Allocations will
// of course be fastest on the original thread for the arena.
//

struct MixedArena {
  // fast bump allocation
  std::vector<char*> chunks;
  int index; // in last chunk

  // multithreaded allocation - each arena is valid on a specific thread.
  // if we are on the wrong thread, we safely look in the linked
  // list of next, adding an allocator if necessary
  // TODO: we don't really need locking here, atomics could suffice
  std::thread::id threadId;
  std::mutex mutex;
  MixedArena* next;

  MixedArena() {
    threadId = std::this_thread::get_id();
    next = nullptr;
  }

  template<class T>
  T* alloc() {
    // the bump allocator data should not be modified by multiple threads at once.
    if (std::this_thread::get_id() != threadId) {
      // TODO use a fast double-checked locking pattern.
      std::lock_guard<std::mutex> lock(mutex);
      MixedArena* curr = this;
      while (std::this_thread::get_id() != curr->threadId) {
        if (curr->next) {
          curr = curr->next;
        } else {
          curr->next = new MixedArena(); // will have our thread id
        }
      }
      return curr->alloc<T>();
    }
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
    for (char* chunk : chunks) {
      delete[] chunk;
    }
    chunks.clear();
  }

  ~MixedArena() {
    clear();
    if (next) delete next;
  }
};

#endif // wasm_mixed_arena_h
