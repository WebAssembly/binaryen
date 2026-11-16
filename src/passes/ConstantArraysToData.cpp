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
// Arrays with identical payloads share one copy of the bytes, from an existing
// passive segment with identical contents that is never dropped, or else from a
// new segment. Each payload gets its own new segment, so that if its arrays are
// lowered to array.new_fixed and converted again later (e.g. with --converge),
// they reuse that segment rather than duplicate it. A payload is converted if
// that reduces the estimated binary size, including the size of its segment.
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
#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "support/insert_ordered.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
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

// The size of an array.new_data that reads all of a segment, apart from the
// prefix, opcode and type index.
size_t getArrayNewDataSize(Index segment, Index size) {
  // The segment index, an i32.const 0 for the offset (2 bytes), and an
  // i32.const for the size.
  return getWrittenSize(U32LEB(segment)) + 2 +
         getConstSize(Literal(int32_t(size)));
}

// The size of a new passive data segment with the given amount of data.
size_t getNewSegmentSize(const Module& wasm, size_t dataSize) {
  // The flags, the size of the data, and the data itself.
  size_t size = 1 + getWrittenSize(U32LEB(dataSize)) + dataSize;
  if (wasm.dataSegments.empty()) {
    // The first segment also adds the data count and data sections, each with
    // an id, a size and a count.
    size += 2 * 3;
  }
  return size;
}

// Candidates for conversion.

// Returns a view of the bytes, to use them as a key in an unordered map
// (std::hash supports views of strings, but not vectors).
std::string_view getView(const std::vector<char>& bytes) {
  return std::string_view(bytes.data(), bytes.size());
}

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
  // Where the array.new_fixed is.
  Expression** location;
  std::vector<char> payload;
};

// Candidates with identical payloads, which can share one copy of the bytes.
struct PayloadGroup {
  std::vector<Candidate*> candidates;

  const std::vector<char>& getPayload() const { return candidates[0]->payload; }
};

struct ConstantArraysToData : public Pass {
  // We only replace allocations with other allocations of the same type.
  bool requiresNonNullableLocalFixups() override { return false; }

  Module* wasm = nullptr;

  // All the candidates, in a deterministic order. Payload groups point into
  // them, so they must not change after grouping.
  std::vector<Candidate> candidates;

  // Segments that are dropped somewhere. We cannot reuse them, as
  // array.new_data traps once its segment is dropped (unless it reads nothing).
  std::unordered_set<Name> droppedSegments;

  void run(Module* module) override {
    wasm = module;
    // array.new_data requires bulk memory.
    if (!wasm->features.hasGC() || !wasm->features.hasBulkMemory()) {
      return;
    }
    findCandidates();
    if (candidates.empty()) {
      return;
    }
    auto groups = groupByPayload();
    convert(groups);
  }

  void findCandidates() {
    struct Info {
      std::vector<Candidate> candidates;
      std::unordered_set<Name> droppedSegments;
    };

    struct Finder : public PostWalker<Finder> {
      Info& info;

      Finder(Info& info) : info(info) {}

      void visitArrayNewFixed(ArrayNewFixed* curr) {
        if (auto payload = getPayload(curr)) {
          info.candidates.push_back(
            {getFunction(), getCurrentPointer(), std::move(*payload)});
        }
      }

      void visitDataDrop(DataDrop* curr) {
        info.droppedSegments.insert(curr->segment);
      }
    };

    ModuleUtils::ParallelFunctionAnalysis<Info, Immutable, InsertOrderedMap>
      analysis(*wasm, [](Function* func, Info& info) {
        if (!func->imported()) {
          Finder(info).walkFunction(func);
        }
      });

    // The map is in function order (see ParallelFunctionAnalysis), so this
    // order is deterministic.
    for (auto& [func, info] : analysis.map) {
      for (auto& candidate : info.candidates) {
        candidates.push_back(std::move(candidate));
      }
      droppedSegments.insert(info.droppedSegments.begin(),
                             info.droppedSegments.end());
    }
  }

  std::vector<PayloadGroup> groupByPayload() {
    std::vector<PayloadGroup> groups;
    // The keys are views of the candidates' payloads.
    std::unordered_map<std::string_view, Index> groupIndexes;
    for (auto& candidate : candidates) {
      auto [it, inserted] =
        groupIndexes.insert({getView(candidate.payload), groups.size()});
      if (inserted) {
        groups.emplace_back();
      }
      groups[it->second].candidates.push_back(&candidate);
    }
    return groups;
  }

  // Converts the arrays of each payload group to read from an existing segment
  // with identical contents, or else from a new segment, if that is smaller.
  void convert(std::vector<PayloadGroup>& groups) {
    auto reusableSegments = getReusableSegments();
    for (auto& group : groups) {
      const auto& payload = group.getPayload();
      if (auto it = reusableSegments.find(getView(payload));
          it != reusableSegments.end()) {
        if (getCodeSavings(group, it->second) > 0) {
          replaceArrays(group, it->second);
        }
        continue;
      }
      // A new segment goes at the end. It is worth adding if the code shrinks
      // by more than the size of the segment.
      Index segment = wasm->dataSegments.size();
      if (getCodeSavings(group, segment) >
          int64_t(getNewSegmentSize(*wasm, payload.size()))) {
        addSegment(payload);
        replaceArrays(group, segment);
      }
    }
  }

  // Returns the passive segments that are never dropped, by their contents (the
  // first one, if several are identical). The keys are views of the segments'
  // data, which stays in place as we add more segments.
  std::unordered_map<std::string_view, Index> getReusableSegments() {
    std::unordered_map<std::string_view, Index> reusableSegments;
    for (Index i = 0; i < wasm->dataSegments.size(); i++) {
      auto& segment = wasm->dataSegments[i];
      if (segment->isPassive() && !droppedSegments.contains(segment->name)) {
        reusableSegments.insert({getView(segment->data), i});
      }
    }
    return reusableSegments;
  }

  // The bytes saved in the code if the group's arrays read from the segment.
  int64_t getCodeSavings(const PayloadGroup& group, Index segment) {
    // Arrays with identical payloads can differ in size: their element types
    // can differ (e.g. 8 i8s or 2 i32s), and so can the constants for packed
    // fields, where only the low bits matter (e.g. -1 and 255 in an i8 array).
    // So we measure each array.
    int64_t savings = 0;
    for (auto* candidate : group.candidates) {
      auto* array = (*candidate->location)->cast<ArrayNewFixed>();
      savings += int64_t(getArrayNewFixedSize(array)) -
                 int64_t(getArrayNewDataSize(segment, array->values.size()));
    }
    return savings;
  }

  void addSegment(const std::vector<char>& payload) {
    auto name = Names::getValidDataSegmentName(*wasm, "constant-array-data");
    // Without a memory and an offset, the segment is passive.
    wasm->addDataSegment(Builder::makeDataSegment(
      name, Name(), nullptr, payload.data(), payload.size()));
  }

  // Replaces the group's arrays with array.new_data of all of the segment. That
  // cannot trap, as the segment is never dropped.
  void replaceArrays(const PayloadGroup& group, Index segment) {
    Builder builder(*wasm);
    auto name = wasm->dataSegments[segment]->name;
    for (auto* candidate : group.candidates) {
      auto* array = (*candidate->location)->cast<ArrayNewFixed>();
      auto* replacement = builder.makeArrayNewData(
        array->type.getHeapType(),
        name,
        builder.makeConst(int32_t(0)),
        builder.makeConst(int32_t(array->values.size())));
      assert(replacement->type == array->type);
      debuginfo::copyOriginalToReplacement(array, replacement, candidate->func);
      *candidate->location = replacement;
    }
  }
};

} // anonymous namespace

Pass* createConstantArraysToDataPass() { return new ConstantArraysToData(); }

} // namespace wasm
