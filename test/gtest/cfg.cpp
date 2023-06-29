#include <iostream>

#include "analysis/cfg.h"
#include "analysis/lattice.h"
#include "analysis/monotone-analyzer.h"
#include "print-test.h"
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

TEST_F(CFGTest, LinearLiveness) {
  auto moduleText = R"wasm(
    (module
      (func $bar
        (local $a (i32))
        (local $b (i32))
        (local $c (i32))
        (local.set $a
          (i32.const 1)
        )
        (drop
          (local.get $a)
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

  auto analyzerText = R"analyzer(CFG Analyzer
State Block: 0
Beginning State: 000
End State: 000
Predecessors:
Successors:
Intermediate States (reverse order): 
000
block
000
drop
000
local.get $2
001
local.set $2
000
i32.const 1
000
local.set $1
000
local.get $0
100
drop
100
local.get $0
100
local.set $0
000
i32.const 1
000
End
)analyzer";

  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("bar"));
  FinitePowersetLattice lattice(wasm.getFunction("bar")->getNumLocals());
  MonotoneCFGAnalyzer<FinitePowersetLattice> analyzer(lattice);
  analyzer.fromCFG(&cfg);
  analyzer.evaluate();

  std::stringstream ss;
  analyzer.print(ss);

  EXPECT_EQ(ss.str(), analyzerText);
}

TEST_F(CFGTest, NonlinearLiveness) {
  auto moduleText = R"wasm(
    (module
      (func $bar
        (local $a (i32))
        (local $b (i32))
        (local.set $a
          (i32.const 1)
        )
        (if
          (i32.eq
            (local.get $a)
            (i32.const 2)
          )
          (local.set $b
            (i32.const 4)
          )
          (drop
            (local.get $a)
          )
        )
      )
    )
  )wasm";

  auto analyzerText = R"analyzer(CFG Analyzer
State Block: 0
Beginning State: 00
End State: 10
Predecessors:
Successors: 1 2
Intermediate States (reverse order): 
10
i32.eq
10
i32.const 2
10
local.get $0
10
local.set $0
00
i32.const 1
00
State Block: 1
Beginning State: 00
End State: 00
Predecessors: 0
Successors: 3
Intermediate States (reverse order): 
00
local.set $1
00
i32.const 4
00
State Block: 2
Beginning State: 10
End State: 00
Predecessors: 0
Successors: 3
Intermediate States (reverse order): 
00
drop
00
local.get $0
10
State Block: 3
Beginning State: 00
End State: 00
Predecessors: 2 1
Successors:
Intermediate States (reverse order): 
00
block
00
End
)analyzer";

  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("bar"));
  FinitePowersetLattice lattice(wasm.getFunction("bar")->getNumLocals());
  MonotoneCFGAnalyzer<FinitePowersetLattice> analyzer(lattice);
  analyzer.fromCFG(&cfg);
  analyzer.evaluate();

  std::stringstream ss;
  analyzer.print(ss);

  EXPECT_EQ(ss.str(), analyzerText);
}
