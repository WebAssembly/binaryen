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
// A WebAssembly shell, loads a .wast file (WebAssembly in S-Expression format)
// and executes it. This provides similar functionality as the reference
// interpreter, like assert_* calls, so it can run the spec test suite.
//

#include <memory>

#include "execution-results.h"
#include "pass.h"
#include "shell-interface.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-interpreter.h"
#include "wasm-printing.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"

using namespace cashew;
using namespace wasm;

Name ASSERT_RETURN("assert_return"),
     ASSERT_TRAP("assert_trap"),
     ASSERT_INVALID("assert_invalid"),
     ASSERT_MALFORMED("assert_malformed"),
     ASSERT_UNLINKABLE("assert_unlinkable"),
     INVOKE("invoke"),
     GET("get");

// Modules named in the file

std::map<Name, std::unique_ptr<Module>> modules;
std::map<Name, std::unique_ptr<SExpressionWasmBuilder>> builders;
std::map<Name, std::unique_ptr<ShellExternalInterface>> interfaces;
std::map<Name, std::unique_ptr<ModuleInstance>> instances;

//
// An operation on a module
//

struct Operation {
  ModuleInstance* instance;
  Name operation;
  Name name;
  LiteralList arguments;

  Operation(Element& element, ModuleInstance* instanceInit, SExpressionWasmBuilder& builder) : instance(instanceInit) {
    operation = element[0]->str();
    Index i = 1;
    if (element.size() >= 3 && element[2]->isStr()) {
      // module also specified
      Name moduleName = element[i++]->str();
      instance = instances[moduleName].get();
    }
    name = element[i++]->str();
    for (size_t j = i; j < element.size(); j++) {
      Expression* argument = builder.parseExpression(*element[j]);
      arguments.push_back(argument->dynCast<Const>()->value);
    }
  }

  Literal operate() {
    if (operation == INVOKE) {
      return instance->callExport(name, arguments);
    } else if (operation == GET) {
      return instance->getExport(name);
    } else {
      Fatal() << "unknown operation: " << operation << '\n';
      WASM_UNREACHABLE();
    }
  }
};

static void run_asserts(Name moduleName, size_t* i, bool* checked, Module* wasm,
                        Element* root,
                        SExpressionWasmBuilder* builder,
                        Name entry) {
  ModuleInstance* instance = nullptr;
  if (wasm) {
    auto tempInterface = wasm::make_unique<ShellExternalInterface>(); // prefix make_unique to work around visual studio bugs
    auto tempInstance = wasm::make_unique<ModuleInstance>(*wasm, tempInterface.get());
    interfaces[moduleName].swap(tempInterface);
    instances[moduleName].swap(tempInstance);
    instance = instances[moduleName].get();
    if (entry.is()) {
      Function* function = wasm->getFunction(entry);
      if (!function) {
        std::cerr << "Unknown entry " << entry << std::endl;
      } else {
        LiteralList arguments;
        for (Type param : function->params) {
          arguments.push_back(Literal(param));
        }
        try {
          instance->callExport(entry, arguments);
        } catch (ExitException&) {
        }
      }
    }
  }
  while (*i < root->size()) {
    Element& curr = *(*root)[*i];
    IString id = curr[0]->str();
    if (id == MODULE) break;
    *checked = true;
    Colors::red(std::cerr);
    std::cerr << *i << '/' << (root->size() - 1);
    Colors::green(std::cerr);
    std::cerr << " CHECKING: ";
    Colors::normal(std::cerr);
    std::cerr << curr;
    Colors::green(std::cerr);
    std::cerr << " [line: " << curr.line << "]\n";
    Colors::normal(std::cerr);
    if (id == ASSERT_INVALID || id == ASSERT_MALFORMED || id == ASSERT_UNLINKABLE) {
      // a module invalidity test
      Module wasm;
      bool invalid = false;
      std::unique_ptr<SExpressionWasmBuilder> builder;
      try {
        builder = std::unique_ptr<SExpressionWasmBuilder>(
          new SExpressionWasmBuilder(wasm, *curr[1])
        );
      } catch (const ParseException&) {
        invalid = true;
      }
      if (!invalid) {
        // maybe parsed ok, but otherwise incorrect
        invalid = !WasmValidator().validate(wasm);
      }
      if (!invalid && id == ASSERT_UNLINKABLE) {
        // validate "instantiating" the mdoule
        auto reportUnknownImport = [&](Importable* import) {
          std::cerr << "unknown import: " << import->module << '.' << import->base << '\n';
          invalid = true;
        };
        ModuleUtils::iterImportedGlobals(wasm, reportUnknownImport);
        ModuleUtils::iterImportedFunctions(wasm, [&](Importable* import) {
          if (import->module == SPECTEST && import->base == PRINT) {
            // We can handle it.
          } else {
            reportUnknownImport(import);
          }
        });
        if (wasm.memory.imported()) {
          reportUnknownImport(&wasm.memory);
        }
        if (wasm.table.imported()) {
          reportUnknownImport(&wasm.table);
        }
        for (auto& segment : wasm.table.segments) {
          for (auto name : segment.data) {
            // spec tests consider it illegal to use spectest.print in a table
            if (auto* import = wasm.getFunction(name)) {
              if (import->imported() && import->module == SPECTEST && import->base == PRINT) {
                std::cerr << "cannot put spectest.print in table\n";
                invalid = true;
              }
            }
          }
        }
      }
      if (!invalid) {
        Colors::red(std::cerr);
        std::cerr << "[should have been invalid]\n";
        Colors::normal(std::cerr);
        std::cerr << &wasm << '\n';
        abort();
      }
    } else if (id == INVOKE) {
      assert(wasm);
      Operation operation(curr, instance, *builder);
      operation.operate();
    } else if (wasm) { // if no wasm, we skipped the module
      // an invoke test
      bool trapped = false;
      WASM_UNUSED(trapped);
      Literal result;
      try {
        Operation operation(*curr[1], instance, *builder);
        result = operation.operate();
      } catch (const TrapException&) {
        trapped = true;
      }
      if (id == ASSERT_RETURN) {
        assert(!trapped);
        if (curr.size() >= 3) {
          Literal expected = builder
                                 ->parseExpression(*curr[2])
                                 ->dynCast<Const>()
                                 ->value;
          std::cerr << "seen " << result << ", expected " << expected << '\n';
          if (expected != result) {
            std::cout << "unexpected, should be identical\n";
            abort();
          }
        } else {
          Literal expected;
          std::cerr << "seen " << result << ", expected " << expected << '\n';
          if (expected != result) {
            std::cout << "unexpected, should be identical\n";
            abort();
          }
        }
      }
      if (id == ASSERT_TRAP) assert(trapped);
    }
    *i += 1;
  }
}

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::set<size_t> skipped;

  Options options("wasm-shell", "Execute .wast files");
  options
      .add(
          "--entry", "-e", "call the entry point after parsing the module",
          Options::Arguments::One,
          [&entry](Options*, const std::string& argument) { entry = argument; })
      .add(
          "--skip", "-s", "skip input on certain lines (comma-separated-list)",
          Options::Arguments::One,
          [&skipped](Options*, const std::string& argument) {
            size_t i = 0;
            while (i < argument.size()) {
              auto ending = argument.find(',', i);
              if (ending == std::string::npos) {
                ending = argument.size();
              }
              auto sub = argument.substr(i, ending - i);
              skipped.insert(atoi(sub.c_str()));
              i = ending + 1;
            }
          })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options* o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  auto input(read_file<std::vector<char>>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));

  bool checked = false;

  try {
    if (options.debug) std::cerr << "parsing text to s-expressions...\n";
    SExpressionParser parser(input.data());
    Element& root = *parser.root;

    // A .wast may have multiple modules, with some asserts after them
    size_t i = 0;
    while (i < root.size()) {
      Element& curr = *root[i];
      if (skipped.count(curr.line) > 0) {
        Colors::green(std::cerr);
        std::cerr << "SKIPPING [line: " << curr.line << "]\n";
        Colors::normal(std::cerr);
        i++;
        continue;
      }
      IString id = curr[0]->str();
      if (id == MODULE) {
        if (options.debug) std::cerr << "parsing s-expressions to wasm...\n";
        Colors::green(std::cerr);
        std::cerr << "BUILDING MODULE [line: " << curr.line << "]\n";
        Colors::normal(std::cerr);
        auto module = wasm::make_unique<Module>();
        Name moduleName;
        auto builder = wasm::make_unique<SExpressionWasmBuilder>(*module, *root[i], &moduleName);
        builders[moduleName].swap(builder);
        modules[moduleName].swap(module);
        i++;
        bool valid = WasmValidator().validate(*modules[moduleName]);
        if (!valid) {
          WasmPrinter::printModule(modules[moduleName].get());
        }
        assert(valid);
        run_asserts(moduleName, &i, &checked, modules[moduleName].get(), &root, builders[moduleName].get(), entry);
      } else {
        run_asserts(Name(), &i, &checked, nullptr, &root, nullptr, entry);
      }
    }
  } catch (ParseException& p) {
    p.dump(std::cerr);
    abort();
  }

  if (checked) {
    Colors::green(std::cerr);
    Colors::bold(std::cerr);
    std::cerr << "all checks passed.\n";
    Colors::normal(std::cerr);
  }
}
