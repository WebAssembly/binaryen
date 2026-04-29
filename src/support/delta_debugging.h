/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_support_delta_debugging_h
#define wasm_support_delta_debugging_h

#include <algorithm>
#include <cassert>
#include <vector>

#include "support/coroutine.h"

namespace wasm {

// Use the delta debugging algorithm (Zeller 2002,
// https://dl.acm.org/doi/10.1109/32.988498) to find the minimal set of items
// necessary to preserve some property. `working` is the minimal set of items
// found so far and `test` is the smaller set of items that should be tested
// next. After testing, call `accept()`, `reject()`, or `resolve(bool accepted)`
// to update the working and test sets appropriately.
template<typename T> struct DeltaDebugger {
  DeltaDebugger(std::vector<T> items) : task(run(std::move(items))) {
    task.handle.resume();
  }

  bool finished() const { return task.get()->finished; }

  const std::vector<T>& working() const { return task.get()->working; }
  std::vector<T>& test() { return task.get()->test; }

  size_t partitionCount() const { return task.get()->numPartitions; }
  size_t partitionIndex() const { return task.get()->currPartition; }

  void resolve(bool success) {
    if (finished()) {
      return;
    }
    task.resume(success);
  }

  void accept() { resolve(true); }
  void reject() { resolve(false); }

private:
  struct State {
    std::vector<T> working;
    std::vector<T> test;
    size_t numPartitions = 1;
    size_t currPartition = 0;
    bool finished = false;
  };

  Generator<State*, bool> task;

  static Generator<State*, bool> run(std::vector<T> items) {
    State state;
    auto& [working, test, numPartitions, currPartition, finished] = state;

    working = std::move(items);

    if (working.empty()) {
      finished = true;
      co_yield &state;
      co_return;
    }

    // First try removing everything.
    if (co_yield &state) {
      working = {};
      finished = true;
      co_yield &state;
      co_return;
    }

    numPartitions = 2;
    while (numPartitions <= working.size()) {
      // Partition the items.
      std::vector<std::vector<T>> partitions;
      size_t size = working.size();
      size_t basePartitionSize = size / numPartitions;
      size_t rem = size % numPartitions;
      size_t idx = 0;
      for (size_t i = 0; i < numPartitions; ++i) {
        size_t partitionSize = basePartitionSize + (i < rem ? 1 : 0);
        if (partitionSize > 0) {
          std::vector<T> partition;
          partition.reserve(partitionSize);
          for (size_t j = 0; j < partitionSize; ++j) {
            partition.push_back(working[idx++]);
          }
          partitions.emplace_back(std::move(partition));
        }
      }
      assert(numPartitions == partitions.size());

      bool reduced = false;

      // Try keeping only one partition. Try each partition in turn.
      for (currPartition = 0; currPartition < numPartitions; ++currPartition) {
        test = std::move(partitions[currPartition]);
        if (co_yield &state) {
          working = std::move(test);
          numPartitions = 2;
          reduced = true;
          break;
        } else {
          // Restore the partition since we failed and might need it for
          // complement testing.
          partitions[currPartition] = std::move(test);
        }
      }
      if (reduced) {
        continue;
      }

      // Otherwise, try keeping the complement of a partition. Do not do this
      // with only two partitions because that would be no different from what
      // we already tried.
      if (numPartitions > 2) {
        for (currPartition = 0; currPartition < numPartitions;
             ++currPartition) {
          test.clear();
          test.reserve(working.size() - partitions[currPartition].size());
          for (size_t i = 0; i < numPartitions; ++i) {
            if (i != currPartition) {
              test.insert(
                test.end(), partitions[i].begin(), partitions[i].end());
            }
          }
          if (co_yield &state) {
            working = std::move(test);
            numPartitions = std::max(numPartitions - 1, size_t(2));
            reduced = true;
            break;
          }
        }
        if (reduced) {
          continue;
        }
      }

      if (numPartitions == working.size()) {
        // Cannot further refine the partitions. We're done.
        break;
      }

      // Otherwise, make the partitions finer grained.
      numPartitions = std::min(working.size(), 2 * numPartitions);
    }

    // Yield final state
    test = {};
    finished = true;
    co_yield &state;
  }
};

} // namespace wasm

#endif // wasm_support_delta_debugging_h
