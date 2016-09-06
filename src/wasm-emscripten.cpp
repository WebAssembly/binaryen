#include "wasm-emscripten.h"

#include "wasm.h"
#include "wasm-builder.h"

namespace wasm {

extern Name GROW_WASM_MEMORY;
extern Name NEW_SIZE;

void generateMemoryGrowthFunction(Module& wasm) {
  Builder wasmBuilder(wasm);
  Name name(GROW_WASM_MEMORY);
  std::vector<NameType> params { { NEW_SIZE, i32 } };
  Function* growFunction = wasmBuilder.makeFunction(
    name, std::move(params), none, {}
  );
  growFunction->body = wasmBuilder.makeHost(
    GrowMemory,
    Name(),
    { wasmBuilder.makeGetLocal(0, i32) }
  );

  wasm.addFunction(growFunction);
  auto export_ = new Export;
  export_->name = export_->value = name;
  wasm.addExport(export_);
}

} // namespace wasm
