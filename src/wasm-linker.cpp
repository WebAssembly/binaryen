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

#include "wasm-linker.h"
#include "asm_v_wasm.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm-printing.h"

using namespace wasm;

cashew::IString EMSCRIPTEN_ASM_CONST("emscripten_asm_const");
namespace wasm {
// These are defined (not just declared) in shared-constants.h, so we can't just
// include that header.  TODO: Move the definitions into a cpp file.
extern cashew::IString ENV;
extern cashew::IString MEMORY;
}


void Linker::placeStackPointer(size_t stackAllocation) {
  // ensure this is the first allocation
  assert(nextStatic == globalBase || nextStatic == 1);
  const size_t pointerSize = 4;
  // Unconditionally allocate space for the stack pointer. Emscripten
  // allocates the stack itself, and initializes the stack pointer itself.
  size_t address = allocateStatic(pointerSize, pointerSize, "__stack_pointer");
  if (stackAllocation) {
    // If we are allocating the stack, set up a relocation to initialize the
    // stack pointer to point to one past-the-end of the stack allocation.
    auto* raw = new uint32_t;
    relocations.emplace_back(
        make_unique<Relocation>(raw, ".stack", stackAllocation));
    assert(wasm.memory.segments.size() == 0);
    addressSegments[address] = wasm.memory.segments.size();
    wasm.memory.segments.emplace_back(
        address, reinterpret_cast<char*>(raw), pointerSize);
  }
}

void Linker::layout() {
  // Place the stack after the user's static data, to keep those addresses
  // small.
  if (stackAllocation) allocateStatic(stackAllocation, 16, ".stack");

  // The minimum initial memory size is the amount of static variables we have
  // allocated. Round it up to a page, and update the page-increment versions
  // of initial and max
  size_t initialMem = roundUpToPageSize(nextStatic);
  if (userInitialMemory) {
    if (initialMem > userInitialMemory) {
      Fatal() << "Specified initial memory size " << userInitialMemory <<
          " is smaller than required size " << initialMem;
    }
    wasm.memory.initial = userInitialMemory / Memory::kPageSize;
  } else {
    wasm.memory.initial = initialMem / Memory::kPageSize;
  }

  if (userMaxMemory) wasm.memory.max = userMaxMemory / Memory::kPageSize;
  wasm.memory.exportName = MEMORY;

  // XXX For now, export all functions marked .globl.
  for (Name name : globls) exportFunction(name, false);
  for (Name name : initializerFunctions) exportFunction(name, true);

  auto ensureFunctionIndex = [this](Name name) {
    if (functionIndexes.count(name) == 0) {
      functionIndexes[name] = wasm.table.names.size();
      wasm.table.names.push_back(name);
      if (debug) {
        std::cerr << "function index: " << name << ": "
                  << functionIndexes[name] << '\n';
      }
    }
  };
  for (auto& relocation : relocations) {
    Name name = relocation->value;
    if (debug) std::cerr << "fix relocation " << name << '\n';
    const auto& symbolAddress = staticAddresses.find(name);
    if (symbolAddress != staticAddresses.end()) {
      *(relocation->data) = symbolAddress->second + relocation->offset;
      if (debug) std::cerr << "  ==> " << *(relocation->data) << '\n';
    } else {
      // must be a function address
      auto aliased = aliasedFunctions.find(name);
      if (aliased != aliasedFunctions.end()) name = aliased->second;
      if (!wasm.checkFunction(name)) {
        std::cerr << "Unknown symbol: " << name << '\n';
        if (!ignoreUnknownSymbols) abort();
        *(relocation->data) = 0;
      } else {
        ensureFunctionIndex(name);
        *(relocation->data) = functionIndexes[name] + relocation->offset;
      }
    }
  }
  if (!!startFunction) {
    if (implementedFunctions.count(startFunction) == 0) {
      std::cerr << "Unknown start function: `" << startFunction << "`\n";
      abort();
    }
    const auto *target = wasm.getFunction(startFunction);
    Name start("_start");
    if (implementedFunctions.count(start) != 0) {
      std::cerr << "Start function already present: `" << start << "`\n";
      abort();
    }
    auto* func = wasm.allocator.alloc<Function>();
    func->name = start;
    wasm.addFunction(func);
    exportFunction(start, true);
    wasm.addStart(start);
    auto* block = wasm.allocator.alloc<Block>();
    func->body = block;
    {
      // Create the call, matching its parameters.
      // TODO allow calling with non-default values.
      auto* call = wasm.allocator.alloc<Call>();
      call->target = startFunction;
      size_t paramNum = 0;
      for (WasmType type : target->params) {
        Name name = Name::fromInt(paramNum++);
        Builder::addVar(func, name, type);
        auto* param = wasm.allocator.alloc<GetLocal>();
        param->index = func->getLocalIndex(name);
        param->type = type;
        call->operands.push_back(param);
      }
      block->list.push_back(call);
      block->finalize();
    }
  }

  // ensure an explicit function type for indirect call targets
  for (auto& name : wasm.table.names) {
    auto* func = wasm.getFunction(name);
    func->type = ensureFunctionType(getSig(func), &wasm, wasm.allocator)->name;
  }
}

void Linker::emscriptenGlue(std::ostream& o) {
  if (debug) {
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  wasm.removeImport(EMSCRIPTEN_ASM_CONST); // we create _sig versions

  makeDynCallThunks();

  o << ";; METADATA: { ";
  // find asmConst calls, and emit their metadata
  struct AsmConstWalker : public PostWalker<AsmConstWalker, Visitor<AsmConstWalker>> {
    Linker* parent;

    std::map<std::string, std::set<std::string>> sigsForCode;
    std::map<std::string, size_t> ids;
    std::set<std::string> allSigs;

    void visitCallImport(CallImport* curr) {
      if (curr->target == EMSCRIPTEN_ASM_CONST) {
        auto arg = curr->operands[0]->cast<Const>();
        size_t segmentIndex = parent->addressSegments[arg->value.geti32()];
        std::string code = escape(parent->wasm.memory.segments[segmentIndex].data);
        int32_t id;
        if (ids.count(code) == 0) {
          id = ids.size();
          ids[code] = id;
        } else {
          id = ids[code];
        }
        std::string sig = getSig(curr);
        sigsForCode[code].insert(sig);
        std::string fixedTarget = EMSCRIPTEN_ASM_CONST.str + std::string("_") + sig;
        curr->target = cashew::IString(fixedTarget.c_str(), false);
        arg->value = Literal(id);
        // add import, if necessary
        if (allSigs.count(sig) == 0) {
          allSigs.insert(sig);
          auto import = parent->wasm.allocator.alloc<Import>();
          import->name = import->base = curr->target;
          import->module = ENV;
          import->type = ensureFunctionType(getSig(curr), &parent->wasm, parent->wasm.allocator);
          parent->wasm.addImport(import);
        }
      }
    }

    std::string escape(const char *input) {
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
        if (curr == 0 || code[curr-1] != '\\') {
          code = code.replace(curr, 1, "\\" "\"");
          curr += 2; // skip this one
        } else { // already escaped, escape the slash as well
          code = code.replace(curr, 1, "\\" "\\" "\"");
          curr += 3; // skip this one
        }
      }
      return code;
    }
  };
  AsmConstWalker walker;
  walker.parent = this;
  walker.startWalk(&wasm);
  // print
  o << "\"asmConsts\": {";
  bool first = true;
  for (auto& pair : walker.sigsForCode) {
    auto& code = pair.first;
    auto& sigs = pair.second;
    if (first) first = false;
    else o << ",";
    o << '"' << walker.ids[code] << "\": [\"" << code << "\", ";
    printSet(o, sigs);
    o << "]";
  }
  o << "}";
  o << ",";
  o << "\"staticBump\": " << (nextStatic - globalBase) << ", ";

  o << "\"initializers\": [";
  first = true;
  for (const auto& func : initializerFunctions) {
    if (first) first = false;
    else o << ", ";
    o << "\"" << func.c_str() << "\"";
  }
  o << "]";

  o << " }";
}

void Linker::makeDynCallThunks() {
  std::unordered_set<std::string> sigs;
  wasm::Builder wasmBuilder(wasm);
  for (const auto& indirectFunc : wasm.table.names) {
    std::string sig(getSig(wasm.getFunction(indirectFunc)));
    auto* funcType = ensureFunctionType(sig, &wasm, wasm.allocator);
    if (!sigs.insert(sig).second) continue; // Sig is already in the set
    std::vector<NameType> params;
    params.emplace_back("fptr", i32); // function pointer param
    int p = 0;
    for (const auto& ty : funcType->params) params.emplace_back("$" + std::to_string(p++), ty);
    Function* f = wasmBuilder.makeFunction(std::string("dynCall_") + sig, std::move(params), funcType->result, {});
    Expression* fptr = wasmBuilder.makeGetLocal(0, i32);
    std::vector<Expression*> args;
    for (unsigned i = 0; i < funcType->params.size(); ++i) {
      args.push_back(wasmBuilder.makeGetLocal(i + 1, funcType->params[i]));
    }
    Expression* call = wasmBuilder.makeCallIndirect(funcType, fptr, std::move(args));
    f->body = funcType->result == none ? call : wasmBuilder.makeReturn(call);
    wasm.addFunction(f);
    exportFunction(f->name, true);
  }
}
