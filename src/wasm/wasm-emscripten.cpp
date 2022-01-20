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

#include "wasm-emscripten.h"

#include <sstream>

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "ir/module-utils.h"
#include "shared-constants.h"
#include "support/debug.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

#define DEBUG_TYPE "emscripten"

namespace wasm {

cashew::IString EM_JS_PREFIX("__em_js__");

void addExportedFunction(Module& wasm, Function* function) {
  wasm.addFunction(function);
  auto export_ = new Export;
  export_->name = export_->value = function->name;
  export_->kind = ExternalKind::Function;
  wasm.addExport(export_);
}

// TODO(sbc): There should probably be a better way to do this.
bool isExported(Module& wasm, Name name) {
  for (auto& ex : wasm.exports) {
    if (ex->value == name) {
      return true;
    }
  }
  return false;
}

Global* getStackPointerGlobal(Module& wasm) {
  // Assumption: The stack pointer is either imported as __stack_pointer or
  // we just assume it's the first non-imported global.
  // TODO(sbc): Find a better way to discover the stack pointer.  Perhaps the
  // linker could export it by name?
  for (auto& g : wasm.globals) {
    if (g->imported() && g->base == STACK_POINTER) {
      return g.get();
    }
  }
  for (auto& g : wasm.globals) {
    if (!g->imported()) {
      return g.get();
    }
  }
  return nullptr;
}

const Address UNKNOWN_OFFSET(uint32_t(-1));

std::string escape(std::string code) {
  // replace newlines quotes with escaped newlines
  size_t curr = 0;
  while ((curr = code.find("\\n", curr)) != std::string::npos) {
    code = code.replace(curr, 2, "\\\\n");
    curr += 3; // skip this one
  }
  curr = 0;
  while ((curr = code.find("\\t", curr)) != std::string::npos) {
    code = code.replace(curr, 2, "\\\\t");
    curr += 3; // skip this one
  }
  // replace double quotes with escaped single quotes
  curr = 0;
  while ((curr = code.find('"', curr)) != std::string::npos) {
    if (curr == 0 || code[curr - 1] != '\\') {
      code = code.replace(curr,
                          1,
                          "\\"
                          "\"");
      curr += 2; // skip this one
    } else {     // already escaped, escape the slash as well
      code = code.replace(curr,
                          1,
                          "\\"
                          "\\"
                          "\"");
      curr += 3; // skip this one
    }
  }
  return code;
}

class StringConstantTracker {
public:
  StringConstantTracker(Module& wasm) : wasm(wasm) { calcSegmentOffsets(); }

  const char* stringAtAddr(Address address) {
    for (unsigned i = 0; i < wasm.memory.segments.size(); ++i) {
      Memory::Segment& segment = wasm.memory.segments[i];
      Address offset = segmentOffsets[i];
      if (offset != UNKNOWN_OFFSET && address >= offset &&
          address < offset + segment.data.size()) {
        return &segment.data[address - offset];
      }
    }
    Fatal() << "unable to find data for ASM/EM_JS const at: " << address;
    return nullptr;
  }

  std::vector<Address> segmentOffsets; // segment index => address offset

private:
  void calcSegmentOffsets() {
    std::unordered_map<Index, Address> passiveOffsets;
    if (wasm.features.hasBulkMemory()) {
      // Fetch passive segment offsets out of memory.init instructions
      struct OffsetSearcher : PostWalker<OffsetSearcher> {
        std::unordered_map<Index, Address>& offsets;
        OffsetSearcher(std::unordered_map<unsigned, Address>& offsets)
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
          auto it = offsets.find(curr->segment);
          if (it != offsets.end()) {
            Fatal() << "Cannot get offset of passive segment initialized "
                       "multiple times";
          }
          offsets[curr->segment] = dest->value.getInteger();
        }
      } searcher(passiveOffsets);
      searcher.walkModule(&wasm);
    }
    for (unsigned i = 0; i < wasm.memory.segments.size(); ++i) {
      auto& segment = wasm.memory.segments[i];
      if (segment.isPassive) {
        auto it = passiveOffsets.find(i);
        if (it != passiveOffsets.end()) {
          segmentOffsets.push_back(it->second);
        } else {
          // This was a non-constant offset (perhaps TLS)
          segmentOffsets.push_back(UNKNOWN_OFFSET);
        }
      } else if (auto* addrConst = segment.offset->dynCast<Const>()) {
        auto address = addrConst->value.getUnsigned();
        segmentOffsets.push_back(address);
      } else {
        // TODO(sbc): Wasm shared libraries have data segments with non-const
        // offset.
        segmentOffsets.push_back(0);
      }
    }
  }

  Module& wasm;
};

struct AsmConst {
  Address id;
  std::string code;
};

struct SegmentRemover : WalkerPass<PostWalker<SegmentRemover>> {
  SegmentRemover(Index segment) : segment(segment) {}

  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SegmentRemover(segment); }

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

  Index segment;
};

static void removeSegment(Module& wasm, Index segment) {
  PassRunner runner(&wasm);
  SegmentRemover(segment).run(&runner, &wasm);
  // Resize the segment to zero.  In theory we should completely remove it
  // but that would mean re-numbering the segments that follow which is
  // non-trivial.
  wasm.memory.segments[segment].data.resize(0);
}

static Address getExportedAddress(Module& wasm, Export* export_) {
  Global* g = wasm.getGlobal(export_->value);
  auto* addrConst = g->init->dynCast<Const>();
  return addrConst->value.getUnsigned();
}

static std::vector<AsmConst> findEmAsmConsts(Module& wasm,
                                             bool minimizeWasmChanges) {
  // Newer version of emscripten/llvm export these symbols so we can use them to
  // find all the EM_ASM constants.   Sadly __start_em_asm and __stop_em_asm
  // don't alwasy mark the start and end of segment because in dynamic linking
  // we merge all data segments into one.
  Export* start = wasm.getExportOrNull("__start_em_asm");
  Export* end = wasm.getExportOrNull("__stop_em_asm");
  if (!start && !end) {
    BYN_TRACE("findEmAsmConsts: no start/stop symbols\n");
    return {};
  }

  if (!start || !end) {
    Fatal() << "Found only one of __start_em_asm and __stop_em_asm";
  }

  std::vector<AsmConst> asmConsts;
  StringConstantTracker stringTracker(wasm);
  Address startAddress = getExportedAddress(wasm, start);
  Address endAddress = getExportedAddress(wasm, end);
  for (Index i = 0; i < wasm.memory.segments.size(); i++) {
    Address segmentStart = stringTracker.segmentOffsets[i];
    size_t segmentSize = wasm.memory.segments[i].data.size();
    if (segmentStart <= startAddress &&
        segmentStart + segmentSize >= endAddress) {
      Address address = startAddress;
      while (address < endAddress) {
        auto code = stringTracker.stringAtAddr(address);
        asmConsts.push_back({address, code});
        address.addr += strlen(code) + 1;
      }

      if (segmentStart == startAddress &&
          segmentStart + segmentSize == endAddress) {
        removeSegment(wasm, i);
      } else {
        // If we can't remove the whole segment then just set the string
        // data to zero.
        size_t segmentOffset = startAddress - segmentStart;
        char* startElem = &wasm.memory.segments[i].data[segmentOffset];
        memset(startElem, 0, endAddress - startAddress);
      }
      break;
    }
  }

  assert(asmConsts.size());
  wasm.removeExport("__start_em_asm");
  wasm.removeExport("__stop_em_asm");
  return asmConsts;
}

struct EmJsWalker : public PostWalker<EmJsWalker> {
  Module& wasm;
  StringConstantTracker stringTracker;
  std::vector<Export> toRemove;

  std::map<std::string, std::string> codeByName;
  std::map<Address, size_t> codeAddresses; // map from address to string len

  EmJsWalker(Module& _wasm) : wasm(_wasm), stringTracker(_wasm) {}

  void visitExport(Export* curr) {
    if (!curr->name.startsWith(EM_JS_PREFIX.str)) {
      return;
    }

    Address address;
    if (curr->kind == ExternalKind::Global) {
      auto* global = wasm.getGlobal(curr->value);
      Const* const_ = global->init->cast<Const>();
      address = const_->value.getUnsigned();
    } else if (curr->kind == ExternalKind::Function) {
      auto* func = wasm.getFunction(curr->value);
      // An EM_JS has a single const in the body. Typically it is just returned,
      // but in unoptimized code it might be stored to a local and loaded from
      // there, and in relocatable code it might get added to __memory_base etc.
      FindAll<Const> consts(func->body);
      if (consts.list.size() != 1) {
        Fatal() << "Unexpected generated __em_js__ function body: "
                << curr->name;
      }
      auto* addrConst = consts.list[0];
      address = addrConst->value.getUnsigned();
    } else {
      return;
    }

    toRemove.push_back(*curr);
    auto code = stringTracker.stringAtAddr(address);
    auto funcName = std::string(curr->name.stripPrefix(EM_JS_PREFIX.str));
    codeByName[funcName] = code;
    codeAddresses[address] = strlen(code) + 1;
  }
};

EmJsWalker findEmJsFuncsAndReturnWalker(Module& wasm) {
  EmJsWalker walker(wasm);
  walker.walkModule(&wasm);

  for (const Export& exp : walker.toRemove) {
    if (exp.kind == ExternalKind::Function) {
      wasm.removeFunction(exp.value);
    } else {
      wasm.removeGlobal(exp.value);
    }
    wasm.removeExport(exp.name);
  }

  // With newer versions of emscripten/llvm we pack all EM_JS strings into
  // single segment.
  // We can detect this by checking for segments that contain only JS strings.
  // When we find such segements we remove them from the final binary.
  for (Index i = 0; i < wasm.memory.segments.size(); i++) {
    Address start = walker.stringTracker.segmentOffsets[i];
    Address cur = start;

    while (cur < start + wasm.memory.segments[i].data.size()) {
      if (walker.codeAddresses.count(cur) == 0) {
        break;
      }
      cur.addr += walker.codeAddresses[cur];
    }

    if (cur == start + wasm.memory.segments[i].data.size()) {
      // Entire segment is contains JS strings.  Remove it.
      removeSegment(wasm, i);
    }
  }
  return walker;
}

std::string EmscriptenGlueGenerator::generateEmscriptenMetadata() {
  bool commaFirst;
  auto nextElement = [&commaFirst]() {
    if (commaFirst) {
      commaFirst = false;
      return "\n    ";
    } else {
      return ",\n    ";
    }
  };

  std::stringstream meta;
  meta << "{\n";

  std::vector<AsmConst> asmConsts = findEmAsmConsts(wasm, minimizeWasmChanges);

  // print
  commaFirst = true;
  if (!asmConsts.empty()) {
    meta << "  \"asmConsts\": {";
    for (auto& asmConst : asmConsts) {
      meta << nextElement();
      meta << '"' << asmConst.id << "\": \"" << escape(asmConst.code) << "\"";
    }
    meta << "\n  },\n";
  }

  EmJsWalker emJsWalker = findEmJsFuncsAndReturnWalker(wasm);
  if (!emJsWalker.codeByName.empty()) {
    meta << "  \"emJsFuncs\": {";
    commaFirst = true;
    for (auto& [name, code] : emJsWalker.codeByName) {
      meta << nextElement();
      meta << '"' << name << "\": \"" << escape(code) << '"';
    }
    meta << "\n  },\n";
  }

  // Avoid adding duplicate imports to `declares' or `invokeFuncs`.  Even
  // though we might import the same function multiple times (i.e. with
  // different sigs) we only need to list is in the metadata once.
  std::set<std::string> declares;
  std::set<std::string> invokeFuncs;

  // We use the `base` rather than the `name` of the imports here and below
  // becasue this is the externally visible name that the embedder (JS) will
  // see.
  meta << "  \"declares\": [";
  commaFirst = true;
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    if (emJsWalker.codeByName.count(import->base.str) == 0 &&
        !import->base.startsWith("invoke_")) {
      if (declares.insert(import->base.str).second) {
        meta << nextElement() << '"' << import->base.str << '"';
      }
    }
  });
  meta << "\n  ],\n";

  meta << "  \"globalImports\": [";
  commaFirst = true;
  ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
    meta << nextElement() << '"' << import->base.str << '"';
  });
  meta << "\n  ],\n";

  if (!wasm.exports.empty()) {
    meta << "  \"exports\": [";
    commaFirst = true;
    for (const auto& ex : wasm.exports) {
      if (ex->kind == ExternalKind::Function) {
        meta << nextElement() << '"' << ex->name.str << '"';
      }
    }
    meta << "\n  ],\n";

    meta << "  \"namedGlobals\": {";
    commaFirst = true;
    for (const auto& ex : wasm.exports) {
      if (ex->kind == ExternalKind::Global) {
        const Global* g = wasm.getGlobal(ex->value);
        assert(g->type == Type::i32 || g->type == Type::i64);
        Const* init = g->init->cast<Const>();
        uint64_t addr = init->value.getInteger();
        meta << nextElement() << '"' << ex->name.str << "\" : \"" << addr
             << '"';
      }
    }
    meta << "\n  },\n";
  }

  meta << "  \"invokeFuncs\": [";
  commaFirst = true;
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    if (import->module == ENV && import->base.startsWith("invoke_")) {
      if (invokeFuncs.insert(import->base.str).second) {
        meta << nextElement() << '"' << import->base.str << '"';
      }
    }
  });
  meta << "\n  ],\n";

  // In normal mode we attempt to determine if main takes argumnts or not
  // In standalone mode we export _start instead and rely on the presence
  // of the __wasi_args_get and __wasi_args_sizes_get syscalls allow us to
  // DCE to the argument handling JS code instead.
  if (!standalone) {
    auto mainReadsParams = false;
    auto* exp = wasm.getExportOrNull("main");
    if (!exp) {
      exp = wasm.getExportOrNull("__main_argc_argv");
    }
    if (exp) {
      if (exp->kind == ExternalKind::Function) {
        auto* main = wasm.getFunction(exp->value);
        mainReadsParams = true;
        // If main does not read its parameters, it will just be a stub that
        // calls __original_main (which has no parameters).
        if (auto* call = main->body->dynCast<Call>()) {
          if (call->operands.empty()) {
            mainReadsParams = false;
          }
        }
      }
    }
    meta << "  \"mainReadsParams\": " << int(mainReadsParams) << ",\n";
  }

  meta << "  \"features\": [";
  commaFirst = true;
  wasm.features.iterFeatures([&](FeatureSet::Feature f) {
    meta << nextElement() << "\"--enable-" << FeatureSet::toString(f) << '"';
  });
  meta << "\n  ]\n";

  meta << "}\n";

  return meta.str();
}

void EmscriptenGlueGenerator::separateDataSegments(Output* outfile,
                                                   Address base) {
  size_t lastEnd = 0;
  for (Memory::Segment& seg : wasm.memory.segments) {
    if (seg.isPassive) {
      Fatal() << "separating passive segments not implemented";
    }
    if (!seg.offset->is<Const>()) {
      Fatal() << "separating relocatable segments not implemented";
    }
    size_t offset = seg.offset->cast<Const>()->value.getInteger();
    offset -= base;
    size_t fill = offset - lastEnd;
    if (fill > 0) {
      std::vector<char> buf(fill);
      outfile->write(buf.data(), fill);
    }
    outfile->write(seg.data.data(), seg.data.size());
    lastEnd = offset + seg.data.size();
  }
  wasm.memory.segments.clear();
}

void EmscriptenGlueGenerator::renameMainArgcArgv() {
  // If an export call ed __main_argc_argv exists rename it to main
  Export* ex = wasm.getExportOrNull("__main_argc_argv");
  if (!ex) {
    BYN_TRACE("renameMain: __main_argc_argv not found\n");
    return;
  }
  ex->name = "main";
  wasm.updateMaps();
  ModuleUtils::renameFunction(wasm, "__main_argc_argv", "main");
}

} // namespace wasm
