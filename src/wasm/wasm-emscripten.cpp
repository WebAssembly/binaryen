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
#include "wasm-traversal.h"
#include "wasm.h"
#include "ir/function-type-utils.h"
#include "ir/module-utils.h"

namespace wasm {

cashew::IString EMSCRIPTEN_ASM_CONST("emscripten_asm_const");
cashew::IString EM_JS_PREFIX("__em_js__");

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
  // TODO(sbc): Once mutable globals are a thing we shouldn't need this
  // at all since we can simply export __stack_pointer.
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

inline void exportFunction(Module& wasm, Name name, bool must_export) {
  if (!wasm.getFunctionOrNull(name)) {
    assert(!must_export);
    return;
  }
  if (wasm.getExportOrNull(name)) return; // Already exported
  auto exp = new Export;
  exp->name = exp->value = name;
  exp->kind = ExternalKind::Function;
  wasm.addExport(exp);
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
    std::string sig = getSig(wasm.getFunction(indirectFunc));
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

    jsCallStartIndex =
        wasm.table.segments[0].offset->cast<Const>()->value.getInteger();
    // Check if jsCalls have already been created
    for (Index i = 0; i < tableSegmentData.size(); ++i) {
      if (tableSegmentData[i].startsWith("jsCall_")) {
        jsCallStartIndex += i;
        return;
      }
    }
    jsCallStartIndex += tableSegmentData.size();
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
    auto import = new Function;
    import->name = import->base = "jsCall_" + sig;
    import->module = ENV;
    import->type = importType->name;
    FunctionTypeUtils::fillFunction(import, importType);
    wasm.addFunction(import);
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
          builder.makeCall(import->name, args, funcType->result);
      f->body = call;
      wasm.addFunction(f);
      tableSegmentData.push_back(f->name);
    }
  }
  wasm.table.initial = wasm.table.max =
      wasm.table.segments[0].offset->cast<Const>()->value.getInteger() +
      tableSegmentData.size();
}

std::vector<Address> getSegmentOffsets(Module& wasm) {
  std::vector<Address> segmentOffsets;
  for (unsigned i = 0; i < wasm.memory.segments.size(); ++i) {
    if (auto* addrConst = wasm.memory.segments[i].offset->dynCast<Const>()) {
      auto address = addrConst->value.geti32();
      segmentOffsets.push_back(address);
    } else {
      // TODO(sbc): Wasm shared libraries have data segments with non-const
      // offset.
      segmentOffsets.push_back(0);
    }
  }
  return segmentOffsets;
}

std::string escape(const char *input) {
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

const char* stringAtAddr(Module& wasm,
                         std::vector<Address> const& segmentOffsets,
                         Address address) {
  for (unsigned i = 0; i < wasm.memory.segments.size(); ++i) {
    Memory::Segment& segment = wasm.memory.segments[i];
    Address offset = segmentOffsets[i];
    if (address >= offset && address < offset + segment.data.size()) {
      return &segment.data[address - offset];
    }
  }
  return nullptr;
}

std::string codeForConstAddr(Module& wasm,
                             std::vector<Address> const& segmentOffsets,
                             Const* addrConst) {
  auto address = addrConst->value.geti32();
  const char* str = stringAtAddr(wasm, segmentOffsets, address);
  if (!str) {
    // If we can't find the segment corresponding with the address, then we
    // omitted the segment and the address points to an empty string.
    return escape("");
  }
  return escape(str);
}

struct AsmConstWalker : public PostWalker<AsmConstWalker> {
  Module& wasm;
  std::vector<Address> segmentOffsets; // segment index => address offset

  std::map<std::string, std::set<std::string>> sigsForCode;
  std::map<std::string, Address> ids;
  std::set<std::string> allSigs;

  AsmConstWalker(Module& _wasm)
    : wasm(_wasm),
      segmentOffsets(getSegmentOffsets(wasm)) { }

  void visitCall(Call* curr);
  void visitTable(Table* curr);

  void process();

private:
  std::string fixupNameWithSig(Name& name, std::string baseSig);
  Literal idLiteralForCode(std::string code);
  std::string asmConstSig(std::string baseSig);
  Name nameForImportWithSig(std::string sig);
  void queueImport(Name importName, std::string baseSig);
  void addImports();

  std::vector<std::unique_ptr<Function>> queuedImports;
};

void AsmConstWalker::visitCall(Call* curr) {
  auto* import = wasm.getFunction(curr->target);
  if (import->imported() && import->base.hasSubstring(EMSCRIPTEN_ASM_CONST)) {
    auto baseSig = getSig(curr);
    auto sig = fixupNameWithSig(curr->target, baseSig);

    auto arg = curr->operands[0]->cast<Const>();
    auto code = codeForConstAddr(wasm, segmentOffsets, arg);
    arg->value = idLiteralForCode(code);
    sigsForCode[code].insert(sig);
  }
}

void AsmConstWalker::visitTable(Table* curr) {
  for (auto& segment : curr->segments) {
    for (auto& name : segment.data) {
      auto* func = wasm.getFunction(name);
      if (func->imported() && func->base.hasSubstring(EMSCRIPTEN_ASM_CONST)) {
        std::string baseSig = getSig(func);
        fixupNameWithSig(name, baseSig);
      }
    }
  }
}

void AsmConstWalker::process() {
  // Find and queue necessary imports
  walkModule(&wasm);
  // Add them after the walk, to avoid iterator invalidation on
  // the list of functions.
  addImports();
}

std::string AsmConstWalker::fixupNameWithSig(Name& name, std::string baseSig) {
  auto sig = asmConstSig(baseSig);
  auto importName = nameForImportWithSig(sig);
  name = importName;

  if (allSigs.count(sig) == 0) {
    allSigs.insert(sig);
    queueImport(importName, baseSig);
  }
  return sig;
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

void AsmConstWalker::queueImport(Name importName, std::string baseSig) {
  auto import = new Function;
  import->name = import->base = importName;
  import->module = ENV;
  import->type = ensureFunctionType(baseSig, &wasm)->name;
  queuedImports.push_back(std::unique_ptr<Function>(import));
}

void AsmConstWalker::addImports() {
  for (auto& import : queuedImports) {
    wasm.addFunction(import.release());
  }
}

AsmConstWalker fixEmAsmConstsAndReturnWalker(Module& wasm) {
  // Collect imports to remove
  // This would find our generated functions if we ran it later
  std::vector<Name> toRemove;
  for (auto& import : wasm.functions) {
    if (import->imported() && import->base.hasSubstring(EMSCRIPTEN_ASM_CONST)) {
      toRemove.push_back(import->name);
    }
  }

  // Walk the module, generate _sig versions of EM_ASM functions
  AsmConstWalker walker(wasm);
  walker.process();

  // Remove the base functions that we didn't generate
  for (auto importName : toRemove) {
    wasm.removeFunction(importName);
  }
  return walker;
}

struct EmJsWalker : public PostWalker<EmJsWalker> {
  Module& wasm;
  std::vector<Address> segmentOffsets; // segment index => address offset

  std::map<std::string, std::string> codeByName;

  EmJsWalker(Module& _wasm)
    : wasm(_wasm),
      segmentOffsets(getSegmentOffsets(wasm)) { }

  void visitFunction(Function* curr) {
    if (curr->imported()) {
      return;
    }
    if (!curr->name.startsWith(EM_JS_PREFIX.str)) {
      return;
    }
    auto funcName = std::string(curr->name.stripPrefix(EM_JS_PREFIX.str));
    auto addrConst = curr->body->dynCast<Const>();
    if (addrConst == nullptr) {
      auto block = curr->body->dynCast<Block>();
      Expression* first = nullptr;
      if (block && block->list.size() > 0) {
        first = block->list[0];
      }
      if (first) {
        addrConst = first->dynCast<Const>();
      }
    }
    if (addrConst == nullptr) {
      Fatal() << "Unexpected generated __em_js__ function body: " << curr;
    }
    auto code = codeForConstAddr(wasm, segmentOffsets, addrConst);
    codeByName[funcName] = code;
  }
};

EmJsWalker fixEmJsFuncsAndReturnWalker(Module& wasm) {
  EmJsWalker walker(wasm);
  walker.walkModule(&wasm);

  std::vector<Name> toRemove;
  for (auto& func : wasm.functions) {
    if (func->name.startsWith(EM_JS_PREFIX.str)) {
      toRemove.push_back(func->name);
    }
  }
  for (auto funcName : toRemove) {
    wasm.removeFunction(funcName);
    wasm.removeExport(funcName);
  }
  return walker;
}

// Fixes function name hacks caused by LLVM exception & setjmp/longjmp
// handling pass for wasm.
// This does two things:
// 1. Change emscripten_longjmp_jmpbuf to emscripten_longjmp.
//    In setjmp/longjmp handling pass in wasm backend, what we want to do is
//    to change all function calls to longjmp to calls to emscripten_longjmp.
//    Because we replace all calls to longjmp to emscripten_longjmp, the
//    signature of that function should be the same as longjmp:
//    emscripten_longjmp(jmp_buf, int)
//    But after calling a function that might longjmp, while we test whether
//    a longjmp occurred, we have to load an int address value and call
//    emscripten_longjmp again with that address as the first argument. (Refer
//    to lib/Target/WebAssembly/WebAssemblyEmscriptenEHSjLj.cpp in LLVM for
//    details.)
//    In this case we need the signature of emscripten_longjmp to be (int,
//    int). So we need two different kinds of emscripten_longjmp signatures in
//    LLVM IR. Both signatures will be lowered to (int, int) eventually, but
//    in LLVM IR, types are not lowered yet.
//    So we declare two functions in LLVM:
//    emscripten_longjmp_jmpbuf(jmp_buf, int)
//    emscripten_longjmp(int, int)
//    And we change the name of emscripten_longjmp_jmpbuf to
//    emscripten_longjmp here.
// 2. Converts invoke wrapper names.
//    Refer to the comments in fixEmExceptionInvoke below.
struct FixInvokeFunctionNamesWalker : public PostWalker<FixInvokeFunctionNamesWalker> {
  Module& wasm;
  std::map<Name, Name> importRenames;
  std::vector<Name> toRemove;
  std::set<Name> newImports;

  FixInvokeFunctionNamesWalker(Module& _wasm) : wasm(_wasm) {}

  // Converts invoke wrapper names generated by LLVM backend to real invoke
  // wrapper names that are expected by JavaScript glue code.
  // This is required to support wasm exception handling (asm.js style).
  //
  // LLVM backend lowers
  //   invoke @func(arg1, arg2) to label %invoke.cont unwind label %lpad
  // into
  // ... (some code)
  //   call @invoke_SIG(func, arg1, arg2)
  // ... (some code)
  // SIG is a mangled string generated based on the LLVM IR-level function
  // signature. In LLVM IR, types are not lowered yet, so this mangling scheme
  // simply takes LLVM's string representtion of parameter types and concatenate
  // them with '_'. For example, the name of an invoke wrapper for function
  // void foo(struct mystruct*, int) will be
  // "__invoke_void_%struct.mystruct*_int".
  // This function converts the names of invoke wrappers based on their lowered
  // argument types and a return type. In the example above, the resulting new
  // wrapper name becomes "invoke_vii".
  static Name fixEmExceptionInvoke(const Name& name, const std::string& sig) {
    std::string nameStr = name.c_str();
    if (nameStr.front() == '"' && nameStr.back() == '"') {
      nameStr = nameStr.substr(1, nameStr.size() - 2);
    }
    if (nameStr.find("__invoke_") != 0) {
      return name;
    }
    std::string sigWoOrigFunc = sig.front() + sig.substr(2, sig.size() - 2);
    return Name("invoke_" + sigWoOrigFunc);
  }

  static Name fixEmEHSjLjNames(const Name &name, const std::string& sig) {
    if (name == "emscripten_longjmp_jmpbuf")
      return "emscripten_longjmp";
    return fixEmExceptionInvoke(name, sig);
  }

  void visitFunction(Function* curr) {
    if (!curr->imported()) {
      return;
    }

    FunctionType* func = wasm.getFunctionType(curr->type);
    Name newname = fixEmEHSjLjNames(curr->base, getSig(func));
    if (newname == curr->base) {
      return;
    }

    assert(importRenames.count(curr->name) == 0);
    importRenames[curr->name] = newname;
    // Either rename or remove the existing import
    if (wasm.getFunctionOrNull(newname) || !newImports.insert(newname).second) {
      toRemove.push_back(curr->name);
    } else {
      curr->base = newname;
      curr->name = newname;
    }
  }

  void visitTable(Table* curr) {
    for (auto& segment : curr->segments) {
      for (size_t i = 0; i < segment.data.size(); i++) {
        auto it = importRenames.find(segment.data[i]);
        if (it != importRenames.end()) {
          segment.data[i] = it->second;
        }
      }
    }
  }

  void visitCall(Call* curr) {
    if (wasm.getFunction(curr->target)->imported()) {
      auto it = importRenames.find(curr->target);
      if (it != importRenames.end()) {
        curr->target = it->second;
      }
    }
  }

  void visitModule(Module* curr) {
    for (auto importName : toRemove) {
      wasm.removeFunction(importName);
    }
    wasm.updateMaps();
  }
};

void EmscriptenGlueGenerator::fixInvokeFunctionNames() {
  FixInvokeFunctionNamesWalker walker(wasm);
  walker.walkModule(&wasm);
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
  bool commaFirst;
  auto maybeComma = [&commaFirst]() {
    if (commaFirst) {
      commaFirst = false;
      return "";
    } else {
      return ",";
    }
  };

  std::stringstream meta;
  meta << "{ ";

  AsmConstWalker emAsmWalker = fixEmAsmConstsAndReturnWalker(wasm);

  // print
  commaFirst = true;
  meta << "\"asmConsts\": {";
  for (auto& pair : emAsmWalker.sigsForCode) {
    auto& code = pair.first;
    auto& sigs = pair.second;
    meta << maybeComma();
    meta << '"' << emAsmWalker.ids[code] << "\": [\"" << code << "\", ";
    printSet(meta, sigs);
    meta << ", ";

    // TODO: proxying to main thread. Currently this is unsupported, so proxy
    // mode is "none", represented by an empty string.
    meta << "[\"\"]";

    meta << "]";
  }
  meta << "},";

  EmJsWalker emJsWalker = fixEmJsFuncsAndReturnWalker(wasm);
  if (emJsWalker.codeByName.size() > 0) {
    meta << "\"emJsFuncs\": {";
    commaFirst = true;
    for (auto& pair : emJsWalker.codeByName) {
      auto& name = pair.first;
      auto& code = pair.second;
      meta << maybeComma();
      meta << '"' << name << "\": \"" << code << '"';
    }
    meta << "},";
  }

  meta << "\"staticBump\": " << staticBump << ", ";

  meta << "\"initializers\": [";
  commaFirst = true;
  for (const auto& func : initializerFunctions) {
    meta << maybeComma();
    meta << "\"" << func.c_str() << "\"";
  }
  meta << "]";

  if (numReservedFunctionPointers) {
    JSCallWalker jsCallWalker = getJSCallWalker(wasm);
    meta << ", ";
    meta << "\"jsCallStartIndex\": " << jsCallWalker.jsCallStartIndex << ", ";
    meta << "\"jsCallFuncType\": [";
    commaFirst = true;
    for (std::string sig : jsCallWalker.indirectlyCallableSigs) {
      meta << maybeComma();
      meta << "\"" << sig << "\"";
    }
    meta << "]";
  }

  // Avoid adding duplicate imports to `declares' or `invokeFuncs`.  Even
  // though we might import the same function multiple times (i.e. with
  // different sigs) we only need to list is in the metadata once.
  std::set<std::string> declares;
  std::set<std::string> invokeFuncs;

  // We use the `base` rather than the `name` of the imports here and below
  // becasue this is the externally visible name that the embedder (JS) will
  // see.
  meta << ", \"declares\": [";
  commaFirst = true;
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    if (emJsWalker.codeByName.count(import->base.str) == 0 &&
        !import->base.startsWith(EMSCRIPTEN_ASM_CONST.str) &&
        !import->base.startsWith("invoke_") &&
        !import->base.startsWith("jsCall_")) {
      if (declares.insert(import->base.str).second) {
        meta << maybeComma() << '"' << import->base.str << '"';
      }
    }
  });
  meta << "]";

  meta << ", \"externs\": [";
  commaFirst = true;
  ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
    meta << maybeComma() << "\"_" << import->base.str << '"';
  });
  meta << "]";

  meta << ", \"implementedFunctions\": [";
  commaFirst = true;
  for (const auto& ex : wasm.exports) {
    if (ex->kind == ExternalKind::Function) {
      meta << maybeComma() << "\"_" << ex->name.str << '"';
    }
  }
  meta << "]";

  meta << ", \"exports\": [";
  commaFirst = true;
  for (const auto& ex : wasm.exports) {
    meta << maybeComma() << '"' << ex->name.str << '"';
  }
  meta << "]";

  meta << ", \"invokeFuncs\": [";
  commaFirst = true;
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    if (import->base.startsWith("invoke_")) {
      if (invokeFuncs.insert(import->base.str).second) {
        meta << maybeComma() << '"' << import->base.str << '"';
      }
    }
  });
  meta << "]";

  meta << " }\n";

  return meta.str();
}

void EmscriptenGlueGenerator::separateDataSegments(Output* outfile) {
  size_t lastEnd = 0;
  for (Memory::Segment& seg : wasm.memory.segments) {
    size_t offset = seg.offset->cast<Const>()->value.geti32();
    size_t fill = offset - lastEnd;
    if (fill > 0) {
      std::vector<char> buf(fill);
      outfile->write(buf.data(), fill);
    }
    outfile->write(seg.data.data(), seg.data.size());
    lastEnd = offset + seg.data.size();
  }
  wasm.memory.segments.clear();
}

} // namespace wasm
