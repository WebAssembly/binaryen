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
// passive segment that is never dropped reuses that segment. Each group of
// identical payloads is converted if that reduces the estimated binary size,
// and the new segment is only added if it pays for itself.
//
// TODO: Also reuse payloads that appear inside other data. That needs an
//       efficient substring search, to avoid quadratic behavior.
// TODO: Convert arrays of constant references to array.new_elem.
//

#include <cstring>
#include <optional>
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

// Binary size estimates.

// The number of bytes |thing| (e.g. a LEB) takes in the binary.
template<typename T> size_t getWrittenSize(const T& thing) {
  BufferWithRandomAccess buffer;
  buffer << thing;
  return buffer.size();
}

// The size of a *.const instruction.
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

// The size of an array.new_fixed of constants, apart from the prefix, opcode
// and type index, which are the same in array.new_data.
size_t getArrayNewFixedSize(ArrayNewFixed* curr) {
  size_t size = getWrittenSize(U32LEB(curr->values.size()));
  for (auto* value : curr->values) {
    size += getConstSize(value->cast<Const>()->value);
  }
  return size;
}

// The size of an array.new_data with a constant offset and size, apart from the
// prefix, opcode and type index.
size_t getArrayNewDataSize(Index segment, Index offset, Index size) {
  // The segment index, and an i32.const each for the offset and the size.
  return getWrittenSize(U32LEB(segment)) + 1 +
         getWrittenSize(S32LEB(int32_t(offset))) + 1 +
         getWrittenSize(S32LEB(int32_t(size)));
}

// The size of a new passive data segment, apart from its data.
size_t getNewSegmentOverhead(const Module& module, size_t dataSize) {
  // The flags and the size of the data.
  size_t size = 1 + getWrittenSize(U32LEB(dataSize));
  if (module.dataSegments.empty()) {
    // The first segment also adds the data count and data sections, each with
    // an id, a size and a count.
    size += 2 * 3;
  }
  return size;
}

// Candidates for conversion.

// Returns the bytes the array would have in a data segment, if its values are
// numeric constants.
std::optional<std::vector<char>> getPayload(ArrayNewFixed* curr) {
  // An unreachable array has no array type (and its values are not all
  // constants anyway), and an empty one is smaller as it is.
  if (curr->type == Type::unreachable || curr->values.empty()) {
    return std::nullopt;
  }
  const auto& element = curr->type.getHeapType().getArray().element;
  // array.new_data only supports numeric elements.
  if (!element.type.isNumber()) {
    return std::nullopt;
  }
  auto elemBytes = element.getByteSize();
  std::vector<char> payload(curr->values.size() * elemBytes);
  for (Index i = 0; i < curr->values.size(); i++) {
    auto* c = curr->values[i]->dynCast<Const>();
    if (!c) {
      return std::nullopt;
    }
    // Like stores to arrays in the interpreter, write the low bytes of the
    // value, which truncates it for packed fields.
    uint8_t bits[16];
    c->value.getBits(bits);
    memcpy(&payload[i * elemBytes], bits, elemBytes);
  }
  return payload;
}

// An array.new_fixed of numeric constants.
struct Candidate {
  Function* func;
  ArrayNewFixed* array;
  // Where |array| is, so that we can replace it.
  Expression** location;
  std::vector<char> payload;
};

// Candidates with identical payloads, which can share one copy of the bytes.
// Their arrays may have different types, as only the bytes matter.
struct PayloadGroup {
  std::string_view payload;
  std::vector<Candidate*> candidates;
};

// A payload group to convert, and where its arrays will read the payload from.
struct Conversion {
  PayloadGroup* group;
  Index segment;
  Index offset;
};

struct ConstantArraysToData : public Pass {
  // We only replace allocations with other allocations of the same type.
  bool requiresNonNullableLocalFixups() override { return false; }

  Module* module = nullptr;

  // All the candidates, in a deterministic order. Payload groups point into
  // them, so they must not change after grouping.
  std::vector<Candidate> candidates;

  // Segments that are dropped somewhere. We cannot reuse them, as
  // array.new_data traps once its segment is dropped (unless it reads nothing).
  std::unordered_set<Name> droppedSegments;

  // The contents of the new segment, if we add one.
  std::vector<char> newSegmentData;

  void run(Module* module_) override {
    module = module_;
    // array.new_data requires bulk memory.
    if (!module->features.hasGC() || !module->features.hasBulkMemory()) {
      return;
    }
    findCandidates();
    if (candidates.empty()) {
      return;
    }
    auto groups = groupByPayload();
    auto conversions = planConversions(groups);
    if (!newSegmentData.empty()) {
      addNewSegment();
    }
    applyConversions(conversions);
  }

  void findCandidates() {
    struct Info {
      std::vector<Candidate> candidates;
      std::unordered_set<Name> droppedSegments;
    };
    ModuleUtils::ParallelFunctionAnalysis<Info> analysis(
      *module, [](Function* func, Info& info) {
        if (func->imported()) {
          return;
        }
        for (auto** location :
             FindAllPointers<ArrayNewFixed>(func->body).list) {
          auto* array = (*location)->cast<ArrayNewFixed>();
          if (auto payload = getPayload(array)) {
            info.candidates.push_back(
              {func, array, location, std::move(*payload)});
          }
        }
        for (auto* drop : FindAll<DataDrop>(func->body).list) {
          info.droppedSegments.insert(drop->segment);
        }
      });

    // Gather the results in function order, so that the output is
    // deterministic.
    for (auto& func : module->functions) {
      auto& info = analysis.map[func.get()];
      for (auto& candidate : info.candidates) {
        candidates.push_back(std::move(candidate));
      }
      droppedSegments.insert(info.droppedSegments.begin(),
                             info.droppedSegments.end());
    }
  }

  std::vector<PayloadGroup> groupByPayload() {
    std::vector<PayloadGroup> groups;
    std::unordered_map<std::string_view, Index> groupIndexes;
    for (auto& candidate : candidates) {
      std::string_view payload(candidate.payload.data(),
                               candidate.payload.size());
      auto [it, inserted] = groupIndexes.insert({payload, groups.size()});
      if (inserted) {
        groups.push_back({payload, {}});
      }
      groups[it->second].candidates.push_back(&candidate);
    }
    return groups;
  }

  // Decides which payload groups to convert, and where their arrays read the
  // payload from: an existing segment with identical contents, or a new segment
  // whose contents we gather in |newSegmentData|.
  std::vector<Conversion> planConversions(std::vector<PayloadGroup>& groups) {
    auto reusableSegments = getReusableSegments();
    // If we add a new segment, it goes at the end.
    Index newSegmentIndex = module->dataSegments.size();
    int64_t newSegmentSavings = 0;
    std::vector<Conversion> conversions;
    for (auto& group : groups) {
      if (auto it = reusableSegments.find(group.payload);
          it != reusableSegments.end()) {
        // The segment is identical to the payload, so we read all of it.
        if (getCodeSavings(group, it->second, 0) > 0) {
          conversions.push_back({&group, it->second, 0});
        }
        continue;
      }
      Index offset = newSegmentData.size();
      auto savings = getCodeSavings(group, newSegmentIndex, offset) -
                     int64_t(group.payload.size());
      if (savings > 0) {
        newSegmentData.insert(
          newSegmentData.end(), group.payload.begin(), group.payload.end());
        newSegmentSavings += savings;
        conversions.push_back({&group, newSegmentIndex, offset});
      }
    }

    // The overhead of the new segment is shared by all the payloads in it, so
    // only now can we check if it pays for itself. If it does not, we still
    // convert the groups that reuse existing segments.
    if (!newSegmentData.empty() &&
        newSegmentSavings <=
          int64_t(getNewSegmentOverhead(*module, newSegmentData.size()))) {
      newSegmentData.clear();
      std::erase_if(conversions, [&](const Conversion& conversion) {
        return conversion.segment == newSegmentIndex;
      });
    }
    return conversions;
  }

  // Returns the passive segments that are never dropped, by their contents (the
  // first one, if several are identical).
  std::unordered_map<std::string_view, Index> getReusableSegments() {
    std::unordered_map<std::string_view, Index> reusableSegments;
    for (Index i = 0; i < module->dataSegments.size(); i++) {
      auto& segment = module->dataSegments[i];
      if (segment->isPassive() && !droppedSegments.contains(segment->name)) {
        reusableSegments.insert(
          {std::string_view(segment->data.data(), segment->data.size()), i});
      }
    }
    return reusableSegments;
  }

  // The bytes saved in the code if the group's arrays read their payload from
  // the given segment and offset. The arrays may have different types, so we
  // measure each one.
  int64_t
  getCodeSavings(const PayloadGroup& group, Index segment, Index offset) {
    int64_t savings = 0;
    for (auto* candidate : group.candidates) {
      auto* array = candidate->array;
      savings +=
        int64_t(getArrayNewFixedSize(array)) -
        int64_t(getArrayNewDataSize(segment, offset, array->values.size()));
    }
    return savings;
  }

  void addNewSegment() {
    auto name = Names::getValidDataSegmentName(*module, "constant-array-data");
    // Without a memory and an offset, the segment is passive.
    module->addDataSegment(Builder::makeDataSegment(
      name, Name(), nullptr, newSegmentData.data(), newSegmentData.size()));
  }

  // Replaces the arrays with array.new_data. That cannot trap, as it reads in
  // bounds from a segment that is never dropped.
  void applyConversions(const std::vector<Conversion>& conversions) {
    Builder builder(*module);
    for (auto& conversion : conversions) {
      auto segment = module->dataSegments[conversion.segment]->name;
      for (auto* candidate : conversion.group->candidates) {
        auto* array = candidate->array;
        auto* replacement = builder.makeArrayNewData(
          array->type.getHeapType(),
          segment,
          builder.makeConst(int32_t(conversion.offset)),
          builder.makeConst(int32_t(array->values.size())));
        assert(replacement->type == array->type);
        debuginfo::copyOriginalToReplacement(
          array, replacement, candidate->func);
        *candidate->location = replacement;
      }
    }
  }
};

} // anonymous namespace

Pass* createConstantArraysToDataPass() { return new ConstantArraysToData(); }

} // namespace wasm
