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

#include "ir/public-type-validator.h"
#include "wasm-type.h"

namespace wasm {

bool PublicTypeValidator::isValidPublicTypeImpl(HeapType type) {
  assert(!features.hasCustomDescriptors());
  assert(!type.isBasic());
  // If custom descriptors is not enabled and exposing this type would make an
  // exact reference public, then this type is not valid to make public.
  // Traverse the heap types reachable from this one, looking for exact
  // references. Cache the findings for each group along the way to minimize
  // future work.
  struct Task {
    RecGroup group;
    bool finished;
  };
  std::vector<Task> workList{Task{type.getRecGroup(), false}};
  std::unordered_set<RecGroup> visiting;

  auto markVisitingInvalid = [&]() {
    for (auto group : visiting) {
      [[maybe_unused]] auto [_, inserted] =
        allowedPublicGroupCache.insert({group, false});
      assert(inserted);
    }
  };

  while (!workList.empty()) {
    auto task = workList.back();
    workList.pop_back();
    if (task.finished) {
      // We finished searching this group and the groups it reaches without
      // finding a problem.
      visiting.erase(task.group);
      [[maybe_unused]] auto [_, inserted] =
        allowedPublicGroupCache.insert({task.group, true});
      assert(inserted);
      continue;
    }
    if (auto it = allowedPublicGroupCache.find(task.group);
        it != allowedPublicGroupCache.end()) {
      if (it->second) {
        // We already know this group is valid. Move on to the next group.
        continue;
      } else {
        // This group is invalid!
        markVisitingInvalid();
        return false;
      }
    }
    // Check whether we are already in the process of searching this group.
    if (!visiting.insert(task.group).second) {
      continue;
    }
    // We have never seen this group before. Search it. Push a completion task
    // first so we will know when we have finished searching.
    workList.push_back({task.group, true});
    for (auto heapType : task.group) {
      // Look for invalid exact references.
      for (auto t : heapType.getTypeChildren()) {
        if (t.isExact()) {
          markVisitingInvalid();
          return false;
        }
      }
      // Search the referenced groups as well.
      for (auto t : heapType.getReferencedHeapTypes()) {
        if (!t.isBasic()) {
          workList.push_back({t.getRecGroup(), false});
        }
      }
    }
  }

  // We searched all the reachable types and never found an exact reference.
  return true;
}

} // namespace wasm
