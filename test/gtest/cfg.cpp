#include "analysis/cfg.h"
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
            (block
              (loop $loop
                (br_if $loop
                  (i32.const 2)
                )
              )
              (i32.const 3)
            )
            (return
              (i32.const 4)
            )
          )
        )
      )
    )
  )wasm";

  auto cfgText = R"cfg(;; preds: [], succs: [1, 5]
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
  7: block

;; preds: [0], succs: []
5:
  8: i32.const 4
  9: return

;; preds: [4], succs: []
6:
  10: drop
  11: block
)cfg";

  Module wasm;
  parseWast(wasm, moduleText);

  CFG cfg = CFG::fromFunction(wasm.getFunction("foo"));

  std::stringstream ss;
  cfg.print(ss);

  EXPECT_EQ(ss.str(), cfgText);
}
