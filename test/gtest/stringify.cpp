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

Module wasm;
SExpressionParser parser(moduleText);
SExpressionWasmBuilder builder(wasm, *(*parser.root)[0], IRProfile::Normal);

