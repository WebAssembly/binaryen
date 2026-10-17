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
// The new payloads are stored in a single new passive segment. Identical
// payloads are stored once, and a payload that is identical to an existing
// passive segment that is never dropped reuses that segment.
//
// Each group of identical payloads is converted if that reduces the estimated
// binary size:
//
//   array.new_fixed $T N (c0) ... (cN-1)
//     = prefix typeidx u32(N) size(c0) ... size(cN-1)
//   array.new_data $T $seg (i32.const off) (i32.const N)
//     = prefix typeidx u32(seg) 0x41 s32(off) 0x41 s32(N)
//
// plus the payload bytes (N * elemBytes) if they are not already present.
//
// TODO: Also reuse payloads that appear inside other data. That needs an
//       efficient substring search, to avoid quadratic behavior.
// TODO: Convert arrays of constant references to array.new_elem.
//

#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "ir/debuginfo.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

template<typename T> size_t getWrittenSize(const T& thing) {
  BufferWithRandomAccess buffer;
  buffer << thing;
  return buffer.size();
}

// The size of a *.const instruction in the binary format.
size_t getConstSize(const Literal& value) {
  switch (value.type.getBasic()) {
    case Type::i32:
      return 1 + getWrittenSize(S32LEB(value.geti32()));
    case Type::i64:
      return 1 + getWrittenSize(S64LEB(value.geti64()));
    case Type::f32:
    case Type::f64:
      return 1 + value.type.getByteSize();
    case Type::v128:
      // The SIMD prefix and opcode, and the value.
      return 2 + 16;
    case Type::none:
    case Type::unreachable:
      break;
  }
  WASM_UNREACHABLE("unexpected const type");
}

struct Candidate {
  Function* func;
  // Where the array.new_fixed is.
  Expression** location;
  // The bytes the array would have in a data segment.
  std::string payload;
  // The size of the elements count and the operands of the array.new_fixed
  // (the prefix and type index are the same in both forms, so we ignore them).
  size_t fixedSize;
};

std::optional<Candidate> getCandidate(Function* func, Expression** location) {
  auto* curr = (*location)->cast<ArrayNewFixed>();
  if (curr->type == Type::unreachable || curr->values.empty()) {
    return std::nullopt;
  }
  const auto& element = curr->type.getHeapType().getArray().element;
  if (!element.type.isNumber()) {
    return std::nullopt;
  }
  auto elemBytes = element.getByteSize();

  Candidate candidate{
    func, location, {}, getWrittenSize(U32LEB(curr->values.size()))};
  candidate.payload.reserve(curr->values.size() * elemBytes);
  for (auto* value : curr->values) {
    auto* c = value->dynCast<Const>();
    if (!c) {
      return std::nullopt;
    }
    candidate.fixedSize += getConstSize(c->value);
    // getBits writes little-endian, so the first bytes are what a packed field
    // stores, which matches the truncation array.new_fixed does.
    uint8_t bits[16];
    c->value.getBits(bits);
    candidate.payload.append(reinterpret_cast<const char*>(bits), elemBytes);
  }
  return candidate;
}

struct FunctionInfo {
  std::vector<Candidate> candidates;
  std::unordered_set<Name> droppedSegments;
};

struct ConstantArraysToData : public Pass {
  // We only replace allocations with other allocations of the same type.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    if (!module->features.hasGC() || !module->features.hasBulkMemory()) {
      return;
    }

    ModuleUtils::ParallelFunctionAnalysis<FunctionInfo> analysis(
      *module, [](Function* func, FunctionInfo& info) {
        if (func->imported()) {
          return;
        }
        for (auto** location :
             FindAllPointers<ArrayNewFixed>(func->body).list) {
          if (auto candidate = getCandidate(func, location)) {
            info.candidates.push_back(std::move(*candidate));
          }
        }
        for (auto* drop : FindAll<DataDrop>(func->body).list) {
          info.droppedSegments.insert(drop->segment);
        }
      });

    // Group identical payloads, in a deterministic order.
    struct Group {
      std::string_view payload;
      std::vector<Candidate*> candidates;
    };
    std::vector<Group> groups;
    std::unordered_map<std::string_view, Index> groupIndexes;
    std::unordered_set<Name> droppedSegments;
    for (auto& func : module->functions) {
      auto& info = analysis.map[func.get()];
      for (auto& candidate : info.candidates) {
        auto [it, inserted] =
          groupIndexes.insert({candidate.payload, groups.size()});
        if (inserted) {
          groups.push_back({candidate.payload, {}});
        }
        groups[it->second].candidates.push_back(&candidate);
      }
      droppedSegments.insert(info.droppedSegments.begin(),
                             info.droppedSegments.end());
    }
    if (groups.empty()) {
      return;
    }

    // Passive segments that are never dropped can be reused by identical
    // payloads.
    std::unordered_map<std::string_view, Index> existingSegments;
    for (Index i = 0; i < module->dataSegments.size(); i++) {
      auto& segment = module->dataSegments[i];
      if (segment->isPassive() && !droppedSegments.contains(segment->name)) {
        existingSegments.insert(
          {std::string_view(segment->data.data(), segment->data.size()), i});
      }
    }

    // Decide which groups to convert. Payloads that are not in an existing
    // segment are appended to the contents of a new segment.
    struct Decision {
      Group* group;
      Index segment;
      Index offset;
    };
    std::vector<Decision> decisions;
    Index newSegment = module->dataSegments.size();
    std::string newData;
    int64_t newSegmentSavings = 0;
    for (auto& group : groups) {
      Index segment = newSegment;
      Index offset = 0;
      size_t dataCost = 0;
      if (auto it = existingSegments.find(group.payload);
          it != existingSegments.end()) {
        segment = it->second;
      } else {
        offset = newData.size();
        dataCost = group.payload.size();
      }

      int64_t savings = -int64_t(dataCost);
      for (auto* candidate : group.candidates) {
        auto* fixed = (*candidate->location)->cast<ArrayNewFixed>();
        size_t dataSize = getWrittenSize(U32LEB(segment)) + 1 +
                          getWrittenSize(S32LEB(int32_t(offset))) + 1 +
                          getWrittenSize(S32LEB(int32_t(fixed->values.size())));
        savings += int64_t(candidate->fixedSize) - int64_t(dataSize);
      }
      if (savings <= 0) {
        continue;
      }
      if (segment == newSegment) {
        newData.append(group.payload);
        newSegmentSavings += savings;
      }
      decisions.push_back({&group, segment, offset});
    }

    if (!newData.empty()) {
      // The new segment needs its flags and size, and if it is the first
      // segment, also the headers of the data count and data sections (id, size
      // and count, which are 3 bytes each).
      int64_t overhead = 1 + getWrittenSize(U32LEB(newData.size()));
      if (module->dataSegments.empty()) {
        overhead += 2 * 3;
      }
      if (newSegmentSavings > overhead) {
        auto name =
          Names::getValidDataSegmentName(*module, "constant-array-data");
        module->addDataSegment(Builder::makeDataSegment(
          name, Name(), nullptr, newData.data(), newData.size()));
      } else {
        // The new segment is not worth it, but we can still reuse existing
        // ones.
        std::erase_if(decisions, [&](const Decision& decision) {
          return decision.segment == newSegment;
        });
      }
    }

    Builder builder(*module);
    for (auto& decision : decisions) {
      auto segment = module->dataSegments[decision.segment]->name;
      for (auto* candidate : decision.group->candidates) {
        auto* fixed = (*candidate->location)->cast<ArrayNewFixed>();
        auto* data = builder.makeArrayNewData(
          fixed->type.getHeapType(),
          segment,
          builder.makeConst(int32_t(decision.offset)),
          builder.makeConst(int32_t(fixed->values.size())));
        assert(data->type == fixed->type);
        debuginfo::copyOriginalToReplacement(fixed, data, candidate->func);
        *candidate->location = data;
      }
    }
  }
};

} // anonymous namespace

Pass* createConstantArraysToDataPass() { return new ConstantArraysToData(); }

} // namespace wasm
