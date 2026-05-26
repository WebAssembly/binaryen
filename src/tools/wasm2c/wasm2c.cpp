/*
 * Copyright 2026 WebAssembly Community Group participants
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
// wasm2c console tool
//

#include "parser/wat-parser.h"
#include "parsing.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/path.h"
#include "tools/tool-options.h"
#include "tools/wasm2c/assertion-emitter.h"
#include "tools/wasm2c/wasm2c-builder.h"
#include "wasm-io.h"

using namespace wasm;

struct Wasm2COptions : public ToolOptions {
  constexpr static const char* Wasm2COptionsCategory = "wasm2c options";

  std::string output;
  bool asserts = false;
  std::string prefix;
  std::string infile;

  Wasm2COptions()
    : ToolOptions(
        "wasm2c",
        "Transform .wasm/.wat files to standard C source and headers") {
    (*this)
      .add("--output",
           "-o",
           "Output file path (derives .h by changing extension, writes both to "
           "stdout if not specified)",
           Wasm2COptionsCategory,
           Arguments::One,
           [this](Options*, const std::string& argument) {
             output = argument;
             Colors::setEnabled(false);
           })
      .add("--allow-asserts",
           "",
           "Allow compilation of .wast testing asserts",
           Wasm2COptionsCategory,
           Arguments::Zero,
           [this](Options*, const std::string&) { asserts = true; })
      .add("--prefix",
           "-n",
           "Set the name prefix for the generated C symbols",
           Wasm2COptionsCategory,
           Arguments::One,
           [this](Options*, const std::string& argument) { prefix = argument; })
      .add_positional(
        "INFILE",
        Arguments::One,
        [this](Options*, const std::string& argument) { infile = argument; });
  }
};

int main(int argc, const char* argv[]) {
  Wasm2COptions options;
  options.parse(argc, argv);

  Wasm2CBuilder::Flags flags;
  flags.moduleName = options.prefix;

  if (options.asserts) {
    // When `--allow-asserts` is passed (i.e. when running spec tests), we need
    // to parse the extra s-expressions that come at the end of the `*.wast`
    // file after the module is defined. Therefore, in this case, we can't use
    // ModuleReader.

    auto input = read_file<std::string>(options.infile, Flags::Text);

    auto script = WATParser::parseScript(input);
    if (auto* err = script.getErr()) {
      Fatal() << err->msg;
    }

    Output cOut(options.output, Flags::Text);
    AssertionEmitter emitter(*script, flags, options.passOptions);
    emitter.emit(cOut.getStream(), options.output);
  } else {
    Module wasm;
    options.applyOptionsBeforeParse(wasm);
    try {
      ModuleReader reader;
      reader.read(options.infile, wasm, "");
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing input";
    }
    options.applyOptionsAfterParse(wasm);

    if (!options.output.empty()) {
      // Derive output header file path (.h instead of .c)
      std::string outputHPath = options.output;
      size_t lastDot = outputHPath.find_last_of('.');
      if (lastDot != std::string::npos) {
        outputHPath.replace(lastDot, std::string::npos, ".h");
      } else {
        outputHPath += ".h";
      }
      flags.headerName = Path::getBaseName(outputHPath);

      Output cOut(options.output, Flags::Text);
      Output hOut(outputHPath, Flags::Text);
      Wasm2CBuilder builder(flags);
      builder.processWasm(&wasm, cOut.getStream(), hOut.getStream());
    } else {
      // Write both to stdout sequentially
      std::cout << "/* === HEADER FILE === */\n";
      std::stringstream hStream;
      std::stringstream cStream;

      flags.headerName = "wasm.h"; // Default fallback
      Wasm2CBuilder builder(flags);
      builder.processWasm(&wasm, cStream, hStream);

      std::cout << hStream.str();
      std::cout << "\n/* === SOURCE FILE === */\n";
      std::cout << cStream.str();
    }
  }

  flush_and_quick_exit(0);
}
