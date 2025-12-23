
#include <optional>
#include <utility>

#include "src/support/name.h"
#include "src/wasm.h"

namespace wasm {

// TODO: move into different headers / cc files

// Module name, base name
using QualifiedName = std::pair<Name, Name>;
class ImportResolver {
public:
  virtual ~ImportResolver() = default;
  // For ctor-eval, we want to provide imports that are guaranteed to type-check
  // against the import type. Providing the expected type here helps us 'cheat'.
  virtual std::optional<Global> getGlobal(QualifiedName name, Type type) = 0;
  // One concern here, tables and memories can change type when resized.
  virtual std::optional<Memory>
  getMemory(QualifiedName name /*, MemoryType type ? */) = 0;
  virtual std::optional<Table>
  getTable(QualifiedName name /*, TableType type ? */) = 0;
  virtual std::optional<Function> getFunction(QualifiedName name,
                                              Type type) = 0;
  virtual std::optional<Tag> getTag(QualifiedName name, Signature type) = 0;
};

class LinkedInstancesImportResolver : public ImportResolver {
public:
  LinkedInstancesImportResolver(
    const std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances)
    : linkedInstances(linkedInstances) {}

  std::optional<Global> getGlobal(QualifiedName name,
                                  Type type) const override {}

  std::optional<Memory>
  getMemory(QualifiedName name /*, MemoryType type ? */) override {
    return std::nullopt;
  }
  std::optional<Table>
  getTable(QualifiedName name /*, TableType type ? */) override {
    return std::nullopt;
  }

  std::optional<Function> getFunction(QualifiedName name, Type type) override {
    return std::nullopt;
  }

  std::optional<Tag> getTag(QualifiedName name, Signature type) override {
    return std::nullopt;
  }

private:
  const std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances;
};

} // namespace wasm