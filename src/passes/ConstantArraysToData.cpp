/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Converts array.new_fixed of constant numeric values in function bodies into
// array.new_data from a passive data segment, when that is smaller.
//
// array.new_fixed needs a full *.const instruction per element, while a data
// segment stores the raw bytes, so large arrays, or arrays whose values have
// long encodings, are smaller as array.new_data. On the other hand,
// array.new_fixed is a constant expression that many optimizations understand
// (and OptimizeInstructions lowers array.new_data into it for that reason), so
// this pass is only useful at the very end of the pipeline, where nothing can
// benefit from array.new_fixed anymore. The default pipeline runs it as part of
// the last set of optimizations.
//
// Global initializers are not modified, as array.new_data is not a constant
// expression.
//
// All the new payloads are stored in a single new passive segment. A payload
// that appears more than once is stored once, and payloads that are already
// present in the new segment or in an existing passive segment that is never
// dropped reuse those bytes.
//
// The decision is made for each group of identical payloads using an estimate
// of the binary size:
//
//   array.new_fixed $T N (c0) ... (cN-1)
//     = prefix typeidx u32(N) size(c0) ... size(cN-1)
//   array.new_data $T $seg (i32.const off) (i32.const N)
//     = prefix typeidx u32(seg) 0x41 s32(off) 0x41 s32(N)
//
// plus the payload bytes (N * elemBytes) if they are not already present. A
// group is converted if the estimate is smaller.
//

#include <algorithm>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

size_t getU32LEBSize(uint64_t value) {
  size_t size = 1;
  while (value >= 0x80) {
    value >>= 7;
    size++;
  }
  return size;
}

size_t getSLEBSize(int64_t value) {
  size_t size = 0;
  while (true) {
    uint8_t byte = value & 0x7f;
    value >>= 7;
    size++;
    if ((value == 0 && !(byte & 0x40)) || (value == -1 && (byte & 0x40))) {
      return size;
    }
  }
}

// The size of a *.const instruction in the binary format.
size_t getConstSize(const Literal& value) {
  switch (value.type.getBasic()) {
    case Type::i32:
      return 1 + getSLEBSize(value.geti32());
    case Type::i64:
      return 1 + getSLEBSize(value.geti64());
    case Type::f32:
      return 1 + 4;
    case Type::f64:
      return 1 + 8;
    case Type::v128:
      return 2 + 16;
    default:
      WASM_UNREACHABLE("unexpected const type");
  }
}

struct Candidate {
  // Where the array.new_fixed is.
  Expression** location;
  // The bytes the array would have in a data segment.
  std::string payload;
  // The size of the elements count and the operands of the array.new_fixed
  // (the prefix and type index are the same in both forms, so we ignore them).
  size_t fixedSize;
};

using Candidates = std::vector<Candidate>;

struct Finder : public PostWalker<Finder> {
  Candidates& candidates;

  Finder(Candidates& candidates) : candidates(candidates) {}

  void visitArrayNewFixed(ArrayNewFixed* curr) {
    if (curr->type == Type::unreachable || curr->values.empty()) {
      return;
    }
    const auto& element = curr->type.getHeapType().getArray().element;
    if (!element.type.isNumber()) {
      return;
    }
    auto elemBytes = element.getByteSize();

    std::string payload;
    payload.reserve(curr->values.size() * elemBytes);
    size_t fixedSize = getU32LEBSize(curr->values.size());
    for (auto* value : curr->values) {
      auto* c = value->dynCast<Const>();
      if (!c) {
        return;
      }
      fixedSize += getConstSize(c->value);
      // getBits writes little-endian, so the first bytes are what a packed
      // field stores, which matches the truncation array.new_fixed does.
      uint8_t bits[16];
      c->value.getBits(bits);
      payload.append(reinterpret_cast<const char*>(bits), elemBytes);
    }
    candidates.push_back({getCurrentPointer(), std::move(payload), fixedSize});
  }
};

struct ConstantArraysToData : public Pass {
  // We only replace allocations with other allocations of the same type.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    if (!module->features.hasGC() || !module->features.hasBulkMemory()) {
      return;
    }

    ModuleUtils::ParallelFunctionAnalysis<Candidates> analysis(
      *module, [&](Function* func, Candidates& candidates) {
        if (!func->imported()) {
          Finder(candidates).walk(func->body);
        }
      });

    // Group identical payloads, in a deterministic order.
    struct Group {
      std::string_view payload;
      std::vector<Candidate*> candidates;
    };
    std::vector<Group> groups;
    std::unordered_map<std::string_view, Index> groupIndexes;
    for (auto& func : module->functions) {
      for (auto& candidate : analysis.map[func.get()]) {
        auto [it, inserted] =
          groupIndexes.insert({candidate.payload, groups.size()});
        if (inserted) {
          groups.push_back({candidate.payload, {}});
        }
        groups[it->second].candidates.push_back(&candidate);
      }
    }
    if (groups.empty()) {
      return;
    }

    // Find the existing passive segments whose bytes we can reuse. A segment
    // that is dropped cannot be read afterwards, so ignore those.
    std::unordered_set<Name> droppedSegments;
    for (auto& func : module->functions) {
      if (!func->imported()) {
        for (auto* drop : FindAll<DataDrop>(func->body).list) {
          droppedSegments.insert(drop->segment);
        }
      }
    }
    struct ExistingSegment {
      Name name;
      Index index;
      std::string_view data;
    };
    std::vector<ExistingSegment> existingSegments;
    for (Index i = 0; i < module->dataSegments.size(); i++) {
      auto& segment = module->dataSegments[i];
      if (segment->isPassive() && !droppedSegments.contains(segment->name) &&
          !segment->data.empty()) {
        existingSegments.push_back(
          {segment->name,
           i,
           std::string_view(segment->data.data(), segment->data.size())});
      }
    }

    // Handle larger payloads first, so that smaller ones have a better chance
    // to be found inside them.
    std::stable_sort(groups.begin(), groups.end(), [](auto& a, auto& b) {
      return a.payload.size() > b.payload.size();
    });

    // The contents of the new segment.
    std::string newData;
    Index newSegmentIndex = module->dataSegments.size();

    struct Decision {
      Group* group;
      // The segment to read from, or a null name for the new segment.
      Name segment;
      Index offset;
    };
    std::vector<Decision> decisions;
    int64_t totalSavings = 0;

    for (auto& group : groups) {
      auto payload = group.payload;
      Name segment;
      Index segmentIndex = newSegmentIndex;
      size_t offset = newData.find(payload);
      size_t dataCost = 0;
      if (offset == std::string::npos) {
        for (auto& existing : existingSegments) {
          offset = existing.data.find(payload);
          if (offset != std::string_view::npos) {
            segment = existing.name;
            segmentIndex = existing.index;
            break;
          }
        }
      }
      if (offset == std::string::npos) {
        offset = newData.size();
        dataCost = payload.size();
      }

      int64_t savings = -int64_t(dataCost);
      for (auto* candidate : group.candidates) {
        auto* fixed = (*candidate->location)->cast<ArrayNewFixed>();
        size_t dataSize = getU32LEBSize(segmentIndex) + 1 +
                          getSLEBSize(int64_t(offset)) + 1 +
                          getSLEBSize(int64_t(fixed->values.size()));
        savings += int64_t(candidate->fixedSize) - int64_t(dataSize);
      }
      if (savings <= 0) {
        continue;
      }
      if (dataCost) {
        newData.append(payload);
      }
      totalSavings += savings;
      decisions.push_back({&group, segment, Index(offset)});
    }
    if (decisions.empty()) {
      return;
    }

    Name newSegmentName;
    if (!newData.empty()) {
      // Account for the new segment's flags and size, and for the data count
      // and data section headers if this is the first segment.
      int64_t overhead = 1 + getU32LEBSize(newData.size());
      if (module->dataSegments.empty()) {
        overhead += 6;
      }
      if (totalSavings <= overhead) {
        return;
      }
      newSegmentName =
        Names::getValidDataSegmentName(*module, "constant-array-data");
      auto segment = std::make_unique<DataSegment>();
      segment->setName(newSegmentName, false);
      segment->data.assign(newData.begin(), newData.end());
      module->addDataSegment(std::move(segment));
    }

    Builder builder(*module);
    for (auto& decision : decisions) {
      auto segment = decision.segment ? decision.segment : newSegmentName;
      for (auto* candidate : decision.group->candidates) {
        auto* fixed = (*candidate->location)->cast<ArrayNewFixed>();
        auto* data = builder.makeArrayNewData(
          fixed->type.getHeapType(),
          segment,
          builder.makeConst(int32_t(decision.offset)),
          builder.makeConst(int32_t(fixed->values.size())));
        assert(data->type == fixed->type);
        *candidate->location = data;
      }
    }
  }
};

} // anonymous namespace

Pass* createConstantArraysToDataPass() { return new ConstantArraysToData(); }

} // namespace wasm
