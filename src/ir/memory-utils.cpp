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

bool flatten(Module& wasm) {
  // The presence of any MemoryInit instructions is a problem because they care
  // about segment identity, which flattening gets rid of ( when it merges them
  // all into one big segment).
  ModuleUtils::ParallelFunctionAnalysis<bool> analysis(
    wasm, [&](Function* func, bool& hasMemoryInit) {
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

  auto& memory = wasm.memory;

  if (memory.segments.size() == 0) {
    return true;
  }

  std::vector<char> data;
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
