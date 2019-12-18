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
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "ir/module-utils.h"
#include "shared-constants.h"
#include "support/debug.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

#define DEBUG_TYPE "emscripten"

namespace wasm {

cashew::IString EM_ASM_PREFIX("emscripten_asm_const");
cashew::IString EM_JS_PREFIX("__em_js__");

static Name STACK_SAVE("stackSave");
static Name STACK_RESTORE("stackRestore");
static Name STACK_ALLOC("stackAlloc");
static Name STACK_INIT("stack$init");
static Name STACK_LIMIT("__stack_limit");
static Name SET_STACK_LIMIT("__set_stack_limit");
static Name POST_INSTANTIATE("__post_instantiate");
static Name ASSIGN_GOT_ENTIRES("__assign_got_enties");
static Name STACK_OVERFLOW_IMPORT("__handle_stack_overflow");

void addExportedFunction(Module& wasm, Function* function) {
  wasm.addFunction(function);
  auto export_ = new Export;
  export_->name = export_->value = function->name;
  export_->kind = ExternalKind::Function;
  wasm.addExport(export_);
}

// TODO(sbc): There should probably be a better way to do this.
bool isExported(Module& wasm, Name name) {
  for (auto& ex : wasm.exports) {
    if (ex->value == name) {
      return true;
    }
  }
  return false;
}

Global* EmscriptenGlueGenerator::getStackPointerGlobal() {
  // Assumption: The stack pointer is either imported as __stack_pointer or
  // its the first non-imported and non-exported global.
  // TODO(sbc): Find a better way to discover the stack pointer.  Perhaps the
  // linker could export it by name?
  for (auto& g : wasm.globals) {
    if (g->imported()) {
      if (g->base == STACK_POINTER) {
        return g.get();
      }
    } else if (!isExported(wasm, g->name)) {
      return g.get();
    }
  }
  return nullptr;
}

Expression* EmscriptenGlueGenerator::generateLoadStackPointer() {
  if (!useStackPointerGlobal) {
    return builder.makeLoad(
      /* bytes  =*/4,
      /* signed =*/false,
      /* offset =*/stackPointerOffset,
      /* align  =*/4,
      /* ptr    =*/builder.makeConst(Literal(0)),
      /* type   =*/i32);
  }
  Global* stackPointer = getStackPointerGlobal();
  if (!stackPointer) {
    Fatal() << "stack pointer global not found";
  }
  return builder.makeGlobalGet(stackPointer->name, i32);
}

inline Expression* stackBoundsCheck(Builder& builder,
                                    Function* func,
                                    Expression* value,
                                    Global* stackPointer,
                                    Global* stackLimit,
                                    Name handlerName) {
  // Add a local to store the value of the expression. We need the value twice:
  // once to check if it has overflowed, and again to assign to store it.
  auto newSP = Builder::addVar(func, stackPointer->type);
  // If we imported a handler, call it. That can show a nice error in JS.
  // Otherwise, just trap.
  Expression* handler;
  if (handlerName.is()) {
    handler = builder.makeCall(handlerName, {}, none);
  } else {
    handler = builder.makeUnreachable();
  }
  // (if (i32.lt_u (local.tee $newSP (...value...)) (global.get $__stack_limit))
  auto check =
    builder.makeIf(builder.makeBinary(
                     BinaryOp::LtUInt32,
                     builder.makeLocalTee(newSP, value, stackPointer->type),
                     builder.makeGlobalGet(stackLimit->name, stackLimit->type)),
                   handler);
  // (global.set $__stack_pointer (local.get $newSP))
  auto newSet = builder.makeGlobalSet(
    stackPointer->name, builder.makeLocalGet(newSP, stackPointer->type));
  return builder.blockify(check, newSet);
}

Expression*
EmscriptenGlueGenerator::generateStoreStackPointer(Function* func,
                                                   Expression* value) {
  BYN_TRACE("generateStoreStackPointer\n");
  if (!useStackPointerGlobal) {
    return builder.makeStore(
      /* bytes  =*/4,
      /* offset =*/stackPointerOffset,
      /* align  =*/4,
      /* ptr    =*/builder.makeConst(Literal(0)),
      /* value  =*/value,
      /* type   =*/i32);
  }
  Global* stackPointer = getStackPointerGlobal();
  if (!stackPointer) {
    Fatal() << "stack pointer global not found";
  }
  if (auto* stackLimit = wasm.getGlobalOrNull(STACK_LIMIT)) {
    return stackBoundsCheck(builder,
                            func,
                            value,
                            stackPointer,
                            stackLimit,
                            importStackOverflowHandler());
  }
  return builder.makeGlobalSet(stackPointer->name, value);
}

void EmscriptenGlueGenerator::generateStackSaveFunction() {
  BYN_TRACE("generateStackSaveFunction\n");
  std::vector<NameType> params{};
  Function* function =
    builder.makeFunction(STACK_SAVE, std::move(params), i32, {});

  function->body = generateLoadStackPointer();

  addExportedFunction(wasm, function);
}

void EmscriptenGlueGenerator::generateStackAllocFunction() {
  BYN_TRACE("generateStackAllocFunction\n");
  std::vector<NameType> params{{"0", i32}};
  Function* function =
    builder.makeFunction(STACK_ALLOC, std::move(params), i32, {{"1", i32}});
  Expression* loadStack = generateLoadStackPointer();
  LocalGet* getSizeArg = builder.makeLocalGet(0, i32);
  Binary* sub = builder.makeBinary(SubInt32, loadStack, getSizeArg);
  const static uint32_t bitAlignment = 16;
  const static uint32_t bitMask = bitAlignment - 1;
  Const* subConst = builder.makeConst(Literal(~bitMask));
  Binary* maskedSub = builder.makeBinary(AndInt32, sub, subConst);
  LocalSet* teeStackLocal = builder.makeLocalTee(1, maskedSub, i32);
  Expression* storeStack = generateStoreStackPointer(function, teeStackLocal);

  Block* block = builder.makeBlock();
  block->list.push_back(storeStack);
  LocalGet* getStackLocal2 = builder.makeLocalGet(1, i32);
  block->list.push_back(getStackLocal2);
  block->type = i32;
  function->body = block;

  addExportedFunction(wasm, function);
}

void EmscriptenGlueGenerator::generateStackRestoreFunction() {
  BYN_TRACE("generateStackRestoreFunction\n");
  std::vector<NameType> params{{"0", i32}};
  Function* function =
    builder.makeFunction(STACK_RESTORE, std::move(params), none, {});
  LocalGet* getArg = builder.makeLocalGet(0, i32);
  Expression* store = generateStoreStackPointer(function, getArg);

  function->body = store;

  addExportedFunction(wasm, function);
}

void EmscriptenGlueGenerator::generateRuntimeFunctions() {
  BYN_TRACE("generateRuntimeFunctions\n");
  generateStackSaveFunction();
  generateStackAllocFunction();
  generateStackRestoreFunction();
}

static Function*
ensureFunctionImport(Module* module, Name name, Signature sig) {
  // Then see if its already imported
  ImportInfo info(*module);
  if (Function* f = info.getImportedFunction(ENV, name)) {
    return f;
  }
  // Failing that create a new function import.
  auto import = new Function;
  import->name = name;
  import->module = ENV;
  import->base = name;
  import->sig = sig;
  module->addFunction(import);
  return import;
}

// Convert LLVM PIC ABI to emscripten ABI
//
// When generating -fPIC code llvm will generate imports call GOT.mem and
// GOT.func in order to access the addresses of external global data and
// functions.
//
// However emscripten uses a different ABI where function and data addresses
// are available at runtime via special `g$foo` and `fp$bar` function calls.
//
// Here we internalize all such wasm globals and generte code that sets their
// value based on the result of call `g$foo` and `fp$bar` functions at runtime.
Function* EmscriptenGlueGenerator::generateAssignGOTEntriesFunction() {
  BYN_TRACE("generateAssignGOTEntriesFunction\n");
  std::vector<Global*> gotFuncEntries;
  std::vector<Global*> gotMemEntries;
  for (auto& g : wasm.globals) {
    if (!g->imported()) {
      continue;
    }
    if (g->module == "GOT.func") {
      gotFuncEntries.push_back(g.get());
    } else if (g->module == "GOT.mem") {
      gotMemEntries.push_back(g.get());
    } else {
      continue;
    }
    // Make this an internal, non-imported, global.
    g->module.clear();
    g->init = Builder(wasm).makeConst(Literal(0));
  }

  if (!gotFuncEntries.size() && !gotMemEntries.size()) {
    return nullptr;
  }

  Function* assignFunc =
    builder.makeFunction(ASSIGN_GOT_ENTIRES, std::vector<NameType>{}, none, {});
  Block* block = builder.makeBlock();
  assignFunc->body = block;

  for (Global* g : gotMemEntries) {
    Name getter(std::string("g$") + g->base.c_str());
    ensureFunctionImport(&wasm, getter, Signature(Type::none, Type::i32));
    Expression* call = builder.makeCall(getter, {}, i32);
    GlobalSet* globalSet = builder.makeGlobalSet(g->name, call);
    block->list.push_back(globalSet);
  }

  for (Global* g : gotFuncEntries) {
    Function* f = nullptr;
    // The function has to exist either as export or an import.
    // Note that we don't search for the function by name since its internal
    // name may be different.
    auto* ex = wasm.getExportOrNull(g->base);
    if (ex) {
      assert(ex->kind == ExternalKind::Function);
      f = wasm.getFunction(ex->value);
    } else {
      ImportInfo info(wasm);
      f = info.getImportedFunction(ENV, g->base);
      if (!f) {
        Fatal() << "GOT.func entry with no import/export: " << g->base;
      }
    }

    Name getter(
      (std::string("fp$") + g->base.c_str() + std::string("$") + getSig(f))
        .c_str());
    ensureFunctionImport(&wasm, getter, Signature(Type::none, Type::i32));
    Expression* call = builder.makeCall(getter, {}, i32);
    GlobalSet* globalSet = builder.makeGlobalSet(g->name, call);
    block->list.push_back(globalSet);
  }

  wasm.addFunction(assignFunc);
  return assignFunc;
}

// For emscripten SIDE_MODULE we generate a single exported function called
// __post_instantiate which calls two functions:
//
// - __assign_got_enties
// - __wasm_call_ctors
//
// The former is function we generate here which calls imported g$XXX functions
// order to assign values to any globals imported from GOT.func or GOT.mem.
// These globals hold address of functions and globals respectively.
//
// The later is the constructor function generaed by lld which performs any
// fixups on the memory section and calls static constructors.
void EmscriptenGlueGenerator::generatePostInstantiateFunction() {
  BYN_TRACE("generatePostInstantiateFunction\n");
  Builder builder(wasm);
  Function* post_instantiate =
    builder.makeFunction(POST_INSTANTIATE, std::vector<NameType>{}, none, {});
  wasm.addFunction(post_instantiate);

  if (Function* F = generateAssignGOTEntriesFunction()) {
    // call __assign_got_enties from post_instantiate
    Expression* call = builder.makeCall(F->name, {}, none);
    post_instantiate->body = builder.blockify(post_instantiate->body, call);
  }

  // The names of standard imports/exports used by lld doesn't quite match that
  // expected by emscripten.
  // TODO(sbc): Unify these
  if (auto* e = wasm.getExportOrNull(WASM_CALL_CTORS)) {
    Expression* call = builder.makeCall(e->value, {}, none);
    post_instantiate->body = builder.blockify(post_instantiate->body, call);
    wasm.removeExport(WASM_CALL_CTORS);
  }

  auto* ex = new Export();
  ex->value = post_instantiate->name;
  ex->name = POST_INSTANTIATE;
  ex->kind = ExternalKind::Function;
  wasm.addExport(ex);
}

Function* EmscriptenGlueGenerator::generateMemoryGrowthFunction() {
  Name name(GROW_WASM_MEMORY);
  std::vector<NameType> params{{NEW_SIZE, i32}};
  Function* growFunction =
    builder.makeFunction(name, std::move(params), i32, {});
  growFunction->body =
    builder.makeHost(MemoryGrow, Name(), {builder.makeLocalGet(0, i32)});

  addExportedFunction(wasm, growFunction);

  return growFunction;
}

inline void exportFunction(Module& wasm, Name name, bool must_export) {
  if (!wasm.getFunctionOrNull(name)) {
    assert(!must_export);
    return;
  }
  if (wasm.getExportOrNull(name)) {
    return; // Already exported
  }
  auto exp = new Export;
  exp->name = exp->value = name;
  exp->kind = ExternalKind::Function;
  wasm.addExport(exp);
}

void EmscriptenGlueGenerator::generateDynCallThunk(Signature sig) {
  if (!sigs.insert(sig).second) {
    return; // sig is already in the set
  }
  Name name = std::string("dynCall_") + getSig(sig.results, sig.params);
  if (wasm.getFunctionOrNull(name) || wasm.getExportOrNull(name)) {
    return; // module already contains this dyncall
  }
  std::vector<NameType> params;
  params.emplace_back("fptr", i32); // function pointer param
  int p = 0;
  const std::vector<Type>& paramTypes = sig.params.expand();
  for (const auto& ty : paramTypes) {
    params.emplace_back(std::to_string(p++), ty);
  }
  Function* f = builder.makeFunction(name, std::move(params), sig.results, {});
  Expression* fptr = builder.makeLocalGet(0, i32);
  std::vector<Expression*> args;
  for (unsigned i = 0; i < paramTypes.size(); ++i) {
    args.push_back(builder.makeLocalGet(i + 1, paramTypes[i]));
  }
  Expression* call = builder.makeCallIndirect(fptr, args, sig);
  f->body = call;

  wasm.addFunction(f);
  exportFunction(wasm, f->name, true);
}

void EmscriptenGlueGenerator::generateDynCallThunks() {
  Builder builder(wasm);
  std::vector<Name> tableSegmentData;
  if (wasm.table.segments.size() > 0) {
    tableSegmentData = wasm.table.segments[0].data;
  }
  for (const auto& indirectFunc : tableSegmentData) {
    generateDynCallThunk(wasm.getFunction(indirectFunc)->sig);
  }
}

struct RemoveStackPointer : public PostWalker<RemoveStackPointer> {
  RemoveStackPointer(Global* stackPointer) : stackPointer(stackPointer) {}

  void visitGlobalGet(GlobalGet* curr) {
    if (getModule()->getGlobalOrNull(curr->name) == stackPointer) {
      needStackSave = true;
      if (!builder) {
        builder = make_unique<Builder>(*getModule());
      }
      replaceCurrent(builder->makeCall(STACK_SAVE, {}, i32));
    }
  }

  void visitGlobalSet(GlobalSet* curr) {
    if (getModule()->getGlobalOrNull(curr->name) == stackPointer) {
      needStackRestore = true;
      if (!builder) {
        builder = make_unique<Builder>(*getModule());
      }
      replaceCurrent(builder->makeCall(STACK_RESTORE, {curr->value}, none));
    }
  }

  bool needStackSave = false;
  bool needStackRestore = false;

private:
  std::unique_ptr<Builder> builder;
  Global* stackPointer;
};

// lld can sometimes produce a build with an imported mutable __stack_pointer
// (i.e.  when linking with -fpie).  This method internalizes the
// __stack_pointer and initializes it from an immutable global instead.
// For -shared builds we instead call replaceStackPointerGlobal.
void EmscriptenGlueGenerator::internalizeStackPointerGlobal() {
  Global* stackPointer = getStackPointerGlobal();
  if (!stackPointer || !stackPointer->imported() || !stackPointer->mutable_) {
    return;
  }

  Name internalName = stackPointer->name;
  Name externalName = internalName.c_str() + std::string("_import");

  // Rename the imported global, and make it immutable
  stackPointer->name = externalName;
  stackPointer->mutable_ = false;
  wasm.updateMaps();

  // Create a new global with the old name that is not imported.
  Builder builder(wasm);
  auto* init = builder.makeGlobalGet(externalName, stackPointer->type);
  auto* sp = builder.makeGlobal(
    internalName, stackPointer->type, init, Builder::Mutable);
  wasm.addGlobal(sp);
}

void EmscriptenGlueGenerator::replaceStackPointerGlobal() {
  Global* stackPointer = getStackPointerGlobal();
  if (!stackPointer) {
    return;
  }

  // Replace all uses of stack pointer global
  RemoveStackPointer walker(stackPointer);
  walker.walkModule(&wasm);
  if (walker.needStackSave) {
    ensureFunctionImport(&wasm, STACK_SAVE, Signature(Type::none, Type::i32));
  }
  if (walker.needStackRestore) {
    ensureFunctionImport(
      &wasm, STACK_RESTORE, Signature(Type::i32, Type::none));
  }

  // Finally remove the stack pointer global itself. This avoids importing
  // a mutable global.
  wasm.removeGlobal(stackPointer->name);
}

struct StackLimitEnforcer : public WalkerPass<PostWalker<StackLimitEnforcer>> {
  StackLimitEnforcer(Global* stackPointer,
                     Global* stackLimit,
                     Builder& builder,
                     Name handler)
    : stackPointer(stackPointer), stackLimit(stackLimit), builder(builder),
      handler(handler) {}

  bool isFunctionParallel() override { return true; }

  Pass* create() override {
    return new StackLimitEnforcer(stackPointer, stackLimit, builder, handler);
  }

  void visitGlobalSet(GlobalSet* curr) {
    if (getModule()->getGlobalOrNull(curr->name) == stackPointer) {
      replaceCurrent(stackBoundsCheck(builder,
                                      getFunction(),
                                      curr->value,
                                      stackPointer,
                                      stackLimit,
                                      handler));
    }
  }

private:
  Global* stackPointer;
  Global* stackLimit;
  Builder& builder;
  Name handler;
};

void EmscriptenGlueGenerator::enforceStackLimit() {
  Global* stackPointer = getStackPointerGlobal();
  if (!stackPointer) {
    return;
  }

  auto* stackLimit = builder.makeGlobal(STACK_LIMIT,
                                        stackPointer->type,
                                        builder.makeConst(Literal(0)),
                                        Builder::Mutable);
  wasm.addGlobal(stackLimit);

  Name handler = importStackOverflowHandler();
  StackLimitEnforcer walker(stackPointer, stackLimit, builder, handler);
  PassRunner runner(&wasm);
  walker.run(&runner, &wasm);

  generateSetStackLimitFunction();
}

void EmscriptenGlueGenerator::generateSetStackLimitFunction() {
  Function* function =
    builder.makeFunction(SET_STACK_LIMIT, Signature(Type::i32, Type::none), {});
  LocalGet* getArg = builder.makeLocalGet(0, i32);
  Expression* store = builder.makeGlobalSet(STACK_LIMIT, getArg);
  function->body = store;
  addExportedFunction(wasm, function);
}

Name EmscriptenGlueGenerator::importStackOverflowHandler() {
  // We can call an import to handle stack overflows normally, but not in
  // standalone mode, where we can't import from JS.
  if (standalone) {
    return Name();
  }

  ImportInfo info(wasm);

  if (auto* existing = info.getImportedFunction(ENV, STACK_OVERFLOW_IMPORT)) {
    return existing->name;
  } else {
    auto* import = new Function;
    import->name = STACK_OVERFLOW_IMPORT;
    import->module = ENV;
    import->base = STACK_OVERFLOW_IMPORT;
    import->sig = Signature(Type::none, Type::none);
    wasm.addFunction(import);
    return STACK_OVERFLOW_IMPORT;
  }
}

const Address UNKNOWN_OFFSET(uint32_t(-1));

std::vector<Address> getSegmentOffsets(Module& wasm) {
  std::unordered_map<Index, Address> passiveOffsets;
  if (wasm.features.hasBulkMemory()) {
    // Fetch passive segment offsets out of memory.init instructions
    struct OffsetSearcher : PostWalker<OffsetSearcher> {
      std::unordered_map<Index, Address>& offsets;
      OffsetSearcher(std::unordered_map<unsigned, Address>& offsets)
        : offsets(offsets) {}
      void visitMemoryInit(MemoryInit* curr) {
        auto* dest = curr->dest->dynCast<Const>();
        if (!dest) {
          return;
        }
        auto it = offsets.find(curr->segment);
        if (it != offsets.end()) {
          Fatal() << "Cannot get offset of passive segment initialized "
                     "multiple times";
        }
        offsets[curr->segment] = dest->value.geti32();
      }
    } searcher(passiveOffsets);
    searcher.walkModule(&wasm);
  }
  std::vector<Address> segmentOffsets;
  for (unsigned i = 0; i < wasm.memory.segments.size(); ++i) {
    auto& segment = wasm.memory.segments[i];
    if (segment.isPassive) {
      auto it = passiveOffsets.find(i);
      if (it != passiveOffsets.end()) {
        segmentOffsets.push_back(it->second);
      } else {
        // This was a non-constant offset (perhaps TLS)
        segmentOffsets.push_back(UNKNOWN_OFFSET);
      }
    } else if (auto* addrConst = segment.offset->dynCast<Const>()) {
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

std::string escape(const char* input) {
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
    if (curr == 0 || code[curr - 1] != '\\') {
      code = code.replace(curr,
                          1,
                          "\\"
                          "\"");
      curr += 2; // skip this one
    } else {     // already escaped, escape the slash as well
      code = code.replace(curr,
                          1,
                          "\\"
                          "\\"
                          "\"");
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
    if (offset != UNKNOWN_OFFSET && address >= offset &&
        address < offset + segment.data.size()) {
      return &segment.data[address - offset];
    }
  }
  return nullptr;
}

std::string codeForConstAddr(Module& wasm,
                             std::vector<Address> const& segmentOffsets,
                             int32_t address) {
  const char* str = stringAtAddr(wasm, segmentOffsets, address);
  if (!str) {
    // If we can't find the segment corresponding with the address, then we
    // omitted the segment and the address points to an empty string.
    return escape("");
  }
  return escape(str);
}

enum class Proxying {
  None,
  Sync,
  Async,
};

std::string proxyingSuffix(Proxying proxy) {
  switch (proxy) {
    case Proxying::None:
      return "";
    case Proxying::Sync:
      return "sync_on_main_thread_";
    case Proxying::Async:
      return "async_on_main_thread_";
  }
  WASM_UNREACHABLE("invalid prozy type");
}

struct AsmConstWalker : public LinearExecutionWalker<AsmConstWalker> {
  Module& wasm;
  std::vector<Address> segmentOffsets; // segment index => address offset

  struct AsmConst {
    std::set<Signature> sigs;
    Address id;
    std::string code;
    Proxying proxy;
  };

  std::vector<AsmConst> asmConsts;
  std::set<std::pair<Signature, Proxying>> allSigs;
  // last sets in the current basic block, per index
  std::map<Index, LocalSet*> sets;

  AsmConstWalker(Module& _wasm)
    : wasm(_wasm), segmentOffsets(getSegmentOffsets(wasm)) {}

  void noteNonLinear(Expression* curr);

  void visitLocalSet(LocalSet* curr);
  void visitCall(Call* curr);
  void visitTable(Table* curr);

  void process();

private:
  Signature fixupName(Name& name, Signature baseSig, Proxying proxy);
  AsmConst&
  createAsmConst(uint32_t id, std::string code, Signature sig, Name name);
  Signature asmConstSig(Signature baseSig);
  Name nameForImportWithSig(Signature sig, Proxying proxy);
  void queueImport(Name importName, Signature baseSig);
  void addImports();
  Proxying proxyType(Name name);

  std::vector<std::unique_ptr<Function>> queuedImports;
};

void AsmConstWalker::noteNonLinear(Expression* curr) {
  // End of this basic block; clear sets.
  sets.clear();
}

void AsmConstWalker::visitLocalSet(LocalSet* curr) { sets[curr->index] = curr; }

void AsmConstWalker::visitCall(Call* curr) {
  auto* import = wasm.getFunction(curr->target);
  // Find calls to emscripten_asm_const* functions whose first argument is
  // is always a string constant.
  if (!import->imported()) {
    return;
  }
  auto importName = import->base;
  if (!importName.hasSubstring(EM_ASM_PREFIX)) {
    return;
  }

  auto baseSig = wasm.getFunction(curr->target)->sig;
  auto sig = asmConstSig(baseSig);
  auto* arg = curr->operands[0];
  while (!arg->dynCast<Const>()) {
    if (auto* get = arg->dynCast<LocalGet>()) {
      // The argument may be a local.get, in which case, the last set in this
      // basic block has the value.
      auto* set = sets[get->index];
      if (set) {
        assert(set->index == get->index);
        arg = set->value;
      } else {
        Fatal() << "local.get of unknown in arg0 of call to " << importName
                << " (used by EM_ASM* macros) in function "
                << getFunction()->name
                << ".\nThis might be caused by aggressive compiler "
                   "transformations. Consider using EM_JS instead.";
      }
      continue;
    }

    if (auto* setlocal = arg->dynCast<LocalSet>()) {
      // The argument may be a local.tee, in which case we take first child
      // which is the value being copied into the local.
      if (setlocal->isTee()) {
        arg = setlocal->value;
        continue;
      }
    }

    if (auto* bin = arg->dynCast<Binary>()) {
      if (bin->op == AddInt32) {
        // In the dynamic linking case the address of the string constant
        // is the result of adding its offset to __memory_base.
        // In this case are only looking for the offset from __memory_base
        // the RHS of the addition is just what we want.
        arg = bin->right;
        continue;
      }
    }

    Fatal() << "Unexpected arg0 type (" << getExpressionName(arg)
            << ") in call to: " << importName;
  }

  auto* value = arg->cast<Const>();
  int32_t address = value->value.geti32();
  auto code = codeForConstAddr(wasm, segmentOffsets, address);
  auto& asmConst = createAsmConst(address, code, sig, importName);
  fixupName(curr->target, baseSig, asmConst.proxy);
}

Proxying AsmConstWalker::proxyType(Name name) {
  if (name.hasSubstring("_sync_on_main_thread")) {
    return Proxying::Sync;
  } else if (name.hasSubstring("_async_on_main_thread")) {
    return Proxying::Async;
  }
  return Proxying::None;
}

void AsmConstWalker::visitTable(Table* curr) {
  for (auto& segment : curr->segments) {
    for (auto& name : segment.data) {
      auto* func = wasm.getFunction(name);
      if (func->imported() && func->base.hasSubstring(EM_ASM_PREFIX)) {
        auto proxy = proxyType(func->base);
        fixupName(name, func->sig, proxy);
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

Signature
AsmConstWalker::fixupName(Name& name, Signature baseSig, Proxying proxy) {
  auto sig = asmConstSig(baseSig);
  auto importName = nameForImportWithSig(sig, proxy);
  name = importName;

  auto pair = std::make_pair(sig, proxy);
  if (allSigs.count(pair) == 0) {
    allSigs.insert(pair);
    queueImport(importName, baseSig);
  }
  return sig;
}

AsmConstWalker::AsmConst& AsmConstWalker::createAsmConst(uint32_t id,
                                                         std::string code,
                                                         Signature sig,
                                                         Name name) {
  AsmConst asmConst;
  asmConst.id = id;
  asmConst.code = code;
  asmConst.sigs.insert(sig);
  asmConst.proxy = proxyType(name);
  asmConsts.push_back(asmConst);
  return asmConsts.back();
}

Signature AsmConstWalker::asmConstSig(Signature baseSig) {
  std::vector<Type> params = baseSig.params.expand();
  assert(params.size() >= 1);
  // Omit the signature of the "code" parameter, taken as a string, as the
  // first argument
  params.erase(params.begin());
  return Signature(Type(params), baseSig.results);
}

Name AsmConstWalker::nameForImportWithSig(Signature sig, Proxying proxy) {
  std::string fixedTarget = EM_ASM_PREFIX.str + std::string("_") +
                            proxyingSuffix(proxy) +
                            getSig(sig.results, sig.params);
  return Name(fixedTarget.c_str());
}

void AsmConstWalker::queueImport(Name importName, Signature baseSig) {
  auto import = new Function;
  import->name = import->base = importName;
  import->module = ENV;
  import->sig = baseSig;
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
    if (import->imported() && import->base.hasSubstring(EM_ASM_PREFIX)) {
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
    : wasm(_wasm), segmentOffsets(getSegmentOffsets(wasm)) {}

  void visitExport(Export* curr) {
    if (curr->kind != ExternalKind::Function) {
      return;
    }
    if (!curr->name.startsWith(EM_JS_PREFIX.str)) {
      return;
    }
    auto* func = wasm.getFunction(curr->value);
    auto funcName = std::string(curr->name.stripPrefix(EM_JS_PREFIX.str));
    // An EM_JS has a single const in the body. Typically it is just returned,
    // but in unoptimized code it might be stored to a local and loaded from
    // there, and in relocatable code it might get added to __memory_base etc.
    FindAll<Const> consts(func->body);
    if (consts.list.size() != 1) {
      Fatal() << "Unexpected generated __em_js__ function body: " << curr->name;
    }
    auto* addrConst = consts.list[0];
    int32_t address = addrConst->value.geti32();
    auto code = codeForConstAddr(wasm, segmentOffsets, address);
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
struct FixInvokeFunctionNamesWalker
  : public PostWalker<FixInvokeFunctionNamesWalker> {
  Module& wasm;
  std::map<Name, Name> importRenames;
  std::vector<Name> toRemove;
  std::set<Name> newImports;
  std::set<Signature> invokeSigs;
  ImportInfo imports;

  FixInvokeFunctionNamesWalker(Module& _wasm) : wasm(_wasm), imports(wasm) {}

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
  Name fixEmExceptionInvoke(const Name& name, Signature sig) {
    std::string nameStr = name.c_str();
    if (nameStr.front() == '"' && nameStr.back() == '"') {
      nameStr = nameStr.substr(1, nameStr.size() - 2);
    }
    if (nameStr.find("__invoke_") != 0) {
      return name;
    }

    const std::vector<Type>& params = sig.params.expand();
    std::vector<Type> newParams(params.begin() + 1, params.end());
    Signature sigWoOrigFunc = Signature(Type(newParams), sig.results);
    invokeSigs.insert(sigWoOrigFunc);
    return Name("invoke_" +
                getSig(sigWoOrigFunc.results, sigWoOrigFunc.params));
  }

  Name fixEmEHSjLjNames(const Name& name, Signature sig) {
    if (name == "emscripten_longjmp_jmpbuf") {
      return "emscripten_longjmp";
    }
    return fixEmExceptionInvoke(name, sig);
  }

  void visitFunction(Function* curr) {
    if (!curr->imported()) {
      return;
    }

    Name newname = fixEmEHSjLjNames(curr->base, curr->sig);
    if (newname == curr->base) {
      return;
    }

    BYN_TRACE("renaming import: " << curr->module << "." << curr->base << " ("
                                  << curr->name << ") -> " << newname << "\n");
    assert(importRenames.count(curr->base) == 0);
    importRenames[curr->base] = newname;
    // Either rename or remove the existing import
    if (imports.getImportedFunction(curr->module, newname) ||
        !newImports.insert(newname).second) {
      BYN_TRACE("using existing import\n");
      toRemove.push_back(curr->name);
    } else {
      BYN_TRACE("renaming import\n");
      curr->base = newname;
    }
  }

  void visitModule(Module* curr) {
    for (auto importName : toRemove) {
      wasm.removeFunction(importName);
    }
    ModuleUtils::renameFunctions(wasm, importRenames);
    // Update any associated GOT.func imports.
    for (auto& pair : importRenames) {
      if (auto g = imports.getImportedGlobal("GOT.func", pair.first)) {
        BYN_TRACE("renaming corresponding GOT entry: " << g->base << " -> "
                                                       << pair.second << "\n");
        g->base = pair.second;
      }
    }
  }
};

void EmscriptenGlueGenerator::fixInvokeFunctionNames() {
  BYN_TRACE("fixInvokeFunctionNames\n");
  FixInvokeFunctionNamesWalker walker(wasm);
  walker.walkModule(&wasm);
  BYN_TRACE("generating dyncall thunks\n");
  for (auto sig : walker.invokeSigs) {
    generateDynCallThunk(sig);
  }
}

void printSignatures(std::ostream& o, const std::set<Signature>& c) {
  o << "[";
  bool first = true;
  for (auto& sig : c) {
    if (first) {
      first = false;
    } else {
      o << ",";
    }
    o << '"' << getSig(sig.results, sig.params) << '"';
  }
  o << "]";
}

std::string EmscriptenGlueGenerator::generateEmscriptenMetadata(
  Address staticBump, std::vector<Name> const& initializerFunctions) {
  bool commaFirst;
  auto nextElement = [&commaFirst]() {
    if (commaFirst) {
      commaFirst = false;
      return "\n    ";
    } else {
      return ",\n    ";
    }
  };

  std::stringstream meta;
  meta << "{\n";

  AsmConstWalker emAsmWalker = fixEmAsmConstsAndReturnWalker(wasm);

  // print
  commaFirst = true;
  if (!emAsmWalker.asmConsts.empty()) {
    meta << "  \"asmConsts\": {";
    for (auto& asmConst : emAsmWalker.asmConsts) {
      meta << nextElement();
      meta << '"' << asmConst.id << "\": [\"" << asmConst.code << "\", ";
      printSignatures(meta, asmConst.sigs);
      meta << ", [\"" << proxyingSuffix(asmConst.proxy) << "\"]";

      meta << "]";
    }
    meta << "\n  },\n";
  }

  EmJsWalker emJsWalker = fixEmJsFuncsAndReturnWalker(wasm);
  if (!emJsWalker.codeByName.empty()) {
    meta << "  \"emJsFuncs\": {";
    commaFirst = true;
    for (auto& pair : emJsWalker.codeByName) {
      auto& name = pair.first;
      auto& code = pair.second;
      meta << nextElement();
      meta << '"' << name << "\": \"" << code << '"';
    }
    meta << "\n  },\n";
  }

  meta << "  \"staticBump\": " << staticBump << ",\n";
  meta << "  \"tableSize\": " << wasm.table.initial.addr << ",\n";

  if (!initializerFunctions.empty()) {
    meta << "  \"initializers\": [";
    commaFirst = true;
    for (const auto& func : initializerFunctions) {
      meta << nextElement();
      meta << "\"" << func.c_str() << "\"";
    }
    meta << "\n  ],\n";
  }

  // Avoid adding duplicate imports to `declares' or `invokeFuncs`.  Even
  // though we might import the same function multiple times (i.e. with
  // different sigs) we only need to list is in the metadata once.
  std::set<std::string> declares;
  std::set<std::string> invokeFuncs;

  // We use the `base` rather than the `name` of the imports here and below
  // becasue this is the externally visible name that the embedder (JS) will
  // see.
  meta << "  \"declares\": [";
  commaFirst = true;
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    if (emJsWalker.codeByName.count(import->base.str) == 0 &&
        !import->base.startsWith(EM_ASM_PREFIX.str) &&
        !import->base.startsWith("invoke_")) {
      if (declares.insert(import->base.str).second) {
        meta << nextElement() << '"' << import->base.str << '"';
      }
    }
  });
  meta << "\n  ],\n";

  meta << "  \"externs\": [";
  commaFirst = true;
  ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
    if (!(import->module == ENV && import->name == STACK_INIT)) {
      meta << nextElement() << "\"_" << import->base.str << '"';
    }
  });
  meta << "\n  ],\n";

  if (!wasm.exports.empty()) {
    meta << "  \"implementedFunctions\": [";
    commaFirst = true;
    for (const auto& ex : wasm.exports) {
      if (ex->kind == ExternalKind::Function) {
        meta << nextElement() << "\"_" << ex->name.str << '"';
      }
    }
    meta << "\n  ],\n";

    meta << "  \"exports\": [";
    commaFirst = true;
    for (const auto& ex : wasm.exports) {
      if (ex->kind == ExternalKind::Function) {
        meta << nextElement() << '"' << ex->name.str << '"';
      }
    }
    meta << "\n  ],\n";

    meta << "  \"namedGlobals\": {";
    commaFirst = true;
    for (const auto& ex : wasm.exports) {
      if (ex->kind == ExternalKind::Global) {
        const Global* g = wasm.getGlobal(ex->value);
        assert(g->type == i32);
        Const* init = g->init->cast<Const>();
        uint32_t addr = init->value.geti32();
        meta << nextElement() << '"' << ex->name.str << "\" : \"" << addr
             << '"';
      }
    }
    meta << "\n  },\n";
  }

  meta << "  \"invokeFuncs\": [";
  commaFirst = true;
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    if (import->base.startsWith("invoke_")) {
      if (invokeFuncs.insert(import->base.str).second) {
        meta << nextElement() << '"' << import->base.str << '"';
      }
    }
  });
  meta << "\n  ],\n";

  meta << "  \"features\": [";
  commaFirst = true;
  wasm.features.iterFeatures([&](FeatureSet::Feature f) {
    meta << nextElement() << "\"--enable-" << FeatureSet::toString(f) << '"';
  });
  meta << "\n  ],\n";

  auto mainReadsParams = false;
  if (auto* exp = wasm.getExportOrNull("main")) {
    if (exp->kind == ExternalKind::Function) {
      auto* main = wasm.getFunction(exp->value);
      mainReadsParams = true;
      // If main does not read its parameters, it will just be a stub that
      // calls __original_main (which has no parameters).
      if (auto* call = main->body->dynCast<Call>()) {
        if (call->operands.empty()) {
          mainReadsParams = false;
        }
      }
    }
  }
  meta << "  \"mainReadsParams\": " << int(mainReadsParams) << '\n';

  meta << "}\n";

  return meta.str();
}

void EmscriptenGlueGenerator::separateDataSegments(Output* outfile,
                                                   Address base) {
  size_t lastEnd = 0;
  for (Memory::Segment& seg : wasm.memory.segments) {
    if (seg.isPassive) {
      Fatal() << "separating passive segments not implemented";
    }
    if (!seg.offset->is<Const>()) {
      Fatal() << "separating relocatable segments not implemented";
    }
    size_t offset = seg.offset->cast<Const>()->value.geti32();
    offset -= base;
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

void EmscriptenGlueGenerator::exportWasiStart() {
  // If main exists, export a function to call it per the wasi standard.
  Name main = "main";
  if (!wasm.getFunctionOrNull(main)) {
    BYN_TRACE("exportWasiStart: main not found\n");
    return;
  }
  Name _start = "_start";
  if (wasm.getExportOrNull(_start)) {
    BYN_TRACE("exportWasiStart: _start already present\n");
    return;
  }
  BYN_TRACE("exportWasiStart\n");
  Builder builder(wasm);
  auto* body = builder.makeDrop(builder.makeCall(
    main,
    {LiteralUtils::makeZero(i32, wasm), LiteralUtils::makeZero(i32, wasm)},
    i32));
  auto* func =
    builder.makeFunction(_start, Signature(Type::none, Type::none), {}, body);
  wasm.addFunction(func);
  wasm.addExport(builder.makeExport(_start, _start, ExternalKind::Function));
}

} // namespace wasm
