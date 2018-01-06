/*
 * Copyright 2017 WebAssembly Community Group participants
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
// A FIFO queue of unique items, in which if an item is queued that already
// exists, it is placed at the end. That means that it is done at the
// last (most deferred) time from all the times it was queued.
//

#ifndef wasm_support_unique_deferring_queue_h
#define wasm_support_unique_deferring_queue_h

#include <queue>
#include <unordered_map>

namespace wasm {

template<typename T>
struct UniqueDeferredQueue {
  // implemented as an internal queue, plus a map
  // that says how many times an element appears. we
  // can then skip non-final appearances. this lets us
  // avoid needing to remove elements from the middle
  // when there are duplicates.
  std::queue<T> data;
  std::unordered_map<T, size_t> count;

  size_t size() { return data.size(); }
  bool empty() { return size() == 0; }

  void push(T item) {
    data.push(item);
    count[item]++;
  }

  T pop() {
    while (1) {
      assert(!empty());
      T item = data.front();
      count[item]--;
      data.pop();
      if (count[item] == 0) {
        return item;
      }
      // skip this one, keep going
    }
  }
};

} // namespace wasm

#endif // wasm_support_unique_deferring_queue_h
