/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_ir_subtypes_h
#define wasm_ir_subtypes_h

#include "ir/module-utils.h"
#include "support/topological_sort.h"
#include "wasm.h"

namespace wasm {

// Analyze subtyping relationships and provide useful interfaces to discover
// them.
//
// This only scans user types, and not basic types like HeapType::eq.
struct SubTypes {
  SubTypes(const std::vector<HeapType>& types) : types(types) {
    for (auto type : types) {
      note(type);
    }
  }

  SubTypes(Module& wasm) : SubTypes(ModuleUtils::collectHeapTypes(wasm)) {}

  const std::vector<HeapType>& getImmediateSubTypes(HeapType type) const {
    // When we return an empty result, use a canonical constant empty vec to
    // avoid allocation.
    static const std::vector<HeapType> empty;

    if (type.isBottom()) {
      // Bottom types have no subtypes.
      return empty;
    }

    assert(!type.isBasic());
    if (auto iter = typeSubTypes.find(type); iter != typeSubTypes.end()) {
      return iter->second;
    }

    // No entry exists.
    return empty;
  }

  // Get all subtypes of a type, and their subtypes and so forth, recursively,
  // excluding the type itself.
  std::vector<HeapType> getStrictSubTypes(HeapType type) {
    std::vector<HeapType> ret, work;
    work.push_back(type);
    while (!work.empty()) {
      auto curr = work.back();
      work.pop_back();
      for (auto sub : getImmediateSubTypes(curr)) {
        ret.push_back(sub);
        work.push_back(sub);
      }
    }
    return ret;
  }

  // Like getStrictSubTypes, but also includes the type itself.
  std::vector<HeapType> getSubTypes(HeapType type) {
    auto ret = getStrictSubTypes(type);
    ret.push_back(type);
    return ret;
  }

  // A topological sort that visits subtypes first.
  auto getSubTypesFirstSort() const {
    struct SubTypesFirstSort : TopologicalSort<HeapType, SubTypesFirstSort> {
      const SubTypes& parent;

      SubTypesFirstSort(const SubTypes& parent) : parent(parent) {
        for (auto type : parent.types) {
          // The roots are types with no supertype.
          if (!type.getDeclaredSuperType()) {
            push(type);
          }
        }
      }

      void pushPredecessors(HeapType type) {
        // Things we need to process before each type are its subtypes. Once we
        // know their depth, we can easily compute our own.
        for (auto pred : parent.getImmediateSubTypes(type)) {
          push(pred);
        }
      }
    };

    return SubTypesFirstSort(*this);
  }

  // Computes the depth of children for each type. This is 0 if the type has no
  // subtypes, 1 if it has subtypes but none of those have subtypes themselves,
  // and so forth.
  //
  // This depth ignores bottom types.
  std::unordered_map<HeapType, Index> getMaxDepths() {
    std::unordered_map<HeapType, Index> depths;

    for (auto type : getSubTypesFirstSort()) {
      // Begin with depth 0, then take into account the subtype depths.
      Index depth = 0;
      for (auto subType : getImmediateSubTypes(type)) {
        depth = std::max(depth, depths[subType] + 1);
      }
      depths[type] = depth;
    }

    // Add the max depths of basic types.
    for (auto type : types) {
      HeapType basic;
      auto share = type.getShared();
      switch (type.getKind()) {
        case HeapTypeKind::Func:
          basic = HeapTypes::func.getBasic(share);
          break;
        case HeapTypeKind::Struct:
          basic = HeapTypes::struct_.getBasic(share);
          break;
        case HeapTypeKind::Array:
          basic = HeapTypes::array.getBasic(share);
          break;
        case HeapTypeKind::Cont:
          WASM_UNREACHABLE("TODO: cont");
        case HeapTypeKind::Basic:
          WASM_UNREACHABLE("unexpected kind");
      }
      auto& basicDepth = depths[basic];
      basicDepth = std::max(basicDepth, depths[type] + 1);
    }

    for (auto share : {Unshared, Shared}) {
      depths[HeapTypes::eq.getBasic(share)] =
        std::max(depths[HeapTypes::struct_.getBasic(share)],
                 depths[HeapTypes::array.getBasic(share)]) +
        1;
      depths[HeapTypes::any.getBasic(share)] =
        depths[HeapTypes::eq.getBasic(share)] + 1;
    }

    return depths;
  }

  // Efficiently iterate on subtypes of a type, up to a particular depth (depth
  // 0 means not to traverse subtypes, etc.). The callback function receives
  // (type, depth).
  template<typename F>
  void iterSubTypes(HeapType type, Index depth, F func) const {
    // Start by traversing the type itself.
    func(type, 0);

    if (depth == 0) {
      // Nothing else to scan.
      return;
    }

    // getImmediateSubTypes() returns vectors of subtypes, so for efficiency
    // store pointers to those in our work queue to avoid allocations. See the
    // note below on typeSubTypes for why this is safe.
    struct Item {
      const std::vector<HeapType>* vec;
      Index depth;
    };

    // Real-world type hierarchies tend to have a limited depth, so try to avoid
    // allocations in our work queue with a SmallVector.
    SmallVector<Item, 10> work;

    // Start with the subtypes of the base type. Those have depth 1.
    work.push_back({&getImmediateSubTypes(type), 1});

    while (!work.empty()) {
      auto& item = work.back();
      work.pop_back();
      auto currDepth = item.depth;
      auto& currVec = *item.vec;
      assert(currDepth <= depth);
      for (auto type : currVec) {
        func(type, currDepth);
        auto* subVec = &getImmediateSubTypes(type);
        if (currDepth + 1 <= depth && !subVec->empty()) {
          work.push_back({subVec, currDepth + 1});
        }
      }
    }
  }

  // As above, but iterate to the maximum depth.
  template<typename F> void iterSubTypes(HeapType type, F func) const {
    return iterSubTypes(type, std::numeric_limits<Index>::max(), func);
  }

  // All the types in the program. This is computed here anyhow, and can be
  // useful for callers to iterate on, so it is public.
  std::vector<HeapType> types;

private:
  // Add a type to the graph.
  void note(HeapType type) {
    if (auto super = type.getDeclaredSuperType()) {
      typeSubTypes[*super].push_back(type);
    }
  }

  // Maps a type to its subtypes.
  //
  // After our constructor we never modify this data structure, so we can take
  // references to the vectors here safely.
  std::unordered_map<HeapType, std::vector<HeapType>> typeSubTypes;
};

} // namespace wasm

#endif // wasm_ir_subtypes_h
