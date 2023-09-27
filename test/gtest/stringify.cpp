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
    )
   )
  )wasm";

  auto stringifyText = R"stringify(adding unique symbol for Func Start
in visitExpression for block
adding unique symbol for Func End
adding unique symbol for Block Start
in visitExpression for block $block_a
in visitExpression for block $block_b
in visitExpression for block $block_c
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for i32.const 20
in visitExpression for drop
in visitExpression for i32.const 10
in visitExpression for drop
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for i32.const 0
in visitExpression for if
in visitExpression for drop
adding unique symbol for End
adding unique symbol for Block Start
in visitExpression for i32.const 1
in visitExpression for if
in visitExpression for drop
adding unique symbol for End
adding unique symbol for If Start
in visitExpression for i32.const 40
adding unique symbol for End
adding unique symbol for Else Start
in visitExpression for i32.const 5
adding unique symbol for End
adding unique symbol for If Start
in visitExpression for i32.const 30
adding unique symbol for End
)stringify";

  struct TestStringifyWalker : public StringifyWalker<TestStringifyWalker> {
    std::ostream& os;

    TestStringifyWalker(std::ostream& os) : os(os){};

    void addUniqueSymbol(SeparatorCtx ctx) {
      os << "adding unique symbol for " << ctx << "\n";
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

std::vector<uint32_t> hashStringifyModule(Module* wasm) {
  HashStringifyWalker stringify = HashStringifyWalker();
  stringify.walkModule(wasm);
  return std::move(stringify.hashString);
}

TEST_F(StringifyTest, Stringify) {
  Module wasm;
  parseWast(wasm, dupModuleText);
  auto hashString = hashStringifyModule(&wasm);

  EXPECT_EQ(hashString,
            (std::vector<uint32_t>{
              (uint32_t)-1,  // function start
              0,             // function block evaluated as a whole
              (uint32_t)-2,  // function end
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
              (uint32_t)-18, // end
              (uint32_t)-19, // else start in block_b
              13,            // i32.const 5
              (uint32_t)-20, // end
              (uint32_t)-21, // if start in block_c
              14,            // i32.const 30
              (uint32_t)-22, // end
              (uint32_t)-23, // if start in block_d
              14,            // i32.const 30
              (uint32_t)-24, // end
              (uint32_t)-25, // if start in block_e
              14,            // i32.const 30
              (uint32_t)-26, // end
            }));
}

std::vector<SuffixTree::RepeatedSubstring>
repeatSubstrings(std::vector<uint32_t> hashString) {
  SuffixTree st(hashString);
  std::vector<SuffixTree::RepeatedSubstring> substrings =
    std::vector(st.begin(), st.end());
  std::sort(
    substrings.begin(),
    substrings.end(),
    [](SuffixTree::RepeatedSubstring a, SuffixTree::RepeatedSubstring b) {
      size_t aWeight = a.Length * a.StartIndices.size();
      size_t bWeight = b.Length * b.StartIndices.size();
      if (aWeight == bWeight) {
        return a.StartIndices[0] < b.StartIndices[0];
      }
      return aWeight > bWeight;
    });
  return substrings;
}

TEST_F(StringifyTest, Substrings) {
  Module wasm;
  parseWast(wasm, dupModuleText);
  auto hashString = hashStringifyModule(&wasm);
  auto substrings = repeatSubstrings(hashString);

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
      SuffixTree::RepeatedSubstring{2u, (std::vector<unsigned>{40, 24, 35})},
      // 7, 6 appears at idx 11 and again at 24
      SuffixTree::RepeatedSubstring{2u, (std::vector<unsigned>{14, 30})}}));
}

TEST_F(StringifyTest, DedupeSubstrings) {
  Module wasm;
  parseWast(wasm, dupModuleText);
  auto hashString = hashStringifyModule(&wasm);
  std::vector<SuffixTree::RepeatedSubstring> substrings =
    repeatSubstrings(hashString);
  auto result = StringifyProcessor::dedupe(substrings);

  EXPECT_EQ(
    result,
    (std::vector<SuffixTree::RepeatedSubstring>{
      // 5, 6, 7, 6 appears at idx 9 and again at 22
      SuffixTree::RepeatedSubstring{4u, (std::vector<unsigned>{9, 22})},
      // 10, 11, 6 appears at idx 18 and again at 27
      SuffixTree::RepeatedSubstring{3u, (std::vector<unsigned>{18, 27})}}));
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
  )
  (func $b (result i32)
      (local $x i32)
      (local.set $x
        (i32.const 1)
      )
    (i32.const 0)
  )
  )
  )wasm";
  Module wasm;
  parseWast(wasm, localSetModuleText);
  HashStringifyWalker stringify = HashStringifyWalker();
  stringify.walkModule(&wasm);
  std::vector<SuffixTree::RepeatedSubstring> substrings =
    repeatSubstrings(stringify.hashString);
  auto result =
    StringifyProcessor::filterLocalSets(substrings, stringify.exprs);

  EXPECT_EQ(
    result,
    (std::vector<SuffixTree::RepeatedSubstring>{
      // 5, 6, 7, 6 appears at idx 9 and again at 22
      SuffixTree::RepeatedSubstring{4u, (std::vector<unsigned>{9, 22})},
      // 10, 11, 6 appears at idx 18 and again at 27
      SuffixTree::RepeatedSubstring{3u, (std::vector<unsigned>{18, 27})}}));
}
