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

#include "support/index.h"
namespace wasm {

// Use the delta debugging algorithm (Zeller 2002,
// https://dl.acm.org/doi/10.1109/32.988498) to find the minimal set of
// items necessary to preserve some property. `working` is the minimal set of
// items found so far and `test` is the smaller set of items that should be
// tested next. After testing, call `accept()`, `reject()`, or `resolve(bool
// accepted)` to update the working and test sets appropriately.
template<typename T> struct DeltaDebugger {
  std::vector<T> working;
  std::vector<T> test;

private:
  Index numPartitions = 1;
  Index currentPartition = 0;
  bool testingComplements = false;
  bool triedEmpty = false;
  bool isFinished = false;
  std::vector<std::vector<T>> partitions;

public:
  DeltaDebugger(std::vector<T> items) : working(std::move(items)) {}

  bool finished() const {
    return isFinished || (triedEmpty && working.size() <= 1);
  }
  Index partitionCount() { return numPartitions; }
  Index partitionIndex() { return currentPartition; }

  void accept() {
    if (test.empty()) {
      triedEmpty = true;
    }

    working = std::move(test);

    if (finished()) {
      return;
    }

    if (!testingComplements) {
      numPartitions = 2;
    } else {
      numPartitions = std::max(numPartitions - 1, Index(2));
    }
    testingComplements = false;
    currentPartition = 0;
    updateTest();
  }

  void reject() {
    if (test.empty()) {
      triedEmpty = true;
      numPartitions = 2;
      updateTest();
      return;
    }

    if (finished()) {
      return;
    }

    ++currentPartition;
    if (currentPartition >= partitions.size()) {
      // No need to test complements if there are only two partitions, since
      // that is no different.
      if (!testingComplements && numPartitions > 2) {
        testingComplements = true;
        currentPartition = 0;
      } else {
        if (numPartitions >= working.size()) {
          isFinished = true;
          return;
        }
        // Refine the partitions.
        numPartitions = std::min(Index(working.size()), 2 * numPartitions);
        testingComplements = false;
        currentPartition = 0;
      }
    }
    updateTest();
  }

  // Convenience wrapper for when there is already a bool determining whether to
  // accept or reject the current test sequence.
  void resolve(bool success) {
    if (success) {
      accept();
    } else {
      reject();
    }
  }

private:
  void updateTest() {
    if (finished()) {
      test.clear();
      return;
    }

    if (currentPartition == 0 && !testingComplements) {
      generatePartitions();
    }

    if (!testingComplements) {
      test = partitions[currentPartition];
    } else {
      test.clear();
      test.reserve(working.size() - partitions[currentPartition].size());
      for (size_t i = 0; i < partitions.size(); ++i) {
        if (i != currentPartition) {
          test.insert(test.end(), partitions[i].begin(), partitions[i].end());
        }
      }
    }
  }

  void generatePartitions() {
    partitions.clear();
    size_t size = working.size();
    assert(numPartitions != 0 && numPartitions <= size);

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
  }
};

} // namespace wasm

#endif // wasm_support_delta_debugging_h
