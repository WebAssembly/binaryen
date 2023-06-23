#include "passes/stringify-walker.h"
#include "wasm-s-parser.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(StringifyTest, Print) {
  auto moduleText = R"wasm(
    (module
    (tag $catch_a (param i32))
    (func $d
      (block $block_a
        (drop (i32.const 20))
        (drop (i32.const 10))
      )
      (block $block_b
        (drop (if (i32.const 0)
          (then
            (i32.const 40))
          (else
            (i32.const 5))
        ))
      )
      (block $block_c
        (try $try_a
          (do
            (nop)
          )
          (catch $catch_a
            (drop (i32.const 8))
          )
        )
      )
    )
   )
  )wasm";

  auto stringifyText = R"stringify(in visitControlFlow with block
adding unique symbol
in visitControlFlow with block $block_a
in visitControlFlow with block $block_b
in visitControlFlow with block $block_c
adding unique symbol
in visitExpression for i32.const 20
in visitExpression for drop
in visitExpression for i32.const 10
in visitExpression for drop
adding unique symbol
in visitExpression for i32.const 0
in visitControlFlow with if
in visitExpression for drop
adding unique symbol
in visitControlFlow with try $try_a
adding unique symbol
in visitControlFlow with block (result i32)
adding unique symbol
in visitControlFlow with block (result i32)
adding unique symbol
in visitExpression for nop
adding unique symbol
in visitExpression for i32.const 8
in visitExpression for drop
adding unique symbol
in visitExpression for i32.const 40
adding unique symbol
in visitExpression for i32.const 5
adding unique symbol
adding unique symbol
)stringify";

  Module wasm;
  SExpressionParser parser(moduleText);
  SExpressionWasmBuilder builder(wasm, *(*parser.root)[0], IRProfile::Normal);

  bool colors = Colors::isEnabled();
  Colors::setEnabled(false);
  std::stringstream ss;
  TestStringifyWalker stringify = TestStringifyWalker(ss);
  stringify.walkModule(&wasm);
  Colors::setEnabled(colors);

  EXPECT_EQ(ss.str(), stringifyText);
}
