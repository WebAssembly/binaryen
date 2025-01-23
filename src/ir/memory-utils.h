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
#include "wasm-limits.h"
#include "wasm.h"

namespace wasm::MemoryUtils {

// Flattens memory into a single data segment, or no segment. If there is
// a segment, it starts at 0.
// Returns true if successful (e.g. relocatable segments cannot be flattened).
// Does not yet support multimemory
bool flatten(Module& wasm);

// Ensures that a memory exists (of minimal size).
inline void ensureExists(Module* wasm) {
  if (wasm->memories.empty()) {
    auto memory = Builder::makeMemory("0");
    memory->initial = memory->max = 1;
    wasm->addMemory(std::move(memory));
  }
}

// Try to merge segments until they fit into web limitations.
// Return true if successful.
// Does not yet support multimemory
inline bool ensureLimitedSegments(Module& module) {
  if (module.memories.size() > 1) {
    return false;
  }
  auto& dataSegments = module.dataSegments;
  if (dataSegments.size() <= WebLimitations::MaxDataSegments) {
    return true;
  }

  // Conservatively refuse to change segments if there might be memory.init
  // and data.drop instructions.
  if (module.features.hasBulkMemory()) {
    return false;
  }

  auto isEmpty = [](DataSegment& segment) { return segment.data.size() == 0; };

  auto isConstantOffset = [](DataSegment& segment) {
    return segment.offset && segment.offset->is<Const>();
  };

  Index numConstant = 0, numDynamic = 0;
  bool hasPassiveSegments = false;
  for (auto& segment : dataSegments) {
    if (!isEmpty(*segment)) {
      if (isConstantOffset(*segment)) {
        numConstant++;
      } else {
        numDynamic++;
      }
    }
    hasPassiveSegments |= segment->isPassive;
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
    [[maybe_unused]] auto num = numConstant + numDynamic;
    assert(num == WebLimitations::MaxDataSegments - 1);
  }

  std::vector<std::unique_ptr<wasm::DataSegment>> mergedSegments;
  mergedSegments.reserve(WebLimitations::MaxDataSegments);

  // drop empty segments and pass through dynamic-offset segments
  for (auto& segment : dataSegments) {
    if (isEmpty(*segment)) {
      continue;
    }
    if (isConstantOffset(*segment)) {
      continue;
    }
    mergedSegments.push_back(std::move(segment));
  }

  // from here on, we concern ourselves with non-empty constant-offset
  // segments, the ones which we may need to merge
  auto isRelevant = [&](DataSegment& segment) {
    return !isEmpty(segment) && isConstantOffset(segment);
  };
  for (Index i = 0; i < dataSegments.size(); i++) {
    auto& segment = dataSegments[i];
    if (!isRelevant(*segment)) {
      continue;
    }
    if (mergedSegments.size() + 2 < WebLimitations::MaxDataSegments) {
      mergedSegments.push_back(std::move(segment));
      continue;
    }
    // we can emit only one more segment! merge everything into one
    // start the combined segment at the bottom of them all
    auto start = segment->offset->cast<Const>()->value.getInteger();
    for (Index j = i + 1; j < dataSegments.size(); j++) {
      auto& segment = dataSegments[j];
      if (!isRelevant(*segment)) {
        continue;
      }
      auto offset = segment->offset->cast<Const>()->value.getInteger();
      start = std::min(start, offset);
    }
    // create the segment and add in all the data
    auto* c = module.allocator.alloc<Const>();
    c->value = Literal(int32_t(start));
    c->type = Type::i32;

    auto combined = Builder::makeDataSegment();
    combined->memory = module.memories[0]->name;
    combined->offset = c;
    for (Index j = i; j < dataSegments.size(); j++) {
      auto& segment = dataSegments[j];
      if (!isRelevant(*segment)) {
        continue;
      }
      auto offset = segment->offset->cast<Const>()->value.getInteger();
      auto needed = offset + segment->data.size() - start;
      if (combined->data.size() < needed) {
        combined->data.resize(needed);
      }
      std::copy(segment->data.begin(),
                segment->data.end(),
                combined->data.begin() + (offset - start));
    }
    mergedSegments.push_back(std::move(combined));
    break;
  }

  dataSegments.swap(mergedSegments);
  module.updateDataSegmentsMap();
  return true;
}
} // namespace wasm::MemoryUtils

#endif // wasm_ir_memory_h
