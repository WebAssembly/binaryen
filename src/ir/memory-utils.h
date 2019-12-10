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
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace MemoryUtils {
// Flattens memory into a single data segment, or no segment. If there is
// a segment, it starts at 0.
// If ensuredSegmentSize is provided, then a segment is always emitted,
// and of at least that size.
// Returns true if successful (e.g. relocatable segments cannot be flattened).
inline bool flatten(Memory& memory,
                    Index ensuredSegmentSize = 0,
                    Module* module = nullptr) {
  if (memory.segments.size() == 0) {
    if (ensuredSegmentSize > 0) {
      assert(module); // must provide a module if ensuring a size.
      Builder builder(*module);
      memory.segments.emplace_back(builder.makeConst(Literal(int32_t(0))));
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

// Ensures that the memory exists (of minimal size).
inline void ensureExists(Memory& memory) {
  if (!memory.exists) {
    memory.exists = true;
    memory.initial = memory.max = 1;
  }
}

// Try to merge segments until they fit into web limitations.
// Return true if successful.
inline bool ensureLimitedSegments(Module& module) {
  Memory& memory = module.memory;
  if (memory.segments.size() <= WebLimitations::MaxDataSegments) {
    return true;
  }

  // Conservatively refuse to change segments if there might be memory.init
  // and data.drop instructions.
  if (module.features.hasBulkMemory()) {
    return false;
  }

  auto isEmpty = [](Memory::Segment& segment) {
    return segment.data.size() == 0;
  };

  auto isConstantOffset = [](Memory::Segment& segment) {
    return segment.offset && segment.offset->is<Const>();
  };

  Index numConstant = 0, numDynamic = 0;
  bool hasPassiveSegments = false;
  for (auto& segment : memory.segments) {
    if (!isEmpty(segment)) {
      if (isConstantOffset(segment)) {
        numConstant++;
      } else {
        numDynamic++;
      }
    }
    hasPassiveSegments |= segment.isPassive;
  }

  if (hasPassiveSegments) {
    return false;
  }

  // check if we have too many dynamic data segments, which we can do nothing
  // about
  if (numDynamic + 1 >= WebLimitations::MaxDataSegments) {
    return false;
  }

  // we'll merge constant segments if we must
  if (numConstant + numDynamic >= WebLimitations::MaxDataSegments) {
    numConstant = WebLimitations::MaxDataSegments - numDynamic - 1;
    auto num = numConstant + numDynamic;
    WASM_UNUSED(num);
    assert(num == WebLimitations::MaxDataSegments - 1);
  }

  std::vector<Memory::Segment> mergedSegments;
  mergedSegments.reserve(WebLimitations::MaxDataSegments);

  // drop empty segments and pass through dynamic-offset segments
  for (auto& segment : memory.segments) {
    if (isEmpty(segment)) {
      continue;
    }
    if (isConstantOffset(segment)) {
      continue;
    }
    mergedSegments.push_back(segment);
  }

  // from here on, we concern ourselves with non-empty constant-offset
  // segments, the ones which we may need to merge
  auto isRelevant = [&](Memory::Segment& segment) {
    return !isEmpty(segment) && isConstantOffset(segment);
  };
  for (Index i = 0; i < memory.segments.size(); i++) {
    auto& segment = memory.segments[i];
    if (!isRelevant(segment)) {
      continue;
    }
    if (mergedSegments.size() + 2 < WebLimitations::MaxDataSegments) {
      mergedSegments.push_back(segment);
      continue;
    }
    // we can emit only one more segment! merge everything into one
    // start the combined segment at the bottom of them all
    auto start = segment.offset->cast<Const>()->value.getInteger();
    for (Index j = i + 1; j < memory.segments.size(); j++) {
      auto& segment = memory.segments[j];
      if (!isRelevant(segment)) {
        continue;
      }
      auto offset = segment.offset->cast<Const>()->value.getInteger();
      start = std::min(start, offset);
    }
    // create the segment and add in all the data
    auto* c = module.allocator.alloc<Const>();
    c->value = Literal(int32_t(start));
    c->type = i32;

    Memory::Segment combined(c);
    for (Index j = i; j < memory.segments.size(); j++) {
      auto& segment = memory.segments[j];
      if (!isRelevant(segment)) {
        continue;
      }
      auto offset = segment.offset->cast<Const>()->value.getInteger();
      auto needed = offset + segment.data.size() - start;
      if (combined.data.size() < needed) {
        combined.data.resize(needed);
      }
      std::copy(segment.data.begin(),
                segment.data.end(),
                combined.data.begin() + (offset - start));
    }
    mergedSegments.push_back(combined);
    break;
  }

  memory.segments.swap(mergedSegments);
  return true;
}
} // namespace MemoryUtils

} // namespace wasm

#endif // wasm_ir_memory_h
