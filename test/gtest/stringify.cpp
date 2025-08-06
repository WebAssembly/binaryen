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
        (drop (if (result i32)
          (i32.const 0)
          (then (i32.const 40))
          (else (i32.const 5))
        ))
      )
      (block $block_c
        (drop (if (result i32)
          (i32.const 1)
          (then (i32.const 30))
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

  auto stringifyText = R"stringify(adding unique symbol for Func Start
in visitExpression for block
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for block $block_a
in visitExpression for block $block_b
in visitExpression for block $block_c
in visitExpression for block $block_d
in visitExpression for block $block_e
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for i32.const 20
in visitExpression for drop
in visitExpression for i32.const 10
in visitExpression for drop
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for i32.const 0
in visitExpression for if (result i32)
in visitExpression for drop
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for i32.const 1
in visitExpression for if (result i32)
in visitExpression for drop
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for try $try_a
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for try $try_b
adding unique symbol for End
adding unique symbol for If Start
in visitExpression for i32.const 40
adding unique symbol for Else Start
in visitExpression for i32.const 5
adding unique symbol for End
adding unique symbol for If Start
in visitExpression for i32.const 30
adding unique symbol for End
adding unique symbol for Try Start
in visitExpression for nop
adding unique symbol for Catch Start
in visitExpression for block
adding unique symbol for Catch Start
in visitExpression for block
adding unique symbol for End
adding unique symbol for Try Start
in visitExpression for nop
adding unique symbol for Catch Start
in visitExpression for block
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for pop i32
in visitExpression for i32.const 8
in visitExpression for drop
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for pop i32
in visitExpression for i32.const 15
in visitExpression for drop
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for pop i32
in visitExpression for i32.const 33
in visitExpression for drop
adding unique symbol for End
)stringify";

  struct TestStringifyWalker : public StringifyWalker<TestStringifyWalker> {
    std::ostream& os;

    TestStringifyWalker(std::ostream& os) : os(os){};

    void addUniqueSymbol(SeparatorReason reason) {
      os << "adding unique symbol for " << reason << "\n";
    }

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
