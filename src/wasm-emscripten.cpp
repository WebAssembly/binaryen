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

bool hasI64ResultOrParam(FunctionType* ft) {
  if (ft->result == i64) return true;
  for (auto ty : ft->params) {
    if (ty == i64) return true;
  }
  return false;
}

std::vector<Function*> makeDynCallThunks(Module& wasm, std::vector<Name>& tableSegmentData) {
  std::vector<Function*> generatedFunctions;
  std::unordered_set<std::string> sigs;
  wasm::Builder wasmBuilder(wasm);
  for (const auto& indirectFunc : tableSegmentData) {
    // Skip generating thunks for the dummy function
    if (indirectFunc == dummyFunction) continue;
    std::string sig(getSig(wasm.getFunction(indirectFunc)));
    auto* funcType = ensureFunctionType(sig, &wasm);
    if (hasI64ResultOrParam(funcType)) continue; // Can't export i64s on the web.
    if (!sigs.insert(sig).second) continue; // Sig is already in the set
    std::vector<NameType> params;
    params.emplace_back("fptr", i32); // function pointer param
    int p = 0;
    for (const auto& ty : funcType->params) params.emplace_back(std::to_string(p++), ty);
    Function* f = wasmBuilder.makeFunction(std::string("dynCall_") + sig, std::move(params), funcType->result, {});
    Expression* fptr = wasmBuilder.makeGetLocal(0, i32);
    std::vector<Expression*> args;
    for (unsigned i = 0; i < funcType->params.size(); ++i) {
      args.push_back(wasmBuilder.makeGetLocal(i + 1, funcType->params[i]));
    }
    Expression* call = wasmBuilder.makeCallIndirect(funcType, fptr, args);
    f->body = call;
    wasm.addFunction(f);
    generatedFunctions.push_back(f);
  }
  return generatedFunctions;
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
