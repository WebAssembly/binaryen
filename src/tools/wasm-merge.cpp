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
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-io.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-validator.h"

using namespace wasm;

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

// find the memory and table bumps. if there are relocatable sections for them,
// that is the base size, and a dylink section may increase things further
void findBumps(Module& wasm, Index& memoryBaseBump, Index& tableBaseBump) {
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

void findImportsByBase(Module& wasm, Name base, std::function<void (Name)> note) {
  for (auto& curr : wasm.imports) {
    if (curr->module == ENV) {
      if (curr->base == base) {
        note(curr->name);
      }
    }
  }
}

// ensure a relocatable segment exists, of the proper size, including
// the dylink bump applied into it (as we are dropping dylink sections)
// if we create a new segment, we need to know the import global to use in the offset.
template<typename T, typename U, typename Segment>
void ensureSegment(Module& wasm, T& what, Index size, U zero, Name globalName) {
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
          return; // there can be only one
        }
      }
      WASM_UNREACHABLE(); // we must find a relocatable one in the output
    }
  }
}

// Merges input into output.
// May destructively modify input, we don't expect to use it later
// We don't copy into the new module, we assume both stay alive forever
void mergeIn(Module& output, Module& input) {
  struct InputUpdater : public ExpressionStackWalker<InputUpdater, Visitor<InputUpdater>> {
    // mappings, old name => new name
    std::map<Name, Name> ftNames; // function types
    std::map<Name, Name> eNames; // exports
    std::map<Name, Name> fNames; // functions
    std::map<Name, Name> gNames; // globals

    // An import of something provided on the other side becomes a direct usage
    std::map<Name, Name> implementedFunctionImports;
    std::map<Name, Name> implementedGlobalImports;

    // memory and table base are imported into these globals
    std::set<Name> memoryBaseGlobals,
                   tableBaseGlobals;

    // memory base and table base bumps
    Index memoryBaseBump = 0,
          tableBaseBump = 0;

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
        addBump(memoryBaseBump);
      } else if (tableBaseGlobals.count(curr->name)) {
        addBump(tableBaseBump);
      }
    }

    void visitSetGlobal(SetGlobal* curr) {
      curr->name = gNames[curr->name];
      assert(curr->name.is());
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
  InputUpdater inputUpdater;

  struct OutputUpdater : public PostWalker<OutputUpdater, Visitor<OutputUpdater>> {
    // An import of something provided on the other side becomes a direct usage
    std::map<Name, Name> implementedFunctionImports;
    std::map<Name, Name> implementedGlobalImports;

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
  OutputUpdater outputUpdater;

  // find imports in the modules for the relocatable bases
  Name outputMemoryBase, outputTableBase;
  findImportsByBase(output, MEMORY_BASE, [&](Name name) {
    outputMemoryBase = name;
  });
  findImportsByBase(output, TABLE_BASE, [&](Name name) {
    outputTableBase = name;
  });
  Name inputMemoryBase, inputTableBase;
  findImportsByBase(input, MEMORY_BASE, [&](Name name) {
    inputMemoryBase = name;
  });
  findImportsByBase(input, TABLE_BASE, [&](Name name) {
    inputTableBase = name;
  });

  // find function imports in input that are implemented in the output
  // TODO make maps, avoid N^2
  for (auto& imp : input.imports) {
    // per wasm dynamic library rules, we expect to see exports on 'env'
    if ((imp->kind == ExternalKind::Function || imp->kind == ExternalKind::Global) && imp->module == ENV) {
      // seek an export on the other side that matches
      for (auto& exp : output.exports) {
        if (exp->kind == imp->kind && exp->name == imp->base) {
          // fits!
          if (imp->kind == ExternalKind::Function) {
            inputUpdater.implementedFunctionImports[imp->name] = exp->value;
          } else {
            inputUpdater.implementedGlobalImports[imp->name] = exp->value;
          }
          break;
        }
      }
    }
  }
  // remove the unneeded ones
  for (auto& pair : inputUpdater.implementedFunctionImports) {
    input.removeImport(pair.first);
  }
  for (auto& pair : inputUpdater.implementedGlobalImports) {
    input.removeImport(pair.first);
  }

  // find new names
  for (auto& curr : input.functionTypes) {
    curr->name = inputUpdater.ftNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
      return output.getFunctionTypeOrNull(name);
    });
  }
  for (auto& curr : input.imports) {
    if (curr->kind == ExternalKind::Function) {
      curr->name = inputUpdater.fNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
        return !!output.getImportOrNull(name) || !!output.getFunctionOrNull(name);
      });
    } else if (curr->kind == ExternalKind::Global) {
      curr->name = inputUpdater.gNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
        return !!output.getImportOrNull(name) || !!output.getGlobalOrNull(name);
      });
    }
  }
  for (auto& curr : input.functions) {
    curr->name = inputUpdater.fNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
      return output.getFunctionOrNull(name);
    });
  }
  for (auto& curr : input.globals) {
    curr->name = inputUpdater.gNames[curr->name] = getNonColliding(curr->name, [&](Name name) -> bool {
      return output.getGlobalOrNull(name);
    });
  }

  // find function imports in output that are implemented in the input
  for (auto& imp : output.imports) {
    if ((imp->kind == ExternalKind::Function || imp->kind == ExternalKind::Global) && imp->module == ENV) {
      for (auto& exp : input.exports) {
        if (exp->kind == imp->kind && exp->name == imp->base) {
          if (imp->kind == ExternalKind::Function) {
            outputUpdater.implementedFunctionImports[imp->name] = inputUpdater.fNames[exp->value];
          } else {
            outputUpdater.implementedGlobalImports[imp->name] = inputUpdater.gNames[exp->value];
          }
          break;
        }
      }
    }
  }

  // update the output before bringing anything in. avoid doing so when possible, as in the
  // common case the output module is very large.
  if (outputUpdater.implementedFunctionImports.size() + outputUpdater.implementedGlobalImports.size() > 0) {
    outputUpdater.walkModule(&output);
  }

  // Find input memory bumps. if the exist, we must have output segments to copy them into
  Index inputMemoryBump = 0, inputTableBump = 0;
  findBumps(input, inputMemoryBump, inputTableBump);

  // output memory and table sizes may increase the bump we need for the input
  findBumps(output, inputUpdater.memoryBaseBump, inputUpdater.tableBaseBump);
  // ensure relocatable segments in the output for us to write to
  if (inputUpdater.memoryBaseBump > 0 || inputMemoryBump > 0) {
    ensureSegment<Memory, char, Memory::Segment>(output, output.memory, inputUpdater.memoryBaseBump, 0, outputMemoryBase);
  }
  if ((inputUpdater.tableBaseBump > 0 || inputTableBump > 0) && inputUpdater.fNames.size() > 0) {
    ensureSegment<Table, Name, Table::Segment>(output, output.table, inputUpdater.tableBaseBump, inputUpdater.fNames.begin()->second, outputTableBase);
  }

  // read the input dylink section too, as we currently don't emit a dylink section,
  // we just add zeros
  if (inputMemoryBump > 0) {
    ensureSegment<Memory, char, Memory::Segment>(input, input.memory, inputMemoryBump, 0, inputMemoryBase);
  }
  if (inputTableBump > 0 && inputUpdater.fNames.size() > 0) {
    ensureSegment<Table, Name, Table::Segment>(input, input.table, inputTableBump, inputUpdater.fNames.begin()->first, inputTableBase);
  }

  // memory&table: we place the new memory segments at a higher position. after the existing ones.
  // that means we need to update usage of gb, which we did earlier.
  // for now, wasm has no base+offset for segments, just a base, so there is 1 relocatable
  // segment at most.
  copySegment(output.memory, input.memory, [](char x) -> char { return x; });
  // if no functions, even imported, then nothing to do (and no zero element anyhow)
  copySegment(output.table, input.table, [&](Name x) -> Name { return inputUpdater.fNames[x]; });

  // find the memory/table base globals, so we know how to update them
  findImportsByBase(input, MEMORY_BASE, [&](Name name) {
    inputUpdater.memoryBaseGlobals.insert(name);
  });
  findImportsByBase(input, TABLE_BASE, [&](Name name) {
    inputUpdater.tableBaseGlobals.insert(name);
  });

  // update the new contents about to be merged in
  inputUpdater.walkModule(&input);

  // handle post-instantiate. this is special, as if it exists in both, we must in fact call both
  Name POST_INSTANTIATE("__post_instantiate");
  if (inputUpdater.fNames.find(POST_INSTANTIATE) != inputUpdater.fNames.end() &&
      output.getExportOrNull(POST_INSTANTIATE)) {
    // indeed, both exist. add a call to the second (wasm spec does not give an order requirement)
    auto* func = output.getFunction(output.getExport(POST_INSTANTIATE)->value);
    Builder builder(output);
    func->body = builder.makeSequence(
      builder.makeCall(inputUpdater.fNames[POST_INSTANTIATE], {}, none),
      func->body
    );
  }

  // copy in the data
  for (auto& curr : input.functionTypes) {
    output.addFunctionType(curr.release());
  }
  for (auto& curr : input.imports) {
    if (curr->kind == ExternalKind::Memory || curr->kind == ExternalKind::Table) {
      continue; // wasm has just 1 of each, they must match
    }
    // update and add
    if (curr->functionType.is()) {
      curr->functionType = inputUpdater.ftNames[curr->functionType];
      assert(curr->functionType.is());
    }
    output.addImport(curr.release());
  }
  for (auto& curr : input.exports) {
    if (curr->kind == ExternalKind::Memory || curr->kind == ExternalKind::Table) {
      continue; // wasm has just 1 of each, they must match
    }
    // if an export would collide, do not add the new one, ignore it
    // TODO: warning/error mode?
    if (!output.getExportOrNull(curr->name)) {
      if (curr->kind == ExternalKind::Function) {
        curr->value = inputUpdater.fNames[curr->value];
        output.addExport(curr.release());
      } else if (curr->kind == ExternalKind::Global) {
        curr->value = inputUpdater.gNames[curr->value];
        output.addExport(curr.release());
      } else {
        WASM_UNREACHABLE();
      }
    }
  }
  for (auto& curr : input.functions) {
    curr->type = inputUpdater.ftNames[curr->type];
    assert(curr->type.is());
    output.addFunction(curr.release());
  }
  for (auto& curr : input.globals) {
    output.addGlobal(curr.release());
  }
}

// Finalize the memory/table bases
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
