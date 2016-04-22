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
  exe.addStatic(pointerSize, pointerSize, "__stack_pointer");
  if (stackAllocation) {
    // If we are allocating the stack, set up a relocation to initialize the
    // stack pointer to point to one past-the-end of the stack allocation.
    auto* raw = new uint32_t;
    exe.addRelocation(LinkerObject::Relocation::kData, raw, ".stack", stackAllocation);
    assert(exe.wasm.memory.segments.size() == 0);
    exe.addSegment("__stack_pointer", reinterpret_cast<char*>(raw), pointerSize);
  }
}

void Linker::layout() {
  // Allocate all user statics
  for (const auto& obj : exe.staticObjects) {
    allocateStatic(obj.allocSize, obj.alignment, obj.name);
  }

  // Update the segments with their addresses now that they have been allocated.
  for (auto& seg : exe.segments) {
    size_t address = staticAddresses[seg.first];
    exe.wasm.memory.segments[seg.second].offset = address;
    segmentsByAddress[address] = seg.second;
  }

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
    exe.wasm.memory.initial = userInitialMemory / Memory::kPageSize;
  } else {
    exe.wasm.memory.initial = initialMem / Memory::kPageSize;
  }

  if (userMaxMemory) exe.wasm.memory.max = userMaxMemory / Memory::kPageSize;
  exe.wasm.memory.exportName = MEMORY;

  // XXX For now, export all functions marked .globl.
  for (Name name : exe.globls) exportFunction(name, false);
  for (Name name : exe.initializerFunctions) exportFunction(name, true);

  auto ensureFunctionIndex = [this](Name name) {
    if (functionIndexes.count(name) == 0) {
      functionIndexes[name] = exe.wasm.table.names.size();
      exe.wasm.table.names.push_back(name);
      if (debug) {
        std::cerr << "function index: " << name << ": "
                  << functionIndexes[name] << '\n';
      }
    }
  };
  for (auto& relocation : exe.relocations) {
    Name name = relocation->symbol;
    if (debug) std::cerr << "fix relocation " << name << '\n';

    if (relocation->kind == LinkerObject::Relocation::kData) {
      const auto& symbolAddress = staticAddresses.find(name);
      assert(symbolAddress != staticAddresses.end());
      *(relocation->data) = symbolAddress->second + relocation->addend;
      if (debug) std::cerr << "  ==> " << *(relocation->data) << '\n';
    } else {
      // function address
      name = exe.resolveAlias(name);
      if (!exe.wasm.checkFunction(name)) {
        std::cerr << "Unknown symbol: " << name << '\n';
        if (!ignoreUnknownSymbols) Fatal() << "undefined reference\n";
        *(relocation->data) = 0;
      } else {
        ensureFunctionIndex(name);
        *(relocation->data) = functionIndexes[name] + relocation->addend;
      }
    }
  }
  if (!!startFunction) {
    if (exe.implementedFunctions.count(startFunction) == 0) {
      Fatal() << "Unknown start function: `" << startFunction << "`\n";
    }
    const auto *target = exe.wasm.getFunction(startFunction);
    Name start("_start");
    if (exe.implementedFunctions.count(start) != 0) {
      Fatal() << "Start function already present: `" << start << "`\n";
    }
    auto* func = exe.wasm.allocator.alloc<Function>();
    func->name = start;
    exe.wasm.addFunction(func);
    exportFunction(start, true);
    exe.wasm.addStart(start);
    auto* block = exe.wasm.allocator.alloc<Block>();
    func->body = block;
    {
      // Create the call, matching its parameters.
      // TODO allow calling with non-default values.
      auto* call = exe.wasm.allocator.alloc<Call>();
      call->target = startFunction;
      size_t paramNum = 0;
      for (WasmType type : target->params) {
        Name name = Name::fromInt(paramNum++);
        Builder::addVar(func, name, type);
        auto* param = exe.wasm.allocator.alloc<GetLocal>();
        param->index = func->getLocalIndex(name);
        param->type = type;
        call->operands.push_back(param);
      }
      block->list.push_back(call);
      block->finalize();
    }
  }

  // ensure an explicit function type for indirect call targets
  for (auto& name : exe.wasm.table.names) {
    auto* func = exe.wasm.getFunction(name);
    func->type = ensureFunctionType(getSig(func), &exe.wasm, exe.wasm.allocator)->name;
  }
}

void Linker::emscriptenGlue(std::ostream& o) {
  if (debug) {
    WasmPrinter::printModule(&exe.wasm, std::cerr);
  }

  exe.wasm.removeImport(EMSCRIPTEN_ASM_CONST); // we create _sig versions

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
        size_t segmentIndex = parent->segmentsByAddress[arg->value.geti32()];
        std::string code = escape(parent->exe.wasm.memory.segments[segmentIndex].data);
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
          auto import = parent->exe.wasm.allocator.alloc<Import>();
          import->name = import->base = curr->target;
          import->module = ENV;
          import->type = ensureFunctionType(getSig(curr), &parent->exe.wasm, parent->exe.wasm.allocator);
          parent->exe.wasm.addImport(import);
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
  walker.startWalk(&exe.wasm);
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
  for (const auto& func : exe.initializerFunctions) {
    if (first) first = false;
    else o << ", ";
    o << "\"" << func.c_str() << "\"";
  }
  o << "]";

  o << " }";
}

void Linker::makeDynCallThunks() {
  std::unordered_set<std::string> sigs;
  wasm::Builder wasmBuilder(exe.wasm);
  for (const auto& indirectFunc : exe.wasm.table.names) {
    std::string sig(getSig(exe.wasm.getFunction(indirectFunc)));
    auto* funcType = ensureFunctionType(sig, &exe.wasm, exe.wasm.allocator);
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
    exe.wasm.addFunction(f);
    exportFunction(f->name, true);
  }
}
