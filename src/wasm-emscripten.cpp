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

#include <sstream>

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "shared-constants.h"
#include "wasm-builder.h"
#include "wasm-linker.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

cashew::IString EMSCRIPTEN_ASM_CONST("emscripten_asm_const");

static constexpr const char* dummyFunction = "__wasm_nullptr";

void addExportedFunction(Module& wasm, Function* function) {
  wasm.addFunction(function);
  auto export_ = new Export;
  export_->name = export_->value = function->name;
  export_->kind = ExternalKind::Function;
  wasm.addExport(export_);
}

Global* EmscriptenGlueGenerator::getStackPointerGlobal() {
  // Assumption: first global is __stack_pointer
  return wasm.globals[0].get();
}

Expression* EmscriptenGlueGenerator::generateLoadStackPointer() {
  if (!useStackPointerGlobal) {
    return builder.makeLoad(
      /* bytes  =*/ 4,
      /* signed =*/ false,
      /* offset =*/ stackPointerOffset,
      /* align  =*/ 4,
      /* ptr    =*/ builder.makeConst(Literal(0)),
      /* type   =*/ i32
    );
  }
  Global* stackPointer = getStackPointerGlobal();
  return builder.makeGetGlobal(stackPointer->name, i32);
}

Expression* EmscriptenGlueGenerator::generateStoreStackPointer(Expression* value) {
  if (!useStackPointerGlobal) {
    return builder.makeStore(
      /* bytes  =*/ 4,
      /* offset =*/ stackPointerOffset,
      /* align  =*/ 4,
      /* ptr    =*/ builder.makeConst(Literal(0)),
      /* value  =*/ value,
      /* type   =*/ i32
    );
  }
  Global* stackPointer = getStackPointerGlobal();
  return builder.makeSetGlobal(stackPointer->name, value);
}

void EmscriptenGlueGenerator::generateStackSaveFunction() {
  Name name("stackSave");
  std::vector<NameType> params { };
  Function* function = builder.makeFunction(
    name, std::move(params), i32, {}
  );

  function->body = generateLoadStackPointer();

  addExportedFunction(wasm, function);
}

void EmscriptenGlueGenerator::generateStackAllocFunction() {
  Name name("stackAlloc");
  std::vector<NameType> params { { "0", i32 } };
  Function* function = builder.makeFunction(
    name, std::move(params), i32, { { "1", i32 } }
  );
  Expression* loadStack = generateLoadStackPointer();
  GetLocal* getSizeArg = builder.makeGetLocal(0, i32);
  Binary* sub = builder.makeBinary(SubInt32, loadStack, getSizeArg);
  const static uint32_t bitAlignment = 16;
  const static uint32_t bitMask = bitAlignment - 1;
  Const* subConst = builder.makeConst(Literal(~bitMask));
  Binary* maskedSub = builder.makeBinary(AndInt32, sub, subConst);
  SetLocal* teeStackLocal = builder.makeTeeLocal(1, maskedSub);
  Expression* storeStack = generateStoreStackPointer(teeStackLocal);

  Block* block = builder.makeBlock();
  block->list.push_back(storeStack);
  GetLocal* getStackLocal2 = builder.makeGetLocal(1, i32);
  block->list.push_back(getStackLocal2);
  block->type = i32;
  function->body = block;

  addExportedFunction(wasm, function);
}

void EmscriptenGlueGenerator::generateStackRestoreFunction() {
  Name name("stackRestore");
  std::vector<NameType> params { { "0", i32 } };
  Function* function = builder.makeFunction(
    name, std::move(params), none, {}
  );
  GetLocal* getArg = builder.makeGetLocal(0, i32);
  Expression* store = generateStoreStackPointer(getArg);

  function->body = store;

  addExportedFunction(wasm, function);
}

void EmscriptenGlueGenerator::generateRuntimeFunctions() {
  generateStackSaveFunction();
  generateStackAllocFunction();
  generateStackRestoreFunction();
}

Function* EmscriptenGlueGenerator::generateMemoryGrowthFunction() {
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

  return growFunction;
}

static bool hasI64ResultOrParam(FunctionType* ft) {
  if (ft->result == i64) return true;
  for (auto ty : ft->params) {
    if (ty == i64) return true;
  }
  return false;
}

void EmscriptenGlueGenerator::generateDynCallThunks() {
  std::unordered_set<std::string> sigs;
  Builder builder(wasm);
  std::vector<Name> tableSegmentData;
  if (wasm.table.segments.size() > 0) {
    tableSegmentData = wasm.table.segments[0].data;
  }
  for (const auto& indirectFunc : tableSegmentData) {
    if (indirectFunc == dummyFunction) {
      continue;
    }
    std::string sig;
    if (auto import = wasm.getImportOrNull(indirectFunc)) {
      sig = getSig(wasm.getFunctionType(import->functionType));
    } else {
      sig = getSig(wasm.getFunction(indirectFunc));
    }
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
    exportFunction(wasm, f->name, true);
  }
}

struct JSCallWalker : public PostWalker<JSCallWalker> {
  Module &wasm;
  JSCallWalker(Module &_wasm) : wasm(_wasm) {
    if (wasm.table.segments.size() == 0) {
      auto emptySegment =
          wasm.allocator.alloc<Const>()->set(Literal(uint32_t(0)));
      wasm.table.segments.emplace_back(emptySegment);
    }
    const auto& tableSegmentData = wasm.table.segments[0].data;

    // Check if jsCalls have already been created
    for (Index i = 0; i < tableSegmentData.size(); ++i) {
      if (tableSegmentData[i].startsWith("jsCall_")) {
        jsCallStartIndex = i;
        return;
      }
    }
    jsCallStartIndex =
        wasm.table.segments[0].offset->cast<Const>()->value.getInteger() +
        tableSegmentData.size();
  }

  // Gather all function signatures used in call_indirect, because any of them
  // can be used to call function pointers created by emscripten's addFunction.
  void visitCallIndirect(CallIndirect *curr) {
    // dynCall thunks are generated in binaryen and call_indirect instructions
    // within them cannot be used to call function pointers returned by
    // emscripten's addFunction.
    if (!getFunction()->name.startsWith("dynCall_")) {
      indirectlyCallableSigs.insert(
          getSig(wasm.getFunctionType(curr->fullType)));
    }
  }

  bool createJSCallThunks;
  Index jsCallStartIndex;
  // Function type signatures used in call_indirect instructions
  std::set<std::string> indirectlyCallableSigs;
};

JSCallWalker getJSCallWalker(Module& wasm) {
  JSCallWalker walker(wasm);
  walker.walkModule(&wasm);
  return walker;
}

void EmscriptenGlueGenerator::generateJSCallThunks(
    unsigned numReservedFunctionPointers) {
  if (numReservedFunctionPointers == 0)
    return;

  JSCallWalker walker = getJSCallWalker(wasm);
  auto& tableSegmentData = wasm.table.segments[0].data;
  for (std::string sig : walker.indirectlyCallableSigs) {
    // Add imports for jsCall_sig (e.g. jsCall_vi).
    // Imported jsCall_sig functions have their first parameter as an index to
    // the function table, so we should prepend an 'i' to parameters' signature
    // (e.g. If the signature of the callee is 'vi', the imported jsCall_vi
    // function would have signature 'vii'.)
    std::string importSig = std::string(1, sig[0]) + 'i' + sig.substr(1);
    FunctionType *importType = ensureFunctionType(importSig, &wasm);
    auto import = new Import;
    import->name = import->base = "jsCall_" + sig;
    import->module = ENV;
    import->functionType = importType->name;
    import->kind = ExternalKind::Function;
    wasm.addImport(import);
    FunctionType *funcType = ensureFunctionType(sig, &wasm);

    // Create jsCall_sig_index thunks (e.g. jsCall_vi_0, jsCall_vi_1, ...)
    // e.g. If # of reserved function pointers (given by a command line
    // argument) is 3 and there are two possible signature 'vi' and 'ii', the
    // genereated thunks will be jsCall_vi_0, jsCall_vi_1, jsCall_vi_2,
    // jsCall_ii_0, jsCall_ii_1, and jsCall_ii_2.
    for (unsigned fp = 0; fp < numReservedFunctionPointers; ++fp) {
      std::vector<NameType> params;
      int p = 0;
      for (const auto& ty : funcType->params) {
        params.emplace_back(std::to_string(p++), ty);
      }
      Function* f = builder.makeFunction(
          std::string("jsCall_") + sig + "_" + std::to_string(fp),
          std::move(params), funcType->result, {});
      std::vector<Expression*> args;
      args.push_back(builder.makeConst(Literal(fp)));
      for (unsigned i = 0; i < funcType->params.size(); ++i) {
        args.push_back(builder.makeGetLocal(i, funcType->params[i]));
      }
      Expression* call =
          builder.makeCallImport(import->name, args, funcType->result);
      f->body = call;
      wasm.addFunction(f);
      tableSegmentData.push_back(f->name);
    }
  }
  wasm.table.initial = wasm.table.max =
      wasm.table.segments[0].offset->cast<Const>()->value.getInteger() +
      tableSegmentData.size();
}

struct AsmConstWalker : public PostWalker<AsmConstWalker> {
  Module& wasm;
  std::vector<Address> segmentOffsets; // segment index => address offset

  std::map<std::string, std::set<std::string>> sigsForCode;
  std::map<std::string, Address> ids;
  std::set<std::string> allSigs;

  AsmConstWalker(Module& _wasm) : wasm(_wasm) {
    for (unsigned i = 0; i < wasm.memory.segments.size(); ++i) {
      Const* addrConst = wasm.memory.segments[i].offset->cast<Const>();
      auto address = addrConst->value.geti32();
      segmentOffsets.push_back(address);
    }
  }

  void visitCallImport(CallImport* curr);

private:
  std::string codeForConstAddr(Const* addrConst);
  const char* stringAtAddr(Address adddress);
  Literal idLiteralForCode(std::string code);
  std::string asmConstSig(std::string baseSig);
  Name nameForImportWithSig(std::string sig);
  void addImport(Name importName, std::string baseSig);
  std::string escape(const char *input);
};

void AsmConstWalker::visitCallImport(CallImport* curr) {
  Import* import = wasm.getImport(curr->target);
  if (import->base.hasSubstring(EMSCRIPTEN_ASM_CONST)) {
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
  const char* str = stringAtAddr(address);
  if (!str) {
    // If we can't find the segment corresponding with the address, then we
    // omitted the segment and the address points to an empty string.
    return escape("");
  }
  auto result = escape(str);
  return result;
}

const char* AsmConstWalker::stringAtAddr(Address address) {
  for (unsigned i = 0; i < wasm.memory.segments.size(); ++i) {
    Memory::Segment &segment = wasm.memory.segments[i];
    Address offset = segmentOffsets[i];
    if (address >= offset && address < offset + segment.data.size()) {
      return &segment.data[address - offset];
    }
  }
  return nullptr;
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

AsmConstWalker fixEmAsmConstsAndReturnWalker(Module& wasm) {
  // Collect imports to remove
  // This would find our generated functions if we ran it later
  std::vector<Name> toRemove;
  for (auto& import : wasm.imports) {
    if (import->base.hasSubstring(EMSCRIPTEN_ASM_CONST)) {
      toRemove.push_back(import->name);
    }
  }

  // Walk the module, generate _sig versions of EM_ASM functions
  AsmConstWalker walker(wasm);
  walker.walkModule(&wasm);

  // Remove the base functions that we didn't generate
  for (auto importName : toRemove) {
    wasm.removeImport(importName);
  }
  return walker;
}

void EmscriptenGlueGenerator::fixEmAsmConsts() {
  fixEmAsmConstsAndReturnWalker(wasm);
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

std::string EmscriptenGlueGenerator::generateEmscriptenMetadata(
    Address staticBump, std::vector<Name> const& initializerFunctions,
    unsigned numReservedFunctionPointers) {
  std::stringstream meta;
  meta << "{ ";

  AsmConstWalker emAsmWalker = fixEmAsmConstsAndReturnWalker(wasm);

  // print
  meta << "\"asmConsts\": {";
  bool first = true;
  for (auto& pair : emAsmWalker.sigsForCode) {
    auto& code = pair.first;
    auto& sigs = pair.second;
    if (first) first = false;
    else meta << ",";
    meta << '"' << emAsmWalker.ids[code] << "\": [\"" << code << "\", ";
    printSet(meta, sigs);
    meta << "]";
  }
  meta << "}";
  meta << ",";
  meta << "\"staticBump\": " << staticBump << ", ";

  meta << "\"initializers\": [";
  first = true;
  for (const auto& func : initializerFunctions) {
    if (first) first = false;
    else meta << ", ";
    meta << "\"" << func.c_str() << "\"";
  }
  meta << "]";

  if (numReservedFunctionPointers) {
    JSCallWalker jsCallWalker = getJSCallWalker(wasm);
    meta << ", ";
    meta << "\"jsCallStartIndex\": " << jsCallWalker.jsCallStartIndex << ", ";
    meta << "\"jsCallFuncType\": [";
    bool first = true;
    for (std::string sig : jsCallWalker.indirectlyCallableSigs) {
      if (!first) meta << ", ";
      first = false;
      meta << "\"" << sig << "\"";
    }
    meta << "]";
  }

  meta << " }\n";

  return meta.str();
}

std::string emscriptenGlue(
    Module& wasm,
    bool allowMemoryGrowth,
    Address stackPointer,
    Address staticBump,
    std::vector<Name> const& initializerFunctions,
    unsigned numReservedFunctionPointers) {
  EmscriptenGlueGenerator generator(wasm, stackPointer);
  generator.generateRuntimeFunctions();

  if (allowMemoryGrowth) {
    generator.generateMemoryGrowthFunction();
  }

  generator.generateDynCallThunks();

  if (numReservedFunctionPointers) {
    generator.generateJSCallThunks(numReservedFunctionPointers);
  }

  return generator.generateEmscriptenMetadata(staticBump, initializerFunctions,
                                              numReservedFunctionPointers);
}

} // namespace wasm
