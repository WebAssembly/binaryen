/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_ir_memory_h
#define wasm_ir_memory_h

#include <algorithm>
#include <vector>

#include "literal.h"
#include "wasm.h"

namespace wasm {

namespace MemoryUtils {
  // flattens memory into a single data segment. returns true if successful
  inline bool flatten(Memory& memory) {
    if (memory.segments.size() == 0) return true;
    std::vector<char> data;
    for (auto& segment : memory.segments) {
      auto* offset = segment.offset->dynCast<Const>();
      if (!offset) return false;
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
};

} // namespace wasm

#endif // wasm_ir_memory_h

