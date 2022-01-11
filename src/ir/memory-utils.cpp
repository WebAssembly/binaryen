/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include "ir/memory-utils.h"
#include "wasm.h"

namespace wasm::MemoryUtils {

// Flattens memory into a single data segment, or no segment. If there is
// a segment, it starts at 0.
// If ensuredSegmentSize is provided, then a segment is always emitted,
// and of at least that size.
// Returns true if successful (e.g. relocatable segments cannot be flattened).
bool flatten(Memory& memory,
                    Index ensuredSegmentSize,
                    Module* module) {
  // The presence of any MemoryInit instructions/ is a problem because they care
  // segment identity, which flattening gets rid of when it merges them all into
  // one big segment.
  ModuleUtils::ParallelFunctionAnalysis<bool> analysis(
    *module, [&](Function* func, bool& hasMemoryInit) {
      if (func->imported()) {
        return;
      }
      hasMemoryInit = FindAll<MemoryInit>(func->body).list.size() > 0;
    });

  for (auto& [func, hasMemoryInit] : analysis.map) {
    if (hasMemoryInit) {
      return false;
    }
  }

  if (memory.segments.size() == 0) {
    if (ensuredSegmentSize > 0) {
      assert(module); // must provide a module if ensuring a size.
      Builder builder(*module);
      memory.segments.emplace_back(builder.makeConst(int32_t(0)));
      memory.segments[0].data.resize(ensuredSegmentSize);
    }
    return true;
  }
  std::vector<char> data;
  data.resize(ensuredSegmentSize);
  for (auto& segment : memory.segments) {
    if (segment.isPassive) {
      return false;
    }
    auto* offset = segment.offset->dynCast<Const>();
    if (!offset) {
      return false;
    }
  }
  for (auto& segment : memory.segments) {
    auto* offset = segment.offset->dynCast<Const>();
    Index start = offset->value.getInteger();
    Index end = start + segment.data.size();
    if (end > data.size()) {
      data.resize(end);
    }
    std::copy(segment.data.begin(), segment.data.end(), data.begin() + start);
  }
  memory.segments.resize(1);
  memory.segments[0].offset->cast<Const>()->value = Literal(int32_t(0));
  memory.segments[0].data.swap(data);
  return true;
}

} // namespace wasm::MemoryUtils
