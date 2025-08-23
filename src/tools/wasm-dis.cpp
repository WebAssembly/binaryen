/*
 * Copyright 2016 WebAssembly Community Group participants
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
// wasm2asm console tool
//

#include "parsing.h"
#include "source-map.h"
#include "support/colors.h"
#include "support/file.h"
#include "wasm-features.h"
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
  options.applyOptionsBeforeParse(wasm);
  auto enabledFeatures = wasm.features;
  wasm.features = FeatureSet::All;

  auto moduleReader = ModuleReader();
  try {
    moduleReader.readBinary(options.extra["infile"], wasm, sourceMapFilename);
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

  options.applyOptionsAfterParse(wasm);
  // If the features section is present, restore it. If not, restore the command
  // line + default features.
  wasm.features = wasm.hasFeaturesSection
                    ? moduleReader.getFeaturesSectionFeatures()
                    : enabledFeatures;
  if (options.debug) {
    std::cerr << "Printing..." << std::endl;
  }
  Output output(options.extra["output"], Flags::Text);
  output.getStream() << wasm << '\n';

  if (options.debug) {
    std::cerr << "Done." << std::endl;
  }
}
