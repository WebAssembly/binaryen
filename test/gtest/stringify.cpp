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

using HashStringifyTest = PrintTest;

TEST_F(HashStringifyTest, Print) {
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

  auto stringifyText = R"stringify(0 - block
1 - unique
2 - block $block_a
3 - block $block_b
4 - block $block_c
2 - block $block_d
4 - block $block_e
5 - block $block_f
6 - unique
7 - i32.const 20
8 - drop
9 - i32.const 10
8 - drop
10 - unique
11 - i32.const 0
12 - if
8 - drop
13 - unique
14 - i32.const 1
15 - if
8 - drop
16 - unique
7 - i32.const 20
8 - drop
9 - i32.const 10
8 - drop
17 - unique
14 - i32.const 1
15 - if
8 - drop
18 - unique
11 - i32.const 0
15 - if
8 - drop
19 - unique
20 - i32.const 40
21 - unique
22 - i32.const 5
23 - unique
24 - i32.const 30
25 - unique
24 - i32.const 30
26 - unique
24 - i32.const 30
27 - unique
)stringify";

  Module wasm;
  parseWast(wasm, moduleText);

  std::stringstream ss;
  HashStringifyWalker stringify = HashStringifyWalker(ss);
  stringify.walkModule(&wasm);

  EXPECT_EQ(ss.str(), stringifyText);
}
