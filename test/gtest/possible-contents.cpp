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
  // Also check the type, as nulls will compare equal even if their types
  // differ. We want to make sure even the types are identical.
  assertEqualSymmetric(temp1.getType(), c.getType());

  T temp2 = b;
  temp2.combine(a);
  assertEqualSymmetric(temp2, c);
  assertEqualSymmetric(temp2.getType(), c.getType());
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
  Type i31ref = Type(HeapType::i31, Nullable);

  PossibleContents none = PossibleContents::none();

  PossibleContents i32Zero = PossibleContents::literal(Literal(int32_t(0)));
  PossibleContents i32One = PossibleContents::literal(Literal(int32_t(1)));
  PossibleContents f64One = PossibleContents::literal(Literal(double(1)));
  PossibleContents anyNull =
    PossibleContents::literal(Literal::makeNull(HeapType::any));
  PossibleContents funcNull =
    PossibleContents::literal(Literal::makeNull(HeapType::func));
  PossibleContents i31Null =
    PossibleContents::literal(Literal::makeNull(HeapType::i31));

  PossibleContents i32Global1 =
    PossibleContents::global("i32Global1", Type::i32);
  PossibleContents i32Global2 =
    PossibleContents::global("i32Global2", Type::i32);
  PossibleContents f64Global = PossibleContents::global("f64Global", Type::f64);
  PossibleContents anyGlobal = PossibleContents::global("anyGlobal", anyref);
  PossibleContents funcGlobal = PossibleContents::global("funcGlobal", funcref);
  PossibleContents nonNullFuncGlobal =
    PossibleContents::global("funcGlobal", Type(HeapType::func, NonNullable));

  PossibleContents nonNullFunc = PossibleContents::literal(
    Literal("func", Signature(Type::none, Type::none)));

  PossibleContents exactI32 = PossibleContents::exactType(Type::i32);
  PossibleContents exactAnyref = PossibleContents::exactType(anyref);
  PossibleContents exactFuncref = PossibleContents::exactType(funcref);
  PossibleContents exactI31ref = PossibleContents::exactType(i31ref);
  PossibleContents exactNonNullAnyref =
    PossibleContents::exactType(Type(HeapType::any, NonNullable));
  PossibleContents exactNonNullFuncref =
    PossibleContents::exactType(Type(HeapType::func, NonNullable));
  PossibleContents exactNonNullI31ref =
    PossibleContents::exactType(Type(HeapType::i31, NonNullable));

  PossibleContents exactFuncSignatureType = PossibleContents::exactType(
    Type(Signature(Type::none, Type::none), Nullable));
  PossibleContents exactNonNullFuncSignatureType = PossibleContents::exactType(
    Type(Signature(Type::none, Type::none), NonNullable));

  PossibleContents many = PossibleContents::many();

  PossibleContents coneAnyref = PossibleContents::fullConeType(anyref);
  PossibleContents coneFuncref = PossibleContents::fullConeType(funcref);
  PossibleContents coneFuncref1 = PossibleContents::coneType(funcref, 1);
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

TEST_F(PossibleContentsTest, TestHash) {
  // Hashes should be deterministic.
  EXPECT_EQ(none.hash(), none.hash());
  EXPECT_EQ(many.hash(), many.hash());

  // Hashes should be different. (In theory hash collisions could appear here,
  // but if such simple things collide and the test fails then we should really
  // rethink our hash functions!)
  EXPECT_NE(none.hash(), many.hash());
  EXPECT_NE(none.hash(), i32Zero.hash());
  EXPECT_NE(none.hash(), i32One.hash());
  EXPECT_NE(none.hash(), anyGlobal.hash());
  EXPECT_NE(none.hash(), funcGlobal.hash());
  EXPECT_NE(none.hash(), exactAnyref.hash());
  EXPECT_NE(none.hash(), exactFuncSignatureType.hash());
  EXPECT_NE(none.hash(), coneAnyref.hash());
  EXPECT_NE(none.hash(), coneFuncref.hash());
  EXPECT_NE(none.hash(), coneFuncref1.hash());

  EXPECT_NE(i32Zero.hash(), i32One.hash());
  EXPECT_NE(anyGlobal.hash(), funcGlobal.hash());
  EXPECT_NE(exactAnyref.hash(), exactFuncSignatureType.hash());
  EXPECT_NE(coneAnyref.hash(), coneFuncref.hash());
  EXPECT_NE(coneAnyref.hash(), coneFuncref1.hash());
  EXPECT_NE(coneFuncref.hash(), coneFuncref1.hash());
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
  // the same heap type (nullability may be added, but nothing else). Otherwise
  // we go to a cone type or to many.
  assertCombination(exactFuncref, exactAnyref, many);
  assertCombination(exactFuncref, anyGlobal, many);
  assertCombination(exactFuncref, nonNullFunc, coneFuncref1);
  assertCombination(exactFuncref, exactFuncref, exactFuncref);
  assertCombination(exactFuncref, exactNonNullFuncref, exactFuncref);

  // Nulls.

  assertCombination(anyNull, i32Zero, many);
  assertCombination(anyNull, anyNull, anyNull);
  assertCombination(anyNull, exactAnyref, exactAnyref);

  // Two nulls go to the lub.
  assertCombination(anyNull, i31Null, anyNull);

  // Incompatible nulls go to Many.
  assertCombination(anyNull, funcNull, many);

  assertCombination(exactNonNullAnyref, exactNonNullAnyref, exactNonNullAnyref);

  // If one is a null and the other is not, it makes the one that is not a
  // null be a nullable type - but keeps the heap type of the other (since the
  // type of the null does not matter, all nulls compare equal).
  assertCombination(anyNull, exactNonNullAnyref, exactAnyref);
  assertCombination(anyNull, exactNonNullI31ref, exactI31ref);

  // Funcrefs

  // A function reference + a null becomes an exact type (of that sig), plus
  // nullability.
  assertCombination(nonNullFunc, funcNull, exactFuncSignatureType);
  assertCombination(exactFuncSignatureType, funcNull, exactFuncSignatureType);
  assertCombination(
    exactNonNullFuncSignatureType, funcNull, exactFuncSignatureType);
  assertCombination(
    nonNullFunc, exactFuncSignatureType, exactFuncSignatureType);
  assertCombination(
    nonNullFunc, exactNonNullFuncSignatureType, exactNonNullFuncSignatureType);
  assertCombination(nonNullFunc, exactI32, many);

  // Globals vs nulls. The result is either the global or a null, so all we can
  // say is that it is something of the global's type, or a null: a cone.

  assertCombination(anyGlobal, anyNull, coneAnyref);
  assertCombination(anyGlobal, i31Null, coneAnyref);
}

TEST_F(PossibleContentsTest, TestCones) {
  /*
       A
      / \
     B   C
          \
           D
  */
  TypeBuilder builder(4);
  builder.setHeapType(0, Struct(FieldList{}));
  builder.setHeapType(1, Struct(FieldList{}));
  builder.setHeapType(2, Struct(FieldList{}));
  builder.setHeapType(3, Struct(FieldList{}));
  builder.setSubType(1, builder.getTempHeapType(0));
  builder.setSubType(2, builder.getTempHeapType(0));
  builder.setSubType(3, builder.getTempHeapType(2));
  auto result = builder.build();
  ASSERT_TRUE(result);
  auto types = *result;
  auto A = types[0];
  auto B = types[1];
  auto C = types[2];
  auto D = types[3];
  ASSERT_TRUE(B.getSuperType() == A);
  ASSERT_TRUE(C.getSuperType() == A);
  ASSERT_TRUE(D.getSuperType() == C);
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

// Asserts a and b have an intersection (or do not), and checks both orderings.
void assertHaveIntersection(PossibleContents a, PossibleContents b) {
  EXPECT_TRUE(PossibleContents::haveIntersection(a, b));
  EXPECT_TRUE(PossibleContents::haveIntersection(b, a));
}
void assertLackIntersection(PossibleContents a, PossibleContents b) {
  EXPECT_FALSE(PossibleContents::haveIntersection(a, b));
  EXPECT_FALSE(PossibleContents::haveIntersection(b, a));
}

TEST_F(PossibleContentsTest, TestIntersection) {
  // None has no contents, so nothing to intersect.
  assertLackIntersection(none, none);
  assertLackIntersection(none, i32Zero);
  assertLackIntersection(none, many);

  // Many intersects with anything (but none).
  assertHaveIntersection(many, many);
  assertHaveIntersection(many, i32Zero);

  // Different exact types cannot intersect.
  assertLackIntersection(exactI32, exactAnyref);
  assertLackIntersection(i32Zero, exactAnyref);

  // But nullable ones can - the null can be the intersection.
  assertHaveIntersection(exactFuncSignatureType, exactAnyref);
  assertHaveIntersection(exactFuncSignatureType, funcNull);
  assertHaveIntersection(anyNull, funcNull);

  // Identical types might.
  assertHaveIntersection(exactI32, exactI32);
  assertHaveIntersection(i32Zero, i32Zero);
  assertHaveIntersection(exactFuncSignatureType, exactFuncSignatureType);
  assertHaveIntersection(i32Zero, i32One); // TODO: this could be inferred false

  // Exact types only differing by nullability can intersect (not on the null,
  // but on something else).
  assertHaveIntersection(exactAnyref, exactNonNullAnyref);

  // Due to subtyping, an intersection might exist.
  assertHaveIntersection(funcGlobal, funcGlobal);
  assertHaveIntersection(funcGlobal, exactFuncSignatureType);
  assertHaveIntersection(nonNullFuncGlobal, exactFuncSignatureType);
  assertHaveIntersection(funcGlobal, exactNonNullFuncSignatureType);
  assertHaveIntersection(nonNullFuncGlobal, exactNonNullFuncSignatureType);

  // Neither is a subtype of the other, but nulls are possible, so a null can be
  // the intersection.
  assertHaveIntersection(funcGlobal, anyGlobal);

  // Without null on one side, we cannot intersect.
  assertLackIntersection(nonNullFuncGlobal, anyGlobal);
}

TEST_F(PossibleContentsTest, TestOracleManyTypes) {
  // Test for a node with many possible types. The pass limits how many it
  // notices to not use excessive memory, so even though 4 are possible here,
  // we'll just report that more than one is possible, a cone of data.
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
  // The body's contents must be a cone of data with depth 1.
  auto bodyContents = oracle.getContents(ResultLocation{wasm->getFunction("foo"), 0});
  ASSERT_TRUE(bodyContents.isConeType());
  EXPECT_TRUE(bodyContents.getType().getHeapType() == HeapType::data);
  EXPECT_TRUE(bodyContents.getCone().depth == 1);
}

// TODO: test A+B+C=C+B+A (add to that permuations test)
