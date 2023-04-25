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
// inside the module, etc. (While JS is mentioned here, this could also be
// helpful with the component model for wasm that is in development.)
//

#include "support/colors.h"
#include "support/file.h"
#include "wasm-io.h"

#include "tool-options.h"

using namespace wasm;

int main(int argc, const char* argv[]) {
  std::string sourceMapFilename;

  const std::string WasmDisOption = "wasm-dis options";

  ToolOptions options("wasm-dis",
                      "Un-assemble a .wasm (WebAssembly binary format) into a "
                      ".wat (WebAssembly text format)");
  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         WasmDisOption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::setEnabled(false);
         })
    .add(
      "--source-map",
      "-sm",
      "Consume source map from the specified file to add location information",
      WasmDisOption,
      Options::Arguments::One,
      [&sourceMapFilename](Options* o, const std::string& argument) {
        sourceMapFilename = argument;
      })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    });
  options.parse(argc, argv);

  if (options.debug) {
    std::cerr << "parsing binary..." << std::endl;
  }
  Module wasm;
  options.applyFeatures(wasm);
  try {
    ModuleReader().readBinary(options.extra["infile"], wasm, sourceMapFilename);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    if (options.debug) {
      Fatal() << "error parsing wasm. here is what we read up to the error:\n"
              << wasm;
    } else {
      Fatal() << "error parsing wasm (try --debug for more info)";
    }
  } catch (MapParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    Fatal() << "error in parsing wasm source mapping";
  }

  // TODO: Validation. However, validating would mean that users are forced to
  //       run with  wasm-dis -all  or such, to enable the features (unless the
  //       features section is present, but that's rare in general). It would be
  //       better to have an "autodetect" code path that enables used features
  //       eventually.

  if (options.debug) {
    std::cerr << "Printing..." << std::endl;
  }
  Output output(options.extra["output"], Flags::Text);
  output.getStream() << wasm << '\n';

  if (options.debug) {
    std::cerr << "Done." << std::endl;
  }
}
