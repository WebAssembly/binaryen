#include <iostream>

#include "analysis/cfg.h"
#include "print-test.h"
#include "analysis/lattice.h"
#include "analysis/monotone-analyzer.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;
using namespace wasm::analysis;

using CFGTest = PrintTest;

TEST_F(CFGTest, Print) {
  auto moduleText = R"wasm(
    (module
      (func $foo
        (drop
          (i32.const 0)
        )
        (drop
          (if (result i32)
            (i32.const 1)
            (block
              (loop $loop
                (br_if $loop
                  (i32.const 2)
                )
              )
              (i32.const 3)
            )
            (return
              (i32.const 4)
            )
          )
        )
      )
    )
  )wasm";

  auto cfgText = R"cfg(;; preds: [], succs: [1, 5]
0:
  0: i32.const 0
  1: drop
  2: i32.const 1

;; preds: [0], succs: [2]
1:

;; preds: [1, 2], succs: [3, 2]
2:
  3: i32.const 2
  4: br_if $loop

;; preds: [2], succs: [4]
3:
  5: loop $loop

;; preds: [3], succs: [6]
4:
  6: i32.const 3
  7: block

;; preds: [0], succs: []
5:
  8: i32.const 4
  9: return

;; preds: [4], succs: []
6:
  10: drop
  11: block
)cfg";

  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("foo"));

  std::stringstream ss;
  cfg.print(ss);

  EXPECT_EQ(ss.str(), cfgText);
}

TEST_F(CFGTest, LivenessTest) {
  auto moduleText = R"wasm(
    (module
      (func $bar
        (local $a (i32))
        (local $b (i32))
        (local $c)
        (local.set $a
          (i32.const 1)
        )
        (drop
          local.get $a
        )
        (local.set $b
          (local.get $a)
        )
        (local.set $c
          (i32.const 1)
        )
        (drop
          (local.get $c)
        )
      )
    )
  )wasm";

 
  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("bar"));

  cfg.print(std::cout);

  const size_t sz = 3;
  BitsetPowersetLattice<3> abc;
  if (BitsetPowersetLattice<3>::isBottom(abc)) {
    std::cout << "HELLO" << std::endl;
  }
  MonotoneCFGAnalyzer<sz> analyzer = MonotoneCFGAnalyzer<sz>::fromCFG(&cfg);

  analyzer.evaluate();

  analyzer.print(std::cout);

  // bool colors = Colors::isEnabled();
  // Colors::setEnabled(false);
  // std::stringstream ss;
  // cfg.print(ss);
  // Colors::setEnabled(colors);

  // EXPECT_EQ(ss.str(), cfgText);
}