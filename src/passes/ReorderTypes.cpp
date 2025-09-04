/*
 * Copyright 2025 WebAssembly Community Group participants
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
// Reorder private types within a single large recursion group to minimize the
// cumulative size of type indices throughout the module.
//

#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "support/insert_ordered.h"
#include "support/topological_sort.h"
#include "wasm-type.h"
#include "wasm.h"
namespace wasm {

namespace {

struct ReorderingTypeRewriter : GlobalTypeRewriter {
  using InfoMap = InsertOrderedMap<HeapType, ModuleUtils::HeapTypeInfo>;

  InfoMap& typeInfo;

  // Use a simpler cost calculation so the effects can be seen with smaller test
  // cases.
  bool forTesting;

  // Try sorting with several exponential factors applied to the weight
  // contribution from successors, then pick the best result.
  static constexpr float minFactor = 0.0;
  static constexpr float maxFactor = 1.0;
  static constexpr Index numFactors = 21;

  ReorderingTypeRewriter(Module& wasm, InfoMap& typeInfo, bool forTesting)
    : GlobalTypeRewriter(wasm), typeInfo(typeInfo), forTesting(forTesting) {}

  std::vector<HeapType> getSortedTypes(PredecessorGraph preds) override {
    auto numTypes = preds.size();
    std::unordered_map<HeapType, Index> indices;
    for (auto& [type, _] : preds) {
      indices[type] = indices.size();
    }
    // We will use raw type indices in the various sorts. Extract an index-only
    // successor graph and a map from type index to use count.
    TopologicalSort::Graph succs(numTypes);
    std::vector<Index> counts;
    counts.reserve(numTypes);
    for (auto& [type, currPreds] : preds) {
      auto it = typeInfo.find(type);
      assert(it != typeInfo.end());
      counts.push_back(it->second.useCount);
      for (auto pred : currPreds) {
        succs[indices.at(pred)].push_back(indices.at(type));
      }
    }

    // A successors-first order used to propagate weights from successors to
    // predecessors.
    auto succsFirst = TopologicalSort::sort(succs);
    std::reverse(succsFirst.begin(), succsFirst.end());

    // Try each factor in turn, keeping the best results.
    std::vector<Index> bestSort;
    Index bestCost = 0;
    for (Index factorIndex = 0; factorIndex < numFactors; ++factorIndex) {
      float factor = getFactor(factorIndex);

      // Accumulate weights. Start with the use counts for each type, then add
      // the adjusted weight for each successor to the weights of its
      // predecessors.
      std::vector<float> weights(numTypes);
      for (Index i = 0; i < numTypes; ++i) {
        weights[i] = counts[i];
      }
      for (Index pred : succsFirst) {
        for (Index succ : succs[pred]) {
          weights[pred] += weights[succ] * factor;
        }
      }

      auto sort = TopologicalSort::minSort(
        succs, [&](Index a, Index b) { return weights[a] > weights[b]; });
      auto cost = getCost(sort, counts);
      if (factorIndex == 0 || cost < bestCost) {
        bestSort = std::move(sort);
        bestCost = cost;
      }
    }

    // Translate the best sort from indices back to types.
    std::vector<HeapType> result;
    result.reserve(numTypes);
    for (Index i = 0; i < numTypes; ++i) {
      result.push_back(preds[bestSort[i]].first);
    }
    return result;
  }

  float getFactor(Index i) {
    return minFactor + (maxFactor - minFactor) * i / (numFactors - 1);
  }

  Index getCost(const std::vector<Index>& order,
                const std::vector<Index> counts) {
    // Model the number of usable bits in an LEB byte, but make it much smaller
    // for testing.
    Index bitsPerByte = forTesting ? 1 : 7;
    Index indicesPerByte = 1u << bitsPerByte;
    Index cost = 0;
    Index numBytes = 1;
    Index maxIndex = indicesPerByte;
    for (Index i = 0; i < order.size(); ++i) {
      if (i == maxIndex) {
        ++numBytes;
        maxIndex *= indicesPerByte;
      }
      cost += numBytes * counts[order[i]];
    }
    return cost;
  }
};

struct ReorderTypes : Pass {
  bool forTesting = false;

  ReorderTypes(bool forTesting = false) : forTesting(forTesting) {}

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      // This pass only does anything with GC types.
      return;
    }

    // See note in RemoveUnusedTypes.
    if (!getPassOptions().closedWorld) {
      Fatal() << "ReorderTypes requires --closed-world";
    }

    // Collect the use counts for each type.
    auto typeInfo = ModuleUtils::collectHeapTypeInfo(
      *module, ModuleUtils::TypeInclusion::BinaryTypes);

    ReorderingTypeRewriter(*module, typeInfo, forTesting).update();
  }
};

} // anonymous namespace

Pass* createReorderTypesPass() { return new ReorderTypes(); }
Pass* createReorderTypesForTestingPass() { return new ReorderTypes(true); }

} // namespace wasm
