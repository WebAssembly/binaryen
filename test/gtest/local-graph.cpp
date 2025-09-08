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
  ASSERT_FALSE(WATParser::parseModule(wasm, moduleText).getErr());

  // Get access to the contents of the wasm.
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* nopA = block->list[0]->cast<Nop>();
  auto* set = block->list[1]->cast<LocalSet>();
  auto* nopB = block->list[2]->cast<Nop>();
  auto* get = block->list[3]->cast<LocalGet>();

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
    EXPECT_EQ(graph.canMoveSet(set, nopA).size(), 1U);
    EXPECT_EQ(*graph.canMoveSet(set, nopA).begin(), get);
    // But if the second one is an obstacle, it severs the connection.
    EXPECT_EQ(graph.canMoveSet(set, nopB).size(), 0U);
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
  ASSERT_FALSE(WATParser::parseModule(wasm, moduleText).getErr());
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* set = block->list[0]->cast<LocalSet>();
  auto* iff = block->list[1]->cast<If>();
  auto* nopA = iff->ifTrue->cast<Nop>();
  auto* nopB = iff->ifTrue->cast<Nop>();
  auto* nopC = block->list[2]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // No matter which if arm is an obstacle, we still connect.
  EXPECT_EQ(graph.canMoveSet(set, nopA).size(), 1U);
  EXPECT_EQ(graph.canMoveSet(set, nopB).size(), 1U);
  // But the nop after the if stops us.
  EXPECT_EQ(graph.canMoveSet(set, nopC).size(), 0U);
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
  ASSERT_FALSE(WATParser::parseModule(wasm, moduleText).getErr());
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* set = block->list[0]->cast<LocalSet>();
  auto* nopA = block->list[1]->cast<Nop>();
  auto* nopB = block->list[3]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // The get is unreachable, and the set has no gets.
  EXPECT_EQ(graph.getSetInfluences(set).size(), 0U);
  EXPECT_EQ(graph.canMoveSet(set, nopA).size(), 0U);
  EXPECT_EQ(graph.canMoveSet(set, nopB).size(), 0U);
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
        (nop)
      )
    )
  )wasm";
  Module wasm;
  ASSERT_FALSE(WATParser::parseModule(wasm, moduleText).getErr());
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* set = block->list[0]->cast<LocalSet>();
  auto* nopA = block->list[1]->cast<Nop>();
  auto* nopB = block->list[3]->cast<Nop>();
  auto* nopC = block->list[5]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // The first nop blocks them both, but not the second, and the third blocks
  // nothing.
  EXPECT_EQ(graph.canMoveSet(set, nopA).size(), 0U);
  EXPECT_EQ(graph.canMoveSet(set, nopB).size(), 1U);
  EXPECT_EQ(graph.canMoveSet(set, nopC).size(), 2U);
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
  ASSERT_FALSE(WATParser::parseModule(wasm, moduleText).getErr());
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
  EXPECT_EQ(graph.canMoveSet(setA, nop).size(), 0U);
  EXPECT_EQ(graph.canMoveSet(setB, nop).size(), 0U);
}

TEST_F(LocalGraphTest, ObstacleMultiSetIndexes) {
  auto moduleText = R"wasm(
    (module
      (func $foo
        ;; Two sets of different indexes.
        (local $x i32)
        (local $y i32)
        (local.set $x
          (i32.const 10)
        )
        (local.set $y
          (i32.const 20)
        )
        (nop)
        (drop
          (local.get $x)
        )
        (nop)
        (drop
          (local.get $y)
        )
        (nop)
      )
    )
  )wasm";
  Module wasm;
  ASSERT_FALSE(WATParser::parseModule(wasm, moduleText).getErr());
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* setA = block->list[0]->cast<LocalSet>();
  auto* setB = block->list[1]->cast<LocalSet>();
  auto* nopA = block->list[2]->cast<Nop>();
  auto* nopB = block->list[4]->cast<Nop>();
  auto* nopC = block->list[6]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // The first nop blocks them both.
  EXPECT_EQ(graph.canMoveSet(setA, nopA).size(), 0U);
  EXPECT_EQ(graph.canMoveSet(setB, nopA).size(), 0U);
  // The second nop only blocks one.
  EXPECT_EQ(graph.canMoveSet(setA, nopB).size(), 1U);
  EXPECT_EQ(graph.canMoveSet(setB, nopB).size(), 0U);
  // The last nop blocks nothing.
  EXPECT_EQ(graph.canMoveSet(setA, nopC).size(), 1U);
  EXPECT_EQ(graph.canMoveSet(setB, nopC).size(), 1U);
}

TEST_F(LocalGraphTest, ObstacleMultiSetIf) {
  auto moduleText = R"wasm(
    (module
      (func $foo
        ;; Two sets in an if.
        (local $x i32)
        (if
          (i32.const 42)
          (then
            (local.set $x
              (i32.const 10)
            )
          )
          (else
            (local.set $x
              (i32.const 20)
            )
          )
        )
        (nop)
        (drop
          (local.get $x)
        )
        (nop)
      )
    )
  )wasm";
  Module wasm;
  ASSERT_FALSE(WATParser::parseModule(wasm, moduleText).getErr());
  auto* func = wasm.functions[0].get();
  auto* block = func->body->cast<Block>();
  auto* iff = block->list[0]->cast<If>();
  auto* setA = iff->ifTrue->cast<LocalSet>();
  auto* setB = iff->ifFalse->cast<LocalSet>();
  auto* nopA = block->list[1]->cast<Nop>();
  auto* nopB = block->list[3]->cast<Nop>();

  LazyLocalGraph graph(func, &wasm, Nop::SpecificId);
  // Both sets have a get.
  EXPECT_EQ(graph.getSetInfluences(setA).size(), 1U);
  EXPECT_EQ(graph.getSetInfluences(setB).size(), 1U);
  // The first nop blocks both.
  EXPECT_EQ(graph.canMoveSet(setA, nopA).size(), 0U);
  EXPECT_EQ(graph.canMoveSet(setB, nopA).size(), 0U);
  // The first nop blocks neither.
  EXPECT_EQ(graph.canMoveSet(setA, nopB).size(), 1U);
  EXPECT_EQ(graph.canMoveSet(setB, nopB).size(), 1U);
}

TEST_F(LocalGraphTest, ObstacleStructSet) {
  // Use something other than a nop to obstruct. Here we show a realistic
  // situation using GC.
  auto moduleText = R"wasm(
    (module
     (type $struct (struct (field (mut i32))))

     (func $test
      (local $struct (ref null $struct))
      (block $label
       ;; A struct.set that may be skipped by the br in the if.
       (struct.set $struct 0
        (local.tee $struct
         (struct.new_default $struct)
        )
        (if (result i32)
         (i32.const 1)
         (then
          (br $label)
         )
         (else
          (i32.const 0)
         )
        )
       )
      )
      (drop
       (struct.get $struct 0
        (local.get $struct)
       )
      )
     )
    )
  )wasm";
  Module wasm;
  ASSERT_FALSE(WATParser::parseModule(wasm, moduleText).getErr());
  auto* func = wasm.functions[0].get();
  auto* outerBlock = func->body->cast<Block>();
  auto* block = outerBlock->list[0]->cast<Block>();
  auto* structSet = block->list[0]->cast<StructSet>();
  auto* tee = structSet->ref->cast<LocalSet>();

  LazyLocalGraph graph(func, &wasm, StructSet::SpecificId);
  // The tee has one get.
  EXPECT_EQ(graph.getSetInfluences(tee).size(), 1U);
  // The struct.set blocks one path, but not the path that skips it via the br.
  EXPECT_EQ(graph.canMoveSet(tee, structSet).size(), 1U);
}
