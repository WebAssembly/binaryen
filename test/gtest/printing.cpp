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

  Module wasm;
  parseWast(wasm, moduleText);

  {
    std::stringstream ss;
    ss << *wasm.getFunction("a");
    EXPECT_EQ(ss.str(), R"print((func $a (result i32)
 (i32.const 10)
)
)print");
  }
  {
    std::stringstream ss;
    ss << *wasm.getFunction("b");
    EXPECT_EQ(ss.str(), R"print((func $b
 (drop
  (i32.const 20)
 )
)
)print");
  }
}
