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
//  ;; metadata: module wasm_i
//  (module
//    (import "foo" "bar" (func $foo.bar))
//    (func $other
//      (call $foo.bar)
//    )
//  )
//
//  ;; metadata: module wasm_j, which has name "foo"
//  (module
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
// To implement that, we need to track the module origin of exports, which we do
// with the following data structure, which maps Export objects to their info.

//
// Note that we allow "forward references" - a reference from an earlier module
// to a later one. If one instantiates the wasm modules in sequence then that is
// impossible to do, and to work around it e.g. emscripten dynamic linking
// support will add a thunk, but ES module support should allow it for wasm, and
// so we support it here for full generality.
//
// Despite resolving imports and exports without regard for the order of
// modules, the order does matter in one way: if the modules have start
// functions then those are called in the given order of the modules.
//

#include "ir/module-utils.h"
#include "ir/names.h"
#include "support/colors.h"
#include "support/file.h"
#include "wasm-io.h"
#include "wasm-validator.h"
#include "wasm.h"

#include "tool-options.h"

using namespace wasm;

namespace {

// The module we'll merge into. This is a singleton and it is simple to just
// have it as a global rather than pass it around all the time.
Module merged;

// Merging two modules is mostly straightforward: copy the functions etc. of the
// first module into the second, with some renaming to avoid name collisions.
// The only other thing we need to handle is the mapping of imports to exports,
// as explained earlier. The way we handle this is to first combine the modules
// into a single module, then connect imports and imports. To do that we track
// the origin of each export.
//
// For example, in the example from earlier we have this as the second module:
//
//  ;; metadata: module wasm_j, which has name "foo"
//  (module
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
using ExportModuleMap = std::unordered_map<Export*, ExportInfo>;
ExportModuleMap exportModuleMap;

// A map of [kind of thing in the module] to [old name => new name] for things
// of that kind. For example, that NameMap for functions is a map of old
// function names to new function names.
using NameMap = std::unordered_map<Name, Name>;
using KindNameMaps = std::unordered_map<ModuleItemKind, NameMap>;

// Apply a set of name changes to a module.
void updateNames(Module& wasm, KindNameMaps& kindNameMaps) {
  if (kindNameMaps.empty()) {
    return;
  }

  struct NameMapper
    : public WalkerPass<
        PostWalker<NameMapper, UnifiedExpressionVisitor<NameMapper>>> {
    bool isFunctionParallel() override { return true; }

    std::unique_ptr<Pass> create() override {
      return std::make_unique<NameMapper>(kindNameMaps);
    }

    KindNameMaps& kindNameMaps;

    NameMapper(KindNameMaps& kindNameMaps) : kindNameMaps(kindNameMaps) {}

    void visitExpression(Expression* curr) {
#define DELEGATE_ID curr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_CHILD(id, field)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#define DELEGATE_FIELD_NAME_KIND(id, field, kind)                              \
  if (cast->field.is()) {                                                      \
    mapName(kind, cast->field);                                                \
  }

#include "wasm-delegations-fields.def"
    }

    // Aside from expressions, we have a few other things we need to update.
    void mapModuleFields(Module& wasm) {
      for (auto& curr : wasm.exports) {
        mapName(ModuleItemKind(curr->kind), curr->value);
      }

      mapName(ModuleItemKind::Function, wasm.start);
    }

  private:
    void mapName(ModuleItemKind kind, Name& name) {
      auto iter = kindNameMaps[kind].find(name);
      if (iter != kindNameMaps[kind].end()) {
        name = kindNameMaps[kind][name];
      }
    }
  } nameMapper(kindNameMaps);

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
  KindNameMaps kindNameMaps;
  for (auto& curr : input.functions) {
    auto name = Names::getValidFunctionName(merged, curr->name);
    kindNameMaps[ModuleItemKind::Function][curr->name] = name;
    curr->name = name;
  }
  for (auto& curr : input.globals) {
    auto name = Names::getValidGlobalName(merged, curr->name);
    kindNameMaps[ModuleItemKind::Global][curr->name] = name;
    curr->name = name;
  }
  for (auto& curr : input.tags) {
    auto name = Names::getValidTagName(merged, curr->name);
    kindNameMaps[ModuleItemKind::Tag][curr->name] = name;
    curr->name = name;
  }
  for (auto& curr : input.elementSegments) {
    auto name = Names::getValidElementSegmentName(merged, curr->name);
    kindNameMaps[ModuleItemKind::ElementSegment][curr->name] = name;
    curr->name = name;
  }
  for (auto& curr : input.memories) {
    auto name = Names::getValidMemoryName(merged, curr->name);
    kindNameMaps[ModuleItemKind::Memory][curr->name] = name;
    curr->name = name;
  }
  for (auto& curr : input.dataSegments) {
    auto name = Names::getValidDataSegmentName(merged, curr->name);
    kindNameMaps[ModuleItemKind::DataSegment][curr->name] = name;
    curr->name = name;
  }
  for (auto& curr : input.tables) {
    auto name = Names::getValidTableName(merged, curr->name);
    kindNameMaps[ModuleItemKind::Table][curr->name] = name;
    curr->name = name;
  }

  // Apply the names to their uses.
  updateNames(input, kindNameMaps);
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

    // An export may already exist with that name, so fix it up.
    copy->name = Names::getValidExportName(merged, copy->name);

    // Note the module origin of this export, for later fusing of imports to
    // exports.
    exportModuleMap[copy.get()] = ExportInfo{inputName, curr->name};

    // Add the export.
    merged.addExport(std::move(copy));
  }

  // Start functions must be merged.
  if (input.start.is()) {
    if (!merged.start.is()) {
      // No previous start; just refer to the new one.
      merged.start = input.start;
    } else {
      // Merge them, keeping the order. Note that we need to create a new
      // function as they may both have other references.
      auto* oldStart = merged.getFunction(merged.start);
      auto* newStart = merged.getFunction(input.start);
      auto mergedName = Names::getValidFunctionName(merged, "merged.start");
      Builder builder(merged);
      auto* mergedBody = builder.makeSequence(oldStart->body, newStart->body);
      auto mergedFunc = builder.makeFunction(
        mergedName, Signature{Type::none, Type::none}, {}, mergedBody);
      merged.addFunction(std::move(mergedFunc));
      merged.start = mergedName;
    }
  }

  // TODO: type names, features, debug info, custom sections, dylink info, etc.
}

// Finds pairs of matching imports and exports, and makes uses of the import
// refer to the exported item (which has been merged into the module).
void fuseImportsAndExports() {
  // Scan the exports and build a map.

  // A map of module names to (export name => internal name). For example,
  // consider this module:
  //
  //  (module ;; linked in as "module_A"
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
  using ModuleExportMap = std::unordered_map<Name, NameMap>;

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
  // there is an internal item we can refer to.
  KindNameMaps kindNameMaps;
  ModuleUtils::iterImportable(merged, [&](ExternalKind kind, Importable* curr) {
    if (curr->imported()) {
      auto internalName = kindModuleExportMaps[kind][curr->module][curr->base];
      if (internalName.is()) {
        // We found something to fuse! Add it to the maps for renaming.
        auto moduleItemKind = ModuleItemKind(kind);
        kindNameMaps[moduleItemKind][curr->name] = internalName;
      }
    }
  });

  // Update the things we found.
  updateNames(merged, kindNameMaps);
}

// Merges an input module into an existing target module. The input module can
// be modified, as it will no longer be needed (so it is intentionally not
// marked as const here).
void mergeInto(Module& input, Name inputName) {
  // Find the new names we'll use for items in the input.
  renameInputItems(input);

  // Apply the new names in the input module.

  // The input module's items can now be copied into the target module safely.
  copyModuleContents(input, inputName);

  // Connect imports and exports now that everything is all together in the
  // merged module.
  fuseImportsAndExports();
}

} // anonymous namespace

int main(int argc, const char* argv[]) {
  std::vector<std::string> inputFiles;
  std::vector<std::string> inputFileNames;
  bool emitBinary = true;
  bool debugInfo = false;

  const std::string WasmMergeOption = "wasm-merge options";

  ToolOptions options("wasm-merge", R"(Merge wasm files into one.

For example,

  wasm-merge foo.wasm foo bar.wasm bar -o merged.wasm

will read foo.wasm and bar.wasm, with names 'foo' and 'bar' respectively, so if the second imports from 'foo', we will see that as an import from the first module after the merge. The merged output will be written to merged.wasm.

Note that filenames and modules names are interleaved as positional inputs to avoid issues with escaping.)");

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

  bool first = true;
  for (Index i = 0; i < inputFiles.size(); i++) {
    auto inputFile = inputFiles[i];
    auto inputFileName = inputFileNames[i];

    if (options.debug) {
      std::cerr << "reading input '" << inputFile << "' as '" << inputFileName
                << "'...\n";
    }
    // For the first input, we'll just read it in directly. For later inputs,
    // we read them and then merge.
    std::unique_ptr<Module> laterInput;
    Module* currModule;
    if (first) {
      currModule = &merged;
      first = false;
    } else {
      laterInput = std::make_unique<Module>();
      currModule = laterInput.get();
    }

    options.applyFeatures(*currModule);

    ModuleReader reader;
    try {
      reader.read(inputFile, *currModule);
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

  // Output.
  if (options.extra.count("output") > 0) {
    ModuleWriter writer;
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    writer.write(merged, options.extra["output"]);
  }
}
