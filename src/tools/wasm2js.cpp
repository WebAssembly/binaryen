/*
 * Copyright 2015 WebAssembly Community Group participants
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
// wasm2js console tool
//

#include "support/base64.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-s-parser.h"
#include "wasm2js.h"
#include "tool-options.h"

using namespace cashew;
using namespace wasm;

namespace {

// Wasm2JSBuilder emits the core of the module - the functions etc. that would
// be the asm.js function in an asm.js world. This class emits the rest of the
// "glue" around that.
class Wasm2JSGlue {
public:
  Wasm2JSGlue(Module& wasm, Output& out, Wasm2JSBuilder::Flags flags) : wasm(wasm), out(out), flags(flags) {}

  void emitPre();
  void emitPost();
private:
  Module& wasm;
  Output& out;
  Wasm2JSBuilder::Flags flags;
};

void Wasm2JSGlue::emitPre() {
  std::unordered_map<Name, Name> baseModuleMap;

  auto noteImport = [&](Name module, Name base) {
    // Right now codegen requires a flat namespace going into the module,
    // meaning we don't support importing the same name from multiple namespaces yet.
    if (baseModuleMap.count(base) && baseModuleMap[base] != module) {
      Fatal() << "the name " << base << " cannot be imported from "
              << "two different modules yet\n";
      abort();
    }
    baseModuleMap[base] = module;

    out << "import { "
      << base.str
      << " } from '"
      << module.str
      << "';\n";
  };

  ImportInfo imports(wasm);

  ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
    Fatal() << "non-function imports aren't supported yet\n";
    noteImport(import->module, import->base);
  });
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    noteImport(import->module, import->base);
  });

  out << '\n';
}

void Wasm2JSGlue::emitPost() {
  std::string funcName = "asmFunc";

  // Create an initial `ArrayBuffer` and populate it with static data.
  // Currently we use base64 encoding to encode static data and we decode it at
  // instantiation time.
  //
  // Note that the translation here expects that the lower values of this memory
  // can be used for conversions, so make sure there's at least one page.
  {
    auto pages = wasm.memory.initial == 0 ? 1 : wasm.memory.initial.addr;
    out << "const mem" << funcName << " = new ArrayBuffer("
      << pages * Memory::kPageSize
      << ")\n";
  }

  if (wasm.memory.segments.size() > 0) {
    auto expr = R"(
      function(mem) {
        const _mem = new Uint8Array(mem);
        return function(offset, s) {
          if (typeof Buffer === 'undefined') {
            const bytes = atob(s);
            for (let i = 0; i < bytes.length; i++)
              _mem[offset + i] = bytes.charCodeAt(i);
          } else {
            const bytes = Buffer.from(s, 'base64');
            for (let i = 0; i < bytes.length; i++)
              _mem[offset + i] = bytes[i];
          }
        }
      }
    )";

    // const assign$name = ($expr)(mem$name);
    out << "const assign" << funcName
      << " = (" << expr << ")(mem" << funcName << ")\n";
  }
  for (auto& seg : wasm.memory.segments) {
    assert(!seg.isPassive && "passive segments not implemented yet");
    out << "assign" << funcName << "("
      << constOffset(seg)
      << ", \""
      << base64Encode(seg.data)
      << "\")\n";
  }

  // Actually invoke the `asmFunc` generated function, passing in all global
  // values followed by all imports
  out << "const ret" << funcName << " = " << funcName << "({"
    << "Math,"
    << "Int8Array,"
    << "Uint8Array,"
    << "Int16Array,"
    << "Uint16Array,"
    << "Int32Array,"
    << "Uint32Array,"
    << "Float32Array,"
    << "Float64Array,"
    << "NaN,"
    << "Infinity"
    << "}, {";

  out << "abort:function() { throw new Error('abort'); }";

  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    out << "," << import->base;
  });
  out << "},mem" << funcName << ")\n";

  if (flags.allowAsserts) {
    return;
  }

  // And now that we have our returned instance, export all our functions
  // that are hanging off it.
  for (auto& exp : wasm.exports) {
    switch (exp->kind) {
      case ExternalKind::Function:
      case ExternalKind::Memory:
        break;

      // Exported globals and function tables aren't supported yet
      default:
        continue;
    }
    std::ostringstream export_name;
    for (auto *ptr = exp->name.str; *ptr; ptr++) {
      if (*ptr == '-') {
        export_name << '_';
      } else {
        export_name << *ptr;
      }
    }
    out << "export const "
      << asmangle(exp->name.str)
      << " = ret"
      << funcName
      << "."
      << asmangle(exp->name.str);
  }
  out << "\n";
}

} // anonymous namespace

int main(int argc, const char *argv[]) {
  Wasm2JSBuilder::Flags builderFlags;
  ToolOptions options("wasm2js", "Transform .wasm/.wast files to asm.js");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--allow-asserts", "", "Allow compilation of .wast testing asserts",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             builderFlags.allowAsserts = true;
             o->extra["asserts"] = "1";
           })
      .add("--pedantic", "", "Emulate WebAssembly trapping behavior",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             builderFlags.pedantic = true;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);
  if (options.debug) builderFlags.debug = true;

  Element* root = nullptr;
  Module wasm;
  Ref asmjs;
  std::unique_ptr<SExpressionParser> sexprParser;
  std::unique_ptr<SExpressionWasmBuilder> sexprBuilder;

  auto &input = options.extra["infile"];
  std::string suffix(".wasm");
  bool binaryInput =
      input.size() >= suffix.size() &&
      input.compare(input.size() - suffix.size(), suffix.size(), suffix) == 0;

  try {
    // If the input filename ends in `.wasm`, then parse it in binary form,
    // otherwise assume it's a `*.wast` file and go from there.
    //
    // Note that we're not using the built-in `ModuleReader` which will also do
    // similar logic here because when testing JS files we use the
    // `--allow-asserts` flag which means we need to parse the extra
    // s-expressions that come at the end of the `*.wast` file after the module
    // is defined.
    if (binaryInput) {
      ModuleReader reader;
      reader.setDebug(options.debug);
      reader.read(input, wasm, "");
      options.calculateFeatures(wasm);
    } else {
      auto input(
          read_file<std::vector<char>>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));
      if (options.debug) std::cerr << "s-parsing..." << std::endl;
      sexprParser = make_unique<SExpressionParser>(input.data());
      root = sexprParser->root;

      if (options.debug) std::cerr << "w-parsing..." << std::endl;
      sexprBuilder = make_unique<SExpressionWasmBuilder>(wasm, *(*root)[0]);
    }
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing input";
  } catch (std::bad_alloc&) {
    Fatal() << "error in building module, std::bad_alloc (possibly invalid request for silly amounts of memory)";
  }

  if (options.passOptions.validate) {
    if (!WasmValidator().validate(wasm, options.passOptions.features)) {
      WasmPrinter::printModule(&wasm);
      Fatal() << "error in validating input";
    }
  }

  if (options.debug) std::cerr << "asming..." << std::endl;
  Wasm2JSBuilder wasm2js(builderFlags);
  asmjs = wasm2js.processWasm(&wasm);

  if (!binaryInput) {
    if (options.extra["asserts"] == "1") {
      if (options.debug) std::cerr << "asserting..." << std::endl;
      flattenAppend(asmjs, wasm2js.processAsserts(&wasm, *root, *sexprBuilder));
    }
  }

  if (options.debug) {
    std::cerr << "a-printing..." << std::endl;
    asmjs->stringify(std::cout, true);
    std::cout << '\n';
  }

  if (options.debug) std::cerr << "j-printing..." << std::endl;
  Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  Wasm2JSGlue glue(wasm, output, builderFlags);
  glue.emitPre();
  JSPrinter jser(true, true, asmjs);
  jser.printAst();
  output << jser.buffer << std::endl;
  glue.emitPost();

  if (options.debug) std::cerr << "done." << std::endl;
}
