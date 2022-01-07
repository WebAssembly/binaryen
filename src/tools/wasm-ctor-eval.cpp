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
// applying their changes to memory as needed, then writes it. In
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

// We do not have access to imported globals
class EvallingGlobalManager {
  // values of globals
  std::map<Name, Literals> globals;

  // globals that are dangerous to modify in the module
  std::set<Name> dangerousGlobals;

  // whether we are done adding new globals
  bool sealed = false;

public:
  void addDangerous(Name name) { dangerousGlobals.insert(name); }

  void seal() { sealed = true; }

  Literals& operator[](Name name) {
    if (dangerousGlobals.count(name) > 0) {
      std::string extra;
      if (name == "___dso_handle") {
        extra = RECOMMENDATION "build with -s NO_EXIT_RUNTIME=1 so that "
                "calls to atexit that use ___dso_handle are not emitted";
      }
      throw FailToEvalException(
        std::string(
          "tried to access a dangerous (import-initialized) global: ") +
        name.str + extra);
    }
    return globals[name];
  }

  struct Iterator {
    Name first;
    Literals second;
    bool found;

    Iterator() : found(false) {}
    Iterator(Name name, Literals value)
      : first(name), second(value), found(true) {}

    bool operator==(const Iterator& other) {
      return first == other.first && second == other.second &&
             found == other.found;
    }
    bool operator!=(const Iterator& other) { return !(*this == other); }
  };

  Iterator find(Name name) {
    if (globals.find(name) == globals.end()) {
      return end();
    }
    return Iterator(name, globals[name]);
  }

  Iterator end() { return Iterator(); }

  // Receives a module and applies the state of globals here into the globals
  // in that module.
  void applyToModule(Module& wasm) {
    Builder builder(wasm);
    for (const auto& [name, value] : globals) {
      wasm.getGlobal(name)->init = builder.makeConstantExpression(value);
    }
  }
};

class EvallingModuleInstance
  : public ModuleInstanceBase<EvallingGlobalManager, EvallingModuleInstance> {
public:
  EvallingModuleInstance(Module& wasm,
                         ExternalInterface* externalInterface,
                         std::map<Name, std::shared_ptr<EvallingModuleInstance>>
                           linkedInstances_ = {})
    : ModuleInstanceBase(wasm, externalInterface, linkedInstances_) {
    // if any global in the module has a non-const constructor, it is using a
    // global import, which we don't have, and is illegal to use
    ModuleUtils::iterDefinedGlobals(wasm, [&](Global* global) {
      if (!global->init->is<Const>()) {
        // this global is dangerously initialized by an import, so if it is
        // used, we must fail
        globals.addDangerous(global->name);
      }
    });
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
      env->memory.name = wasm.memory.name;
      env->memory.exists = true;
      env->memory.initial = memory->initial;
      env->memory.max = memory->max;
      env->memory.shared = memory->shared;
      env->memory.indexType = memory->indexType;
      env->addExport(Builder(*env).makeExport(
        wasm.memory.base, wasm.memory.name, ExternalKind::Memory));
    }
  });

  return env;
}

// Whether to ignore external input to the program as it runs. If set, we will
// assume that stdin is empty, that any env vars we try to read are not set,
// that there are not arguments passed to main, etc.
static bool ignoreExternalInput = false;

struct CtorEvalExternalInterface : EvallingModuleInstance::ExternalInterface {
  Module* wasm;
  EvallingModuleInstance* instance;
  std::map<Name, std::shared_ptr<EvallingModuleInstance>> linkedInstances;

  // A representation of the contents of wasm memory as we execute.
  std::vector<char> memory;

  CtorEvalExternalInterface(
    std::map<Name, std::shared_ptr<EvallingModuleInstance>> linkedInstances_ =
      {}) {
    linkedInstances.swap(linkedInstances_);
  }

  // Called when we want to apply the current state of execution to the Module.
  // Until this is called the Module is never changed.
  void applyToModule() {
    // If nothing was ever written to memory then there is nothing to update.
    if (!memory.empty()) {
      applyMemoryToModule();
    }

    instance->globals.applyToModule(*wasm);
  }

  void init(Module& wasm_, EvallingModuleInstance& instance_) override {
    wasm = &wasm_;
    instance = &instance_;
  }

  void importGlobals(EvallingGlobalManager& globals, Module& wasm_) override {
    ModuleUtils::iterImportedGlobals(wasm_, [&](Global* global) {
      auto it = linkedInstances.find(global->module);
      if (it != linkedInstances.end()) {
        auto* inst = it->second.get();
        auto* globalExport = inst->wasm.getExportOrNull(global->base);
        if (!globalExport) {
          throw FailToEvalException(std::string("importGlobals: ") +
                                    global->module.str + "." +
                                    global->base.str);
        }
        globals[global->name] = inst->globals[globalExport->value];
      } else {
        throw FailToEvalException(std::string("importGlobals: ") +
                                  global->module.str + "." + global->base.str);
      }
    });
  }

  Literals callImport(Function* import, LiteralList& arguments) override {
    Name WASI("wasi_snapshot_preview1");

    if (ignoreExternalInput) {
      if (import->module == WASI) {
        if (import->base == "environ_sizes_get") {
          if (arguments.size() != 2 || arguments[0].type != Type::i32 ||
              import->getResults() != Type::i32) {
            throw FailToEvalException("wasi environ_sizes_get has wrong sig");
          }

          // Write out a count of i32(0) and return __WASI_ERRNO_SUCCESS (0).
          store32(arguments[0].geti32(), 0);
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
          store32(arguments[0].geti32(), 0);
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
                              import->module.str + "." + import->base.str +
                              extra);
  }

  Literals callTable(Name tableName,
                     Index index,
                     HeapType sig,
                     LiteralList& arguments,
                     Type result,
                     EvallingModuleInstance& instance) override {

    std::unordered_map<wasm::Name, std::vector<wasm::Name>>::iterator it;

    auto* table = wasm->getTableOrNull(tableName);
    if (!table) {
      throw FailToEvalException("callTable on non-existing table");
    }

    // we assume the table is not modified (hmm)
    // look through the segments, try to find the function
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
          auto name = get->func;
          // if this is one of our functions, we can call it; if it was
          // imported, fail
          auto* func = wasm->getFunction(name);
          if (func->type != sig) {
            throw FailToEvalException(
              std::string("callTable signature mismatch: ") + name.str);
          }
          if (!func->imported()) {
            return instance.callFunctionInternal(name, arguments);
          } else {
            throw FailToEvalException(
              std::string("callTable on imported function: ") + name.str);
          }
        } else {
          throw FailToEvalException(
            std::string("callTable on uninitialized entry"));
        }
      }
    }
    throw FailToEvalException(
      std::string("callTable on index not found in static segments: ") +
      std::to_string(index));
  }

  Index tableSize(Name tableName) override {
    throw FailToEvalException("table size");
  }

  Literal tableLoad(Name tableName, Index index) override {
    throw FailToEvalException("table.get: TODO");
  }

  // called during initialization
  void tableStore(Name tableName, Index index, const Literal& value) override {}

  int8_t load8s(Address addr) override { return doLoad<int8_t>(addr); }
  uint8_t load8u(Address addr) override { return doLoad<uint8_t>(addr); }
  int16_t load16s(Address addr) override { return doLoad<int16_t>(addr); }
  uint16_t load16u(Address addr) override { return doLoad<uint16_t>(addr); }
  int32_t load32s(Address addr) override { return doLoad<int32_t>(addr); }
  uint32_t load32u(Address addr) override { return doLoad<uint32_t>(addr); }
  int64_t load64s(Address addr) override { return doLoad<int64_t>(addr); }
  uint64_t load64u(Address addr) override { return doLoad<uint64_t>(addr); }

  void store8(Address addr, int8_t value) override {
    doStore<int8_t>(addr, value);
  }
  void store16(Address addr, int16_t value) override {
    doStore<int16_t>(addr, value);
  }
  void store32(Address addr, int32_t value) override {
    doStore<int32_t>(addr, value);
  }
  void store64(Address addr, int64_t value) override {
    doStore<int64_t>(addr, value);
  }

  bool growMemory(Address /*oldSize*/, Address /*newSize*/) override {
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

  template<typename T> T* getMemory(Address address) {
    // resize the memory buffer as needed.
    auto max = address + sizeof(T);
    if (max > memory.size()) {
      memory.resize(max);
    }
    return (T*)(&memory[address]);
  }

  template<typename T> void doStore(Address address, T value) {
    // do a memcpy to avoid undefined behavior if unaligned
    memcpy(getMemory<T>(address), &value, sizeof(T));
  }

  template<typename T> T doLoad(Address address) {
    // do a memcpy to avoid undefined behavior if unaligned
    T ret;
    memcpy(&ret, getMemory<T>(address), sizeof(T));
    return ret;
  }

  void applyMemoryToModule() {
    // Memory must have already been flattened into the standard form: one
    // segment at offset 0, or none.
    if (wasm->memory.segments.empty()) {
      Builder builder(*wasm);
      std::vector<char> empty;
      wasm->memory.segments.push_back(
        Memory::Segment(builder.makeConst(int32_t(0)), empty));
    }
    auto& segment = wasm->memory.segments[0];
    assert(segment.offset->cast<Const>()->value.getInteger() == 0);

    // Copy the current memory contents after execution into the Module's
    // memory.
    segment.data = memory;
  }
};

// Eval a single ctor function. Returns whether we succeeded to completely
// evaluate the ctor, which means that the caller can proceed to try to eval
// further ctors if there are any.
bool evalCtor(EvallingModuleInstance& instance,
              CtorEvalExternalInterface& interface,
              Name funcName,
              Name exportName) {
  auto& wasm = instance.wasm;
  auto* func = wasm.getFunction(funcName);

  // We don't know the values of parameters, so give up if there are any.
  // TODO: Maybe use ignoreExternalInput?
  // TODO test this and other corner cases
  if (func->getNumParams() > 0) {
    std::cout << "  ...stopping due to params\n";
    return false;
  }

  // TODO: Handle a return value by emitting a proper constant.
  if (func->getResults() != Type::none) {
    std::cout << "  ...stopping due to results\n";
    return false;
  }

  // Special case the form of the global constructor function in LLVM. That
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
  // We may be possible to eval some of those functions but not all, so go
  // through them one by one.

  // TODO: Support complete partial evalling, that is, evaluate parts of an
  //       arbitrary function, and not just a sequence in a single toplevel
  //       block.
  if (auto* block = func->body->dynCast<Block>()) {
    // Go through the items in the block and try to execute them. We do all this
    // in a single function scope for all the executions.
    EvallingModuleInstance::FunctionScope scope(func, LiteralList());
    EvallingModuleInstance::RuntimeExpressionRunner expressionRunner(
      instance, scope, 100); // TODO MaxDepth default in .h
    Index successes = 0;
    for (auto* curr : block->list) {
      Flow flow;
      try {
        flow = expressionRunner.visit(curr);
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

      // So far so good!
      interface.applyToModule();
      successes++;

      if (flow.breaking()) {
        // We are returning out of the function (either via a return, or via a
        // break to |block|, which has the same outcome. That means we don't
        // need to execute any more lines, and can consider them to be executed.
        std::cout << "  ...stopping in block due to break\n";
        successes = block->list.size();
        break;
      }
    }

    if (successes > 0 && successes < block->list.size()) {
      // We managed to eval some but not all. We want to apply what we've
      // managed to do. Create a copy of the function with those contents and
      // make the export use that (as the function may be used by others).
      auto copyName = Names::getValidFunctionName(wasm, funcName);
      auto* copyFunc = ModuleUtils::copyFunction(func, wasm, copyName);
      wasm.getExport(exportName)->value = copyName;

      // Remove the items we've evalled.
      Builder builder(wasm);
      auto* copyBlock = copyFunc->body->cast<Block>();
      for (Index i = 0; i < successes; i++) {
        copyBlock->list[i] = builder.makeNop();
      }

      // Apply the locals.
      std::vector<Expression*> localSets;
      for (Index i = 0; i < copyFunc->getNumLocals(); i++) {
        auto value = scope.locals[i];
        localSets.push_back(
          builder.makeLocalSet(i, builder.makeConstantExpression(value)));
      }

      // Put the local sets at the front of the block. We know there must be a
      // nop in that position, so we can overwrite it.
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
    return successes == block->list.size();
  }

  // Otherwise, we don't recognize a pattern that allows us to do partial
  // evalling. So simply call the entire function at once and see if we can
  // optimize that.
  try {
    instance.callFunction(funcName, LiteralList());
  } catch (FailToEvalException& fail) {
    std::cout << "  ...stopping since could not eval: " << fail.why << "\n";
    return false;
  }

  // Success! Apply the results.
  interface.applyToModule();
  return true;
}

// Eval all ctors in a module.
void evalCtors(Module& wasm, std::vector<std::string> ctors) {
  std::map<Name, std::shared_ptr<EvallingModuleInstance>> linkedInstances;

  // build and link the env module
  auto envModule = buildEnvModule(wasm);
  CtorEvalExternalInterface envInterface;
  auto envInstance =
    std::make_shared<EvallingModuleInstance>(*envModule, &envInterface);
  linkedInstances[envModule->name] = envInstance;

  CtorEvalExternalInterface interface(linkedInstances);
  try {
    // flatten memory, so we do not depend on the layout of data segments
    if (!MemoryUtils::flatten(wasm.memory)) {
      Fatal() << "  ...stopping since could not flatten memory\n";
    }

    // create an instance for evalling
    EvallingModuleInstance instance(wasm, &interface, linkedInstances);
    // we should not add new globals from here on; as a result, using
    // an imported global will fail, as it is missing and so looks new
    instance.globals.seal();
    // go one by one, in order, until we fail
    // TODO: if we knew priorities, we could reorder?
    for (auto& ctor : ctors) {
      std::cout << "trying to eval " << ctor << '\n';
      Export* ex = wasm.getExportOrNull(ctor);
      if (!ex) {
        Fatal() << "export not found: " << ctor;
      }
      auto funcName = ex->value;
      if (!evalCtor(instance, interface, funcName, ctor)) {
        std::cout << "  ...stopping\n";
        return;
      }

      // Success! Remove the export, and continue.
      std::cout << "  ...success on " << ctor << ".\n";
      wasm.removeExport(ctor);
    }
  } catch (FailToEvalException& fail) {
    // that's it, we failed to even create the instance
    std::cout << "  ...stopping since could not create module instance: "
              << fail.why << "\n";
    return;
  }
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
  std::string ctorsString;

  const std::string WasmCtorEvalOption = "wasm-ctor-eval options";

  ToolOptions options("wasm-ctor-eval",
                      "Execute C++ global constructors ahead of time");
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
    .add(
      "--ctors",
      "-c",
      "Comma-separated list of global constructor functions to evaluate",
      WasmCtorEvalOption,
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) { ctorsString = argument; })
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

  // get list of ctors, and eval them
  std::vector<std::string> ctors;
  std::istringstream stream(ctorsString);
  std::string temp;
  while (std::getline(stream, temp, ',')) {
    ctors.push_back(temp);
  }
  evalCtors(wasm, ctors);

  // Do some useful optimizations after the evalling
  {
    PassRunner passRunner(&wasm);
    passRunner.add("memory-packing"); // we flattened it, so re-optimize
/*
// TODO: just do -Os for the one function
    passRunner.add("remove-unused-names");
    passRunner.add("dce");
    passRunner.add("merge-blocks");
    passRunner.add("vacuum");
*/
    passRunner.add("remove-unused-module-elements");
    passRunner.run();
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
