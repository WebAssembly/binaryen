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

#include "ir/element-utils.h"
#include "ir/find_all.h"
#include "ir/manipulation.h"
#include "ir/properties.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm::ModuleUtils {

// Copies a function into a module. If newName is provided it is used as the
// name of the function (otherwise the original name is copied).
inline Function*
copyFunction(Function* func, Module& out, Name newName = Name()) {
  auto ret = std::make_unique<Function>();
  ret->name = newName.is() ? newName : func->name;
  ret->type = func->type;
  ret->vars = func->vars;
  ret->localNames = func->localNames;
  ret->localIndices = func->localIndices;
  ret->debugLocations = func->debugLocations;
  ret->body = ExpressionManipulator::copy(func->body, out);
  ret->module = func->module;
  ret->base = func->base;
  // TODO: copy Stack IR
  assert(!func->stackIR);
  return out.addFunction(std::move(ret));
}

inline Global* copyGlobal(Global* global, Module& out) {
  auto* ret = new Global();
  ret->name = global->name;
  ret->type = global->type;
  ret->mutable_ = global->mutable_;
  ret->module = global->module;
  ret->base = global->base;
  if (global->imported()) {
    ret->init = nullptr;
  } else {
    ret->init = ExpressionManipulator::copy(global->init, out);
  }
  out.addGlobal(ret);
  return ret;
}

inline Tag* copyTag(Tag* tag, Module& out) {
  auto* ret = new Tag();
  ret->name = tag->name;
  ret->sig = tag->sig;
  out.addTag(ret);
  return ret;
}

inline ElementSegment* copyElementSegment(const ElementSegment* segment,
                                          Module& out) {
  auto copy = [&](std::unique_ptr<ElementSegment>&& ret) {
    ret->name = segment->name;
    ret->hasExplicitName = segment->hasExplicitName;
    ret->type = segment->type;
    ret->data.reserve(segment->data.size());
    for (auto* item : segment->data) {
      ret->data.push_back(ExpressionManipulator::copy(item, out));
    }

    return out.addElementSegment(std::move(ret));
  };

  if (segment->table.isNull()) {
    return copy(std::make_unique<ElementSegment>());
  } else {
    auto offset = ExpressionManipulator::copy(segment->offset, out);
    return copy(std::make_unique<ElementSegment>(segment->table, offset));
  }
}

inline Table* copyTable(const Table* table, Module& out) {
  auto ret = std::make_unique<Table>();
  ret->name = table->name;
  ret->hasExplicitName = table->hasExplicitName;
  ret->type = table->type;
  ret->module = table->module;
  ret->base = table->base;

  ret->initial = table->initial;
  ret->max = table->max;

  return out.addTable(std::move(ret));
}

inline Memory* copyMemory(const Memory* memory, Module& out) {
  auto ret = Builder::makeMemory(memory->name);
  ret->hasExplicitName = memory->hasExplicitName;
  ret->initial = memory->initial;
  ret->max = memory->max;
  ret->shared = memory->shared;
  ret->indexType = memory->indexType;

  return out.addMemory(std::move(ret));
}

inline DataSegment* copyDataSegment(const DataSegment* segment, Module& out) {
  auto ret = Builder::makeDataSegment();
  ret->name = segment->name;
  ret->hasExplicitName = segment->hasExplicitName;
  ret->memory = segment->memory;
  ret->isPassive = segment->isPassive;
  if (!segment->isPassive) {
    auto offset = ExpressionManipulator::copy(segment->offset, out);
    ret->offset = offset;
  }
  ret->data = segment->data;

  return out.addDataSegment(std::move(ret));
}

inline void copyModule(const Module& in, Module& out) {
  // we use names throughout, not raw pointers, so simple copying is fine
  // for everything *but* expressions
  for (auto& curr : in.exports) {
    out.addExport(new Export(*curr));
  }
  for (auto& curr : in.functions) {
    copyFunction(curr.get(), out);
  }
  for (auto& curr : in.globals) {
    copyGlobal(curr.get(), out);
  }
  for (auto& curr : in.tags) {
    copyTag(curr.get(), out);
  }
  for (auto& curr : in.elementSegments) {
    copyElementSegment(curr.get(), out);
  }
  for (auto& curr : in.tables) {
    copyTable(curr.get(), out);
  }
  for (auto& curr : in.memories) {
    copyMemory(curr.get(), out);
  }
  for (auto& curr : in.dataSegments) {
    copyDataSegment(curr.get(), out);
  }
  out.start = in.start;
  out.customSections = in.customSections;
  out.debugInfoFileNames = in.debugInfoFileNames;
  out.features = in.features;
  out.typeNames = in.typeNames;
}

inline void clearModule(Module& wasm) {
  wasm.~Module();
  new (&wasm) Module;
}

// Renaming

// Rename functions along with all their uses.
// Note that for this to work the functions themselves don't necessarily need
// to exist.  For example, it is possible to remove a given function and then
// call this to redirect all of its uses.
template<typename T> inline void renameFunctions(Module& wasm, T& map) {
  // Update the function itself.
  for (auto& [oldName, newName] : map) {
    if (Function* func = wasm.getFunctionOrNull(oldName)) {
      assert(!wasm.getFunctionOrNull(newName) || func->name == newName);
      func->name = newName;
    }
  }
  wasm.updateMaps();

  // Update all references to it.
  struct Updater : public WalkerPass<PostWalker<Updater>> {
    bool isFunctionParallel() override { return true; }

    T& map;

    void maybeUpdate(Name& name) {
      if (auto iter = map.find(name); iter != map.end()) {
        name = iter->second;
      }
    }

    Updater(T& map) : map(map) {}

    std::unique_ptr<Pass> create() override {
      return std::make_unique<Updater>(map);
    }

    void visitCall(Call* curr) { maybeUpdate(curr->target); }

    void visitRefFunc(RefFunc* curr) { maybeUpdate(curr->func); }
  };

  Updater updater(map);
  updater.maybeUpdate(wasm.start);
  PassRunner runner(&wasm);
  updater.run(&runner, &wasm);
  updater.runOnModuleCode(&runner, &wasm);
}

inline void renameFunction(Module& wasm, Name oldName, Name newName) {
  std::map<Name, Name> map;
  map[oldName] = newName;
  renameFunctions(wasm, map);
}

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
    // Fill in map, as we operate on it in parallel (each function to its own
    // entry).
    for (auto& func : wasm.functions) {
      map[func.get()];
    }

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
  // addProperty() - Adds the property. This receives a second parameter which
  //                 is the function due to which we are adding the property.
  void propagateBack(std::function<bool(const T&)> hasProperty,
                     std::function<bool(const T&)> canHaveProperty,
                     std::function<void(T&, Function*)> addProperty,
                     NonDirectCalls nonDirectCalls) {
    // The work queue contains items we just learned can change the state.
    UniqueDeferredQueue<Function*> work;
    for (auto& func : wasm.functions) {
      if (hasProperty(map[func.get()]) ||
          (nonDirectCalls == NonDirectCallsHaveProperty &&
           map[func.get()].hasNonDirectCall)) {
        addProperty(map[func.get()], func.get());
        work.push(func.get());
      }
    }
    while (!work.empty()) {
      auto* func = work.pop();
      for (auto* caller : map[func].calledBy) {
        // If we don't already have the property, and we are not forbidden
        // from getting it, then it propagates back to us now.
        if (!hasProperty(map[caller]) && canHaveProperty(map[caller])) {
          addProperty(map[caller], func);
          work.push(caller);
        }
      }
    }
  }
};

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
