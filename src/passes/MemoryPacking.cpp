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

#include "ir/manipulation.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm.h"

// TODO: Use vector swaps instead of erases
// TODO: Solve problem of drop-observing inits becoming fills

namespace wasm {

// A subsection of an orginal memory segment
struct Range {
  bool isZero;
  size_t start;
  size_t end;
};

// An initial segment index and a list of ranges an original segment has been
// split into. This is enough information to replace a bulk memory operation on
// an original segment with an equivalent sequence of operations on the new,
// split segments.
using Replacement = std::pair<Index, std::vector<Range>>;

// Maps bulk memory operations to the replacements that must be applied to them.
using Replacements = std::unordered_map<Expression*, Replacement>;

// memory.fill: 2 byte opcode + ~2 immediate bytes + ~(3*2) byte operands
const size_t MEMORY_FILL_SIZE = 10;

// data.drop: 2 byte opcode + ~1 byte index immediate
const size_t DATA_DROP_SIZE = 3;

struct MemoryPacking : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (!module->memory.exists) {
      return;
    }

    auto& segments = module->memory.segments;

    // For each segment, a list of bulk memory instructions that refer to it
    std::vector<std::vector<Expression*>> referers(segments.size());

    if (module->features.hasBulkMemory()) {
      // Remove any references to active segments that might be invalidated.
      optimizeBulkMemoryOps(runner, module);
      getSegmentReferers(runner, module, referers);
      // Remove segments that are never used
      // TODO: remove unused portions of partially used segments as well
      for (ssize_t i = segments.size() - 1; i >= 0; --i) {
        if (segments[i].isPassive) {
          bool used = false;
          for (auto* referer : referers[i]) {
            if (auto* init = referer->dynCast<MemoryInit>()) {
              used = true;
              break;
            }
          }
          if (!used) {
            // All referers are data.drops. Make them nops.
            for (auto* referer : referers[i]) {
              ExpressionManipulator::nop(referer);
            }
            segments.erase(segments.begin() + i);
            referers.erase(referers.begin() + i);
          }
        }
      }
    }

    // The new, split memory segments
    std::vector<Memory::Segment> packed;
    Replacements replacements;

    for (size_t origIndex = 0; origIndex < segments.size(); ++origIndex) {
      auto& segment = segments[origIndex];
      auto& currReferers = referers[origIndex];

      bool canSplit = true;
      if (segment.isPassive) {
        for (auto* referer : currReferers) {
          if (auto* init = referer->dynCast<MemoryInit>()) {
            // Do not try to split if there is a nonconstant offset or size
            if (!init->offset->is<Const>() || !init->size->is<Const>()) {
              canSplit = false;
            }
          }
        }
      } else {
        // Active segments can only be split if they have constant offsets
        canSplit = segment.offset->is<Const>();
      }

      std::vector<Range> ranges;
      if (canSplit) {
        calculateRanges(segment, currReferers, ranges);
      } else {
        // A single range covers the entire segment
        ranges.push_back(
          Range{.isZero = false, .start = 0, .end = segment.data.size()});
      }

      Index firstNewIndex = packed.size();

      // Create new segments
      Builder builder(*module);
      for (size_t i = 0; i < ranges.size(); ++i) {
        Range& range = ranges[i];
        if (range.isZero) {
          continue;
        }
        Expression* offset = nullptr;
        if (!segment.isPassive) {
          if (auto* c = segment.offset->dynCast<Const>()) {
            offset = builder.makeConst(
              Literal(int32_t(c->value.geti32() + range.start)));
          } else {
            assert(ranges.size() == 1);
            offset = segment.offset;
          }
        }
        if (WebLimitations::MaxDataSegments <=
            packed.size() + segments.size() - origIndex) {
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

      // If a passive segment is removed entirely (because it is all zeroes),
      // make all its data.drops into nops.
      if (segment.isPassive && packed.size() == firstNewIndex) {
        for (size_t i = currReferers.size() - 1; i > 0; --i) {
          if (currReferers[i]->is<DataDrop>()) {
            ExpressionManipulator::nop(currReferers[i]);
            currReferers.erase(currReferers.begin() + i);
          }
        }
      }

      // Update replacements to reflect final splitting scheme for this segment
      for (Expression* referer : currReferers) {
        replacements[referer] = std::make_pair(firstNewIndex, ranges);
      }
    }

    segments.swap(packed);

    if (module->features.hasBulkMemory()) {
      replaceBulkMemoryOps(runner, module, replacements);
    }
  }

  void calculateRanges(Memory::Segment& segment,
                       std::vector<Expression*>& referers,
                       std::vector<Range>& ranges) {
    // Calculate initial zero and nonzero ranges
    auto& data = segment.data;
    size_t start = 0;
    while (start < data.size()) {
      size_t end = start;
      while (end < data.size() && data[end] == 0) {
        end++;
      }
      if (end > start) {
        ranges.push_back(Range{.isZero = true, start, end});
        start = end;
      }
      while (end < data.size() && data[end] != 0) {
        end++;
      }
      if (end > start) {
        ranges.push_back(Range{.isZero = false, start, end});
        start = end;
      }
    }

    // Number of adjacent interior zeroes for which splitting is beneficial
    size_t threshold = 0;
    if (segment.isPassive) {
      // Segment with no offset
      threshold += 2;
      size_t edgeThreshold = 0;
      for (auto* referer : referers) {
        if (referer->is<MemoryInit>()) {
          threshold += MEMORY_FILL_SIZE;
          edgeThreshold += MEMORY_FILL_SIZE;
        } else {
          threshold += DATA_DROP_SIZE;
        }
      }
      // Zeroes at the edges of passive segments may not be worth splitting
      // out via memory.fill instructions.
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
      // Ballpark overhead of segment with offset
      threshold = 8;
    }

    // Merge ranges across small spans of zeroes
    for (ssize_t i = ranges.size() - 2; i >= 1; --i) {
      auto left = ranges.begin() + i - 1;
      auto curr = ranges.begin() + i;
      auto right = ranges.begin() + i + 1;
      if (curr->isZero && curr->end - curr->start < threshold) {
        left->end = right->end;
        ranges.erase(curr, right + 1);
      }
    }
  }

  void optimizeBulkMemoryOps(PassRunner* runner, Module* module) {
    struct Optimizer : WalkerPass<PostWalker<Optimizer>> {
      bool isFunctionParallel() override { return true; }

      Pass* create() override { return new Optimizer; }

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
            builder.makeBinary(
              GtUInt32, curr->dest, builder.makeHost(MemorySize, Name(), {})),
            builder.makeUnreachable()));
        } else if (mustTrap) {
          // Drop dest, offset, and size then trap
          replaceCurrent(builder.blockify(builder.makeDrop(curr->dest),
                                          builder.makeDrop(curr->offset),
                                          builder.makeDrop(curr->size),
                                          builder.makeUnreachable()));
        } else if (!segment.isPassive) {
          // trap if (dest > memory.size | offset | size) != 0
          replaceCurrent(builder.makeIf(
            builder.makeBinary(
              OrInt32,
              builder.makeBinary(
                GtUInt32, curr->dest, builder.makeHost(MemorySize, Name(), {})),
              builder.makeBinary(OrInt32, curr->offset, curr->size)),
            builder.makeUnreachable()));
        }
      }
      void visitDataDrop(DataDrop* curr) {
        if (!getModule()->memory.segments[curr->segment].isPassive) {
          ExpressionManipulator::nop(curr);
        }
      }
    } optimizer;
    optimizer.run(runner, module);
  }

  void getSegmentReferers(PassRunner* runner,
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

  void replaceBulkMemoryOps(PassRunner* runner,
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

        auto segmentIndex = replacement->second.first;
        auto& ranges = replacement->second.second;
        assert(ranges.size() > 0);

        // If there was no transformation, only update the index
        if (ranges.size() == 1 && !ranges.front().isZero) {
          curr->segment = segmentIndex;
          return;
        }

        Builder builder(*getModule());

        // Nonconstant offsets or sizes will have inhibited splitting
        size_t start = curr->offset->cast<Const>()->value.geti32();
        size_t end = start + curr->size->cast<Const>()->value.geti32();
        size_t bytesWritten = 0;

        // Split curr into multiple memory.inits and memory.fills, storing the
        // original base destination in a local if it is not a constant
        Expression* result = nullptr;
        Index destVar = -1;
        if (!curr->dest->is<Const>()) {
          destVar = builder.addVar(getFunction(), i32);
          result = builder.makeLocalSet(destVar, curr->dest);
        }
        for (auto& range : ranges) {
          // Skip ranges that do no intersect the range of the memory.fill
          if (range.end <= start) {
            if (!range.isZero) {
              segmentIndex++;
            }
            continue;
          }
          if (range.start >= end) {
            break;
          }

          Expression* dest;
          if (auto* c = curr->dest->dynCast<Const>()) {
            dest = builder.makeConst(
              Literal(int32_t(c->value.geti32() + bytesWritten)));
          } else {
            dest = builder.makeLocalGet(destVar, i32);
            if (bytesWritten > 0) {
              Const* addend = builder.makeConst(Literal(int32_t(bytesWritten)));
              dest = builder.makeBinary(AddInt32, dest, addend);
            }
          }

          size_t bytes =
            std::min(range.end, end) - std::max(range.start, start);
          bytesWritten += bytes;
          Expression* size = builder.makeConst(Literal(int32_t(bytes)));

          if (range.isZero) {
            Expression* value = builder.makeConst(Literal::makeZero(i32));
            result = builder.blockify(
              result, builder.makeMemoryFill(dest, value, size));
          } else {
            size_t offsetBytes = std::max(start, range.start) - range.start;
            Expression* offset =
              builder.makeConst(Literal(int32_t(offsetBytes)));
            result = builder.blockify(
              result, builder.makeMemoryInit(segmentIndex, dest, offset, size));
            segmentIndex++;
          }
        }
        if (result) {
          replaceCurrent(result);
        } else {
          // Zero-width fill with constant dest does not intersect any ranges
          ExpressionManipulator::nop(curr);
        }
      }

      void visitDataDrop(DataDrop* curr) {
        auto replacement = replacements.find(curr);
        assert(replacement != replacements.end());

        auto segmentIndex = replacement->second.first;
        auto& ranges = replacement->second.second;

        // If there was no transformation, only update the index
        if (ranges.size() == 1) {
          // Data.drop of all-zero segments have already been removed
          assert(!ranges.front().isZero);
          curr->segment = segmentIndex;
          return;
        }

        Builder builder(*getModule());

        Expression* result = nullptr;
        for (auto range : ranges) {
          if (!range.isZero) {
            result =
              builder.blockify(result, builder.makeDataDrop(segmentIndex++));
          }
        }

        assert(result != nullptr);
        replaceCurrent(result);
      }
    } replacer(replacements);
    replacer.run(runner, module);
  }
};

Pass* createMemoryPackingPass() { return new MemoryPacking(); }

} // namespace wasm
