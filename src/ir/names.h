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
#ifndef wasm_ir_names_h
#define wasm_ir_names_h

#include "wasm.h"

namespace wasm::Names {

// Add explicit names for function locals not yet named, and do not
// modify existing names
inline void ensureNames(Function* func) {
  std::unordered_set<Name> seen;
  for (auto& [_, name] : func->localNames) {
    seen.insert(name);
  }
  Index nameIndex = seen.size();
  for (Index i = 0; i < func->getNumLocals(); i++) {
    if (!func->hasLocalName(i)) {
      while (1) {
        auto name = Name::fromInt(nameIndex++);
        if (seen.emplace(name).second) {
          func->localNames[i] = name;
          func->localIndices[name] = i;
          break;
        }
      }
    }
  }
}

// Given a root of a name, finds a valid name with perhaps a number appended
// to it, by calling a function to check if a name is valid.
//
// An optional index can be given as a hint, and if so, the search for a valid
// name will begin there. This can be used to avoid trying the same 0,1,2,..
// etc. names each time (which could lead to quadratic behavior in certain
// cases).
inline Name getValidName(Name root,
                         std::function<bool(Name)> check,
                         Index hint = 0,
                         std::string separator = "_") {
  if (check(root)) {
    return root;
  }
  auto prefixed = std::string(root.str) + separator;
  Index num = hint;
  while (1) {
    auto name = prefixed + std::to_string(num);
    if (check(name)) {
      return name;
    }
    num++;
  }
}

inline Name getValidExportName(Module& module, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !module.getExportOrNull(test); },
    module.exports.size());
}
inline Name getValidGlobalName(Module& module, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !module.getGlobalOrNull(test); },
    module.globals.size());
}
inline Name getValidFunctionName(Module& module, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !module.getFunctionOrNull(test); },
    module.functions.size());
}
inline Name getValidTableName(Module& module, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !module.getTableOrNull(test); },
    module.tables.size());
}
inline Name getValidTagName(Module& module, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !module.getTagOrNull(test); },
    module.tags.size());
}
inline Name getValidElementSegmentName(Module& module, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !module.getElementSegmentOrNull(test); },
    module.elementSegments.size());
}
inline Name getValidDataSegmentName(Module& module, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !module.getDataSegmentOrNull(test); },
    module.dataSegments.size());
}
inline Name getValidMemoryName(Module& module, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !module.getMemoryOrNull(test); },
    module.memories.size());
}
inline Name getValidLocalName(Function& func, Name root) {
  return getValidName(
    root,
    [&](Name test) { return !func.hasLocalIndex(test); },
    func.getNumLocals());
}

template<typename T>
inline Name getValidNameGivenExisting(Name root, const T& existingNames) {
  return getValidName(
    root,
    [&](Name test) { return !existingNames.count(test); },
    existingNames.size());
}

class MinifiedNameGenerator {
  size_t state = 0;

public:
  // Get a fresh minified name.
  std::string getName();
};

} // namespace wasm::Names

#endif // wasm_ir_names_h
