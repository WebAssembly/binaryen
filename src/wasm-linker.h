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

#include "support/utilities.h"
#include "wasm.h"

namespace wasm {

// Wasm module linking/layout information
class Linker {
 public:
  struct Relocation {
    uint32_t* data;
    Name value;
    int offset;
    Relocation(uint32_t* data, Name value, int offset) :
        data(data), value(value), offset(offset) {}
  };

  Linker(Module& wasm, size_t globalBase, size_t stackAllocation,
               size_t userInitialMemory, size_t userMaxMemory,
               bool ignoreUnknownSymbols, Name startFunction,
               bool debug) :
      wasm(wasm),
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
    allocateStatic(4, 4, "__dso_handle");
  }

  // Allocate a static variable and return its address in linear memory
  size_t allocateStatic(size_t allocSize, size_t alignment, Name name) {
    size_t address = alignAddr(nextStatic, alignment);
    staticAddresses[name] = address;
    nextStatic = address + allocSize;
    return address;
  }

  // Allocate space for a stack pointer and (if stackAllocation > 0) set up a
  // relocation for it to point to the top of the stack.
  void placeStackPointer(size_t stackAllocation);
  void addGlobal(Name name) {
    globls.push_back(name);
  }

  void addRelocation(uint32_t* target, Name name, int offset) {
    relocations.emplace_back(make_unique<Relocation>(target, name, offset));
  }
  Relocation* getCurrentRelocation() {
    return relocations.back().get();
  }

  void addImplementedFunction(Name name) {
    implementedFunctions.insert(name);
  }
  bool isFunctionImplemented(Name name) {
    return implementedFunctions.count(name) != 0;
  }

  void addAliasedFunction(Name name, Name alias) {
    aliasedFunctions.insert({name, alias});
  }
  // If name is an alias, return what it points to. Otherwise return name
  Name resolveAlias(Name name) {
    auto aliased = aliasedFunctions.find(name);
    if (aliased != aliasedFunctions.end()) return aliased->second;
    return name;
  }

  void addAddressSegment(size_t address, const char* data, size_t size) {
    addressSegments[address] = wasm.memory.segments.size();
    wasm.memory.segments.emplace_back(address, data, size);
  }

  void addInitializerFunction(Name name) {
    initializerFunctions.emplace_back(name);
    assert(implementedFunctions.count(name));
  }

  // Allocate the user stack, set up the initial memory size of the module, lay
  // out the linear memory, process the relocations, and set up the indirect
  // function table.
  void layout();

  // Support for emscripten integration: generates dyncall thunks, emits
  // metadata for asmConsts, staticBump and initializer functions.
  void emscriptenGlue(std::ostream& o);

 private:
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

  static size_t roundUpToPageSize(size_t size) {
    return (size + Memory::kPageSize - 1) & Memory::kPageMask;
  }

  void exportFunction(Name name, bool must_export) {
    if (!wasm.checkFunction(name)) {
      assert(!must_export);
      return;
    }
    if (wasm.checkExport(name)) return; // Already exported
    auto exp = wasm.allocator.alloc<Export>();
    exp->name = exp->value = name;
    wasm.addExport(exp);
  }


  Module& wasm;
  bool ignoreUnknownSymbols;
  Name startFunction;
  std::vector<Name> globls;

  // where globals can start to be statically allocated, i.e., the data segment
  size_t globalBase;
  size_t nextStatic; // location of next static allocation
  size_t userInitialMemory; // Initial memory size (in bytes) specified by the user.
  size_t userMaxMemory; // Max memory size (in bytes) specified by the user.
  //(after linking, this is rounded and set on the wasm object in pages)
  size_t stackAllocation;
  bool debug;

  std::map<Name, int32_t> staticAddresses; // name => address

  std::vector<std::unique_ptr<Relocation>> relocations;

  std::set<Name> implementedFunctions;
  std::map<Name, Name> aliasedFunctions;

  std::map<size_t, size_t> addressSegments; // address => segment index

  std::map<Name, size_t> functionIndexes;

  std::vector<Name> initializerFunctions;

};


}
#endif // WASM_WASM_LINK_H
