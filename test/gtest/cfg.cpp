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

  LocalGraph::GetSetses getSetses;
  LocalGraph::Locations locations;
  ReachingDefinitionsTransferFunction transferFunction(
    func, getSetses, locations);

  MonotoneCFGAnalyzer<FinitePowersetLattice<LocalSet*>,
                      ReachingDefinitionsTransferFunction>
    analyzer(transferFunction.lattice, transferFunction, cfg);

  // TODO: Make evaluating function entry point more automatic (i.e. part of
  // existing evaluate call).
  analyzer.evaluateFunctionEntry(func);
  analyzer.evaluateAndCollectResults();

  FindAll<LocalSet> foundSets(func->body);
  FindAll<LocalGet> foundGets(func->body);

  LocalGet* getA1 = foundGets.list[0];
  LocalGet* getA2 = foundGets.list[1];
  LocalGet* getC = foundGets.list[2];
  LocalSet* setA1 = foundSets.list[0];

  LocalGraph::GetSetses expectedResult;
  expectedResult[getA1].insert(setA1);
  expectedResult[getA2].insert(setA1);
  expectedResult[getC].insert(nullptr);

  EXPECT_EQ(expectedResult, getSetses);
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

  Module wasm;
  parseWast(wasm, moduleText);

  Function* func = wasm.getFunction("bar");
  CFG cfg = CFG::fromFunction(func);

  LocalGraph::GetSetses getSetses;
  LocalGraph::Locations locations;
  ReachingDefinitionsTransferFunction transferFunction(
    func, getSetses, locations);

  MonotoneCFGAnalyzer<FinitePowersetLattice<LocalSet*>,
                      ReachingDefinitionsTransferFunction>
    analyzer(transferFunction.lattice, transferFunction, cfg);
  analyzer.evaluateFunctionEntry(func);
  analyzer.evaluateAndCollectResults();

  FindAll<LocalSet> foundSets(func->body);
  FindAll<LocalGet> foundGets(func->body);

  LocalGet* getA1 = foundGets.list[0];
  LocalGet* getB = foundGets.list[1];
  LocalGet* getA2 = foundGets.list[2];
  LocalSet* setA1 = foundSets.list[0];
  LocalSet* setB = foundSets.list[1];
  LocalSet* setA2 = foundSets.list[2];

  LocalGraph::GetSetses expectedResult;
  expectedResult[getA1].insert(setA1);
  expectedResult[getB].insert(nullptr);
  expectedResult[getB].insert(setB);
  expectedResult[getA2].insert(setA1);
  expectedResult[getA2].insert(setA2);

  EXPECT_EQ(expectedResult, getSetses);
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

  Module wasm;
  parseWast(wasm, moduleText);

  Function* func = wasm.getFunction("bar");
  CFG cfg = CFG::fromFunction(func);

  LocalGraph::GetSetses getSetses;
  LocalGraph::Locations locations;
  ReachingDefinitionsTransferFunction transferFunction(
    func, getSetses, locations);

  MonotoneCFGAnalyzer<FinitePowersetLattice<LocalSet*>,
                      ReachingDefinitionsTransferFunction>
    analyzer(transferFunction.lattice, transferFunction, cfg);
  analyzer.evaluateFunctionEntry(func);
  analyzer.evaluateAndCollectResults();

  FindAll<LocalSet> foundSets(func->body);
  FindAll<LocalGet> foundGets(func->body);

  LocalGet* getA1 = foundGets.list[0];
  LocalGet* getA2 = foundGets.list[1];
  LocalGet* getA3 = foundGets.list[2];
  LocalGet* getB = foundGets.list[3];
  LocalGet* getA4 = foundGets.list[4];
  LocalSet* setA = foundSets.list[0];

  LocalGraph::GetSetses expectedResult;
  expectedResult[getA1].insert(nullptr);
  expectedResult[getA1].insert(setA);
  expectedResult[getA2].insert(nullptr);
  expectedResult[getA2].insert(setA);
  expectedResult[getA3].insert(setA);
  expectedResult[getB].insert(nullptr);
  expectedResult[getA4].insert(setA);

  EXPECT_EQ(expectedResult, getSetses);
}
