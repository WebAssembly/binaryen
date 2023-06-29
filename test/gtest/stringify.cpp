#include "ir/utils.h"
#include "passes/stringify-walker.h"
#include "print-test.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

using StringifyTest = PrintTest;

TEST_F(StringifyTest, Print) {
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
          (i32.const 40)
          (i32.const 5)
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

  auto stringifyText = R"stringify(in visitExpression for block
adding unique symbol
in visitExpression for block $block_a
in visitExpression for block $block_b
in visitExpression for block $block_c
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
in visitExpression for try $try_a
adding unique symbol
in visitExpression for i32.const 40
adding unique symbol
in visitExpression for i32.const 5
adding unique symbol
in visitExpression for nop
adding unique symbol
in visitExpression for i32.const 8
in visitExpression for drop
adding unique symbol
)stringify";

  struct TestStringifyWalker : public StringifyWalker<TestStringifyWalker> {
    std::ostream& os;

    TestStringifyWalker(std::ostream& os) : os(os){};

    void addUniqueSymbol() { this->os << "adding unique symbol\n"; }

    void visitExpression(Expression* curr) {
      this->os << "in visitExpression for "
               << ShallowExpression{curr, getModule()} << std::endl;
    }
  };

  Module wasm;
  parseWast(wasm, moduleText);

  std::stringstream ss;
  TestStringifyWalker stringify = TestStringifyWalker(ss);
  stringify.walkModule(&wasm);

  EXPECT_EQ(ss.str(), stringifyText);
}
