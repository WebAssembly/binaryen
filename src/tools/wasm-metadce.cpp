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

#include "pass.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/colors.h"
#include "wasm-io.h"
#include "wasm-builder.h"

#include "emscripten-optimizer/simple_ast.h"

using namespace wasm;

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::vector<std::string> passes;
  bool emitBinary = true;
  bool debugInfo = false;
  std::string graphFile;

  Options options("wasm-metadce", "This tool performs dead code elimination (DCE) on a larger space "
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
                                  "The graph file should represent the graph in the following "
                                  "JSON notation:\n\n"
                                  "  [\n"
                                  "    {\n"
                                  "      name: 'entity1',\n"
                                  "      reaches: ['entity2, 'entity3'],\n"
                                  "      root: true\n"
                                  "    },\n"
                                  "    {\n"
                                  "      name: 'entity2',\n"
                                  "      reaches: ['entity1, 'entity4']\n"
                                  "    },\n"
                                  "    {\n"
                                  "      name: 'entity3',\n"
                                  "      reaches: ['entity1'],\n"
                                  "      export: 'export1'\n"
                                  "    },\n"
                                  "    {\n"
                                  "      name: 'entity4',\n"
                                  "      import: ['module', 'import1']\n"
                                  "    },\n"
                                  "  ]\n\n"
                                  "Each entity has a name and an optional list of the other "
                                  "entities it reaches. It can also be marked as a root, "
                                  "export (with the export string), or import (with the "
                                  "module and import strings). DCE then computes what is "
                                  "reachable from the roots.");

  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--emit-text", "-S", "Emit text instead of binary for the output file",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &argument) { emitBinary = false; })
      .add("--debuginfo", "-g", "Emit names section and debug info",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &arguments) { debugInfo = true; })
      .add("--graph-file", "-f", "Filename of the graph description file",
           Options::Arguments::One,
           [&](Options* o, const std::string& argument) {
             graphFile = argument;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options* o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  if (graphFile.size() == 0) {
    Fatal() << "no graph file provided.";
  }

  auto input(read_file<std::string>(options.extra["infile"], Flags::Text, Flags::Release));

  Module wasm;

  {
    if (options.debug) std::cerr << "reading...\n";
    ModuleReader reader;
    reader.setDebug(options.debug);

    try {
      reader.read(options.extra["infile"], wasm);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing wasm input";
    }
  }

  auto graphInput(read_file<std::string>(graphFile, Flags::Text, Flags::Release));
  auto* copy = strdup(graphInput.c_str());
  cashew::Value graph;
  graph.parse(copy);

#if 0
  // Do some useful optimizations after the evalling
  {
    PassRunner passRunner(&wasm);
    passRunner.add("memory-packing"); // we flattened it, so re-optimize
    passRunner.add("remove-unused-names");
    passRunner.add("dce");
    passRunner.add("merge-blocks");
    passRunner.add("vacuum");
    passRunner.run();
  }

  if (options.extra.count("output") > 0) {
    if (options.debug) std::cerr << "writing..." << std::endl;
    ModuleWriter writer;
    writer.setDebug(options.debug);
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    writer.write(wasm, options.extra["output"]);
  }
#endif
}
