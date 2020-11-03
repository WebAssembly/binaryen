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

namespace wasm {

namespace Names {

// Add explicit names for function locals not yet named, and do not
// modify existing names
inline void ensureNames(Function* func) {
  std::unordered_set<Name> seen;
  for (auto& pair : func->localNames) {
    seen.insert(pair.second);
  }
  Index nameIndex = seen.size();
  for (Index i = 0; i < func->getNumLocals(); i++) {
    if (!func->hasLocalName(i)) {
      while (1) {
        auto name = Name::fromInt(nameIndex++);
        if (seen.count(name) == 0) {
          func->localNames[i] = name;
          func->localIndices[name] = i;
          seen.insert(name);
          break;
        }
      }
    }
  }
}

// Given a root of a name, finds a valid name with perhaps a number appended
// to it, by calling a function to check if a name is valid.
inline Name
getValidName(Module& module, Name root, std::function<bool(Name)> check) {
  if (check(root)) {
    return root;
  }
  auto prefixed = std::string(root.str) + '_';
  Index num = 0;
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
    module, root, [&](Name test) { return !module.getExportOrNull(test); });
}
inline Name getValidGlobalName(Module& module, Name root) {
  return getValidName(
    module, root, [&](Name test) { return !module.getGlobalOrNull(test); });
}
inline Name getValidFunctionName(Module& module, Name root) {
  return getValidName(
    module, root, [&](Name test) { return !module.getFunctionOrNull(test); });
}
inline Name getValidEventName(Module& module, Name root) {
  return getValidName(
    module, root, [&](Name test) { return !module.getEventOrNull(test); });
}

} // namespace Names

} // namespace wasm

#endif // wasm_ir_names_h
