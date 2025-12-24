#include "wasm/import-resolver.h"
#include "wasm-interpreter.h"

namespace wasm {

LinkedInstancesImportResolver::LinkedInstancesImportResolver(
  std::map<Name, std::shared_ptr<ModuleRunnerInterface>> linkedInstances
  // SomeLinkedInstances linkedInstances
  )
  : linkedInstances(linkedInstances) {}

std::optional<Literals*>
LinkedInstancesImportResolver::getGlobal(QualifiedName name, Type type) {
  // TODO: these two lines may fail
  auto* instance = linkedInstances.find(name.first)->second.get();
  auto* global = instance->definedGlobals[name.second];
  return global;
}

std::optional<Memory> LinkedInstancesImportResolver::getMemory(
  QualifiedName name /*, MemoryType type ? */) {
  return std::nullopt;
}

std::optional<Table> LinkedInstancesImportResolver::getTable(
  QualifiedName name /*, TableType type ? */) {
  return std::nullopt;
}

std::optional<Function>
LinkedInstancesImportResolver::getFunction(QualifiedName name, Type type) {
  return std::nullopt;
}

std::optional<Tag> LinkedInstancesImportResolver::getTag(QualifiedName name,
                                                         Signature type) {
  return std::nullopt;
}

} // namespace wasm
