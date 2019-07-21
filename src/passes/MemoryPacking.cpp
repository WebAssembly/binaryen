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

namespace wasm {

// Adding segments adds overhead, this is a rough estimate
const Index OVERHEAD = 8;

struct MemoryPacking : public Pass {
  bool modifiesBinaryenIR() override { return false; }

  void run(PassRunner* runner, Module* module) override {
    if (!module->memory.exists) {
      return;
    }

    if (module->features.hasBulkMemory()) {
      // Remove any references to active segments that might be invalidated.
      optimizeTrappingBulkMemoryOps(runner, module);
      // Conservatively refuse to change segments if any are passive to avoid
      // invalidating segment indices or segment contents referenced from
      // memory.init and data.drop instructions.
      // TODO: optimize in the presence of memory.init and  data.drop
      for (auto segment : module->memory.segments) {
        if (segment.isPassive) {
          return;
        }
      }
    }

    std::vector<Memory::Segment> packed;

    // we can only handle a constant offset for splitting
    auto isSplittable = [&](const Memory::Segment& segment) {
      return segment.offset->is<Const>();
    };

    for (auto& segment : module->memory.segments) {
      if (!isSplittable(segment)) {
        packed.push_back(segment);
      }
    }

    size_t numRemaining = module->memory.segments.size() - packed.size();

    // Split only if we have room for more segments
    auto shouldSplit = [&]() {
      return WebLimitations::MaxDataSegments > packed.size() + numRemaining;
    };

    for (auto& segment : module->memory.segments) {
      if (!isSplittable(segment)) {
        continue;
      }

      // skip final zeros
      while (segment.data.size() > 0 && segment.data.back() == 0) {
        segment.data.pop_back();
      }

      if (!shouldSplit()) {
        packed.push_back(segment);
        continue;
      }

      auto* offset = segment.offset->cast<Const>();
      // Find runs of zeros, and split
      auto& data = segment.data;
      auto base = offset->value.geti32();
      Index start = 0;
      // create new segments
      while (start < data.size()) {
        // skip initial zeros
        while (start < data.size() && data[start] == 0) {
          start++;
        }
        Index end = start; // end of data-containing part
        Index next = end;  // after zeros we can skip. preserves next >= end
        if (!shouldSplit()) {
          next = end = data.size();
        }
        while (next < data.size() && (next - end < OVERHEAD)) {
          if (data[end] != 0) {
            end++;
            next = end; // we can try to skip zeros from here
          } else {
            // end is on a zero, we are looking to skip
            if (data[next] != 0) {
              end = next; // we must extend the segment, including some zeros
            } else {
              next++;
            }
          }
        }
        if (end != start) {
          packed.emplace_back(
            Builder(*module).makeConst(Literal(int32_t(base + start))),
            &data[start],
            end - start);
        }
        start = next;
      }
      numRemaining--;
    }
    module->memory.segments.swap(packed);
  }

  void optimizeTrappingBulkMemoryOps(PassRunner* runner, Module* module) {
    struct Trapper : WalkerPass<PostWalker<Trapper>> {
      bool isFunctionParallel() override { return true; }
      bool changed;

      Pass* create() override { return new Trapper; }

      void visitMemoryInit(MemoryInit* curr) {
        if (!getModule()->memory.segments[curr->segment].isPassive) {
          Builder builder(*getModule());
          replaceCurrent(builder.blockify(builder.makeDrop(curr->dest),
                                          builder.makeDrop(curr->offset),
                                          builder.makeDrop(curr->size),
                                          builder.makeUnreachable()));
          changed = true;
        }
      }
      void visitDataDrop(DataDrop* curr) {
        if (!getModule()->memory.segments[curr->segment].isPassive) {
          ExpressionManipulator::unreachable(curr);
          changed = true;
        }
      }
      void doWalkFunction(Function* func) {
        changed = false;
        super::doWalkFunction(func);
        if (changed) {
          ReFinalize().walkFunctionInModule(func, getModule());
        }
      }
    } trapper;
    trapper.run(runner, module);
  }
};

Pass* createMemoryPackingPass() { return new MemoryPacking(); }

} // namespace wasm
