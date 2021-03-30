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

namespace wasm {

namespace ModuleUtils {

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

inline ElementSegment* copyElementSegment(const ElementSegment* segment,
                                          Module& out) {
  auto copy = [&](std::unique_ptr<ElementSegment>&& ret) {
    ret->name = segment->name;
    ret->hasExplicitName = segment->hasExplicitName;
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

inline Table* copyTable(Table* table, Module& out) {
  auto ret = std::make_unique<Table>();
  ret->name = table->name;
  ret->module = table->module;
  ret->base = table->base;

  ret->initial = table->initial;
  ret->max = table->max;

  return out.addTable(std::move(ret));
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
  for (auto& curr : in.elementSegments) {
    copyElementSegment(curr.get(), out);
  }
  for (auto& curr : in.tables) {
    copyTable(curr.get(), out);
  }

  out.memory = in.memory;
  for (auto& segment : out.memory.segments) {
    segment.offset = ExpressionManipulator::copy(segment.offset, out);
  }
  out.start = in.start;
  out.userSections = in.userSections;
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
// call this redirect all of its uses.
template<typename T> inline void renameFunctions(Module& wasm, T& map) {
  // Update the function itself.
  for (auto& pair : map) {
    if (Function* F = wasm.getFunctionOrNull(pair.first)) {
      assert(!wasm.getFunctionOrNull(pair.second) || F->name == pair.second);
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
  ElementUtils::iterAllElementFunctionNames(&wasm, maybeUpdate);
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

template<typename T> inline void iterImports(Module& wasm, T visitor) {
  iterImportedMemories(wasm, visitor);
  iterImportedTables(wasm, visitor);
  iterImportedGlobals(wasm, visitor);
  iterImportedFunctions(wasm, visitor);
  iterImportedEvents(wasm, visitor);
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
    // A non-direct call is any call that is not direct. That includes
    // CallIndirect and CallRef.
    bool hasNonDirectCall = false;
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
    for (auto& pair : map) {
      auto* func = pair.first;
      auto& info = pair.second;
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

// Helper function for collecting all the types that are declared in a module,
// which means the HeapTypes (that are non-basic, that is, not eqref etc., which
// do not need to be defined).
//
// Used when emitting or printing a module to give HeapTypes canonical
// indices. HeapTypes are sorted in order of decreasing frequency to minize the
// size of their collective encoding. Both a vector mapping indices to
// HeapTypes and a map mapping HeapTypes to indices are produced.
inline void collectHeapTypes(Module& wasm,
                             std::vector<HeapType>& types,
                             std::unordered_map<HeapType, Index>& typeIndices) {
  struct Counts : public std::unordered_map<HeapType, size_t> {
    bool isRelevant(Type type) {
      return (type.isRef() || type.isRtt()) && !type.getHeapType().isBasic();
    }
    void note(HeapType type) { (*this)[type]++; }
    void maybeNote(Type type) {
      if (isRelevant(type)) {
        note(type.getHeapType());
      }
    }
  };

  struct CodeScanner
    : PostWalker<CodeScanner, UnifiedExpressionVisitor<CodeScanner>> {
    Counts& counts;

    CodeScanner(Counts& counts) : counts(counts) {}

    void visitExpression(Expression* curr) {
      if (auto* call = curr->dynCast<CallIndirect>()) {
        counts.note(call->sig);
      } else if (curr->is<RefNull>()) {
        counts.maybeNote(curr->type);
      } else if (curr->is<RttCanon>() || curr->is<RttSub>()) {
        counts.note(curr->type.getRtt().heapType);
      } else if (auto* get = curr->dynCast<StructGet>()) {
        counts.maybeNote(get->ref->type);
      } else if (auto* set = curr->dynCast<StructSet>()) {
        counts.maybeNote(set->ref->type);
      } else if (Properties::isControlFlowStructure(curr)) {
        if (curr->type.isTuple()) {
          // TODO: Allow control flow to have input types as well
          counts.note(Signature(Type::none, curr->type));
        } else {
          counts.maybeNote(curr->type);
        }
      }
    }
  };

  // Collect module-level info.
  Counts counts;
  CodeScanner(counts).walkModuleCode(&wasm);
  for (auto& curr : wasm.events) {
    counts.note(curr->sig);
  }

  // Collect info from functions in parallel.
  ModuleUtils::ParallelFunctionAnalysis<Counts> analysis(
    wasm, [&](Function* func, Counts& counts) {
      counts.note(func->sig);
      for (auto type : func->vars) {
        for (auto t : type) {
          counts.maybeNote(t);
        }
      }
      if (!func->imported()) {
        CodeScanner(counts).walk(func->body);
      }
    });

  // Combine the function info with the module info.
  for (auto& pair : analysis.map) {
    Counts& functionCounts = pair.second;
    for (auto& innerPair : functionCounts) {
      counts[innerPair.first] += innerPair.second;
    }
  }

  // A generic utility to traverse the child types of a type.
  // TODO: work with tlively to refactor this to a shared place
  auto walkRelevantChildren = [&](HeapType type, auto callback) {
    auto callIfRelevant = [&](Type type) {
      if (counts.isRelevant(type)) {
        callback(type.getHeapType());
      }
    };
    if (type.isSignature()) {
      auto sig = type.getSignature();
      for (Type type : {sig.params, sig.results}) {
        for (auto element : type) {
          callIfRelevant(element);
        }
      }
    } else if (type.isArray()) {
      callIfRelevant(type.getArray().element.type);
    } else if (type.isStruct()) {
      auto fields = type.getStruct().fields;
      for (auto field : fields) {
        callIfRelevant(field.type);
      }
    }
  };
  // Recursively traverse each reference type, which may have a child type that
  // is itself a reference type. This reflects an appearance in the binary
  // format that is in the type section itself.
  // As we do this we may find more and more types, as nested children of
  // previous ones. Each such type will appear in the type section once, so
  // we just need to visit it once.
  std::unordered_set<HeapType> newTypes;
  for (auto& pair : counts) {
    newTypes.insert(pair.first);
  }
  while (!newTypes.empty()) {
    auto iter = newTypes.begin();
    auto type = *iter;
    newTypes.erase(iter);
    walkRelevantChildren(type, [&](HeapType type) {
      if (!counts.count(type)) {
        newTypes.insert(type);
      }
      counts.note(type);
    });
  }

  // Sort by frequency and then simplicity.
  std::vector<std::pair<HeapType, size_t>> sorted(counts.begin(), counts.end());
  std::stable_sort(sorted.begin(), sorted.end(), [&](auto a, auto b) {
    if (a.second != b.second) {
      return a.second > b.second;
    }
    return a.first < b.first;
  });
  for (Index i = 0; i < sorted.size(); ++i) {
    typeIndices[sorted[i].first] = i;
    types.push_back(sorted[i].first);
  }
}

} // namespace ModuleUtils

} // namespace wasm

#endif // wasm_ir_module_h
