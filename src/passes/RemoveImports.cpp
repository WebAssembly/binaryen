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
  std::map<Name, Import*> importsMap;

  void prepare(PassRunner* runner, Module *module) override {
    allocator = runner->allocator;
    importsMap = module->importsMap;
  }

  void visitCallImport(CallImport *curr) override {
    WasmType type = importsMap[curr->target]->type.result;
    if (type == none) {
      replaceCurrent(allocator->alloc<Nop>());
    } else {
      Literal nopLiteral;
      nopLiteral.type = type;
      replaceCurrent(allocator->alloc<Const>()->set(nopLiteral));
    }
  }

  void visitModule(Module *curr) override {
    curr->importsMap.clear();
    curr->imports.clear();
  }
};

static RegisterPass<RemoveImports> registerPass("remove-imports", "removes imports and replaces them with nops");

} // namespace wasm

