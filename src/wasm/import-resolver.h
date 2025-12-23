#ifndef wasm_import_resolver_h
#define wasm_import_resolver_h

#include <map>
#include <optional>
#include <utility>
#include <vector>

#include "support/name.h"
#include "wasm.h"
#include "wasm/qualified-name.h"

namespace wasm {

class ImportResolver {
public:
  virtual ~ImportResolver() = default;

  virtual std::optional<Literals*> getGlobal(QualifiedName name,
                                             Type type) const = 0;
};

template<typename ModuleRunnerType>
class LinkedInstancesImportResolver : public ImportResolver {
public:
  LinkedInstancesImportResolver(
    std::map<Name, std::shared_ptr<ModuleRunnerType>> linkedInstances)
    : linkedInstances(std::move(linkedInstances)) {}

  std::optional<Literals*> getGlobal(QualifiedName name,
                                     Type type) const override {
    auto it = linkedInstances.find(name.module);
    if (it == linkedInstances.end()) {
      return std::nullopt;
    }

    ModuleRunnerType* instance = it->second.get();
    return instance->getExportedGlobal(name.name);
  }

private:
  const std::map<Name, std::shared_ptr<ModuleRunnerType>> linkedInstances;
};

} // namespace wasm

#endif // wasm_import_resolver_h
