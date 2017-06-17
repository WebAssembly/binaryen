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

// Calls note() on every import that has form "env".(base)
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

// A mergeable unit. This class contains basic logic to prepare for merging
// of two modules.
struct Mergeable {
  Mergeable(Module& wasm) : wasm(wasm) {
    // scan the module
    findSizes();
    findImports();
    standardizeSegments();
  }

  // The module we are working on
  Module& wasm;

  // Total sizes of the memory and table data, including things
  // link a bump from the dylink section
  Index totalMemorySize, totalTableSize;

  // The names of the imported globals for the memory and table bases
  // (sets, as each may be imported more than once)
  std::set<Name> memoryBaseGlobals, tableBaseGlobals;

  // Imported functions and globals provided by the other mergeable
  // are fused together. We track those here, then remove them
  std::map<Name, Name> implementedFunctionImports;
  std::map<Name, Name> implementedGlobalImports;

  // setups

  // find the memory and table sizes. if there are relocatable sections for them,
  // that is the base size, and a dylink section may increase things further
  void findSizes() {
    totalMemorySize = 0;
    totalTableSize = 0;
    for (auto& segment : wasm.memory.segments) {
      Expression* offset = segment.offset;
      if (offset->is<GetGlobal>()) {
        totalMemorySize = segment.data.size();
        break;
      }
    }
    for (auto& segment : wasm.table.segments) {
      Expression* offset = segment.offset;
      if (offset->is<GetGlobal>()) {
        totalTableSize = segment.data.size();
        break;
      }
    }
    for (auto& section : wasm.userSections) {
      if (section.name == "dylink") {
        WasmBinaryBuilder builder(wasm, section.data, false);
        totalMemorySize = std::max(totalMemorySize, builder.getU32LEB());
        totalTableSize = std::max(totalTableSize, builder.getU32LEB());
        break; // there can be only one
      }
    }
    // align them
    while (totalMemorySize % 16 != 0) totalMemorySize++;
    while (totalTableSize % 2 != 0) totalTableSize++;
  }

  void findImports() {
    findImportsByBase(wasm, MEMORY_BASE, [&](Name name) {
      memoryBaseGlobals.insert(name);
    });
    //if (memoryBaseGlobals.size() == 0) {
    //  Fatal() << "no memory base was imported";
    //}
    findImportsByBase(wasm, TABLE_BASE, [&](Name name) {
      tableBaseGlobals.insert(name);
    });
    //if (tableBaseGlobals.size() == 0) {
    //  Fatal() << "no table base was imported";
    //}
  }

  void standardizeSegments() {
    standardizeSegment<Memory, char, Memory::Segment>(wasm, wasm.memory, totalMemorySize, 0, *memoryBaseGlobals.begin());
    // if there are no functions, and we need one, we need to add one as the zero
    if (totalTableSize > 0 && wasm.functions.empty()) {
      auto func = new Function;
      func->name = Name("binaryen$merge-zero");
      func->body = Builder(wasm).makeNop();
      func->type = ensureFunctionType("v", &wasm)->name;
      wasm.addFunction(func);
    }
    Name zero;
    if (totalTableSize > 0) {
      zero = wasm.functions.begin()->get()->name;
    }
    standardizeSegment<Table, Name, Table::Segment>(wasm, wasm.table, totalTableSize, zero, *tableBaseGlobals.begin());
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

// A mergeable that is an output, that is, that we merge into. This adds
// logic to update it for the new data, namely, when an import is provided
// by the other merged unit, we resolve to access that value directly.
struct OutputMergeable : public PostWalker<OutputMergeable, Visitor<OutputMergeable>>, public Mergeable {
  OutputMergeable(Module& wasm) : Mergeable(wasm) {}

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
      // this global is now in the module - get it
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

// A mergeable that is an input, that is, that we merge into another.
// This adds logic to disambiguate its names from the other, and to
// perform all other merging operations.
struct InputMergeable : public ExpressionStackWalker<InputMergeable, Visitor<InputMergeable>>, public Mergeable {
  InputMergeable(Module& wasm, OutputMergeable& outputMergeable) : Mergeable(wasm), outputMergeable(outputMergeable) {}

  // The unit we are being merged into
  OutputMergeable& outputMergeable;

  // mappings (after disambiguating with the other mergeable), old name => new name
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
    if (curr->name.is()) {
      // if this is the memory or table base, add the bump
      if (memoryBaseGlobals.count(curr->name)) {
        addBump(outputMergeable.totalMemorySize);
      } else if (tableBaseGlobals.count(curr->name)) {
        addBump(outputMergeable.totalTableSize);
      }
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
        for (auto& exp : outputMergeable.wasm.exports) {
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
        return outputMergeable.wasm.getFunctionTypeOrNull(name);
      });
    }
    for (auto& curr : wasm.imports) {
      if (curr->kind == ExternalKind::Function) {
        curr->name = fNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
          return !!outputMergeable.wasm.getImportOrNull(name) || !!outputMergeable.wasm.getFunctionOrNull(name);
        });
      } else if (curr->kind == ExternalKind::Global) {
        curr->name = gNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
          return !!outputMergeable.wasm.getImportOrNull(name) || !!outputMergeable.wasm.getGlobalOrNull(name);
        });
      }
    }
    for (auto& curr : wasm.functions) {
      curr->name = fNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
        return outputMergeable.wasm.getFunctionOrNull(name);
      });
    }
    for (auto& curr : wasm.globals) {
      curr->name = gNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
        return outputMergeable.wasm.getGlobalOrNull(name);
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
    for (auto& imp : outputMergeable.wasm.imports) {
      if ((imp->kind == ExternalKind::Function || imp->kind == ExternalKind::Global) && imp->module == ENV) {
        for (auto& exp : wasm.exports) {
          if (exp->kind == imp->kind && exp->name == imp->base) {
            if (imp->kind == ExternalKind::Function) {
              outputMergeable.implementedFunctionImports[imp->name] = fNames[exp->value];
            } else {
              outputMergeable.implementedGlobalImports[imp->name] = gNames[exp->value];
            }
            break;
          }
        }
      }
    }

    // update the output before bringing anything in. avoid doing so when possible, as in the
    // common case the output module is very large.
    if (outputMergeable.implementedFunctionImports.size() + outputMergeable.implementedGlobalImports.size() > 0) {
      outputMergeable.walkModule(&outputMergeable.wasm);
    }

    // memory&table: we place the new memory segments at a higher position. after the existing ones.
    copySegment(outputMergeable.wasm.memory, wasm.memory, [](char x) -> char { return x; });
    copySegment(outputMergeable.wasm.table, wasm.table, [&](Name x) -> Name { return fNames[x]; });

    // update the new contents about to be merged in
    walkModule(&wasm);

    // handle the dylink post-instantiate. this is special, as if it exists in both, we must in fact call both
    Name POST_INSTANTIATE("__post_instantiate");
    if (fNames.find(POST_INSTANTIATE) != fNames.end() &&
        outputMergeable.wasm.getExportOrNull(POST_INSTANTIATE)) {
      // indeed, both exist. add a call to the second (wasm spec does not give an order requirement)
      auto* func = outputMergeable.wasm.getFunction(outputMergeable.wasm.getExport(POST_INSTANTIATE)->value);
      Builder builder(outputMergeable.wasm);
      func->body = builder.makeSequence(
        builder.makeCall(fNames[POST_INSTANTIATE], {}, none),
        func->body
      );
    }

    // copy in the data
    for (auto& curr : wasm.functionTypes) {
      outputMergeable.wasm.addFunctionType(curr.release());
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
      outputMergeable.wasm.addImport(curr.release());
    }
    for (auto& curr : wasm.exports) {
      if (curr->kind == ExternalKind::Memory || curr->kind == ExternalKind::Table) {
        continue; // wasm has just 1 of each, they must match
      }
      // if an export would collide, do not add the new one, ignore it
      // TODO: warning/error mode?
      if (!outputMergeable.wasm.getExportOrNull(curr->name)) {
        if (curr->kind == ExternalKind::Function) {
          curr->value = fNames[curr->value];
          outputMergeable.wasm.addExport(curr.release());
        } else if (curr->kind == ExternalKind::Global) {
          curr->value = gNames[curr->value];
          outputMergeable.wasm.addExport(curr.release());
        } else {
          WASM_UNREACHABLE();
        }
      }
    }
    for (auto& curr : wasm.functions) {
      curr->type = ftNames[curr->type];
      assert(curr->type.is());
      outputMergeable.wasm.addFunction(curr.release());
    }
    for (auto& curr : wasm.globals) {
      outputMergeable.wasm.addGlobal(curr.release());
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

// Finalize the memory/table bases, assinging concrete values into them
void finalizeBases(Module& wasm, Index memory, Index table) {
  struct FinalizableMergeable : public Mergeable, public PostWalker<FinalizableMergeable, Visitor<FinalizableMergeable>> {
    FinalizableMergeable(Module& wasm, Index memory, Index table) : Mergeable(wasm), memory(memory), table(table) {
      walkModule(&wasm);
      // ensure memory and table sizes suffice, after finalization we have absolute locations now
      for (auto& segment : wasm.memory.segments) {
        ensureSize(wasm.memory, memory + segment.data.size());
      }
      for (auto& segment : wasm.table.segments) {
        ensureSize(wasm.table, table + segment.data.size());
      }
    }

    Index memory, table;

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
  FinalizableMergeable mergeable(wasm, memory, table);
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
  bool verbose = false;

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
      .add("--finalize-table-base", "-ftb", "Finalize the env.tableBase import",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             finalizeTableBase = atoi(argument.c_str());
           })
      .add("-O", "-O", "Perform merge-time/finalize-time optimizations",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             optimize = true;
           })
      .add("--verbose", "-v", "Verbose output",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             verbose = true;
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
      // perform the merge
      OutputMergeable outputMergeable(output);
      InputMergeable inputMergeable(*input, outputMergeable);
      inputMergeable.merge();
      // retain the linked in module as we may depend on parts of it
      otherModules.push_back(std::unique_ptr<Module>(input.release()));
    }
  }

  if (verbose) {
    // memory and table are standardized and merged, so it's easy to dump out some stats
    std::cout << "merged total memory size: " << output.memory.segments[0].data.size() << '\n';
    std::cout << "merged total table size: " << output.table.segments[0].data.size() << '\n';
    std::cout << "merged functions: " << output.functions.size() << '\n';
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
