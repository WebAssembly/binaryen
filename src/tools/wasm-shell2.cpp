/*
 * Copyright 2021 WebAssembly Community Group participants
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
#include "ir/element-utils.h"
#include "pass.h"
#include "shell-interface.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-interpreter.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"

using namespace cashew;
using namespace wasm;

Name ASSERT_RETURN("assert_return");
Name ASSERT_TRAP("assert_trap");
Name ASSERT_INVALID("assert_invalid");
Name ASSERT_MALFORMED("assert_malformed");
Name ASSERT_UNLINKABLE("assert_unlinkable");
Name INVOKE("invoke");
Name REGISTER("register");
Name GET("get");


//
// An operation on a module
//

struct Operation {
  ModuleInstance* instance;
  Name operation;
  Name name;
  LiteralList arguments;

  Operation(Element& element,
            ModuleInstance* instanceInit,
            SExpressionWasmBuilder& builder,
            std::map<Name, std::unique_ptr<ModuleInstance>>& instances)
    : instance(instanceInit) {
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
      arguments.push_back(getLiteralFromConstExpression(argument));
    }
  }

  Literals operate() {
    if (operation == INVOKE) {
      return instance->callExport(name, arguments);
    } else if (operation == GET) {
      return {instance->getExport(name)};
    } else {
      WASM_UNREACHABLE("unknown operation");
    }
  }
};

class Shell {
protected:
  std::map<Name, std::unique_ptr<Module>> modules;
  std::map<Name, std::unique_ptr<SExpressionWasmBuilder>> builders;
  std::map<Name, std::unique_ptr<ShellExternalInterface>> interfaces;
  std::map<Name, std::unique_ptr<ModuleInstance>> instances;
  // used for imports
  std::map<Name, ModuleInstance*> registry;

  Name lastModule;

  ModuleInstance* instantiate(Module* wasm) {
    auto tempInterface = wasm::make_unique<ShellExternalInterface>();
    auto tempInstance =
      wasm::make_unique<ModuleInstance>(*wasm, tempInterface.get(), registry);
    interfaces[wasm->name].swap(tempInterface);
    instances[wasm->name].swap(tempInstance);
    return instances[wasm->name].get();
  }

  void parse(Element& s) {
    IString id = s[0]->str();
    if (id == MODULE) {
      parseModule(s);
    } else if (id == REGISTER) {
      parseRegister(s);
    } else if (id == INVOKE) {
      parseOperation(s);
    } else if (id == ASSERT_RETURN) {
      parseAssertReturn(s);
    } else if ((id == ASSERT_INVALID) || (id == ASSERT_MALFORMED)) {
      parseModuleAssertion(s);
    }
  }

  Module* parseModule(Element& s) {
    if (options.debug) {
      std::cerr << "parsing s-expressions to wasm...\n";
    }
    Colors::green(std::cerr);
    std::cerr << "BUILDING MODULE [line: " << s.line << "]\n";
    Colors::normal(std::cerr);
    auto module = wasm::make_unique<Module>();
    auto builder =
      wasm::make_unique<SExpressionWasmBuilder>(*module, s, IRProfile::Normal);
    auto moduleName = module->name;
    lastModule = module->name;
    builders[moduleName].swap(builder);
    modules[moduleName].swap(module);
    modules[moduleName]->features = FeatureSet::All;
    bool valid = WasmValidator().validate(*modules[moduleName]);
    if (!valid) {
      std::cout << *modules[moduleName] << '\n';
      Fatal() << "module failed to validate, see above";
    }

    instantiate(modules[moduleName].get());

    return modules[moduleName].get();
  }

  void parseRegister(Element& s) {
    auto* instance = instances[lastModule].get();
    if (!instance) {
      Fatal() << "register called without a module";
    }
    auto name = s[1]->str();
    registry[name] = instance;

    // swap to the new name in all maps
    modules[name].swap(modules[lastModule]);
    builders[name].swap(builders[lastModule]);
    interfaces[name].swap(interfaces[lastModule]);
    instances[name].swap(instances[lastModule]);

    Colors::green(std::cerr);
    std::cerr << "REGISTER MODULE INSTANCE AS \"" << name.c_str()
              << "\"  [line: " << s.line << "]\n";
    Colors::normal(std::cerr);
  }

  Literals parseOperation(Element& s) {
    Index i = 1;
    Name moduleName = lastModule;
    if (s[i]->dollared()) {
      moduleName = s[i++]->str();
    }
    ModuleInstance* instance = instances[moduleName].get();
    assert(instance);

    Name base = s[i++]->str();

    LiteralList args;
    while (i < s.size()) {
      Expression* argument = builders[moduleName]->parseExpression(*s[i++]);
      args.push_back(getLiteralFromConstExpression(argument));
    }

    return instance->callExport(base, args);
  }

  void parseAssertTrap(Element& s) {
    bool trapped = false;
    try {
      parseOperation(*s[1]);
    } catch (const TrapException&) {
      trapped = true;
    } catch (const WasmException& e) {
      std::cout << "[exception thrown: " << e << "]" << std::endl;
      trapped = true;
    }

    assert(trapped);
  }

  void parseAssertReturn(Element& s) {
    Literals actual;
    Literals expected;
    if (s.size() >= 3) {
      expected = getLiteralsFromConstExpression(
        builders[lastModule]->parseExpression(*s[2]));
    }
    bool trapped = false;
    try {
      actual = parseOperation(*s[1]);
    } catch (const TrapException&) {
      trapped = true;
    } catch (const WasmException& e) {
      std::cout << "[exception thrown: " << e << "]" << std::endl;
      trapped = true;
    }
    assert(!trapped);
    std::cerr << "seen " << actual << ", expected " << expected << '\n';
    if (expected != actual) {
      Fatal() << "unexpected, should be identical\n";
    }
  }

  bool tryParseModuleArg(Element& s) {
    Module wasm;
    wasm.features = FeatureSet::All;
    std::unique_ptr<SExpressionWasmBuilder> builder;
    try {
      builder = std::unique_ptr<SExpressionWasmBuilder>(
        new SExpressionWasmBuilder(wasm, s, IRProfile::Normal));
    } catch (const ParseException&) {
      return false;
    }

    return true;
  }

  void parseModuleAssertion(Element& s) {
    Module wasm;
    wasm.features = FeatureSet::All;
    std::unique_ptr<SExpressionWasmBuilder> builder;
    auto id = s[0]->str();

    bool invalid = false;
    try {
      builder = std::unique_ptr<SExpressionWasmBuilder>(
        new SExpressionWasmBuilder(wasm, *s[1], IRProfile::Normal));
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
        if (registry.count(import->module) == 0 ||
            registry.at(import->module)->wasm.getExportOrNull(import->base) ==
              nullptr) {
          std::cerr << "unknown import: " << import->module << '.'
                    << import->base << '\n';
          invalid = true;
        }
      };
      ModuleUtils::iterImportedGlobals(wasm, reportUnknownImport);
      ModuleUtils::iterImportedTables(wasm, reportUnknownImport);
      ModuleUtils::iterImportedFunctions(wasm, [&](Importable* import) {
        if (import->module == SPECTEST && import->base.startsWith(PRINT)) {
          // We can handle it.
        } else {
          reportUnknownImport(import);
        }
      });
      ElementUtils::iterAllElementFunctionNames(&wasm, [&](Name name) {
        // spec tests consider it illegal to use spectest.print in a table
        if (auto* import = wasm.getFunction(name)) {
          if (import->imported() && import->module == SPECTEST &&
              import->base.startsWith(PRINT)) {
            std::cerr << "cannot put spectest.print in table\n";
            invalid = true;
          }
        }
      });
      if (wasm.memory.imported()) {
        reportUnknownImport(&wasm.memory);
      }
    }

    if (!invalid) {
      Colors::red(std::cerr);
      std::cerr << "[should have been invalid]\n";
      Colors::normal(std::cerr);
      Fatal() << &wasm << '\n';
    }
  }

protected:
  Options options;

public:
  Shell(Options options) : options(options) {
    auto input(
      read_file<std::vector<char>>("test/spec/spectest.wast", Flags::Text));
    SExpressionParser parser(input.data());
    Element& root = *parser.root;
    parseModule(*root[0]);
    parseRegister(*root[1]);
  }

  bool parseAndRun(Element& root) {
    size_t i = 0;
    while (i < root.size()) {
      parse(*root[i++]);
    }

    return false;
  }
};

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::set<size_t> skipped;

  Options options("wasm-shell", "Execute .wast files");
  options
    .add("--entry",
         "-e",
         "Call the entry point after parsing the module",
         Options::Arguments::One,
         [&entry](Options*, const std::string& argument) { entry = argument; })
    .add("--skip",
         "-s",
         "Skip input on certain lines (comma-separated-list)",
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
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    });
  options.parse(argc, argv);

  auto input(
    read_file<std::vector<char>>(options.extra["infile"], Flags::Text));

  bool checked = false;
  try {
    if (options.debug) {
      std::cerr << "parsing text to s-expressions...\n";
    }
    SExpressionParser parser(input.data());
    Element& root = *parser.root;
    checked = Shell(options).parseAndRun(root);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    exit(1);
  }

  if (checked) {
    Colors::green(std::cerr);
    Colors::bold(std::cerr);
    std::cerr << "all checks passed.\n";
    Colors::normal(std::cerr);
  }
}