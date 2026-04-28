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

namespace wasm {

// Use the delta debugging algorithm (Zeller 1999,
// https://dl.acm.org/doi/10.1109/32.988498) to find the minimal set of
// items necessary to preserve some property. Returns that minimal set of
// items, preserving their input order. `tryPartition` should have this
// signature:
//
//   bool tryPartition(size_t partitionIndex,
//                     size_t numPartitions,
//                     const std::vector<T>& partition)
//
// It should return true iff the property is preserved while keeping only
// `partition` items.
template<typename T, typename F>
std::vector<T> deltaDebugging(std::vector<T> items, const F& tryPartition) {
  if (items.empty()) {
    return items;
  }
  // First try removing everything.
  if (tryPartition(0, 1, {})) {
    return {};
  }
  size_t numPartitions = 2;
  while (numPartitions <= items.size()) {
    // Partition the items.
    std::vector<std::vector<T>> partitions;
    size_t size = items.size();
    size_t basePartitionSize = size / numPartitions;
    size_t rem = size % numPartitions;
    size_t idx = 0;
    for (size_t i = 0; i < numPartitions; ++i) {
      size_t partitionSize = basePartitionSize + (i < rem ? 1 : 0);
      if (partitionSize > 0) {
        std::vector<T> partition;
        partition.reserve(partitionSize);
        for (size_t j = 0; j < partitionSize; ++j) {
          partition.push_back(items[idx++]);
        }
        partitions.emplace_back(std::move(partition));
      }
    }
    assert(numPartitions == partitions.size());

    bool reduced = false;

    // Try keeping only one partition. Try each partition in turn.
    for (size_t i = 0; i < numPartitions; ++i) {
      if (tryPartition(i, numPartitions, partitions[i])) {
        items = std::move(partitions[i]);
        numPartitions = 2;
        reduced = true;
        break;
      }
    }
    if (reduced) {
      continue;
    }

    // Otherwise, try keeping the complement of a partition. Do not do this with
    // only two partitions because that would be no different from what we
    // already tried.
    if (numPartitions > 2) {
      for (size_t i = 0; i < numPartitions; ++i) {
        std::vector<T> complement;
        complement.reserve(items.size() - partitions[i].size());
        for (size_t j = 0; j < numPartitions; ++j) {
          if (j != i) {
            complement.insert(
              complement.end(), partitions[j].begin(), partitions[j].end());
          }
        }
        if (tryPartition(i, numPartitions, complement)) {
          items = std::move(complement);
          numPartitions = std::max(numPartitions - 1, size_t(2));
          reduced = true;
          break;
        }
      }
      if (reduced) {
        continue;
      }
    }

    if (numPartitions == items.size()) {
      // Cannot further refine the partitions. We're done.
      break;
    }

    // Otherwise, make the partitions finer grained.
    numPartitions = std::min(items.size(), 2 * numPartitions);
  }
  return items;
}

} // namespace wasm

#endif // wasm_support_delta_debugging_h
