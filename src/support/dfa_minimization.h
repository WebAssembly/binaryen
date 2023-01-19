/*
 * Copyright 2023 WebAssembly Community Group participants
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

// Use the Valmari-Lehtinen DFA minimization algorithm
// (https://arxiv.org/pdf/0802.2826.pdf) to find equivalent elements in a
// user-provided DFA.

#ifndef wasm_support_dfa_minimization_h
#define wasm_support_dfa_minimization_h

#include <cassert>
#include <cstddef>
#include <unordered_map>
#include <vector>

namespace wasm::DFA {

namespace Internal {

std::vector<std::vector<size_t>>
refinePartitionsImpl(const std::vector<std::vector<std::vector<size_t>>>&);

} // namespace Internal

// A DFA state with an ordered list of successor states.
template<typename T> struct State {
  T val;
  std::vector<T> succs;
};

// Given a vector of initial state partitions in which states known to be
// different are in different partitions, return a vector of refined partitions,
// each containing a different equivalence class of states. No value should
// appear more than once in the input. All successor values should appear in
// some top-level partition.
template<typename T>
std::vector<std::vector<T>>
refinePartitions(const std::vector<std::vector<State<T>>>& partitions) {
  // Map values to indices and vice versa.
  std::unordered_map<T, size_t> indices;
  std::vector<T> values;
  for (const auto& partition : partitions) {
    for (const auto& state : partition) {
      [[maybe_unused]] bool inserted =
        indices.insert({state.val, indices.size()}).second;
      assert(inserted && "unexpected repeated value");
      values.push_back(state.val);
    }
  }

  // Create a copy of the DFA that uses indices instead of the original values.
  std::vector<std::vector<std::vector<size_t>>> indexPartitions;
  indexPartitions.reserve(partitions.size());
  for (const auto& partition : partitions) {
    std::vector<std::vector<size_t>> indexPartition;
    indexPartition.reserve(partition.size());
    for (const auto& state : partition) {
      std::vector<size_t> succIndices;
      succIndices.reserve(state.succs.size());
      for (const auto& succ : state.succs) {
        auto it = indices.find(succ);
        assert(it != indices.end() && "unknown successor value");
        succIndices.push_back(it->second);
      }
      indexPartition.emplace_back(std::move(succIndices));
    }
    indexPartitions.emplace_back(std::move(indexPartition));
  }

  // Refine the partitions.
  auto indexResults = Internal::refinePartitionsImpl(indexPartitions);

  // Map the refined partitions of indices back to values.
  std::vector<std::vector<T>> results;
  results.reserve(indexResults.size());
  for (const auto& indexPartition : indexResults) {
    std::vector<T> partition;
    partition.reserve(indexPartition.size());
    for (size_t index : indexPartition) {
      partition.push_back(values[index]);
    }
    results.emplace_back(std::move(partition));
  }

  return results;
}

} // namespace wasm::DFA

#endif // wasm_support_dfa_minimization_h
