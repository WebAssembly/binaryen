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

// Size estimates for the binary format.

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

// Returns the bytes the array would have in a data segment, if its values are
// numeric constants.
std::optional<std::vector<char>> getPayload(ArrayNewFixed* curr) {
  if (curr->type == Type::unreachable || curr->values.empty()) {
    return std::nullopt;
  }
  const auto& element = curr->type.getHeapType().getArray().element;
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
  Expression** location;
  std::vector<char> payload;

  ArrayNewFixed* get() const { return (*location)->cast<ArrayNewFixed>(); }
};

// Candidates with identical payloads, which can share their bytes.
struct Group {
  std::string_view payload;
  std::vector<Candidate*> candidates;
};

// A group to convert, and where its arrays read their payload from.
struct Decision {
  Group* group;
  Index segment;
  Index offset;
};

struct ConstantArraysToData : public Pass {
  // We only replace allocations with other allocations of the same type.
  bool requiresNonNullableLocalFixups() override { return false; }

  Module* module = nullptr;

  // All the candidates, in a deterministic order.
  std::vector<Candidate> candidates;

  // Segments that are dropped somewhere, which we cannot reuse.
  std::unordered_set<Name> droppedSegments;

  void run(Module* module_) override {
    module = module_;
    if (!module->features.hasGC() || !module->features.hasBulkMemory()) {
      return;
    }
    findCandidates();
    if (candidates.empty()) {
      return;
    }
    auto groups = groupByPayload();
    replace(decide(groups));
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
          if (auto payload = getPayload((*location)->cast<ArrayNewFixed>())) {
            info.candidates.push_back({func, location, std::move(*payload)});
          }
        }
        for (auto* drop : FindAll<DataDrop>(func->body).list) {
          info.droppedSegments.insert(drop->segment);
        }
      });

    for (auto& func : module->functions) {
      auto& info = analysis.map[func.get()];
      for (auto& candidate : info.candidates) {
        candidates.push_back(std::move(candidate));
      }
      droppedSegments.insert(info.droppedSegments.begin(),
                             info.droppedSegments.end());
    }
  }

  std::vector<Group> groupByPayload() {
    std::vector<Group> groups;
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

  // Returns the segments that identical payloads can reuse, by their contents.
  std::unordered_map<std::string_view, Index> getReusableSegments() {
    std::unordered_map<std::string_view, Index> reusable;
    for (Index i = 0; i < module->dataSegments.size(); i++) {
      auto& segment = module->dataSegments[i];
      if (segment->isPassive() && !droppedSegments.contains(segment->name)) {
        reusable.insert(
          {std::string_view(segment->data.data(), segment->data.size()), i});
      }
    }
    return reusable;
  }

  // The bytes saved in the code if the group's arrays read their payload from
  // the given segment and offset.
  int64_t getCodeSavings(const Group& group, Index segment, Index offset) {
    int64_t savings = 0;
    for (auto* candidate : group.candidates) {
      auto* curr = candidate->get();
      savings +=
        int64_t(getArrayNewFixedSize(curr)) -
        int64_t(getArrayNewDataSize(segment, offset, curr->values.size()));
    }
    return savings;
  }

  // Decides which groups to convert and where they read their payloads from,
  // and adds a new segment for the payloads that are not present yet, if that
  // is worth it.
  std::vector<Decision> decide(std::vector<Group>& groups) {
    auto reusable = getReusableSegments();
    Index newSegment = module->dataSegments.size();
    std::vector<char> newData;
    int64_t newSegmentSavings = 0;
    std::vector<Decision> decisions;
    for (auto& group : groups) {
      if (auto it = reusable.find(group.payload); it != reusable.end()) {
        if (getCodeSavings(group, it->second, 0) > 0) {
          decisions.push_back({&group, it->second, 0});
        }
        continue;
      }
      Index offset = newData.size();
      auto savings = getCodeSavings(group, newSegment, offset) -
                     int64_t(group.payload.size());
      if (savings > 0) {
        newData.insert(
          newData.end(), group.payload.begin(), group.payload.end());
        newSegmentSavings += savings;
        decisions.push_back({&group, newSegment, offset});
      }
    }

    if (newData.empty()) {
      return decisions;
    }
    if (newSegmentSavings >
        int64_t(getNewSegmentOverhead(*module, newData.size()))) {
      addSegment(newData);
    } else {
      std::erase_if(decisions, [&](const Decision& decision) {
        return decision.segment == newSegment;
      });
    }
    return decisions;
  }

  void addSegment(const std::vector<char>& data) {
    auto name = Names::getValidDataSegmentName(*module, "constant-array-data");
    module->addDataSegment(Builder::makeDataSegment(
      name, Name(), nullptr, data.data(), data.size()));
  }

  void replace(const std::vector<Decision>& decisions) {
    Builder builder(*module);
    for (auto& decision : decisions) {
      auto segment = module->dataSegments[decision.segment]->name;
      for (auto* candidate : decision.group->candidates) {
        auto* curr = candidate->get();
        auto* replacement = builder.makeArrayNewData(
          curr->type.getHeapType(),
          segment,
          builder.makeConst(int32_t(decision.offset)),
          builder.makeConst(int32_t(curr->values.size())));
        assert(replacement->type == curr->type);
        debuginfo::copyOriginalToReplacement(
          curr, replacement, candidate->func);
        *candidate->location = replacement;
      }
    }
  }
};

} // anonymous namespace

Pass* createConstantArraysToDataPass() { return new ConstantArraysToData(); }

} // namespace wasm
