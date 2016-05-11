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

// (very) basic linking functionality for s2wasm.
// Performs some of the tasks that will eventually be done by a real linker.
// Currently can allocate static variables and the stack, lay out memory
// and initial segment contents, and process relocations. (In particular, there
// is no merging of multiple modules). Currently this is only inteded to turn
// a .s file produced by LLVM into a usable wast file.

#ifndef WASM_WASM_LINK_H
#define WASM_WASM_LINK_H

#include "support/archive.h"
#include "support/utilities.h"
#include "wasm.h"

namespace wasm {

class S2WasmBuilder;

// An "object file" for linking. Contains a wasm module, plus the associated
// information needed for linking/layout.
class LinkerObject {
 public:
  struct Relocation {
    enum Kind { kData, kFunction };
    Kind kind; // Whether the symbol refers to data or a function.
    // Instead of section offsets as relocation targets, for now this is just
    // a pointer to the memory to rewrite.
    uint32_t* data;
    Name symbol; // Like the symbol index in ELF r_info field
    int addend; // Like the ELF r_addend field
    Relocation(Kind kind, uint32_t* data, Name symbol, int addend) :
        kind(kind), data(data), symbol(symbol), addend(addend) {}
  };
  // Information about symbols
  struct SymbolInfo {
    std::unordered_set<cashew::IString> implementedFunctions;
    std::unordered_set<cashew::IString> undefinedFunctions;
    // TODO: it's not clear that this really belongs here.
    std::unordered_map<cashew::IString, Name> aliasedFunctions;

    // For now, do not support weak symbols or anything special. Just directly
    // merge the functions together, and remove any newly-defined functions
    // from undefinedFunction
    void merge(SymbolInfo& other) {
      for (const auto& func : other.implementedFunctions) {
        undefinedFunctions.erase(func);
      }
      implementedFunctions.insert(other.implementedFunctions.begin(),
                                  other.implementedFunctions.end());
      aliasedFunctions.insert(other.aliasedFunctions.begin(),
                              other.aliasedFunctions.end());
    }
  };

  LinkerObject() {}

  // Allocate a static object
  void addStatic(Address allocSize, Address alignment, Name name) {
    staticObjects.emplace_back(allocSize, alignment, name);
  }

  void addGlobal(Name name) {
    globls.push_back(name);
  }

  void addRelocation(Relocation::Kind kind, uint32_t* target, Name name, int addend) {
    relocations.emplace_back(new Relocation(kind, target, name, addend));
  }
  Relocation* getCurrentRelocation() {
    return relocations.back().get();
  }


  bool isFunctionImplemented(Name name) {
    return symbolInfo.implementedFunctions.count(name) != 0;
  }

  // If name is an alias, return what it points to. Otherwise return name
  Name resolveAlias(Name name) {
    auto aliased = symbolInfo.aliasedFunctions.find(name);
    if (aliased != symbolInfo.aliasedFunctions.end()) return aliased->second;
    return name;
  }

  // Add an initializer segment for the named static variable.
  void addSegment(Name name, const char* data, Address size) {
    segments[name] = wasm.memory.segments.size();
    wasm.memory.segments.emplace_back(0, data, size);
  }

  void addSegment(Name name, std::vector<char>& data) {
    segments[name] = wasm.memory.segments.size();
    wasm.memory.segments.emplace_back(0, data);
  }

  void addInitializerFunction(Name name) {
    initializerFunctions.emplace_back(name);
    assert(symbolInfo.implementedFunctions.count(name));
  }

  void addUndefinedFunctionCall(Call* call) {
    symbolInfo.undefinedFunctions.insert(call->target);
    undefinedFunctionCalls[call->target].push_back(call);
  }

  bool isEmpty() {
    return wasm.functions.empty();
  }

  friend class Linker;

  Module wasm;

 private:
  struct StaticObject {
    Address allocSize;
    Address alignment;
    Name name;
    StaticObject(Address allocSize, Address alignment, Name name) :
        allocSize(allocSize), alignment(alignment), name(name) {}
  };

  std::vector<Name> globls;

  std::vector<StaticObject> staticObjects;
  std::vector<std::unique_ptr<Relocation>> relocations;

  SymbolInfo symbolInfo;

  using CallList = std::vector<Call*>;
  std::map<Name, CallList> undefinedFunctionCalls;

  std::map<Name, Address> segments; // name => segment index (in wasm module)

  std::vector<Name> initializerFunctions;

  LinkerObject(const LinkerObject&) = delete;
  LinkerObject& operator=(const LinkerObject&) = delete;

};

// Class which performs some linker-like functionality; namely taking an object
// file with relocations, laying out the linear memory and segments, and
// applying the relocations, resulting in an executable wasm module.
class Linker {
 public:
  Linker(Address globalBase, Address stackAllocation,
         Address userInitialMemory, Address userMaxMemory,
         bool ignoreUnknownSymbols, Name startFunction,
         bool debug) :
      ignoreUnknownSymbols(ignoreUnknownSymbols),
      startFunction(startFunction),
      globalBase(globalBase),
      nextStatic(globalBase),
      userInitialMemory(userInitialMemory),
      userMaxMemory(userMaxMemory),
      stackAllocation(stackAllocation),
      debug(debug) {
    if (userMaxMemory && userMaxMemory < userInitialMemory) {
      Fatal() << "Specified max memory " << userMaxMemory <<
          " is < specified initial memory " << userInitialMemory;
    }
    if (roundUpToPageSize(userMaxMemory) != userMaxMemory) {
      Fatal() << "Specified max memory " << userMaxMemory <<
          " is not a multiple of 64k";
    }
    if (roundUpToPageSize(userInitialMemory) != userInitialMemory) {
      Fatal() << "Specified initial memory " << userInitialMemory <<
          " is not a multiple of 64k";
    }
    // Don't allow anything to be allocated at address 0
    if (globalBase == 0) nextStatic = 1;

    // Place the stack pointer at the bottom of the linear memory, to keep its
    // address small (and thus with a small encoding).
    placeStackPointer(stackAllocation);
    // Allocate __dso_handle. For asm.js, emscripten provides this in JS, but
    // wasm modules can't import data objects. Its value is 0 for the main
    // executable, which is all we have with static linking. In the future this
    // can go in a crtbegin or similar file.
    out.addStatic(4, 4, "__dso_handle");
  }

  // Return a reference to the LinkerObject for the main executable. If empty,
  // it can be passed to an S2WasmBuilder and constructed.
  LinkerObject& getOutput() { return out; }

  // Allocate the user stack, set up the initial memory size of the module, lay
  // out the linear memory, process the relocations, and set up the indirect
  // function table.
  void layout();

  // Support for emscripten integration: generates dyncall thunks, emits
  // metadata for asmConsts, staticBump and initializer functions.
  void emscriptenGlue(std::ostream& o);

  // Add an object to the link by constructing it in-place with a builder.
  // Returns false if an error occurred.
  bool linkObject(S2WasmBuilder& builder);

  // Add an archive to the link. Any objects in the archive that satisfy a
  // currently-undefined reference will be added to the link.
  // Returns false if an error occurred.
  bool linkArchive(Archive& archive);

 private:
  // Allocate a static variable and return its address in linear memory
  Address allocateStatic(Address allocSize, Address alignment, Name name) {
    Address address = alignAddr(nextStatic, alignment);
    staticAddresses[name] = address;
    nextStatic = address + allocSize;
    return address;
  }

  // Allocate space for a stack pointer and (if stackAllocation > 0) set up a
  // relocation for it to point to the top of the stack.
  void placeStackPointer(Address stackAllocation);

  template<class C>
  void printSet(std::ostream& o, C& c) {
    o << "[";
    bool first = true;
    for (auto& item : c) {
      if (first) first = false;
      else o << ",";
      o << '"' << item << '"';
    }
    o << "]";
  }

  // Create thunks for use with emscripten Runtime.dynCall. Creates one for each
  // signature in the indirect function table.
  void makeDynCallThunks();

  static Address roundUpToPageSize(Address size) {
    return (size + Memory::kPageSize - 1) & Memory::kPageMask;
  }

  void exportFunction(Name name, bool must_export) {
    if (!out.wasm.checkFunction(name)) {
      assert(!must_export);
      return;
    }
    if (out.wasm.checkExport(name)) return; // Already exported
    auto exp = new Export;
    exp->name = exp->value = name;
    out.wasm.addExport(exp);
  }

  // The output module (linked executable)
  LinkerObject out;

  bool ignoreUnknownSymbols;
  Name startFunction;

  // where globals can start to be statically allocated, i.e., the data segment
  Address globalBase;
  Address nextStatic; // location of next static allocation
  Address userInitialMemory; // Initial memory size (in bytes) specified by the user.
  Address userMaxMemory; // Max memory size (in bytes) specified by the user.
  //(after linking, this is rounded and set on the wasm object in pages)
  Address stackAllocation;
  bool debug;

  std::unordered_map<cashew::IString, int32_t> staticAddresses; // name => address
  std::unordered_map<Address, Address> segmentsByAddress; // address => segment index
  std::unordered_map<cashew::IString, size_t> functionIndexes;

};


}
#endif // WASM_WASM_LINK_H
