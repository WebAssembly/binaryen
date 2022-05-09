#include "type-test.h"
#include "wasm-type-printing.h"
#include "wasm-type.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST_F(TypeTest, TypeBuilderGrowth) {
  TypeBuilder builder;
  EXPECT_EQ(builder.size(), 0u);
  builder.grow(3);
  EXPECT_EQ(builder.size(), 3u);
}

TEST_F(TypeTest, TypeIterator) {
  Type none = Type::none;
  Type i32 = Type::i32;
  Type i64 = Type::i64;
  Type f32 = Type::f32;
  Type f64 = Type::f64;
  Type tuple = Tuple{i32, i64, f32, f64};

  EXPECT_EQ(none.size(), 0u);
  EXPECT_EQ(none.begin(), none.end());
  EXPECT_EQ(none.end() - none.begin(), 0u);
  EXPECT_EQ(none.begin() + 0, none.end());

  EXPECT_EQ(i32.size(), 1u);
  EXPECT_NE(i32.begin(), i32.end());
  EXPECT_EQ(i32.end() - i32.begin(), 1u);

  EXPECT_EQ(*i32.begin(), i32);
  EXPECT_EQ(i32[0], i32);

  EXPECT_EQ(i32.begin() + 1, i32.end());
  EXPECT_EQ(i32.end() - 1, i32.begin());

  auto preInc = i32.begin();
  EXPECT_EQ(++preInc, i32.end());
  EXPECT_EQ(preInc, i32.end());

  auto postInc = i32.begin();
  EXPECT_EQ(postInc++, i32.begin());
  EXPECT_EQ(postInc, i32.end());

  auto preDec = i32.end();
  EXPECT_EQ(--preDec, i32.begin());
  EXPECT_EQ(preDec, i32.begin());

  auto postDec = i32.end();
  EXPECT_EQ(postDec--, i32.end());
  EXPECT_EQ(postDec, i32.begin());

  EXPECT_EQ(tuple.size(), 4u);
  EXPECT_NE(tuple.begin(), tuple.end());
  EXPECT_EQ(tuple.end() - tuple.begin(), 4u);

  EXPECT_EQ(*tuple.begin(), i32);
  EXPECT_EQ(*(tuple.begin() + 1), i64);
  EXPECT_EQ(*(tuple.begin() + 2), f32);
  EXPECT_EQ(*(tuple.begin() + 3), f64);
  EXPECT_EQ(tuple[0], i32);
  EXPECT_EQ(tuple[1], i64);
  EXPECT_EQ(tuple[2], f32);
  EXPECT_EQ(tuple[3], f64);

  auto reverse = tuple.rbegin();
  EXPECT_EQ(*reverse++, f64);
  EXPECT_EQ(*reverse++, f32);
  EXPECT_EQ(*reverse++, i64);
  EXPECT_EQ(*reverse++, i32);
  EXPECT_EQ(reverse, tuple.rend());
}

TEST_F(TypeTest, IndexedTypePrinter) {
  TypeBuilder builder(4);
  builder.createRecGroup(0, 4);

  Type refStructA = builder.getTempRefType(builder[0], Nullable);
  Type refStructB = builder.getTempRefType(builder[1], Nullable);
  Type refArrayA = builder.getTempRefType(builder[2], Nullable);
  Type refArrayB = builder.getTempRefType(builder[3], Nullable);
  builder[0] = Struct({Field(refArrayB, Immutable)});
  builder[1] = Struct({Field(refStructA, Immutable)});
  builder[2] = Array(Field(refStructB, Immutable));
  builder[3] = Array(Field(refArrayA, Immutable));

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  std::vector<HeapType> structs{built[0], built[1]};
  std::vector<HeapType> arrays{built[2], built[3]};

  // Check that IndexedTypePrinters configured with fallbacks work correctly.
  using ArrayPrinter = IndexedTypeNameGenerator<DefaultTypeNameGenerator>;
  ArrayPrinter printArrays(arrays, "array");
  using StructPrinter = IndexedTypeNameGenerator<ArrayPrinter>;
  StructPrinter print(structs, printArrays, "struct");

  std::stringstream stream;
  stream << print(built[0]);
  EXPECT_EQ(stream.str(), "(struct_subtype (field (ref null $array1)) data)");

  stream.str("");
  stream << print(built[1]);
  EXPECT_EQ(stream.str(), "(struct_subtype (field (ref null $struct0)) data)");

  stream.str("");
  stream << print(built[2]);
  EXPECT_EQ(stream.str(), "(array_subtype (ref null $struct1) data)");

  stream.str("");
  stream << print(built[3]);
  EXPECT_EQ(stream.str(), "(array_subtype (ref null $array0) data)");
}

TEST_F(EquirecursiveTest, Basics) {
  // (type $sig (func (param (ref $struct)) (result (ref $array) i32)))
  // (type $struct (struct (field (ref null $array) (mut rtt 0 $array))))
  // (type $array (array (mut anyref)))
  TypeBuilder builder(3);
  ASSERT_EQ(builder.size(), size_t{3});

  Type refSig = builder.getTempRefType(builder[0], NonNullable);
  Type refStruct = builder.getTempRefType(builder[1], NonNullable);
  Type refArray = builder.getTempRefType(builder[2], NonNullable);
  Type refNullArray = builder.getTempRefType(builder[2], Nullable);
  Type rttArray = builder.getTempRttType(Rtt(0, builder[2]));
  Type refNullAny(HeapType::any, Nullable);

  Signature sig(refStruct, builder.getTempTupleType({refArray, Type::i32}));
  Struct struct_({Field(refNullArray, Immutable), Field(rttArray, Mutable)});
  Array array(Field(refNullAny, Mutable));

  builder[0] = sig;
  builder[1] = struct_;
  builder[2] = array;

  auto result = builder.build();
  ASSERT_TRUE(result);
  std::vector<HeapType> built = *result;
  ASSERT_EQ(built.size(), size_t{3});

  // The built types should have the correct kinds.
  ASSERT_TRUE(built[0].isSignature());
  ASSERT_TRUE(built[1].isStruct());
  ASSERT_TRUE(built[2].isArray());

  // The built types should have the correct structure.
  Type newRefSig = Type(built[0], NonNullable);
  Type newRefStruct = Type(built[1], NonNullable);
  Type newRefArray = Type(built[2], NonNullable);
  Type newRefNullArray = Type(built[2], Nullable);
  Type newRttArray = Type(Rtt(0, built[2]));

  EXPECT_EQ(built[0].getSignature(),
            Signature(newRefStruct, {newRefArray, Type::i32}));
  EXPECT_EQ(
    built[1].getStruct(),
    Struct({Field(newRefNullArray, Immutable), Field(newRttArray, Mutable)}));
  EXPECT_EQ(built[2].getArray(), Array(Field(refNullAny, Mutable)));

  // The built types should be different from the temporary types.
  EXPECT_NE(newRefSig, refSig);
  EXPECT_NE(newRefStruct, refStruct);
  EXPECT_NE(newRefArray, refArray);
  EXPECT_NE(newRefNullArray, refNullArray);
  EXPECT_NE(newRttArray, rttArray);
}

static void testDirectSelfSupertype() {
  // Type is directly a supertype of itself.
  TypeBuilder builder(1);
  builder[0] = Struct{};
  builder[0].subTypeOf(builder[0]);

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  if (getTypeSystem() == TypeSystem::Nominal) {
    EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::SelfSupertype);
  } else if (getTypeSystem() == TypeSystem::Isorecursive) {
    EXPECT_EQ(error->reason,
              TypeBuilder::ErrorReason::ForwardSupertypeReference);
  }
  EXPECT_EQ(error->index, 0u);
}

TEST_F(NominalTest, DirectSelfSupertype) { testDirectSelfSupertype(); }
TEST_F(IsorecursiveTest, DirectSelfSupertype) { testDirectSelfSupertype(); }

static void testIndirectSelfSupertype() {
  // Type is indirectly a supertype of itself.
  TypeBuilder builder(2);
  builder.createRecGroup(0, 2);
  builder[0] = Struct{};
  builder[1] = Struct{};
  builder[0].subTypeOf(builder[1]);
  builder[1].subTypeOf(builder[0]);

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  if (getTypeSystem() == TypeSystem::Nominal) {
    EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::SelfSupertype);
  } else if (getTypeSystem() == TypeSystem::Isorecursive) {
    EXPECT_EQ(error->reason,
              TypeBuilder::ErrorReason::ForwardSupertypeReference);
  } else {
    WASM_UNREACHABLE("unexpected type system");
  }
  EXPECT_EQ(error->index, 0u);
}

TEST_F(NominalTest, IndirectSelfSupertype) { testIndirectSelfSupertype(); }
TEST_F(IsorecursiveTest, IndirectSelfSupertype) { testIndirectSelfSupertype(); }

static void testInvalidSupertype() {
  TypeBuilder builder(2);
  builder.createRecGroup(0, 2);
  builder[0] = Struct({Field(Type::i32, Immutable)});
  builder[1] = Struct{};
  builder[1].subTypeOf(builder[0]);

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::InvalidSupertype);
  EXPECT_EQ(error->index, 1u);
}

TEST_F(NominalTest, InvalidSupertype) { testInvalidSupertype(); }
TEST_F(IsorecursiveTest, InvalidSupertype) { testInvalidSupertype(); }

TEST_F(IsorecursiveTest, ForwardReferencedChild) {
  TypeBuilder builder(3);
  builder.createRecGroup(0, 2);
  Type refA1 = builder.getTempRefType(builder[1], Nullable);
  Type refB0 = builder.getTempRefType(builder[2], Nullable);
  // Forward reference to same group is ok.
  builder[0] = Struct({Field(refA1, Mutable)});
  // Forward reference to different group is not ok.
  builder[1] = Struct({Field(refB0, Mutable)});
  builder[2] = Struct{};

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::ForwardChildReference);
  EXPECT_EQ(error->index, 1u);
}

TEST_F(IsorecursiveTest, RecGroupIndices) {
  TypeBuilder builder(5);

  builder.createRecGroup(0, 2);
  builder[0] = Struct{};
  builder[1] = Struct{};

  builder.createRecGroup(2, 3);
  builder[2] = Struct{};
  builder[3] = Struct{};
  builder[4] = Struct{};

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[0].getRecGroup(), built[1].getRecGroup());
  EXPECT_EQ(built[0].getRecGroupIndex(), 0u);
  EXPECT_EQ(built[1].getRecGroupIndex(), 1u);

  EXPECT_EQ(built[2].getRecGroup(), built[3].getRecGroup());
  EXPECT_EQ(built[3].getRecGroup(), built[4].getRecGroup());
  EXPECT_EQ(built[2].getRecGroupIndex(), 0u);
  EXPECT_EQ(built[3].getRecGroupIndex(), 1u);
  EXPECT_EQ(built[4].getRecGroupIndex(), 2u);
}

TEST_F(IsorecursiveTest, CanonicalizeGroups) {
  // Trivial types in the same group are not equivalent.
  TypeBuilder builderA(2);
  builderA.createRecGroup(0, 2);
  builderA[0] = Struct{};
  builderA[1] = Struct{};
  auto resultA = builderA.build();
  ASSERT_TRUE(resultA);
  auto builtA = *resultA;

  EXPECT_NE(builtA[0], builtA[1]);

  // But if they are in their own separate groups, they are equivalent.
  TypeBuilder builderB(2);
  builderB[0] = Struct{};
  builderB[1] = Struct{};
  auto resultB = builderB.build();
  ASSERT_TRUE(resultB);
  auto builtB = *resultB;

  EXPECT_EQ(builtB[0], builtB[1]);
  EXPECT_NE(builtB[0], builtA[0]);
  EXPECT_NE(builtB[0], builtA[1]);

  // If we build the same groups again, we should get the same results.
  TypeBuilder builderA2(4);
  builderA2.createRecGroup(0, 2);
  builderA2.createRecGroup(2, 2);
  builderA2[0] = Struct{};
  builderA2[1] = Struct{};
  builderA2[2] = Struct{};
  builderA2[3] = Struct{};
  auto resultA2 = builderA2.build();
  ASSERT_TRUE(resultA2);
  auto builtA2 = *resultA2;

  EXPECT_EQ(builtA2[0], builtA[0]);
  EXPECT_EQ(builtA2[1], builtA[1]);
  EXPECT_EQ(builtA2[2], builtA[0]);
  EXPECT_EQ(builtA2[3], builtA[1]);

  TypeBuilder builderB2(1);
  builderB2[0] = Struct{};
  auto resultB2 = builderB2.build();
  ASSERT_TRUE(resultB2);
  auto builtB2 = *resultB2;

  EXPECT_EQ(builtB2[0], builtB[0]);
}

TEST_F(IsorecursiveTest, CanonicalizeUses) {
  TypeBuilder builder(8);
  builder[0] = makeStruct(builder, {});
  builder[1] = makeStruct(builder, {});
  builder[2] = makeStruct(builder, {0});
  builder[3] = makeStruct(builder, {1});
  builder[4] = makeStruct(builder, {0, 2});
  builder[5] = makeStruct(builder, {1, 3});
  builder[6] = makeStruct(builder, {2, 4});
  builder[7] = makeStruct(builder, {3, 5});

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[0], built[1]);
  EXPECT_EQ(built[2], built[3]);
  EXPECT_EQ(built[4], built[5]);
  EXPECT_EQ(built[6], built[7]);

  EXPECT_NE(built[0], built[2]);
  EXPECT_NE(built[0], built[4]);
  EXPECT_NE(built[0], built[6]);
  EXPECT_NE(built[2], built[4]);
  EXPECT_NE(built[2], built[6]);
  EXPECT_NE(built[4], built[6]);
}

TEST_F(IsorecursiveTest, DISABLED_CanonicalizeSelfReferences) {
  TypeBuilder builder(5);
  // Single self-reference
  builder[0] = makeStruct(builder, {0});
  builder[1] = makeStruct(builder, {1});
  // Single other reference
  builder[2] = makeStruct(builder, {0});
  // Other reference followed by self-reference
  builder[3] = makeStruct(builder, {2, 3});
  // Self-reference followed by other reference
  builder[4] = makeStruct(builder, {4, 2});

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[0], built[1]);

  EXPECT_NE(built[0], built[2]);
  EXPECT_NE(built[0], built[3]);
  EXPECT_NE(built[0], built[4]);
  EXPECT_NE(built[2], built[3]);
  EXPECT_NE(built[2], built[4]);
  EXPECT_NE(built[3], built[4]);
}

TEST_F(IsorecursiveTest, CanonicalizeSupertypes) {
  TypeBuilder builder(6);
  builder[0] = Struct{};
  builder[1] = Struct{};
  // Type with a supertype
  builder[2] = Struct{};
  builder[2].subTypeOf(builder[0]);
  // Type with the same supertype after canonicalization.
  builder[3] = Struct{};
  builder[3].subTypeOf(builder[1]);
  // Type with a different supertype
  builder[4] = Struct{};
  builder[4].subTypeOf(builder[2]);
  // Type with no supertype
  builder[5] = Struct{};

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[2], built[3]);

  EXPECT_NE(built[3], built[4]);
  EXPECT_NE(built[3], built[5]);
  EXPECT_NE(built[4], built[5]);
}

TEST_F(IsorecursiveTest, HeapTypeConstructors) {
  HeapType sig(Signature(Type::i32, Type::i32));
  HeapType struct_(Struct({Field(Type(sig, Nullable), Mutable)}));
  HeapType array(Field(Type(struct_, Nullable), Mutable));

  TypeBuilder builder(3);
  builder[0] = Signature(Type::i32, Type::i32);
  Type sigRef = builder.getTempRefType(builder[0], Nullable);
  builder[1] = Struct({Field(sigRef, Mutable)});
  Type structRef = builder.getTempRefType(builder[1], Nullable);
  builder[2] = Array(Field(structRef, Mutable));

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[0], sig);
  EXPECT_EQ(built[1], struct_);
  EXPECT_EQ(built[2], array);

  HeapType sig2(Signature(Type::i32, Type::i32));
  HeapType struct2(Struct({Field(Type(sig, Nullable), Mutable)}));
  HeapType array2(Field(Type(struct_, Nullable), Mutable));

  EXPECT_EQ(sig, sig2);
  EXPECT_EQ(struct_, struct2);
  EXPECT_EQ(array, array2);
}

TEST_F(IsorecursiveTest, CanonicalizeTypesBeforeSubtyping) {
  TypeBuilder builder(6);
  // A rec group
  builder.createRecGroup(0, 2);
  builder[0] = Struct{};
  builder[1] = Struct{};
  builder[1].subTypeOf(builder[0]);

  // The same rec group again
  builder.createRecGroup(2, 2);
  builder[2] = Struct{};
  builder[3] = Struct{};
  builder[3].subTypeOf(builder[2]);

  // This subtyping only validates if the previous two groups are deduplicated
  // before checking subtype validity.
  builder[4] =
    Struct({Field(builder.getTempRefType(builder[0], Nullable), Immutable)});
  builder[5] =
    Struct({Field(builder.getTempRefType(builder[3], Nullable), Immutable)});
  builder[5].subTypeOf(builder[4]);

  auto result = builder.build();
  EXPECT_TRUE(result);
}

static void testCanonicalizeBasicTypes() {
  TypeBuilder builder(5);

  Type anyref = builder.getTempRefType(builder[0], Nullable);
  Type anyrefs = builder.getTempTupleType({anyref, anyref});

  builder[0] = HeapType::any;
  builder[1] = Struct({Field(anyref, Immutable)});
  builder[2] = Struct({Field(Type::anyref, Immutable)});
  builder[3] = Signature(anyrefs, Type::none);
  builder[4] = Signature({Type::anyref, Type::anyref}, Type::none);

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[1], built[2]);
  EXPECT_EQ(built[3], built[4]);
}

TEST_F(EquirecursiveTest, CanonicalizeBasicTypes) {
  testCanonicalizeBasicTypes();
}
TEST_F(IsorecursiveTest, CanonicalizeBasicTypes) {
  testCanonicalizeBasicTypes();
}
