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

//
// An invocation into a module
//

struct Invocation {
  ModuleInstance* instance;
  IString name;
  LiteralList arguments;

  Invocation(Element& invoke, ModuleInstance* instance, SExpressionWasmBuilder& builder) : instance(instance) {
    assert(invoke[0]->str() == INVOKE);
    name = invoke[1]->str();
    for (size_t j = 2; j < invoke.size(); j++) {
      Expression* argument = builder.parseExpression(*invoke[j]);
      arguments.push_back(argument->dynCast<Const>()->value);
    }
  }

  Literal invoke() {
    return instance->callExport(name, arguments);
  }
};

static void verify_result(Literal a, Literal b) {
  if (a == b) return;
  // accept equal nans if equal in all bits
  assert(a.type == b.type);
  if (a.type == f32) {
    assert(a.reinterpreti32() == b.reinterpreti32());
  } else if (a.type == f64) {
    assert(a.reinterpreti64() == b.reinterpreti64());
  } else {
    abort();
  }
}

static void run_asserts(size_t* i, bool* checked, Module* wasm,
                        Element* root,
                        std::unique_ptr<SExpressionWasmBuilder>* builder,
                        Name entry) {
  std::unique_ptr<ShellExternalInterface> interface;
  std::unique_ptr<ModuleInstance> instance;
  if (wasm) {
    interface = wasm::make_unique<ShellExternalInterface>(); // prefix make_unique to work around visual studio bugs
    instance = wasm::make_unique<ModuleInstance>(*wasm, interface.get());
    if (entry.is()) {
      Function* function = wasm->getFunction(entry);
      if (!function) {
        std::cerr << "Unknown entry " << entry << std::endl;
      } else {
        LiteralList arguments;
        for (WasmType param : function->params) {
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
    if (id == ASSERT_INVALID) {
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
      if (!invalid) {
        Colors::red(std::cerr);
        std::cerr << "[should have been invalid]\n";
        Colors::normal(std::cerr);
        std::cerr << &wasm << '\n';
        abort();
      }
    } else if (id == INVOKE) {
      assert(wasm);
      Invocation invocation(curr, instance.get(), *builder->get());
      invocation.invoke();
    } else if (wasm) { // if no wasm, we skipped the module
      // an invoke test
      bool trapped = false;
      WASM_UNUSED(trapped);
      Literal result;
      try {
        Invocation invocation(*curr[1], instance.get(), *builder->get());
        result = invocation.invoke();
      } catch (const TrapException&) {
        trapped = true;
      }
      if (id == ASSERT_RETURN) {
        assert(!trapped);
        if (curr.size() >= 3) {
          Literal expected = builder->get()
                                 ->parseExpression(*curr[2])
                                 ->dynCast<Const>()
                                 ->value;
          std::cerr << "seen " << result << ", expected " << expected << '\n';
          verify_result(expected, result);
        } else {
          Literal expected;
          std::cerr << "seen " << result << ", expected " << expected << '\n';
          verify_result(expected, result);
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
        Module wasm;
        std::unique_ptr<SExpressionWasmBuilder> builder;
        builder = wasm::make_unique<SExpressionWasmBuilder>(wasm, *root[i]);
        i++;
        assert(WasmValidator().validate(wasm));
        run_asserts(&i, &checked, &wasm, &root, &builder, entry);
      } else {
        run_asserts(&i, &checked, nullptr, &root, nullptr, entry);
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
