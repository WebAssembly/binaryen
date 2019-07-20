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
    auto addGlobal = [&](Global* curr) {
      auto index = globalIndexes.size();
      globalIndexes[curr->name] = index;
    };
    for (auto& curr : wasm.globals) {
      if (curr->imported()) {
        addGlobal(curr.get());
      }
    }
    for (auto& curr : wasm.globals) {
      if (!curr->imported()) {
        addGlobal(curr.get());
      }
    }
    assert(globalIndexes.size() == wasm.globals.size());
    auto addFunction = [&](Function* curr) {
      auto index = functionIndexes.size();
      functionIndexes[curr->name] = index;
    };
    for (auto& curr : wasm.functions) {
      if (curr->imported()) {
        addFunction(curr.get());
      }
    }
    for (auto& curr : wasm.functions) {
      if (!curr->imported()) {
        addFunction(curr.get());
      }
    }
    assert(functionIndexes.size() == wasm.functions.size());
    auto addEvent = [&](Event* curr) {
      auto index = eventIndexes.size();
      eventIndexes[curr->name] = index;
    };
    for (auto& curr : wasm.events) {
      if (curr->imported()) {
        addEvent(curr.get());
      }
    }
    for (auto& curr : wasm.events) {
      if (!curr->imported()) {
        addEvent(curr.get());
      }
    }
    assert(eventIndexes.size() == wasm.events.size());
  }
};

inline Function* copyFunction(Function* func, Module& out) {
  auto* ret = new Function();
  ret->name = func->name;
  ret->result = func->result;
  ret->params = func->params;
  ret->vars = func->vars;
  // start with no named type; the names in the other module may differ
  ret->type = Name();
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
  ret->type = event->type;
  ret->params = event->params;
  out.addEvent(ret);
  return ret;
}

inline void copyModule(Module& in, Module& out) {
  // we use names throughout, not raw points, so simple copying is fine
  // for everything *but* expressions
  for (auto& curr : in.functionTypes) {
    out.addFunctionType(make_unique<FunctionType>(*curr));
  }
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

// Performs a parallel map on function in the module, emitting a map object
// of function => result.
// TODO: use in inlining and elsewhere
template<typename T> struct ParallelFunctionMap {

  typedef std::map<Function*, T> Map;
  Map map;

  typedef std::function<void(Function*, T&)> Func;

  struct Info {
    Map* map;
    Func work;
  };

  ParallelFunctionMap(Module& wasm, Func work) {
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

    // Run on the implemented functions.
    struct Mapper : public WalkerPass<PostWalker<Mapper>> {
      bool isFunctionParallel() override { return true; }

      Mapper(Info* info) : info(info) {}

      Mapper* create() override { return new Mapper(info); }

      void doWalkFunction(Function* curr) {
        assert((*info->map).count(curr));
        info->work(curr, (*info->map)[curr]);
      }

    private:
      Info* info;
    };

    Info info = {&map, work};

    PassRunner runner(&wasm);
    Mapper(&info).run(&runner, &wasm);
  }
};

} // namespace ModuleUtils

} // namespace wasm

#endif // wasm_ir_module_h
