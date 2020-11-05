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
#include "ir/table-utils.h"
#include "shared-constants.h"
#include "support/debug.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

#define DEBUG_TYPE "emscripten"

namespace wasm {

cashew::IString EM_ASM_PREFIX("emscripten_asm_const");
cashew::IString EM_JS_PREFIX("__em_js__");

static Name STACK_INIT("stack$init");

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
  // its the first non-imported and non-exported global.
  // TODO(sbc): Find a better way to discover the stack pointer.  Perhaps the
  // linker could export it by name?
  for (auto& g : wasm.globals) {
    if (g->imported()) {
      if (g->base == STACK_POINTER) {
        return g.get();
      }
    } else if (!isExported(wasm, g->name)) {
      return g.get();
    }
  }
  return nullptr;
}

const Address UNKNOWN_OFFSET(uint32_t(-1));

std::vector<Address> getSegmentOffsets(Module& wasm) {
  std::unordered_map<Index, Address> passiveOffsets;
  if (wasm.features.hasBulkMemory()) {
    // Fetch passive segment offsets out of memory.init instructions
    struct OffsetSearcher : PostWalker<OffsetSearcher> {
      std::unordered_map<Index, Address>& offsets;
      OffsetSearcher(std::unordered_map<unsigned, Address>& offsets)
        : offsets(offsets) {}
      void visitMemoryInit(MemoryInit* curr) {
        auto* dest = curr->dest->dynCast<Const>();
        if (!dest) {
          return;
        }
        auto it = offsets.find(curr->segment);
        if (it != offsets.end()) {
          Fatal() << "Cannot get offset of passive segment initialized "
                     "multiple times";
        }
        offsets[curr->segment] = dest->value.geti32();
      }
    } searcher(passiveOffsets);
    searcher.walkModule(&wasm);
  }
  std::vector<Address> segmentOffsets;
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
      auto address = addrConst->value.geti32();
      segmentOffsets.push_back(address);
    } else {
      // TODO(sbc): Wasm shared libraries have data segments with non-const
      // offset.
      segmentOffsets.push_back(0);
    }
  }
  return segmentOffsets;
}

std::string escape(const char* input) {
  std::string code = input;
  // replace newlines quotes with escaped newlines
  size_t curr = 0;
  while ((curr = code.find("\\n", curr)) != std::string::npos) {
    code = code.replace(curr, 2, "\\\\n");
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

const char* stringAtAddr(Module& wasm,
                         std::vector<Address> const& segmentOffsets,
                         Address address) {
  for (unsigned i = 0; i < wasm.memory.segments.size(); ++i) {
    Memory::Segment& segment = wasm.memory.segments[i];
    Address offset = segmentOffsets[i];
    if (offset != UNKNOWN_OFFSET && address >= offset &&
        address < offset + segment.data.size()) {
      return &segment.data[address - offset];
    }
  }
  return nullptr;
}

std::string codeForConstAddr(Module& wasm,
                             std::vector<Address> const& segmentOffsets,
                             int32_t address) {
  const char* str = stringAtAddr(wasm, segmentOffsets, address);
  if (!str) {
    // If we can't find the segment corresponding with the address, then we
    // omitted the segment and the address points to an empty string.
    return escape("");
  }
  return escape(str);
}

enum class Proxying {
  None,
  Sync,
  Async,
};

std::string proxyingSuffix(Proxying proxy) {
  switch (proxy) {
    case Proxying::None:
      return "";
    case Proxying::Sync:
      return "sync_on_main_thread_";
    case Proxying::Async:
      return "async_on_main_thread_";
  }
  WASM_UNREACHABLE("invalid prozy type");
}

struct AsmConstWalker : public LinearExecutionWalker<AsmConstWalker> {
  Module& wasm;
  bool minimizeWasmChanges;
  std::vector<Address> segmentOffsets; // segment index => address offset

  struct AsmConst {
    std::set<Signature> sigs;
    Address id;
    std::string code;
    Proxying proxy;
  };

  std::vector<AsmConst> asmConsts;
  std::set<std::pair<Signature, Proxying>> allSigs;
  // last sets in the current basic block, per index
  std::map<Index, LocalSet*> sets;

  AsmConstWalker(Module& _wasm, bool minimizeWasmChanges)
    : wasm(_wasm), minimizeWasmChanges(minimizeWasmChanges),
      segmentOffsets(getSegmentOffsets(wasm)) {}

  void noteNonLinear(Expression* curr);

  void visitLocalSet(LocalSet* curr);
  void visitCall(Call* curr);

  void process();

private:
  void createAsmConst(uint32_t id, std::string code, Signature sig, Name name);
  Signature asmConstSig(Signature baseSig);
  Name nameForImportWithSig(Signature sig, Proxying proxy);
  void addImports();
  Proxying proxyType(Name name);

  std::vector<std::unique_ptr<Function>> queuedImports;
};

void AsmConstWalker::noteNonLinear(Expression* curr) {
  // End of this basic block; clear sets.
  sets.clear();
}

void AsmConstWalker::visitLocalSet(LocalSet* curr) { sets[curr->index] = curr; }

void AsmConstWalker::visitCall(Call* curr) {
  auto* import = wasm.getFunction(curr->target);
  // Find calls to emscripten_asm_const* functions whose first argument is
  // is always a string constant.
  if (!import->imported()) {
    return;
  }
  auto importName = import->base;
  if (!importName.hasSubstring(EM_ASM_PREFIX)) {
    return;
  }

  auto baseSig = wasm.getFunction(curr->target)->sig;
  auto sig = asmConstSig(baseSig);
  auto* arg = curr->operands[0];
  while (!arg->dynCast<Const>()) {
    if (auto* get = arg->dynCast<LocalGet>()) {
      // The argument may be a local.get, in which case, the last set in this
      // basic block has the value.
      auto* set = sets[get->index];
      if (set) {
        assert(set->index == get->index);
        arg = set->value;
      } else {
        Fatal() << "local.get of unknown in arg0 of call to " << importName
                << " (used by EM_ASM* macros) in function "
                << getFunction()->name
                << ".\nThis might be caused by aggressive compiler "
                   "transformations. Consider using EM_JS instead.";
      }
      continue;
    }

    if (auto* setlocal = arg->dynCast<LocalSet>()) {
      // The argument may be a local.tee, in which case we take first child
      // which is the value being copied into the local.
      if (setlocal->isTee()) {
        arg = setlocal->value;
        continue;
      }
    }

    if (auto* bin = arg->dynCast<Binary>()) {
      if (bin->op == AddInt32) {
        // In the dynamic linking case the address of the string constant
        // is the result of adding its offset to __memory_base.
        // In this case are only looking for the offset from __memory_base
        // the RHS of the addition is just what we want.
        arg = bin->right;
        continue;
      }
    }

    Fatal() << "Unexpected arg0 type (" << getExpressionName(arg)
            << ") in call to: " << importName;
  }

  auto* value = arg->cast<Const>();
  int32_t address = value->value.geti32();
  auto code = codeForConstAddr(wasm, segmentOffsets, address);
  createAsmConst(address, code, sig, importName);
}

Proxying AsmConstWalker::proxyType(Name name) {
  if (name.hasSubstring("_sync_on_main_thread")) {
    return Proxying::Sync;
  } else if (name.hasSubstring("_async_on_main_thread")) {
    return Proxying::Async;
  }
  return Proxying::None;
}

void AsmConstWalker::process() {
  // Find and queue necessary imports
  walkModule(&wasm);
  // Add them after the walk, to avoid iterator invalidation on
  // the list of functions.
  addImports();
}

void AsmConstWalker::createAsmConst(uint32_t id,
                                    std::string code,
                                    Signature sig,
                                    Name name) {
  AsmConst asmConst;
  asmConst.id = id;
  asmConst.code = code;
  asmConst.sigs.insert(sig);
  asmConst.proxy = proxyType(name);
  asmConsts.push_back(asmConst);
}

Signature AsmConstWalker::asmConstSig(Signature baseSig) {
  assert(baseSig.params.size() >= 1);
  // Omit the signature of the "code" parameter, taken as a string, as the
  // first argument
  return Signature(
    Type(std::vector<Type>(baseSig.params.begin() + 1, baseSig.params.end())),
    baseSig.results);
}

void AsmConstWalker::addImports() {
  for (auto& import : queuedImports) {
    wasm.addFunction(import.release());
  }
}

static AsmConstWalker fixEmAsmConstsAndReturnWalker(Module& wasm,
                                                    bool minimizeWasmChanges) {
  AsmConstWalker walker(wasm, minimizeWasmChanges);
  walker.process();
  return walker;
}

struct EmJsWalker : public PostWalker<EmJsWalker> {
  Module& wasm;
  std::vector<Address> segmentOffsets; // segment index => address offset

  std::map<std::string, std::string> codeByName;

  EmJsWalker(Module& _wasm)
    : wasm(_wasm), segmentOffsets(getSegmentOffsets(wasm)) {}

  void visitExport(Export* curr) {
    if (curr->kind != ExternalKind::Function) {
      return;
    }
    if (!curr->name.startsWith(EM_JS_PREFIX.str)) {
      return;
    }
    auto* func = wasm.getFunction(curr->value);
    auto funcName = std::string(curr->name.stripPrefix(EM_JS_PREFIX.str));
    // An EM_JS has a single const in the body. Typically it is just returned,
    // but in unoptimized code it might be stored to a local and loaded from
    // there, and in relocatable code it might get added to __memory_base etc.
    FindAll<Const> consts(func->body);
    if (consts.list.size() != 1) {
      Fatal() << "Unexpected generated __em_js__ function body: " << curr->name;
    }
    auto* addrConst = consts.list[0];
    int32_t address = addrConst->value.geti32();
    auto code = codeForConstAddr(wasm, segmentOffsets, address);
    codeByName[funcName] = code;
  }
};

EmJsWalker fixEmJsFuncsAndReturnWalker(Module& wasm) {
  EmJsWalker walker(wasm);
  walker.walkModule(&wasm);

  std::vector<Name> toRemove;
  for (auto& func : wasm.functions) {
    if (func->name.startsWith(EM_JS_PREFIX.str)) {
      toRemove.push_back(func->name);
    }
  }
  for (auto funcName : toRemove) {
    wasm.removeFunction(funcName);
    wasm.removeExport(funcName);
  }
  return walker;
}

void printSignatures(std::ostream& o, const std::set<Signature>& c) {
  o << "[";
  bool first = true;
  for (auto& sig : c) {
    if (first) {
      first = false;
    } else {
      o << ",";
    }
    o << '"' << getSig(sig.results, sig.params) << '"';
  }
  o << "]";
}

std::string EmscriptenGlueGenerator::generateEmscriptenMetadata(
  std::vector<Name> const& initializerFunctions) {
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

  AsmConstWalker emAsmWalker =
    fixEmAsmConstsAndReturnWalker(wasm, minimizeWasmChanges);

  // print
  commaFirst = true;
  if (!emAsmWalker.asmConsts.empty()) {
    meta << "  \"asmConsts\": {";
    for (auto& asmConst : emAsmWalker.asmConsts) {
      meta << nextElement();
      meta << '"' << asmConst.id << "\": [\"" << asmConst.code << "\", ";
      printSignatures(meta, asmConst.sigs);
      meta << ", [\"" << proxyingSuffix(asmConst.proxy) << "\"]";

      meta << "]";
    }
    meta << "\n  },\n";
  }

  EmJsWalker emJsWalker = fixEmJsFuncsAndReturnWalker(wasm);
  if (!emJsWalker.codeByName.empty()) {
    meta << "  \"emJsFuncs\": {";
    commaFirst = true;
    for (auto& pair : emJsWalker.codeByName) {
      auto& name = pair.first;
      auto& code = pair.second;
      meta << nextElement();
      meta << '"' << name << "\": \"" << code << '"';
    }
    meta << "\n  },\n";
  }

  meta << "  \"tableSize\": " << wasm.table.initial.addr << ",\n";

  if (!initializerFunctions.empty()) {
    meta << "  \"initializers\": [";
    commaFirst = true;
    for (const auto& func : initializerFunctions) {
      meta << nextElement();
      meta << "\"" << func.c_str() << "\"";
    }
    meta << "\n  ],\n";
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

  meta << "  \"externs\": [";
  commaFirst = true;
  ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
    if (!(import->module == ENV && import->name == STACK_INIT)) {
      meta << nextElement() << "\"_" << import->base.str << '"';
    }
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
        assert(g->type == Type::i32);
        Const* init = g->init->cast<Const>();
        uint32_t addr = init->value.geti32();
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
    size_t offset = seg.offset->cast<Const>()->value.geti32();
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
