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
#include "ir/utils.h"
#include "s2wasm.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm-emscripten.h"
#include "wasm-printing.h"

using namespace wasm;

// Name of the dummy function to prevent erroneous nullptr comparisons.
static constexpr const char* dummyFunction = "__wasm_nullptr";
static constexpr const char* stackPointer = "__stack_pointer";

void Linker::placeStackPointer(Address stackAllocation) {
  // ensure this is the first allocation
  assert(nextStatic == globalBase || nextStatic == 1);
  const Address pointerSize = 4;
  // Unconditionally allocate space for the stack pointer. Emscripten
  // allocates the stack itself, and initializes the stack pointer itself.
  out.addStatic(pointerSize, pointerSize, stackPointer);
  if (stackAllocation) {
    // If we are allocating the stack, set up a relocation to initialize the
    // stack pointer to point to one past-the-end of the stack allocation.
    std::vector<char> raw;
    raw.resize(pointerSize);
    auto relocation = new LinkerObject::Relocation(
      LinkerObject::Relocation::kData, (uint32_t*)&raw[0], ".stack", stackAllocation);
    out.addRelocation(relocation);
    assert(out.wasm.memory.segments.empty());
    out.addSegment(stackPointer, raw);
  }
}

void Linker::ensureFunctionImport(Name target, std::string signature) {
  if (!out.wasm.getImportOrNull(target)) {
    auto import = new Import;
    import->name = import->base = target;
    import->module = ENV;
    import->functionType = ensureFunctionType(signature, &out.wasm)->name;
    import->kind = ExternalKind::Function;
    out.wasm.addImport(import);
  }
}

void Linker::ensureObjectImport(Name target) {
  if (!out.wasm.getImportOrNull(target)) {
    auto import = new Import;
    import->name = import->base = target;
    import->module = ENV;
    import->kind = ExternalKind::Global;
    import->globalType = i32;
    out.wasm.addImport(import);
  }
}

void Linker::layout() {
  // Convert calls to undefined functions to call_imports
  for (const auto& f : out.undefinedFunctionCalls) {
    Name target = f.first;
    if (!out.symbolInfo.undefinedFunctions.count(target)) continue;
    // Create an import for the target if necessary.
    ensureFunctionImport(target, getSig(*f.second.begin()));
    // Change each call. The target is the same since it's still the name.
    // Delete and re-allocate the Expression as CallImport to avoid undefined
    // behavior.
    for (auto* call : f.second) {
      auto type = call->type;
      ExpressionList operands(out.wasm.allocator);
      operands.swap(call->operands);
      auto target = call->target;
      CallImport* newCall = ExpressionManipulator::convert<Call, CallImport>(call, out.wasm.allocator);
      newCall->type = type;
      newCall->operands.swap(operands);
      newCall->target = target;
    }
  }

  // Allocate all user statics
  for (const auto& obj : out.staticObjects) {
    allocateStatic(obj.allocSize, obj.alignment, obj.name);
  }

  // Update the segments with their addresses now that they have been allocated.
  for (const auto& seg : out.segments) {
    Address address = staticAddresses[seg.first];
    out.wasm.memory.segments[seg.second].offset = out.wasm.allocator.alloc<Const>()->set(Literal(uint32_t(address)));
    segmentsByAddress[address] = seg.second;
  }

  // Place the stack after the user's static data, to keep those addresses
  // small.
  if (stackAllocation) allocateStatic(stackAllocation, 16, ".stack");

  // The minimum initial memory size is the amount of static variables we have
  // allocated. Round it up to a page, and update the page-increment versions
  // of initial and max
  Address initialMem = roundUpToPageSize(nextStatic);
  if (userInitialMemory) {
    if (initialMem > userInitialMemory) {
      Fatal() << "Specified initial memory size " << userInitialMemory <<
          " is smaller than required size " << initialMem;
    }
    out.wasm.memory.initial = userInitialMemory / Memory::kPageSize;
  } else {
    out.wasm.memory.initial = initialMem / Memory::kPageSize;
  }
  out.wasm.memory.exists = true;

  if (userMaxMemory) out.wasm.memory.max = userMaxMemory / Memory::kPageSize;

  if (importMemory) {
    auto memoryImport = make_unique<Import>();
    memoryImport->name = MEMORY;
    memoryImport->module = ENV;
    memoryImport->base = MEMORY;
    memoryImport->kind = ExternalKind::Memory;
    out.wasm.memory.imported = true;
    out.wasm.addImport(memoryImport.release());
  } else {
    auto memoryExport = make_unique<Export>();
    memoryExport->name = MEMORY;
    memoryExport->value = Name::fromInt(0);
    memoryExport->kind = ExternalKind::Memory;
    out.wasm.addExport(memoryExport.release());
  }

  // Add imports for any imported objects
  for (const auto& obj : out.symbolInfo.importedObjects) {
    ensureObjectImport(obj);
  }

  // XXX For now, export all functions marked .globl.
  for (Name name : out.globls) exportFunction(out.wasm, name, false);
  for (Name name : out.initializerFunctions) exportFunction(out.wasm, name, true);

  // Pad the indirect function table with a dummy function
  makeDummyFunction();
  // Always create a table, even if it's empty.
  out.wasm.table.exists = true;

  // Pre-assign the function indexes
  for (auto& pair : out.indirectIndexes) {
    if (functionIndexes.count(pair.first) != 0 ||
        functionNames.count(pair.second) != 0) {
      Fatal() << "Function " << pair.first << " already has an index " <<
          functionIndexes[pair.first] << " while setting index " << pair.second;
    }
    if (debug) {
      std::cerr << "pre-assigned function index: " << pair.first << ": "
                << pair.second << '\n';
    }
    functionIndexes[pair.first] = pair.second;
    functionNames[pair.second] = pair.first;
  }

  // Emit the pre-assigned function names in sorted order
  for (const auto& P : functionNames) {
    ensureTableSegment();
    getTableDataRef().push_back(P.second);
  }

  for (auto& relocation : out.relocations) {
    // TODO: Handle weak symbols properly, instead of always taking the weak definition.
    auto *alias = out.getAlias(relocation->symbol, relocation->kind);
    Name name = relocation->symbol;

    if (debug) std::cerr << "fix relocation " << name << '\n';

    if (alias) {
      name = alias->symbol;
      relocation->addend += alias->offset;
    }

    if (relocation->kind == LinkerObject::Relocation::kData) {
      const auto& symbolAddress = staticAddresses.find(name);
      if (symbolAddress == staticAddresses.end()) Fatal() << "Unknown relocation: " << name << '\n';
      *(relocation->data) = symbolAddress->second + relocation->addend;
      if (debug) std::cerr << "  ==> " << *(relocation->data) << '\n';
    } else {
      // function address
      if (!out.wasm.getFunctionOrNull(name)) {
        if (FunctionType* f = out.getExternType(name)) {
          // Address of an imported function is taken, but imports do not have addresses in wasm.
          // Generate a thunk to forward to the call_import.
          Function* thunk = getImportThunk(name, f);
          *(relocation->data) = getFunctionIndex(thunk->name) + relocation->addend;
        } else {
          std::cerr << "Unknown symbol: " << name << '\n';
          if (!ignoreUnknownSymbols) Fatal() << "undefined reference\n";
          *(relocation->data) = 0;
        }
      } else {
        *(relocation->data) = getFunctionIndex(name) + relocation->addend;
      }
    }
  }
  out.relocations.clear();

  if (!!startFunction) {
    if (out.symbolInfo.implementedFunctions.count(startFunction) == 0) {
      Fatal() << "Unknown start function: `" << startFunction << "`\n";
    }
    const auto *target = out.wasm.getFunction(startFunction);
    Name start("_start");
    if (out.symbolInfo.implementedFunctions.count(start) != 0) {
      Fatal() << "Start function already present: `" << start << "`\n";
    }
    auto* func = new Function;
    func->name = start;
    out.wasm.addFunction(func);
    out.wasm.addStart(start);
    Builder builder(out.wasm);
    auto* block = builder.makeBlock();
    func->body = block;
    {
      // Create the call, matching its parameters.
      // TODO allow calling with non-default values.
      std::vector<Expression*> args;
      Index paramNum = 0;
      for (Type type : target->params) {
        Name name = Name::fromInt(paramNum++);
        Builder::addVar(func, name, type);
        auto* param = builder.makeGetLocal(func->getLocalIndex(name), type);
        args.push_back(param);
      }
      auto* call = builder.makeCall(startFunction, args, target->result);
      Expression* e = call;
      if (target->result != none) e = builder.makeDrop(call);
      block->list.push_back(e);
      block->finalize();
    }
  }

  // ensure an explicit function type for indirect call targets
  for (auto& segment : out.wasm.table.segments) {
    for (auto& name : segment.data) {
      auto* func = out.wasm.getFunction(name);
      func->type = ensureFunctionType(getSig(func), &out.wasm)->name;
    }
  }

  // Export malloc/realloc/free/memalign whenever availble. JavsScript version of
  // malloc has some issues and it cannot be called once _sbrk() is called, and
  // JS glue code does not have realloc().  TODO This should get the list of
  // exported functions from emcc.py - it has EXPORTED_FUNCTION metadata to keep
  // track of this. Get the list of exported functions using a command-line
  // argument from emcc.py and export all of them.
  for (auto function : {"malloc", "free", "realloc", "memalign"}) {
    if (out.symbolInfo.implementedFunctions.count(function)) {
      exportFunction(out.wasm, function, true);
    }
  }

  // finalize function table
  unsigned int tableSize = getTableData().size();
  if (tableSize > 0) {
    out.wasm.table.initial = out.wasm.table.max = tableSize;
  }
}

bool Linker::linkObject(S2WasmBuilder& builder) {
  LinkerObject::SymbolInfo *newSymbols = builder.getSymbolInfo();
  // check for multiple definitions
  for (const Name& symbol : newSymbols->implementedFunctions) {
    if (out.symbolInfo.implementedFunctions.count(symbol)) {
      // TODO: Figure out error handling for library-style pieces
      // TODO: give LinkerObjects (or builders) names for better errors.
      std::cerr << "Error: multiple definition of symbol " << symbol << "\n";
      return false;
    }
  }
  // Allow duplicate aliases only if they refer to the same name. For now we
  // do not expect aliases in compiler-rt files.
  // TODO: figure out what the semantics of merging aliases should be.
  for (const auto& alias : newSymbols->aliasedSymbols) {
    if (out.symbolInfo.aliasedSymbols.count(alias.first) &&
      (out.symbolInfo.aliasedSymbols.at(alias.first).symbol != alias.second.symbol ||
      out.symbolInfo.aliasedSymbols.at(alias.first).kind != alias.second.kind)) {
      std::cerr << "Error: conflicting definitions for alias "
                << alias.first.c_str() << "of type " << alias.second.kind << "\n";
      return false;
    }
  }
  out.symbolInfo.merge(*newSymbols);
  builder.build(&out);
  return true;
}

bool Linker::linkArchive(Archive& archive) {
  bool selected;
  do {
    selected = false;
    for (auto child = archive.child_begin(), end = archive.child_end();
         child != end; ++child) {
      Archive::SubBuffer memberBuf = child->getBuffer();
      // S2WasmBuilder expects its input to be NUL-terminated. Archive members
      // are
      // not NUL-terminated. So we have to copy the contents out before parsing.
      std::vector<char> memberString(memberBuf.len + 1);
      memcpy(memberString.data(), memberBuf.data, memberBuf.len);
      memberString[memberBuf.len] = '\0';
      S2WasmBuilder memberBuilder(memberString.data(), false);
      auto* memberSymbols = memberBuilder.getSymbolInfo();
      for (const Name& symbol : memberSymbols->implementedFunctions) {
        if (out.symbolInfo.undefinedFunctions.count(symbol)) {
          if (!linkObject(memberBuilder)) return false;
          selected = true;
          break;
        }
      }
    }
    // If we selected an archive member, it may depend on another archive member
    // so continue to make passes over the members until no more are added.
  } while (selected);
  return true;
}

Address Linker::getStaticBump() const {
  return nextStatic - globalBase;
}

void Linker::ensureTableSegment() {
  if (out.wasm.table.segments.size() == 0) {
    auto emptySegment = out.wasm.allocator.alloc<Const>()->set(Literal(uint32_t(0)));
    out.wasm.table.segments.emplace_back(emptySegment);
  }
}

std::vector<Name>& Linker::getTableDataRef() {
  assert(out.wasm.table.segments.size() == 1);
  return out.wasm.table.segments[0].data;
}

std::vector<Name> Linker::getTableData() {
  if (out.wasm.table.segments.size() > 0) {
    return getTableDataRef();
  }
  return {};
}

Index Linker::getFunctionIndex(Name name) {
  if (!functionIndexes.count(name)) {
    ensureTableSegment();
    functionIndexes[name] = getTableData().size();
    getTableDataRef().push_back(name);
    if (debug) {
      std::cerr << "function index: " << name << ": "
                << functionIndexes[name] << '\n';
    }
  }
  return functionIndexes[name];
}

void Linker::makeDummyFunction() {
  bool create = false;
  // Check if there are address-taken functions
  for (auto& relocation : out.relocations) {
    if (relocation->kind == LinkerObject::Relocation::kFunction) {
      create = true;
      break;
    }
  }

  if (!create) return;
  wasm::Builder wasmBuilder(out.wasm);
  Expression *unreachable = wasmBuilder.makeUnreachable();
  Function *dummy = wasmBuilder.makeFunction(Name(dummyFunction), {}, Type::none, {}, unreachable);
  out.wasm.addFunction(dummy);
  getFunctionIndex(dummy->name);
}

Function* Linker::getImportThunk(Name name, const FunctionType* funcType) {
  Name thunkName = std::string("__importThunk_") + name.c_str();
  if (Function* thunk = out.wasm.getFunctionOrNull(thunkName)) return thunk;
  ensureFunctionImport(name, getSig(funcType));
  wasm::Builder wasmBuilder(out.wasm);
  std::vector<NameType> params;
  Index p = 0;
  for (const auto& ty : funcType->params) params.emplace_back(std::to_string(p++), ty);
  Function *f = wasmBuilder.makeFunction(thunkName, std::move(params), funcType->result, {});
  std::vector<Expression*> args;
  for (Index i = 0; i < funcType->params.size(); ++i) {
    args.push_back(wasmBuilder.makeGetLocal(i, funcType->params[i]));
  }
  Expression* call = wasmBuilder.makeCallImport(name, args, funcType->result);
  f->body = call;
  out.wasm.addFunction(f);
  return f;
}

Address Linker::getStackPointerAddress() const {
  return Address(staticAddresses.at(stackPointer));
}
