#include "passes/stringify-walker.h"
#include "wasm-s-parser.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(StringifyTest, Print) {
  auto moduleText = R"wasm(
    (module
      (func $foo
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
      )
    )
  )wasm";

  auto stringifyText = R"stringify(

  )stringify";

  Module wasm;
  SExpressionParser parser(moduleText);
  SExpressionWasmBuilder builder(wasm, *(*parser.root)[0], IRProfile::Normal);

  TestStringifyWalker stringify = TestStringifyWalker();
  stringify.walkModule(&wasm);

  bool colors = Colors::isEnabled();
  Colors::setEnabled(false);
  std::stringstream ss;
  //stringify.print(ss);
  Colors::setEnabled(colors);

  EXPECT_EQ(ss.str(), stringifyText);
}
