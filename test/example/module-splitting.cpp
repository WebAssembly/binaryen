#include <cassert>
#include <iostream>

#include "ir/module-splitting.h"
#include "ir/stack-utils.h"
#include "wasm-printing.h"
#include "wasm-s-parser.h"
#include "wasm.h"

using namespace wasm;

std::unique_ptr<Module> parse(char* module) {
  auto wasm = std::make_unique<Module>();
  try {
    SExpressionParser parser(module);
    Element& root = *parser.root;
    SExpressionWasmBuilder builder(*wasm, *root[0], IRProfile::Normal);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing wasm text";
  }
  return wasm;
}

void do_test(ModuleSplitting::Config config, std::string module) {
  auto primary = parse(&module.front());

  std::cout << "Before:\n";
  WasmPrinter::printModule(primary.get());
  auto secondary = splitFunctions(*primary, config);
  std::cout << "After:\n";
  WasmPrinter::printModule(primary.get());
  std::cout << "Secondary:\n";
  WasmPrinter::printModule(secondary.get());
  std::cout << "\n\n";
}

void test_split() {
  std::cout << ";; Test module splitting\n";
  do_test(ModuleSplitting::Config{{"foo"}, "primary", "placeholder"},
          R"(
            (module
             (memory $mem 0 0)
             (table $table 2 2 funcref)
             (elem (i32.const 0) $foo $bar)
             (export "bar" (func $bar))
             (func $foo (param i32) (result i32)
              (drop (call $bar (i32.const 0)))
             )
             (func $bar (param i32) (result i32)
              (drop (call $foo (i32.const 1)))
             )
            )
          )");
}

int main() { test_split(); }
