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
#include "ir/element-utils.h"
#include "pass.h"
#include "shell-interface.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-interpreter.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"

using namespace wasm;

Name ASSERT_RETURN("assert_return");
Name ASSERT_TRAP("assert_trap");
Name ASSERT_EXCEPTION("assert_exception");
Name ASSERT_INVALID("assert_invalid");
Name ASSERT_MALFORMED("assert_malformed");
Name ASSERT_UNLINKABLE("assert_unlinkable");
Name INVOKE("invoke");
Name REGISTER("register");
Name GET("get");

class Shell {
protected:
  std::map<Name, std::shared_ptr<Module>> modules;
  std::map<Name, std::shared_ptr<SExpressionWasmBuilder>> builders;
  std::map<Name, std::shared_ptr<ShellExternalInterface>> interfaces;
  std::map<Name, std::shared_ptr<ModuleRunner>> instances;
  // used for imports
  std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances;

  Name lastModule;

  void instantiate(Module* wasm) {
    auto tempInterface =
      std::make_shared<ShellExternalInterface>(linkedInstances);
    auto tempInstance = std::make_shared<ModuleRunner>(
      *wasm, tempInterface.get(), linkedInstances);
    interfaces[wasm->name].swap(tempInterface);
    instances[wasm->name].swap(tempInstance);
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
    } else if (id == ASSERT_TRAP) {
      parseAssertTrap(s);
    } else if (id == ASSERT_EXCEPTION) {
      parseAssertException(s);
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
    auto module = std::make_shared<Module>();
    auto builder =
      std::make_shared<SExpressionWasmBuilder>(*module, s, IRProfile::Normal);
    auto moduleName = module->name;
    lastModule = module->name;
    builders[moduleName] = builder;
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
    auto instance = instances[lastModule];
    if (!instance) {
      Fatal() << "register called without a module";
    }
    auto name = s[1]->str();
    linkedInstances[name] = instance;

    // we copy pointers as a registered module's name might still be used
    // in an assertion or invoke command.
    modules[name] = modules[lastModule];
    builders[name] = builders[lastModule];
    interfaces[name] = interfaces[lastModule];
    instances[name] = instances[lastModule];

    Colors::green(std::cerr);
    std::cerr << "REGISTER MODULE INSTANCE AS \"" << name.str
              << "\"  [line: " << s.line << "]\n";
    Colors::normal(std::cerr);
  }

  Literals parseOperation(Element& s) {
    Index i = 1;
    Name moduleName = lastModule;
    if (s[i]->dollared()) {
      moduleName = s[i++]->str();
    }
    ModuleRunner* instance = instances[moduleName].get();
    assert(instance);

    Name base = s[i++]->str();

    if (s[0]->str() == INVOKE) {
      Literals args;
      while (i < s.size()) {
        Expression* argument = builders[moduleName]->parseExpression(*s[i++]);
        args.push_back(getLiteralFromConstExpression(argument));
      }

      return instance->callExport(base, args);
    } else if (s[0]->str() == GET) {
      return instance->getExport(base);
    }

    Fatal() << "Invalid operation " << s[0]->toString();
  }

  void parseAssertTrap(Element& s) {
    [[maybe_unused]] bool trapped = false;
    auto& inner = *s[1];
    if (inner[0]->str() == MODULE) {
      return parseModuleAssertion(s);
    }

    try {
      parseOperation(inner);
    } catch (const TrapException&) {
      trapped = true;
    }
    assert(trapped);
  }

  void parseAssertException(Element& s) {
    [[maybe_unused]] bool thrown = false;
    auto& inner = *s[1];
    if (inner[0]->str() == MODULE) {
      return parseModuleAssertion(s);
    }

    try {
      parseOperation(inner);
    } catch (const WasmException& e) {
      std::cout << "[exception thrown: " << e << "]" << std::endl;
      thrown = true;
    }
    assert(thrown);
  }

  void parseAssertReturn(Element& s) {
    Literals actual;
    Literals expected;
    if (s.size() >= 3) {
      expected = getLiteralsFromConstExpression(
        builders[lastModule]->parseExpression(*s[2]));
    }
    [[maybe_unused]] bool trapped = false;
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

  void parseModuleAssertion(Element& s) {
    Module wasm;
    wasm.features = FeatureSet::All;
    std::unique_ptr<SExpressionWasmBuilder> builder;
    auto id = s[0]->str();

    bool invalid = false;
    try {
      SExpressionWasmBuilder(wasm, *s[1], IRProfile::Normal);
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
        auto it = linkedInstances.find(import->module);
        if (it == linkedInstances.end() ||
            it->second->wasm.getExportOrNull(import->base) == nullptr) {
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
      ModuleUtils::iterImportedMemories(wasm, reportUnknownImport);
    }

    if (!invalid && (id == ASSERT_TRAP || id == ASSERT_EXCEPTION)) {
      try {
        instantiate(&wasm);
      } catch (const TrapException&) {
        invalid = true;
      } catch (const WasmException& e) {
        std::cout << "[exception thrown: " << e << "]" << std::endl;
        invalid = true;
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
  Options& options;

  // spectest module is a default host-provided module defined by the spec's
  // reference interpreter. It's been replaced by the `(register ...)`
  // mechanism in the recent spec tests, and is kept for legacy tests only.
  //
  // TODO: spectest module is considered deprecated by the spec. Remove when
  // is actually removed from the spec test.
  void buildSpectestModule() {
    auto spectest = std::make_shared<Module>();
    spectest->name = "spectest";
    Builder builder(*spectest);

    spectest->addGlobal(builder.makeGlobal(Name::fromInt(0),
                                           Type::i32,
                                           builder.makeConst<uint32_t>(666),
                                           Builder::Immutable));
    spectest->addGlobal(builder.makeGlobal(Name::fromInt(1),
                                           Type::i64,
                                           builder.makeConst<uint64_t>(666),
                                           Builder::Immutable));
    spectest->addGlobal(builder.makeGlobal(Name::fromInt(2),
                                           Type::f32,
                                           builder.makeConst<float>(666.6f),
                                           Builder::Immutable));
    spectest->addGlobal(builder.makeGlobal(Name::fromInt(3),
                                           Type::f64,
                                           builder.makeConst<double>(666.6),
                                           Builder::Immutable));
    spectest->addExport(
      builder.makeExport("global_i32", Name::fromInt(0), ExternalKind::Global));
    spectest->addExport(
      builder.makeExport("global_i64", Name::fromInt(1), ExternalKind::Global));
    spectest->addExport(
      builder.makeExport("global_f32", Name::fromInt(2), ExternalKind::Global));
    spectest->addExport(
      builder.makeExport("global_f64", Name::fromInt(3), ExternalKind::Global));

    spectest->addTable(builder.makeTable(
      Name::fromInt(0), Type(HeapType::func, Nullable), 10, 20));
    spectest->addExport(
      builder.makeExport("table", Name::fromInt(0), ExternalKind::Table));

    Memory* memory =
      spectest->addMemory(builder.makeMemory(Name::fromInt(0), 1, 2));
    spectest->addExport(
      builder.makeExport("memory", memory->name, ExternalKind::Memory));

    modules["spectest"].swap(spectest);
    modules["spectest"]->features = FeatureSet::All;
    instantiate(modules["spectest"].get());
    linkedInstances["spectest"] = instances["spectest"];
    // print_* functions are handled separately, no need to define here.
  }

public:
  Shell(Options& options) : options(options) { buildSpectestModule(); }

  bool parseAndRun(Element& root) {
    size_t i = 0;
    while (i < root.size()) {
      Element& curr = *root[i];

      if (curr[0]->str() != MODULE) {
        Colors::red(std::cerr);
        std::cerr << i << '/' << (root.size() - 1);
        Colors::green(std::cerr);
        std::cerr << " CHECKING: ";
        Colors::normal(std::cerr);
        std::cerr << curr;
        Colors::green(std::cerr);
        std::cerr << " [line: " << curr.line << "]\n";
        Colors::normal(std::cerr);
      }

      parse(curr);

      i += 1;
    }

    return false;
  }
};

int main(int argc, const char* argv[]) {
  Name entry;
  std::set<size_t> skipped;

  // Read stdin by default.
  std::string infile = "-";
  Options options("wasm-shell", "Execute .wast files");
  options.add_positional(
    "INFILE",
    Options::Arguments::One,
    [&](Options* o, const std::string& argument) { infile = argument; });
  options.parse(argc, argv);

  auto input = read_file<std::string>(infile, Flags::Text);

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
