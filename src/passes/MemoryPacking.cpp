/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Memory Packing.
//
// Reduces binary size by splitting data segments around ranges of zeros. This
// pass assumes that memory initialized by active segments is zero on
// instantiation and therefore simply drops the zero ranges from the active
// segments. For passive segments, we perform the same splitting, but we also
// record how each segment was split and update all instructions that use it
// accordingly. To preserve trapping semantics for memory.init instructions, it
// is sometimes necessary to explicitly track whether input segments would have
// been dropped in globals. We are careful to emit only as many of these globals
// as necessary.
//

#include "ir/manipulation.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/space.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// A subsection of an orginal memory segment. If `isZero` is true, memory.fill
// will be used instead of memory.init for this range.
struct Range {
  bool isZero;
  size_t start;
  size_t end;
};

// A function that produces the transformed instruction. We need to use a
// function here instead of simple data because the replacement code sequence
// may require allocating new locals, which in turn requires the enclosing
// Function, which is only available in the parallelized instruction replacement
// phase. However, we can't move the entire calculation of replacement code
// sequences into the parallel phase because the lowering of data.drops depends
// on the lowering of memory.inits to determine whether a drop state global is
// necessary. The solution is that we calculate the shape of the replacement
// code sequence up front and use a closure just to allocate and insert new
// locals as necessary.
using Replacement = std::function<Expression*(Function*)>;

// Maps each instruction to the replacement that must be applied to it.
using Replacements = std::unordered_map<Expression*, Replacement>;

// A collection of instructions referring to a particular segment.
using Referrers = std::vector<Expression*>;

// Map segment indices to referrers.
using ReferrersMap = std::unordered_map<Index, Referrers>;

// memory.init: 2 byte opcode + 1 byte segment index + 1 byte memory index +
//              3 x 2 byte operands
const size_t MEMORY_INIT_SIZE = 10;

// memory.fill: 2 byte opcode + 1 byte memory index + 3 x 2 byte operands
const size_t MEMORY_FILL_SIZE = 9;

// data.drop: 2 byte opcode + ~1 byte index immediate
const size_t DATA_DROP_SIZE = 3;

Expression*
makeGtShiftedMemorySize(Builder& builder, Module& module, MemoryInit* curr) {
  auto mem = module.getMemory(curr->memory);
  return builder.makeBinary(
    mem->is64() ? GtUInt64 : GtUInt32,
    curr->dest,
    builder.makeBinary(mem->is64() ? ShlInt64 : ShlInt32,
                       builder.makeMemorySize(mem->name),
                       builder.makeConstPtr(16, mem->indexType)));
}

} // anonymous namespace

struct MemoryPacking : public Pass {
  // This pass operates on linear memory, and does not affect reference locals.
  // TODO: don't run at all if the module has no memories
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override;
  bool canOptimize(std::vector<std::unique_ptr<Memory>>& memories,
                   std::vector<std::unique_ptr<DataSegment>>& dataSegments);
  void optimizeSegmentOps(Module* module);
  void getSegmentReferrers(Module* module, ReferrersMap& referrers);
  void dropUnusedSegments(Module* module,
                          std::vector<std::unique_ptr<DataSegment>>& segments,
                          ReferrersMap& referrers);
  bool canSplit(const std::unique_ptr<DataSegment>& segment,
                const Referrers& referrers);
  void calculateRanges(const std::unique_ptr<DataSegment>& segment,
                       const Referrers& referrers,
                       std::vector<Range>& ranges);
  void createSplitSegments(Builder& builder,
                           const DataSegment* segment,
                           std::vector<Range>& ranges,
                           std::vector<std::unique_ptr<DataSegment>>& packed,
                           size_t segmentsRemaining);
  void createReplacements(Module* module,
                          const std::vector<Range>& ranges,
                          const Referrers& referrers,
                          Replacements& replacements,
                          const Index segmentIndex);
  void replaceSegmentOps(Module* module, Replacements& replacements);
};

void MemoryPacking::run(Module* module) {
  // Does not have multi-memories support
  if (!canOptimize(module->memories, module->dataSegments)) {
    return;
  }

  bool canHaveSegmentReferrers =
    module->features.hasBulkMemory() || module->features.hasGC();

  auto& segments = module->dataSegments;

  // For each segment, a list of instructions that refer to it
  ReferrersMap referrers;

  if (canHaveSegmentReferrers) {
    // Optimize out memory.inits and data.drops that can be entirely replaced
    // with other instruction sequences. This can increase the number of unused
    // segments that can be dropped entirely and allows later replacement
    // creation to make more assumptions about what these instructions will look
    // like, such as memory.inits not having both zero offset and size.
    optimizeSegmentOps(module);
    getSegmentReferrers(module, referrers);
    dropUnusedSegments(module, segments, referrers);
  }

  // The new, split memory segments
  std::vector<std::unique_ptr<DataSegment>> packed;

  Replacements replacements;
  Builder builder(*module);
  for (size_t origIndex = 0; origIndex < segments.size(); ++origIndex) {
    auto& segment = segments[origIndex];
    auto& currReferrers = referrers[origIndex];

    std::vector<Range> ranges;

    if (canSplit(segment, currReferrers)) {
      calculateRanges(segment, currReferrers, ranges);
    } else {
      // A single range covers the entire segment. Set isZero to false so the
      // original memory.init will be used even if segment is all zeroes.
      ranges.push_back({false, 0, segment->data.size()});
    }

    Index firstNewIndex = packed.size();
    size_t segmentsRemaining = segments.size() - origIndex;
    createSplitSegments(
      builder, segment.get(), ranges, packed, segmentsRemaining);
    createReplacements(
      module, ranges, currReferrers, replacements, firstNewIndex);
  }

  segments.swap(packed);
  module->updateDataSegmentsMap();

  if (canHaveSegmentReferrers) {
    replaceSegmentOps(module, replacements);
  }
}

bool MemoryPacking::canOptimize(
  std::vector<std::unique_ptr<Memory>>& memories,
  std::vector<std::unique_ptr<DataSegment>>& dataSegments) {
  if (memories.empty() || memories.size() > 1) {
    return false;
  }
  auto& memory = memories[0];
  // We must optimize under the assumption that memory has been initialized to
  // zero. That is the case for a memory declared in the module, but for a
  // memory that is imported, we must be told that it is zero-initialized.
  if (memory->imported() && !getPassOptions().zeroFilledMemory) {
    return false;
  }

  // One segment is always ok to optimize, as it does not have the potential
  // problems handled below.
  if (dataSegments.size() <= 1) {
    return true;
  }
  // Check if it is ok for us to optimize.
  Address maxAddress = 0;
  for (auto& segment : dataSegments) {
    if (!segment->isPassive) {
      auto* c = segment->offset->dynCast<Const>();
      // If an active segment has a non-constant offset, then what gets written
      // cannot be known until runtime. That is, the active segments are written
      // out at startup, in order, and one may trample the data of another, like
      //
      //  (data (i32.const 100) "a")
      //  (data (i32.const 100) "\00")
      //
      // It is *not* ok to optimize out the zero in the last segment, as it is
      // actually needed, it will zero out the "a" that was written earlier. And
      // if a segment has an imported offset,
      //
      //  (data (i32.const 100) "a")
      //  (data (global.get $x) "\00")
      //
      // then we can't tell if that last segment will end up overwriting or not.
      // The only case we can easily handle is if there is just a single
      // segment, which we handled earlier. (Note that that includes the main
      // case of having a non-constant offset, dynamic linking, in which we have
      // a single segment.)
      if (!c) {
        return false;
      }
      // Note the maximum address so far.
      maxAddress = std::max(
        maxAddress, Address(c->value.getUnsigned() + segment->data.size()));
    }
  }
  // All active segments have constant offsets, known at this time, so we may be
  // able to optimize, but must still check for the trampling problem mentioned
  // earlier.
  // TODO: optimize in the trampling case
  DisjointSpans space;
  for (auto& segment : dataSegments) {
    if (!segment->isPassive) {
      auto* c = segment->offset->cast<Const>();
      Address start = c->value.getUnsigned();
      DisjointSpans::Span span{start, start + segment->data.size()};
      if (space.addAndCheckOverlap(span)) {
        std::cerr << "warning: active memory segments have overlap, which "
                  << "prevents some optimizations.\n";
        return false;
      }
    }
  }
  return true;
}

bool MemoryPacking::canSplit(const std::unique_ptr<DataSegment>& segment,
                             const Referrers& referrers) {
  // Don't mess with segments related to llvm coverage tools such as
  // __llvm_covfun. There segments are expected/parsed by external downstream
  // tools (llvm-cov) so they need to be left intact.
  // See https://clang.llvm.org/docs/SourceBasedCodeCoverage.html
  if (segment->name.is() && segment->name.startsWith("__llvm")) {
    return false;
  }

  for (auto* referrer : referrers) {
    if (auto* curr = referrer->dynCast<MemoryInit>()) {
      if (segment->isPassive) {
        // Do not try to split if there is a nonconstant offset or size
        if (!curr->offset->is<Const>() || !curr->size->is<Const>()) {
          return false;
        }
      }
    } else if (referrer->is<ArrayNewSeg>()) {
      // TODO: Split segments referenced by array.new_data instructions.
      return false;
    }
  }

  // Active segments can only be split if they have constant offsets
  return segment->isPassive || segment->offset->is<Const>();
}

void MemoryPacking::calculateRanges(const std::unique_ptr<DataSegment>& segment,
                                    const Referrers& referrers,
                                    std::vector<Range>& ranges) {
  auto& data = segment->data;
  if (data.size() == 0) {
    return;
  }

  // Calculate initial zero and nonzero ranges
  size_t start = 0;
  while (start < data.size()) {
    size_t end = start;
    while (end < data.size() && data[end] == 0) {
      end++;
    }
    if (end > start) {
      ranges.push_back({true, start, end});
      start = end;
    }
    while (end < data.size() && data[end] != 0) {
      end++;
    }
    if (end > start) {
      ranges.push_back({false, start, end});
      start = end;
    }
  }

  // Calculate the number of consecutive zeroes for which splitting is
  // beneficial. This is an approximation that assumes all memory.inits cover an
  // entire segment and that all its arguments are constants. These assumptions
  // are true of all memory.inits generated by the tools.
  size_t threshold = 0;
  if (segment->isPassive) {
    // Passive segment metadata size
    threshold += 2;
    // Zeroes on the edge do not increase the number of segments or data.drops,
    // so their threshold is lower. The threshold for interior zeroes depends on
    // an estimate of the number of new memory.fill and data.drop instructions
    // splitting would introduce.
    size_t edgeThreshold = 0;
    for (auto* referrer : referrers) {
      if (referrer->is<MemoryInit>()) {
        // Splitting adds a new memory.fill and a new memory.init
        threshold += MEMORY_FILL_SIZE + MEMORY_INIT_SIZE;
        edgeThreshold += MEMORY_FILL_SIZE;
      } else {
        threshold += DATA_DROP_SIZE;
      }
    }

    // Merge edge zeroes if they are not worth splitting
    if (ranges.size() >= 2) {
      auto last = ranges.end() - 1;
      auto penultimate = ranges.end() - 2;
      if (last->isZero && last->end - last->start <= edgeThreshold) {
        penultimate->end = last->end;
        ranges.erase(last);
      }
    }
    if (ranges.size() >= 2) {
      auto first = ranges.begin();
      auto second = ranges.begin() + 1;
      if (first->isZero && first->end - first->start <= edgeThreshold) {
        second->start = first->start;
        ranges.erase(first);
      }
    }
  } else {
    // Legacy ballpark overhead of active segment with offset
    // TODO: Tune this
    threshold = 8;
  }

  // Merge ranges across small spans of zeroes
  std::vector<Range> mergedRanges = {ranges.front()};
  size_t i;
  for (i = 1; i < ranges.size() - 1; ++i) {
    auto left = mergedRanges.end() - 1;
    auto curr = ranges.begin() + i;
    auto right = ranges.begin() + i + 1;
    if (curr->isZero && curr->end - curr->start <= threshold) {
      left->end = right->end;
      ++i;
    } else {
      mergedRanges.push_back(*curr);
    }
  }
  // Add the final range if it hasn't already been merged in
  if (i < ranges.size()) {
    mergedRanges.push_back(ranges.back());
  }
  std::swap(ranges, mergedRanges);
}

void MemoryPacking::optimizeSegmentOps(Module* module) {
  struct Optimizer : WalkerPass<PostWalker<Optimizer>> {
    bool isFunctionParallel() override { return true; }

    // This operates on linear memory, and does not affect reference locals.
    bool requiresNonNullableLocalFixups() override { return false; }

    std::unique_ptr<Pass> create() override {
      return std::make_unique<Optimizer>();
    }

    bool needsRefinalizing;

    void visitMemoryInit(MemoryInit* curr) {
      Builder builder(*getModule());
      auto& segment = getModule()->dataSegments[curr->segment];
      size_t maxRuntimeSize = segment->isPassive ? segment->data.size() : 0;
      bool mustNop = false;
      bool mustTrap = false;
      auto* offset = curr->offset->dynCast<Const>();
      auto* size = curr->size->dynCast<Const>();
      if (offset && uint32_t(offset->value.geti32()) > maxRuntimeSize) {
        mustTrap = true;
      }
      if (size && uint32_t(size->value.geti32()) > maxRuntimeSize) {
        mustTrap = true;
      }
      if (offset && size) {
        uint64_t offsetVal(offset->value.geti32());
        uint64_t sizeVal(size->value.geti32());
        if (offsetVal + sizeVal > maxRuntimeSize) {
          mustTrap = true;
        } else if (offsetVal == 0 && sizeVal == 0) {
          mustNop = true;
        }
      }
      assert(!mustNop || !mustTrap);
      if (mustNop) {
        // Offset and size are 0, so just trap if dest > memory.size
        replaceCurrent(
          builder.makeIf(makeGtShiftedMemorySize(builder, *getModule(), curr),
                         builder.makeUnreachable()));
      } else if (mustTrap) {
        // Drop dest, offset, and size then trap
        replaceCurrent(builder.blockify(builder.makeDrop(curr->dest),
                                        builder.makeDrop(curr->offset),
                                        builder.makeDrop(curr->size),
                                        builder.makeUnreachable()));
        needsRefinalizing = true;
      } else if (!segment->isPassive) {
        // trap if (dest > memory.size | offset | size) != 0
        replaceCurrent(builder.makeIf(
          builder.makeBinary(
            OrInt32,
            makeGtShiftedMemorySize(builder, *getModule(), curr),
            builder.makeBinary(OrInt32, curr->offset, curr->size)),
          builder.makeUnreachable()));
      }
    }
    void visitDataDrop(DataDrop* curr) {
      if (!getModule()->dataSegments[curr->segment]->isPassive) {
        ExpressionManipulator::nop(curr);
      }
    }
    void doWalkFunction(Function* func) {
      needsRefinalizing = false;
      super::doWalkFunction(func);
      if (needsRefinalizing) {
        ReFinalize().walkFunctionInModule(func, getModule());
      }
    }
  } optimizer;
  optimizer.run(getPassRunner(), module);
}

void MemoryPacking::getSegmentReferrers(Module* module,
                                        ReferrersMap& referrers) {
  auto collectReferrers = [&](Function* func, ReferrersMap& referrers) {
    if (func->imported()) {
      return;
    }
    struct Collector : WalkerPass<PostWalker<Collector>> {
      ReferrersMap& referrers;
      Collector(ReferrersMap& referrers) : referrers(referrers) {}

      void visitMemoryInit(MemoryInit* curr) {
        referrers[curr->segment].push_back(curr);
      }
      void visitDataDrop(DataDrop* curr) {
        referrers[curr->segment].push_back(curr);
      }
      void visitArrayNewSeg(ArrayNewSeg* curr) {
        if (curr->op == NewData) {
          referrers[curr->segment].push_back(curr);
        }
      }
      void doWalkFunction(Function* func) {
        super::doWalkFunction(func);
      }
    } collector(referrers);
    collector.walkFunctionInModule(func, module);
  };
  ModuleUtils::ParallelFunctionAnalysis<ReferrersMap> analysis(
    *module, collectReferrers);
  for (auto& [_, funcReferrersMap] : analysis.map) {
    for (auto& [i, segReferrers] : funcReferrersMap) {
      referrers[i].insert(
        referrers[i].end(), segReferrers.begin(), segReferrers.end());
    }
  }
}

void MemoryPacking::dropUnusedSegments(
  Module* module,
  std::vector<std::unique_ptr<DataSegment>>& segments,
  ReferrersMap& referrers) {
  std::vector<std::unique_ptr<DataSegment>> usedSegments;
  ReferrersMap usedReferrers;
  // Remove segments that are never used
  // TODO: remove unused portions of partially used segments as well
  for (size_t i = 0; i < segments.size(); ++i) {
    bool used = false;
    auto referrersIt = referrers.find(i);
    bool hasReferrers = referrersIt != referrers.end();
    if (segments[i]->isPassive) {
      if (hasReferrers) {
        for (auto* referrer : referrersIt->second) {
          if (!referrer->is<DataDrop>()) {
            used = true;
            break;
          }
        }
      }
    } else {
      // Active segment.
      used = true;
    }
    if (used) {
      usedSegments.push_back(std::move(segments[i]));
      if (hasReferrers) {
        usedReferrers[usedSegments.size() - 1] = std::move(referrersIt->second);
      }
    } else if (hasReferrers) {
      // All referrers are data.drops. Make them nops.
      for (auto* referrer : referrersIt->second) {
        ExpressionManipulator::nop(referrer);
      }
    }
  }
  std::swap(segments, usedSegments);
  module->updateDataSegmentsMap();
  std::swap(referrers, usedReferrers);
}

void MemoryPacking::createSplitSegments(
  Builder& builder,
  const DataSegment* segment,
  std::vector<Range>& ranges,
  std::vector<std::unique_ptr<DataSegment>>& packed,
  size_t segmentsRemaining) {
  size_t segmentCount = 0;
  bool hasExplicitName = false;
  for (size_t i = 0; i < ranges.size(); ++i) {
    Range& range = ranges[i];
    if (range.isZero) {
      continue;
    }
    Expression* offset = nullptr;
    if (!segment->isPassive) {
      if (auto* c = segment->offset->dynCast<Const>()) {
        if (c->value.type == Type::i32) {
          offset = builder.makeConst(int32_t(c->value.geti32() + range.start));
        } else {
          assert(c->value.type == Type::i64);
          offset = builder.makeConst(int64_t(c->value.geti64() + range.start));
        }
      } else {
        assert(ranges.size() == 1);
        offset = segment->offset;
      }
    }
    if (WebLimitations::MaxDataSegments <= packed.size() + segmentsRemaining) {
      // Give up splitting and merge all remaining ranges except end zeroes
      auto lastNonzero = ranges.end() - 1;
      if (lastNonzero->isZero) {
        --lastNonzero;
      }
      range.end = lastNonzero->end;
      ranges.erase(ranges.begin() + i + 1, lastNonzero + 1);
    }
    Name name;
    if (segment->name.is()) {
      // Name the first range after the original segment and all following
      // ranges get numbered accordingly.  This means that for segments that
      // canot be split (segments that contains a single range) the input and
      // output segment have the same name.
      if (!segmentCount) {
        name = segment->name;
        hasExplicitName = segment->hasExplicitName;
      } else {
        name = segment->name.toString() + "." + std::to_string(segmentCount);
      }
      segmentCount++;
    }
    auto curr = Builder::makeDataSegment(name,
                                         segment->memory,
                                         segment->isPassive,
                                         offset,
                                         &segment->data[range.start],
                                         range.end - range.start);
    curr->hasExplicitName = hasExplicitName;
    packed.push_back(std::move(curr));
  }
}

void MemoryPacking::createReplacements(Module* module,
                                       const std::vector<Range>& ranges,
                                       const Referrers& referrers,
                                       Replacements& replacements,
                                       const Index segmentIndex) {
  // If there was no transformation, only update the indices
  if (ranges.size() == 1 && !ranges.front().isZero) {
    for (auto referrer : referrers) {
      replacements[referrer] = [referrer, segmentIndex](Function*) {
        if (auto* curr = referrer->dynCast<MemoryInit>()) {
          curr->segment = segmentIndex;
        } else if (auto* curr = referrer->dynCast<DataDrop>()) {
          curr->segment = segmentIndex;
        } else if (auto* curr = referrer->dynCast<ArrayNewSeg>()) {
          curr->segment = segmentIndex;
        } else {
          WASM_UNREACHABLE("Unexpected segment operation");
        }
        return referrer;
      };
    }
    return;
  }

  Builder builder(*module);

  Name dropStateGlobal;

  // Return the drop state global, initializing it if it does not exist. This
  // may change module-global state and has the important side effect of setting
  // dropStateGlobal, so it must be evaluated eagerly, not in the replacements.
  auto getDropStateGlobal = [&]() {
    if (dropStateGlobal != Name()) {
      return dropStateGlobal;
    }
    dropStateGlobal =
      Names::getValidGlobalName(*module, "__mem_segment_drop_state");
    module->addGlobal(builder.makeGlobal(dropStateGlobal,
                                         Type::i32,
                                         builder.makeConst(int32_t(0)),
                                         Builder::Mutable));
    return dropStateGlobal;
  };

  // Create replacements for memory.init instructions first
  for (auto referrer : referrers) {
    auto* init = referrer->dynCast<MemoryInit>();
    if (init == nullptr) {
      continue;
    }

    // Nonconstant offsets or sizes will have inhibited splitting
    size_t start = init->offset->cast<Const>()->value.geti32();
    size_t end = start + init->size->cast<Const>()->value.geti32();

    // Segment index used in emitted memory.init instructions
    size_t initIndex = segmentIndex;

    // Index of the range from which this memory.init starts reading
    size_t firstRangeIdx = 0;
    while (firstRangeIdx < ranges.size() &&
           ranges[firstRangeIdx].end <= start) {
      if (!ranges[firstRangeIdx].isZero) {
        ++initIndex;
      }
      ++firstRangeIdx;
    }

    // Handle zero-length memory.inits separately so we can later assume that
    // start is in bounds and that some range will be intersected.
    if (start == end) {
      // Offset is nonzero because init would otherwise have previously been
      // optimized out, so trap if the dest is out of bounds or the segment is
      // dropped
      Expression* result = builder.makeIf(
        builder.makeBinary(
          OrInt32,
          makeGtShiftedMemorySize(builder, *module, init),
          builder.makeGlobalGet(getDropStateGlobal(), Type::i32)),
        builder.makeUnreachable());
      replacements[init] = [result](Function*) { return result; };
      continue;
    }

    assert(firstRangeIdx < ranges.size());

    // Split init into multiple memory.inits and memory.fills, storing the
    // original base destination in a local if it is not a constant. If the
    // first access is a memory.fill, explicitly check the drop status first to
    // avoid writing zeroes when we should have trapped.
    Expression* result = nullptr;
    auto appendResult = [&](Expression* expr) {
      result = result ? builder.blockify(result, expr) : expr;
    };

    // The local var holding the dest is not known until replacement time. Keep
    // track of the locations where it will need to be patched in.
    Index* setVar = nullptr;
    std::vector<Index*> getVars;
    if (!init->dest->is<Const>()) {
      auto set = builder.makeLocalSet(-1, init->dest);
      setVar = &set->index;
      appendResult(set);
    }

    // We only need to explicitly check the drop state when we will emit
    // memory.fill first, since memory.init will implicitly do the check for us.
    if (ranges[firstRangeIdx].isZero) {
      appendResult(
        builder.makeIf(builder.makeGlobalGet(getDropStateGlobal(), Type::i32),
                       builder.makeUnreachable()));
    }

    size_t bytesWritten = 0;

    for (size_t i = firstRangeIdx; i < ranges.size() && ranges[i].start < end;
         ++i) {
      auto& range = ranges[i];

      // Calculate dest, either as a const or as an addition to the dest local
      Expression* dest;
      if (auto* c = init->dest->dynCast<Const>()) {
        dest = builder.makeConst(int32_t(c->value.geti32() + bytesWritten));
      } else {
        auto* get = builder.makeLocalGet(-1, Type::i32);
        getVars.push_back(&get->index);
        dest = get;
        if (bytesWritten > 0) {
          Const* addend = builder.makeConst(int32_t(bytesWritten));
          dest = builder.makeBinary(AddInt32, dest, addend);
        }
      }

      // How many bytes are read from this range
      size_t bytes = std::min(range.end, end) - std::max(range.start, start);
      Expression* size = builder.makeConst(int32_t(bytes));
      bytesWritten += bytes;

      // Create new memory.init or memory.fill
      if (range.isZero) {
        Expression* value = builder.makeConst(Literal::makeZero(Type::i32));
        appendResult(builder.makeMemoryFill(dest, value, size, init->memory));
      } else {
        size_t offsetBytes = std::max(start, range.start) - range.start;
        Expression* offset = builder.makeConst(int32_t(offsetBytes));
        appendResult(
          builder.makeMemoryInit(initIndex, dest, offset, size, init->memory));
        initIndex++;
      }
    }

    // Non-zero length memory.inits must have intersected some range
    assert(result);
    replacements[init] = [module, setVar, getVars, result](Function* function) {
      if (setVar != nullptr) {
        Index destVar = Builder(*module).addVar(function, Type::i32);
        *setVar = destVar;
        for (auto* getVar : getVars) {
          *getVar = destVar;
        }
      }
      return result;
    };
  }

  // Create replacements for data.drop instructions now that we know whether we
  // need a drop state global
  for (auto drop : referrers) {
    if (!drop->is<DataDrop>()) {
      continue;
    }

    Expression* result = nullptr;
    auto appendResult = [&](Expression* expr) {
      result = result ? builder.blockify(result, expr) : expr;
    };

    // Track drop state in a global only if some memory.init required it
    if (dropStateGlobal != Name()) {
      appendResult(
        builder.makeGlobalSet(dropStateGlobal, builder.makeConst(int32_t(1))));
    }
    size_t dropIndex = segmentIndex;
    for (auto range : ranges) {
      if (!range.isZero) {
        appendResult(builder.makeDataDrop(dropIndex++));
      }
    }
    replacements[drop] = [result, module](Function*) {
      return result ? result : Builder(*module).makeNop();
    };
  }
}

void MemoryPacking::replaceSegmentOps(Module* module,
                                      Replacements& replacements) {
  struct Replacer : WalkerPass<PostWalker<Replacer>> {
    bool isFunctionParallel() override { return true; }

    // This operates on linear memory, and does not affect reference locals.
    bool requiresNonNullableLocalFixups() override { return false; }

    Replacements& replacements;

    Replacer(Replacements& replacements) : replacements(replacements){};
    std::unique_ptr<Pass> create() override {
      return std::make_unique<Replacer>(replacements);
    }

    void visitMemoryInit(MemoryInit* curr) {
      auto replacement = replacements.find(curr);
      assert(replacement != replacements.end());
      replaceCurrent(replacement->second(getFunction()));
    }

    void visitDataDrop(DataDrop* curr) {
      auto replacement = replacements.find(curr);
      assert(replacement != replacements.end());
      replaceCurrent(replacement->second(getFunction()));
    }

    void visitArrayNewSeg(ArrayNewSeg* curr) {
      if (curr->op == NewData) {
        auto replacement = replacements.find(curr);
        assert(replacement != replacements.end());
        replaceCurrent(replacement->second(getFunction()));
      }
    }
  } replacer(replacements);
  replacer.run(getPassRunner(), module);
}

Pass* createMemoryPackingPass() { return new MemoryPacking(); }

} // namespace wasm
