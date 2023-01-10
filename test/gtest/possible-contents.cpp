#include "ir/possible-contents.h"
#include "ir/subtypes.h"
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
  T temp1 = PossibleContents::combine(a, b);
  assertEqualSymmetric(temp1, c);
  // Also check the type, as nulls will compare equal even if their types
  // differ. We want to make sure even the types are identical.
  assertEqualSymmetric(temp1.getType(), c.getType());

  T temp2 = PossibleContents::combine(b, a);
  assertEqualSymmetric(temp2, c);
  assertEqualSymmetric(temp2.getType(), c.getType());

  // Verify the shorthand API works like the static one.
  T temp3 = a;
  temp3.combine(b);
  assertEqualSymmetric(temp3, temp1);

  T temp4 = b;
  temp4.combine(a);
  assertEqualSymmetric(temp4, temp2);
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
  Type structref = Type(HeapType::struct_, Nullable);

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
  PossibleContents exactStructref = PossibleContents::exactType(structref);
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
  assertNotEqualSymmetric(anyNull, funcNull);
  assertEqualSymmetric(anyNull, anyNull);

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
#if BINARYEN_TEST_DEBUG
  if (!PossibleContents::haveIntersection(a, b) ||
      !PossibleContents::haveIntersection(b, a)) {
    std::cout << "\nFailure: no intersection:\n" << a << '\n' << b << '\n';
    abort();
  }
#endif
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

  // But nullable ones can - the null can be the intersection, if they are not
  // in separate hierarchies.
  assertHaveIntersection(exactFuncSignatureType, funcNull);

  assertLackIntersection(exactFuncSignatureType, exactAnyref);
  assertLackIntersection(anyNull, funcNull);

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

  // Separate hierarchies.
  assertLackIntersection(funcGlobal, anyGlobal);
}

TEST_F(PossibleContentsTest, TestIntersectWithCombinations) {
  // Whenever we combine C = A + B, both A and B must intersect with C. This
  // helper function gets a set of things and checks that property on them. It
  // returns the set of all contents it ever observed (see below for how we use
  // that).
  auto doTest = [](std::unordered_set<PossibleContents> set) {
    std::vector<PossibleContents> vec(set.begin(), set.end());

    // Find the maximum depths for the normalized cone tests later down.
    std::unordered_set<HeapType> heapTypes;
    for (auto& contents : set) {
      auto type = contents.getType();
      if (type.isRef()) {
        auto heapType = type.getHeapType();
        if (!heapType.isBasic()) {
          heapTypes.insert(heapType);
        }
      }
    }
    std::vector<HeapType> heapTypesVec(heapTypes.begin(), heapTypes.end());
    SubTypes subTypes(heapTypesVec);
    auto maxDepths = subTypes.getMaxDepths();

    // Go over all permutations up to a certain size (this quickly becomes
    // extremely slow, obviously, so keep this low).
    size_t max = 3;

    auto n = set.size();

    // |indexes| contains the indexes of the items in vec for the current
    // permutation.
    std::vector<size_t> indexes(max);
    std::fill(indexes.begin(), indexes.end(), 0);
    while (1) {
      // Test the current permutation: Combine all the relevant things, and then
      // check they all have an intersection.
      PossibleContents combination;
      for (auto index : indexes) {
        combination.combine(vec[index]);
      }
      // Note the combination in the set.
      set.insert(combination);
#if BINARYEN_TEST_DEBUG
      for (auto index : indexes) {
        std::cout << index << ' ';
        combination.combine(vec[index]);
      }
      std::cout << '\n';
#endif
      for (auto index : indexes) {
        auto item = vec[index];
        if (item.isNone()) {
          assertLackIntersection(combination, item);
          continue;
        }
#if BINARYEN_TEST_DEBUG
        if (!PossibleContents::haveIntersection(combination, item)) {
          std::cout << "\nFailure: no expected intersection. Indexes:\n";
          for (auto index : indexes) {
            std::cout << index << "\n  ";
            vec[index].dump(std::cout);
            std::cout << '\n';
          }
          std::cout << "combo:\n";
          combination.dump(std::cout);
          std::cout << "\ncompared item (index " << index << "):\n";
          item.dump(std::cout);
          std::cout << '\n';
          abort();
        }
#endif
        assertHaveIntersection(combination, item);

        auto type = combination.getType();
        if (type.isRef()) {
          // If we normalize the combination's depth, the item must still have
          // an intersection. That is, normalization must not have a bug that
          // results in cones that are too shallow.
          auto normalizedDepth = maxDepths[type.getHeapType()];
          auto normalizedCone =
            PossibleContents::coneType(type, normalizedDepth);
          assertHaveIntersection(normalizedCone, item);
        }

        // Test intersectWithFullCone() method, which is supported with a full
        // cone type. In that case we can test that the intersection of A with
        // A + B is simply A.
        if (combination.isFullConeType()) {
          auto intersection = item;
          intersection.intersectWithFullCone(combination);
          EXPECT_EQ(intersection, item);
#if BINARYEN_TEST_DEBUG
          if (intersection != item) {
            std::cout << "\nFailure: wrong intersection.\n";
            std::cout << "item: " << item << '\n';
            std::cout << "combination: " << combination << '\n';
            std::cout << "intersection: " << intersection << '\n';
            abort();
          }
#endif

          // The intersection is contained in each of the things we intersected
          // (but we can only compare to the full cone, as the API is restricted
          // to that).
          EXPECT_TRUE(
            PossibleContents::isSubContents(intersection, combination));
        }
      }

      // Move to the next permutation.
      size_t i = 0;
      while (1) {
        indexes[i]++;
        if (indexes[i] == n) {
          // Overflow.
          indexes[i] = 0;
          i++;
          if (i == max) {
            // All done.
            return set;
          }
        } else {
          break;
        }
      }
    }

    WASM_UNREACHABLE("loop above returns manually");
  };

  // Start from an initial set of the hardcoded contents we have in our test
  // fixture.
  std::unordered_set<PossibleContents> initial = {none,
                                                  f64One,
                                                  anyNull,
                                                  funcNull,
                                                  i31Null,
                                                  i32Global1,
                                                  i32Global2,
                                                  f64Global,
                                                  anyGlobal,
                                                  funcGlobal,
                                                  nonNullFuncGlobal,
                                                  nonNullFunc,
                                                  exactI32,
                                                  exactAnyref,
                                                  exactFuncref,
                                                  exactStructref,
                                                  exactI31ref,
                                                  exactNonNullAnyref,
                                                  exactNonNullFuncref,
                                                  exactNonNullI31ref,
                                                  exactFuncSignatureType,
                                                  exactNonNullFuncSignatureType,
                                                  many,
                                                  coneAnyref,
                                                  coneFuncref,
                                                  coneFuncref1};

  // Add some additional interesting types.
  auto structType =
    Type(HeapType(Struct({Field(Type::i32, Immutable)})), NonNullable);
  initial.insert(PossibleContents::coneType(structType, 0));
  auto arrayType =
    Type(HeapType(Array(Field(Type::i32, Immutable))), NonNullable);
  initial.insert(PossibleContents::coneType(arrayType, 0));

  // After testing on the initial contents, also test using anything new that
  // showed up while combining them.
  auto subsequent = doTest(initial);
  while (subsequent.size() > initial.size()) {
    initial = subsequent;
    subsequent = doTest(subsequent);
  }
}

void assertIntersection(PossibleContents a,
                        PossibleContents b,
                        PossibleContents result) {
  auto intersection = a;
  intersection.intersectWithFullCone(b);
  EXPECT_EQ(intersection, result);

  EXPECT_EQ(PossibleContents::haveIntersection(a, b), !result.isNone());
}

TEST_F(PossibleContentsTest, TestStructCones) {
  /*
        A       E
       / \
      B   C
           \
            D
  */
  TypeBuilder builder(5);
  builder.setHeapType(0, Struct(FieldList{}));
  builder.setHeapType(1, Struct(FieldList{}));
  builder.setHeapType(2, Struct(FieldList{}));
  builder.setHeapType(3, Struct(FieldList{}));
  builder.setHeapType(4, Struct(FieldList{}));
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
  auto E = types[4];
  ASSERT_TRUE(B.getSuperType() == A);
  ASSERT_TRUE(C.getSuperType() == A);
  ASSERT_TRUE(D.getSuperType() == C);

  auto nullA = Type(A, Nullable);
  auto nullB = Type(B, Nullable);
  auto nullC = Type(C, Nullable);
  auto nullD = Type(D, Nullable);
  auto nullE = Type(E, Nullable);

  auto exactA = PossibleContents::exactType(nullA);
  auto exactB = PossibleContents::exactType(nullB);
  auto exactC = PossibleContents::exactType(nullC);
  auto exactD = PossibleContents::exactType(nullD);
  auto exactE = PossibleContents::exactType(nullE);

  auto nnA = Type(A, NonNullable);
  auto nnB = Type(B, NonNullable);
  auto nnC = Type(C, NonNullable);
  auto nnD = Type(D, NonNullable);
  auto nnE = Type(E, NonNullable);

  auto nnExactA = PossibleContents::exactType(nnA);
  auto nnExactB = PossibleContents::exactType(nnB);
  auto nnExactC = PossibleContents::exactType(nnC);
  auto nnExactD = PossibleContents::exactType(nnD);
  auto nnExactE = PossibleContents::exactType(nnE);

  assertCombination(exactA, exactA, exactA);
  assertCombination(exactA, exactA, PossibleContents::coneType(nullA, 0));
  assertCombination(exactA, exactB, PossibleContents::coneType(nullA, 1));
  assertCombination(exactA, exactC, PossibleContents::coneType(nullA, 1));
  assertCombination(exactA, exactD, PossibleContents::coneType(nullA, 2));
  assertCombination(exactA, exactE, PossibleContents::coneType(structref, 1));
  assertCombination(
    exactA, exactStructref, PossibleContents::coneType(structref, 1));

  assertCombination(exactB, exactB, exactB);
  assertCombination(exactB, exactC, PossibleContents::coneType(nullA, 1));
  assertCombination(exactB, exactD, PossibleContents::coneType(nullA, 2));
  assertCombination(exactB, exactE, PossibleContents::coneType(structref, 2));
  assertCombination(
    exactB, exactStructref, PossibleContents::coneType(structref, 2));

  assertCombination(exactC, exactC, exactC);
  assertCombination(exactC, exactD, PossibleContents::coneType(nullC, 1));
  assertCombination(exactC, exactE, PossibleContents::coneType(structref, 2));
  assertCombination(
    exactC, exactStructref, PossibleContents::coneType(structref, 2));

  assertCombination(exactD, exactD, exactD);
  assertCombination(exactD, exactE, PossibleContents::coneType(structref, 3));
  assertCombination(
    exactD, exactStructref, PossibleContents::coneType(structref, 3));

  assertCombination(exactE, exactE, exactE);
  assertCombination(
    exactE, exactStructref, PossibleContents::coneType(structref, 1));

  assertCombination(exactStructref, exactStructref, exactStructref);

  assertCombination(
    exactStructref, exactAnyref, PossibleContents::coneType(anyref, 2));

  // Combinations of cones.
  assertCombination(PossibleContents::coneType(nullA, 5),
                    PossibleContents::coneType(nullA, 7),
                    PossibleContents::coneType(nullA, 7));

  // Increment the cone of D as we go here, until it matters.
  assertCombination(PossibleContents::coneType(nullA, 5),
                    PossibleContents::coneType(nullD, 2),
                    PossibleContents::coneType(nullA, 5));
  assertCombination(PossibleContents::coneType(nullA, 5),
                    PossibleContents::coneType(nullD, 3),
                    PossibleContents::coneType(nullA, 5));
  assertCombination(PossibleContents::coneType(nullA, 5),
                    PossibleContents::coneType(nullD, 4),
                    PossibleContents::coneType(nullA, 6));

  assertCombination(PossibleContents::coneType(nullA, 5),
                    PossibleContents::coneType(nullE, 7),
                    PossibleContents::coneType(structref, 8));

  assertCombination(PossibleContents::coneType(nullB, 4),
                    PossibleContents::coneType(structref, 1),
                    PossibleContents::coneType(structref, 6));

  // Combinations of cones and exact types.
  assertCombination(exactA,
                    PossibleContents::coneType(nullA, 3),
                    PossibleContents::coneType(nullA, 3));
  assertCombination(exactA,
                    PossibleContents::coneType(nullD, 3),
                    PossibleContents::coneType(nullA, 5));
  assertCombination(exactD,
                    PossibleContents::coneType(nullA, 3),
                    PossibleContents::coneType(nullA, 3));
  assertCombination(exactA,
                    PossibleContents::coneType(nullE, 2),
                    PossibleContents::coneType(structref, 3));

  assertCombination(exactA,
                    PossibleContents::coneType(structref, 1),
                    PossibleContents::coneType(structref, 1));
  assertCombination(exactA,
                    PossibleContents::coneType(structref, 2),
                    PossibleContents::coneType(structref, 2));

  assertCombination(exactStructref,
                    PossibleContents::coneType(nullB, 3),
                    PossibleContents::coneType(structref, 5));

  // Full cones.
  assertCombination(PossibleContents::fullConeType(nullA),
                    exactA,
                    PossibleContents::fullConeType(nullA));
  assertCombination(PossibleContents::fullConeType(nullA),
                    PossibleContents::coneType(nullA, 2),
                    PossibleContents::fullConeType(nullA));

  // All full cones with A remain full cones, except for E.
  assertCombination(PossibleContents::fullConeType(nullA),
                    PossibleContents::fullConeType(nullA),
                    PossibleContents::fullConeType(nullA));
  assertCombination(PossibleContents::fullConeType(nullA),
                    PossibleContents::fullConeType(nullB),
                    PossibleContents::fullConeType(nullA));
  assertCombination(PossibleContents::fullConeType(nullA),
                    PossibleContents::fullConeType(nullC),
                    PossibleContents::fullConeType(nullA));
  assertCombination(PossibleContents::fullConeType(nullA),
                    PossibleContents::fullConeType(nullD),
                    PossibleContents::fullConeType(nullA));
  assertCombination(PossibleContents::fullConeType(nullA),
                    PossibleContents::fullConeType(nullE),
                    PossibleContents::fullConeType(structref));

  // Intersections. Test with non-nullable types to avoid the null being a
  // possible intersection.
  assertHaveIntersection(nnExactA, nnExactA);
  assertLackIntersection(nnExactA, nnExactB);
  assertLackIntersection(nnExactA, nnExactC);
  assertLackIntersection(nnExactA, nnExactD);
  assertLackIntersection(nnExactA, nnExactE);

  assertHaveIntersection(PossibleContents::coneType(nnA, 1), nnExactB);
  assertHaveIntersection(PossibleContents::coneType(nnA, 1), nnExactC);
  assertHaveIntersection(PossibleContents::coneType(nnA, 2), nnExactD);

  assertLackIntersection(PossibleContents::coneType(nnA, 1), nnExactD);
  assertLackIntersection(PossibleContents::coneType(nnA, 1), nnExactE);
  assertLackIntersection(PossibleContents::coneType(nnA, 2), nnExactE);

  assertHaveIntersection(PossibleContents::coneType(nnA, 1),
                         PossibleContents::coneType(nnC, 100));
  assertLackIntersection(PossibleContents::coneType(nnA, 1),
                         PossibleContents::coneType(nnD, 100));

  // Neither is a subtype of the other, but nulls are possible, so a null can be
  // the intersection.
  assertHaveIntersection(PossibleContents::fullConeType(nullA),
                         PossibleContents::fullConeType(nullE));

  // Without null on one side, we cannot intersect.
  assertLackIntersection(PossibleContents::fullConeType(nnA),
                         PossibleContents::fullConeType(nullE));

  // Computing intersections is supported with a full cone type.
  assertIntersection(none, PossibleContents::fullConeType(nnA), none);
  assertIntersection(many,
                     PossibleContents::fullConeType(nnA),
                     PossibleContents::fullConeType(nnA));
  assertIntersection(many,
                     PossibleContents::fullConeType(nullA),
                     PossibleContents::fullConeType(nullA));

  assertIntersection(exactA, PossibleContents::fullConeType(nullA), exactA);
  assertIntersection(nnExactA, PossibleContents::fullConeType(nullA), nnExactA);
  assertIntersection(exactA, PossibleContents::fullConeType(nnA), nnExactA);

  assertIntersection(exactB, PossibleContents::fullConeType(nullA), exactB);
  assertIntersection(nnExactB, PossibleContents::fullConeType(nullA), nnExactB);
  assertIntersection(exactB, PossibleContents::fullConeType(nnA), nnExactB);

  auto literalNullA = PossibleContents::literal(Literal::makeNull(A));

  assertIntersection(
    literalNullA, PossibleContents::fullConeType(nullA), literalNullA);
  assertIntersection(literalNullA, PossibleContents::fullConeType(nnA), none);

  assertIntersection(
    literalNullA, PossibleContents::fullConeType(nullB), literalNullA);
  assertIntersection(literalNullA, PossibleContents::fullConeType(nnB), none);

  assertIntersection(
    literalNullA, PossibleContents::fullConeType(nullE), literalNullA);
  assertIntersection(literalNullA, PossibleContents::fullConeType(nnE), none);

  assertIntersection(exactA,
                     PossibleContents::fullConeType(nullB),
                     PossibleContents::literal(Literal::makeNull(B)));
  assertIntersection(nnExactA, PossibleContents::fullConeType(nullB), none);
  assertIntersection(exactA, PossibleContents::fullConeType(nnB), none);

  // A and E have no intersection, so the only possibility is a null, and that
  // null must be the bottom type.
  assertIntersection(
    exactA,
    PossibleContents::fullConeType(nullE),
    PossibleContents::literal(Literal::makeNull(HeapType::none)));

  assertIntersection(PossibleContents::coneType(nnA, 1),
                     PossibleContents::fullConeType(nnB),
                     nnExactB);
  assertIntersection(PossibleContents::coneType(nnB, 1),
                     PossibleContents::fullConeType(nnA),
                     PossibleContents::coneType(nnB, 1));
  assertIntersection(PossibleContents::coneType(nnD, 2),
                     PossibleContents::fullConeType(nnA),
                     PossibleContents::coneType(nnD, 2));
  assertIntersection(PossibleContents::coneType(nnA, 5),
                     PossibleContents::fullConeType(nnD),
                     PossibleContents::coneType(nnD, 3));

  assertIntersection(PossibleContents::coneType(nnA, 1),
                     PossibleContents::fullConeType(nnD),
                     none);

  // Globals stay as globals if their type is in the cone. Otherwise, they lose
  // the global info and we compute a normal cone intersection on them. The
  // same for literals.
  assertIntersection(
    funcGlobal, PossibleContents::fullConeType(funcref), funcGlobal);

  auto signature = Type(Signature(Type::none, Type::none), Nullable);
  assertIntersection(
    nonNullFunc, PossibleContents::fullConeType(signature), nonNullFunc);
  assertIntersection(funcGlobal,
                     PossibleContents::fullConeType(signature),
                     PossibleContents::fullConeType(signature));

  // Incompatible hierarchies have no intersection.
  assertIntersection(
    literalNullA, PossibleContents::fullConeType(funcref), none);

  // Subcontents. This API only supports the case where one of the inputs is a
  // full cone type.
  // First, compare exact types to such a cone.
  EXPECT_TRUE(PossibleContents::isSubContents(
    exactA, PossibleContents::fullConeType(nullA)));
  EXPECT_TRUE(PossibleContents::isSubContents(
    nnExactA, PossibleContents::fullConeType(nnA)));
  EXPECT_TRUE(PossibleContents::isSubContents(
    nnExactA, PossibleContents::fullConeType(nullA)));
  EXPECT_TRUE(PossibleContents::isSubContents(
    nnExactD, PossibleContents::fullConeType(nullA)));

  EXPECT_FALSE(PossibleContents::isSubContents(
    exactA, PossibleContents::fullConeType(nnA)));
  EXPECT_FALSE(PossibleContents::isSubContents(
    exactA, PossibleContents::fullConeType(nullB)));

  // Next, compare cones.
  EXPECT_TRUE(
    PossibleContents::isSubContents(PossibleContents::fullConeType(nullA),
                                    PossibleContents::fullConeType(nullA)));
  EXPECT_TRUE(
    PossibleContents::isSubContents(PossibleContents::fullConeType(nnA),
                                    PossibleContents::fullConeType(nullA)));
  EXPECT_TRUE(PossibleContents::isSubContents(
    PossibleContents::fullConeType(nnA), PossibleContents::fullConeType(nnA)));
  EXPECT_TRUE(
    PossibleContents::isSubContents(PossibleContents::fullConeType(nullD),
                                    PossibleContents::fullConeType(nullA)));

  EXPECT_FALSE(
    PossibleContents::isSubContents(PossibleContents::fullConeType(nullA),
                                    PossibleContents::fullConeType(nnA)));
  EXPECT_FALSE(
    PossibleContents::isSubContents(PossibleContents::fullConeType(nullA),
                                    PossibleContents::fullConeType(nullD)));

  // Trivial values.
  EXPECT_TRUE(PossibleContents::isSubContents(
    PossibleContents::none(), PossibleContents::fullConeType(nullA)));
  EXPECT_FALSE(PossibleContents::isSubContents(
    PossibleContents::many(), PossibleContents::fullConeType(nullA)));

  EXPECT_TRUE(PossibleContents::isSubContents(
    anyNull, PossibleContents::fullConeType(nullA)));
  EXPECT_FALSE(PossibleContents::isSubContents(
    anyNull, PossibleContents::fullConeType(nnA)));

  // Tests cases with a full cone only on the left. Such a cone is only a sub-
  // contents of Many.
  EXPECT_FALSE(PossibleContents::isSubContents(
    PossibleContents::fullConeType(nullA), exactA));
  EXPECT_FALSE(PossibleContents::isSubContents(
    PossibleContents::fullConeType(nullA), nnExactA));

  EXPECT_FALSE(PossibleContents::isSubContents(
    PossibleContents::fullConeType(nullA), PossibleContents::none()));
  EXPECT_TRUE(PossibleContents::isSubContents(
    PossibleContents::fullConeType(nullA), PossibleContents::many()));

  EXPECT_FALSE(PossibleContents::isSubContents(
    PossibleContents::fullConeType(nullA), anyNull));
  EXPECT_FALSE(PossibleContents::isSubContents(
    PossibleContents::fullConeType(nnA), anyNull));
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
  auto bodyContents =
    oracle.getContents(ResultLocation{wasm->getFunction("foo"), 0});
  ASSERT_TRUE(bodyContents.isConeType());
  EXPECT_EQ(bodyContents.getType().getHeapType(), HeapType::struct_);
  EXPECT_EQ(bodyContents.getCone().depth, Index(1));
}

TEST_F(PossibleContentsTest, TestOracleNoFullCones) {
  // PossibleContents should be normalized, so we never have full cones (depth
  // infinity).
  auto wasm = parse(R"(
    (module
      (type $A (struct_subtype (field i32) data))
      (type $B (struct_subtype (field i32) $A))
      (type $C (struct_subtype (field i32) $B))
      (func $foo (export "foo")
        ;; Note we must declare $C so that $B and $C have uses and are not
        ;; removed automatically from consideration.
        (param $a (ref $A)) (param $c (ref $C))
        (result (ref any))
        (local.get $a)
      )
    )
  )");
  ContentOracle oracle(*wasm);
  // The function is exported, and all we know about the parameter $a is that it
  // is some subtype of $A. This is normalized to depth 2 because that is the
  // actual depth of subtypes.
  auto bodyContents =
    oracle.getContents(ResultLocation{wasm->getFunction("foo"), 0});
  ASSERT_TRUE(bodyContents.isConeType());
  EXPECT_EQ(bodyContents.getCone().depth, Index(2));
}
