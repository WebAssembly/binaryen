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
// Merges adjacent active data segments into a single data segment. The name of
// the merged segment is the name of the input segment with the lowest offset.
// If the memory is known to be zero-initialized, we can also merge
// near-adjacent data segments according to a size heuristic. We must be careful
// to flush all merged segments for a memory before adding a segment of
// non-constant offset. Unless TNH is enabled, we must also be careful to flush
// all merged segments for all memories before adding a segment that may cause
// an out-of-bounds trap.
//

#include "pass.h"
#include "support/stdckdint.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// The maximum size possible for a single data segment.
constexpr size_t MAX_SEG_SIZE = std::numeric_limits<int32_t>::max();

struct SegmentEntry {
  Address start;
  Name name;
  mutable std::vector<char> data;
  Address end() const { return start + data.size(); }

  struct CompareStart {
    using is_transparent = void;

    bool operator()(const SegmentEntry& lhs, const SegmentEntry& rhs) const {
      return lhs.start < rhs.start;
    }

    bool operator()(const SegmentEntry& lhs, Address rhs) const {
      return lhs.start < rhs;
    }

    bool operator()(Address lhs, const SegmentEntry& rhs) const {
      return lhs < rhs.start;
    }
  };

  // Check if we can merge this entry while respecting MAX_SEG_SIZE.
  bool canMergeInto(std::set<SegmentEntry, CompareStart>& map) const {
    if (data.empty()) {
      return true;
    }

    size_t mergedSize = data.size();
    auto it = map.upper_bound(start);
    if (it != map.begin()) {
      --it;
      if (start <= it->end()) {
        mergedSize += start - it->start;
      }
    }
    it = map.upper_bound(end());
    if (it != map.begin()) {
      --it;
      if (end() <= it->end()) {
        mergedSize += it->end() - end();
      }
    }

    return mergedSize <= MAX_SEG_SIZE;
  }

  // Simple merge algorithm, joining together adjacent entries.
  void mergeInto(std::set<SegmentEntry, CompareStart>& map) const {
    if (data.empty()) {
      return;
    }

    // If there exists an overlapping or adjacent entry before the new entry,
    // then subsume the new entry into the old entry. Otherwise, simply add the
    // new entry to the map.
    auto it = map.upper_bound(start);
    auto merged = it;
    if (it != map.begin()) {
      --merged;
      if (start <= merged->end()) {
        auto head = start - merged->start;
        auto tail = merged->data.size() - head;
        // Copy all bytes up to the old entry's size, then append any remaining
        // bytes.
        if (data.size() <= tail) {
          std::copy(data.begin(), data.end(), merged->data.begin() + head);
        } else {
          std::copy(
            data.begin(), data.begin() + tail, merged->data.begin() + head);
          merged->data.insert(
            merged->data.end(), data.begin() + tail, data.end());
        }
      } else {
        merged = map.emplace_hint(it, *this);
      }
    } else {
      merged = map.emplace_hint(it, *this);
    }

    // Subsume any further overlapping or adjacent entries into the merged
    // entry.
    while (it != map.end() && it->start <= merged->end()) {
      if (merged->end() < it->end()) {
        merged->data.insert(merged->data.end(),
                            it->data.begin() + (merged->end() - it->start),
                            it->data.end());
      }
      it = map.erase(it);
    }
  }
};

using SegmentMap = std::set<SegmentEntry, SegmentEntry::CompareStart>;

// Bytes needed to represent a nonnegative integer in the signed LEB encoding.
size_t lebSize(uint64_t x) { return (std::bit_width(x) + 7) / 7; }

enum InBounds { No, Maybe, Yes };

struct MergeInfo {
  Memory* mem;
  Address knownSize;
  SegmentMap flushedSegments;
  SegmentMap newSegments;
  bool zeroFilled;

  // Determine whether the initialization of a new data segment can possibly
  // succeed, and update the known size of the memory accordingly. If this
  // method returns No, then initializing the data segment will invariably
  // result in a trap during instantiation. This method should return Maybe or
  // Yes before the segment is added to a SegmentMap, otherwise address
  // overflows could occur in the merge algorithm.
  InBounds inBounds(const Literal& offset, size_t size) {
    if (offset.isNegative() || size > MAX_SEG_SIZE) {
      return InBounds::No;
    }
    uint64_t end;
    if (std::ckd_add(&end, offset.getUnsigned(), size)) {
      return InBounds::No;
    }
    if (end == 0) {
      return InBounds::Yes;
    }

    auto neededSize = ((end - 1) >> mem->pageSizeLog2) + 1;
    if (neededSize <= knownSize) {
      return InBounds::Yes;
    } else if (!mem->imported() || (mem->hasMax() && neededSize > mem->max)) {
      return InBounds::No;
    } else {
      knownSize = neededSize;
      return InBounds::Maybe;
    }
  }

  // Retrieve a range of backing data from flushedSegments. Returns true if all
  // bytes could be retrieved without any gaps.
  bool flushedData(std::vector<char>& dest, Address start, size_t size) {
    dest.clear();
    dest.reserve(size);
    Address end = start + size;

    auto it = flushedSegments.upper_bound(start);
    if (it != flushedSegments.begin()) {
      auto preIt = it;
      --preIt;
      if (start < it->end()) {
        if (end <= it->end()) {
          dest.assign(it->data.begin() + (start - it->start),
                      it->data.begin() + (end - it->start));
          return true;
        }
        dest.assign(it->data.begin() + (start - it->start), it->data.end());
      }
    }

    while (it != flushedSegments.end()) {
      if (dest.size() < it->start - start) {
        if (!zeroFilled) {
          return false;
        }
        dest.resize(dest.size() + (it->start - start));
      }
      if (end <= it->end()) {
        dest.insert(
          dest.end(), it->data.begin(), it->data.begin() + (end - it->start));
        return true;
      }
      dest.insert(dest.end(), it->data.begin(), it->data.end());
      ++it;
    }

    if (!zeroFilled) {
      return false;
    }
    dest.resize(size);
    return true;
  }

  // Merge near-adjacent entries in newSegments according to a size heuristic.
  void mergeNearAdjacent() {
    if (newSegments.size() < 2) {
      return;
    }
    // Pessimistically assume that all data segments use the implicit memory 0
    // encoding. Then, the total size of a data segment is 3 + lebSize(offset) +
    // lebSize(size) + size. We greedily attempt to merge segments in a single
    // pass from lower to higher addresses.
    auto left = newSegments.begin();
    auto right = left;
    ++right;
    std::vector<char> gapData;
    while (right != newSegments.end()) {
      uint64_t leftSize = left->data.size();
      uint64_t rightSize = right->data.size();
      uint64_t gapSize = right->start - left->end();
      uint64_t mergedSize = leftSize + gapSize + rightSize;
      if (mergedSize > MAX_SEG_SIZE) {
        left = right++;
        continue;
      }

      size_t leftSegSize =
        3 + lebSize(left->start) + lebSize(leftSize) + leftSize;
      size_t rightSegSize =
        3 + lebSize(right->start) + lebSize(rightSize) + rightSize;
      size_t mergedSegSize =
        3 + lebSize(left->start) + lebSize(mergedSize) + mergedSize;
      if (leftSegSize + rightSegSize < mergedSegSize) {
        left = right++;
        continue;
      }
      if (!flushedData(gapData, left->end(), gapSize)) {
        left = right++;
        continue;
      }

      left->data.insert(left->data.end(), gapData.begin(), gapData.end());
      left->data.insert(
        left->data.end(), right->data.begin(), right->data.end());
      right = newSegments.erase(right);
    }
  }

  void flushBoundsCheck(Module* module,
                        std::optional<Name>& boundsCheckSeg,
                        bool clearFlushed) {
    // Flush the first merged segment that overlaps the last known page, so that
    // we hit the bounds check before adding any other segments.
    assert(knownSize != 0);
    Address lastPageStart = (knownSize - 1) << mem->pageSizeLog2;
    auto it = newSegments.upper_bound(lastPageStart);
    bool hasEntry = false;
    SegmentEntry entry;
    if (it != newSegments.begin()) {
      auto preIt = it;
      --preIt;
      if (lastPageStart < preIt->end()) {
        hasEntry = true;
        entry = std::move(newSegments.extract(preIt).value());
      }
    }
    if (!hasEntry && it != newSegments.end()) {
      hasEntry = true;
      entry = std::move(newSegments.extract(it).value());
    }
    if (hasEntry && !clearFlushed) {
      entry.mergeInto(flushedSegments);
    }
    // If the last known page has no nonempty segments, synthesize a new empty
    // segment.
    if (!hasEntry) {
      assert(boundsCheckSeg);
      entry.start = lastPageStart + 1;
      entry.name = *boundsCheckSeg;
      boundsCheckSeg.reset();
    }
    flushEntry(module, std::move(entry));
  }

  void flush(Module* module, bool clearFlushed) {
    // If the flush is triggered by a segment of non-constant offset, clear all
    // previous data.
    if (clearFlushed) {
      flushedSegments.clear();
    } else {
      for (const auto& seg : newSegments) {
        seg.mergeInto(flushedSegments);
      }
    }
    // Flush merged segments to the module in order.
    while (!newSegments.empty()) {
      flushEntry(module,
                 std::move(newSegments.extract(newSegments.begin()).value()));
    }
  }

  void flushEntry(Module* module, SegmentEntry&& entry) {
    // Finish flushing an entry into a data segment in the underlying module.
    auto* c = Builder(*module).makeConst(
      Literal::makeFromInt64(entry.start, mem->addressType));
    auto seg = Builder::makeDataSegment(entry.name, mem->name, false, c);
    seg->data = std::move(entry.data);
    module->dataSegments.push_back(std::move(seg));
  }
};

void flushAll(Module* module,
              std::unordered_map<Name, MergeInfo>& infos,
              std::optional<Name>& boundsCheckMem,
              std::optional<Name>& boundsCheckSeg,
              std::optional<Name> clearFlushedMem) {
  for (const auto& mem : module->memories) {
    infos[mem->name].mergeNearAdjacent();
  }
  if (boundsCheckMem) {
    infos[*boundsCheckMem].flushBoundsCheck(
      module, boundsCheckSeg, boundsCheckMem == clearFlushedMem);
    boundsCheckMem.reset();
  }
  for (const auto& mem : module->memories) {
    infos[mem->name].flush(module, mem->name == clearFlushedMem);
  }
}

} // namespace

struct MergeDataSegments : public Pass {
  // This pass only modifies data segments and data-segment indices.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    bool trapsNeverHappen = getPassOptions().trapsNeverHappen;
    bool zeroFilledMemory = getPassOptions().zeroFilledMemory;

    if (module->dataSegments.empty()) {
      return;
    }

    // Initialize the MergeInfo list with each memory in the module.
    std::unordered_map<Name, MergeInfo> infos;
    for (const auto& mem : module->memories) {
      auto& info = infos[mem->name];
      info.mem = mem.get();
      info.knownSize = mem->initial;
      info.zeroFilled = zeroFilledMemory || !mem->imported();
    }

    std::vector<std::unique_ptr<DataSegment>> oldSegments;
    module->dataSegments.swap(oldSegments);

    // To avoid changing observable behavior, we flush all existing data before
    // adding a new data segment that may be out-of-bounds. Between flushes, we
    // use boundsCheckMem to lazily keep track of which memory last triggered a
    // bounds check, so that we can flush a corresponding bounds-check segment
    // before flushing any other data. If an empty segment triggers a bounds
    // check, then it will not show up in boundsCheckMem, so we keep track of
    // its name in boundsCheckSeg in case we need to synthesize it again.
    std::optional<Name> boundsCheckMem = std::nullopt;
    std::optional<Name> boundsCheckSeg = std::nullopt;
    // We also keep track of the activeNames so that we can rename active
    // segments referred to by instructions, and retain an emptySegment in case
    // we need a name but no nonempty active segments are left.
    std::unordered_set<Name> activeNames;
    std::unique_ptr<DataSegment> emptySegment = nullptr;
    // If a segment is guaranteed to cause an out-of-bounds trap, then we flush
    // all prior segments, copy it verbatim, then drop all remaining segments.
    std::unique_ptr<DataSegment> trapSegment = nullptr;

    for (auto& seg : oldSegments) {
      if (seg->isPassive) {
        module->dataSegments.push_back(std::move(seg));
        continue;
      }
      activeNames.insert(seg->name);
      auto& info = infos[seg->memory];

      if (auto* c = seg->offset->dynCast<Const>()) {
        auto inBounds = info.inBounds(c->value, seg->data.size());
        if (inBounds == InBounds::No) {
          trapSegment = std::move(seg);
          break;
        }

        SegmentEntry entry;
        entry.start = c->value.getUnsigned();
        entry.name = seg->name;
        if (!seg->data.empty()) {
          entry.data = std::move(seg->data);
        } else if (!emptySegment) {
          emptySegment = std::move(seg);
        }

        // If a constant-offset segment is statically in-bounds, we simply merge
        // it into its appropriate memory; otherwise, we flush all memories,
        // then mark its segment as needing a bounds check next flush.
        if (!trapsNeverHappen && inBounds != InBounds::Yes) {
          flushAll(module, infos, boundsCheckMem, boundsCheckSeg, std::nullopt);
          boundsCheckMem = info.mem->name;
          boundsCheckSeg = entry.name;
        }

        // As a special fallback, flush the memory early if the merged segment
        // would not respect MAX_SEG_SIZE.
        if (!entry.canMergeInto(info.newSegments)) {
          if (boundsCheckMem) {
            infos[*boundsCheckMem].mergeNearAdjacent();
            infos[*boundsCheckMem].flushBoundsCheck(
              module, boundsCheckSeg, boundsCheckMem == seg->memory);
            boundsCheckMem.reset();
          }
          info.mergeNearAdjacent();
          info.flush(module, false);
        }

        entry.mergeInto(info.newSegments);
      } else {
        if (!seg->data.empty()) {
          // A nonempty non-constant-offset segment always flushes its own
          // memory and invalidates all previous data. Unless TNH is enabled, it
          // also requires all other memories to be flushed due to the bounds
          // check.
          if (trapsNeverHappen) {
            if (boundsCheckMem) {
              infos[*boundsCheckMem].mergeNearAdjacent();
              infos[*boundsCheckMem].flushBoundsCheck(
                module, boundsCheckSeg, boundsCheckMem == seg->memory);
              boundsCheckMem.reset();
            }
            info.mergeNearAdjacent();
            info.flush(module, true);
          } else {
            flushAll(
              module, infos, boundsCheckMem, boundsCheckSeg, seg->memory);
          }
          info.zeroFilled = false;
        } else {
          // An empty non-constant-offset segment only triggers a bounds check.
          if (!trapsNeverHappen) {
            flushAll(
              module, infos, boundsCheckMem, boundsCheckSeg, std::nullopt);
          }
        }

        // For the bounds check, we conservatively assume that the offset is 0.
        auto zero = Literal::makeZero(info.mem->addressType);
        if (info.inBounds(zero, seg->data.size()) == InBounds::No) {
          trapSegment = std::move(seg);
          break;
        }
        module->dataSegments.push_back(std::move(seg));
      }
    }

    // If there were no active segments in the input, then we have no more work
    // to do after regenerating the module's map.
    if (activeNames.empty()) {
      module->updateDataSegmentsMap();
      return;
    }

    // Flush all remaining segments, then copy any trap segment.
    flushAll(module, infos, boundsCheckMem, boundsCheckSeg, std::nullopt);
    if (trapSegment) {
      module->dataSegments.push_back(std::move(trapSegment));
    }
    module->updateDataSegmentsMap();

    // Determine a destination segment for any instructions that refer to an
    // active segment. If there are no active segments left in the output, then
    // there must have been some empty active segment in the input, which we
    // have retained in emptySegment.
    std::optional<Name> firstActive = std::nullopt;
    for (const auto& seg : module->dataSegments) {
      if (!seg->isPassive) {
        firstActive = seg->name;
        break;
      }
    }
    assert(firstActive || emptySegment);
    Name destName = firstActive ? *firstActive : emptySegment->name;

    struct ActiveSegmentRenamer
      : public WalkerPass<PostWalker<ActiveSegmentRenamer>> {
      // This pass only modifies data-segment indices.
      bool requiresNonNullableLocalFixups() override { return false; }

      std::unordered_set<Name> srcNames;
      Name destName;
      bool destUsed = false;

      ActiveSegmentRenamer(std::unordered_set<Name> srcNames, Name destName)
        : srcNames(std::move(srcNames)), destName(destName) {}

      void visitMemoryInit(MemoryInit* curr) {
        if (srcNames.contains(curr->segment)) {
          curr->segment = destName;
          destUsed = true;
        }
      }

      void visitDataDrop(DataDrop* curr) {
        if (srcNames.contains(curr->segment)) {
          curr->segment = destName;
          destUsed = true;
        }
      }

      void visitArrayNewData(ArrayNewData* curr) {
        if (srcNames.contains(curr->segment)) {
          curr->segment = destName;
          destUsed = true;
        }
      }

      void visitArrayInitData(ArrayInitData* curr) {
        if (srcNames.contains(curr->segment)) {
          curr->segment = destName;
          destUsed = true;
        }
      }
    };

    // Replace the names, then actually add the empty segment if needed.
    ActiveSegmentRenamer renamer(std::move(activeNames), destName);
    renamer.run(getPassRunner(), module);
    renamer.runOnModuleCode(getPassRunner(), module);
    if (renamer.destUsed && !firstActive) {
      module->dataSegments.push_back(std::move(emptySegment));
      module->updateDataSegmentsMap();
    }
  }
};

Pass* createMergeDataSegmentsPass() { return new MergeDataSegments(); }

} // namespace wasm
