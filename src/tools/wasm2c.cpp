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

#include "wasm2c.h"
#include "optimization-options.h"
#include "parser/wat-parser.h"
#include "pass.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"

using namespace wasm;
using namespace wasm::WATParser;

int main(int argc, const char* argv[]) {
  Wasm2CBuilder::Flags flags;

  const std::string Wasm2COption = "wasm2c options";

  OptimizationOptions options(
    "wasm2c", "Transform .wasm/.wat files to standard C source and headers");
  options
    .add("--output",
         "-o",
         "Output file path (derives .h by changing extension, writes both to "
         "stdout if not specified)",
         Wasm2COption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::setEnabled(false);
         })
    .add("--allow-asserts",
         "",
         "Allow compilation of .wast testing asserts",
         Wasm2COption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           o->extra["asserts"] = "1";
         })
    .add("--prefix",
         "-n",
         "Set the name prefix for the generated C symbols",
         Wasm2COption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) {
           flags.moduleName = argument;
         })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    });

  options.parse(argc, argv);
  if (options.debug) {
    flags.debug = true;
  }

  std::optional<WASTScript> script;
  std::shared_ptr<Module> wasm;


  auto& input = options.extra["infile"];
  std::string suffix(".wasm");
  bool binaryInput =
    input.size() >= suffix.size() &&
    input.compare(input.size() - suffix.size(), suffix.size(), suffix) == 0;

  try {
    // If the input filename ends in `.wasm`, then parse it in binary form,
    // otherwise assume it's a `*.wat` file and go from there.
    //
    // Note that we're not using the built-in `ModuleReader` which will also do
    // similar logic here because when testing C files we use the
    // `--allow-asserts` flag which means we need to parse the extra
    // s-expressions that come at the end of the `*.wast` file after the module
    // is defined.
    if (binaryInput) {
      wasm = std::make_shared<Module>();
      options.applyOptionsBeforeParse(*wasm);
      ModuleReader reader;
      reader.read(input, *wasm, "");
    } else {
      auto input(read_file<std::string>(options.extra["infile"], Flags::Text));

      auto parsed = parseScript(input);
      if (auto* err = parsed.getErr()) {
        Fatal() << err->msg;
      }
      script = std::move(*parsed);

      // Find the first module in the script.
      if (script->empty()) {
        Fatal() << "expected module";
      }
      if (auto* mod = std::get_if<WASTModule>(&(*script)[0].cmd)) {
        if (mod->isDefinition) {
          Fatal() << "module definition is not supported";
        }
        if (auto* w = std::get_if<std::shared_ptr<Module>>(&mod->module)) {
          wasm = *w;
          // This isn't actually before the parse, but we can't apply the
          // feature options any earlier. FIXME.
          options.applyOptionsBeforeParse(*wasm);
        }
      }
      if (!wasm) {
        Fatal() << "expected module as first command in script";
      }
    }
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing input";
  } catch (std::bad_alloc&) {
    Fatal() << "error in building module, std::bad_alloc (possibly invalid "
               "request for silly amounts of memory)";
  }

  options.applyOptionsAfterParse(*wasm);
  if (options.passOptions.validate) {
    if (!WasmValidator().validate(*wasm)) {
      std::cout << *wasm << '\n';
      Fatal() << "error in validating input";
    }
  }

  if (options.debug) {
    std::cerr << "j-printing..." << std::endl;
  }

  std::string output_c_path = options.extra["output"];
  if (!output_c_path.empty()) {
    // Derive output header file path (.h instead of .c)
    std::string output_h_path = output_c_path;
    size_t last_dot = output_h_path.find_last_of('.');
    if (last_dot != std::string::npos) {
      output_h_path.replace(last_dot, std::string::npos, ".h");
    } else {
      output_h_path += ".h";
    }

    // Extract header basename for custom `#include "[basename]"` inside .c file
    size_t last_slash = output_h_path.find_last_of("/\\");
    std::string header_basename = (last_slash == std::string::npos)
                                    ? output_h_path
                                    : output_h_path.substr(last_slash + 1);
    flags.headerName = header_basename;

    Output c_out(output_c_path, Flags::Text);
    Output h_out(output_h_path, Flags::Text);

    if (script && options.extra["asserts"] == "1") {
      AssertionEmitter emitter(*script, flags, options.passOptions);
      emitter.emit(c_out.getStream(), h_out.getStream());
    } else {
      optimizeWasm(*wasm, options.passOptions);
      Wasm2CBuilder builder(flags);
      builder.processWasm(wasm.get(), c_out.getStream(), h_out.getStream());
    }
  } else {
    // Write both to stdout sequentially
    std::cout << "/* === HEADER FILE === */\n";
    std::stringstream h_stream;
    std::stringstream c_stream;

    flags.headerName = "wasm.h"; // Default fallback
    if (script && options.extra["asserts"] == "1") {
      AssertionEmitter emitter(*script, flags, options.passOptions);
      emitter.emit(c_stream, h_stream);
    } else {
      optimizeWasm(*wasm, options.passOptions);
      Wasm2CBuilder builder(flags);
      builder.processWasm(wasm.get(), c_stream, h_stream);
    }
    std::cout << h_stream.str();
    std::cout << "\n/* === SOURCE FILE === */\n";
    std::cout << c_stream.str();
  }

  if (options.debug) {
    std::cerr << "done." << std::endl;
  }

  flush_and_quick_exit(0);
}
