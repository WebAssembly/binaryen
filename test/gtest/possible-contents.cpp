#include "ir/possible-contents.h"
#include "wasm-s-parser.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

// Asserts a == b, in any order.
template<typename T> void assertEqualSymmetric(const T& a, const T& b) {
  EXPECT_EQ(a, b);
  EXPECT_EQ(b, a);
  EXPECT_PRED2([](const T& a, const T& b) { return !(a != b); }, a, b);
  EXPECT_PRED2([](const T& a, const T& b) { return !(b != a); }, a, b);
}

// Asserts a != b, in any order.
template<typename T> void assertNotEqualSymmetric(const T& a, const T& b) {
  EXPECT_NE(a, b);
  EXPECT_NE(b, a);
  EXPECT_PRED2([](const T& a, const T& b) { return !(a == b); }, a, b);
  EXPECT_PRED2([](const T& a, const T& b) { return !(b == a); }, a, b);
}

// Asserts a combined with b (in any order) is equal to c.
template<typename T>
void assertCombination(const T& a, const T& b, const T& c) {
  T temp1 = a;
  temp1.combine(b);
  assertEqualSymmetric(temp1, c);

  T temp2 = b;
  temp2.combine(a);
  assertEqualSymmetric(temp2, c);
}

// Parse a module from text and return it.
static std::unique_ptr<Module> parse(std::string module) {
  auto wasm = std::make_unique<Module>();
  wasm->features = FeatureSet::All;
  try {
    SExpressionParser parser(&module.front());
    Element& root = *parser.root;
    SExpressionWasmBuilder builder(*wasm, *root[0], IRProfile::Normal);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing wasm text";
  }
  return wasm;
};

// We want to declare a bunch of globals that are used in various tests. Doing
// so in the global scope is risky, as their constructors use types, and the
// type system itself uses global constructors. Instead, we use a fixture for
// that.
class PossibleContentsTest : public testing::Test {
protected:
  void SetUp() override {
    // Use nominal typing to test struct types.
    wasm::setTypeSystem(TypeSystem::Nominal);
  }

  Type anyref = Type(HeapType::any, Nullable);
  Type funcref = Type(HeapType::func, Nullable);

  PossibleContents none = PossibleContents::none();

  PossibleContents i32Zero = PossibleContents::literal(Literal(int32_t(0)));
  PossibleContents i32One = PossibleContents::literal(Literal(int32_t(1)));
  PossibleContents f64One = PossibleContents::literal(Literal(double(1)));
  PossibleContents anyNull =
    PossibleContents::literal(Literal::makeNull(HeapType::any));
  PossibleContents funcNull =
    PossibleContents::literal(Literal::makeNull(HeapType::func));

  PossibleContents i32Global1 =
    PossibleContents::global("i32Global1", Type::i32);
  PossibleContents i32Global2 =
    PossibleContents::global("i32Global2", Type::i32);
  PossibleContents f64Global = PossibleContents::global("f64Global", Type::f64);
  PossibleContents anyGlobal = PossibleContents::global("anyGlobal", anyref);

  PossibleContents nonNullFunc = PossibleContents::literal(
    Literal("func", Type(Signature(Type::none, Type::none), NonNullable)));

  PossibleContents exactI32 = PossibleContents::exactType(Type::i32);
  PossibleContents exactAnyref = PossibleContents::exactType(anyref);
  PossibleContents exactFuncref = PossibleContents::exactType(funcref);
  PossibleContents exactNonNullAnyref =
    PossibleContents::exactType(Type(HeapType::any, NonNullable));
  PossibleContents exactNonNullFuncref =
    PossibleContents::exactType(Type(HeapType::func, NonNullable));

  PossibleContents exactFuncSignatureType = PossibleContents::exactType(
    Type(Signature(Type::none, Type::none), Nullable));
  PossibleContents exactNonNullFuncSignatureType = PossibleContents::exactType(
    Type(Signature(Type::none, Type::none), NonNullable));

  PossibleContents many = PossibleContents::many();
};

TEST_F(PossibleContentsTest, TestComparisons) {
  assertEqualSymmetric(none, none);
  assertNotEqualSymmetric(none, i32Zero);
  assertNotEqualSymmetric(none, i32Global1);
  assertNotEqualSymmetric(none, exactI32);
  assertNotEqualSymmetric(none, many);

  assertEqualSymmetric(i32Zero, i32Zero);
  assertNotEqualSymmetric(i32Zero, i32One);
  assertNotEqualSymmetric(i32Zero, f64One);
  assertNotEqualSymmetric(i32Zero, i32Global1);
  assertNotEqualSymmetric(i32Zero, exactI32);
  assertNotEqualSymmetric(i32Zero, many);

  assertEqualSymmetric(i32Global1, i32Global1);
  assertNotEqualSymmetric(i32Global1, i32Global2);
  assertNotEqualSymmetric(i32Global1, exactI32);
  assertNotEqualSymmetric(i32Global1, many);

  assertEqualSymmetric(exactI32, exactI32);
  assertNotEqualSymmetric(exactI32, exactAnyref);
  assertNotEqualSymmetric(exactI32, many);

  assertEqualSymmetric(many, many);

  // Nulls

  assertNotEqualSymmetric(i32Zero, anyNull);
  assertEqualSymmetric(anyNull, anyNull);
  assertEqualSymmetric(anyNull, funcNull); // All nulls compare equal.

  assertEqualSymmetric(exactNonNullAnyref, exactNonNullAnyref);
  assertNotEqualSymmetric(exactNonNullAnyref, exactAnyref);
}

TEST_F(PossibleContentsTest, TestCombinations) {
  // None with anything else becomes the other thing.
  assertCombination(none, none, none);
  assertCombination(none, i32Zero, i32Zero);
  assertCombination(none, i32Global1, i32Global1);
  assertCombination(none, exactI32, exactI32);
  assertCombination(none, many, many);

  // i32(0) will become Many, unless the value or the type is identical.
  assertCombination(i32Zero, i32Zero, i32Zero);
  assertCombination(i32Zero, i32One, exactI32);
  assertCombination(i32Zero, f64One, many);
  assertCombination(i32Zero, i32Global1, exactI32);
  assertCombination(i32Zero, f64Global, many);
  assertCombination(i32Zero, exactI32, exactI32);
  assertCombination(i32Zero, exactAnyref, many);
  assertCombination(i32Zero, many, many);

  assertCombination(i32Global1, i32Global1, i32Global1);
  assertCombination(i32Global1, i32Global2, exactI32);
  assertCombination(i32Global1, f64Global, many);
  assertCombination(i32Global1, exactI32, exactI32);
  assertCombination(i32Global1, exactAnyref, many);
  assertCombination(i32Global1, many, many);

  assertCombination(exactI32, exactI32, exactI32);
  assertCombination(exactI32, exactAnyref, many);
  assertCombination(exactI32, many, many);

  assertCombination(many, many, many);

  // Exact references: An exact reference only stays exact when combined with
  // the same heap type (nullability may be added, but nothing else).
  assertCombination(exactFuncref, exactAnyref, many);
  assertCombination(exactFuncref, anyGlobal, many);
  assertCombination(exactFuncref, nonNullFunc, many);
  assertCombination(exactFuncref, exactFuncref, exactFuncref);
  assertCombination(exactFuncref, exactNonNullFuncref, exactFuncref);

  // Nulls.

  assertCombination(anyNull, i32Zero, many);
  assertCombination(anyNull, anyNull, anyNull);
  assertCombination(anyNull, exactAnyref, exactAnyref);

  // Two nulls go to the lub.
  assertCombination(anyNull, funcNull, anyNull);

  assertCombination(exactNonNullAnyref, exactNonNullAnyref, exactNonNullAnyref);

  // If one is a null and the other is not, it makes the one that is not a
  // null be a nullable type - but keeps the heap type of the other (since the
  // type of the null does not matter, all nulls compare equal).
  assertCombination(anyNull, exactNonNullAnyref, exactAnyref);
  assertCombination(anyNull, exactNonNullFuncref, exactFuncref);

  // Funcrefs

  // A function reference + a null becomes an exact type (of that sig), plus
  // nullability.
  assertCombination(nonNullFunc, anyNull, exactFuncSignatureType);
  assertCombination(nonNullFunc, funcNull, exactFuncSignatureType);
  assertCombination(exactFuncSignatureType, funcNull, exactFuncSignatureType);
  assertCombination(
    exactNonNullFuncSignatureType, funcNull, exactFuncSignatureType);
  assertCombination(
    nonNullFunc, exactFuncSignatureType, exactFuncSignatureType);
  assertCombination(
    nonNullFunc, exactNonNullFuncSignatureType, exactNonNullFuncSignatureType);
  assertCombination(nonNullFunc, exactI32, many);

  // Globals vs nulls.

  assertCombination(anyGlobal, anyNull, many);
  assertCombination(anyGlobal, funcNull, many);
}

TEST_F(PossibleContentsTest, TestOracleMinimal) {
  // A minimal test of the public API of PossibleTypesOracle. See the lit test
  // for coverage of all the internals (using lit makes the result more
  // fuzzable).
  auto wasm = parse(R"(
    (module
      (global $null (ref null any) (ref.null any))
      (global $something i32 (i32.const 42))
    )
  )");
  ContentOracle oracle(*wasm);

  // This will be a null constant.
  EXPECT_TRUE(oracle.getContents(GlobalLocation{"null"}).isNull());

  // This will be 42.
  EXPECT_EQ(oracle.getContents(GlobalLocation{"something"}).getLiteral(),
            Literal(int32_t(42)));
}

TEST_F(PossibleContentsTest, TestOracleManyTypes) {
  // Test for a node with many possible types. The pass limits how many it
  // notices to not use excessive memory, so even though 4 are possible here,
  // we'll just report that more than one is possible ("many").
  auto wasm = parse(R"(
    (module
      (type $A (struct_subtype (field i32) data))
      (type $B (struct_subtype (field i64) data))
      (type $C (struct_subtype (field f32) data))
      (type $D (struct_subtype (field f64) data))
      (func $foo (result (ref any))
        (select (result (ref any))
          (select (result (ref any))
            (struct.new $A)
            (struct.new $B)
            (i32.const 0)
          )
          (select (result (ref any))
            (struct.new $C)
            (struct.new $D)
            (i32.const 0)
          )
          (i32.const 0)
        )
      )
    )
  )");
  ContentOracle oracle(*wasm);
  // The function's body should be Many.
  EXPECT_TRUE(
    oracle.getContents(ResultLocation{wasm->getFunction("foo"), 0}).isMany());
}
