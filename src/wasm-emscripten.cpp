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
#include "wasm-linker.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace emscripten {

cashew::IString EMSCRIPTEN_ASM_CONST("emscripten_asm_const");

static constexpr const char* stackPointer = "__stack_pointer";

void addExportedFunction(Module& wasm, Function* function) {
  wasm.addFunction(function);
  auto export_ = new Export;
  export_->name = export_->value = function->name;
  export_->kind = ExternalKind::Function;
  wasm.addExport(export_);
}

void generateMemoryGrowthFunction(Module& wasm) {
  Builder builder(wasm);
  Name name(GROW_WASM_MEMORY);
  std::vector<NameType> params { { NEW_SIZE, i32 } };
  Function* growFunction = builder.makeFunction(
    name, std::move(params), i32, {}
  );
  growFunction->body = builder.makeHost(
    GrowMemory,
    Name(),
    { builder.makeGetLocal(0, i32) }
  );

  addExportedFunction(wasm, growFunction);
}

void addStackPointerRelocation(LinkerObject& linker, uint32_t* data) {
  linker.addRelocation(new LinkerObject::Relocation(
    LinkerObject::Relocation::kData,
    data,
    Name(stackPointer),
    0
  ));
}

Load* generateLoadStackPointer(Builder& builder, LinkerObject& linker) {
  Load* load = builder.makeLoad(
    /* bytes  =*/ 4,
    /* signed =*/ false,
    /* offset =*/ 0,
    /* align  =*/ 4,
    /* ptr    =*/ builder.makeConst(Literal(0)),
    /* type   =*/ i32
  );
  addStackPointerRelocation(linker, &load->offset.addr);
  return load;
}

Store* generateStoreStackPointer(Builder& builder,
                                 LinkerObject& linker,
                                 Expression* value) {
  Store* store = builder.makeStore(
    /* bytes  =*/ 4,
    /* offset =*/ 0,
    /* align  =*/ 4,
    /* ptr    =*/ builder.makeConst(Literal(0)),
    /* value  =*/ value,
    /* type   =*/ i32
  );
  addStackPointerRelocation(linker, &store->offset.addr);
  return store;
}

void generateStackSaveFunction(LinkerObject& linker) {
  Module& wasm = linker.wasm;
  Builder builder(wasm);
  Name name("stackSave");
  std::vector<NameType> params { };
  Function* function = builder.makeFunction(
    name, std::move(params), i32, {}
  );

  function->body = generateLoadStackPointer(builder, linker);

  addExportedFunction(wasm, function);
}

void generateStackAllocFunction(LinkerObject& linker) {
  Module& wasm = linker.wasm;
  Builder builder(wasm);
  Name name("stackAlloc");
  std::vector<NameType> params { { "0", i32 } };
  Function* function = builder.makeFunction(
    name, std::move(params), i32, { { "1", i32 } }
  );
  Load* loadStack = generateLoadStackPointer(builder, linker);
  SetLocal* setStackLocal = builder.makeSetLocal(1, loadStack);
  GetLocal* getStackLocal = builder.makeGetLocal(1, i32);
  GetLocal* getSizeArg = builder.makeGetLocal(0, i32);
  Binary* add = builder.makeBinary(AddInt32, getStackLocal, getSizeArg);
  const static uint32_t bitAlignment = 16;
  const static uint32_t bitMask = bitAlignment - 1;
  Const* addConst = builder.makeConst(Literal(bitMask));
  Binary* maskedAdd = builder.makeBinary(
    AndInt32,
    builder.makeBinary(AddInt32, add, addConst),
    builder.makeConst(Literal(~bitMask))
  );
  Store* storeStack = generateStoreStackPointer(builder, linker, maskedAdd);

  Block* block = builder.makeBlock();
  block->list.push_back(setStackLocal);
  block->list.push_back(storeStack);
  block->list.push_back(getStackLocal);
  block->type = i32;
  function->body = block;

  addExportedFunction(wasm, function);
}

void generateStackRestoreFunction(LinkerObject& linker) {
  Module& wasm = linker.wasm;
  Builder builder(wasm);
  Name name("stackRestore");
  std::vector<NameType> params { { "0", i32 } };
  Function* function = builder.makeFunction(
    name, std::move(params), none, {}
  );
  GetLocal* getArg = builder.makeGetLocal(0, i32);
  Store* store = generateStoreStackPointer(builder, linker, getArg);

  function->body = store;

  addExportedFunction(wasm, function);
}

void generateRuntimeFunctions(LinkerObject& linker) {
  generateStackSaveFunction(linker);
  generateStackAllocFunction(linker);
  generateStackRestoreFunction(linker);
}

static bool hasI64ResultOrParam(FunctionType* ft) {
  if (ft->result == i64) return true;
  for (auto ty : ft->params) {
    if (ty == i64) return true;
  }
  return false;
}

void removeImportsWithSubstring(Module& module, Name name) {
  std::vector<Name> toRemove;
  for (auto& import : module.imports) {
    if (import->name.hasSubstring(name)) {
      toRemove.push_back(import->name);
    }
  }
  for (auto importName : toRemove) {
    module.removeImport(importName);
  }
}

std::vector<Function*> makeDynCallThunks(Module& wasm, std::vector<Name> const& tableSegmentData) {
  removeImportsWithSubstring(wasm, EMSCRIPTEN_ASM_CONST); // we create _sig versions

  std::vector<Function*> generatedFunctions;
  std::unordered_set<std::string> sigs;
  Builder builder(wasm);
  for (const auto& indirectFunc : tableSegmentData) {
    std::string sig(getSig(wasm.getFunction(indirectFunc)));
    auto* funcType = ensureFunctionType(sig, &wasm);
    if (hasI64ResultOrParam(funcType)) continue; // Can't export i64s on the web.
    if (!sigs.insert(sig).second) continue; // Sig is already in the set
    std::vector<NameType> params;
    params.emplace_back("fptr", i32); // function pointer param
    int p = 0;
    for (const auto& ty : funcType->params) params.emplace_back(std::to_string(p++), ty);
    Function* f = builder.makeFunction(std::string("dynCall_") + sig, std::move(params), funcType->result, {});
    Expression* fptr = builder.makeGetLocal(0, i32);
    std::vector<Expression*> args;
    for (unsigned i = 0; i < funcType->params.size(); ++i) {
      args.push_back(builder.makeGetLocal(i + 1, funcType->params[i]));
    }
    Expression* call = builder.makeCallIndirect(funcType, fptr, args);
    f->body = call;
    wasm.addFunction(f);
    generatedFunctions.push_back(f);
  }
  return generatedFunctions;
}

struct AsmConstWalker : public PostWalker<AsmConstWalker> {
  Module& wasm;
  std::unordered_map<Address, Address> segmentsByAddress; // address => segment index

  std::map<std::string, std::set<std::string>> sigsForCode;
  std::map<std::string, Address> ids;
  std::set<std::string> allSigs;

  AsmConstWalker(Module& _wasm, std::unordered_map<Address, Address> _segmentsByAddress) :
    wasm(_wasm), segmentsByAddress(_segmentsByAddress) { }

  void visitCallImport(CallImport* curr);

private:
  std::string codeForConstAddr(Const* addrConst);
  Literal idLiteralForCode(std::string code);
  std::string asmConstSig(std::string baseSig);
  Name nameForImportWithSig(std::string sig);
  void addImport(Name importName, std::string baseSig);
  std::string escape(const char *input);
};

void AsmConstWalker::visitCallImport(CallImport* curr) {
  if (curr->target.hasSubstring(EMSCRIPTEN_ASM_CONST)) {
    auto arg = curr->operands[0]->cast<Const>();
    auto code = codeForConstAddr(arg);
    arg->value = idLiteralForCode(code);
    auto baseSig = getSig(curr);
    auto sig = asmConstSig(baseSig);
    sigsForCode[code].insert(sig);
    auto importName = nameForImportWithSig(sig);
    curr->target = importName;

    if (allSigs.count(sig) == 0) {
      allSigs.insert(sig);
      addImport(importName, baseSig);
    }
  }
}

std::string AsmConstWalker::codeForConstAddr(Const* addrConst) {
  auto address = addrConst->value.geti32();
  auto segmentIterator = segmentsByAddress.find(address);
  if (segmentIterator == segmentsByAddress.end()) {
    // If we can't find the segment corresponding with the address, then we omitted the segment and the address points to an empty string.
    return escape("");
  }
  Address segmentIndex = segmentsByAddress[address];
  return escape(&wasm.memory.segments[segmentIndex].data[0]);
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

Literal AsmConstWalker::idLiteralForCode(std::string code) {
  int32_t id;
  if (ids.count(code) == 0) {
    id = ids.size();
    ids[code] = id;
  } else {
    id = ids[code];
  }
  return Literal(id);
}

std::string AsmConstWalker::asmConstSig(std::string baseSig) {
  std::string sig = "";
  for (size_t i = 0; i < baseSig.size(); ++i) {
    // Omit the signature of the "code" parameter, taken as a string, as the first argument
    if (i != 1) {
      sig += baseSig[i];
    }
  }
  return sig;
}

Name AsmConstWalker::nameForImportWithSig(std::string sig) {
  std::string fixedTarget = EMSCRIPTEN_ASM_CONST.str + std::string("_") + sig;
  return Name(fixedTarget.c_str());
}

void AsmConstWalker::addImport(Name importName, std::string baseSig) {
  auto import = new Import;
  import->name = import->base = importName;
  import->module = ENV;
  import->functionType = ensureFunctionType(baseSig, &wasm)->name;
  import->kind = ExternalKind::Function;
  wasm.addImport(import);
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
