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

#include <iostream>
#include <string>

#include "parser/wat-parser.h"
#include "pass.h"
#include "support/file.h"
#include "tools/wasm2c/assertion-emitter.h"
#include "tools/wasm2c/c-printer.h"
#include "wasm.h"

// code to be inserted into the generated output
extern const char* SpecTop;

namespace wasm {

namespace {

inline std::string stripExtension(const std::string& path) {
  size_t lastDot = path.find_last_of('.');
  if (lastDot == std::string::npos) {
    return path;
  }
  size_t lastSlash = path.find_last_of("/\\");
  if (lastSlash != std::string::npos && lastDot < lastSlash) {
    return path;
  }
  return path.substr(0, lastDot);
}

inline std::string getBasename(const std::string& path) {
  size_t lastSlash = path.find_last_of("/\\");
  if (lastSlash == std::string::npos) {
    return path;
  }
  return path.substr(lastSlash + 1);
}

} // anonymous namespace

AssertionEmitter::AssertionEmitter(WATParser::WASTScript& script,
                                   Wasm2CBuilder::Flags flags,
                                   const PassOptions& options)
  : script(script), flags(flags), options(options) {}

void AssertionEmitter::emit(std::ostream& cOut,
                            const std::string& outputCPath) {
  CPrinter c(cOut);

  std::string basePath =
    outputCPath.empty() ? "spec" : stripExtension(outputCPath);
  std::string baseBasename = getBasename(basePath);

  // Loop sequentially through WASTScript AST commands
  for (size_t i = 0; i < script.size(); i++) {
    auto& entry = script[i];
    auto& cmd = entry.cmd;

    if (auto* mod = std::get_if<WATParser::WASTModule>(&cmd)) {
      if (mod->isDefinition) {
        Fatal() << "Module definition is not supported";
      }
      auto* w = std::get_if<std::shared_ptr<Module>>(&mod->module);
      assert(w && "expected parsed Module pointer inside WASTModule");

      auto wasm = *w;
      size_t currentIdx = moduleCounter++;
      std::string prefix = "spec_" + std::to_string(currentIdx);

      // Generate separate files for this module
      std::string modHFilename =
        baseBasename + "." + std::to_string(currentIdx) + ".h";

      std::string modCPath = basePath + "." + std::to_string(currentIdx) + ".c";
      std::string modHPath = basePath + "." + std::to_string(currentIdx) + ".h";

      Output modCOut(modCPath, Flags::Text);
      Output modHOut(modHPath, Flags::Text);

      Wasm2CBuilder::Flags modFlags = flags;
      modFlags.moduleName = prefix;
      modFlags.headerName = modHFilename;

      Wasm2CBuilder builder(modFlags);
      builder.processWasm(wasm.get(), modCOut.getStream(), modHOut.getStream());

      c << "#include \"" << modHFilename << "\"" << endl;
      c << SpecTop << endl << endl;

    } else if (std::get_if<WATParser::Register>(&cmd)) {
      Fatal() << "register is not yet supported";
    } else if (std::get_if<WATParser::Assertion>(&cmd)) {
      Fatal() << "assertions are not yet supported";
    } else {
      Fatal() << "unsupported command";
    }
  }

  // Write main execution entry point
  c << "void run_spec_tests() {" << endl;
  c << "}" << endl;
}

} // namespace wasm
