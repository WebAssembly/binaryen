#include "dataflow/graph.h"
#include "dataflow/node.h"
#include "parser/wat-parser.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;
using namespace wasm::DataFlow;

class DataflowTest : public ::testing::Test {
protected:
  void parseWast(Module& wasm, const std::string& wast) {
    auto parsed = WATParser::parseModule(wasm, wast);
    if (auto* err = parsed.getErr()) {
      Fatal() << err->msg << "\n";
    }
  }
};

// Regression test for https://github.com/WebAssembly/binaryen/issues/8273
// In the no-else case, mergeIf arguments were swapped: the initial state
// (before the if body) was paired with the ifTrue condition and the
// afterIfTrue state was paired with ifFalse. This test verifies the fix.
TEST_F(DataflowTest, IfNoElseMergeOrder) {
  auto moduleText = R"wasm(
    (module
      (func $test (param $cond i32)
        (local $x i32)
        (local.set $x (i32.const 10))
        (if (local.get $cond)
          (then
            (local.set $x (i32.const 42))
          )
        )
        (drop (local.get $x))
      )
    )
  )wasm";

  Module wasm;
  parseWast(wasm, moduleText);

  auto* func = wasm.getFunction("test");
  Graph graph;
  graph.build(func, &wasm);

  // Find the phi node for local $x (index 1).
  Node* phi = nullptr;
  for (auto& node : graph.nodes) {
    if (node->isPhi() && node->index == 1) {
      phi = node.get();
      break;
    }
  }
  ASSERT_NE(phi, nullptr) << "Expected a phi node for local $x";

  // Phi structure: values[0] = block, values[1] = ifTrue value,
  // values[2] = ifFalse value.
  ASSERT_EQ(phi->values.size(), 3u);

  auto* ifTrueNode = phi->values[1];
  auto* ifFalseNode = phi->values[2];

  ASSERT_TRUE(ifTrueNode->isConst());
  ASSERT_TRUE(ifFalseNode->isConst());

  int32_t ifTrueValue = ifTrueNode->expr->cast<Const>()->value.geti32();
  int32_t ifFalseValue = ifFalseNode->expr->cast<Const>()->value.geti32();

  // When condition is true (body ran), $x should be 42.
  EXPECT_EQ(ifTrueValue, 42)
    << "When condition is TRUE, phi should select 42 (set in ifTrue body)";
  // When condition is false (body skipped), $x should be 10 (initial value).
  EXPECT_EQ(ifFalseValue, 10)
    << "When condition is FALSE, phi should select 10 (initial value)";
}
