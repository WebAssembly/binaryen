/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Misc optimizations that are useful for and/or are only valid for
// emscripten output.
//

#include <asmjs/shared-constants.h>
#include <ir/import-utils.h>
#include <ir/localize.h>
#include <ir/memory-utils.h>
#include <ir/module-utils.h>
#include <ir/table-utils.h>
#include <pass.h>
#include <shared-constants.h>
#include <wasm-builder.h>
#include <wasm-emscripten.h>
#include <wasm.h>

#define DEBUG_TYPE "post-emscripten"

namespace wasm {

namespace {

static bool isInvoke(Function* F) {
  return F->imported() && F->module == ENV && F->base.startsWith("invoke_");
}

struct SegmentRemover : WalkerPass<PostWalker<SegmentRemover>> {
  SegmentRemover(Name segment) : segment(segment) {}

  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<SegmentRemover>(segment);
  }

  void visitMemoryInit(MemoryInit* curr) {
    if (segment == curr->segment) {
      Builder builder(*getModule());
      replaceCurrent(builder.blockify(builder.makeDrop(curr->dest),
                                      builder.makeDrop(curr->offset),
                                      builder.makeDrop(curr->size)));
    }
  }

  void visitDataDrop(DataDrop* curr) {
    if (segment == curr->segment) {
      Builder builder(*getModule());
      replaceCurrent(builder.makeNop());
    }
  }

  Name segment;
};

static void calcSegmentOffsets(Module& wasm,
                               std::vector<Address>& segmentOffsets) {
  const Address UNKNOWN_OFFSET(uint32_t(-1));

  std::unordered_map<Name, Address> passiveOffsets;
  if (wasm.features.hasBulkMemory()) {
    // Fetch passive segment offsets out of memory.init instructions
    struct OffsetSearcher : PostWalker<OffsetSearcher> {
      std::unordered_map<Name, Address>& offsets;
      OffsetSearcher(std::unordered_map<Name, Address>& offsets)
        : offsets(offsets) {}
      void visitMemoryInit(MemoryInit* curr) {
        // The desitination of the memory.init is either a constant
        // or the result of an addition with __memory_base in the
        // case of PIC code.
        auto* dest = curr->dest->dynCast<Const>();
        if (!dest) {
          auto* add = curr->dest->dynCast<Binary>();
          if (!add) {
            return;
          }
          dest = add->left->dynCast<Const>();
          if (!dest) {
            return;
          }
        }
        if (offsets.find(curr->segment) != offsets.end()) {
          Fatal() << "Cannot get offset of passive segment initialized "
                     "multiple times";
        }
        offsets[curr->segment] = dest->value.getUnsigned();
      }
    } searcher(passiveOffsets);
    searcher.walkModule(&wasm);
  }
  for (unsigned i = 0; i < wasm.dataSegments.size(); ++i) {
    auto& segment = wasm.dataSegments[i];
    if (segment->isPassive) {
      auto it = passiveOffsets.find(segment->name);
      if (it != passiveOffsets.end()) {
        segmentOffsets.push_back(it->second);
      } else {
        // This was a non-constant offset (perhaps TLS)
        segmentOffsets.push_back(UNKNOWN_OFFSET);
      }
    } else if (auto* addrConst = segment->offset->dynCast<Const>()) {
      auto address = addrConst->value.getUnsigned();
      segmentOffsets.push_back(address);
    } else {
      // TODO(sbc): Wasm shared libraries have data segments with non-const
      // offset.
      segmentOffsets.push_back(0);
    }
  }
}

static void removeSegment(Module& wasm, Name segment) {
  PassRunner runner(&wasm);
  SegmentRemover(segment).run(&runner, &wasm);
  // Resize the segment to zero. TODO: Remove it entirely instead.
  wasm.getDataSegment(segment)->data.resize(0);
}

static Address getExportedAddress(Module& wasm, Export* export_) {
  Global* g = wasm.getGlobal(export_->value);
  auto* addrConst = g->init->dynCast<Const>();
  return addrConst->value.getUnsigned();
}

static void removeData(Module& wasm,
                       const std::vector<Address>& segmentOffsets,
                       Name start_sym,
                       Name end_sym) {
  Export* start = wasm.getExportOrNull(start_sym);
  Export* end = wasm.getExportOrNull(end_sym);
  if (!start && !end) {
    BYN_TRACE("removeData: start/stop symbols not found (" << start_sym << ", "
                                                           << end_sym << ")\n");
    return;
  }

  if (!start || !end) {
    Fatal() << "Found only one of " << start_sym << " and " << end_sym;
  }

  Address startAddress = getExportedAddress(wasm, start);
  Address endAddress = getExportedAddress(wasm, end);
  for (Index i = 0; i < wasm.dataSegments.size(); i++) {
    auto& segment = wasm.dataSegments[i];
    Address segmentStart = segmentOffsets[i];
    size_t segmentSize = segment->data.size();
    if (segmentStart <= startAddress &&
        segmentStart + segmentSize >= endAddress) {
      if (segmentStart == startAddress &&
          segmentStart + segmentSize == endAddress) {
        BYN_TRACE("removeData: removing whole segment\n");
        removeSegment(wasm, segment->name);
      } else {
        // If we can't remove the whole segment then just set the string
        // data to zero.
        BYN_TRACE("removeData: removing part of segment\n");
        size_t segmentOffset = startAddress - segmentStart;
        char* startElem = &segment->data[segmentOffset];
        memset(startElem, 0, endAddress - startAddress);
      }
      return;
    }
  }
  Fatal() << "Segment data not found between symbols " << start_sym << " ("
          << startAddress << ") and " << end_sym << " (" << endAddress << ")";
}

IString EM_JS_PREFIX("__em_js__");
IString EM_JS_DEPS_PREFIX("__em_lib_deps_");

struct EmJsWalker : public PostWalker<EmJsWalker> {
  bool sideModule;
  std::vector<Export> toRemove;

  EmJsWalker(bool sideModule) : sideModule(sideModule) {}

  void visitExport(Export* curr) {
    if (!sideModule && curr->name.startsWith(EM_JS_PREFIX)) {
      toRemove.push_back(*curr);
    }
    if (curr->name.startsWith(EM_JS_DEPS_PREFIX)) {
      toRemove.push_back(*curr);
    }
  }
};

} // namespace

struct PostEmscripten : public Pass {
  void run(Module* module) override {
    removeExports(*module);
    removeEmJsExports(*module);
    // Optimize exceptions
    optimizeExceptions(module);
  }

  void removeExports(Module& module) {
    std::vector<Address> segmentOffsets; // segment index => address offset
    calcSegmentOffsets(module, segmentOffsets);

    auto sideModule = hasArgument("post-emscripten-side-module");
    if (!sideModule) {
      removeData(module, segmentOffsets, "__start_em_asm", "__stop_em_asm");
      removeData(module, segmentOffsets, "__start_em_js", "__stop_em_js");

      // Side modules read EM_ASM data from the module based on these exports
      // so we need to keep them around in that case.
      module.removeExport("__start_em_asm");
      module.removeExport("__stop_em_asm");
    }

    removeData(
      module, segmentOffsets, "__start_em_lib_deps", "__stop_em_lib_deps");
    module.removeExport("__start_em_js");
    module.removeExport("__stop_em_js");
    module.removeExport("__start_em_lib_deps");
    module.removeExport("__stop_em_lib_deps");
  }

  void removeEmJsExports(Module& module) {
    auto sideModule = hasArgument("post-emscripten-side-module");
    EmJsWalker walker(sideModule);
    walker.walkModule(&module);
    for (const Export& exp : walker.toRemove) {
      if (exp.kind == ExternalKind::Function) {
        module.removeFunction(exp.value);
      } else {
        module.removeGlobal(exp.value);
      }
      module.removeExport(exp.name);
    }
  }

  // Optimize exceptions (and setjmp) by removing unnecessary invoke* calls.
  // An invoke is a call to JS with a function pointer; JS does a try-catch
  // and calls the pointer, catching and reporting any error. If we know no
  // exception will be thrown, we can simply skip the invoke.
  void optimizeExceptions(Module* module) {
    // First, check if this code even uses invokes.
    bool hasInvokes = false;
    for (auto& imp : module->functions) {
      if (isInvoke(imp.get())) {
        hasInvokes = true;
      }
    }
    if (!hasInvokes || module->tables.empty()) {
      return;
    }
    // Next, see if the Table is flat, which we need in order to see where
    // invokes go statically. (In dynamic linking, the table is not flat,
    // and we can't do this.)
    TableUtils::FlatTable flatTable(*module, *module->tables[0]);
    if (!flatTable.valid) {
      return;
    }
    // This code has exceptions. Find functions that definitely cannot throw,
    // and remove invokes to them.
    struct Info
      : public ModuleUtils::CallGraphPropertyAnalysis<Info>::FunctionInfo {
      bool canThrow = false;
    };
    ModuleUtils::CallGraphPropertyAnalysis<Info> analyzer(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          // Assume any import can throw. We may want to reduce this to just
          // longjmp/cxa_throw/etc.
          info.canThrow = true;
        }
      });

    // Assume a non-direct call might throw.
    analyzer.propagateBack([](const Info& info) { return info.canThrow; },
                           [](const Info& info) { return true; },
                           [](Info& info) { info.canThrow = true; },
                           [](const Info& info, Function* reason) {},
                           analyzer.NonDirectCallsHaveProperty);

    // Apply the information.
    struct OptimizeInvokes : public WalkerPass<PostWalker<OptimizeInvokes>> {
      bool isFunctionParallel() override { return true; }

      std::unique_ptr<Pass> create() override {
        return std::make_unique<OptimizeInvokes>(map, flatTable);
      }

      std::map<Function*, Info>& map;
      TableUtils::FlatTable& flatTable;

      OptimizeInvokes(std::map<Function*, Info>& map,
                      TableUtils::FlatTable& flatTable)
        : map(map), flatTable(flatTable) {}

      void visitCall(Call* curr) {
        auto* target = getModule()->getFunction(curr->target);
        if (!isInvoke(target)) {
          return;
        }
        // The first operand is the function pointer index, which must be
        // constant if we are to optimize it statically.
        if (auto* index = curr->operands[0]->dynCast<Const>()) {
          size_t indexValue = index->value.getUnsigned();
          if (indexValue >= flatTable.names.size()) {
            // UB can lead to indirect calls to invalid pointers.
            return;
          }
          auto actualTarget = flatTable.names[indexValue];
          if (actualTarget.isNull()) {
            // UB can lead to an indirect call of 0 or an index in which there
            // is no function name.
            return;
          }
          if (map[getModule()->getFunction(actualTarget)].canThrow) {
            return;
          }
          // This invoke cannot throw! Make it a direct call.
          curr->target = actualTarget;
          for (Index i = 0; i < curr->operands.size() - 1; i++) {
            curr->operands[i] = curr->operands[i + 1];
          }
          curr->operands.resize(curr->operands.size() - 1);
        }
      }
    };
    OptimizeInvokes(analyzer.map, flatTable).run(getPassRunner(), module);
  }
};

Pass* createPostEmscriptenPass() { return new PostEmscripten(); }

} // namespace wasm
