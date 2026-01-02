/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef wasm_import_resolver_h
#define wasm_import_resolver_h

#include <map>
#include <optional>
#include <utility>
#include <vector>

#include "support/name.h"
#include "support/nullability.h"
#include "wasm.h"
#include "wasm/qualified-name.h"

namespace wasm {

class ImportResolver {
public:
  virtual ~ImportResolver() = default;

  // Returns null if the `name` wasn't found. The returned Literals* lives as
  // long as the ImportResolver instance.
  virtual nullability::Nullable<Literals*> getGlobal(QualifiedName name,
                                                     Type type) const = 0;
};

// Looks up imports from the given `linkedInstances`.
template<typename ModuleRunnerType>
class LinkedInstancesImportResolver : public ImportResolver {
public:
  LinkedInstancesImportResolver(
    std::map<Name, std::shared_ptr<ModuleRunnerType>> linkedInstances)
    : linkedInstances(std::move(linkedInstances)) {}

  nullability::Nullable<Literals*> getGlobal(QualifiedName name,
                                             Type type) const override {
    auto it = linkedInstances.find(name.module);
    if (it == linkedInstances.end()) {
      return nullptr;
    }

    ModuleRunnerType* instance = it->second.get();
    return instance->getExportedGlobal(name.name);
  }

private:
  const std::map<Name, std::shared_ptr<ModuleRunnerType>> linkedInstances;
};

} // namespace wasm

#endif // wasm_import_resolver_h
