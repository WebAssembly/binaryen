#include <cassert>
#include <iostream>

#include "ir/module-splitting.h"
#include "ir/stack-utils.h"
#include "wasm-features.h"
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
  std::cout << *primary.get();

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
  auto secondary = splitFunctions(*primary, config).secondary;

  std::cout << "After:\n";
  std::cout << *primary.get();
  std::cout << "Secondary:\n";
  std::cout << *secondary.get();
  std::cout << "\n\n";

  valid = validator.validate(*primary);
  assert(valid && "after invalid!");
  valid = validator.validate(*secondary);
  assert(valid && "secondary invalid!");
}

void test_minimized_exports();

int main() {
  // Trivial module
  do_test({}, "(module)");

  // Global stuff
  do_test({}, R"(
    (module
     (memory $mem (shared 3 42))
     (table $tab 3 42 funcref)
     (global $glob (mut i32) (i32.const 7))
     (tag $e (param i32))
    ))");

  // Imported global stuff
  do_test({}, R"(
    (module
     (import "env" "mem" (memory $mem (shared 3 42)))
     (import "env" "tab" (table $tab 3 42 funcref))
     (import "env" "glob" (global $glob (mut i32)))
     (import "env" "e" (tag $e (param i32)))
    ))");

  // Exported global stuff
  do_test({}, R"(
    (module
     (memory $mem (shared 3 42))
     (table $tab 3 42 funcref)
     (global $glob (mut i32) (i32.const 7))
     (tag $e (param i32))
     (export "mem" (memory $mem))
     (export "tab" (table $tab))
     (export "glob" (global $glob))
     (export "e" (tag $e))
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

  // Non-deferred function in table multiple times
  do_test({"foo"}, R"(
    (module
     (table $table 2 funcref)
     (elem (i32.const 0) $foo $foo)
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Non-deferred function in table at non-const offset
  do_test({"foo"}, R"(
    (module
     (import "env" "base" (global $base i32))
     (table $table 1 funcref)
     (elem (global.get $base) $foo)
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Non-deferred function in table at non-const offset multiple times
  do_test({"foo"}, R"(
    (module
     (import "env" "base" (global $base i32))
     (table $table 2 funcref)
     (elem (global.get $base) $foo $foo)
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

  // Non-deferred exported imported function in table at a non-const offset
  do_test({"foo"}, R"(
    (module
     (import "env" "base" (global $base i32))
     (import "env" "foo" (func $foo (param i32) (result i32)))
     (table $table 1000 funcref)
     (elem (global.get $base) $foo)
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

  // Deferred function in table multiple times
  do_test({}, R"(
    (module
     (table $table 2 funcref)
     (elem (i32.const 0) $foo $foo)
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

  // Deferred exported function in table at a non-const offset
  do_test({}, R"(
    (module
     (import "env" "base" (global $base i32))
     (table $table 1000 funcref)
     (elem (global.get $base) $foo)
     (export "foo" (func $foo))
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Deferred exported function in table at a non-const offset multiple times
  do_test({}, R"(
    (module
     (import "env" "base" (global $base i32))
     (table $table 1000 funcref)
     (elem (global.get $base) $foo $foo)
     (export "foo" (func $foo))
     (func $foo (param i32) (result i32)
      (local.get 0)
     )
    ))");

  // Deferred exported function in table at an offset from a non-const base
  do_test({"null"}, R"(
    (module
     (import "env" "base" (global $base i32))
     (table $table 1000 funcref)
     (elem (global.get $base) $null $foo)
     (export "foo" (func $foo))
     (func $null)
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

  // Mixed table 1 with non-const offset
  do_test({"bar", "quux"}, R"(
    (module
     (import "env" "base" (global $base i32))
     (table $table 4 funcref)
     (elem (global.get $base) $foo $bar $baz $quux)
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

  // Mixed table 2 with non-const offset
  do_test({"baz"}, R"(
    (module
     (import "env" "base" (global $base i32))
     (table $table 4 funcref)
     (elem (global.get $base) $foo $bar $baz $quux)
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

  // `foo` is exported both because it is called by `bar` and because it is in a
  // table gap
  do_test({"foo"}, R"(
    (module
     (import "env" "base" (global $base i32))
     (table $table 2 funcref)
     (elem (global.get $base) $foo $bar)
     (func $foo
      (nop)
     )
     (func $bar
      (call $foo)
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

  // Multiple exports of a secondary function
  do_test({}, R"(
    (module
     (export "foo1" (func $foo))
     (export "foo2" (func $foo))
     (func $foo)
    ))");

  test_minimized_exports();
}

void test_minimized_exports() {
  Module primary;
  primary.features = FeatureSet::All;

  std::set<Name> keep;
  Expression* callBody = nullptr;

  Builder builder(primary);
  auto funcType = Signature(Type::none, Type::none);

  for (size_t i = 0; i < 10; ++i) {
    Name name = std::to_string(i);
    primary.addFunction(
      Builder::makeFunction(name, funcType, {}, builder.makeNop()));
    keep.insert(name);
    callBody =
      builder.blockify(callBody, builder.makeCall(name, {}, Type::none));

    if (i == 3) {
      primary.addExport(
        Builder::makeExport("already_exported", name, ExternalKind::Function));
    }
    if (i == 7) {
      primary.addExport(
        Builder::makeExport("%b", name, ExternalKind::Function));
    }
  }

  primary.addFunction(Builder::makeFunction("call", funcType, {}, callBody));

  ModuleSplitting::Config config;
  config.primaryFuncs = std::move(keep);
  config.newExportPrefix = "%";
  config.minimizeNewExportNames = true;

  auto secondary = splitFunctions(primary, config).secondary;
  std::cout << "Minimized names primary:\n";
  std::cout << primary << "\n";
  std::cout << "Minimized names secondary:\n";
  std::cout << *secondary << "\n";
}
