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
// record how each segment was split. We then use that data to split and update
// all the bulk memory operations in parallel. To preserve trapping semantics,
// it is sometimes necessary to explicitly track whether input segments would
// have been dropped in globals. We are careful to emit only as many of these
// globals as necessary.
//

#include "ir/manipulation.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// A subsection of an orginal memory segment. If `isZero` is true, memory.fill
// will be used instead of memory.init for this range.
struct Range {
  bool isZero;
  size_t start;
  size_t end;
};

// A function that produces the transformed bulk memory op
using Replacement = std::function<Expression*(Function*)>;

// Maps each bulk memory op to the replacement that must be applied to it.
using Replacements = std::unordered_map<Expression*, Replacement>;

// memory.fill: 2 byte opcode + ~2 immediate bytes + ~(3*2) byte operands
const size_t MEMORY_FILL_SIZE = 10;

// data.drop: 2 byte opcode + ~1 byte index immediate
const size_t DATA_DROP_SIZE = 3;

namespace {

Expression* makeMemorySize(Builder& builder) {
  return builder.makeBinary(ShlInt32,
                            builder.makeHost(MemorySize, Name(), {}),
                            builder.makeConst(Literal(int32_t(16))));
}

} // anonymous namespace

struct MemoryPacking : public Pass {
  size_t dropStateGlobalCount = 0;

  void run(PassRunner* runner, Module* module) override;
  void optimizeBulkMemoryOps(PassRunner* runner, Module* module);
  void getSegmentReferers(PassRunner* runner,
                          Module* module,
                          std::vector<std::vector<Expression*>>& referers);
  void dropUnusedSegments(std::vector<Memory::Segment>& segments,
                          std::vector<std::vector<Expression*>>& referers);
  bool canSplit(const Memory::Segment& segment,
                const std::vector<Expression*>& referers);
  void calculateRanges(const Memory::Segment& segment,
                       const std::vector<Expression*>& referers,
                       std::vector<Range>& ranges);
  void createSplitSegments(Builder& builder,
                           const Memory::Segment& segment,
                           std::vector<Range>& ranges,
                           std::vector<Memory::Segment>& packed,
                           size_t segmentsRemaining);
  void createReplacements(Module* module,
                          const std::vector<Range>& ranges,
                          const std::vector<Expression*>& referers,
                          Replacements& replacements,
                          const Index segmentIndex);
  void replaceBulkMemoryOps(PassRunner* runner,
                            Module* module,
                            Replacements& replacements);
};

void MemoryPacking::run(PassRunner* runner, Module* module) {
  if (!module->memory.exists) {
    return;
  }

  auto& segments = module->memory.segments;

  // For each segment, a list of bulk memory instructions that refer to it
  std::vector<std::vector<Expression*>> referers(segments.size());

  if (module->features.hasBulkMemory()) {
    // Remove any references to active segments from bulk memory
    // operations. This means we only need to track replacements for passive
    // segments.
    optimizeBulkMemoryOps(runner, module);
    getSegmentReferers(runner, module, referers);
    dropUnusedSegments(segments, referers);
  }

  // The new, split memory segments
  std::vector<Memory::Segment> packed;

  Replacements replacements;
  Builder builder(*module);
  for (size_t origIndex = 0; origIndex < segments.size(); ++origIndex) {
    auto& segment = segments[origIndex];
    auto& currReferers = referers[origIndex];

    std::vector<Range> ranges;
    if (canSplit(segment, currReferers)) {
      calculateRanges(segment, currReferers, ranges);
    } else {
      // A single range covers the entire segment
      ranges.push_back({false, 0, segment.data.size()});
    }

    Index firstNewIndex = packed.size();
    size_t segmentsRemaining = segments.size() - origIndex;
    createSplitSegments(builder, segment, ranges, packed, segmentsRemaining);
    createReplacements(
      module, ranges, currReferers, replacements, firstNewIndex);
  }

  segments.swap(packed);

  if (module->features.hasBulkMemory()) {
    replaceBulkMemoryOps(runner, module, replacements);
  }
}

bool MemoryPacking::canSplit(const Memory::Segment& segment,
                             const std::vector<Expression*>& referers) {
  if (segment.isPassive) {
    for (auto* referer : referers) {
      if (auto* init = referer->dynCast<MemoryInit>()) {
        // Do not try to split if there is a nonconstant offset or size
        if (!init->offset->is<Const>() || !init->size->is<Const>()) {
          return false;
        }
      }
    }
    return true;
  } else {
    // Active segments can only be split if they have constant offsets
    return segment.offset->is<Const>();
  }
}

void MemoryPacking::calculateRanges(const Memory::Segment& segment,
                                    const std::vector<Expression*>& referers,
                                    std::vector<Range>& ranges) {
  auto& data = segment.data;
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

  // Number of adjacent interior zeroes for which splitting is beneficial
  size_t threshold = 0;
  if (segment.isPassive) {
    // Passive segment metadata size
    threshold += 2;
    // Zeroes on the edge do not increase the number of segments or data.drops,
    // so their threshold is lower. The threshold for interior zeroes depends on
    // an estimate of the number of new memory.fill and data.drop instructions
    // splitting would introduce.
    size_t edgeThreshold = 0;
    for (auto* referer : referers) {
      if (referer->is<MemoryInit>()) {
        // Splitting adds a new memory.fill and a new memory.init
        // TODO: multiply by 2 and update tests
        threshold += MEMORY_FILL_SIZE;
        edgeThreshold += MEMORY_FILL_SIZE;
      } else {
        threshold += DATA_DROP_SIZE;
      }
    }

    // Merge edge zeroes if they are not worth splitting
    if (ranges.size() >= 2) {
      auto last = ranges.end() - 1;
      auto penultimate = ranges.end() - 2;
      if (last->isZero && last->end - last->start < edgeThreshold) {
        penultimate->end = last->end;
        ranges.erase(last);
      }
    }
    if (ranges.size() >= 2) {
      auto first = ranges.begin();
      auto second = ranges.begin() + 1;
      if (first->isZero && first->end - first->start < edgeThreshold) {
        second->start = first->start;
        ranges.erase(first);
      }
    }
  } else {
    // Ballpark overhead of active segment with offset
    threshold = 8;
  }

  // Merge ranges across small spans of zeroes
  std::vector<Range> mergedRanges = {ranges.front()};
  size_t i;
  for (i = 1; i < ranges.size() - 1; ++i) {
    auto left = mergedRanges.end() - 1;
    auto curr = ranges.begin() + i;
    auto right = ranges.begin() + i + 1;
    if (curr->isZero && curr->end - curr->start < threshold) {
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

void MemoryPacking::optimizeBulkMemoryOps(PassRunner* runner, Module* module) {
  struct Optimizer : WalkerPass<PostWalker<Optimizer>> {
    bool isFunctionParallel() override { return true; }
    Pass* create() override { return new Optimizer; }

    bool needsRefinalizing = false;

    void visitMemoryInit(MemoryInit* curr) {
      Builder builder(*getModule());
      Memory::Segment& segment = getModule()->memory.segments[curr->segment];
      size_t maxRuntimeSize = segment.isPassive ? segment.data.size() : 0;
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
        replaceCurrent(builder.makeIf(
          builder.makeBinary(GtUInt32, curr->dest, makeMemorySize(builder)),
          builder.makeUnreachable()));
      } else if (mustTrap) {
        // Drop dest, offset, and size then trap
        replaceCurrent(builder.blockify(builder.makeDrop(curr->dest),
                                        builder.makeDrop(curr->offset),
                                        builder.makeDrop(curr->size),
                                        builder.makeUnreachable()));
        needsRefinalizing = true;
      } else if (!segment.isPassive) {
        // trap if (dest > memory.size | offset | size) != 0
        replaceCurrent(builder.makeIf(
          builder.makeBinary(
            OrInt32,
            builder.makeBinary(GtUInt32, curr->dest, makeMemorySize(builder)),
            builder.makeBinary(OrInt32, curr->offset, curr->size)),
          builder.makeUnreachable()));
      }
    }
    void visitDataDrop(DataDrop* curr) {
      if (!getModule()->memory.segments[curr->segment].isPassive) {
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
  optimizer.run(runner, module);
}

void MemoryPacking::getSegmentReferers(
  PassRunner* runner,
  Module* module,
  std::vector<std::vector<Expression*>>& referers) {
  // TODO: make this a ParallelAnalysis pass
  struct Recorder : WalkerPass<PostWalker<Recorder>> {
    bool isFunctionParallel() override { return false; }

    std::vector<std::vector<Expression*>>& referers;
    Recorder(std::vector<std::vector<Expression*>>& referers)
      : referers(referers) {}

    void visitMemoryInit(MemoryInit* curr) {
      referers[curr->segment].push_back(curr);
    }

    void visitDataDrop(DataDrop* curr) {
      referers[curr->segment].push_back(curr);
    }
  } recorder(referers);
  recorder.run(runner, module);
}

void MemoryPacking::dropUnusedSegments(
  std::vector<Memory::Segment>& segments,
  std::vector<std::vector<Expression*>>& referers) {
  std::vector<Memory::Segment> usedSegments;
  std::vector<std::vector<Expression*>> usedReferers;
  // Remove segments that are never used
  // TODO: remove unused portions of partially used segments as well
  for (size_t i = 0; i < segments.size(); ++i) {
    bool used = false;
    if (segments[i].isPassive) {
      for (auto* referer : referers[i]) {
        if (referer->is<MemoryInit>()) {
          used = true;
          break;
        }
      }
    } else {
      used = true;
    }
    if (used) {
      usedSegments.push_back(segments[i]);
      usedReferers.push_back(referers[i]);
    } else {
      // All referers are data.drops. Make them nops.
      for (auto* referer : referers[i]) {
        ExpressionManipulator::nop(referer);
      }
    }
  }
  std::swap(segments, usedSegments);
  std::swap(referers, usedReferers);
}

void MemoryPacking::createSplitSegments(Builder& builder,
                                        const Memory::Segment& segment,
                                        std::vector<Range>& ranges,
                                        std::vector<Memory::Segment>& packed,
                                        size_t segmentsRemaining) {
  for (size_t i = 0; i < ranges.size(); ++i) {
    Range& range = ranges[i];
    if (range.isZero) {
      continue;
    }
    Expression* offset = nullptr;
    if (!segment.isPassive) {
      if (auto* c = segment.offset->dynCast<Const>()) {
        offset =
          builder.makeConst(Literal(int32_t(c->value.geti32() + range.start)));
      } else {
        assert(ranges.size() == 1);
        offset = segment.offset;
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
    packed.emplace_back(segment.isPassive,
                        offset,
                        &segment.data[range.start],
                        range.end - range.start);
  }
}

void MemoryPacking::createReplacements(Module* module,
                                       const std::vector<Range>& ranges,
                                       const std::vector<Expression*>& referers,
                                       Replacements& replacements,
                                       const Index segmentIndex) {
  // If there was no transformation, only update the indices
  if (ranges.size() == 1 && !ranges.front().isZero) {
    for (auto referer : referers) {
      replacements[referer] = [referer, segmentIndex](Function*) {
        if (auto* init = referer->dynCast<MemoryInit>()) {
          init->segment = segmentIndex;
        } else if (auto* drop = referer->dynCast<DataDrop>()) {
          drop->segment = segmentIndex;
        } else {
          WASM_UNREACHABLE("Unexpected bulk memory operation");
        }
        return referer;
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
    dropStateGlobal = Name(std::string("__mem_segment_drop_state_") +
                           std::to_string(dropStateGlobalCount++));
    module->addGlobal(builder.makeGlobal(dropStateGlobal,
                                         Type::i32,
                                         builder.makeConst(Literal(int32_t(0))),
                                         Builder::Mutable));
    return dropStateGlobal;
  };

  // Create replacements for memory.init instructions first
  size_t initIndex = segmentIndex;
  for (auto referer : referers) {
    auto* init = referer->dynCast<MemoryInit>();
    if (init == nullptr) {
      continue;
    }

    // Nonconstant offsets or sizes will have inhibited splitting
    size_t start = init->offset->cast<Const>()->value.geti32();
    size_t end = start + init->size->cast<Const>()->value.geti32();

    // Index of the range from which this memory.init starts reading
    size_t firstRangeIdx = 0;
    while (ranges[firstRangeIdx].end <= start) {
      ++firstRangeIdx;
    }

    // Handle zero-length memory.inits separately
    if (start == end) {
      // Offset is nonzero because init would otherwise have previously been
      // optimized out, so trap if the dest is out of bounds or the segment is
      // dropped
      Expression* result = builder.makeIf(
        builder.makeBinary(
          OrInt32,
          builder.makeBinary(GtUInt32, init->dest, makeMemorySize(builder)),
          builder.makeGlobalGet(getDropStateGlobal(), Type::i32)),
        builder.makeUnreachable());
      replacements[init] = [result](Function*) { return result; };
      continue;
    }

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
    if (ranges[firstRangeIdx].isZero) {
      appendResult(
        builder.makeIf(builder.makeGlobalGet(getDropStateGlobal(), Type::i32),
                       builder.makeUnreachable()));
    }

    size_t bytesWritten = 0;

    std::cerr << "First range: " << firstRangeIdx << "\n";
    for (size_t i = firstRangeIdx; i < ranges.size() && ranges[i].start < end;
         ++i) {
      auto& range = ranges[i];
      std::cerr << "Visiting range: " << i << "\n";

      // Calculate dest, either as a const or as an addition to the dest local
      Expression* dest;
      if (auto* c = init->dest->dynCast<Const>()) {
        dest =
          builder.makeConst(Literal(int32_t(c->value.geti32() + bytesWritten)));
      } else {
        auto* get = builder.makeLocalGet(-1, i32);
        getVars.push_back(&get->index);
        dest = get;
        if (bytesWritten > 0) {
          Const* addend = builder.makeConst(Literal(int32_t(bytesWritten)));
          dest = builder.makeBinary(AddInt32, dest, addend);
        }
      }

      // How many bytes are read from this range
      size_t bytes = std::min(range.end, end) - std::max(range.start, start);
      Expression* size = builder.makeConst(Literal(int32_t(bytes)));
      bytesWritten += bytes;

      // Create new memory.init or memory.fill
      if (range.isZero) {
        Expression* value = builder.makeConst(Literal::makeZero(i32));
        appendResult(builder.makeMemoryFill(dest, value, size));
      } else {
        size_t offsetBytes = std::max(start, range.start) - range.start;
        Expression* offset = builder.makeConst(Literal(int32_t(offsetBytes)));
        appendResult(builder.makeMemoryInit(initIndex, dest, offset, size));
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
  size_t dropIndex = segmentIndex;
  for (auto drop : referers) {
    if (!drop->is<DataDrop>()) {
      continue;
    }

    Expression* result = nullptr;
    auto appendResult = [&](Expression* expr) {
      result = result ? builder.blockify(result, expr) : expr;
    };

    // Track drop state in a global only if some memory.init required it
    if (dropStateGlobal != Name()) {
      appendResult(builder.makeGlobalSet(
        dropStateGlobal, builder.makeConst(Literal(int32_t(1)))));
    }
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

void MemoryPacking::replaceBulkMemoryOps(PassRunner* runner,
                                         Module* module,
                                         Replacements& replacements) {
  struct Replacer : WalkerPass<PostWalker<Replacer>> {
    bool isFunctionParallel() override { return true; }

    Replacements& replacements;

    Replacer(Replacements& replacements) : replacements(replacements){};
    Pass* create() override { return new Replacer(replacements); }

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
  } replacer(replacements);
  replacer.run(runner, module);
}

Pass* createMemoryPackingPass() { return new MemoryPacking(); }

} // namespace wasm
