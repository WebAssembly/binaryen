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
// Performs DCE on a graph containing a wasm module. The caller provides
// the graph, this tool fills in the wasm module's parts. It can then
// remove exports that are unused, for example, which is impossible
// otherwise (since we wouldn't know if the outside needs them).
//
// TODO: Currently all functions in the table are considered roots,
//       as the outside may call them. In the future we probably want
//       to refine that.

#include <memory>

#include "asmjs/shared-constants.h"
#include "ir/element-utils.h"
#include "ir/module-utils.h"
#include "optimization-options.h"
#include "pass.h"
#include "support/colors.h"
#include "support/file.h"
#include "support/json.h"
#include "wasm-builder.h"
#include "wasm-io.h"
#include "wasm-validator.h"

using namespace wasm;

// Generic reachability graph of abstract nodes

struct DCENode {
  Name name;
  std::vector<Name> reaches; // the other nodes this one can reach
  DCENode() = default;
  DCENode(Name name) : name(name) {}
};

// A meta DCE graph with wasm integration
struct MetaDCEGraph {
  std::unordered_map<Name, DCENode> nodes;
  std::unordered_set<Name> roots;

  std::unordered_map<Name, Name> exportToDCENode;

  using KindName = std::pair<ModuleItemKind, Name>;

  // Kind and exported name => DCE name
  std::unordered_map<KindName, Name> itemToDCENode;

  // imports are not mapped 1:1 to DCE nodes in the wasm, since env.X might
  // be imported twice, for example. So we don't map a DCE node to an Import,
  // but rather the module.base pair ("id") for the import.
  // TODO: implement this in a safer way, not a string with a magic separator
  using ImportId = Name;

  ImportId getImportId(Name module, Name base) {
    if (module == "GOT.func" || module == "GOT.mem") {
      // If a module imports a symbol from `GOT.func` of `GOT.mem` that
      // corresponds to the address of a symbol in the `env` namespace.  The
      // `GOT.func` and `GOT.mem` don't actually exist anywhere but reference
      // other symbols.  For this reason we treat an import from one of these
      // namespaces as an import from the `env` namespace.  (i.e.  any usage of
      // a `GOT.mem` or `GOT.func` import requires the corresponding env import
      // to be kept alive.
      module = ENV;
    }
    return std::string(module.str) + " (*) " + std::string(base.str);
  }

  ImportId getImportId(ModuleItemKind kind, Name name) {
    auto* imp = wasm.getImport(kind, name);
    return getImportId(imp->module, imp->base);
  }

  // import module.base => DCE name
  std::unordered_map<Name, Name> importIdToDCENode;

  Module& wasm;

  MetaDCEGraph(Module& wasm) : wasm(wasm) {}

  std::unordered_map<ModuleItemKind, std::string> kindPrefixes = {
    {ModuleItemKind::Function, "func"},
    {ModuleItemKind::Table, "table"},
    {ModuleItemKind::Memory, "memory"},
    {ModuleItemKind::Global, "global"},
    {ModuleItemKind::Tag, "tag"},
    {ModuleItemKind::DataSegment, "dseg"},
    {ModuleItemKind::ElementSegment, "eseg"}};

  // populate the graph with info from the wasm, integrating with
  // potentially-existing nodes for imports and exports that the graph may
  // already contain.
  void scanWebAssembly() {
    // Add an entry for everything we might need ahead of time, so parallel work
    // does not alter parent state, just adds to things pointed by it,
    // independently (each thread will add for one function, etc.)
    ModuleUtils::iterModuleItems(wasm, [&](ModuleItemKind kind, Named* item) {
      if (auto* import = wasm.getImportOrNull(kind, item->name)) {
        auto id = getImportId(import->module, import->base);
        if (importIdToDCENode.find(id) == importIdToDCENode.end()) {
          auto dceName = getName("importId", import->name.toString());
          importIdToDCENode[id] = dceName;
        }
        return;
      }
      auto dceName = getName(kindPrefixes[kind], item->name.toString());
      itemToDCENode[{kind, item->name}] = dceName;
      nodes[dceName] = DCENode(dceName);
    });
    for (auto& exp : wasm.exports) {
      if (exportToDCENode.find(exp->name) == exportToDCENode.end()) {
        auto dceName = getName("export", exp->name.toString());
        exportToDCENode[exp->name] = dceName;
        nodes[dceName] = DCENode(dceName);
      }
      // we can also link the export to the thing being exported
      auto& node = nodes[exportToDCENode[exp->name]];
      node.reaches.push_back(getDCEName(ModuleItemKind(exp->kind), exp->value));
    }
    // Add initializer dependencies
    // if we provide a parent DCE name, that is who can reach what we see
    // if none is provided, then it is something we must root
    struct InitScanner : public PostWalker<InitScanner> {
      InitScanner(MetaDCEGraph* parent, Name parentDceName)
        : parent(parent), parentDceName(parentDceName) {}

      void visitGlobalGet(GlobalGet* curr) { handleGlobal(curr->name); }
      void visitGlobalSet(GlobalSet* curr) { handleGlobal(curr->name); }
      void visitRefFunc(RefFunc* curr) {
        assert(!parentDceName.isNull());
        parent->nodes[parentDceName].reaches.push_back(
          parent->getDCEName(ModuleItemKind::Function, curr->func));
      }

    private:
      MetaDCEGraph* parent;
      Name parentDceName;

      void handleGlobal(Name name) {
        Name dceName;
        if (!getModule()->getGlobal(name)->imported()) {
          // its a defined global
          dceName = parent->itemToDCENode[{ModuleItemKind::Global, name}];
        } else {
          // it's an import.
          dceName = parent->importIdToDCENode[parent->getImportId(
            ModuleItemKind::Global, name)];
        }
        if (parentDceName.isNull()) {
          parent->roots.insert(dceName);
        } else {
          parent->nodes[parentDceName].reaches.push_back(dceName);
        }
      }
    };
    ModuleUtils::iterDefinedGlobals(wasm, [&](Global* global) {
      InitScanner scanner(
        this, itemToDCENode[{ModuleItemKind::Global, global->name}]);
      scanner.setModule(&wasm);
      scanner.walk(global->init);
    });
    // We can't remove active segments, so root them and what they use.
    // TODO: treat them as in a cycle with their parent memory/table
    InitScanner rooter(this, Name());
    rooter.setModule(&wasm);
    ModuleUtils::iterActiveElementSegments(wasm, [&](ElementSegment* segment) {
      // TODO: currently, all functions in the table are roots, but we
      //       should add an option to refine that
      ElementUtils::iterElementSegmentFunctionNames(
        segment, [&](Name name, Index) {
          roots.insert(getDCEName(ModuleItemKind::Function, name));
        });
      rooter.walk(segment->offset);
      roots.insert(getDCEName(ModuleItemKind::ElementSegment, segment->name));
    });
    ModuleUtils::iterActiveDataSegments(wasm, [&](DataSegment* segment) {
      rooter.walk(segment->offset);
      roots.insert(getDCEName(ModuleItemKind::DataSegment, segment->name));
    });

    // A parallel scanner for function bodies
    struct Scanner : public WalkerPass<
                       PostWalker<Scanner, UnifiedExpressionVisitor<Scanner>>> {
      bool isFunctionParallel() override { return true; }

      Scanner(MetaDCEGraph* parent) : parent(parent) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<Scanner>(parent);
      }

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
    handle(kind, cast->field);                                                 \
  }

#include "wasm-delegations-fields.def"
      }

    private:
      MetaDCEGraph* parent;

      void handle(ModuleItemKind kind, Name name) {
        getCurrentFunctionDCENode().reaches.push_back(
          parent->getDCEName(kind, name));
      }

      DCENode& getCurrentFunctionDCENode() {
        return parent->nodes[parent->itemToDCENode[{ModuleItemKind::Function,
                                                    getFunction()->name}]];
      }
    };

    PassRunner runner(&wasm);
    Scanner(this).run(&runner, &wasm);
  }

  Name getDCEName(ModuleItemKind kind, Name name) {
    if (wasm.getImportOrNull(kind, name)) {
      return importIdToDCENode[getImportId(kind, name)];
    } else {
      return itemToDCENode[{kind, name}];
    }
  }

private:
  // gets a unique name for the graph
  Name getName(std::string prefix1, std::string prefix2) {
    auto base = prefix1 + '$' + prefix2;
    if (nodes.find(base) == nodes.end()) {
      return base;
    }
    while (1) {
      Name curr = base + '$' + std::to_string(nameIndex++);
      if (nodes.find(curr) == nodes.end()) {
        return curr;
      }
    }
  }

  Index nameIndex = 0;

  std::unordered_set<Name> reached;

public:
  // Perform the DCE: simple marking from the roots
  void deadCodeElimination() {
    std::vector<Name> queue;
    for (auto root : roots) {
      reached.insert(root);
      queue.push_back(root);
    }
    while (queue.size() > 0) {
      auto name = queue.back();
      queue.pop_back();
      auto& node = nodes[name];
      for (auto target : node.reaches) {
        if (reached.emplace(target).second) {
          queue.push_back(target);
        }
      }
    }
  }

  // Apply to the wasm
  void apply() {
    // Remove the unused exports
    std::vector<Name> toRemove;
    for (auto& exp : wasm.exports) {
      auto name = exp->name;
      auto dceName = exportToDCENode[name];
      if (reached.find(dceName) == reached.end()) {
        toRemove.push_back(name);
      }
    }
    for (auto name : toRemove) {
      wasm.removeExport(name);
    }
    // Now they are gone, standard optimization passes can do the rest!
    PassRunner passRunner(&wasm);
    passRunner.add("remove-unused-module-elements");
    // removing functions may alter the optimum order, as # of calls can change
    passRunner.add("reorder-functions");
    passRunner.run();
  }

  // Print out everything we found is not used, and so can be
  // removed, including on the outside
  void printAllUnused() {
    std::set<std::string> unused;
    for (auto& [name, _] : nodes) {
      if (reached.find(name) == reached.end()) {
        unused.insert(name.toString());
      }
    }
    for (auto& name : unused) {
      std::cout << "unused: " << name << '\n';
    }
  }

  // A debug utility, prints out the graph
  void dump() {
    std::cout << "=== graph ===\n";
    for (auto root : roots) {
      std::cout << "root: " << root << '\n';
    }
    std::map<Name, ImportId> importMap;
    for (auto& [id, dceName] : importIdToDCENode) {
      importMap[dceName] = id;
    }
    for (auto& [name, node] : nodes) {
      std::cout << "node: " << name << '\n';
      if (importMap.find(name) != importMap.end()) {
        std::cout << "  is import " << importMap[name] << '\n';
      }
      for (auto target : node.reaches) {
        std::cout << "  reaches: " << target << '\n';
      }
    }
    std::cout << "=============\n";
  }
};

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::vector<std::string> passes;
  bool emitBinary = true;
  bool debugInfo = false;
  std::string graphFile;
  bool dump = false;
  std::string inputSourceMapFilename;
  std::string outputSourceMapFilename;
  std::string outputSourceMapUrl;

  const std::string WasmMetaDCEOption = "wasm-opt options";

  OptimizationOptions options(
    "wasm-metadce",
    "This tool performs dead code elimination (DCE) on a larger space "
    "that the wasm module is just a part of. For example, if you have "
    "JS and wasm that are connected, this can DCE the combined graph. "
    "By doing so, it is able to eliminate wasm module exports, which "
    "otherwise regular optimizations cannot.\n\n"
    "This tool receives a representation of the reachability graph "
    "that the wasm module resides in, which contains abstract nodes "
    "and connections showing what they reach. Some of those nodes "
    "can represent the wasm module's imports and exports. The tool "
    "then completes the graph by adding the internal parts of the "
    "module, and does DCE on the entire thing.\n\n"
    "This tool will output a wasm module with dead code eliminated, "
    "and metadata describing the things in the rest of the graph "
    "that can be eliminated as well.\n\n"
    "The graph description file should represent the graph in the following "
    "JSON-like notation (note, this is not true JSON, things like "
    "comments, escaping, single-quotes, etc. are not supported):\n\n"
    "  [\n"
    "    {\n"
    "      \"name\": \"entity1\",\n"
    "      \"reaches\": [\"entity2, \"entity3\"],\n"
    "      \"root\": true\n"
    "    },\n"
    "    {\n"
    "      \"name\": \"entity2\",\n"
    "      \"reaches\": [\"entity1, \"entity4\"]\n"
    "    },\n"
    "    {\n"
    "      \"name\": \"entity3\",\n"
    "      \"reaches\": [\"entity1\"],\n"
    "      \"export\": \"export1\"\n"
    "    },\n"
    "    {\n"
    "      \"name\": \"entity4\",\n"
    "      \"import\": [\"module\", \"import1\"]\n"
    "    },\n"
    "  ]\n\n"
    "Each entity has a name and an optional list of the other "
    "entities it reaches. It can also be marked as a root, "
    "export (with the export string), or import (with the "
    "module and import strings). DCE then computes what is "
    "reachable from the roots.");

  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         WasmMetaDCEOption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::setEnabled(false);
         })
    .add("--input-source-map",
         "-ism",
         "Consume source map from the specified file",
         WasmMetaDCEOption,
         Options::Arguments::One,
         [&inputSourceMapFilename](Options* o, const std::string& argument) {
           inputSourceMapFilename = argument;
         })
    .add("--output-source-map",
         "-osm",
         "Emit source map to the specified file",
         WasmMetaDCEOption,
         Options::Arguments::One,
         [&outputSourceMapFilename](Options* o, const std::string& argument) {
           outputSourceMapFilename = argument;
         })
    .add("--output-source-map-url",
         "-osu",
         "Emit specified string as source map URL",
         WasmMetaDCEOption,
         Options::Arguments::One,
         [&outputSourceMapUrl](Options* o, const std::string& argument) {
           outputSourceMapUrl = argument;
         })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file",
         WasmMetaDCEOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { emitBinary = false; })
    .add("--debuginfo",
         "-g",
         "Emit names section and debug info",
         WasmMetaDCEOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { debugInfo = true; })
    .add("--graph-file",
         "-f",
         "Filename of the graph description file",
         WasmMetaDCEOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) { graphFile = argument; })
    .add("--dump",
         "-d",
         "Dump the combined graph file (useful for debugging)",
         WasmMetaDCEOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { dump = true; })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    });
  options.parse(argc, argv);

  if (graphFile.size() == 0) {
    Fatal() << "no graph file provided.";
  }

  Module wasm;
  options.applyFeatures(wasm);

  {
    if (options.debug) {
      std::cerr << "reading...\n";
    }
    ModuleReader reader;
    reader.setDWARF(debugInfo);
    try {
      reader.read(options.extra["infile"], wasm, inputSourceMapFilename);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing wasm input";
    }
  }

  if (options.passOptions.validate) {
    if (!WasmValidator().validate(wasm)) {
      std::cout << wasm << '\n';
      Fatal() << "error in validating input";
    }
  }

  auto graphInput(read_file<std::string>(graphFile, Flags::Text));
  auto* copy = strdup(graphInput.c_str());
  json::Value outside;
  outside.parse(copy);

  // parse the JSON into our graph, doing all the JSON parsing here, leaving
  // the abstract computation for the class itself
  const json::IString NAME("name");
  const json::IString REACHES("reaches");
  const json::IString ROOT("root");
  const json::IString EXPORT("export");
  const json::IString IMPORT("import");

  MetaDCEGraph graph(wasm);

  if (!outside.isArray()) {
    Fatal()
      << "input graph must be a JSON array of nodes. see --help for the form";
  }
  auto size = outside.size();
  for (size_t i = 0; i < size; i++) {
    json::Ref ref = outside[i];
    if (!ref->isObject()) {
      Fatal()
        << "nodes in input graph must be JSON objects. see --help for the form";
    }
    if (!ref->has(NAME)) {
      Fatal()
        << "nodes in input graph must have a name. see --help for the form";
    }
    DCENode node(ref[NAME]->getIString());
    if (ref->has(REACHES)) {
      json::Ref reaches = ref[REACHES];
      if (!reaches->isArray()) {
        Fatal() << "node.reaches must be an array. see --help for the form";
      }
      auto size = reaches->size();
      for (size_t j = 0; j < size; j++) {
        json::Ref name = reaches[j];
        if (!name->isString()) {
          Fatal()
            << "node.reaches items must be strings. see --help for the form";
        }
        node.reaches.push_back(name->getIString());
      }
    }
    if (ref->has(ROOT)) {
      json::Ref root = ref[ROOT];
      if (!root->isBool() || !root->getBool()) {
        Fatal()
          << "node.root, if it exists, must be true. see --help for the form";
      }
      graph.roots.insert(node.name);
    }
    if (ref->has(EXPORT)) {
      json::Ref exp = ref[EXPORT];
      if (!exp->isString()) {
        Fatal() << "node.export, if it exists, must be a string. see --help "
                   "for the form";
      }
      graph.exportToDCENode[exp->getIString()] = node.name;
    }
    if (ref->has(IMPORT)) {
      json::Ref imp = ref[IMPORT];
      if (!imp->isArray() || imp->size() != 2 || !imp[0]->isString() ||
          !imp[1]->isString()) {
        Fatal() << "node.import, if it exists, must be an array of two "
                   "strings. see --help for the form";
      }
      auto id = graph.getImportId(imp[0]->getIString(), imp[1]->getIString());
      graph.importIdToDCENode[id] = node.name;
    }
    // TODO: optimize this copy with a clever move
    graph.nodes[node.name] = node;
  }

  // The external graph is now populated. Scan the module
  graph.scanWebAssembly();

  // Debug dump the graph, if requested
  if (dump) {
    graph.dump();
  }

  // Perform the DCE
  graph.deadCodeElimination();

  // Apply to the wasm
  graph.apply();

  if (options.extra.count("output") > 0) {
    ModuleWriter writer(options.passOptions);
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    if (outputSourceMapFilename.size()) {
      writer.setSourceMapFilename(outputSourceMapFilename);
      writer.setSourceMapUrl(outputSourceMapUrl);
    }
    writer.write(wasm, options.extra["output"]);
  }

  // Print out everything that we found is removable, the outside might use that
  graph.printAllUnused();

  // Clean up
  free(copy);
}
