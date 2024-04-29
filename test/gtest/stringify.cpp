#include "ir/utils.h"
#include "passes/stringify-walker.h"
#include "print-test.h"
#include "support/suffix_tree.h"

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
adding unique symbol for Try Body Start
in visitExpression for nop
adding unique symbol for End
adding unique symbol for Try Catch Start
in visitExpression for block
adding unique symbol for End
adding unique symbol for Try Catch Start
in visitExpression for block
adding unique symbol for End
adding unique symbol for Try Body Start
in visitExpression for nop
adding unique symbol for End
adding unique symbol for Try Catch Start
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

static auto dupModuleText = R"wasm(
    (module
      (func $a
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
          (drop (i32.const 20))
          (drop (i32.const 10))
        )
        (block $block_e
          (drop (if (result i32)
            (i32.const 1)
            (then (i32.const 30))
          ))
        )
        (block $block_f
          (drop (if (result i32)
            (i32.const 0)
            (then (i32.const 30))
          ))
        )
      )
    )
  )wasm";

std::vector<uint32_t> hashStringifyModule(Module* wasm) {
  HashStringifyWalker stringify = HashStringifyWalker();
  stringify.walkModule(wasm);
  return stringify.hashString;
}

TEST_F(StringifyTest, Stringify) {
  Module wasm;
  parseWast(wasm, dupModuleText);
  auto hashString = hashStringifyModule(&wasm);

  EXPECT_EQ(hashString,
            (std::vector<uint32_t>{
              (uint32_t)-1,  // function start
              0,             // function block evaluated as a whole
              (uint32_t)-2,  // end
              (uint32_t)-3,  // block start
              1,             // block_a evaluated as a whole
              2,             // block_b evaluated as a whole
              3,             // block_c evaluated as a whole
              1,             // block_d has the same contents as block_a
              3,             // block_e has the same contents as block_c
              4,             // block_f evaluated as a whole
              (uint32_t)-4,  // end
              (uint32_t)-5,  // block start for block_a
              5,             // i32.const 20
              6,             // drop, all drops will be the same symbol
              7,             // i32.const 10
              6,             // drop
              (uint32_t)-6,  // end
              (uint32_t)-7,  // block start for block_b
              8,             // i32.const 0, if condition
              9,             // block_b's if evaluated as a whole
              6,             // drop
              (uint32_t)-8,  // end
              (uint32_t)-9,  // block start for block_c
              10,            // i32.const 1, if condition
              11,            // block_c's if evaluated as a whole
              6,             // drop
              (uint32_t)-10, // end
              (uint32_t)-11, // block start for block_d
              5,             // i32.const 20
              6,             // drop
              7,             // i32.const 10
              6,             // drop
              (uint32_t)-12, // end
              (uint32_t)-13, // block start for block_e
              10,            // i32.const 1, if condition
              11,            // block_e if evaluated as a whole
              6,             // drop
              (uint32_t)-14, // end
              (uint32_t)-15, // block start for block_f
              8,             // i32.const 0, if condition
              11,            // block_f's if evaluated as a whole
              6,             // drop
              (uint32_t)-16, // end
              (uint32_t)-17, // if start in block_b
              12,            // i32.const 40
              (uint32_t)-18, // else start in block_b
              13,            // i32.const 5
              (uint32_t)-19, // end
              (uint32_t)-20, // if start in block_c
              14,            // i32.const 30
              (uint32_t)-21, // end
              (uint32_t)-22, // if start in block_e
              14,            // i32.const 30
              (uint32_t)-23, // end
              (uint32_t)-24, // if start in block_f
              14,            // i32.const 30
              (uint32_t)-25, // end
            }));
}

TEST_F(StringifyTest, Substrings) {
  Module wasm;
  parseWast(wasm, dupModuleText);
  auto hashString = hashStringifyModule(&wasm);
  auto substrings = StringifyProcessor::repeatSubstrings(hashString);

  EXPECT_EQ(
    substrings,
    (std::vector<SuffixTree::RepeatedSubstring>{
      // 5, 6, 7, 6 appears at idx 9 and again at 22
      SuffixTree::RepeatedSubstring{4u, (std::vector<unsigned>{12, 28})},
      // 6, 7, 6 appears at idx 10 and again at 23
      SuffixTree::RepeatedSubstring{3u, (std::vector<unsigned>{13, 29})},
      // 10, 11, 6 appears at idx 18 and again at 27
      SuffixTree::RepeatedSubstring{3u, (std::vector<unsigned>{23, 34})},
      // 11, 6 appears at idx 32, 19 and again at 28
      SuffixTree::RepeatedSubstring{2u, (std::vector<unsigned>{24, 35, 40})},
      // 7, 6 appears at idx 11 and again at 24
      SuffixTree::RepeatedSubstring{2u, (std::vector<unsigned>{14, 30})}}));
}

TEST_F(StringifyTest, DedupeSubstrings) {
  Module wasm;
  parseWast(wasm, dupModuleText);
  auto hashString = hashStringifyModule(&wasm);
  std::vector<SuffixTree::RepeatedSubstring> substrings =
    StringifyProcessor::repeatSubstrings(hashString);
  auto result = StringifyProcessor::dedupe(substrings);

  EXPECT_EQ(
    result,
    (std::vector<SuffixTree::RepeatedSubstring>{
      // 5, 6, 7, 6 appears at idx 12 and again at 28
      SuffixTree::RepeatedSubstring{4u, (std::vector<unsigned>{12, 28})},
      // 10, 11, 6 appears at idx 23 and again at 34
      SuffixTree::RepeatedSubstring{3u, (std::vector<unsigned>{23, 34})}}));
}

TEST_F(StringifyTest, FilterLocalSets) {
  static auto localSetModuleText = R"wasm(
  (module
    (func $a (result i32)
        (local $x i32)
        (local.set $x
          (i32.const 1)
        )
      (i32.const 0)
      (i32.const 1)
    )
    (func $b (result i32)
        (local $x i32)
        (local.set $x
          (i32.const 1)
        )
      (i32.const 5)
      (i32.const 0)
      (i32.const 1)
    )
  )
  )wasm";
  Module wasm;
  parseWast(wasm, localSetModuleText);
  HashStringifyWalker stringify = HashStringifyWalker();
  stringify.walkModule(&wasm);
  auto substrings = StringifyProcessor::repeatSubstrings(stringify.hashString);
  auto result =
    StringifyProcessor::filterLocalSets(substrings, stringify.exprs);

  EXPECT_EQ(
    result,
    (std::vector<SuffixTree::RepeatedSubstring>{
      // sequence i32.const 0, i32.const 1 appears at idx 6 and again at 16
      SuffixTree::RepeatedSubstring{2u, (std::vector<unsigned>{6, 16})}}));
}

// TODO: Switching to the new parser broke this test. Fix it.

// TEST_F(StringifyTest, FilterBranches) {
//   static auto branchesModuleText = R"wasm(
//   (module
//     (func $a (result i32)
//       (block $top (result i32)
//         (br $top)
//       )
//       (i32.const 7)
//       (i32.const 1)
//       (i32.const 2)
//       (i32.const 4)
//       (i32.const 3)
//       (return)
//     )
//     (func $b (result i32)
//       (block $top (result i32)
//         (br $top)
//       )
//       (i32.const 0)
//       (i32.const 1)
//       (i32.const 2)
//       (i32.const 5)
//       (i32.const 3)
//       (return)
//     )
//   )
//   )wasm";
//   Module wasm;
//   parseWast(wasm, branchesModuleText);
//   HashStringifyWalker stringify = HashStringifyWalker();
//   stringify.walkModule(&wasm);
//   auto substrings =
//   StringifyProcessor::repeatSubstrings(stringify.hashString);
//   auto result =
//   StringifyProcessor::filterBranches(substrings, stringify.exprs);

//   EXPECT_EQ(
//     result,
//     (std::vector<SuffixTree::RepeatedSubstring>{
//       // sequence i32.const 1, i32.const 2 is at idx 6 and 21
//       SuffixTree::RepeatedSubstring{2u, (std::vector<unsigned>{6, 21})}}));
// }
