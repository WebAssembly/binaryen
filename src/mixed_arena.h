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
  size_t chunkSize = 32768;
  size_t index; // in last chunk

  std::thread::id threadId;

  // multithreaded allocation - each arena is valid on a specific thread.
  // if we are on the wrong thread, we atomically look in the linked
  // list of next, adding an allocator if necessary
  std::atomic<MixedArena*> next;

  MixedArena() {
    threadId = std::this_thread::get_id();
    next.store(nullptr);
  }

  void* allocSpace(size_t size) {
    // the bump allocator data should not be modified by multiple threads at once.
    auto myId = std::this_thread::get_id();
    if (myId != threadId) {
      MixedArena* curr = this;
      MixedArena* allocated = nullptr;
      while (myId != curr->threadId) {
        auto seen = curr->next.load();
        if (seen) {
          curr = seen;
          continue;
        }
        // there is a nullptr for next, so we may be able to place a new
        // allocator for us there. but carefully, as others may do so as
        // well. we may waste a few allocations here, but it doesn't matter
        // as this can only happen as the chain is built up, i.e.,
        // O(# of cores) per allocator, and our allocatrs are long-lived.
        if (!allocated) {
          allocated = new MixedArena(); // has our thread id
        }
        if (curr->next.compare_exchange_weak(seen, allocated)) {
          // we replaced it, so we are the next in the chain
          // we can forget about allocated, it is owned by the chain now
          allocated = nullptr;
          break;
        }
        // otherwise, the cmpxchg updated seen, and we continue to loop
        curr = seen;
      }
      if (allocated) delete allocated;
      return curr->allocSpace(size);
    }
    size = (size + 7) & (-8); // same alignment as malloc TODO optimize?
    bool mustAllocate = false;
    while (chunkSize <= size) {
      chunkSize *= 2;
      mustAllocate = true;
    }
    if (chunks.size() == 0 || index + size >= chunkSize || mustAllocate) {
      chunks.push_back(new char[chunkSize]);
      index = 0;
    }
    auto* ret = chunks.back() + index;
    index += size;
    return static_cast<void*>(ret);
  }

  template<class T>
  T* alloc() {
    auto* ret = static_cast<T*>(allocSpace(sizeof(T)));
    new (ret) T(*this); // allocated objects receive the allocator, so they can allocate more later if necessary
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
    if (next.load()) delete next.load();
  }
};


//
// A vector that allocates in an arena.
//
// TODO: consider not saving the allocator, but requiring it be
//       passed in when needed, would make this (and thus Blocks etc.
//       smaller)
//
// TODO: specialize on the initial size of the array

template <typename T>
class ArenaVector {
  MixedArena& allocator;
  T* data = nullptr;
  size_t usedElements = 0,
         allocatedElements = 0;

  void allocate(size_t size) {
    allocatedElements = size;
    data = static_cast<T*>(allocator.allocSpace(sizeof(T) * allocatedElements));
  }

  void reallocate(size_t size) {
    T* old = data;
    allocate(size);
    for (size_t i = 0; i < usedElements; i++) {
      data[i] = old[i];
    }
  }

public:
  ArenaVector(MixedArena& allocator) : allocator(allocator) {}

  ArenaVector(ArenaVector<T>&& other) : allocator(other.allocator) {
    *this = other;
  }

  T& operator[](size_t index) const {
    assert(index < usedElements);
    return data[index];
  }

  size_t size() const {
    return usedElements;
  }

  void resize(size_t size) {
    if (size > allocatedElements) {
      reallocate(size);
    }
    // construct new elements
    for (size_t i = usedElements; i < size; i++) {
      new (data + i) T();
    }
    usedElements = size;
  }

  T& back() const {
    assert(usedElements > 0);
    return data[usedElements - 1];
  }

  T& pop_back() {
    assert(usedElements > 0);
    usedElements--;
    return data[usedElements];
  }

  void push_back(T item) {
    if (usedElements == allocatedElements) {
      reallocate((allocatedElements + 1) * 2); // TODO: optimize
    }
    data[usedElements] = item;
    usedElements++;
  }

  template<typename ListType>
  void set(ListType& list) {
    size_t size = list.size();
    if (allocatedElements < size) {
      allocate(size);
    }
    for (size_t i = 0; i < size; i++) {
      data[i] = list[i];
    }
    usedElements = size;
  }

  void operator=(ArenaVector<T>& other) {
    set(other);
  }

  void operator=(ArenaVector<T>&& other) {
    data = other.data;
    usedElements = other.usedElements;
    allocatedElements = other.allocatedElements;
    other.data = nullptr;
    other.usedElements = other.allocatedElements = 0;
  }

  // iteration

  struct Iterator {
    const ArenaVector<T>* parent;
    size_t index;

    Iterator(const ArenaVector<T>* parent, size_t index) : parent(parent), index(index) {}

    bool operator!=(const Iterator& other) const {
      return index != other.index || parent != other.parent;
    }

    void operator++() {
      index++;
    }

    T& operator*() {
      return (*parent)[index];
    }
  };

  Iterator begin() const {
    return Iterator(this, 0);
  }
  Iterator end() const {
    return Iterator(this, usedElements);
  }
};

#endif // wasm_mixed_arena_h
