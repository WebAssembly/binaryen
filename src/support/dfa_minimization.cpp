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

#include <map>

#include "dfa_minimization.h"

namespace wasm::DFA {

namespace {

// A vector of initial partitions, each of which is a vector of elements, each
// of which is a vector of successor indices.
using InputGraph = std::vector<std::vector<std::vector<size_t>>>;

// The Refined Partitions data structure used in Valmari-Lehtinen DFA
// minimization. The translation from terms used in the Valmari-Lehtinen paper
// to the more expanded terms used here is:
//
//   Block => Set
//   elems => elements
//   loc => elementIndices
//   sidx => setIndices
//   first => beginnings
//   end => endings
//   mid => pivots
//
struct Partitions {
  // The number of sets.
  size_t sets = 0;

  // The partitioned elements. Elements in the same set are next to each other.
  // Within each set, "marked" elements come first followed by "unmarked"
  // elements.
  std::vector<size_t> elements;

  // Maps elements to their indices in `elements`.
  std::vector<size_t> elementIndices;

  // Maps elements to their sets, identified by an index.
  std::vector<size_t> setIndices;

  // Maps sets to the indices of their first elements in `elements`.
  std::vector<size_t> beginnings;

  // Maps sets to (one past) the indices of their ends in `elements`.
  std::vector<size_t> endings;

  // Maps sets to the indices of their first unmarked elements in `elements`.
  std::vector<size_t> pivots;

  Partitions() = default;

  // Allocate space up front so we never need to re-allocate. The actual
  // contents of all the vectors will need to be externally initialized,
  // though.
  Partitions(size_t size)
    : elements(size), elementIndices(size), setIndices(size), beginnings(size),
      endings(size), pivots(size) {}

  struct Set {
    using Iterator = std::vector<size_t>::iterator;

    Partitions& partitions;
    size_t index;

    Set(Partitions& partitions, size_t index)
      : partitions(partitions), index(index) {}

    Iterator begin() {
      return partitions.elements.begin() + partitions.beginnings[index];
    }
    Iterator end() {
      return partitions.elements.begin() + partitions.endings[index];
    }
    size_t size() {
      return partitions.endings[index] - partitions.beginnings[index];
    }

    bool hasMarks() {
      return partitions.pivots[index] != partitions.beginnings[index];
    }

    // Split the set between marked and unmarked elements if there are both
    // marked and unmarked elements. Unmark all elements of this set regardless.
    // Return the index of the new partition or 0 if there was no split.
    size_t split() {
      size_t begin = partitions.beginnings[index];
      size_t end = partitions.endings[index];
      size_t pivot = partitions.pivots[index];
      if (pivot == begin) {
        // No elements marked, so there is nothing to do.
        return 0;
      }
      if (pivot == end) {
        // All elements were marked, so just unmark them.
        partitions.pivots[index] = begin;
        return 0;
      }
      // Create a new set covering the marked region.
      size_t newIndex = partitions.sets++;
      partitions.beginnings[newIndex] = begin;
      partitions.pivots[newIndex] = begin;
      partitions.endings[newIndex] = pivot;
      for (size_t i = begin; i < pivot; ++i) {
        partitions.setIndices[partitions.elements[i]] = newIndex;
      }
      // Update the old set. The end and pivot are already correct.
      partitions.beginnings[index] = pivot;
      return newIndex;
    }
  };

  Set getSet(size_t index) { return {*this, index}; }

  // Returns the set containing an element, which can be iterated upon. The set
  // may be invalidated by calls to `mark` or `Set::split`.
  Set getSetForElem(size_t element) { return getSet(setIndices[element]); }

  void mark(size_t element) {
    size_t index = elementIndices[element];
    size_t set = setIndices[element];
    size_t pivot = pivots[set];
    if (index >= pivot) {
      // Move the pivot element into the location of the newly marked element.
      elements[index] = elements[pivot];
      elementIndices[elements[index]] = index;
      // Move the newly marked element into the pivot location.
      elements[pivot] = element;
      elementIndices[element] = pivot;
      // Update the pivot index to mark the element.
      ++pivots[set];
    }
  }
};

Partitions initializeStatePartitions(const InputGraph& inputGraph,
                                     size_t numElements) {
  Partitions partitions(numElements);
  size_t elementIndex = 0;
  for (const auto& partition : inputGraph) {
    size_t set = partitions.sets++;
    partitions.beginnings[set] = elementIndex;
    partitions.pivots[set] = elementIndex;
    for (size_t i = 0; i < partition.size(); ++i) {
      partitions.elements[elementIndex] = elementIndex;
      partitions.elementIndices[elementIndex] = elementIndex;
      partitions.setIndices[elementIndex] = set;
      ++elementIndex;
    }
    partitions.endings[set] = elementIndex;
  }
  return partitions;
}

// A DFA transition into a state.
struct Transition {
  size_t pred;
  size_t label;
};

void initializeTransitions(const InputGraph& inputGraph,
                           size_t numElements,
                           size_t numTransitions,
                           std::vector<Transition>& transitions,
                           std::vector<size_t>& transitionIndices) {
  // Find the transitions into each state. Map destinations to input
  // transitions.
  std::map<size_t, std::vector<Transition>> transitionMap;
  size_t elementIndex = 0;
  for (const auto& partition : inputGraph) {
    for (const auto& elem : partition) {
      size_t label = 0;
      for (const auto& succ : elem) {
        transitionMap[succ].push_back({elementIndex, label++});
      }
      ++elementIndex;
    }
  }

  // Populate `transitions` and `transitionIndices`.
  transitions.reserve(numTransitions);
  transitionIndices.reserve(numElements + 1);
  for (size_t dest = 0; dest < numElements; ++dest) {
    // Record the first index of transitions leading to `dest`.
    transitionIndices.push_back(transitions.size());
    if (auto it = transitionMap.find(dest); it != transitionMap.end()) {
      transitions.insert(
        transitions.end(), it->second.begin(), it->second.end());
    }
  }
  // Record one-past the end of the transitions leading to the final `dest`.
  transitionIndices.push_back(transitions.size());
}

Partitions
initializeSplitterPartitions(Partitions& partitions,
                             const std::vector<Transition>& transitions,
                             const std::vector<size_t>& transitionIndices) {
  // The initial sets of splitters are partitioned by destination state
  // partition and transition label.
  Partitions splitters(transitions.size());
  size_t elementIndex = 0;
  for (size_t statePartition = 0; statePartition < partitions.sets;
       ++statePartition) {
    // The in-transitions leading to states in the current partition, organized
    // by transition label.
    std::map<size_t, std::vector<size_t>> currTransitions;
    for (size_t state : partitions.getSet(statePartition)) {
      for (size_t transition = transitionIndices[state],
                  end = transitionIndices[state + 1];
           transition < end;
           ++transition) {
        currTransitions[transitions[transition].label].push_back(transition);
      }
    }
    // Create a splitter partition for each in-transition label leading to the
    // current state partition.
    for (auto& pair : currTransitions) {
      size_t set = splitters.sets++;
      splitters.beginnings[set] = elementIndex;
      splitters.pivots[set] = elementIndex;
      for (size_t transition : pair.second) {
        splitters.elements[elementIndex] = transition;
        splitters.elementIndices[transition] = elementIndex;
        splitters.setIndices[transition] = set;
        ++elementIndex;
      }
      splitters.endings[set] = elementIndex;
    }
  }
  return splitters;
}

} // anonymous namespace

namespace Internal {

std::vector<std::vector<size_t>>
refinePartitionsImpl(const InputGraph& inputGraph) {
  // Find the number of states and transitions.
  size_t numElements = 0;
  size_t numTransitions = 0;
  for (const auto& partition : inputGraph) {
    numElements += partition.size();
    for (const auto& elem : partition) {
      numTransitions += elem.size();
    }
  }

  // The partitions of DFA states.
  Partitions partitions = initializeStatePartitions(inputGraph, numElements);

  // The transitions arranged such that the transitions leading to state `q` are
  // `transitions[transitionIndices[q] : transitionIndices[q+1]]`.
  std::vector<Transition> transitions;
  std::vector<size_t> transitionIndices;
  initializeTransitions(
    inputGraph, numElements, numTransitions, transitions, transitionIndices);

  // The splitters, which are partitions of the input transitions.
  Partitions splitters =
    initializeSplitterPartitions(partitions, transitions, transitionIndices);

  // The list of splitter partitions that might be able to split states in some
  // state partition. Starts out containing all splitter partitions.
  std::vector<size_t> potentialSplitters;
  potentialSplitters.reserve(splitters.sets);
  for (size_t i = 0; i < splitters.sets; ++i) {
    potentialSplitters.push_back(i);
  }

  while (!potentialSplitters.empty()) {
    size_t potentialSplitter = potentialSplitters.back();
    potentialSplitters.pop_back();

    // The partitions that may be able to be split.
    std::vector<size_t> markedPartitions;

    // Mark states that are predecessors via this splitter partition.
    for (size_t transition : splitters.getSet(potentialSplitter)) {
      size_t state = transitions[transition].pred;
      auto partition = partitions.getSetForElem(state);
      if (!partition.hasMarks()) {
        markedPartitions.push_back(partition.index);
      }
      partitions.mark(state);
    }

    // Try to split each partition with marked states.
    for (size_t partition : markedPartitions) {
      size_t newPartition = partitions.getSet(partition).split();
      if (!newPartition) {
        // There was nothing to split.
        continue;
      }

      // We only want to keep using the smaller of the two split partitions.
      if (partitions.getSet(newPartition).size() <
          partitions.getSet(partition).size()) {
        newPartition = partition;
      }

      // The splitter partitions that may need to be split to match the new
      // split of the state partitions.
      std::vector<size_t> markedSplitters;

      // Mark transitions that lead to the newly split off states.
      for (size_t state : partitions.getSet(newPartition)) {
        for (size_t t = transitionIndices[state],
                    end = transitionIndices[state + 1];
             t < end;
             ++t) {
          auto splitter = splitters.getSetForElem(t);
          if (!splitter.hasMarks()) {
            markedSplitters.push_back(splitter.index);
          }
          splitters.mark(t);
        }
      }

      // Split the splitters and update `potentialSplitters`.
      for (size_t splitter : markedSplitters) {
        size_t newSplitter = splitters.getSet(splitter).split();
        if (newSplitter) {
          potentialSplitters.push_back(newSplitter);
        }
      }
    }
  }

  // Return the refined partitions.
  std::vector<std::vector<size_t>> resultPartitions;
  resultPartitions.reserve(partitions.sets);
  for (size_t p = 0; p < partitions.sets; ++p) {
    auto partition = partitions.getSet(p);
    std::vector<size_t> resultPartition;
    resultPartition.reserve(partition.size());
    for (size_t elem : partition) {
      resultPartition.push_back(elem);
    }
    resultPartitions.emplace_back(std::move(resultPartition));
  }
  return resultPartitions;
}

} // namespace Internal

} // namespace wasm::DFA
