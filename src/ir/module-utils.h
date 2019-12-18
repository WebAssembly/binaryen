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

#include "ir/find_all.h"
#include "ir/manipulation.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm {

namespace ModuleUtils {

// Computes the indexes in a wasm binary, i.e., with function imports
// and function implementations sharing a single index space, etc.,
// and with the imports first (the Module's functions and globals
// arrays are not assumed to be in a particular order, so we can't
// just use them directly).
struct BinaryIndexes {
  std::unordered_map<Name, Index> functionIndexes;
  std::unordered_map<Name, Index> globalIndexes;
  std::unordered_map<Name, Index> eventIndexes;

  BinaryIndexes(Module& wasm) {
    auto addIndexes = [&](auto& source, auto& indexes) {
      auto addIndex = [&](auto* curr) {
        auto index = indexes.size();
        indexes[curr->name] = index;
      };
      for (auto& curr : source) {
        if (curr->imported()) {
          addIndex(curr.get());
        }
      }
      for (auto& curr : source) {
        if (!curr->imported()) {
          addIndex(curr.get());
        }
      }
    };
    addIndexes(wasm.functions, functionIndexes);
    addIndexes(wasm.globals, globalIndexes);
    addIndexes(wasm.events, eventIndexes);
  }
};

inline Function* copyFunction(Function* func, Module& out) {
  auto* ret = new Function();
  ret->name = func->name;
  ret->sig = func->sig;
  ret->vars = func->vars;
  ret->localNames = func->localNames;
  ret->localIndices = func->localIndices;
  ret->debugLocations = func->debugLocations;
  ret->body = ExpressionManipulator::copy(func->body, out);
  ret->module = func->module;
  ret->base = func->base;
  // TODO: copy Stack IR
  assert(!func->stackIR);
  out.addFunction(ret);
  return ret;
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

inline Event* copyEvent(Event* event, Module& out) {
  auto* ret = new Event();
  ret->name = event->name;
  ret->attribute = event->attribute;
  ret->sig = event->sig;
  out.addEvent(ret);
  return ret;
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
  for (auto& curr : in.events) {
    copyEvent(curr.get(), out);
  }
  out.table = in.table;
  for (auto& segment : out.table.segments) {
    segment.offset = ExpressionManipulator::copy(segment.offset, out);
  }
  out.memory = in.memory;
  for (auto& segment : out.memory.segments) {
    segment.offset = ExpressionManipulator::copy(segment.offset, out);
  }
  out.start = in.start;
  out.userSections = in.userSections;
  out.debugInfoFileNames = in.debugInfoFileNames;
}

inline void clearModule(Module& wasm) {
  wasm.exports.clear();
  wasm.functions.clear();
  wasm.globals.clear();
  wasm.events.clear();
  wasm.table.clear();
  wasm.memory.clear();
  wasm.start = Name();
  wasm.userSections.clear();
  wasm.debugInfoFileNames.clear();
  wasm.updateMaps();
}

// Renaming

// Rename functions along with all their uses.
// Note that for this to work the functions themselves don't necessarily need
// to exist.  For example, it is possible to remove a given function and then
// call this redirect all of its uses.
template<typename T> inline void renameFunctions(Module& wasm, T& map) {
  // Update the function itself.
  for (auto& pair : map) {
    if (Function* F = wasm.getFunctionOrNull(pair.first)) {
      assert(!wasm.getFunctionOrNull(pair.second));
      F->name = pair.second;
    }
  }
  wasm.updateMaps();
  // Update other global things.
  auto maybeUpdate = [&](Name& name) {
    auto iter = map.find(name);
    if (iter != map.end()) {
      name = iter->second;
    }
  };
  maybeUpdate(wasm.start);
  for (auto& segment : wasm.table.segments) {
    for (auto& name : segment.data) {
      maybeUpdate(name);
    }
  }
  for (auto& exp : wasm.exports) {
    if (exp->kind == ExternalKind::Function) {
      maybeUpdate(exp->value);
    }
  }
  // Update call instructions.
  for (auto& func : wasm.functions) {
    // TODO: parallelize
    if (!func->imported()) {
      FindAll<Call> calls(func->body);
      for (auto* call : calls.list) {
        maybeUpdate(call->target);
      }
    }
  }
}

inline void renameFunction(Module& wasm, Name oldName, Name newName) {
  std::map<Name, Name> map;
  map[oldName] = newName;
  renameFunctions(wasm, map);
}

// Convenient iteration over imported/non-imported module elements

template<typename T> inline void iterImportedMemories(Module& wasm, T visitor) {
  if (wasm.memory.exists && wasm.memory.imported()) {
    visitor(&wasm.memory);
  }
}

template<typename T> inline void iterDefinedMemories(Module& wasm, T visitor) {
  if (wasm.memory.exists && !wasm.memory.imported()) {
    visitor(&wasm.memory);
  }
}

template<typename T> inline void iterImportedTables(Module& wasm, T visitor) {
  if (wasm.table.exists && wasm.table.imported()) {
    visitor(&wasm.table);
  }
}

template<typename T> inline void iterDefinedTables(Module& wasm, T visitor) {
  if (wasm.table.exists && !wasm.table.imported()) {
    visitor(&wasm.table);
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

template<typename T> inline void iterImportedEvents(Module& wasm, T visitor) {
  for (auto& import : wasm.events) {
    if (import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T> inline void iterDefinedEvents(Module& wasm, T visitor) {
  for (auto& import : wasm.events) {
    if (!import->imported()) {
      visitor(import.get());
    }
  }
}

// Helper class for performing an operation on all the functions in the module,
// in parallel, with an Info object for each one that can contain results of
// some computation that the operation performs.
// The operation performend should not modify the wasm module in any way.
// TODO: enforce this
template<typename T> struct ParallelFunctionAnalysis {
  Module& wasm;

  typedef std::map<Function*, T> Map;
  Map map;

  typedef std::function<void(Function*, T&)> Func;

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
      bool modifiesBinaryenIR() override { return false; }

      Mapper(Module& module, Map& map, Func work)
        : module(module), map(map), work(work) {}

      Mapper* create() override { return new Mapper(module, map, work); }

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
  };

  typedef std::map<Function*, T> Map;
  Map map;

  typedef std::function<void(Function*, T&)> Func;

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

      private:
        Module* module;
        T& info;
        Func work;
      } mapper(&wasm, info, work);
      mapper.walk(func->body);
    });

    map.swap(analysis.map);

    // Find what is called by what.
    for (auto& pair : map) {
      auto* func = pair.first;
      auto& info = pair.second;
      for (auto* target : info.callsTo) {
        map[target].calledBy.insert(func);
      }
    }
  }

  // Propagate a property from a function to those that call it.
  void propagateBack(std::function<bool(const T&)> hasProperty,
                     std::function<bool(const T&)> canHaveProperty,
                     std::function<void(T&)> addProperty) {
    // The work queue contains items we just learned can change the state.
    UniqueDeferredQueue<Function*> work;
    for (auto& func : wasm.functions) {
      if (hasProperty(map[func.get()])) {
        work.push(func.get());
      }
    }
    while (!work.empty()) {
      auto* func = work.pop();
      for (auto* caller : map[func].calledBy) {
        // If we don't already have the property, and we are not forbidden
        // from getting it, then it propagates back to us now.
        if (!hasProperty(map[caller]) && canHaveProperty(map[caller])) {
          addProperty(map[caller]);
          work.push(caller);
        }
      }
    }
  }
};

// Helper function for collecting the type signature used in a module
//
// Used when emitting or printing a module to give signatures canonical
// indices. Signatures are sorted in order of decreasing frequency to minize the
// size of their collective encoding. Both a vector mapping indices to
// signatures and a map mapping signatures to indices are produced.
inline void
collectSignatures(Module& wasm,
                  std::vector<Signature>& signatures,
                  std::unordered_map<Signature, Index>& sigIndices) {
  using Counts = std::unordered_map<Signature, size_t>;

  // Collect the signature use counts for a single function
  auto updateCounts = [&](Function* func, Counts& counts) {
    if (func->imported()) {
      return;
    }
    struct TypeCounter : PostWalker<TypeCounter> {
      Counts& counts;

      TypeCounter(Counts& counts) : counts(counts) {}

      void visitCallIndirect(CallIndirect* curr) { counts[curr->sig]++; }
    };
    TypeCounter(counts).walk(func->body);
  };

  ModuleUtils::ParallelFunctionAnalysis<Counts> analysis(wasm, updateCounts);

  // Collect all the counts.
  Counts counts;
  for (auto& curr : wasm.functions) {
    counts[curr->sig]++;
  }
  for (auto& curr : wasm.events) {
    counts[curr->sig]++;
  }
  for (auto& pair : analysis.map) {
    Counts& functionCounts = pair.second;
    for (auto& innerPair : functionCounts) {
      counts[innerPair.first] += innerPair.second;
    }
  }
  std::vector<std::pair<Signature, size_t>> sorted(counts.begin(),
                                                   counts.end());
  std::sort(sorted.begin(), sorted.end(), [&](auto a, auto b) {
    // order by frequency then simplicity
    if (a.second != b.second) {
      return a.second > b.second;
    }
    return a.first < b.first;
  });
  for (Index i = 0; i < sorted.size(); ++i) {
    sigIndices[sorted[i].first] = i;
    signatures.push_back(sorted[i].first);
  }
}

} // namespace ModuleUtils

} // namespace wasm

#endif // wasm_ir_module_h
