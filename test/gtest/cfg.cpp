#include <iostream>

#include "analysis/cfg.h"
#include "analysis/lattice.h"
#include "analysis/lattices/stack.h"
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
            (then
              (loop $loop
                (br_if $loop
                  (i32.const 2)
                )
              )
              (i32.const 3)
            )
            (else
              (return)
            )
          )
        )
      )
    )
  )wasm";

  auto cfgText = R"cfg(;; preds: [], succs: [1, 5]
;; entry
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
  7: block (result i32)

;; preds: [0], succs: [7]
5:
  8: return

;; preds: [4], succs: [7]
6:
  9: drop
  10: block

;; preds: [5, 6], succs: []
;; exit
7:
)cfg";

  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("foo"));

  std::stringstream ss;
  cfg.print(ss);

  EXPECT_EQ(ss.str(), cfgText);
}

TEST_F(CFGTest, CallBlock) {
  // Verify that a call instruction ends the current basic block. Even if the
  // call has no control flow edges inside the function (no catches it can
  // reach), we still end a basic block with the call, so that we preserve the
  // property of basic blocks ending in possibly-control-flow-transferring
  // instructions.
  auto moduleText = R"wasm(
    (module
      (func $foo
        (drop
          (i32.const 0)
        )
        (call $bar)
        (drop
          (i32.const 1)
        )
      )
      (func $bar)
    )
  )wasm";

  auto cfgText = R"cfg(;; preds: [], succs: [1]
;; entry
0:
  0: i32.const 0
  1: drop
  2: call $bar

;; preds: [0], succs: []
;; exit
1:
  3: i32.const 1
  4: drop
  5: block
)cfg";

  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("foo"));

  std::stringstream ss;
  cfg.print(ss);

  EXPECT_EQ(ss.str(), cfgText);
}

TEST_F(CFGTest, Empty) {
  // Check that we create a correct CFG for an empty function.
  auto moduleText = R"wasm(
    (module (func $foo))
  )wasm";

  auto cfgText = R"cfg(;; preds: [], succs: []
;; entry
;; exit
0:
  0: nop
)cfg";

  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("foo"));

  std::stringstream ss;
  cfg.print(ss);

  EXPECT_EQ(ss.str(), cfgText);
}

TEST_F(CFGTest, Unreachable) {
  // Check that we create a correct CFG for a function that does not return. In
  // particular, it should not have an exit block.
  auto moduleText = R"wasm(
    (module (func $foo (unreachable)))
  )wasm";

  auto cfgText = R"cfg(;; preds: [], succs: []
;; entry
0:
  0: unreachable
)cfg";

  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("foo"));

  std::stringstream ss;
  cfg.print(ss);

  EXPECT_EQ(ss.str(), cfgText);
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
  EXPECT_EQ(lattice.compare(element1, element2), LatticeComparison::GREATER);
  lattice.add(&element2, "f");
  EXPECT_EQ(lattice.compare(element1, element2),
            LatticeComparison::NO_RELATION);

  std::stringstream ss;
  element1.print(ss);
  EXPECT_EQ(ss.str(), "101100");
  ss.str(std::string());
  element2.print(ss);
  EXPECT_EQ(ss.str(), "100101");
  ss.str(std::string());
  lattice.join(element2, element1);
  element2.print(ss);
  EXPECT_EQ(ss.str(), "101101");
}

TEST_F(CFGTest, BlockIndexes) {
  auto moduleText = R"wasm(
    (module
      (func $foo
        (if
          (i32.const 1)
          (then
            (drop
              (i32.const 2)
            )
            (drop
              (i32.const 3)
            )
          )
        )
      )
    )
  )wasm";

  Module wasm;
  parseWast(wasm, moduleText);

  auto* func = wasm.getFunction("foo");
  CFG cfg = CFG::fromFunction(func);
  CFGBlockIndexes indexes(cfg);

  // The body of the function is an if. An if is a control flow structure and so
  // it has no basic block (it can contain multiple ones).
  auto* iff = func->body->cast<If>();
  EXPECT_EQ(indexes.get(iff), indexes.InvalidBlock);

  // The constant 1 is in the entry block.
  EXPECT_EQ(indexes.get(iff->condition), Index(0));

  // The dropped constants 2 and three are in another block, together.
  auto* block = iff->ifTrue->cast<Block>();
  EXPECT_EQ(indexes.get(block->list[0]), Index(1));
  EXPECT_EQ(indexes.get(block->list[1]), Index(1));
}

TEST_F(CFGTest, LinearReachingDefinitions) {
  auto moduleText = R"wasm(
    (module
      (func $bar
        (local $a i32)
        (local $b i32)
        (local $c i32)
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

  LocalGraph::GetSetsMap getSetsMap;
  LocalGraph::Locations locations;
  ReachingDefinitionsTransferFunction transferFunction(
    func, getSetsMap, locations);

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

  LocalGraph::GetSetsMap expectedResult;
  expectedResult[getA1].insert(setA1);
  expectedResult[getA2].insert(setA1);
  expectedResult[getC].insert(nullptr);

  EXPECT_EQ(expectedResult, getSetsMap);
}

TEST_F(CFGTest, ReachingDefinitionsIf) {
  auto moduleText = R"wasm(
    (module
      (func $bar
        (local $a i32)
        (local $b i32)
        (local.set $a
          (i32.const 1)
        )
        (if
          (i32.eq
            (local.get $a)
            (i32.const 2)
          )
          (then
            (local.set $b
              (i32.const 3)
            )
          )
          (else
            (local.set $a
              (i32.const 4)
            )
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

  LocalGraph::GetSetsMap getSetsMap;
  LocalGraph::Locations locations;
  ReachingDefinitionsTransferFunction transferFunction(
    func, getSetsMap, locations);

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

  LocalGraph::GetSetsMap expectedResult;
  expectedResult[getA1].insert(setA1);
  expectedResult[getB].insert(nullptr);
  expectedResult[getB].insert(setB);
  expectedResult[getA2].insert(setA1);
  expectedResult[getA2].insert(setA2);

  EXPECT_EQ(expectedResult, getSetsMap);
}

TEST_F(CFGTest, ReachingDefinitionsLoop) {
  auto moduleText = R"wasm(
    (module
      (func $bar (param $a i32) (param $b i32)
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

  LocalGraph::GetSetsMap getSetsMap;
  LocalGraph::Locations locations;
  ReachingDefinitionsTransferFunction transferFunction(
    func, getSetsMap, locations);

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

  LocalGraph::GetSetsMap expectedResult;
  expectedResult[getA1].insert(nullptr);
  expectedResult[getA1].insert(setA);
  expectedResult[getA2].insert(nullptr);
  expectedResult[getA2].insert(setA);
  expectedResult[getA3].insert(setA);
  expectedResult[getB].insert(nullptr);
  expectedResult[getA4].insert(setA);

  EXPECT_EQ(expectedResult, getSetsMap);
}
