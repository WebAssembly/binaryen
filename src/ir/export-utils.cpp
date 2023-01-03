/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include "ir/export-utils.h"
#include "wasm.h"

namespace wasm::ExportUtils {

namespace {

// Returns a vector of all the things that are exported of a particular kind,
// given that kind and a way to look them up on the module.
template<typename T, ExternalKind K, typename G>
std::vector<T*> getExportedByKind(Module& wasm, G getModuleItem) {
  std::vector<T*> ret;
  for (auto& ex : wasm.exports) {
    if (ex->kind == K) {
      ret.push_back(getModuleItem(ex->value));
    }
  }
  return ret;
}

} // anonymous namespace

std::vector<Function*> getExportedFunctions(Module& wasm) {
  return getExportedByKind<Function, ExternalKind::Function>(
    wasm, [&](Name name) { return wasm.getFunction(name); });
}

std::vector<Global*> getExportedGlobals(Module& wasm) {
  return getExportedByKind<Global, ExternalKind::Global>(
    wasm, [&](Name name) { return wasm.getGlobal(name); });
}

} // namespace wasm::ExportUtils
