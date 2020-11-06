#include <cassert>
#include <iostream>

#include "ir/module-splitting.h"
#include "ir/stack-utils.h"
#include "wasm-features.h"
#include "wasm-printing.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"
#include "wasm.h"

using namespace wasm;

std::unique_ptr<Module> parse(char* module) {
  auto wasm = std::make_unique<Module>();
  wasm->features = FeatureSet::All;
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

void do_test(const std::set<Name>& keptFuncs, std::string&& module) {
  WasmValidator validator;
  bool valid;

  auto primary = parse(&module.front());
  valid = validator.validate(*primary);
  assert(valid && "before invalid!");

  std::cout << "Before:\n";
  WasmPrinter::printModule(primary.get());

  std::cout << "Keeping: ";
  if (keptFuncs.size()) {
    auto it = keptFuncs.begin();
    std::cout << *it++;
    while (it != keptFuncs.end()) {
      std::cout << ", " << *it++;
    }
  } else {
    std::cout << "<none>";
  }
  std::cout << "\n";

  ModuleSplitting::Config config;
  config.primaryFuncs = keptFuncs;
  config.newExportPrefix = "%";
  auto secondary = splitFunctions(*primary, config);

  valid = validator.validate(*primary);
  assert(valid && "after invalid!");
  valid = validator.validate(*secondary);
  assert(valid && "secondary invalid!");

  std::cout << "After:\n";
  WasmPrinter::printModule(primary.get());
  std::cout << "Secondary:\n";
  WasmPrinter::printModule(secondary.get());
  std::cout << "\n\n";
}

int main() {
  // Trivial module
  do_test({}, "(module)");

  // Global stuff
  do_test({}, R"(
    (module
     (memory $mem (shared 3 42))
     (table $tab 3 42 funcref)
     (global $glob (mut i32) (i32.const 7))
     (event $e (attr 0) (param i32))
    ))");

  // Imported global stuff
  do_test({}, R"(
    (module
     (import "env" "mem" (memory $mem (shared 3 42)))
     (import "env" "tab" (table $tab 3 42 funcref))
     (import "env" "glob" (global $glob (mut i32)))
     (import "env" "e" (event $e (attr 0) (param i32)))
    ))");

  // Exported global stuff
  do_test({}, R"(
    (module
     (memory $mem (shared 3 42))
     (table $tab 3 42 funcref)
     (global $glob (mut i32) (i32.const 7))
     (event $e (attr 0) (param i32))
     (export "mem" (memory $mem))
     (export "tab" (table $tab))
     (export "glob" (global $glob))
     (export "e" (event $e))
    ))");

  // Non-deferred function
  do_test({"foo"}, R"(
    (module
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Non-deferred exported function
  do_test({"foo"}, R"(
    (module
     (export "foo" (func $foo))
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Non-deferred function in table
  do_test({"foo"}, R"(
    (module
     (table $table 1 funcref)
     (elem (i32.const 0) $foo)
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Non-deferred imported function
  do_test({"foo"}, R"(
    (module
     (import "env" "foo" (func $foo (param i32) (result i32)))
    ))");

  // Non-deferred exported imported function in table at a weird offset
  do_test({"foo"}, R"(
    (module
     (import "env" "foo" (func $foo (param i32) (result i32)))
     (table $table 1000 funcref)
     (elem (i32.const 42) $foo)
     (export "foo" (func $foo))
    ))");

  // Deferred function
  do_test({}, R"(
    (module
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Deferred exported function
  do_test({}, R"(
    (module
     (export "foo" (func $foo))
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Deferred function in table
  do_test({}, R"(
    (module
     (table $table 1 funcref)
     (elem (i32.const 0) $foo)
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Deferred exported function in table at a weird offset
  do_test({}, R"(
    (module
     (table $table 1000 funcref)
     (elem (i32.const 42) $foo)
     (export "foo" (func $foo))
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Non-deferred function calling non-deferred function
  do_test({"foo", "bar"}, R"(
    (module
     (func $foo
      (call $bar)
     )
     (func $bar
      (nop)
     )
    ))");

  // Deferred function calling non-deferred function
  do_test({"bar"}, R"(
    (module
     (func $foo
      (call $bar)
     )
     (func $bar
      (nop)
     )
    ))");

  // Non-deferred function calling deferred function
  do_test({"foo"}, R"(
    (module
     (func $foo
      (call $bar)
     )
     (func $bar
      (nop)
     )
    ))");

  // Deferred function calling deferred function
  do_test({}, R"(
    (module
     (func $foo
      (call $bar)
     )
     (func $bar
      (nop)
     )
    ))");

  // Deferred function calling non-deferred function with clashing export name
  do_test({"foo"}, R"(
    (module
     (export "%foo" (func $bar))
     (func $foo
      (nop)
     )
     (func $bar
      (call $foo)
     )
    ))");

  // Mixed table 1
  do_test({"bar", "quux"}, R"(
    (module
     (table $table 4 funcref)
     (elem (i32.const 0) $foo $bar $baz $quux)
     (func $foo
      (nop)
     )
     (func $bar
      (nop)
     )
     (func $baz
      (nop)
     )
     (func $quux
      (nop)
     )
    ))");

  // Mixed table 2
  do_test({"baz"}, R"(
    (module
     (table $table 4 funcref)
     (elem (i32.const 0) $foo $bar $baz $quux)
     (func $foo
      (nop)
     )
     (func $bar
      (nop)
     )
     (func $baz
      (nop)
     )
     (func $quux
      (nop)
     )
    ))");

  // Mutual recursion with table growth
  do_test({"foo"}, R"(
    (module
     (table $table 1 1 funcref)
     (elem (i32.const 0) $foo)
     (func $foo (param i32) (result i32)
      (call $bar (i32.const 0))
     )
     (func $bar (param i32) (result i32)
      (call $foo (i32.const 1))
     )
    ))");
}
