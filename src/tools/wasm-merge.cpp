/*
 * Copyright 2023 WebAssembly Community Group participants
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
// A WebAssembly merger: loads multiple files, mashes them together, and emits
// the result. Unlike wasm-ld, this does not have the full semantics of native
// linkers. Instead, wasm-merge does at compile time what you can do with JS at
// runtime: connect some wasm modules together by hooking up imports to exports.
// The result of wasm-merge is a single module that behaves the same as the
// multiple original modules, but you don't need that JS to set up the
// connections between the modules any more, and DCE and inlining can help
// inside the module, etc. In other words, wasm-merge is sort of like a wasm
// bundler, where "bundler" means something similar to JS bundlers. (While JS is
// mentioned here a lot, wasm-merge could in principle also be helpful with
// optimizing other ways of connecting modules at compile time instead of
// runtime, like perhaps the component model for wasm that is in development.)
//
// The specific merging model here is to take N wasm modules, each with a given
// name:
//
//   wasm_1, wasm_2, ... , wasm_N
//   name_1, name_2, ... , name_N
//
// We resolve imports and exports using those names as we merge all the code
// into the final module. That is, if wasm_i imports "foo.bar", and wasm_j has
// name name_j == "foo" and it exports a function "bar" then wasm_i's import of
// "foo.bar" will turn into a reference to the proper item from wasm_j that
// corresponds to that export:
//
//  (module "first"
//    (import "foo" "bar" (func $foo.bar))
//    (func $other
//      (call $foo.bar)
//    )
//  )
//
//  (module "foo"
//    (func $f (export "bar")
//      ..
//    )
//  )
//
// => wasm-merge =>
//
//  (module
//    ..
//    (func $other
//      (call $f) ;; call $f directly since "foo.bar" resolved as $f
//    )
//    (func $f
//      ..
//    )
//  )
//
// We call that process "fusing" of imports to exports. Note that we don't
// bother to optimize here - we don't remove either the export or the import,
// even if we fuse - as it is simple to leave that for later optimizations
// (removing unwanted exports can be done using wasm-metadce, see
// https://github.com/WebAssembly/binaryen/wiki/Pruning-unneeded-code-in-wasm-files-with-wasm-metadce#example-pruning-exports
// ).
//
// Note that we allow "forward references" - a reference from an earlier module
// to a later one. If one instantiates the wasm modules in sequence then that is
// impossible to do, and to work around it e.g. emscripten dynamic linking
// support will add a thunk. Note that ES6 modules support such circular imports
// for JS, but they are considered annoying even there; one of the solutions to
// such import loops in JS is to merge the modules together, and similarly
// wasm-merge can help wasm build systems avoid such cycles. (Note that ES6
// module support for *wasm* is not intended to support cycles, unlike JS, and
// so avoiding cycles is important.)
//
// Despite resolving imports and exports without regard for the order of
// modules, the order does matter in one way: if the modules have start
// functions then those are called in the given order of the modules.
//
// wasm-merge works in linear time (linear in the total code in all the linked
// modules). Each input module is traversed once to fix up names before being
// merged, and at the end we traverse the entire merged module once to fuse
// imports and exports.
//

#include "ir/module-utils.h"
#include "ir/names.h"
#include "support/colors.h"
#include "support/file.h"
#include "wasm-builder.h"
#include "wasm-io.h"
#include "wasm-validator.h"
#include "wasm.h"

#include "tool-options.h"

using namespace wasm;

namespace {

// The module we'll merge into. This is a singleton and it is simple to just
// have it as a global rather than pass it around all the time.
Module merged;

// Name conflicts on functions etc. are resolved by renaming things in a way
// that only matters internally. Conflicting export names, however, are
// observable, and so the user must decide how they want wasm-merge to handle
// that.
enum ExportMergeMode {
  // Error on name conflicts. This is the least surprising mode, and the one
  // used by default.
  ErrorOnExportConflicts,
  // Rename conflicting exports. Later exports will get a suffix added to them
  // to make them unique. For example, this is useful if you merge several
  // modules that each have a "main" export, and it's fine if those are renamed
  // to "main", "main_1", "main_2" etc. - you'll decide when to call each of
  // those and do so at the right time.
  RenameExportConflicts,
  // Silently ignore export conflicts, that is, later exports that overlap with
  // previous ones are simply skipped. This can be useful when the first module
  // is the main program, which exports things to the outside, while other
  // modules are libraries of code that only provide things to the main module
  // but not to the outside.
  SkipExportConflicts,
} exportMergeMode = ErrorOnExportConflicts;

// Merging two modules is mostly straightforward: copy the functions etc. of the
// first module into the second, with some renaming to avoid name collisions.
// The only other thing we need to handle is the mapping of imports to exports,
// as explained earlier. The way we handle this is to first combine the modules
// into a single module, then connect imports and imports. To do that we track
// the origin of each export.
//
// For example, in the example from earlier we have this as the second module:
//
//  (module "foo"
//    (func $f (export "bar")
//      ..
//    )
//  )
//
// We will annotate that exported function as being from module "foo", so that
// we can resolve imports to "foo.bar" to it. The ExportInfo data structure
// tracks the extra info we need for exports as we go.
struct ExportInfo {
  // The name of the module this export originally appeared in, as just
  // explained.
  Name moduleName;
  // The name of the export itself, which is the basename (the export will be
  // used as module.base). This is normally just the same as export->name, but
  // we need to stash it here because exports may be renamed when merged in, if
  // there is overlap with the name of another export, and imports refer to the
  // original name.
  Name baseName;
};
std::unordered_map<Export*, ExportInfo> exportModuleMap;

// A map of [kind of thing in the module] to [old name => new name] for things
// of that kind. For example, the NameUpdates for functions is a map of old
// function names to new function names.
using NameUpdates = std::unordered_map<Name, Name>;
using KindNameUpdates = std::unordered_map<ModuleItemKind, NameUpdates>;

// Apply a set of name changes to a module.
void updateNames(Module& wasm, KindNameUpdates& kindNameUpdates) {
  if (kindNameUpdates.empty()) {
    return;
  }

  struct NameMapper
    : public WalkerPass<
        PostWalker<NameMapper, UnifiedExpressionVisitor<NameMapper>>> {
    bool isFunctionParallel() override { return true; }

    std::unique_ptr<Pass> create() override {
      return std::make_unique<NameMapper>(kindNameUpdates);
    }

    KindNameUpdates& kindNameUpdates;

    NameMapper(KindNameUpdates& kindNameUpdates)
      : kindNameUpdates(kindNameUpdates) {}

    void visitExpression(Expression* curr) {
#define DELEGATE_ID curr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_CHILD(id, field)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#define DELEGATE_FIELD_NAME_KIND(id, field, kind)                              \
  if (cast->field.is()) {                                                      \
    mapName(kind, cast->field);                                                \
  }

#include "wasm-delegations-fields.def"
    }

    // Aside from expressions, we have a few other things we need to update at
    // the module scope.
    void mapModuleFields(Module& wasm) {
      for (auto& curr : wasm.exports) {
        mapName(ModuleItemKind(curr->kind), curr->value);
      }
      for (auto& curr : wasm.elementSegments) {
        mapName(ModuleItemKind::Table, curr->table);
      }
      for (auto& curr : wasm.dataSegments) {
        mapName(ModuleItemKind::Memory, curr->memory);
      }

      mapName(ModuleItemKind::Function, wasm.start);
    }

  private:
    Name resolveName(NameUpdates& updates, Name newName, Name oldName) {
      // Iteratively lookup the updated name.
      std::set<Name> visited;
      auto name = newName;
      while (1) {
        auto iter = updates.find(name);
        if (iter == updates.end()) {
          return name;
        }
        if (visited.count(name)) {
          // This is a loop of imports, which means we cannot resolve a useful
          // name. Report an error.
          Fatal() << "wasm-merge: infinite loop of imports on " << oldName;
        }
        visited.insert(name);
        name = iter->second;
      }
    }

    void mapName(ModuleItemKind kind, Name& name) {
      auto iter = kindNameUpdates.find(kind);
      if (iter == kindNameUpdates.end()) {
        return;
      }
      auto& nameUpdates = iter->second;
      auto iter2 = nameUpdates.find(name);
      if (iter2 != nameUpdates.end()) {
        name = resolveName(nameUpdates, iter2->second, name);
      }
    }
  } nameMapper(kindNameUpdates);

  PassRunner runner(&wasm);
  nameMapper.run(&runner, &wasm);
  nameMapper.runOnModuleCode(&runner, &wasm);
  nameMapper.mapModuleFields(wasm);
}

// Scan an input module to find the names of the items it contains, and pick new
// names for them that do not cause conflicts with things already in the merged
// module.
void renameInputItems(Module& input) {
  // Pick the names, and apply them to the items themselves.
  // TODO Add ModuleUtils::iterAll + getValidName(kind, ..)? Then we could
  //      avoid hardcoded loops here, but it's unclear those would help
  //      anywhere else.
  KindNameUpdates kindNameUpdates;

  // Add a mapping of a name to a new name, in a particular kind. If the new
  // name is the same as the old, do nothing.
  auto maybeAdd = [&](ModuleItemKind kind, Name& name, const Name newName) {
    if (newName != name) {
      kindNameUpdates[kind][name] = newName;
      name = newName;
    }
  };

  for (auto& curr : input.functions) {
    auto name = Names::getValidFunctionName(merged, curr->name);
    maybeAdd(ModuleItemKind::Function, curr->name, name);
  }
  for (auto& curr : input.globals) {
    auto name = Names::getValidGlobalName(merged, curr->name);
    maybeAdd(ModuleItemKind::Global, curr->name, name);
  }
  for (auto& curr : input.tags) {
    auto name = Names::getValidTagName(merged, curr->name);
    maybeAdd(ModuleItemKind::Tag, curr->name, name);
  }
  for (auto& curr : input.elementSegments) {
    auto name = Names::getValidElementSegmentName(merged, curr->name);
    maybeAdd(ModuleItemKind::ElementSegment, curr->name, name);
  }
  for (auto& curr : input.memories) {
    auto name = Names::getValidMemoryName(merged, curr->name);
    maybeAdd(ModuleItemKind::Memory, curr->name, name);
  }
  for (auto& curr : input.dataSegments) {
    auto name = Names::getValidDataSegmentName(merged, curr->name);
    maybeAdd(ModuleItemKind::DataSegment, curr->name, name);
  }
  for (auto& curr : input.tables) {
    auto name = Names::getValidTableName(merged, curr->name);
    maybeAdd(ModuleItemKind::Table, curr->name, name);
  }

  // Apply the names to their uses.
  updateNames(input, kindNameUpdates);
}

void copyModuleContents(Module& input, Name inputName) {
  // First, copy the regular module items (functions, globals) etc. which we
  // have proper names for, and can just copy.
  ModuleUtils::copyModuleItems(input, merged);

  // We must handle exports in a special way, as we need to note their origin
  // module as we copy them in (also, they are not importable or exportable, so
  // the ModuleUtils function above does not handle them).
  for (auto& curr : input.exports) {
    auto copy = std::make_unique<Export>(*curr);

    // Note the module origin and original name of this export, for later fusing
    // of imports to exports.
    exportModuleMap[copy.get()] = ExportInfo{inputName, curr->name};

    // An export may already exist with that name, so fix it up.
    copy->name = Names::getValidExportName(merged, copy->name);
    if (copy->name != curr->name) {
      if (exportMergeMode == ErrorOnExportConflicts) {
        Fatal() << "Export name conflict: " << curr->name << " (consider"
                << " --rename-export-conflicts or"
                << " --skip-export-conflicts)\n";
      } else if (exportMergeMode == SkipExportConflicts) {
        // Skip the addExport below us.
        continue;
      }
    }
    // Add the export.
    merged.addExport(std::move(copy));
  }

  // Start functions must be merged.
  if (input.start.is()) {
    if (!merged.start.is()) {
      // No previous start; just refer to the new one.
      merged.start = input.start;
    } else {
      // Merge them, keeping the order. We copy both functions to avoid issues
      // with other references to them, and just call the second one, leaving
      // inlining to the optimizer if that makes sense to do.
      auto copiedOldName =
        Names::getValidFunctionName(merged, "merged.start.old");
      auto copiedNewName =
        Names::getValidFunctionName(merged, "merged.start.new");
      auto* copiedOld = ModuleUtils::copyFunction(
        merged.getFunction(merged.start), merged, copiedOldName);
      ModuleUtils::copyFunction(
        merged.getFunction(input.start), merged, copiedNewName);
      Builder builder(merged);
      copiedOld->body = builder.makeSequence(
        copiedOld->body, builder.makeCall(copiedNewName, {}, Type::none));
      merged.start = copiedOldName;
    }
  }

  // TODO: type names, features, debug info, custom sections, dylink info, etc.
}

void reportTypeMismatch(bool& valid, const char* kind, Importable* import) {
  valid = false;
  std::cerr << "Type mismatch when importing " << kind << " " << import->base
            << " from module " << import->module << " ($" << import->name
            << "): ";
}

// Check that the export and import limits match.
template<typename T>
void checkLimit(bool& valid, const char* kind, T* export_, T* import) {
  if (export_->initial < import->initial) {
    reportTypeMismatch(valid, kind, import);
    std::cerr << "minimal size " << export_->initial
              << " is smaller than expected minimal size " << import->initial
              << ".\n";
  }
  if (import->hasMax()) {
    if (!export_->hasMax()) {
      reportTypeMismatch(valid, kind, import);
      std::cerr << "expecting a bounded " << kind
                << " but the "
                   "imported "
                << kind << " is unbounded.\n";
    } else if (export_->max > import->max) {
      reportTypeMismatch(valid, kind, import);
      std::cerr << "maximal size " << export_->max
                << " is larger than expected maximal size " << import->max
                << ".\n";
    }
  }
}

// Find pairs of matching imports and exports, and make uses of the import refer
// to the exported item (which has been merged into the module).
void fuseImportsAndExports() {
  // First, scan the exports and build a map. We build a map of [module name] to
  // [export name => internal name]. For example, consider this module:
  //
  //  (module "module_A"
  //    (func $foo (export "bar"))
  //  )
  //
  // Then the ModuleExportMap will be:
  //
  //  {
  //    "module_A": {
  //      "bar": "foo";
  //    }
  //  }
  //
  using ModuleExportMap = std::unordered_map<Name, NameUpdates>;

  // A map of ModuleExportMaps, one per item kind (one for functions, one for
  // globals, etc.).
  using KindModuleExportMaps =
    std::unordered_map<ExternalKind, ModuleExportMap>;
  KindModuleExportMaps kindModuleExportMaps;

  for (auto& ex : merged.exports) {
    assert(exportModuleMap.count(ex.get()));
    ExportInfo& exportInfo = exportModuleMap[ex.get()];
    kindModuleExportMaps[ex->kind][exportInfo.moduleName][exportInfo.baseName] =
      ex->value;
  }

  // Find all the imports and see which have corresponding exports, which means
  // there is an internal item we can refer to. We build up a map of the names
  // that we should update.
  KindNameUpdates kindNameUpdates;
  ModuleUtils::iterImportable(merged, [&](ExternalKind kind, Importable* curr) {
    if (curr->imported()) {
      auto internalName = kindModuleExportMaps[kind][curr->module][curr->base];
      if (internalName.is()) {
        // We found something to fuse! Add it to the maps for renaming.
        kindNameUpdates[ModuleItemKind(kind)][curr->name] = internalName;
      }
    }
  });

  // Make sure that the export types match the import types.
  bool valid = true;
  ModuleUtils::iterImportedFunctions(merged, [&](Function* import) {
    auto internalName = kindModuleExportMaps[ExternalKind::Function]
                                            [import->module][import->base];
    if (internalName.is()) {
      auto* export_ = merged.getFunction(internalName);
      if (!HeapType::isSubType(export_->type, import->type)) {
        reportTypeMismatch(valid, "function", import);
        std::cerr << "type " << export_->type << " is not a subtype of "
                  << import->type << ".\n";
      }
    }
  });
  ModuleUtils::iterImportedTables(merged, [&](Table* import) {
    auto internalName =
      kindModuleExportMaps[ExternalKind::Table][import->module][import->base];
    if (internalName.is()) {
      auto* export_ = merged.getTable(internalName);
      checkLimit(valid, "table", export_, import);
      if (export_->type != import->type) {
        reportTypeMismatch(valid, "table", import);
        std::cerr << "export type " << export_->type
                  << " is different from import type " << import->type << ".\n";
      }
    }
  });
  ModuleUtils::iterImportedMemories(merged, [&](Memory* import) {
    auto internalName =
      kindModuleExportMaps[ExternalKind::Memory][import->module][import->base];
    if (internalName.is()) {
      auto* export_ = merged.getMemory(internalName);
      if (export_->is64() != import->is64()) {
        reportTypeMismatch(valid, "memory", import);
        std::cerr << "index type should match.\n";
      }
      checkLimit(valid, "memory", export_, import);
    }
  });
  ModuleUtils::iterImportedGlobals(merged, [&](Global* import) {
    auto internalName =
      kindModuleExportMaps[ExternalKind::Global][import->module][import->base];
    if (internalName.is()) {
      auto* export_ = merged.getGlobal(internalName);
      if (export_->mutable_ != import->mutable_) {
        reportTypeMismatch(valid, "global", import);
        std::cerr << "mutability should match.\n";
      }
      if (export_->mutable_ && export_->type != import->type) {
        reportTypeMismatch(valid, "global", import);
        std::cerr << "export type " << export_->type
                  << " is different from import type " << import->type << ".\n";
      }
      if (!export_->mutable_ && !Type::isSubType(export_->type, import->type)) {
        reportTypeMismatch(valid, "global", import);
        std::cerr << "type " << export_->type << " is not a subtype of "
                  << import->type << ".\n";
      }
    }
  });
  ModuleUtils::iterImportedTags(merged, [&](Tag* import) {
    auto internalName =
      kindModuleExportMaps[ExternalKind::Tag][import->module][import->base];
    if (internalName.is()) {
      auto* export_ = merged.getTag(internalName);
      if (HeapType(export_->sig) != HeapType(import->sig)) {
        reportTypeMismatch(valid, "tag", import);
        std::cerr << "export type " << export_->sig
                  << " is different from import type " << import->sig << ".\n";
      }
    }
  });
  if (!valid) {
    Fatal() << "import/export mismatches";
  }

  // Update the things we found.
  updateNames(merged, kindNameUpdates);
}

// Merges an input module into an existing target module. The input module can
// be modified, as it will no longer be needed (so it is intentionally not
// marked as const here).
void mergeInto(Module& input, Name inputName) {
  // Rename things in the input module so that there are no conflicts with names
  // in the merged module. We do so in place for efficiency.
  renameInputItems(input);

  // The input module's items can now be copied into the target module safely,
  // as names will not conflict.
  copyModuleContents(input, inputName);
}

} // anonymous namespace

int main(int argc, const char* argv[]) {
  std::vector<std::string> inputFiles;
  std::vector<std::string> inputFileNames;
  bool emitBinary = true;
  bool debugInfo = false;
  std::map<size_t, std::string> inputSourceMapFilenames;
  std::string outputSourceMapFilename;
  std::string outputSourceMapUrl;

  const std::string WasmMergeOption = "wasm-merge options";

  ToolOptions options("wasm-merge",
                      R"(Merge wasm files into one.

For example,

  wasm-merge foo.wasm foo bar.wasm bar -o merged.wasm

will read foo.wasm and bar.wasm, with names 'foo' and 'bar' respectively, so if the second imports from 'foo', we will see that as an import from the first module after the merge. The merged output will be written to merged.wasm.

Note that filenames and modules names are interleaved (which is hopefully less confusing).

Input source maps can be specified by adding an -ism option right after the module name:

  wasm-merge foo.wasm foo -ism foo.wasm.map ...)");

  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         WasmMergeOption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::setEnabled(false);
         })
    .add_positional("INFILE1 NAME1 INFILE2 NAME2 [..]",
                    Options::Arguments::N,
                    [&](Options* o, const std::string& argument) {
                      if (inputFiles.size() == inputFileNames.size()) {
                        inputFiles.push_back(argument);
                      } else {
                        inputFileNames.push_back(argument);
                      }
                    })
    .add("--input-source-map",
         "-ism",
         "Consume source maps from the specified files",
         WasmMergeOption,
         Options::Arguments::N,
         [&](Options* o, const std::string& argument) {
           size_t pos = inputFiles.size();
           if (pos == 0 || pos != inputFileNames.size() ||
               inputSourceMapFilenames.count(pos - 1)) {
             std::cerr << "Option '-ism " << argument
                       << "' should be right after the module name\n";
             exit(EXIT_FAILURE);
           }
           inputSourceMapFilenames.insert({pos - 1, argument});
         })
    .add("--output-source-map",
         "-osm",
         "Emit source map to the specified file",
         WasmMergeOption,
         Options::Arguments::One,
         [&outputSourceMapFilename](Options* o, const std::string& argument) {
           outputSourceMapFilename = argument;
         })
    .add("--output-source-map-url",
         "-osu",
         "Emit specified string as source map URL",
         WasmMergeOption,
         Options::Arguments::One,
         [&outputSourceMapUrl](Options* o, const std::string& argument) {
           outputSourceMapUrl = argument;
         })
    .add("--rename-export-conflicts",
         "-rec",
         "Rename exports to avoid conflicts (rather than error)",
         WasmMergeOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           exportMergeMode = RenameExportConflicts;
         })
    .add("--skip-export-conflicts",
         "-sec",
         "Skip exports that conflict with previous ones",
         WasmMergeOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           exportMergeMode = SkipExportConflicts;
         })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file",
         WasmMergeOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { emitBinary = false; })
    .add("--debuginfo",
         "-g",
         "Emit names section and debug info",
         WasmMergeOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { debugInfo = true; });
  options.parse(argc, argv);

  if (inputFiles.size() != inputFileNames.size()) {
    Fatal() << "Please provide an import name for each input file. "
               "In particular, the number of positional inputs must be even as "
               "each wasm binary must be followed by its name.";
  }

  // Process the inputs.
  // TODO: If the inputs are a very large number of small modules then it might
  //       make sense to parallelize this. (If so, then changing the existing
  //       parallelism above in NameMapper might make sense.)

  for (Index i = 0; i < inputFiles.size(); i++) {
    auto inputFile = inputFiles[i];
    auto inputFileName = inputFileNames[i];
    auto iter = inputSourceMapFilenames.find(i);
    auto inputSourceMapFilename =
      (iter == inputSourceMapFilenames.end()) ? "" : iter->second;

    if (options.debug) {
      std::cerr << "reading input '" << inputFile << "' as '" << inputFileName
                << "'...\n";
    }

    // For the first input, we'll just read it in directly. For later inputs,
    // we read them and then merge.
    std::unique_ptr<Module> laterInput;
    Module* currModule;
    if (i == 0) {
      currModule = &merged;
    } else {
      laterInput = std::make_unique<Module>();
      currModule = laterInput.get();
    }

    options.applyFeatures(*currModule);

    ModuleReader reader;
    try {
      reader.read(inputFile, *currModule, inputSourceMapFilename);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing wasm input: " << inputFile;
    }

    if (options.passOptions.validate) {
      if (!WasmValidator().validate(*currModule)) {
        std::cout << *currModule << '\n';
        Fatal() << "error in validating input: " << inputFile;
      }
    }

    if (!laterInput) {
      // This is the very first module, which we read directly into |merged|.
      // The only other operation we need to do is note the exports for later.
      for (auto& curr : merged.exports) {
        exportModuleMap[curr.get()] = ExportInfo{inputFileName, curr->name};
      }
    } else {
      // This is a later module: do a full merge.
      mergeInto(*currModule, inputFileName);

      if (options.passOptions.validate) {
        if (!WasmValidator().validate(merged)) {
          std::cout << merged << '\n';
          Fatal() << "error in validating merged after: " << inputFile;
        }
      }
    }
  }

  // Fuse imports and exports now that everything is all together in the merged
  // module.
  fuseImportsAndExports();

  {
    PassRunner passRunner(&merged);
    // We might have made some globals read from others that now appear after
    // them (if the one they read was appended from a later module). Sort them
    // to fix that. TODO: we could do this only if we actually append globals
    passRunner.add("reorder-globals-always");
    // Remove unused things. This is obviously a useful optimization but it also
    // makes using the output easier: if an import was resolved by an export
    // during the merge, then that import will have no more uses and it will be
    // optimized out (while if we didn't optimize it out then instantiating the
    // module would still be forced to provide something for that import).
    passRunner.add("remove-unused-module-elements");
    passRunner.run();
  }

  // Output.
  if (options.extra.count("output") > 0) {
    ModuleWriter writer;
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    if (outputSourceMapFilename.size()) {
      writer.setSourceMapFilename(outputSourceMapFilename);
      writer.setSourceMapUrl(outputSourceMapUrl);
    }
    writer.write(merged, options.extra["output"]);
  }
}
