/*
 * Copyright 2016 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "wasm-emscripten.h"

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "shared-constants.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace emscripten {

cashew::IString EMSCRIPTEN_ASM_CONST("emscripten_asm_const");

void generateMemoryGrowthFunction(Module& wasm) {
  Builder wasmBuilder(wasm);
  Name name(GROW_WASM_MEMORY);
  std::vector<NameType> params { { NEW_SIZE, i32 } };
  Function* growFunction = wasmBuilder.makeFunction(
    name, std::move(params), i32, {}
  );
  growFunction->body = wasmBuilder.makeHost(
    GrowMemory,
    Name(),
    { wasmBuilder.makeGetLocal(0, i32) }
  );

  wasm.addFunction(growFunction);
  auto export_ = new Export;
  export_->name = export_->value = name;
  export_->kind = ExternalKind::Function;
  wasm.addExport(export_);
}

static bool hasI64ResultOrParam(FunctionType* ft) {
  if (ft->result == i64) return true;
  for (auto ty : ft->params) {
    if (ty == i64) return true;
  }
  return false;
}

std::vector<Function*> makeDynCallThunks(Module& wasm, std::vector<Name> const& tableSegmentData) {
  wasm.removeImport(EMSCRIPTEN_ASM_CONST); // we create _sig versions

  std::vector<Function*> generatedFunctions;
  std::unordered_set<std::string> sigs;
  Builder wasmBuilder(wasm);
  for (const auto& indirectFunc : tableSegmentData) {
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

void addGlobalImports(Module& wasm, std::unordered_set<cashew::IString> const& globalImports) {
  for (Name name : globalImports) {
    auto import = new Import;
    import->name = import->base = name;
    import->module = ENV;
    import->kind = ExternalKind::Global;
    import->globalType = i32;
    wasm.addImport(import);
  }
}

struct AsmConstWalker : public PostWalker<AsmConstWalker, Visitor<AsmConstWalker>> {
  Module& wasm;
  std::unordered_map<Address, Address> segmentsByAddress; // address => segment index

  std::map<std::string, std::set<std::string>> sigsForCode;
  std::map<std::string, Address> ids;
  std::set<std::string> allSigs;

  AsmConstWalker(Module& _wasm, std::unordered_map<Address, Address> _segmentsByAddress) :
    wasm(_wasm), segmentsByAddress(_segmentsByAddress) { }

  void visitCallImport(CallImport* curr);

  std::string escape(const char *input);
};

void AsmConstWalker::visitCallImport(CallImport* curr) {
  if (curr->target == EMSCRIPTEN_ASM_CONST) {
    auto arg = curr->operands[0]->cast<Const>();
    auto address = arg->value.geti32();
    auto segmentIterator = segmentsByAddress.find(address);
    std::string code;
    if (segmentIterator != segmentsByAddress.end()) {
      Address segmentIndex = segmentsByAddress[address];
      code = escape(&wasm.memory.segments[segmentIndex].data[0]);
    } else {
      // If we can't find the segment corresponding with the address, then we omitted the segment and the address points to an empty string.
      code = escape("");
    }
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
      import->functionType = ensureFunctionType(getSig(curr), &wasm);
      import->kind = ExternalKind::Function;
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

template<class C>
void printSet(std::ostream& o, C& c) {
  o << "[";
  bool first = true;
  for (auto& item : c) {
    if (first) first = false;
    else o << ",";
    o << '"' << item << '"';
  }
  o << "]";
}

void generateEmscriptenMetadata(std::ostream& o,
                                Module& wasm,
                                std::unordered_map<Address, Address> segmentsByAddress,
                                Address staticBump,
                                std::vector<Name> const& initializerFunctions) {
  o << ";; METADATA: { ";
  // find asmConst calls, and emit their metadata
  AsmConstWalker walker(wasm, segmentsByAddress);
  walker.walkModule(&wasm);
  // print
  o << "\"asmConsts\": {";
  bool first = true;
  for (auto& pair : walker.sigsForCode) {
    auto& code = pair.first;
    auto& sigs = pair.second;
    if (first) first = false;
    else o << ",";
    o << '"' << walker.ids[code] << "\": [\"" << code << "\", ";
    printSet(o, sigs);
    o << "]";
  }
  o << "}";
  o << ",";
  o << "\"staticBump\": " << staticBump << ", ";

  o << "\"initializers\": [";
  first = true;
  for (const auto& func : initializerFunctions) {
    if (first) first = false;
    else o << ", ";
    o << "\"" << func.c_str() << "\"";
  }
  o << "]";

  o << " }\n";
}

} // namespace emscripten

} // namespace wasm
