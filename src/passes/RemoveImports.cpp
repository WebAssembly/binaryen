//
// Removeds imports, and replaces them with nops. This is useful
// for running a module through the reference interpreter, which
// does not validate imports for a JS environment (by removing
// imports, we can at least get the reference interpreter to
// look at all the rest of the code).
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct RemoveImports : public Pass {
  MixedArena* allocator;

  void prepare(PassRunner* runner, Module *module) override {
    allocator = runner->allocator;
  }

  void visitCallImport(CallImport *curr) override {
    replaceCurrent(allocator->alloc<Nop>());
  }

  void visitModule(Module *curr) {
    auto imports = curr->imports;
    for (auto import : imports) {
      curr->removeImport(import->name);
    }
  }
};

static RegisterPass<RemoveImports> registerPass("remove-imports", "removes imports and replaces them with nops");

} // namespace wasm

