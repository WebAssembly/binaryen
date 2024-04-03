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
#include "ir/find_all.h"
#include "ir/gc-type-utils.h"
#include "ir/global-utils.h"
#include "ir/import-utils.h"
#include "ir/literal-utils.h"
#include "ir/memory-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "support/colors.h"
#include "support/file.h"
#include "support/insert_ordered.h"
#include "support/small_set.h"
#include "support/string.h"
#include "support/topological_sort.h"
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

// Check whether a field is both nullable and mutable. This is a useful
// property for breaking cycles of GC data, see below.
bool isNullableAndMutable(Expression* ref, Index fieldIndex) {
  // Find the field for the given reference, and check its properties.
  auto field = GCTypeUtils::getField(ref->type, fieldIndex);
  assert(field);
  return field->type.isNullable() && field->mutable_ == Mutable;
}

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

  Flow visitTableSet(TableSet* curr) {
    // TODO: Full dynamic table support. For now we stop evalling when we see a
    //       table.set. (To support this we need to track sets and add code to
    //       serialize them.)
    throw FailToEvalException("table.set: TODO");
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

  // All the names of globals we've seen in the module. We cannot reuse these.
  // We must track these manually as we will be adding more, and as we do so we
  // also reorder them, so we remove and re-add globals, which means the module
  // itself is not aware of all the globals that belong to it (those that have
  // not yet been re-added are a blind spot for it).
  std::unordered_set<Name> usedGlobalNames;

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

    for (auto& global : wasm->globals) {
      usedGlobalNames.insert(global->name);
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

  Literals callImport(Function* import, const Literals& arguments) override {
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
  std::array<uint8_t, 16> load128(Address addr, Name memoryName) override {
    return doLoad<std::array<uint8_t, 16>>(addr, memoryName);
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
  void store128(Address addr,
                const std::array<uint8_t, 16>& value,
                Name memoryName) override {
    doStore<std::array<uint8_t, 16>>(addr, value, memoryName);
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
  // We limit the size of memory to some reasonable amount. We handle memory in
  // a linear/dense manner, so when we see a write to address X we allocate X
  // memory to represent that, and so very high addresses can lead to OOM. In
  // practice, ctor-eval should only run on low addresses anyhow, since static
  // memory tends to be reasonably-sized and mallocs start at the start of the
  // heap, so it's simpler to add an arbitrary limit here to avoid OOMs for now.
  const size_t MaximumMemory = 100 * 1024 * 1024;

  // TODO: handle unaligned too, see shell-interface
  template<typename T> T* getMemory(Address address, Name memoryName) {
    auto it = memories.find(memoryName);
    assert(it != memories.end());
    auto& memory = it->second;
    // resize the memory buffer as needed.
    auto max = address + sizeof(T);
    if (max > memory.size()) {
      if (max > MaximumMemory) {
        throw FailToEvalException("excessively high memory address accessed");
      }
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

    // Clear any startup operations as well (which may apply to globals that
    // become no longer live; we'll create new start operations as we need
    // them).
    clearStartBlock();
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
    // After clearing the globals vector, clear the map as well.
    wasm->updateMaps();

    for (auto& oldGlobal : oldGlobals) {
      // Serialize the global's value. While doing so, pass in the name of this
      // global, as we may be able to reuse the global as the defining global
      // for the value. See getSerialization() for more details.
      Name name;
      if (!oldGlobal->mutable_ && oldGlobal->type == oldGlobal->init->type) {
        // This has the properties we need of a defining global - immutable and
        // of the precise type - so use it as such.
        name = oldGlobal->name;
      }

      // If the instance has an evalled value here, compute the serialization
      // for it. (If there is no value, then this is a new global we've added
      // during execution, for whom we've already set up a proper serialized
      // value when we created it.)
      auto iter = instance->globals.find(oldGlobal->name);
      if (iter != instance->globals.end()) {
        oldGlobal->init = getSerialization(iter->second, name);
      }

      // Add the global back to the module.
      wasm->addGlobal(std::move(oldGlobal));
    }

    // Finally, we need to fix up cycles. The serialization we just emitted
    // ignores them, so we can end up with things like this:
    //
    //  (global $a (struct.new $A (global.get $a)))
    //
    // That global refers to an object that should have a self-reference, and
    // the serialization logic simply emits global.gets for all references, so
    // we end up with a situation like this where a global.get refers to a
    // global before it is valid to do so. To fix this up, we can reorder
    // globals as needed, and break up cycles by writing a null in the initial
    // struct.new in the global's definition, and later in the start function we
    // can perform additional struct.sets that cause cycles to form.
    //
    // The existing algorithm here is rather simple: we find things that
    // definitely force a certain order and sort according to them. Then in that
    // order we break forward references with fixups as described above. This is
    // not always the best, as there may be a more optimal order, and we may end
    // up doing more fixups than are absolutely necessary, but this algorithm is
    // simple and works in linear time (or nlogn including the sort). The
    // general problem here is NP-hard (the maximum acyclic subgraph problem),
    // but there are probably greedy algorithms we could consider if we need to
    // do better.

    Builder builder(*wasm);

    // First, find what constraints we have on the ordering of the globals. We
    // will build up a map of each global to the globals it must be after.
    using MustBeAfter = InsertOrderedMap<Name, InsertOrderedSet<Name>>;
    MustBeAfter mustBeAfter;

    for (auto& global : wasm->globals) {
      if (!global->init) {
        continue;
      }

      struct InitScanner : PostWalker<InitScanner> {
        // All the global.gets that we can't fix up by replacing the value with
        // a null and adding a set in the start function. These will be hard
        // constraints on our sorting (if we could fix things up with a null +
        // set then we would not need to reorder).
        InsertOrderedSet<GlobalGet*> unfixableGets;

        void visitGlobalGet(GlobalGet* curr) {
          // Assume this is unfixable, unless we reach the parent and see that
          // it is.
          unfixableGets.insert(curr);
        }

        // Checks if a child is a global.get that we need to handle, and if we
        // can fix it if so. The index is the position of the child in the
        // parent (which is 0 for all array children, as their position does not
        // matter, they all have the same field info).
        void handleChild(Expression* child,
                         Expression* parent,
                         Index fieldIndex = 0) {
          if (!child) {
            return;
          }

          if (auto* get = child->dynCast<GlobalGet>()) {
            if (isNullableAndMutable(parent, fieldIndex)) {
              // We can replace the child with a null, and set the value later
              // (in the start function), so this is not a constraint on our
              // sorting - we'll just fix it up later, and the order won't be
              // an issue.
              unfixableGets.erase(get);
            }
          }
        }

        void visitStructNew(StructNew* curr) {
          Index i = 0;
          for (auto* child : curr->operands) {
            handleChild(child, curr, i++);
          }
        }
        void visitArrayNew(ArrayNew* curr) { handleChild(curr->init, curr); }
        void visitArrayNewFixed(ArrayNewFixed* curr) {
          for (auto* child : curr->values) {
            handleChild(child, curr);
          }
        }
      };

      InitScanner scanner;
      scanner.walk(global->init);

      // Any global.gets that cannot be fixed up are constraints.
      for (auto* get : scanner.unfixableGets) {
        mustBeAfter[global->name].insert(get->name);
      }
    }

    if (!mustBeAfter.empty()) {
      // We found constraints that require reordering, so do so.
      struct MustBeAfterSort : TopologicalSort<Name, MustBeAfterSort> {
        MustBeAfter& mustBeAfter;

        MustBeAfterSort(MustBeAfter& mustBeAfter) : mustBeAfter(mustBeAfter) {
          for (auto& [global, _] : mustBeAfter) {
            push(global);
          }
        }

        void pushPredecessors(Name global) {
          auto iter = mustBeAfter.find(global);
          if (iter != mustBeAfter.end()) {
            for (auto other : iter->second) {
              push(other);
            }
          }
        }
      };

      auto oldGlobals = std::move(wasm->globals);
      // After clearing the globals vector, clear the map as well.
      wasm->updateMaps();

      std::unordered_map<Name, Index> globalIndexes;
      for (Index i = 0; i < oldGlobals.size(); i++) {
        globalIndexes[oldGlobals[i]->name] = i;
      }
      // Add the globals that had an important ordering, in the right order.
      for (auto global : MustBeAfterSort(mustBeAfter)) {
        wasm->addGlobal(std::move(oldGlobals[globalIndexes[global]]));
      }
      // Add all other globals after them.
      for (auto& global : oldGlobals) {
        if (global) {
          wasm->addGlobal(std::move(global));
        }
      }
    }

    // After sorting (*), perform the fixups that we need, that is, replace the
    // relevant fields in cycles with a null and prepare a set in the start
    // function.
    //
    // We'll track the set of readable globals as we go (which are the globals
    // we've seen already, and fully finished processing).
    //
    // (*) Note that we may need these fixups even if we didn't need to do any
    //     sorting. There may be a single global with a cycle in it, for
    //     example.
    std::unordered_set<Name> readableGlobals;

    for (auto& global : wasm->globals) {
      if (!global->init) {
        continue;
      }

      struct InitFixer : PostWalker<InitFixer> {
        CtorEvalExternalInterface& evaller;
        std::unique_ptr<Global>& global;
        std::unordered_set<Name>& readableGlobals;

        InitFixer(CtorEvalExternalInterface& evaller,
                  std::unique_ptr<Global>& global,
                  std::unordered_set<Name>& readableGlobals)
          : evaller(evaller), global(global), readableGlobals(readableGlobals) {
        }

        // Handles a child by fixing things up if needed. Returns true if we
        // did in fact fix things up.
        bool handleChild(Expression*& child,
                         Expression* parent,
                         Index fieldIndex = 0) {
          if (!child) {
            return false;
          }

          if (auto* get = child->dynCast<GlobalGet>()) {
            if (!readableGlobals.count(get->name)) {
              // This get cannot be read - it is a global that appears after
              // us - and so we must fix it up, using the method mentioned
              // before (setting it to null now, and later in the start
              // function writing to it).
              assert(isNullableAndMutable(parent, fieldIndex));
              evaller.addStartFixup(
                {global->name, global->type}, fieldIndex, get);
              child =
                Builder(*getModule()).makeRefNull(get->type.getHeapType());
              return true;
            }
          }

          return false;
        }

        // This code will need to be updated for all new GC-creating
        // instructions that we use when serializing GC data, that is, things we
        // put in defining globals. (All other instructions, even constant ones
        // in globals, will simply end up referring to them using a global.get,
        // but will not be referred to. That is, cycles will only appear in
        // defining globals.)

        void visitStructNew(StructNew* curr) {
          Index i = 0;
          for (auto*& child : curr->operands) {
            handleChild(child, curr, i++);
          }
        }
        void visitArrayNew(ArrayNew* curr) {
          if (handleChild(curr->init, curr)) {
            // Handling array.new is tricky as the number of items may be
            // unknown at compile time, so we'd need to loop at runtime. But,
            // in practice we emit an array.new_fixed anyhow, so this should
            // not be needed for now.
            WASM_UNREACHABLE("TODO: ArrayNew in ctor-eval cycles");
          }
        }
        void visitArrayNewFixed(ArrayNewFixed* curr) {
          Index i = 0;
          for (auto*& child : curr->values) {
            handleChild(child, curr, i++);
          }
        }
      };

      InitFixer fixer(*this, global, readableGlobals);
      fixer.setModule(wasm);
      fixer.walk(global->init);

      // Only after we've fully processed this global is it ok to be read from
      // by later globals.
      readableGlobals.insert(global->name);
    }
  }

public:
  // Maps each GC data in the interpreter to its defining global: the global in
  // which it is created, and then all other users of it can just global.get
  // that. For each such global we track its name and type.
  struct DefiningGlobalInfo {
    Name name;
    Type type;
  };
  std::unordered_map<GCData*, DefiningGlobalInfo> definingGlobals;

  // If |possibleDefiningGlobal| is provided, it is the name of a global that we
  // are in the init expression of, and which can be reused as defining global,
  // if the other conditions are suitable.
  Expression* getSerialization(Literal value,
                               Name possibleDefiningGlobal = Name()) {
    Builder builder(*wasm);

    // If this is externalized then we want to inspect the inner data, handle
    // that, and emit a ref.externalize around it as needed. To simplify the
    // logic here, we save the original (possible externalized) value, and then
    // look at the internals from here on out.
    Literal original = value;
    if (value.type.isRef() && value.type.getHeapType() == HeapType::ext) {
      value = value.internalize();

      // We cannot serialize truly external things, only data and i31s.
      assert(value.isData() || value.type.getHeapType() == HeapType::i31);
    }

    // GC data (structs and arrays) must be handled with the special global-
    // creating logic later down. But MVP types as well as i31s (even
    // externalized i31s) can be handled by the general makeConstantExpression
    // logic (which knows how to handle externalization, for i31s; and it also
    // can handle string constants).
    if (!value.isData() || value.type.getHeapType().isString()) {
      return builder.makeConstantExpression(original);
    }

    // This is GC data, which we must handle in a more careful way.
    auto* data = value.getGCData().get();
    assert(data);

    auto type = value.type;
    Name definingGlobalName;

    if (auto it = definingGlobals.find(data); it != definingGlobals.end()) {
      // Use the existing defining global.
      definingGlobalName = it->second.name;
    } else {
      // This is the first usage of this data. Generate a struct.new /
      // array.new for it.
      auto& values = value.getGCData()->values;
      std::vector<Expression*> args;

      // The initial values for this allocation may themselves be GC
      // allocations. Recurse and add globals as necessary. First, pick the
      // global name (note that we must do so first, as we may need to read from
      // definingGlobals to find where this global will be, in the case of a
      // cycle; see below).
      if (possibleDefiningGlobal.is()) {
        // No need to allocate a new global, as we are in the definition of
        // one, which will be the defining global.
        definingGlobals[data] =
          DefiningGlobalInfo{possibleDefiningGlobal, type};
        definingGlobalName = possibleDefiningGlobal;
      } else {
        // Allocate a new defining global.
        definingGlobalName =
          Names::getValidNameGivenExisting("ctor-eval$global", usedGlobalNames);
        usedGlobalNames.insert(definingGlobalName);
        definingGlobals[data] = DefiningGlobalInfo{definingGlobalName, type};
      }

      for (auto& value : values) {
        args.push_back(getSerialization(value));
      }

      Expression* init;
      auto heapType = type.getHeapType();
      if (heapType.isStruct()) {
        init = builder.makeStructNew(heapType, args);
      } else if (heapType.isArray()) {
        // TODO: for repeated identical values, can use ArrayNew
        init = builder.makeArrayNewFixed(heapType, args);
      } else {
        WASM_UNREACHABLE("bad gc type");
      }

      if (possibleDefiningGlobal.is()) {
        // We didn't need to allocate a new global, as we are in the definition
        // of one, so just return the initialization expression, which will be
        // placed in that global's |init| field.
        return init;
      }

      // There is no existing defining global, so we must allocate a new one.
      //
      // We set the global's init to null temporarily, and we'll fix it up
      // later down after we create the init expression.
      wasm->addGlobal(
        builder.makeGlobal(definingGlobalName, type, init, Builder::Immutable));
    }

    // Refer to this GC allocation by reading from the global that is
    // designated to contain it.
    Expression* ret = builder.makeGlobalGet(definingGlobalName, value.type);
    if (original != value) {
      // The original is externalized.
      assert(original.type.getHeapType() == HeapType::ext);
      ret = builder.makeRefAs(ExternExternalize, ret);
    }
    return ret;
  }

  Expression* getSerialization(const Literals& values,
                               Name possibleDefiningGlobal = Name()) {
    if (values.size() > 1) {
      // We do not support multivalues in defining globals, which store GC refs.
      assert(possibleDefiningGlobal.isNull());
      std::vector<Expression*> children;
      for (const auto& value : values) {
        children.push_back(getSerialization(value));
      }
      return Builder(*wasm).makeTupleMake(children);
    }
    assert(values.size() == 1);
    return getSerialization(values[0], possibleDefiningGlobal);
  }

  // This is called when we hit a cycle in setting up defining globals. For
  // example, if the data we want to emit is
  //
  //    global globalA = new A{ field = &A }; // A has a reference to itself
  //
  // then we'll emit
  //
  //    global globalA = new A{ field = null };
  //
  // and put this in the start function:
  //
  //   globalA.field = globalA;
  //
  // The parameters here are a global and a field index to that global, and the
  // global we want to assign to it, that is, our goal is to have
  //
  //  global[index] = valueGlobal
  //
  // run during the start function.
  void addStartFixup(DefiningGlobalInfo global, Index index, GlobalGet* value) {
    if (!startBlock) {
      createStartBlock();
    }

    Builder builder(*wasm);
    auto* getGlobal = builder.makeGlobalGet(global.name, global.type);

    Expression* set;
    if (global.type.isStruct()) {
      set = builder.makeStructSet(index, getGlobal, value);
    } else {
      set = builder.makeArraySet(
        getGlobal, builder.makeConst(int32_t(index)), value);
    }

    (*startBlock)->list.push_back(set);
  }

  // A block in the start function where we put the operations we need to occur
  // during startup.
  std::optional<Block*> startBlock;

  void createStartBlock() {
    Builder builder(*wasm);
    startBlock = builder.makeBlock();
    if (wasm->start.is()) {
      // Put our block before any user start code.
      auto* existingStart = wasm->getFunction(wasm->start);
      existingStart->body =
        builder.makeSequence(*startBlock, existingStart->body);
    } else {
      // Make a new start function.
      wasm->start = Names::getValidFunctionName(*wasm, "start");
      wasm->addFunction(builder.makeFunction(
        wasm->start, Signature{Type::none, Type::none}, {}, *startBlock));
    }
  }

  void clearStartBlock() {
    if (startBlock) {
      (*startBlock)->list.clear();
    }
  }
};

// Whether to emit informative logging to stdout about the eval process.
static bool quiet = false;

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
  if (func->imported()) {
    // We cannot evaluate an import.
    if (!quiet) {
      std::cout << "  ...stopping since could not eval: call import: "
                << func->module.toString() << "." << func->base.toString()
                << '\n';
    }
    return EvalCtorOutcome();
  }

  // We don't know the values of parameters, so give up if there are any, unless
  // we are ignoring them.
  if (func->getNumParams() > 0 && !ignoreExternalInput) {
    if (!quiet) {
      std::cout << "  ...stopping due to params\n";
      std::cout << RECOMMENDATION "consider --ignore-external-input";
    }
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
      if (!quiet) {
        std::cout << "  ...stopping due to non-zeroable param\n";
      }
      return EvalCtorOutcome();
    }
    params.push_back(Literal::makeZero(type));
  }

  // After we successfully eval a line we will store the operations to set up
  // the locals here. That is, we need to save the local state in the function,
  // which we do by setting up at the entry. We update this list of expressions
  // at the same time as applyToModule() - we must only do it after an entire
  // atomic "chunk" has been processed succesfully, we do not want partial
  // updates from an item in the block that we only partially evalled. When we
  // construct the (partially) evalled function, we will create local.sets of
  // these expressions at the beginning.
  std::vector<Expression*> localExprs;

  // We might have to evaluate multiple functions due to return calls.
start_eval:
  while (true) {
    // We want to handle the form of the global constructor function in LLVM.
    // That looks like this:
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
    // And for now we look for a toplevel block and process its children one at
    // a time. This allows us to eval some of the $ctor.* functions (or their
    // inlined contents) even if not all.
    //
    // TODO: Support complete partial evalling, that is, evaluate parts of an
    //       arbitrary function, and not just a sequence in a single toplevel
    //       block.
    Builder builder(wasm);
    auto* block = builder.blockify(func->body);

    // Go through the items in the block and try to execute them. We do all this
    // in a single function scope for all the executions.
    EvallingModuleRunner::FunctionScope scope(func, params, instance);

    Literals results;
    Index successes = 0;

    for (auto* curr : block->list) {
      Flow flow;
      try {
        flow = instance.visit(curr);
      } catch (FailToEvalException& fail) {
        if (!quiet) {
          if (successes == 0) {
            std::cout << "  ...stopping (in block) since could not eval: "
                      << fail.why << "\n";
          } else {
            std::cout << "  ...partial evalling successful, but stopping since "
                         "could not eval: "
                      << fail.why << "\n";
          }
        }
        break;
      }

      if (flow.breakTo == RETURN_CALL_FLOW) {
        // The return-called function is stored in the last value.
        func = wasm.getFunction(flow.values.back().getFunc());
        flow.values.pop_back();
        params = std::move(flow.values);

        // Serialize the arguments for the new function and save the module
        // state in case we fail to eval the new function.
        localExprs.clear();
        for (auto& param : params) {
          localExprs.push_back(interface.getSerialization(param));
        }
        interface.applyToModule();
        goto start_eval;
      }

      // So far so good! Serialize the values of locals, and apply to the
      // module. Note that we must serialize the locals now as doing so may
      // cause changes that must be applied to the module (e.g. GC data may
      // cause globals to be added). And we must apply to the module now, and
      // not later, as we must do so right after a successfull partial eval
      // (after any failure to eval, the global state is no long valid to be
      // applied to the module, as incomplete changes may have occurred).
      //
      // Note that we make no effort to optimize locals: we just write out all
      // of them, and leave it to the optimizer to remove redundant or
      // unnecessary operations. We just recompute the entire local
      // serialization sets from scratch each time here, for all locals.
      localExprs.clear();
      for (Index i = 0; i < func->getNumLocals(); i++) {
        localExprs.push_back(interface.getSerialization(scope.locals[i]));
      }
      interface.applyToModule();
      successes++;

      // Note the values here, if any. If we are exiting the function now then
      // these will be returned.
      results = flow.values;

      if (flow.breaking()) {
        // We are returning out of the function (either via a return, or via a
        // break to |block|, which has the same outcome. That means we don't
        // need to execute any more lines, and can consider them to be
        // executed.
        if (!quiet) {
          std::cout << "  ...stopping in block due to break\n";
        }

        // Mark us as having succeeded on the entire block, since we have: we
        // are skipping the rest, which means there is no problem there. We
        // must set this here so that lower down we realize that we've evalled
        // everything.
        successes = block->list.size();
        break;
      }
    }

    // If we have not fully evaluated the current function, but we have
    // evaluated part of it, have return-called to a different function, or have
    // precomputed values for the current return-called function, then we can
    // replace the export with a new function that does less work than the
    // original.
    if ((func->imported() || successes < block->list.size()) &&
        (successes > 0 || func->name != funcName ||
         (localExprs.size() && func->getParams() != Type::none))) {
      auto originalFuncType = wasm.getFunction(funcName)->type;
      auto copyName = Names::getValidFunctionName(wasm, funcName);
      wasm.getExport(exportName)->value = copyName;

      if (func->imported()) {
        // We must have return-called this imported function. Generate a new
        // function that return-calls the import with the arguments we have
        // evalled.
        auto copyFunc = builder.makeFunction(
          copyName,
          originalFuncType,
          {},
          builder.makeCall(func->name, localExprs, func->getResults(), true));
        wasm.addFunction(std::move(copyFunc));
        return EvalCtorOutcome();
      }

      // We may have managed to eval some but not all. That means we can't just
      // remove the entire function, but need to keep parts of it - the parts we
      // have not evalled - around. To do so, we create a copy of the function
      // with the partially-evalled contents and make the export use that (as
      // the function may be used in other places than the export, which we do
      // not want to affect).
      auto* copyBody =
        builder.blockify(ExpressionManipulator::copy(func->body, wasm));

      // Remove the items we've evalled.
      for (Index i = 0; i < successes; i++) {
        copyBody->list[i] = builder.makeNop();
      }

      // Put the local sets at the front of the function body.
      auto* setsBlock = builder.makeBlock();
      for (Index i = 0; i < localExprs.size(); ++i) {
        setsBlock->list.push_back(builder.makeLocalSet(i, localExprs[i]));
      }
      copyBody = builder.makeSequence(setsBlock, copyBody, copyBody->type);

      // We may have return-called into a function with different parameter
      // types, but we ultimately need to export a function with the original
      // signature. If there is a mismatch, shift the local indices to make room
      // for the unused parameters.
      std::vector<Type> localTypes;
      auto originalParams = originalFuncType.getSignature().params;
      if (originalParams != func->getParams()) {
        // Add locals for the body to use instead of using the params.
        for (auto type : func->getParams()) {
          localTypes.push_back(type);
        }

        // Shift indices in the body so they will refer to the new locals.
        auto localShift = originalParams.size();
        if (localShift != 0) {
          for (auto* get : FindAll<LocalGet>(copyBody).list) {
            get->index += localShift;
          }
          for (auto* set : FindAll<LocalSet>(copyBody).list) {
            set->index += localShift;
          }
        }
      }

      // Add vars from current function.
      localTypes.insert(localTypes.end(), func->vars.begin(), func->vars.end());

      // Create and add the new function.
      auto* copyFunc = wasm.addFunction(builder.makeFunction(
        copyName, originalFuncType, std::move(localTypes), copyBody));

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
      if (!quiet) {
        std::cout << "trying to eval " << ctor << '\n';
      }
      Export* ex = wasm.getExportOrNull(ctor);
      if (!ex) {
        Fatal() << "export not found: " << ctor;
      }
      auto funcName = ex->value;
      auto outcome = evalCtor(instance, interface, funcName, ctor);
      if (!outcome) {
        if (!quiet) {
          std::cout << "  ...stopping\n";
        }
        return;
      }

      // Success! And we can continue to try more.
      if (!quiet) {
        std::cout << "  ...success on " << ctor << ".\n";
      }

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
    if (!quiet) {
      std::cout << "  ...stopping since could not create module instance: "
                << fail.why << "\n";
    }
    return;
  }
}

static bool canEval(Module& wasm) {
  // Check if we can flatten memory. We need to do so currently because of how
  // we assume memory is simple and flat. TODO
  if (!MemoryUtils::flatten(wasm)) {
    if (!quiet) {
      std::cout << "  ...stopping since could not flatten memory\n";
    }
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
    .add("--quiet",
         "-q",
         "Do not emit verbose logging about the eval process",
         WasmCtorEvalOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { quiet = true; })
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

    if (!WasmValidator().validate(wasm)) {
      std::cout << wasm << '\n';
      Fatal() << "error in validating output";
    }

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
