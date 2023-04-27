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
// A WebAssembly merger: loads multiple files, mashes them together, and emits
// the result. Unlike wasm-ld, this does not have the full semantics of native
// linkers. Instead, wasm-merge does at compile time what you can do with JS at
// runtime: connect some wasm modules together by hooking up imports to exports.
// The result of wasm-merge is a single module that behaves the same as the
// multiple original modules, but you don't need that JS to set up the
// connections between the modules any more, and DCE and inlining can help
// inside the module, etc. In other words, wasm-merge is sort of like a wasm
// bundler, where "bundler" means something similar to JS bundlers. (While JS is
// mentioned here a lot, wasm-merge could also be helpful with the component
// model for wasm that is in development.)
//
// The specific merging model here is to take N wasm modules, each with a given
// name:
//
//   wasm_1, wasm_2, ... , wasm_N
//   name_1, name_2, ... , name_N
//
// We resolve imports and exports using those names as we merge all the code
// into the final module. That is, if wasm_i imports "foo.bar", and wasm_j has
// name name_j == "foo" and it exports a function bar, then wasm_i's import of
// "foo.bar" will turn into a reference to the proper item from wasm_j that
// corresponds to that export.
//

#include "ir/module-utils.h"
#include "ir/names.h"
#include "support/colors.h"
#include "support/file.h"
#include "wasm-io.h"
#include "wasm.h"
#include "wasm-validator.h"

#include "tool-options.h"

using namespace wasm;

namespace {

// The module we'll merge into.
Module merged;

// Merging two modules is mostly straightforward: copy the functions etc. of the
// first module into the second, with some renaming to avoid name collisions.
// The only other thing we need to handle is the mapping of imports to exports,
// which can happen both ways. The way we handle this is to first combine the
// items into a single module, while tracking the origin module for exports.
// Then as a later operation we hook up imports and exports.
//
// For example, if we have these two modules:
//
//  ;; metadata: module "A"
//  (module
//    (import "B" "c" (func $d))
//    (func $e
//      (call $d)
//    )
//  )
//
//  ;; metadata: module "B"
//  (module
//    (func $f (export "c")
//      ..
//    )
//  )
//
// Then the first phase just combines them into this single module:
//
//  (module
//    (import "B" "c" (func $d))
//    (func $e
//      (call $d)
//    )
//    (func $f (export "c") ;; metadata: exported from "B"
//      ..
//    )
//  )
//
// And then we can connect the export "c" which we remember was from "B" to the
// import of B.c:
//
//  (module
//    (import "B" "c" (func $d))
//    (func $e
//      (call $f) ;; only this line changed
//    )
//    (func $f (export "c")
//      ..
//    )
//  )
//
// Note that we don't bother to remove either the export or the import, which we
// leave for later (optimizations can remove the import, and we handle exports
// lower down).
//
// To implement that, we need to track the module origin of exports, which we do
// with the following data structure, which maps Export objects to their module
// name.
using ExportModuleMap = std::unordered_map<Export*, Name>;

/*

// A map of (kind of thing in the module) to (old name => new name) for things
// of that kind. For example, one of the maps is of old function names to new
// function names.
using NameMap = std::unordered_map<Name, Name>;
using KindNameMaps = std::unordered_map<ModuleItemKind, NameMap>;

// Exports in the merged wasm so far: a map of (module name) to (export name =>
// name inside module). For example, consider this module:
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
using KindModuleExportMaps = std::unordered_map<ExternalKind, ModuleExportMap>;

// The accumulated KindModuleExportMaps of all merged modules thus far.
KindModuleExportMaps kindModuleExportMaps;

// Similar to exports, we have a data structures to map the imports seen so far.
// ImportMap maps a (module, base) pair to the name of the item in the merged
// module. For example, if the module is
//
//  (module
//    (import "foo" "bar" (func $inner))
//  )
//
// then ImportMap would map (foo, bar) => inner.
using ImportMap = std::unordered_map<std::pair<Name, Name>, Name>;

// A map of ImportMap, one per item kind (one for functions, one for globals,
// etc.).
using KindImportMaps = std::unordered_map<ExternalKind, ImportMap>;

KindImportMaps kindImportMaps;

// Notes the exports in a module on KindModuleExportMaps, so later modules can
// find them.
void noteModuleImportsAndExports(Module& wasm, Name name) {
  // Imports.
  ModuleUtils::iterNamed(wasm, [&](ExternalKind kind, Named* curr) {
    kindImportMaps[kind][{curr->module, curr->base}] = curr->name;
  });

  // Exports.
  for (auto& ex : wasm.exports) {
    kindModuleExportMaps[ex->kind][name][ex->name] = ex->value;
  }
}

*/

// First we'll scan the input module to find the names of the items it contains,
// and pick new names for them that do not cause conflicts in the target.
//
// For things defined in the input module this is trivial: we either use the
// existing name, if there is no conflict in the target, or if there is then we
// pick some new unique name. For things imported in the input module, we check
// if they are provided in the target module, and if so then we point the name
// to that so we use it directly.
void buildKindNameMaps(Module& input, KindNameMaps& kindNameMaps) {
  // Given a name that refers to some kind, and the module.base of an import
  // operation, returns the proper name of the import in the target, if it
  // exists, and otherwise returns the original name.
  auto maybeUseImport = [&](Name name, ModuleItemKind kind, Name module, Name base) {
    if (!module.is()) {
      // This is
      return name; // XXX remove all this
    }
    if
  }

  for (auto& curr : input.functions) {
    kindNameMaps[ModuleItemKind::Function][curr->name] = maybeUseImport(Names::getValidFunctionName(merged, curr->name), merged.getFunctionOrNull(curr->);
  }
  for (auto& curr : input.globals) {
    kindNameMaps[ModuleItemKind::Global][curr->name] = maybeUseImport(Names::getValidGlobalName(merged, curr->name), curr);
  }
  for (auto& curr : input.tags) {
    kindNameMaps[ModuleItemKind::Tag][curr->name] = maybeUseImport(Names::getValidTagName(merged, curr->name), curr);
  }
  for (auto& curr : input.elementSegments) {
    kindNameMaps[ModuleItemKind::ElementSegment][curr->name] = maybeUseImport(Names::getValidElementSegmentName(merged, curr->name), curr);
  }
  for (auto& curr : input.memories) {
    kindNameMaps[ModuleItemKind::Memory][curr->name] = maybeUseImport(Names::getValidMemoryName(merged, curr->name), curr);
  }
  for (auto& curr : input.dataSegments) {
    kindNameMaps[ModuleItemKind::DataSegment][curr->name] = maybeUseImport(Names::getValidDataSegmentName(merged, curr->name), curr);
  }
  for (auto& curr : input.tables) {
    kindNameMaps[ModuleItemKind::Table][curr->name] = maybeUseImport(Names::getValidTableName(merged, curr->name), curr);
  }
}

void updateNames(Module& input, KindNameMaps& kindNameMaps) {
  // Update the input module in place. This is more efficient than making a
  // copy or updating it as we go in some online manner.
  struct NameMapper : public WalkerPass<PostWalker<NameMapper, UnifiedExpressionVisitor<NameMapper>>> {
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

#define DELEGATE_FIELD_NAME_KIND(id, field, kind) \
  assert(kindNameMaps[kind].count(cast->field)); \
  cast->field = kindNameMaps[kind][cast->field];

#include "wasm-delegations-fields.def"
    }
  } nameMapper(kindNameMaps);

  PassRunner runner(&input);
  nameMapper.run(&runner, &input);
  nameMapper.runOnModuleCode(&runner, &input);
}

void copyModuleContents(Module& input, Name inputName) {
  // First, copy the regular module items (functions, globals) etc. which we
  // have proper names for, and can just copy.
  ModuleUtils::copyModuleItems(input, merged);

  // We must handle exports in a special way, as we need to note their origin
  // module as we copy them in (also, they are not importable or exportable, so
  // the ModuleUtils function above does not handle them).
  for (auto& curr : in.exports) {
    auto copy = std::make_unique<Export>(*curr);
    ExportModuleMap[copy.get()] = inputName;
    out.addExport(std::move(copy));
  }

  // TODO: start, type names, etc. etc.
}

// Finds pairs of matching imports and exports, and makes uses of the import
// refer to the exported item (which has been merged into the module).
void connectImportsAndExports() {
  ...
}

// Merges an input module into an existing target module. The input module can
// be modified, as it will no longer be needed (so it is intentionally not
// marked as const here).
void mergeInto(Module& input, Name inputName) {
  KindNameMaps kindNameMaps;

// XXX hook up imports and exports both ways!

  // Find the new names we'll use.
  buildKindNameMaps(input, kindNameMaps);

  // Apply the new names in the input module.
  updateNames(input, kindNameMaps);

  // The input module's items can now be copied into the target module safely.
  copyModuleContents(input, inputName);

  // Connect imports and exports now that everything is all together in the
  // merged module.
  connectImportsAndExports();

  // Note the exports from the new input for future modules to find.
  noteModuleImportsAndExports(input, inputName);

  // TODO: remaining things like exports, start, type names, etc.; see
  //       ModuleUtils::copyModule
}

} // anonymous namespace

int main(int argc, const char* argv[]) {
  std::vector<std::string> inputFiles;
  bool emitBinary = true;
  bool debugInfo = false;

  const std::string WasmMergeOption = "wasm-merge options";

  ToolOptions options("wasm-merge",
                      "Merge wasm files into one");
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
    .add_positional("INFILES",
                    Options::Arguments::N,
                    [&inputFiles](Options* o, const std::string& argument) {
                      inputFiles.push_back(argument);
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

  // Inputs.

  bool first = true;
  for (auto& input : inputFiles) {
    if (options.debug) {
      std::cerr << "reading input '" << input << "'...\n";
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
      reader.read(options.extra["infile"], *currModule);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing wasm input: " << input;
    }

    if (options.passOptions.validate) {
      if (!WasmValidator().validate(*currModule)) {
        std::cout << *currModule << '\n';
        Fatal() << "error in validating input: " << input;
      }
    }

    if (!laterInput) {
      // This is the first module, so there is nothing to merge in. All we need
      // to do is note its exports and imports for later.
      noteModuleImportsAndExports(merged);
    } else {
      // This is a later module: do a full merge.
      mergeInto(*currModule, merged);

      if (options.passOptions.validate) {
        if (!WasmValidator().validate(merged)) {
          std::cout << merged << '\n';
          Fatal() << "error in validating merged after: " << input;
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
