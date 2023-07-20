#include "print-test.h"

#include "wasm.h"

using namespace wasm;

using PrintingTest = PrintTest;

TEST_F(PrintingTest, Print) {
  auto moduleText = R"wasm(
    (module
      (func $a (result i32)
        (i32.const 10)
      )
      (func $b
        (drop
          (i32.const 20)
        )
      )
    )
  )wasm";

  auto printText = R"print(
(func $a (result i32)
 (i32.const 10)
)

And the other function:

(func $b
 (drop
  (i32.const 20)
 )
)
)print";

  Module wasm;
  parseWast(wasm, moduleText);

  std::stringstream ss;
  ss << '\n';
  ss << *wasm.getFunction("a") << '\n';
  ss << "And the other function:\n\n";
  ss << *wasm.getFunction("b");

  EXPECT_EQ(ss.str(), printText);
}
