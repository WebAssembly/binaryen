#include "ir/utils.h"
#include "passes/stringify-walker.h"
#include "print-test.h"

using namespace wasm;

using StringifyTest = PrintTest;

TEST_F(StringifyTest, Print) {
  auto moduleText = R"wasm(
    (module
    (tag $catch_a (param i32))
    (tag $catch_b (param i32))
    (tag $catch_c (param i32))
    (func $d
      (block $block_a
        (drop (i32.const 20))
        (drop (i32.const 10))
      )
      (block $block_b
        (drop (if (i32.const 0)
          (i32.const 40)
          (i32.const 5)
        ))
      )
      (block $block_c
        (drop (if (i32.const 1)
          (i32.const 30)
        ))
      )
      (block $block_d
        (try $try_a
          (do
            (nop)
          )
          (catch $catch_a
            (drop (i32.const 8))
          )
          (catch $catch_b
            (drop (i32.const 15))
          )
        )
      )
      (block $block_e
        (try $try_b
          (do
            (nop)
          )
          (catch $catch_c
            (drop (i32.const 33))
          )
        )
      )
    )
   )
  )wasm";

  auto stringifyText = R"stringify(in visitExpression for block
adding unique symbol
in visitExpression for block $block_a
in visitExpression for block $block_b
in visitExpression for block $block_c
in visitExpression for block $block_d
in visitExpression for block $block_e
adding unique symbol
in visitExpression for i32.const 20
in visitExpression for drop
in visitExpression for i32.const 10
in visitExpression for drop
adding unique symbol
in visitExpression for i32.const 0
in visitExpression for if
in visitExpression for drop
adding unique symbol
in visitExpression for i32.const 1
in visitExpression for if
in visitExpression for drop
adding unique symbol
in visitExpression for try $try_a
adding unique symbol
in visitExpression for try $try_b
adding unique symbol
in visitExpression for i32.const 40
adding unique symbol
in visitExpression for i32.const 5
adding unique symbol
in visitExpression for i32.const 30
adding unique symbol
in visitExpression for nop
adding unique symbol
in visitExpression for i32.const 8
in visitExpression for drop
adding unique symbol
in visitExpression for i32.const 15
in visitExpression for drop
adding unique symbol
in visitExpression for nop
adding unique symbol
in visitExpression for i32.const 33
in visitExpression for drop
adding unique symbol
)stringify";

  struct TestStringifyWalker : public StringifyWalker<TestStringifyWalker> {
    std::ostream& os;

    TestStringifyWalker(std::ostream& os) : os(os){};

    void addUniqueSymbol() { os << "adding unique symbol\n"; }

    void visitExpression(Expression* curr) {
      os << "in visitExpression for " << ShallowExpression{curr, getModule()}
         << std::endl;
    }
  };

  Module wasm;
  parseWast(wasm, moduleText);

  std::stringstream ss;
  TestStringifyWalker stringify = TestStringifyWalker(ss);
  stringify.walkModule(&wasm);

  EXPECT_EQ(ss.str(), stringifyText);
}

TEST_F(StringifyTest, Stringify) {
  auto moduleText = R"wasm(
    (module
    (func $a
      (block $block_a
        (drop (i32.const 20))
        (drop (i32.const 10))
      )
      (block $block_b
        (drop (if (i32.const 0)
          (i32.const 40)
          (i32.const 5)
        ))
      )
      (block $block_c
        (drop (if (i32.const 1)
          (i32.const 30)
        ))
      )
      (block $block_d
        (drop (i32.const 20))
        (drop (i32.const 10))
      )
      (block $block_e
        (drop (if (i32.const 1)
          (i32.const 30)
        ))
      )
      (block $block_f
        (drop (if (i32.const 0)
          (i32.const 30)
        ))
      )
    )
   )
  )wasm";

  Module wasm;
  parseWast(wasm, moduleText);

  HashStringifyWalker stringify = HashStringifyWalker();
  stringify.walkModule(&wasm);

  EXPECT_EQ(stringify.hashString,
            (std::vector<uint32_t>{
              0,             // function block evaluated as a whole
              (uint32_t)-1,  // separate function block from function contents
              1,             // block_a evaluated as a whole
              2,             // block_b evaluated as a whole
              3,             // block_c evaluated as a whole
              1,             // block_d has the same contents as block_a
              3,             // block_e has the same contents as block_c
              4,             // block_f evaluated as a whole
              (uint32_t)-2,  // separate blocks from block contents
              5,             // i32.const 20
              6,             // drop, all drops will be the same symbol
              7,             // i32.const 10
              6,             // drop
              (uint32_t)-3,  // separate block_a contents
              8,             // i32.const 0, if condition
              9,             // block_b's if evaluated as a whole
              6,             // drop
              (uint32_t)-4,  // separate block_b contents
              10,            // i32.const 1, if condition
              11,            // block_c's if evaluated as a whole
              6,             // drop
              (uint32_t)-5,  // separate block_c contents
              5,             // i32.const 20
              6,             // drop
              7,             // i32.const 10
              6,             // drop
              (uint32_t)-6,  // separate block_d contents
              10,            // i32.const 1, if condition
              11,            // block_e if evaluated as a whole
              6,             // drop
              (uint32_t)-7,  // separate block_e contents
              8,             // i32.const 0, if condition
              11,            // block_f's if evaluated as a whole
              6,             // drop
              (uint32_t)-8,  // separate block_f contents
              12,            // i32.const 40
              (uint32_t)-9,  // separate block_b if-true
              13,            // i32.const 5
              (uint32_t)-10, // separate block_b if-false
              14,            // i32.const 30
              (uint32_t)-11, // separate block_c if-true
              14,            // i32.const 30
              (uint32_t)-12, // separate block_e if-true
              14,            // i32.const 30
              (uint32_t)-13  // separate block_f if-true
            }));
}
