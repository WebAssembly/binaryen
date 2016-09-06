#include "wasm-emscripten.h"

#include "shared-constants.h"
#include "wasm.h"
#include "wasm-builder.h"
#include "asm_v_wasm.h"
#include "wasm-linker.h"
#include "asmjs/shared-constants.h"

namespace wasm {

cashew::IString EMSCRIPTEN_ASM_CONST("emscripten_asm_const");

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

void AsmConstWalker::visitCallImport(CallImport* curr) {
  if (curr->target == EMSCRIPTEN_ASM_CONST) {
    auto arg = curr->operands[0]->cast<Const>();
    Address segmentIndex = segmentsByAddress[arg->value.geti32()];
    std::string code = escape(&wasm.memory.segments[segmentIndex].data[0]);
    int32_t id;
    if (ids.count(code) == 0) {
      id = ids.size();
      ids[code] = id;
    } else {
      id = ids[code];
    }
    std::string sig = getSig(curr);
    sigsForCode[code].insert(sig);
    std::string fixedTarget = EMSCRIPTEN_ASM_CONST.str + std::string("_") + sig;
    curr->target = cashew::IString(fixedTarget.c_str(), false);
    arg->value = Literal(id);
    // add import, if necessary
    if (allSigs.count(sig) == 0) {
      allSigs.insert(sig);
      auto import = new Import;
      import->name = import->base = curr->target;
      import->module = ENV;
      import->type = ensureFunctionType(getSig(curr), &wasm);
      wasm.addImport(import);
    }
  }
}

std::string AsmConstWalker::escape(const char *input) {
  std::string code = input;
  // replace newlines quotes with escaped newlines
  size_t curr = 0;
  while ((curr = code.find("\\n", curr)) != std::string::npos) {
    code = code.replace(curr, 2, "\\\\n");
    curr += 3; // skip this one
  }
  // replace double quotes with escaped single quotes
  curr = 0;
  while ((curr = code.find('"', curr)) != std::string::npos) {
    if (curr == 0 || code[curr-1] != '\\') {
      code = code.replace(curr, 1, "\\" "\"");
      curr += 2; // skip this one
    } else { // already escaped, escape the slash as well
      code = code.replace(curr, 1, "\\" "\\" "\"");
      curr += 3; // skip this one
    }
  }
  return code;
}

} // namespace wasm
