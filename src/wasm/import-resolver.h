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

// template <typename SubType>
// class ModuleRunnerBase;
// class EvallingModuleRunner;

// class ModuleRunnerInterface;

// using SomeModuleRunner =
// std::variant<shared_ptr<ModuleRunner<EvallingModuleRunner>>> using
// SomeLinkedInstances = std::variant<std::map<Name,
// std::shared_ptr<ModuleRunnerBase<EvallingModuleRunner>>>>

class NullImportResolver : public ImportResolver {
public:
  NullImportResolver() {}

  std::optional<Literals*> getGlobal(QualifiedName name, Type type) override {
    return std::nullopt;
  }

  std::optional<Memory>
  getMemory(QualifiedName name /*, MemoryType type ? */) override {
    return std::nullopt;
  };
  std::optional<Table>
  getTable(QualifiedName name /*, TableType type ? */) override {
    return std::nullopt;
  };

  std::optional<Function> getFunction(QualifiedName name, Type type) override {
    return std::nullopt;
  };

  std::optional<Tag> getTag(QualifiedName name, Signature type) override {
    return std::nullopt;
  };
};

class SpecTestModuleImportResolver : public NullImportResolver {
public:
  SpecTestModuleImportResolver()
    : global_i32({Literal(static_cast<uint32_t>(666))}) {}

  std::optional<Literals*> getGlobal(QualifiedName name, Type type) override {
    if (name.first != "spectest") {
      return std::nullopt;
    }

    if (name.second == "global_i32") {
      return &global_i32;
    }

    // todo
    return std::nullopt;
  }

private:
  // todo make it into a map
  Literals global_i32;
};

template<typename ModuleRunnerType>
class LinkedInstancesImportResolver : public ImportResolver {
public:
  LinkedInstancesImportResolver(
    std::map<Name, std::shared_ptr<ModuleRunnerType>> linkedInstances
    // SomeLinkedInstances linkedInstances;
    )
    : linkedInstances(linkedInstances) {}

  std::optional<Literals*> getGlobal(QualifiedName name, Type type) override {
    auto it = linkedInstances.find(name.first);
    if (it == linkedInstances.end()) {
      return std::nullopt;
    }

    ModuleRunnerType* instance = it->second.get();
    return instance->getExportedGlobal(name.second);
  }

  std::optional<Memory>
  getMemory(QualifiedName name /*, MemoryType type ? */) override {
    return std::nullopt;
  };
  std::optional<Table>
  getTable(QualifiedName name /*, TableType type ? */) override {
    return std::nullopt;
  };

  std::optional<Function> getFunction(QualifiedName name, Type type) override {
    return std::nullopt;
  };

  std::optional<Tag> getTag(QualifiedName name, Signature type) override {
    return std::nullopt;
  };

private:
  const std::map<Name, std::shared_ptr<ModuleRunnerType>> linkedInstances;
};

class ChainedImportResolver : public NullImportResolver {
public:
  ChainedImportResolver(
    std::vector<std::shared_ptr<ImportResolver>> importResolvers)
    : importResolvers(importResolvers) {}

  std::optional<Literals*> getGlobal(QualifiedName name, Type type) override {
    for (const auto& resolver : importResolvers) {
      if (auto global = resolver->getGlobal(name, type); global) {
        return global;
      }
    }

    return std::nullopt;
  }

private:
  std::vector<std::shared_ptr<ImportResolver>> importResolvers;
};

} // namespace wasm
