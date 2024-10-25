#include "ir/local-graph.h"
#include "parser/wat-parser.h"
#include "wasm.h"

#include "gtest/gtest.h"

using LocalGraphTest = ::testing::Test;

using namespace wasm;

TEST_F(LocalGraphTest, ObstacleBasics) {
  auto moduleText = R"wasm(
    (module
      (func $foo (result i32)
        ;; A local with a set and a get, and some nops in between.
        (local $x i32)
        (nop)
        (local.set $x
          (i32.const 10)
        )
        (nop)
        (local.get $x)
      )
    )
  )wasm";

  Module wasm;
  WATParser::parseModule(wasm, moduleText);

  // Get access to the contents of the wasm.
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* nopA = block->list[0]->cast<Nop>();
  auto* set = block->list[1]->cast<LocalSet>();
  auto* nopB = block->list[2]->cast<Nop>();

  {
    LazyLocalGraph graph(func, &wasm);
    // The set has one get.
    EXPECT_EQ(graph.getSetInfluences(set).size(), 1U);
  }

  {
    // Construct the graph with an obstacle class, Nop.
    LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
    // The set has one get, like before.
    EXPECT_EQ(graph.getSetInfluences(set).size(), 1U);
    // If the first nop is an obstacle, nothing changes: the path between the
    // set and get does not include it.
    EXPECT_TRUE(graph.setHasGetsDespiteObstacle(set, nopA));
    // But if the second one is an obstacle, it severs the connection.
    EXPECT_FALSE(graph.setHasGetsDespiteObstacle(set, nopB));
  }
}

TEST_F(LocalGraphTest, ObstacleMultiblock) {
  auto moduleText = R"wasm(
    (module
      (func $foo (result i32)
        ;; An if between the set and get.
        (local $x i32)
        (local.set $x
          (i32.const 10)
        )
        (if
          (i32.const 42)
          (then
            (nop)
          )
          (else
            (nop)
          )
        )
        (nop)
        (local.get $x)
      )
    )
  )wasm";
  Module wasm;
  WATParser::parseModule(wasm, moduleText);
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* set = block->list[0]->cast<LocalSet>();
  auto* iff = block->list[1]->cast<If>();
  auto* nopA = iff->ifTrue->cast<Nop>();
  auto* nopB = iff->ifTrue->cast<Nop>();
  auto* nopC = block->list[2]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // No matter which if arm is an obstacle, we we still connect.
  EXPECT_TRUE(graph.setHasGetsDespiteObstacle(set, nopA));
  EXPECT_TRUE(graph.setHasGetsDespiteObstacle(set, nopB));
  // But the nop after the if stops us.
  EXPECT_FALSE(graph.setHasGetsDespiteObstacle(set, nopC));
}

TEST_F(LocalGraphTest, ObstacleUnreachable) {
  auto moduleText = R"wasm(
    (module
      (func $foo (result i32)
        ;; An unreachable between the set and get.
        (local $x i32)
        (local.set $x
          (i32.const 10)
        )
        (nop)
        (unreachable)
        (nop)
        (local.get $x)
      )
    )
  )wasm";
  Module wasm;
  WATParser::parseModule(wasm, moduleText);
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* set = block->list[0]->cast<LocalSet>();
  auto* nopA = block->list[1]->cast<Nop>();
  auto* nopB = block->list[3]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // The get is unreachable, and the set has no gets.
  EXPECT_EQ(graph.getSetInfluences(set).size(), 0U);
  EXPECT_FALSE(graph.setHasGetsDespiteObstacle(set, nopA));
  EXPECT_FALSE(graph.setHasGetsDespiteObstacle(set, nopB));
}

TEST_F(LocalGraphTest, ObstacleMultiGet) {
  auto moduleText = R"wasm(
    (module
      (func $foo
        ;; A set with multiple gets.
        (local $x i32)
        (local.set $x
          (i32.const 10)
        )
        (nop)
        (drop
          (local.get $x)
        )
        (nop)
        (drop
          (local.get $x)
        )
      )
    )
  )wasm";
  Module wasm;
  WATParser::parseModule(wasm, moduleText);
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* set = block->list[0]->cast<LocalSet>();
  auto* nopA = block->list[1]->cast<Nop>();
  auto* nopB = block->list[3]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // The first nop blocks them both, but not the second.
  EXPECT_FALSE(graph.setHasGetsDespiteObstacle(set, nopA));
  EXPECT_TRUE(graph.setHasGetsDespiteObstacle(set, nopB));
}

TEST_F(LocalGraphTest, ObstacleMultiSet) {
  auto moduleText = R"wasm(
    (module
      (func $foo
        ;; Two sets.
        (local $x i32)
        (local.set $x
          (i32.const 10)
        )
        (local.set $x
          (i32.const 20)
        )
        (nop)
        (drop
          (local.get $x)
        )
      )
    )
  )wasm";
  Module wasm;
  WATParser::parseModule(wasm, moduleText);
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* setA = block->list[0]->cast<LocalSet>();
  auto* setB = block->list[1]->cast<LocalSet>();
  auto* nop = block->list[2]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // The first set has no gets, the second has one.
  EXPECT_EQ(graph.getSetInfluences(setA).size(), 0U);
  EXPECT_EQ(graph.getSetInfluences(setB).size(), 1U);
  // The nop blocks on the second (and the first, but it had none anyhow).
  EXPECT_FALSE(graph.setHasGetsDespiteObstacle(setA, nop));
  EXPECT_FALSE(graph.setHasGetsDespiteObstacle(setB, nop));
}

// TODO sets in an if
