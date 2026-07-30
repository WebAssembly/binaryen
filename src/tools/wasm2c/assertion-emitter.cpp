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

#include <cassert>
#include <iostream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "parser/wat-parser.h"
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

std::string mangleName(const std::string& name) {
  if (name.empty()) {
    return "";
  }
  std::string result;
  bool isFirst = true;
  for (char c : name) {
    if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') ||
        (c >= '0' && c <= '9')) {
      result += c;
      isFirst = false;
    } else if (c == '_') {
      if (isFirst) {
        result += "0x5F";
        isFirst = false;
      } else {
        result += '_';
      }
    } else {
      char buf[8];
      snprintf(buf, sizeof(buf), "0x%02X", (unsigned char)c);
      result += buf;
      isFirst = false;
    }
  }
  return result;
}

std::string literalToCLiteral(const Literal& lit) {
  if (lit.type == Type::i32) {
    return std::to_string(static_cast<uint32_t>(lit.geti32())) + "u";
  }
  Fatal() << "Unsupported literal type for C emission: " << lit.type;
  return "";
}

} // anonymous namespace

AssertionEmitter::AssertionEmitter(WATParser::WASTScript& script,
                                   Wasm2CBuilder::Flags flags)
  : script(script), flags(flags) {}

void AssertionEmitter::emit(std::ostream& cOut,
                            const std::string& outputCPath) {
  CPrinter c(cOut);

  std::string basePath =
    outputCPath.empty() ? "spec" : stripExtension(outputCPath);
  std::string baseBasename = getBasename(basePath);

  std::vector<std::string> modulePrefixes;
  std::unordered_map<Name, std::string> moduleNameToPrefix;
  std::unordered_map<std::string, std::unordered_set<std::string>>
    moduleExports;
  std::string lastModulePrefix;

  // First pass: Process modules and generate files
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
      modulePrefixes.push_back(prefix);
      lastModulePrefix = prefix;

      if (wasm->name.is()) {
        moduleNameToPrefix[wasm->name] = prefix;
      }

      // Collect exports
      std::unordered_set<std::string> exports;
      for (auto& exp : wasm->exports) {
        if (exp->kind == ExternalKind::Function) {
          exports.insert(exp->name.toString());
        }
      }
      moduleExports[prefix] = exports;

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
    }
  }

  c << SpecTop << endl << endl;

  // Declare static instances
  for (const auto& prefix : modulePrefixes) {
    c << "static w2c_" << prefix << " instance_" << prefix << ";" << endl;
  }
  c << endl;

  // Write main execution entry point
  c << "void run_spec_tests() {" << endl;
  c.indent();

  // Instantiate modules
  for (const auto& prefix : modulePrefixes) {
    c << "wasm2c_" << prefix << "_instantiate(&instance_" << prefix << ");"
      << endl;
  }
  c << endl;

  // Process assertions
  for (size_t i = 0; i < script.size(); i++) {
    auto& entry = script[i];
    auto& cmd = entry.cmd;

    if (auto* assertCmd = std::get_if<WATParser::Assertion>(&cmd)) {
      if (auto* assertReturn =
            std::get_if<WATParser::AssertReturn>(assertCmd)) {
        auto* invoke =
          std::get_if<WATParser::InvokeAction>(&assertReturn->action);
        if (!invoke) {
          Fatal() << "Only InvokeAction is supported in AssertReturn";
        }

        std::string activePrefix;
        if (invoke->base.has_value()) {
          auto it = moduleNameToPrefix.find(invoke->base.value());
          if (it != moduleNameToPrefix.end()) {
            activePrefix = it->second;
          } else {
            Fatal() << "Unknown module reference: " << invoke->base.value();
          }
        } else {
          activePrefix = lastModulePrefix;
        }

        // Verify export exists
        auto expIt = moduleExports.find(activePrefix);
        if (expIt == moduleExports.end() ||
            !expIt->second.count(invoke->name.toString())) {
          Fatal() << "Invoked function is not exported: " << invoke->name;
        }

        std::string callStr = "w2c_" + activePrefix + "_" +
                              mangleName(invoke->name.toString()) +
                              "(&instance_" + activePrefix;
        for (const auto& arg : invoke->args) {
          callStr += ", " + literalToCLiteral(arg);
        }
        callStr += ")";

        if (assertReturn->expected.empty()) {
          c << "ASSERT_RETURN(" << callStr << ");" << endl;
        } else if (assertReturn->expected.size() == 1) {
          auto& alts = assertReturn->expected[0];
          if (alts.size() != 1) {
            Fatal() << "Multiple alternatives in expected result not supported";
          }
          auto& expectedRes = alts[0];
          if (auto* lit = std::get_if<Literal>(&expectedRes)) {
            if (lit->type == Type::i32) {
              c << "ASSERT_RETURN_I32(" << callStr << ", "
                << literalToCLiteral(*lit) << ");" << endl;
            } else {
              Fatal() << "Unsupported expected result type: " << lit->type;
            }
          } else {
            Fatal() << "Unsupported expected result kind";
          }
        } else {
          Fatal() << "Multi-value return assertions not supported";
        }

      } else if (auto* assertAction =
                   std::get_if<WATParser::AssertAction>(assertCmd)) {
        if (assertAction->type != WATParser::ActionAssertionType::Trap) {
          Fatal() << "Only Trap assertion is supported in AssertAction";
        }
        auto* invoke =
          std::get_if<WATParser::InvokeAction>(&assertAction->action);
        if (!invoke) {
          Fatal() << "Only InvokeAction is supported in AssertAction";
        }

        std::string activePrefix;
        if (invoke->base.has_value()) {
          auto it = moduleNameToPrefix.find(invoke->base.value());
          if (it != moduleNameToPrefix.end()) {
            activePrefix = it->second;
          } else {
            Fatal() << "Unknown module reference: " << invoke->base.value();
          }
        } else {
          activePrefix = lastModulePrefix;
        }

        // Verify export exists
        auto expIt = moduleExports.find(activePrefix);
        if (expIt == moduleExports.end() ||
            !expIt->second.count(invoke->name.toString())) {
          Fatal() << "Invoked function is not exported: " << invoke->name;
        }

        std::string callStr = "w2c_" + activePrefix + "_" +
                              mangleName(invoke->name.toString()) +
                              "(&instance_" + activePrefix;
        for (const auto& arg : invoke->args) {
          callStr += ", " + literalToCLiteral(arg);
        }
        callStr += ")";

        c << "ASSERT_TRAP(" << callStr << ");" << endl;
      }
    }
  }

  // Free modules
  for (const auto& prefix : modulePrefixes) {
    c << "wasm2c_" << prefix << "_free(&instance_" << prefix << ");" << endl;
  }

  c.outdent();
  c << "}" << endl;
}

} // namespace wasm
