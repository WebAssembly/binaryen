#include <iostream>

#include "analysis/cfg.h"
#include "analysis/lattice.h"
#include "analysis/liveness-transfer-function.h"
#include "analysis/monotone-analyzer.h"
#include "analysis/reaching-definitions-transfer-function.h"
#include "ir/find_all.h"
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
CFG Block: 0
Input State: 000
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
  size_t numLocals = wasm.getFunction("bar")->getNumLocals();

  FiniteIntPowersetLattice lattice(numLocals);
  LivenessTransferFunction transferFunction;

  MonotoneCFGAnalyzer<FiniteIntPowersetLattice, LivenessTransferFunction>
    analyzer(lattice, transferFunction, cfg);
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
CFG Block: 0
Input State: 10
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
CFG Block: 1
Input State: 00
Predecessors: 0
Successors: 3
Intermediate States (reverse order): 
00
local.set $1
00
i32.const 4
00
CFG Block: 2
Input State: 00
Predecessors: 0
Successors: 3
Intermediate States (reverse order): 
00
drop
00
local.get $0
10
CFG Block: 3
Input State: 00
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
  size_t numLocals = wasm.getFunction("bar")->getNumLocals();

  FiniteIntPowersetLattice lattice(numLocals);
  LivenessTransferFunction transferFunction;

  MonotoneCFGAnalyzer<FiniteIntPowersetLattice, LivenessTransferFunction>
    analyzer(lattice, transferFunction, cfg);
  analyzer.evaluate();

  std::stringstream ss;
  analyzer.print(ss);

  EXPECT_EQ(ss.str(), analyzerText);
}

TEST_F(CFGTest, FinitePowersetLatticeFunctioning) {

  std::vector<std::string> initialSet = {"a", "b", "c", "d", "e", "f"};
  FinitePowersetLattice<std::string> lattice(std::move(initialSet));

  auto element1 = lattice.getBottom();

  EXPECT_TRUE(element1.isBottom());
  EXPECT_FALSE(element1.isTop());

  lattice.add(&element1, "c");
  lattice.add(&element1, "d");
  lattice.add(&element1, "a");

  EXPECT_FALSE(element1.isBottom());
  EXPECT_FALSE(element1.isTop());

  auto element2 = element1;
  lattice.remove(&element2, "c");
  EXPECT_EQ(FinitePowersetLattice<std::string>::compare(element1, element2),
            LatticeComparison::GREATER);
  lattice.add(&element2, "f");
  EXPECT_EQ(FinitePowersetLattice<std::string>::compare(element1, element2),
            LatticeComparison::NO_RELATION);

  std::stringstream ss;
  element1.print(ss);
  EXPECT_EQ(ss.str(), "101100");
  ss.str(std::string());
  element2.print(ss);
  EXPECT_EQ(ss.str(), "100101");
  ss.str(std::string());
  element2.makeLeastUpperBound(element1);
  element2.print(ss);
  EXPECT_EQ(ss.str(), "101101");
}

TEST_F(CFGTest, LinearReachingDefinitions) {
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
        (drop
          (local.get $c)
        )
        (local.set $c
          (i32.const 1)
        )
        (local.set $a
          (i32.const 2)
        )
      )
    )
  )wasm";

  Module wasm;
  parseWast(wasm, moduleText);

  Function* func = wasm.getFunction("bar");
  CFG cfg = CFG::fromFunction(func);
  FindAll<LocalSet> setFinder(func->body);

  for (size_t i = 0; i < func->getNumLocals(); ++i) {
    setFinder.list.push_back(nullptr);
  }
  FinitePowersetLattice<LocalSet*> lattice(std::move(setFinder.list));
  ReachingDefinitionsTransferFunction transferFunction(lattice,
                                                       func->getNumLocals());

  MonotoneCFGAnalyzer<FinitePowersetLattice<LocalSet*>,
                      ReachingDefinitionsTransferFunction>
    analyzer(lattice, transferFunction, cfg);
  analyzer.evaluateFunctionEntry(func);
  analyzer.evaluate();

  FindAll<LocalSet> foundSets(func->body);
  FindAll<LocalGet> foundGets(func->body);
  LocalGraph::GetSetses getSetses;
  transferFunction.beginResultCollection(&getSetses, nullptr);
  analyzer.collectResults();
  transferFunction.endResultCollection();

  EXPECT_EQ(getSetses.size(), foundGets.list.size());

  EXPECT_TRUE(getSetses.count(foundGets.list[0]));
  EXPECT_TRUE(getSetses[foundGets.list[0]].size() == 1);
  EXPECT_TRUE(getSetses[foundGets.list[0]].count(foundSets.list[0]));

  EXPECT_TRUE(getSetses.count(foundGets.list[1]));
  EXPECT_TRUE(getSetses[foundGets.list[1]].size() == 1);
  EXPECT_TRUE(getSetses[foundGets.list[1]].count(foundSets.list[0]));

  EXPECT_TRUE(getSetses.count(foundGets.list[2]));
  EXPECT_TRUE(getSetses[foundGets.list[2]].size() == 1);
  EXPECT_TRUE(getSetses[foundGets.list[2]].count(nullptr));
}

TEST_F(CFGTest, ReachingDefinitionsIf) {
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
            (i32.const 3)
          )
          (local.set $a
            (i32.const 4)
          )
        )
        (drop
          (local.get $b)
        )
        (drop
          (local.get $a)
        )
      )
    )
  )wasm";

  auto analyzerText = R"analyzer(CFG Analyzer
CFG Block: 0
Input State: 00011
Predecessors:
Successors: 1 2
Intermediate States: 
00011
i32.const 1
00011
local.set $0
10001
local.get $0
10001
i32.const 2
10001
i32.eq
10001
CFG Block: 1
Input State: 10001
Predecessors: 0
Successors: 3
Intermediate States: 
10001
i32.const 3
10001
local.set $1
11000
CFG Block: 2
Input State: 10001
Predecessors: 0
Successors: 3
Intermediate States: 
10001
i32.const 4
10001
local.set $0
00101
CFG Block: 3
Input State: 11101
Predecessors: 2 1
Successors:
Intermediate States: 
11101
local.get $1
11101
drop
11101
local.get $0
11101
drop
11101
block
11101
End
)analyzer";

  Module wasm;
  parseWast(wasm, moduleText);

  Function* func = wasm.getFunction("bar");
  CFG cfg = CFG::fromFunction(func);
  FindAll<LocalSet> setFinder(func->body);

  for (size_t i = 0; i < func->getNumLocals(); ++i) {
    setFinder.list.push_back(nullptr);
  }
  FinitePowersetLattice<LocalSet*> lattice(std::move(setFinder.list));
  ReachingDefinitionsTransferFunction transferFunction(lattice,
                                                       func->getNumLocals());

  MonotoneCFGAnalyzer<FinitePowersetLattice<LocalSet*>,
                      ReachingDefinitionsTransferFunction>
    analyzer(lattice, transferFunction, cfg);
  analyzer.evaluateFunctionEntry(func);
  analyzer.evaluate();

  std::stringstream ss;
  analyzer.print(ss);
  EXPECT_EQ(ss.str(), analyzerText);

  FindAll<LocalSet> foundSets(func->body);
  FindAll<LocalGet> foundGets(func->body);
  LocalGraph::GetSetses getSetses;
  transferFunction.beginResultCollection(&getSetses, nullptr);
  analyzer.collectResults();
  transferFunction.endResultCollection();

  EXPECT_EQ(getSetses.size(), foundGets.list.size());

  EXPECT_TRUE(getSetses.count(foundGets.list[0]));
  EXPECT_TRUE(getSetses[foundGets.list[0]].size() == 1);
  EXPECT_TRUE(getSetses[foundGets.list[0]].count(foundSets.list[0]));

  EXPECT_TRUE(getSetses.count(foundGets.list[1]));
  EXPECT_TRUE(getSetses[foundGets.list[1]].size() == 2);
  EXPECT_TRUE(getSetses[foundGets.list[1]].count(nullptr));
  EXPECT_TRUE(getSetses[foundGets.list[1]].count(foundSets.list[1]));

  EXPECT_TRUE(getSetses.count(foundGets.list[2]));
  EXPECT_TRUE(getSetses[foundGets.list[2]].size() == 2);
  EXPECT_TRUE(getSetses[foundGets.list[2]].count(foundSets.list[0]));
  EXPECT_TRUE(getSetses[foundGets.list[2]].count(foundSets.list[2]));
}

TEST_F(CFGTest, ReachingDefinitionsLoop) {
  auto moduleText = R"wasm(
    (module
      (func $bar (param $a (i32)) (param $b (i32))
        (loop $loop
          (drop
            (local.get $a)
          )
          (local.set $a
             (i32.add
               (i32.const 1)
               (local.get $a)
             )
          )
          (br_if $loop
            (i32.le_u
              (local.get $a)
              (i32.const 7)
            )
          )
        )
        (local.set $b
          (i32.sub
            (local.get $b)
            (local.get $a)
          )
        )
      )
    )
  )wasm";

  auto analyzerText = R"analyzer(CFG Analyzer
CFG Block: 0
Input State: 0011
Predecessors:
Successors: 1
Intermediate States: 
0011
CFG Block: 1
Input State: 1011
Predecessors: 0 1
Successors: 2 1
Intermediate States: 
1011
local.get $0
1011
drop
1011
i32.const 1
1011
local.get $0
1011
i32.add
1011
local.set $0
1001
local.get $0
1001
i32.const 7
1001
i32.le_u
1001
br_if $loop
1001
CFG Block: 2
Input State: 1001
Predecessors: 1
Successors: 3
Intermediate States: 
1001
block
1001
loop $loop
1001
CFG Block: 3
Input State: 1001
Predecessors: 2
Successors:
Intermediate States: 
1001
local.get $1
1001
local.get $0
1001
i32.sub
1001
local.set $1
1100
block
1100
End
)analyzer";

  Module wasm;
  parseWast(wasm, moduleText);

  Function* func = wasm.getFunction("bar");
  CFG cfg = CFG::fromFunction(func);
  FindAll<LocalSet> setFinder(func->body);

  for (size_t i = 0; i < func->getNumLocals(); ++i) {
    setFinder.list.push_back(nullptr);
  }
  FinitePowersetLattice<LocalSet*> lattice(std::move(setFinder.list));
  ReachingDefinitionsTransferFunction transferFunction(lattice,
                                                       func->getNumLocals());

  MonotoneCFGAnalyzer<FinitePowersetLattice<LocalSet*>,
                      ReachingDefinitionsTransferFunction>
    analyzer(lattice, transferFunction, cfg);
  analyzer.evaluateFunctionEntry(func);
  analyzer.evaluate();

  std::stringstream ss;
  analyzer.print(ss);
  EXPECT_EQ(ss.str(), analyzerText);
}
