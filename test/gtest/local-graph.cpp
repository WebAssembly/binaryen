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
