/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_ir_module_h
#define wasm_ir_module_h

#include "pass.h"
#include "support/insert_ordered.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm::ModuleUtils {

// Copies a function into a module. If newName is provided it is used as the
// name of the function (otherwise the original name is copied). If fileIndexMap
// is specified, it is used to rename source map filename indices when copying
// the function from one module to another one.
Function*
copyFunction(Function* func,
             Module& out,
             Name newName = Name(),
             std::optional<std::vector<Index>> fileIndexMap = std::nullopt);

// As above, but does not add the copy to the module.
std::unique_ptr<Function> copyFunctionWithoutAdd(
  Function* func,
  Module& out,
  Name newName = Name(),
  std::optional<std::vector<Index>> fileIndexMap = std::nullopt);

Global* copyGlobal(Global* global, Module& out);

Tag* copyTag(Tag* tag, Module& out);

ElementSegment* copyElementSegment(const ElementSegment* segment, Module& out);

Table* copyTable(const Table* table, Module& out);

Memory* copyMemory(const Memory* memory, Module& out);

DataSegment* copyDataSegment(const DataSegment* segment, Module& out);

// Copies named toplevel module items (things of kind ModuleItemKind). See
// copyModule() for something that also copies exports, the start function, etc.
void copyModuleItems(const Module& in, Module& out);

void copyModule(const Module& in, Module& out);

void clearModule(Module& wasm);

// Renaming

// Rename functions along with all their uses.
// Note that for this to work the functions themselves don't necessarily need
// to exist.  For example, it is possible to remove a given function and then
// call this to redirect all of its uses.
template<typename T> void renameFunctions(Module& wasm, T& map);

void renameFunction(Module& wasm, Name oldName, Name newName);

// Convenient iteration over imported/non-imported module elements

template<typename T> inline void iterImportedMemories(Module& wasm, T visitor) {
  for (auto& import : wasm.memories) {
    if (import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T> inline void iterDefinedMemories(Module& wasm, T visitor) {
  for (auto& import : wasm.memories) {
    if (!import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T>
inline void iterMemorySegments(Module& wasm, Name memory, T visitor) {
  for (auto& segment : wasm.dataSegments) {
    if (!segment->isPassive && segment->memory == memory) {
      visitor(segment.get());
    }
  }
}

template<typename T>
inline void iterActiveDataSegments(Module& wasm, T visitor) {
  for (auto& segment : wasm.dataSegments) {
    if (!segment->isPassive) {
      visitor(segment.get());
    }
  }
}

template<typename T> inline void iterImportedTables(Module& wasm, T visitor) {
  for (auto& import : wasm.tables) {
    if (import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T> inline void iterDefinedTables(Module& wasm, T visitor) {
  for (auto& import : wasm.tables) {
    if (!import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T>
inline void iterTableSegments(Module& wasm, Name table, T visitor) {
  // Just a precaution so that we don't iterate over passive elem segments by
  // accident
  assert(table.is() && "Table name must not be null");

  for (auto& segment : wasm.elementSegments) {
    if (segment->table == table) {
      visitor(segment.get());
    }
  }
}

template<typename T>
inline void iterActiveElementSegments(Module& wasm, T visitor) {
  for (auto& segment : wasm.elementSegments) {
    if (segment->table.is()) {
      visitor(segment.get());
    }
  }
}

template<typename T> inline void iterImportedGlobals(Module& wasm, T visitor) {
  for (auto& import : wasm.globals) {
    if (import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T> inline void iterDefinedGlobals(Module& wasm, T visitor) {
  for (auto& import : wasm.globals) {
    if (!import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T>
inline void iterImportedFunctions(Module& wasm, T visitor) {
  for (auto& import : wasm.functions) {
    if (import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T> inline void iterDefinedFunctions(Module& wasm, T visitor) {
  for (auto& import : wasm.functions) {
    if (!import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T> inline void iterImportedTags(Module& wasm, T visitor) {
  for (auto& import : wasm.tags) {
    if (import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T> inline void iterDefinedTags(Module& wasm, T visitor) {
  for (auto& import : wasm.tags) {
    if (!import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T> inline void iterImports(Module& wasm, T visitor) {
  iterImportedMemories(wasm, visitor);
  iterImportedTables(wasm, visitor);
  iterImportedGlobals(wasm, visitor);
  iterImportedFunctions(wasm, visitor);
  iterImportedTags(wasm, visitor);
}

// Iterates over all importable module items. The visitor provided should have
// signature void(ExternalKind, Importable*).
template<typename T> inline void iterImportable(Module& wasm, T visitor) {
  for (auto& curr : wasm.functions) {
    if (curr->imported()) {
      visitor(ExternalKind::Function, curr.get());
    }
  }
  for (auto& curr : wasm.tables) {
    if (curr->imported()) {
      visitor(ExternalKind::Table, curr.get());
    }
  }
  for (auto& curr : wasm.memories) {
    if (curr->imported()) {
      visitor(ExternalKind::Memory, curr.get());
    }
  }
  for (auto& curr : wasm.globals) {
    if (curr->imported()) {
      visitor(ExternalKind::Global, curr.get());
    }
  }
  for (auto& curr : wasm.tags) {
    if (curr->imported()) {
      visitor(ExternalKind::Tag, curr.get());
    }
  }
}

// Iterates over all module items. The visitor provided should have signature
// void(ModuleItemKind, Named*).
template<typename T> inline void iterModuleItems(Module& wasm, T visitor) {
  for (auto& curr : wasm.functions) {
    visitor(ModuleItemKind::Function, curr.get());
  }
  for (auto& curr : wasm.tables) {
    visitor(ModuleItemKind::Table, curr.get());
  }
  for (auto& curr : wasm.memories) {
    visitor(ModuleItemKind::Memory, curr.get());
  }
  for (auto& curr : wasm.globals) {
    visitor(ModuleItemKind::Global, curr.get());
  }
  for (auto& curr : wasm.tags) {
    visitor(ModuleItemKind::Tag, curr.get());
  }
  for (auto& curr : wasm.dataSegments) {
    visitor(ModuleItemKind::DataSegment, curr.get());
  }
  for (auto& curr : wasm.elementSegments) {
    visitor(ModuleItemKind::ElementSegment, curr.get());
  }
}

// Helper class for performing an operation on all the functions in the module,
// in parallel, with an Info object for each one that can contain results of
// some computation that the operation performs.
// The operation performed should not modify the wasm module in any way, by
// default - otherwise, set the Mutability to Mutable. (This is not enforced at
// compile time - TODO find a way - but at runtime in pass-debug mode it is
// checked.)
template<typename K, typename V> using DefaultMap = std::map<K, V>;
template<typename T,
         Mutability Mut = Immutable,
         template<typename, typename> class MapT = DefaultMap>
struct ParallelFunctionAnalysis {
  Module& wasm;

  using Map = MapT<Function*, T>;
  Map map;

  using Func = std::function<void(Function*, T&)>;

  ParallelFunctionAnalysis(Module& wasm, Func work) : wasm(wasm) {
    // Fill in the map as we operate on it in parallel (each function to its own
    // entry).
    for (auto& func : wasm.functions) {
      map[func.get()];
    }

    doAnalysis(work);
  }

  // Perform an analysis by operating on each function, in parallel.
  //
  // This is called from the constructor (with the work function given there),
  // and can also be called later as well if the user has additional operations
  // to perform.
  void doAnalysis(Func work) {
    // Run on the imports first. TODO: parallelize this too
    for (auto& func : wasm.functions) {
      if (func->imported()) {
        work(func.get(), map[func.get()]);
      }
    }

    struct Mapper : public WalkerPass<PostWalker<Mapper>> {
      bool isFunctionParallel() override { return true; }
      bool modifiesBinaryenIR() override { return Mut; }

      Mapper(Module& module, Map& map, Func work)
        : module(module), map(map), work(work) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<Mapper>(module, map, work);
      }

      void doWalkFunction(Function* curr) {
        assert(map.count(curr));
        work(curr, map[curr]);
      }

    private:
      Module& module;
      Map& map;
      Func work;
    };

    PassRunner runner(&wasm);
    Mapper(wasm, map, work).run(&runner, &wasm);
  }
};

// Helper class for analyzing the call graph.
//
// Provides hooks for running some initial calculation on each function (which
// is done in parallel), writing to a FunctionInfo structure for each function.
// Then you can call propagateBack() to propagate a property of interest to the
// calling functions, transitively.
//
// For example, if some functions are known to call an import "foo", then you
// can use this to find which functions call something that might eventually
// reach foo, by initially marking the direct callers as "calling foo" and
// propagating that backwards.
template<typename T> struct CallGraphPropertyAnalysis {
  Module& wasm;

  // The basic information for each function about whom it calls and who is
  // called by it.
  struct FunctionInfo {
    std::set<Function*> callsTo;
    std::set<Function*> calledBy;
    // A non-direct call is any call that is not direct. That includes
    // CallIndirect and CallRef.
    bool hasNonDirectCall = false;
  };

  using Map = std::map<Function*, T>;
  Map map;

  using Func = std::function<void(Function*, T&)>;

  CallGraphPropertyAnalysis(Module& wasm, Func work) : wasm(wasm) {
    ParallelFunctionAnalysis<T> analysis(wasm, [&](Function* func, T& info) {
      work(func, info);
      if (func->imported()) {
        return;
      }
      struct Mapper : public PostWalker<Mapper> {
        Mapper(Module* module, T& info, Func work)
          : module(module), info(info), work(work) {}

        void visitCall(Call* curr) {
          info.callsTo.insert(module->getFunction(curr->target));
        }
        void visitCallIndirect(CallIndirect* curr) {
          info.hasNonDirectCall = true;
        }
        void visitCallRef(CallRef* curr) { info.hasNonDirectCall = true; }

      private:
        Module* module;
        T& info;
        Func work;
      } mapper(&wasm, info, work);
      mapper.walk(func->body);
    });

    map.swap(analysis.map);

    // Find what is called by what.
    for (auto& [func, info] : map) {
      for (auto* target : info.callsTo) {
        map[target].calledBy.insert(func);
      }
    }
  }

  enum NonDirectCalls { IgnoreNonDirectCalls, NonDirectCallsHaveProperty };

  // Propagate a property from a function to those that call it.
  //
  // hasProperty() - Check if the property is present.
  // canHaveProperty() - Check if the property could be present.
  // addProperty() - Adds the property.
  // logVisit() - Log each visit of the propagation. This is called before
  //              we check if the function already has the property.
  //
  // Note that the order of propagation here is *not* deterministic, for
  // efficiency reasons (specifically, |calledBy| is unordered and also is
  // generated by |callsTo| which is likewise unordered). If the order matters
  // we could add an ordered variant of this. For now, users that care about
  // ordering in the middle need to handle this (e.g. Asyncify - if we add such
  // an ordered variant, we could use it there).
  void propagateBack(std::function<bool(const T&)> hasProperty,
                     std::function<bool(const T&)> canHaveProperty,
                     std::function<void(T&)> addProperty,
                     std::function<void(const T&, Function*)> logVisit,
                     NonDirectCalls nonDirectCalls) {
    // The work queue contains items we just learned can change the state.
    UniqueDeferredQueue<Function*> work;
    for (auto& func : wasm.functions) {
      if (hasProperty(map[func.get()]) ||
          (nonDirectCalls == NonDirectCallsHaveProperty &&
           map[func.get()].hasNonDirectCall)) {
        addProperty(map[func.get()]);
        work.push(func.get());
      }
    }
    while (!work.empty()) {
      auto* func = work.pop();
      for (auto* caller : map[func].calledBy) {
        // Skip functions forbidden from getting this property.
        if (!canHaveProperty(map[caller])) {
          continue;
        }
        // Log now, even if the function already has the property.
        logVisit(map[caller], func);
        // If we don't already have the property, then add it now, and propagate
        // further.
        if (!hasProperty(map[caller])) {
          addProperty(map[caller]);
          work.push(caller);
        }
      }
    }
  }
};

// Which types to collect.
//
//   AllTypes - Any type anywhere reachable from anything.
//
//   UsedIRTypes - Same as AllTypes, but excludes types reachable only because
//   they are in a rec group with some other used type and types that are only
//   used from other unreachable types.
//
//   BinaryTypes - Only types that need to appear in the module's type section.
//
enum class TypeInclusion { AllTypes, UsedIRTypes, BinaryTypes };

// Whether to classify collected types as public and private.
enum class VisibilityHandling { NoVisibility, FindVisibility };

// Whether a type is public or private. If visibility is not analyzed, the
// visibility will be Unknown instead.
enum class Visibility { Unknown, Public, Private };

struct HeapTypeInfo {
  Index useCount = 0;
  Visibility visibility = Visibility::Unknown;
};

InsertOrderedMap<HeapType, HeapTypeInfo> collectHeapTypeInfo(
  Module& wasm,
  TypeInclusion inclusion = TypeInclusion::AllTypes,
  VisibilityHandling visibility = VisibilityHandling::NoVisibility);

// Helper function for collecting all the non-basic heap types used in the
// module, i.e. the types that would appear in the type section.
std::vector<HeapType> collectHeapTypes(Module& wasm);

// Collect all the heap types visible on the module boundary that cannot be
// changed. TODO: For open world use cases, this needs to include all subtypes
// of public types as well.
std::vector<HeapType> getPublicHeapTypes(Module& wasm);

// getHeapTypes - getPublicHeapTypes
std::vector<HeapType> getPrivateHeapTypes(Module& wasm);

struct IndexedHeapTypes {
  std::vector<HeapType> types;
  std::unordered_map<HeapType, Index> indices;
};

// Similar to `collectHeapTypes`, but provides fast lookup of the index for each
// type as well. Also orders the types to be valid and sorts the types by
// frequency of use to minimize code size.
IndexedHeapTypes getOptimizedIndexedHeapTypes(Module& wasm);

} // namespace wasm::ModuleUtils

#endif // wasm_ir_module_h
