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
// A WebAssembly merger: loads multiple files, smashes them together,
// and emits the result.
//
// This is *not* a real linker. It just does naive merging.
//

#include <memory>

#include "parsing.h"
#include "pass.h"
#include "shared-constants.h"
#include "asmjs/shared-constants.h"
#include "asm_v_wasm.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-io.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-validator.h"

using namespace wasm;

static void findImportsByBase(Module& wasm, Name base, std::function<void (Name)> note) {
  for (auto& curr : wasm.imports) {
    if (curr->module == ENV) {
      if (curr->base == base) {
        note(curr->name);
      }
    }
  }
}

// Ensure a memory or table is of at least a size
template<typename T>
static void ensureSize(T& what, Index size) {
  // ensure the size is sufficient
  while (what.initial * what.kPageSize < size) {
    what.initial = what.initial + 1;
  }
  what.max = std::max(what.initial, what.max);
}

struct Mergeable {
  Mergeable(Module& wasm) : wasm(wasm) {
    // scan the module
    findBumps();
    findImports();
    standardizeSegments();
  }

  // The module we are working on
  Module& wasm;

  // Total sizes of the memory and table data, including everything
  Index memoryBaseBump, tableBaseBump;

  // The names of the imported globals for the memory and table bases
  // (sets, as each may be imported more than once)
  std::set<Name> memoryBaseGlobals, tableBaseGlobals;

  // Imported functions and globals provided by the other mergeable
  // are fused together. We track those here, then remove them
  std::map<Name, Name> implementedFunctionImports;
  std::map<Name, Name> implementedGlobalImports;

  // setups

  // find the memory and table bumps. if there are relocatable sections for them,
  // that is the base size, and a dylink section may increase things further
  void findBumps() {
    memoryBaseBump = 0;
    tableBaseBump = 0;
    for (auto& segment : wasm.memory.segments) {
      Expression* offset = segment.offset;
      if (offset->is<GetGlobal>()) {
        memoryBaseBump = segment.data.size();
        break;
      }
    }
    for (auto& segment : wasm.table.segments) {
      Expression* offset = segment.offset;
      if (offset->is<GetGlobal>()) {
        tableBaseBump = segment.data.size();
        break;
      }
    }
    for (auto& section : wasm.userSections) {
      if (section.name == "dylink") {
        WasmBinaryBuilder builder(wasm, section.data, false);
        memoryBaseBump = std::max(memoryBaseBump, builder.getU32LEB());
        tableBaseBump = std::max(tableBaseBump, builder.getU32LEB());
        break; // there can be only one
      }
    }
    // align them
    while (memoryBaseBump % 16 != 0) memoryBaseBump++;
    while (tableBaseBump % 2 != 0) tableBaseBump++;
  }

  void findImports() {
    findImportsByBase(wasm, MEMORY_BASE, [&](Name name) {
      memoryBaseGlobals.insert(name);
    });
    if (memoryBaseGlobals.size() == 0) {
      Fatal() << "no memory base was imported";
    }
    findImportsByBase(wasm, TABLE_BASE, [&](Name name) {
      tableBaseGlobals.insert(name);
    });
    if (tableBaseGlobals.size() == 0) {
      Fatal() << "no table base was imported";
    }
  }

  void standardizeSegments() {
    standardizeSegment<Memory, char, Memory::Segment>(wasm, wasm.memory, memoryBaseBump, 0, *memoryBaseGlobals.begin());
    // if there are no functions, we need to add one as the zero
    if (wasm.functions.empty()) {
      auto func = new Function;
      func->name = Name("binaryen$merge-zero");
      func->body = Builder(wasm).makeNop();
      func->type = ensureFunctionType("v", &wasm)->name;
      wasm.addFunction(func);
    }
    Name zero = wasm.functions.begin()->get()->name;
    standardizeSegment<Table, Name, Table::Segment>(wasm, wasm.table, tableBaseBump, zero, *tableBaseGlobals.begin());
  }

  // utilities

  Name getNonColliding(Name initial, std::function<bool (Name)> checkIfCollides) {
    if (!checkIfCollides(initial)) {
      return initial;
    }
    int x = 0;
    while (1) {
      auto curr = Name(std::string(initial.str) + '$' + std::to_string(x));
      if (!checkIfCollides(curr)) {
        return curr;
      }
      x++;
    }
  }

  // ensure a relocatable segment exists, of the proper size, including
  // the dylink bump applied into it, standardized into the form of
  // not using a dylink section and instead having enough zeros at
  // the end. this makes linking much simpler.
  template<typename T, typename U, typename Segment>
  void standardizeSegment(Module& wasm, T& what, Index size, U zero, Name globalName) {
    Segment* relocatable = nullptr;
    for (auto& segment : what.segments) {
      Expression* offset = segment.offset;
      if (offset->is<GetGlobal>()) {
        // this is the relocatable one.
        relocatable = &segment;
        break;
      }
    }
    if (!relocatable) {
      // none existing, add one
      what.segments.resize(what.segments.size() + 1);
      relocatable = &what.segments.back();
      relocatable->offset = Builder(wasm).makeGetGlobal(globalName, i32);
    }
    // make sure it is the right size
    while (relocatable->data.size() < size) {
      relocatable->data.push_back(zero);
    }
    ensureSize(what, relocatable->data.size());
  }

  // copies a relocatable segment from the input to the output
  template<typename T, typename V>
  void copySegment(T& output, T& input, V updater) {
    for (auto& inputSegment : input.segments) {
      Expression* inputOffset = inputSegment.offset;
      if (inputOffset->is<GetGlobal>()) {
        // this is the relocatable one. find the output's relocatable
        for (auto& segment : output.segments) {
          Expression* offset = segment.offset;
          if (offset->is<GetGlobal>()) {
            // copy our data in
            for (auto item : inputSegment.data) {
              segment.data.push_back(updater(item));
            }
            ensureSize(output, segment.data.size());
            return; // there can be only one
          }
        }
        WASM_UNREACHABLE(); // we must find a relocatable one in the output, as we standardized
      }
    }
  }
};

// Merges input into output.
// May destructively modify input, we don't expect to use it later
// We don't copy into the new module, we assume both stay alive forever
void mergeIn(Module& output, Module& input) {
  struct OutputUpdater : public PostWalker<OutputUpdater, Visitor<OutputUpdater>>, public Mergeable {
    OutputUpdater(Module& wasm) : Mergeable(wasm) {}

    void visitCallImport(CallImport* curr) {
      auto iter = implementedFunctionImports.find(curr->target);
      if (iter != implementedFunctionImports.end()) {
        // this import is now in the module - call it
        replaceCurrent(Builder(*getModule()).makeCall(iter->second, curr->operands, curr->type));
      }
    }

    void visitGetGlobal(GetGlobal* curr) {
      auto iter = implementedGlobalImports.find(curr->name);
      if (iter != implementedGlobalImports.end()) {
        curr->name = iter->second;
        assert(curr->name.is());
      }
    }

    void visitModule(Module* curr) {
      // remove imports that are being implemented
      for (auto& pair : implementedFunctionImports) {
        curr->removeImport(pair.first);
      }
      for (auto& pair : implementedGlobalImports) {
        curr->removeImport(pair.first);
      }
    }
  };
  OutputUpdater outputUpdater(output);

  struct InputUpdater : public ExpressionStackWalker<InputUpdater, Visitor<InputUpdater>>, public Mergeable {
    InputUpdater(Module& wasm, OutputUpdater& outputUpdater) : Mergeable(wasm), outputUpdater(outputUpdater) {}

    OutputUpdater& outputUpdater;

    // mappings, old name => new name
    std::map<Name, Name> ftNames; // function types
    std::map<Name, Name> eNames; // exports
    std::map<Name, Name> fNames; // functions
    std::map<Name, Name> gNames; // globals

    void visitCall(Call* curr) {
      curr->target = fNames[curr->target];
      assert(curr->target.is());
    }

    void visitCallImport(CallImport* curr) {
      auto iter = implementedFunctionImports.find(curr->target);
      if (iter != implementedFunctionImports.end()) {
        // this import is now in the module - call it
        replaceCurrent(Builder(*getModule()).makeCall(iter->second, curr->operands, curr->type));
        return;
      }
      curr->target = fNames[curr->target];
      assert(curr->target.is());
    }

    void visitCallIndirect(CallIndirect* curr) {
      curr->fullType = ftNames[curr->fullType];
      assert(curr->fullType.is());
    }

    void visitGetGlobal(GetGlobal* curr) {
      auto iter = implementedGlobalImports.find(curr->name);
      if (iter != implementedGlobalImports.end()) {
        // this import is now in the module - use it
        curr->name = iter->second;
        return;
      }
      curr->name = gNames[curr->name];
      assert(curr->name.is());
      // if this is the memory or table base, add the bump
      if (memoryBaseGlobals.count(curr->name)) {
        addBump(outputUpdater.memoryBaseBump);
      } else if (tableBaseGlobals.count(curr->name)) {
        addBump(outputUpdater.tableBaseBump);
      }
    }

    void visitSetGlobal(SetGlobal* curr) {
      curr->name = gNames[curr->name];
      assert(curr->name.is());
    }

    void merge() {
      // find function imports in us that are implemented in the output
      // TODO make maps, avoid N^2
      for (auto& imp : wasm.imports) {
        // per wasm dynamic library rules, we expect to see exports on 'env'
        if ((imp->kind == ExternalKind::Function || imp->kind == ExternalKind::Global) && imp->module == ENV) {
          // seek an export on the other side that matches
          for (auto& exp : outputUpdater.wasm.exports) {
            if (exp->kind == imp->kind && exp->name == imp->base) {
              // fits!
              if (imp->kind == ExternalKind::Function) {
                implementedFunctionImports[imp->name] = exp->value;
              } else {
                implementedGlobalImports[imp->name] = exp->value;
              }
              break;
            }
          }
        }
      }
      // remove the unneeded ones
      for (auto& pair : implementedFunctionImports) {
        wasm.removeImport(pair.first);
      }
      for (auto& pair : implementedGlobalImports) {
        wasm.removeImport(pair.first);
      }

      // find new names
      for (auto& curr : wasm.functionTypes) {
        curr->name = ftNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
          return outputUpdater.wasm.getFunctionTypeOrNull(name);
        });
      }
      for (auto& curr : wasm.imports) {
        if (curr->kind == ExternalKind::Function) {
          curr->name = fNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
            return !!outputUpdater.wasm.getImportOrNull(name) || !!outputUpdater.wasm.getFunctionOrNull(name);
          });
        } else if (curr->kind == ExternalKind::Global) {
          curr->name = gNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
            return !!outputUpdater.wasm.getImportOrNull(name) || !!outputUpdater.wasm.getGlobalOrNull(name);
          });
        }
      }
      for (auto& curr : wasm.functions) {
        curr->name = fNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
          return outputUpdater.wasm.getFunctionOrNull(name);
        });
      }
      for (auto& curr : wasm.globals) {
        curr->name = gNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
          return outputUpdater.wasm.getGlobalOrNull(name);
        });
      }

      // update global names in input
      {
        auto temp = memoryBaseGlobals;
        memoryBaseGlobals.clear();
        for (auto x : temp) {
          memoryBaseGlobals.insert(gNames[x]);
        }
      }
      {
        auto temp = tableBaseGlobals;
        tableBaseGlobals.clear();
        for (auto x : temp) {
          tableBaseGlobals.insert(gNames[x]);
        }
      }

      // find function imports in output that are implemented in the input
      for (auto& imp : outputUpdater.wasm.imports) {
        if ((imp->kind == ExternalKind::Function || imp->kind == ExternalKind::Global) && imp->module == ENV) {
          for (auto& exp : wasm.exports) {
            if (exp->kind == imp->kind && exp->name == imp->base) {
              if (imp->kind == ExternalKind::Function) {
                outputUpdater.implementedFunctionImports[imp->name] = fNames[exp->value];
              } else {
                outputUpdater.implementedGlobalImports[imp->name] = gNames[exp->value];
              }
              break;
            }
          }
        }
      }

      // update the output before bringing anything in. avoid doing so when possible, as in the
      // common case the output module is very large.
      if (outputUpdater.implementedFunctionImports.size() + outputUpdater.implementedGlobalImports.size() > 0) {
        outputUpdater.walkModule(&outputUpdater.wasm);
      }

      // memory&table: we place the new memory segments at a higher position. after the existing ones.
      // that means we need to update usage of gb, which we did earlier.
      // for now, wasm has no base+offset for segments, just a base, so there is 1 relocatable
      // segment at most.
      copySegment(outputUpdater.wasm.memory, wasm.memory, [](char x) -> char { return x; });
      // if no functions, even imported, then nothing to do (and no zero element anyhow)
      copySegment(outputUpdater.wasm.table, wasm.table, [&](Name x) -> Name { return fNames[x]; });

      // update the new contents about to be merged in
      walkModule(&wasm);

      // handle post-instantiate. this is special, as if it exists in both, we must in fact call both
      Name POST_INSTANTIATE("__post_instantiate");
      if (fNames.find(POST_INSTANTIATE) != fNames.end() &&
          outputUpdater.wasm.getExportOrNull(POST_INSTANTIATE)) {
        // indeed, both exist. add a call to the second (wasm spec does not give an order requirement)
        auto* func = outputUpdater.wasm.getFunction(outputUpdater.wasm.getExport(POST_INSTANTIATE)->value);
        Builder builder(outputUpdater.wasm);
        func->body = builder.makeSequence(
          builder.makeCall(fNames[POST_INSTANTIATE], {}, none),
          func->body
        );
      }

      // copy in the data
      for (auto& curr : wasm.functionTypes) {
        outputUpdater.wasm.addFunctionType(curr.release());
      }
      for (auto& curr : wasm.imports) {
        if (curr->kind == ExternalKind::Memory || curr->kind == ExternalKind::Table) {
          continue; // wasm has just 1 of each, they must match
        }
        // update and add
        if (curr->functionType.is()) {
          curr->functionType = ftNames[curr->functionType];
          assert(curr->functionType.is());
        }
        outputUpdater.wasm.addImport(curr.release());
      }
      for (auto& curr : wasm.exports) {
        if (curr->kind == ExternalKind::Memory || curr->kind == ExternalKind::Table) {
          continue; // wasm has just 1 of each, they must match
        }
        // if an export would collide, do not add the new one, ignore it
        // TODO: warning/error mode?
        if (!outputUpdater.wasm.getExportOrNull(curr->name)) {
          if (curr->kind == ExternalKind::Function) {
            curr->value = fNames[curr->value];
            outputUpdater.wasm.addExport(curr.release());
          } else if (curr->kind == ExternalKind::Global) {
            curr->value = gNames[curr->value];
            outputUpdater.wasm.addExport(curr.release());
          } else {
            WASM_UNREACHABLE();
          }
        }
      }
      for (auto& curr : wasm.functions) {
        curr->type = ftNames[curr->type];
        assert(curr->type.is());
        outputUpdater.wasm.addFunction(curr.release());
      }
      for (auto& curr : wasm.globals) {
        outputUpdater.wasm.addGlobal(curr.release());
      }
    }

  private:
    // add an offset to a get_global. we look above, and if there is already an add,
    // we can add into it, avoiding creating a new node
    void addBump(Index bump) {
      if (expressionStack.size() >= 2) {
        auto* parent = expressionStack[expressionStack.size() - 2];
        if (auto* binary = parent->dynCast<Binary>()) {
          if (binary->op == AddInt32) {
            if (auto* num = binary->right->dynCast<Const>()) {
              num->value = num->value.add(Literal(bump));
              return;
            }
          }
        }
      }
      Builder builder(*getModule());
      replaceCurrent(
        builder.makeBinary(
          AddInt32,
          expressionStack.back(),
          builder.makeConst(Literal(int32_t(bump)))
        )
      );
    }
  };
  InputUpdater inputUpdater(input, outputUpdater);

  inputUpdater.merge();
}

// Finalize the memory/table bases, assinging concrete values into them
void finalizeBases(Module& wasm, Index memory, Index table) {
  struct Updater : public PostWalker<Updater, Visitor<Updater>> {
    Index memory, table;

    std::set<Name> memoryBaseGlobals,
                   tableBaseGlobals;

    void visitGetGlobal(GetGlobal* curr) {
      if (memory != Index(-1) && memoryBaseGlobals.count(curr->name)) {
        finalize(memory);
      } else if (table != Index(-1) && tableBaseGlobals.count(curr->name)) {
        finalize(table);
      }
    }

  private:
    void finalize(Index value) {
      replaceCurrent(Builder(*getModule()).makeConst(Literal(int32_t(value))));
    }
  };
  Updater updater;
  updater.memory = memory;
  updater.table = table;
  findImportsByBase(wasm, MEMORY_BASE, [&](Name name) {
    updater.memoryBaseGlobals.insert(name);
  });
  findImportsByBase(wasm, TABLE_BASE, [&](Name name) {
    updater.tableBaseGlobals.insert(name);
  });
  updater.walkModule(&wasm);
  // ensure memory and table sizes suffice
  for (auto& segment : wasm.memory.segments) {
    ensureSize(wasm.memory, memory + segment.data.size());
  }
  for (auto& segment : wasm.table.segments) {
    ensureSize(wasm.table, table + segment.data.size());
  }
}

//
// main
//

int main(int argc, const char* argv[]) {
  std::vector<std::string> filenames;
  bool emitBinary = true;
  Index finalizeMemoryBase = Index(-1),
        finalizeTableBase = Index(-1);
  bool optimize = false;

  Options options("wasm-merge", "Merge wasm files");
  options
      .add("--output", "-o", "Output file",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--emit-text", "-S", "Emit text instead of binary for the output file",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &argument) { emitBinary = false; })
      .add("--finalize-memory-base", "-fmb", "Finalize the env.memoryBase import",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             finalizeMemoryBase = atoi(argument.c_str());
           })
      .add("--finalize-table-base", "-fmb", "Finalize the env.tableBase import",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             finalizeTableBase = atoi(argument.c_str());
           })
      .add("-O", "-O", "Perform merge-time/finalize-time optimizations",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             optimize = true;
           })
      .add_positional("INFILES", Options::Arguments::N,
                      [&](Options *o, const std::string &argument) {
                        filenames.push_back(argument);
                      });
  options.parse(argc, argv);

  Module output;
  std::vector<std::unique_ptr<Module>> otherModules; // keep all inputs alive, to save copies
  bool first = true;
  for (auto& filename : filenames) {
    ModuleReader reader;
    if (first) {
      // read the first right into output, don't waste time merging into an empty module
      try {
        reader.read(filename, output);
      } catch (ParseException& p) {
        p.dump(std::cerr);
        Fatal() << "error in parsing input";
      }
      first = false;
    } else {
      std::unique_ptr<Module> input = wasm::make_unique<Module>();
      try {
        reader.read(filename, *input);
      } catch (ParseException& p) {
        p.dump(std::cerr);
        Fatal() << "error in parsing input";
      }
      mergeIn(output, *input);
      otherModules.push_back(std::unique_ptr<Module>(input.release()));
    }
  }

  if (finalizeMemoryBase != Index(-1) || finalizeTableBase != Index(-1)) {
    finalizeBases(output, finalizeMemoryBase, finalizeTableBase);
  }

  if (optimize) {
    // merge-time/finalize-time optimization
    // it is beneficial to do global optimizations, as well as precomputing to get rid of finalized constants
    PassRunner passRunner(&output);
    passRunner.add("precompute");
    passRunner.add("optimize-instructions"); // things now-constant may be further optimized
    passRunner.addDefaultGlobalOptimizationPasses();
    passRunner.run();
  }

  if (!WasmValidator().validate(output)) {
    Fatal() << "error in validating output";
  }

  if (options.extra.count("output") > 0) {
    ModuleWriter writer;
    writer.setDebug(options.debug);
    writer.setBinary(emitBinary);
    writer.write(output, options.extra["output"]);
  }
}
