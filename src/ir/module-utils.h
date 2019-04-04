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

#include "wasm-binary.h"
#include "wasm.h"
#include "ir/find_all.h"
#include "ir/manipulation.h"

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
  }
};

// Read the features section into the out param, if it is present. If it is not
// present, return false
inline bool readFeaturesSection(const Module& module, FeatureSet& features) try {
  features = FeatureSet::MVP;

  const UserSection* section = nullptr;
  for (auto &s : module.userSections) {
    if (s.name == BinaryConsts::UserSections::TargetFeatures) {
      section = &s;
      break;
    }
  }

  if (!section) {
    return false;
  }

  // read target features section
  size_t index = 0;
  auto next_byte = [&]() {
    return section->data.at(index++);
  };

  size_t num_feats = U32LEB().read(next_byte).value;
  for (size_t i = 0; i < num_feats; ++i) {
    uint8_t prefix = section->data.at(index++);
    if (prefix != '=' && prefix != '+' && prefix != '-') {
      // unrecognized prefix, silently fail
      features = FeatureSet::MVP;
      return false;
    }

    size_t len = U32LEB().read(next_byte).value;
    if (index + len > section->data.size()) {
      // ill-formed string, silently fail
      features = FeatureSet::MVP;
      return false;
    }
    std::string name(&section->data[index], len);
    index += len;

    if (prefix == '-') {
      continue;
    }

    if (name == BinaryConsts::UserSections::AtomicsFeature) {
      features.setAtomics();
    } else if (name == BinaryConsts::UserSections::BulkMemoryFeature) {
      features.setBulkMemory();
    } else if (name == BinaryConsts::UserSections::ExceptionHandlingFeature) {
      WASM_UNREACHABLE(); // TODO: exception handling
    } else if (name == BinaryConsts::UserSections::TruncSatFeature) {
      features.setTruncSat();
    } else if (name == BinaryConsts::UserSections::SignExtFeature) {
      features.setSignExt();
    } else if (name == BinaryConsts::UserSections::SIMD128Feature) {
      features.setSIMD();
    }
  }

  return true;

// silently fail to read features. Maybe this should warn?
} catch (std::out_of_range& e) {
  features = FeatureSet::MVP;
  return false;
}


inline Function* copyFunction(Function* func, Module& out) {
  auto* ret = new Function();
  ret->name = func->name;
  ret->result = func->result;
  ret->params = func->params;
  ret->vars = func->vars;
  ret->type = Name(); // start with no named type; the names in the other module may differ
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
template<typename T>
inline void renameFunctions(Module& wasm, T& map) {
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

template<typename T>
inline void iterImportedMemories(Module& wasm, T visitor) {
  if (wasm.memory.exists && wasm.memory.imported()) {
    visitor(&wasm.memory);
  }
}

template<typename T>
inline void iterDefinedMemories(Module& wasm, T visitor) {
  if (wasm.memory.exists && !wasm.memory.imported()) {
    visitor(&wasm.memory);
  }
}

template<typename T>
inline void iterImportedTables(Module& wasm, T visitor) {
  if (wasm.table.exists && wasm.table.imported()) {
    visitor(&wasm.table);
  }
}

template<typename T>
inline void iterDefinedTables(Module& wasm, T visitor) {
  if (wasm.table.exists && !wasm.table.imported()) {
    visitor(&wasm.table);
  }
}

template<typename T>
inline void iterImportedGlobals(Module& wasm, T visitor) {
  for (auto& import : wasm.globals) {
    if (import->imported()) {
      visitor(import.get());
    }
  }
}

template<typename T>
inline void iterDefinedGlobals(Module& wasm, T visitor) {
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

template<typename T>
inline void iterDefinedFunctions(Module& wasm, T visitor) {
  for (auto& import : wasm.functions) {
    if (!import->imported()) {
      visitor(import.get());
    }
  }
}

} // namespace ModuleUtils

} // namespace wasm

#endif // wasm_ir_module_h
