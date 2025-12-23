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

  // Here we should also consider `Literal` instead of `Literals`. `Literals`
  // seems to be used for consisentecy in some other places that may return
  // multiple values like functions, but I don't think it's relevant in the case
  // of globals.
  virtual std::optional<Literals*> getGlobal(QualifiedName name, Type type) = 0;
  // One concern here, tables and memories can change type when resized.
  virtual std::optional<Memory>
  getMemory(QualifiedName name /*, MemoryType type ? */) = 0;
  virtual std::optional<Table>
  getTable(QualifiedName name /*, TableType type ? */) = 0;
  virtual std::optional<Function> getFunction(QualifiedName name,
                                              Type type) = 0;
  virtual std::optional<Tag> getTag(QualifiedName name, Signature type) = 0;
};

// This is defined in wasm-interpreter.h which would lead to a circular
// reference.
// TODO: extract this class out maybe?
class ModuleRunner {
public:
  std::map<Name, Literals> definedGlobals;
};

class LinkedInstancesImportResolver : public ImportResolver {
public:
  LinkedInstancesImportResolver(
    const std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances)
    : linkedInstances(linkedInstances) {}

  std::optional<Literals*> getGlobal(QualifiedName name, Type type) override {
    auto instance = *linkedInstances.find(name.first);
    auto* global = &instance.second->definedGlobals[name.second];
    return global;
  }

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