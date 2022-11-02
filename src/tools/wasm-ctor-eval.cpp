/*
 * Copyright 2017 WebAssembly Community Group participants
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

//
// Loads wasm plus a list of functions that are global ctors, i.e.,
// are to be executed. It then executes as many of them as it can,
// applying their changes to memory etc as needed, then writes it. In
// other words, this executes code at compile time to speed up
// startup later.
//

#include <memory>

#include "asmjs/shared-constants.h"
#include "ir/global-utils.h"
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "ir/memory-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "support/colors.h"
#include "support/file.h"
#include "support/small_set.h"
#include "support/string.h"
#include "tool-options.h"
#include "wasm-builder.h"
#include "wasm-interpreter.h"
#include "wasm-io.h"
#include "wasm-validator.h"

using namespace wasm;

namespace {

struct FailToEvalException {
  std::string why;
  FailToEvalException(std::string why) : why(why) {}
};

// The prefix for a recommendation, so it is aligned properly with the rest of
// the output.
#define RECOMMENDATION "\n       recommendation: "

class EvallingModuleRunner : public ModuleRunnerBase<EvallingModuleRunner> {
public:
  EvallingModuleRunner(
    Module& wasm,
    ExternalInterface* externalInterface,
    std::map<Name, std::shared_ptr<EvallingModuleRunner>> linkedInstances_ = {})
    : ModuleRunnerBase(wasm, externalInterface, linkedInstances_) {}

  Flow visitGlobalGet(GlobalGet* curr) {
    // Error on reads of imported globals.
    auto* global = wasm.getGlobal(curr->name);
    if (global->imported()) {
      throw FailToEvalException(std::string("read from imported global ") +
                                global->module.toString() + "." +
                                global->base.toString());
    }

    return ModuleRunnerBase<EvallingModuleRunner>::visitGlobalGet(curr);
  }
};

// Build an artificial `env` module based on a module's imports, so that the
// interpreter can use correct object instances. It initializes usable global
// imports, and fills the rest with fake values since those are dangerous to
// use. we will fail if dangerous globals are used.
std::unique_ptr<Module> buildEnvModule(Module& wasm) {
  auto env = std::make_unique<Module>();
  env->name = "env";

  // create empty functions with similar signature
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* func) {
    if (func->module == env->name) {
      Builder builder(*env);
      auto* copied = ModuleUtils::copyFunction(func, *env);
      copied->module = Name();
      copied->base = Name();
      copied->body = builder.makeUnreachable();
      env->addExport(
        builder.makeExport(func->base, copied->name, ExternalKind::Function));
    }
  });

  // create tables with similar initial and max values
  ModuleUtils::iterImportedTables(wasm, [&](Table* table) {
    if (table->module == env->name) {
      auto* copied = ModuleUtils::copyTable(table, *env);
      copied->module = Name();
      copied->base = Name();
      env->addExport(Builder(*env).makeExport(
        table->base, copied->name, ExternalKind::Table));
    }
  });

  ModuleUtils::iterImportedGlobals(wasm, [&](Global* global) {
    if (global->module == env->name) {
      auto* copied = ModuleUtils::copyGlobal(global, *env);
      copied->module = Name();
      copied->base = Name();

      Builder builder(*env);
      copied->init = builder.makeConst(Literal::makeZero(global->type));
      env->addExport(
        builder.makeExport(global->base, copied->name, ExternalKind::Global));
    }
  });

  // create an exported memory with the same initial and max size
  ModuleUtils::iterImportedMemories(wasm, [&](Memory* memory) {
    if (memory->module == env->name) {
      auto* copied = ModuleUtils::copyMemory(memory, *env);
      copied->module = Name();
      copied->base = Name();
      env->addExport(Builder(*env).makeExport(
        memory->base, copied->name, ExternalKind::Memory));
    }
  });

  return env;
}

// Whether to ignore external input to the program as it runs. If set, we will
// assume that stdin is empty, that any env vars we try to read are not set,
// that there are not arguments passed to main, etc.
static bool ignoreExternalInput = false;

struct CtorEvalExternalInterface : EvallingModuleRunner::ExternalInterface {
  Module* wasm;
  EvallingModuleRunner* instance;
  std::map<Name, std::shared_ptr<EvallingModuleRunner>> linkedInstances;

  // A representation of the contents of wasm memory as we execute.
  std::unordered_map<Name, std::vector<char>> memories;

  CtorEvalExternalInterface(
    std::map<Name, std::shared_ptr<EvallingModuleRunner>> linkedInstances_ =
      {}) {
    linkedInstances.swap(linkedInstances_);
  }

  // Called when we want to apply the current state of execution to the Module.
  // Until this is called the Module is never changed.
  void applyToModule() {
    clearApplyState();

    // If nothing was ever written to memories then there is nothing to update.
    if (!memories.empty()) {
      applyMemoryToModule();
    }

    applyGlobalsToModule();
  }

  void init(Module& wasm_, EvallingModuleRunner& instance_) override {
    wasm = &wasm_;
    instance = &instance_;
    for (auto& memory : wasm->memories) {
      if (!memory->imported()) {
        std::vector<char> data;
        memories[memory->name] = data;
      }
    }
  }

  void importGlobals(GlobalValueSet& globals, Module& wasm_) override {
    ModuleUtils::iterImportedGlobals(wasm_, [&](Global* global) {
      auto it = linkedInstances.find(global->module);
      if (it != linkedInstances.end()) {
        auto* inst = it->second.get();
        auto* globalExport = inst->wasm.getExportOrNull(global->base);
        if (!globalExport) {
          throw FailToEvalException(std::string("importGlobals: ") +
                                    global->module.toString() + "." +
                                    global->base.toString());
        }
        globals[global->name] = inst->globals[globalExport->value];
      } else {
        throw FailToEvalException(std::string("importGlobals: ") +
                                  global->module.toString() + "." +
                                  global->base.toString());
      }
    });
  }

  Literals callImport(Function* import, Literals& arguments) override {
    Name WASI("wasi_snapshot_preview1");

    if (ignoreExternalInput) {
      if (import->module == WASI) {
        if (import->base == "environ_sizes_get") {
          if (arguments.size() != 2 || arguments[0].type != Type::i32 ||
              import->getResults() != Type::i32) {
            throw FailToEvalException("wasi environ_sizes_get has wrong sig");
          }

          // Write out a count of i32(0) and return __WASI_ERRNO_SUCCESS (0).
          store32(arguments[0].geti32(), 0, wasm->memories[0]->name);
          return {Literal(int32_t(0))};
        }

        if (import->base == "environ_get") {
          if (arguments.size() != 2 || arguments[0].type != Type::i32 ||
              import->getResults() != Type::i32) {
            throw FailToEvalException("wasi environ_get has wrong sig");
          }

          // Just return __WASI_ERRNO_SUCCESS (0).
          return {Literal(int32_t(0))};
        }

        if (import->base == "args_sizes_get") {
          if (arguments.size() != 2 || arguments[0].type != Type::i32 ||
              import->getResults() != Type::i32) {
            throw FailToEvalException("wasi args_sizes_get has wrong sig");
          }

          // Write out an argc of i32(0) and return a __WASI_ERRNO_SUCCESS (0).
          store32(arguments[0].geti32(), 0, wasm->memories[0]->name);
          return {Literal(int32_t(0))};
        }

        if (import->base == "args_get") {
          if (arguments.size() != 2 || arguments[0].type != Type::i32 ||
              import->getResults() != Type::i32) {
            throw FailToEvalException("wasi args_get has wrong sig");
          }

          // Just return __WASI_ERRNO_SUCCESS (0).
          return {Literal(int32_t(0))};
        }

        // Otherwise, we don't recognize this import; continue normally to
        // error.
      }
    }

    std::string extra;
    if (import->module == ENV && import->base == "___cxa_atexit") {
      extra = RECOMMENDATION "build with -s NO_EXIT_RUNTIME=1 so that calls "
                             "to atexit are not emitted";
    } else if (import->module == WASI && !ignoreExternalInput) {
      extra = RECOMMENDATION "consider --ignore-external-input";
    }
    throw FailToEvalException(std::string("call import: ") +
                              import->module.toString() + "." +
                              import->base.toString() + extra);
  }

  // We assume the table is not modified FIXME
  Literals callTable(Name tableName,
                     Index index,
                     HeapType sig,
                     Literals& arguments,
                     Type result,
                     EvallingModuleRunner& instance) override {

    std::unordered_map<wasm::Name, std::vector<wasm::Name>>::iterator it;

    auto* table = wasm->getTableOrNull(tableName);
    if (!table) {
      throw FailToEvalException("callTable on non-existing table");
    }

    // Look through the segments and find the function. Segments can overlap,
    // so we want the last one.
    Name targetFunc;
    for (auto& segment : wasm->elementSegments) {
      if (segment->table != tableName) {
        continue;
      }

      Index start;
      // look for the index in this segment. if it has a constant offset, we
      // look in the proper range. if it instead gets a global, we rely on the
      // fact that when not dynamically linking then the table is loaded at
      // offset 0.
      if (auto* c = segment->offset->dynCast<Const>()) {
        start = c->value.getInteger();
      } else if (segment->offset->is<GlobalGet>()) {
        start = 0;
      } else {
        // wasm spec only allows const and global.get there
        WASM_UNREACHABLE("invalid expr type");
      }
      auto end = start + segment->data.size();
      if (start <= index && index < end) {
        auto entry = segment->data[index - start];
        if (auto* get = entry->dynCast<RefFunc>()) {
          targetFunc = get->func;
        } else {
          throw FailToEvalException(
            std::string("callTable on uninitialized entry"));
        }
      }
    }

    if (!targetFunc.is()) {
      throw FailToEvalException(
        std::string("callTable on index not found in static segments: ") +
        std::to_string(index));
    }

    // If this is one of our functions, we can call it; if it was
    // imported, fail.
    auto* func = wasm->getFunction(targetFunc);
    if (func->type != sig) {
      throw FailToEvalException(std::string("callTable signature mismatch: ") +
                                targetFunc.toString());
    }
    if (!func->imported()) {
      return instance.callFunctionInternal(targetFunc, arguments);
    } else {
      throw FailToEvalException(
        std::string("callTable on imported function: ") +
        targetFunc.toString());
    }
  }

  Index tableSize(Name tableName) override {
    throw FailToEvalException("table size");
  }

  Literal tableLoad(Name tableName, Index index) override {
    throw FailToEvalException("table.get: TODO");
  }

  // called during initialization
  void tableStore(Name tableName, Index index, const Literal& value) override {}

  int8_t load8s(Address addr, Name memoryName) override {
    return doLoad<int8_t>(addr, memoryName);
  }
  uint8_t load8u(Address addr, Name memoryName) override {
    return doLoad<uint8_t>(addr, memoryName);
  }
  int16_t load16s(Address addr, Name memoryName) override {
    return doLoad<int16_t>(addr, memoryName);
  }
  uint16_t load16u(Address addr, Name memoryName) override {
    return doLoad<uint16_t>(addr, memoryName);
  }
  int32_t load32s(Address addr, Name memoryName) override {
    return doLoad<int32_t>(addr, memoryName);
  }
  uint32_t load32u(Address addr, Name memoryName) override {
    return doLoad<uint32_t>(addr, memoryName);
  }
  int64_t load64s(Address addr, Name memoryName) override {
    return doLoad<int64_t>(addr, memoryName);
  }
  uint64_t load64u(Address addr, Name memoryName) override {
    return doLoad<uint64_t>(addr, memoryName);
  }

  void store8(Address addr, int8_t value, Name memoryName) override {
    doStore<int8_t>(addr, value, memoryName);
  }
  void store16(Address addr, int16_t value, Name memoryName) override {
    doStore<int16_t>(addr, value, memoryName);
  }
  void store32(Address addr, int32_t value, Name memoryName) override {
    doStore<int32_t>(addr, value, memoryName);
  }
  void store64(Address addr, int64_t value, Name memoryName) override {
    doStore<int64_t>(addr, value, memoryName);
  }

  bool growMemory(Name memoryName,
                  Address /*oldSize*/,
                  Address /*newSize*/) override {
    throw FailToEvalException("grow memory");
  }

  bool growTable(Name /*name*/,
                 const Literal& /*value*/,
                 Index /*oldSize*/,
                 Index /*newSize*/) override {
    throw FailToEvalException("grow table");
  }

  void trap(const char* why) override {
    throw FailToEvalException(std::string("trap: ") + why);
  }

  void hostLimit(const char* why) override {
    throw FailToEvalException(std::string("trap: ") + why);
  }

  void throwException(const WasmException& exn) override {
    std::stringstream ss;
    ss << "exception thrown: " << exn;
    throw FailToEvalException(ss.str());
  }

private:
  // TODO: handle unaligned too, see shell-interface
  template<typename T> T* getMemory(Address address, Name memoryName) {
    auto it = memories.find(memoryName);
    assert(it != memories.end());
    auto& memory = it->second;
    // resize the memory buffer as needed.
    auto max = address + sizeof(T);
    if (max > memory.size()) {
      memory.resize(max);
    }
    return (T*)(&memory[address]);
  }

  template<typename T> void doStore(Address address, T value, Name memoryName) {
    // do a memcpy to avoid undefined behavior if unaligned
    memcpy(getMemory<T>(address, memoryName), &value, sizeof(T));
  }

  template<typename T> T doLoad(Address address, Name memoryName) {
    // do a memcpy to avoid undefined behavior if unaligned
    T ret;
    memcpy(&ret, getMemory<T>(address, memoryName), sizeof(T));
    return ret;
  }

  // Clear the state of the operation of applying the interpreter's runtime
  // information into the module.
  //
  // This happens each time we apply contents to the module, which is basically
  // once per ctor function, but can be more fine-grained also if we execute a
  // line at a time.
  void clearApplyState() {
    // The process of allocating "defining globals" begins here, from scratch
    // each time (things live before may no longer be).
    definingGlobals.clear();

    // When we start to apply the state there should be no previous state left
    // over.
    assert(seenDataStack.empty());
  }

  void applyMemoryToModule() {
    // Memory must have already been flattened into the standard form: one
    // segment at offset 0, or none.
    if (wasm->dataSegments.empty()) {
      Builder builder(*wasm);
      auto curr = builder.makeDataSegment();
      curr->offset = builder.makeConst(int32_t(0));
      curr->setName(Name::fromInt(0), false);
      curr->memory = wasm->memories[0]->name;
      wasm->addDataSegment(std::move(curr));
    }
    auto& segment = wasm->dataSegments[0];
    assert(segment->offset->cast<Const>()->value.getInteger() == 0);

    // Copy the current memory contents after execution into the Module's
    // memory.
    segment->data = memories[wasm->memories[0]->name];
  }

  // Serializing GC data requires more work than linear memory, because
  // allocations have an identity, and they are created using struct.new /
  // array.new, which we must emit in a proper location in the wasm. This
  // affects how we serialize globals, which can contain GC data, and also, we
  // use globals to store GC data, so overall the process of computing the
  // globals is where most of the GC logic ends up.
  //
  // The general idea for handling GC data is as follows: After evaluating the
  // code, we end up with some live allocations in the interpreter, which we
  // need to somehow serialize into the wasm module. We will put each such live
  // GC data item into its own "defining global", a global whose purpose is to
  // create and store that data. Each such global is immutable, and has the
  // exact type of the data, for simplicity. Every other reference to that GC
  // data in the interpreter's memory can then be serialized by simply emitting
  // a global.get of that defining global.
  void applyGlobalsToModule() {
    Builder builder(*wasm);

    if (!wasm->features.hasGC()) {
      // Without GC, we can simply serialize the globals in place as they are.
      for (const auto& [name, values] : instance->globals) {
        wasm->getGlobal(name)->init = getSerialization(values);
      }
      return;
    }

    // We need to emit the "defining globals" of GC data before the existing
    // globals, as the normal ones may refer to them. We do this by removing all
    // the existing globals, and then adding them one by one, during which time
    // we call getSerialization() for their init expressions. If their init
    // refes to GC data, then we will allocate a defining global for that data,
    // and refer to it. Put another way, we place the existing globals back into
    // the module one at a time, adding their dependencies as we go.
    auto oldGlobals = std::move(wasm->globals);
    wasm->updateMaps();

    for (auto& oldGlobal : oldGlobals) {
      // Serialize the global's value. While doing so, pass in the name of this
      // global, as we may be able to reuse the global as the defining global
      // for the value. See getSerialization() for more details.
      Name name;
      if (!oldGlobal->mutable_ && oldGlobal->type == oldGlobal->init->type) {
        // This has the properties we need of a defining global - immutable and
        // of the precise type - so use it.
        name = oldGlobal->name;
      }

      // If there is a value here to serialize, do so. (If there is no value,
      // then this global was added after the interpreter initialized the
      // module, which means it is a new global we've added since; we don't need
      // to do anything for such a global - if it is needed it will show up as a
      // dependency of something, and be emitted at the right time and place.)
      auto iter = instance->globals.find(oldGlobal->name);
      if (iter != instance->globals.end()) {
        oldGlobal->init = getSerialization(iter->second, name);
        wasm->addGlobal(std::move(oldGlobal));
      }
    }
  }

public:
  // Maps each GC data in the interpreter to its defining global: the global in
  // which it is created, and then all other users of it can just global.get
  // that.
  std::unordered_map<GCData*, Name> definingGlobals;

  // The data we have seen so far on the stack. This is used to guard against
  // infinite recursion, which would otherwise happen if there is a cycle among
  // the live objects, which we don't handle yet.
  //
  // Pick a constant of 2 here to handle the common case of an object with a
  // reference to another object that is already in a defining global.
  SmallSet<GCData*, 2> seenDataStack;

  // If |possibleDefiningGlobal| is provided, it is the name of a global that we
  // are in the init expression of, and which can be reused as defining global,
  // if the other conditions are suitable.
  Expression* getSerialization(const Literal& value,
                               Name possibleDefiningGlobal = Name()) {
    Builder builder(*wasm);

    if (!value.isData()) {
      // This can be handled normally.
      return builder.makeConstantExpression(value);
    }

    // This is GC data, which we must handle in a more careful way.
    auto* data = value.getGCData().get();
    assert(data);

    // There was actual GC data allocated here.
    auto type = value.type;
    auto& definingGlobal = definingGlobals[data];
    if (!definingGlobal.is()) {
      // This is the first usage of this allocation. Generate a struct.new /
      // array.new for it.
      auto& values = value.getGCData()->values;
      std::vector<Expression*> args;

      // The initial values for this allocation may themselves be GC
      // allocations. Recurse and add globals as necessary.
      // TODO: Handle cycles. That will require code in the start function. For
      //       now, just error if we detect an infinite recursion.
      if (seenDataStack.count(data)) {
        Fatal() << "Cycle in live GC data, which we cannot serialize yet.";
      }
      seenDataStack.insert(data);
      for (auto& value : values) {
        args.push_back(getSerialization(value));
      }
      seenDataStack.erase(data);

      Expression* init;
      auto heapType = type.getHeapType();
      if (heapType.isStruct()) {
        init = builder.makeStructNew(heapType, args);
      } else if (heapType.isArray()) {
        // TODO: for repeated identical values, can use ArrayNew
        init = builder.makeArrayInit(heapType, args);
      } else {
        WASM_UNREACHABLE("bad gc type");
      }

      if (possibleDefiningGlobal.is()) {
        // No need to allocate a new global, as we are in the definition of
        // one. Just return the initialization expression, which will be
        // placed in that global's |init| field, and first note this as the
        // defining global.
        definingGlobal = possibleDefiningGlobal;
        return init;
      }

      // Allocate a new defining global.
      auto name = Names::getValidGlobalName(*wasm, "ctor-eval$global");
      wasm->addGlobal(builder.makeGlobal(name, type, init, Builder::Immutable));
      definingGlobal = name;
    }

    // Refer to this GC allocation by reading from the global that is
    // designated to contain it.
    return builder.makeGlobalGet(definingGlobal, value.type);
  }

  Expression* getSerialization(const Literals& values,
                               Name possibleDefiningGlobal = Name()) {
    assert(values.size() == 1);
    return getSerialization(values[0], possibleDefiningGlobal);
  }
};

// The outcome of evalling a ctor is one of three states:
//
// 1. We failed to eval it completely (but perhaps we succeeded partially). In
//    that case the std::optional here contains nothing.
// 2. We evalled it completely, and it is a function with no return value, so
//    it contains an empty Literals.
// 3. We evalled it completely, and it is a function with a return value, so
//    it contains Literals with those results.
using EvalCtorOutcome = std::optional<Literals>;

// Eval a single ctor function. Returns whether we succeeded to completely
// evaluate the ctor (which means that the caller can proceed to try to eval
// further ctors if there are any), and if we did, the results if the function
// returns any.
EvalCtorOutcome evalCtor(EvallingModuleRunner& instance,
                         CtorEvalExternalInterface& interface,
                         Name funcName,
                         Name exportName) {
  auto& wasm = instance.wasm;
  auto* func = wasm.getFunction(funcName);

  // We don't know the values of parameters, so give up if there are any, unless
  // we are ignoring them.
  if (func->getNumParams() > 0 && !ignoreExternalInput) {
    std::cout << "  ...stopping due to params\n";
    std::cout << RECOMMENDATION "consider --ignore-external-input";
    return EvalCtorOutcome();
  }

  // If there are params, we are ignoring them (or we would have quit earlier);
  // set those up with zeros.
  // TODO: Have a safer option here, either
  //        1. Statically or dynamically stop evalling when a param is actually
  //           used, or
  //        2. Split out --ignore-external-input into separate flags.
  Literals params;
  for (Index i = 0; i < func->getNumParams(); i++) {
    auto type = func->getLocalType(i);
    if (!LiteralUtils::canMakeZero(type)) {
      std::cout << "  ...stopping due to non-zeroable param\n";
      return EvalCtorOutcome();
    }
    params.push_back(Literal::makeZero(type));
  }

  // We want to handle the form of the global constructor function in LLVM. That
  // looks like this:
  //
  //    (func $__wasm_call_ctors
  //      (call $ctor.1)
  //      (call $ctor.2)
  //      (call $ctor.3)
  //    )
  //
  // Some of those ctors may be inlined, however, which would mean that the
  // function could have locals, control flow, etc. However, we assume for now
  // that it does not have parameters at least (whose values we can't tell).
  // And for now we look for a toplevel block and process its children one at a
  // time. This allows us to eval some of the $ctor.* functions (or their
  // inlined contents) even if not all.
  //
  // TODO: Support complete partial evalling, that is, evaluate parts of an
  //       arbitrary function, and not just a sequence in a single toplevel
  //       block.

  if (auto* block = func->body->dynCast<Block>()) {
    // Go through the items in the block and try to execute them. We do all this
    // in a single function scope for all the executions.
    EvallingModuleRunner::FunctionScope scope(func, params, instance);

    // After we successfully eval a line we will apply the changes here. This is
    // the same idea as applyToModule() - we must only do it after an entire
    // atomic "chunk" has been processed, we do not want partial updates from
    // an item in the block that we only partially evalled.
    std::vector<Literals> appliedLocals;

    Literals results;
    Index successes = 0;
    for (auto* curr : block->list) {
      Flow flow;
      try {
        flow = instance.visit(curr);
      } catch (FailToEvalException& fail) {
        if (successes == 0) {
          std::cout << "  ...stopping (in block) since could not eval: "
                    << fail.why << "\n";
        } else {
          std::cout << "  ...partial evalling successful, but stopping since "
                       "could not eval: "
                    << fail.why << "\n";
        }
        break;
      }

      // So far so good! Apply the results.
      interface.applyToModule();
      appliedLocals = scope.locals;
      successes++;

      // Note the values here, if any. If we are exiting the function now then
      // these will be returned.
      results = flow.values;

      if (flow.breaking()) {
        // We are returning out of the function (either via a return, or via a
        // break to |block|, which has the same outcome. That means we don't
        // need to execute any more lines, and can consider them to be executed.
        std::cout << "  ...stopping in block due to break\n";

        // Mark us as having succeeded on the entire block, since we have: we
        // are skipping the rest, which means there is no problem there. We must
        // set this here so that lower down we realize that we've evalled
        // everything.
        successes = block->list.size();
        break;
      }
    }

    if (successes > 0 && successes < block->list.size()) {
      // We managed to eval some but not all. That means we can't just remove
      // the entire function, but need to keep parts of it - the parts we have
      // not evalled - around. To do so, we create a copy of the function with
      // the partially-evalled contents and make the export use that (as the
      // function may be used in other places than the export, which we do not
      // want to affect).
      auto copyName = Names::getValidFunctionName(wasm, funcName);
      auto* copyFunc = ModuleUtils::copyFunction(func, wasm, copyName);
      wasm.getExport(exportName)->value = copyName;

      // Remove the items we've evalled.
      Builder builder(wasm);
      auto* copyBlock = copyFunc->body->cast<Block>();
      for (Index i = 0; i < successes; i++) {
        copyBlock->list[i] = builder.makeNop();
      }

      // Write out the values of locals, that is the local state after evalling
      // the things we've just nopped. For simplicity we just write out all of
      // locals, and leave it to the optimizer to remove redundant or
      // unnecessary operations.
      std::vector<Expression*> localSets;
      for (Index i = 0; i < copyFunc->getNumLocals(); i++) {
        auto value = appliedLocals[i];
        localSets.push_back(
          builder.makeLocalSet(i, interface.getSerialization(value)));
      }

      // Put the local sets at the front of the block. We know there must be a
      // nop in that position (since we've evalled at least one item in the
      // block, and replaced it with a nop), so we can overwrite it.
      copyBlock->list[0] = builder.makeBlock(localSets);

      // Interesting optimizations may be possible both due to removing some but
      // not all of the code, and due to the locals we just added.
      PassRunner passRunner(&wasm,
                            PassOptions::getWithDefaultOptimizationOptions());
      passRunner.addDefaultFunctionOptimizationPasses();
      passRunner.runOnFunction(copyFunc);
    }

    // Return true if we evalled the entire block. Otherwise, even if we evalled
    // some of it, the caller must stop trying to eval further things.
    if (successes == block->list.size()) {
      return EvalCtorOutcome(results);
    } else {
      return EvalCtorOutcome();
    }
  }

  // Otherwise, we don't recognize a pattern that allows us to do partial
  // evalling. So simply call the entire function at once and see if we can
  // optimize that.

  Literals results;
  try {
    results = instance.callFunction(funcName, params);
  } catch (FailToEvalException& fail) {
    std::cout << "  ...stopping since could not eval: " << fail.why << "\n";
    return EvalCtorOutcome();
  }

  // Success! Apply the results.
  interface.applyToModule();
  return EvalCtorOutcome(results);
}

// Eval all ctors in a module.
void evalCtors(Module& wasm,
               std::vector<std::string>& ctors,
               std::vector<std::string>& keptExports) {
  std::unordered_set<std::string> keptExportsSet(keptExports.begin(),
                                                 keptExports.end());

  std::map<Name, std::shared_ptr<EvallingModuleRunner>> linkedInstances;

  // build and link the env module
  auto envModule = buildEnvModule(wasm);
  CtorEvalExternalInterface envInterface;
  auto envInstance =
    std::make_shared<EvallingModuleRunner>(*envModule, &envInterface);
  linkedInstances[envModule->name] = envInstance;

  CtorEvalExternalInterface interface(linkedInstances);
  try {
    // create an instance for evalling
    EvallingModuleRunner instance(wasm, &interface, linkedInstances);
    // go one by one, in order, until we fail
    // TODO: if we knew priorities, we could reorder?
    for (auto& ctor : ctors) {
      std::cout << "trying to eval " << ctor << '\n';
      Export* ex = wasm.getExportOrNull(ctor);
      if (!ex) {
        Fatal() << "export not found: " << ctor;
      }
      auto funcName = ex->value;
      auto outcome = evalCtor(instance, interface, funcName, ctor);
      if (!outcome) {
        std::cout << "  ...stopping\n";
        return;
      }

      // Success! And we can continue to try more.
      std::cout << "  ...success on " << ctor << ".\n";

      // Remove the export if we should.
      auto* exp = wasm.getExport(ctor);
      if (!keptExportsSet.count(ctor)) {
        wasm.removeExport(exp->name);
      } else {
        // We are keeping around the export, which should now refer to an
        // empty function since calling the export should do nothing.
        auto* func = wasm.getFunction(exp->value);
        auto copyName = Names::getValidFunctionName(wasm, func->name);
        auto* copyFunc = ModuleUtils::copyFunction(func, wasm, copyName);
        if (func->getResults() == Type::none) {
          copyFunc->body = Builder(wasm).makeNop();
        } else {
          copyFunc->body = interface.getSerialization(*outcome);
        }
        wasm.getExport(exp->name)->value = copyName;
      }
    }
  } catch (FailToEvalException& fail) {
    // that's it, we failed to even create the instance
    std::cout << "  ...stopping since could not create module instance: "
              << fail.why << "\n";
    return;
  }
}

static bool canEval(Module& wasm) {
  // Check if we can flatten memory. We need to do so currently because of how
  // we assume memory is simple and flat. TODO
  if (!MemoryUtils::flatten(wasm)) {
    std::cout << "  ...stopping since could not flatten memory\n";
    return false;
  }
  return true;
}

} // anonymous namespace

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::vector<std::string> passes;
  bool emitBinary = true;
  bool debugInfo = false;
  String::Split ctors;
  String::Split keptExports;

  const std::string WasmCtorEvalOption = "wasm-ctor-eval options";

  ToolOptions options("wasm-ctor-eval", "Execute code at compile time");
  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         WasmCtorEvalOption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::setEnabled(false);
         })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file",
         WasmCtorEvalOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { emitBinary = false; })
    .add("--debuginfo",
         "-g",
         "Emit names section and debug info",
         WasmCtorEvalOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { debugInfo = true; })
    .add("--ctors",
         "-c",
         "Comma-separated list of global constructor functions to evaluate",
         WasmCtorEvalOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           ctors = String::Split(argument, ",");
         })
    .add(
      "--kept-exports",
      "-ke",
      "Comma-separated list of ctors whose exports we keep around even if we "
      "eval those ctors",
      WasmCtorEvalOption,
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) {
        keptExports = String::Split(argument, ",");
      })
    .add("--ignore-external-input",
         "-ipi",
         "Assumes no env vars are to be read, stdin is empty, etc.",
         WasmCtorEvalOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           ignoreExternalInput = true;
         })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    });
  options.parse(argc, argv);

  auto input(read_file<std::string>(options.extra["infile"], Flags::Text));

  Module wasm;
  options.applyFeatures(wasm);

  {
    if (options.debug) {
      std::cout << "reading...\n";
    }
    ModuleReader reader;
    try {
      reader.read(options.extra["infile"], wasm);
    } catch (ParseException& p) {
      p.dump(std::cout);
      Fatal() << "error in parsing input";
    }
  }

  if (!WasmValidator().validate(wasm)) {
    std::cout << wasm << '\n';
    Fatal() << "error in validating input";
  }

  if (canEval(wasm)) {
    evalCtors(wasm, ctors, keptExports);

    // Do some useful optimizations after the evalling
    {
      PassRunner passRunner(&wasm);
      passRunner.add("memory-packing"); // we flattened it, so re-optimize
      // TODO: just do -Os for the one function
      passRunner.add("remove-unused-names");
      passRunner.add("dce");
      passRunner.add("merge-blocks");
      passRunner.add("vacuum");
      passRunner.add("remove-unused-module-elements");
      passRunner.run();
    }
  }

  if (options.extra.count("output") > 0) {
    if (options.debug) {
      std::cout << "writing..." << std::endl;
    }
    ModuleWriter writer;
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    writer.write(wasm, options.extra["output"]);
  }
}
