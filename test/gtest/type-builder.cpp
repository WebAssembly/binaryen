#include "ir/subtypes.h"
#include "type-test.h"
#include "wasm-builder.h"
#include "wasm-type-printing.h"
#include "wasm-type.h"
#include "gtest/gtest.h"

#ifdef FUZZTEST
#include "type-domains.h"
#endif

using namespace wasm;

TEST_F(TypeTest, TypeBuilderGrowth) {
  TypeBuilder builder;
  EXPECT_EQ(builder.size(), 0u);
  builder.grow(3);
  EXPECT_EQ(builder.size(), 3u);
  builder.grow(0);
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
  EXPECT_EQ(none.end() - none.begin(), 0);
  EXPECT_EQ(none.begin() + 0, none.end());

  EXPECT_EQ(i32.size(), 1u);
  EXPECT_NE(i32.begin(), i32.end());
  EXPECT_EQ(i32.end() - i32.begin(), 1);

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
  EXPECT_EQ(tuple.end() - tuple.begin(), 4);

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
  EXPECT_EQ(stream.str(),
            "(type $struct0 (struct (field (ref null $array1))))");

  stream.str("");
  stream << print(built[1]);
  EXPECT_EQ(stream.str(),
            "(type $struct1 (struct (field (ref null $struct0))))");

  stream.str("");
  stream << print(built[2]);
  EXPECT_EQ(stream.str(), "(type $array0 (array (ref null $struct1)))");

  stream.str("");
  stream << print(built[3]);
  EXPECT_EQ(stream.str(), "(type $array1 (array (ref null $array0)))");
}

TEST_F(TypeTest, ModuleTypePrinter) {
  TypeBuilder builder(2);
  builder.createRecGroup(0, 2);
  builder[0] = Struct({Field(Type::i32, Immutable)});
  builder[1] = Struct({Field(Type::i32, Immutable)});

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  Module module;
  module.typeNames[built[0]] = {"A", {}};

  ModuleTypeNameGenerator printDefault(module);

  std::stringstream stream;
  stream << printDefault(built[0]);
  EXPECT_EQ(stream.str(), "(type $A (struct (field i32)))");

  stream.str("");
  stream << printDefault(built[1]);
  EXPECT_EQ(stream.str(), "(type $struct.0 (struct (field i32)))");

  using IndexedFallback = IndexedTypeNameGenerator<DefaultTypeNameGenerator>;
  IndexedTypeNameGenerator fallback(built);
  ModuleTypeNameGenerator<IndexedFallback> printIndexed(module, fallback);

  stream.str("");
  stream << printIndexed(built[0]);
  EXPECT_EQ(stream.str(), "(type $A (struct (field i32)))");

  stream.str("");
  stream << printIndexed(built[1]);
  EXPECT_EQ(stream.str(), "(type $1 (struct (field i32)))");
}

TEST_F(TypeTest, Basics) {
  // (type $sig (func (param (ref $struct)) (result (ref $array) i32)))
  // (type $struct (struct (field (ref null $array))))
  // (type $array (array (mut anyref)))
  TypeBuilder builder(3);
  ASSERT_EQ(builder.size(), size_t{3});

  Type refStruct = builder.getTempRefType(builder[1], NonNullable);
  Type refArray = builder.getTempRefType(builder[2], NonNullable);
  Type refNullArray = builder.getTempRefType(builder[2], Nullable);
  Type refNullAny(HeapType::any, Nullable);

  Signature sig(refStruct, builder.getTempTupleType({refArray, Type::i32}));
  Struct struct_({Field(refNullArray, Immutable)});
  Array array(Field(refNullAny, Mutable));

  builder[0] = sig;
  builder[1] = struct_;
  builder[2] = array;

  builder.createRecGroup(0, 3);

  auto result = builder.build();
  ASSERT_TRUE(result);
  std::vector<HeapType> built = *result;
  ASSERT_EQ(built.size(), size_t{3});

  // The built types should have the correct kinds.
  ASSERT_TRUE(built[0].isSignature());
  ASSERT_TRUE(built[1].isStruct());
  ASSERT_TRUE(built[2].isArray());

  // The built types should have the correct structure.
  Type newRefStruct = Type(built[1], NonNullable);
  Type newRefArray = Type(built[2], NonNullable);
  Type newRefNullArray = Type(built[2], Nullable);

  EXPECT_EQ(built[0].getSignature(),
            Signature(newRefStruct, {newRefArray, Type::i32}));
  EXPECT_EQ(built[1].getStruct(), Struct({Field(newRefNullArray, Immutable)}));
  EXPECT_EQ(built[2].getArray(), Array(Field(refNullAny, Mutable)));
}

TEST_F(TypeTest, DirectSelfSupertype) {
  // Type is directly a supertype of itself.
  TypeBuilder builder(1);
  builder[0] = Struct{};
  builder[0].subTypeOf(builder[0]);

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::ForwardSupertypeReference);
  EXPECT_EQ(error->index, 0u);
}

TEST_F(TypeTest, IndirectSelfSupertype) {
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
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::ForwardSupertypeReference);
  EXPECT_EQ(error->index, 0u);
}

TEST_F(TypeTest, InvalidSupertype) {
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

TEST_F(TypeTest, InvalidFinalSupertype) {
  TypeBuilder builder(2);
  builder[0] = Struct{};
  builder[1] = Struct{};
  builder[0].setOpen(false);
  builder[1].subTypeOf(builder[0]);

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::InvalidSupertype);
  EXPECT_EQ(error->index, 1u);
}

TEST_F(TypeTest, InvalidSharedSupertype) {
  TypeBuilder builder(2);
  builder[0] = Struct{};
  builder[1] = Struct{};
  builder[0].setShared();
  builder[1].setShared();
  builder[1].subTypeOf(builder[0]);

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::InvalidSupertype);
  EXPECT_EQ(error->index, 1u);
}

TEST_F(TypeTest, InvalidUnsharedSupertype) {
  TypeBuilder builder(2);
  builder[0] = Struct{};
  builder[1] = Struct{};
  builder[0].setShared(Unshared);
  builder[1].setShared(Shared);
  builder[1].subTypeOf(builder[0]);

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::InvalidSupertype);
  EXPECT_EQ(error->index, 1u);
}

TEST_F(TypeTest, ForwardReferencedChild) {
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

TEST_F(TypeTest, RecGroupIndices) {
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

TEST_F(TypeTest, CanonicalizeGroups) {
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

TEST_F(TypeTest, CanonicalizeUses) {
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

TEST_F(TypeTest, CanonicalizeExactRefs) {
  TypeBuilder builder(10);

  // Types that vary in exactness or nullability of references are different.
  Type a = builder.getTempRefType(builder[0], Nullable, Inexact);
  Type b = builder.getTempRefType(builder[1], NonNullable, Inexact);
  Type c = builder.getTempRefType(builder[2], Nullable, Exact);
  Type d = builder.getTempRefType(builder[3], NonNullable, Exact);

  builder[0] = Struct({Field(a, Mutable)});
  builder[1] = Struct({Field(b, Mutable)});
  builder[2] = Struct({Field(c, Mutable)});
  builder[3] = Struct({Field(d, Mutable)});

  auto translate = [&](HeapType t) -> HeapType {
    for (int i = 0; i < 4; ++i) {
      if (t == builder[i]) {
        return builder[4 + i];
      }
    }
    WASM_UNREACHABLE("unexpected type");
  };

  builder[4].copy(builder[0], translate);
  builder[5].copy(builder[1], translate);
  builder[6].copy(builder[2], translate);
  builder[7].copy(builder[3], translate);

  // Test with references to previous types as well.
  Type ref0 = builder.getTempRefType(builder[0], Nullable, Exact);
  Type ref4 = builder.getTempRefType(builder[4], Nullable, Exact);

  builder[8] = Struct({Field(ref0, Mutable)});
  builder[9] = Struct({Field(ref4, Mutable)});

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[0], built[4]);
  EXPECT_EQ(built[1], built[5]);
  EXPECT_EQ(built[2], built[6]);
  EXPECT_EQ(built[3], built[7]);

  EXPECT_EQ(built[8], built[9]);

  EXPECT_NE(built[0], built[1]);
  EXPECT_NE(built[0], built[2]);
  EXPECT_NE(built[0], built[3]);
  EXPECT_NE(built[1], built[2]);
  EXPECT_NE(built[1], built[3]);
  EXPECT_NE(built[2], built[3]);
}

TEST_F(TypeTest, CanonicalizeSelfReferences) {
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

TEST_F(TypeTest, CanonicalizeSupertypes) {
  TypeBuilder builder(6);
  builder[0].setOpen() = Struct{};
  builder[1].setOpen() = Struct{};
  // Type with a supertype
  builder[2].setOpen().subTypeOf(builder[0]) = Struct{};
  // Type with the same supertype after canonicalization.
  builder[3].setOpen().subTypeOf(builder[1]) = Struct{};
  // Type with a different supertype
  builder[4].setOpen().subTypeOf(builder[2]) = Struct{};
  // Type with no supertype
  builder[5].setOpen() = Struct{};

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[2], built[3]);

  EXPECT_NE(built[3], built[4]);
  EXPECT_NE(built[3], built[5]);
  EXPECT_NE(built[4], built[5]);
}

TEST_F(TypeTest, CanonicalizeDescriptors) {
  constexpr int numGroups = 3;
  constexpr int groupSize = 4;
  TypeBuilder builder(numGroups * groupSize);

  for (int i = 0; i < numGroups; ++i) {
    builder.createRecGroup(i * groupSize, groupSize);
  }
  for (int i = 0; i < numGroups * groupSize; ++i) {
    builder[i] = Struct();
  }

  // A B A' B'
  builder[0].descriptor(builder[1]);
  builder[1].describes(builder[0]);
  builder[2].descriptor(builder[3]);
  builder[3].describes(builder[2]);

  // A' A B B'
  builder[4].descriptor(builder[7]);
  builder[5].descriptor(builder[6]);
  builder[6].describes(builder[5]);
  builder[7].describes(builder[4]);

  auto translate = [&](HeapType t) -> HeapType {
    for (int i = 0; i < groupSize; ++i) {
      if (t == builder[i]) {
        return builder[2 * groupSize + i];
      }
    }
    WASM_UNREACHABLE("unexpected type");
  };

  // A B A' B' again
  builder[8].copy(builder[0], translate);
  builder[9].copy(builder[1], translate);
  builder[10].copy(builder[2], translate);
  builder[11].copy(builder[3], translate);

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_EQ(built[0], built[8]);
  EXPECT_EQ(built[1], built[9]);
  EXPECT_EQ(built[2], built[10]);
  EXPECT_EQ(built[3], built[11]);

  EXPECT_NE(built[0].getRecGroup(), built[4].getRecGroup());
}

TEST_F(TypeTest, CanonicalizeFinal) {
  // Types are different if their finality flag is different.
  TypeBuilder builder(2);
  builder[0] = Struct{};
  builder[1].setOpen() = Struct{};

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  EXPECT_NE(built[0], built[1]);
  EXPECT_TRUE(!built[0].isOpen());
  EXPECT_FALSE(!built[1].isOpen());
}

TEST_F(TypeTest, HeapTypeConstructors) {
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

TEST_F(TypeTest, CanonicalizeTypesBeforeSubtyping) {
  TypeBuilder builder(6);
  // A rec group
  builder.createRecGroup(0, 2);
  builder[0].setOpen() = Struct{};
  builder[1].setOpen() = Struct{};
  builder[1].subTypeOf(builder[0]);

  // The same rec group again
  builder.createRecGroup(2, 2);
  builder[2].setOpen() = Struct{};
  builder[3].setOpen() = Struct{};
  builder[3].subTypeOf(builder[2]);

  // This subtyping only validates if the previous two groups are deduplicated
  // before checking subtype validity.
  builder[4].setOpen() =
    Struct({Field(builder.getTempRefType(builder[0], Nullable), Immutable)});
  builder[5].setOpen() =
    Struct({Field(builder.getTempRefType(builder[3], Nullable), Immutable)});
  builder[5].subTypeOf(builder[4]);

  auto result = builder.build();
  EXPECT_TRUE(result);
}

TEST_F(TypeTest, TestHeapTypeRelations) {
  HeapType ext = HeapType::ext;
  HeapType func = HeapType::func;
  HeapType cont = HeapType::cont;
  HeapType any = HeapType::any;
  HeapType eq = HeapType::eq;
  HeapType i31 = HeapType::i31;
  HeapType struct_ = HeapType::struct_;
  HeapType array = HeapType::array;
  HeapType string = HeapType::string;
  HeapType none = HeapType::none;
  HeapType noext = HeapType::noext;
  HeapType nofunc = HeapType::nofunc;
  HeapType nocont = HeapType::nocont;
  HeapType defFunc = Signature();
  HeapType defCont = Continuation(defFunc);
  HeapType defStruct = Struct();
  HeapType defArray = Array(Field(Type::i32, Immutable));
  HeapType sharedAny = any.getBasic(Shared);
  HeapType sharedEq = eq.getBasic(Shared);
  HeapType sharedI31 = i31.getBasic(Shared);
  HeapType sharedStruct = struct_.getBasic(Shared);
  HeapType sharedNone = none.getBasic(Shared);
  HeapType sharedFunc = func.getBasic(Shared);

  HeapType sharedDefStruct;
  HeapType sharedDefFunc;
  {
    TypeBuilder builder(2);
    builder[0] = Struct{};
    builder[1] = Signature();
    builder[0].setShared();
    builder[1].setShared();
    auto results = builder.build();
    ASSERT_TRUE(results);
    auto built = *results;
    sharedDefStruct = built[0];
    sharedDefFunc = built[1];
  }

  auto assertLUB = [](HeapType a, HeapType b, std::optional<HeapType> lub) {
    auto lub1 = HeapType::getLeastUpperBound(a, b);
    auto lub2 = HeapType::getLeastUpperBound(b, a);
    EXPECT_EQ(lub, lub1);
    EXPECT_EQ(lub1, lub2);
    if (a == b) {
      EXPECT_TRUE(HeapType::isSubType(a, b));
      EXPECT_TRUE(HeapType::isSubType(b, a));
      EXPECT_EQ(a.getTop(), b.getTop());
      EXPECT_EQ(a.getBottom(), b.getBottom());
    } else if (lub && *lub == b) {
      EXPECT_TRUE(HeapType::isSubType(a, b));
      EXPECT_FALSE(HeapType::isSubType(b, a));
      EXPECT_EQ(a.getTop(), b.getTop());
      EXPECT_EQ(a.getBottom(), b.getBottom());
    } else if (lub && *lub == a) {
      EXPECT_FALSE(HeapType::isSubType(a, b));
      EXPECT_TRUE(HeapType::isSubType(b, a));
      EXPECT_EQ(a.getTop(), b.getTop());
      EXPECT_EQ(a.getBottom(), b.getBottom());
    } else if (lub) {
      EXPECT_FALSE(HeapType::isSubType(a, b));
      EXPECT_FALSE(HeapType::isSubType(b, a));
      EXPECT_EQ(a.getTop(), b.getTop());
      EXPECT_EQ(a.getBottom(), b.getBottom());
    } else {
      EXPECT_FALSE(HeapType::isSubType(a, b));
      EXPECT_FALSE(HeapType::isSubType(b, a));
      EXPECT_NE(a.getTop(), b.getTop());
      EXPECT_NE(a.getBottom(), b.getBottom());
    }
  };

  assertLUB(ext, ext, ext);
  assertLUB(ext, func, {});
  assertLUB(ext, cont, {});
  assertLUB(ext, any, {});
  assertLUB(ext, eq, {});
  assertLUB(ext, i31, {});
  assertLUB(ext, struct_, {});
  assertLUB(ext, array, {});
  assertLUB(ext, string, ext);
  assertLUB(ext, none, {});
  assertLUB(ext, noext, ext);
  assertLUB(ext, nofunc, {});
  assertLUB(ext, nocont, {});
  assertLUB(ext, defFunc, {});
  assertLUB(ext, defStruct, {});
  assertLUB(ext, defArray, {});
  assertLUB(ext, sharedAny, {});
  assertLUB(ext, sharedEq, {});
  assertLUB(ext, sharedI31, {});
  assertLUB(ext, sharedStruct, {});
  assertLUB(ext, sharedNone, {});
  assertLUB(ext, sharedFunc, {});
  assertLUB(ext, sharedDefStruct, {});
  assertLUB(ext, sharedDefFunc, {});

  assertLUB(func, func, func);
  assertLUB(func, cont, {});
  assertLUB(func, any, {});
  assertLUB(func, eq, {});
  assertLUB(func, i31, {});
  assertLUB(func, struct_, {});
  assertLUB(func, array, {});
  assertLUB(func, string, {});
  assertLUB(func, none, {});
  assertLUB(func, noext, {});
  assertLUB(func, nofunc, func);
  assertLUB(func, nocont, {});
  assertLUB(func, defFunc, func);
  assertLUB(func, defCont, {});
  assertLUB(func, defStruct, {});
  assertLUB(func, defArray, {});
  assertLUB(func, sharedAny, {});
  assertLUB(func, sharedEq, {});
  assertLUB(func, sharedI31, {});
  assertLUB(func, sharedStruct, {});
  assertLUB(func, sharedNone, {});
  assertLUB(func, sharedFunc, {});
  assertLUB(func, sharedDefStruct, {});
  assertLUB(func, sharedDefFunc, {});

  assertLUB(cont, cont, cont);
  assertLUB(cont, func, {});
  assertLUB(cont, any, {});
  assertLUB(cont, eq, {});
  assertLUB(cont, i31, {});
  assertLUB(cont, struct_, {});
  assertLUB(cont, array, {});
  assertLUB(cont, string, {});
  assertLUB(cont, none, {});
  assertLUB(cont, noext, {});
  assertLUB(cont, nofunc, {});
  assertLUB(cont, nocont, cont);
  assertLUB(cont, defFunc, {});
  assertLUB(cont, defCont, cont);
  assertLUB(cont, defStruct, {});
  assertLUB(cont, defArray, {});
  assertLUB(cont, sharedAny, {});
  assertLUB(cont, sharedEq, {});
  assertLUB(cont, sharedI31, {});
  assertLUB(cont, sharedStruct, {});
  assertLUB(cont, sharedNone, {});
  assertLUB(cont, sharedFunc, {});
  assertLUB(cont, sharedDefStruct, {});
  assertLUB(cont, sharedDefFunc, {});

  assertLUB(any, any, any);
  assertLUB(any, cont, {});
  assertLUB(any, eq, any);
  assertLUB(any, i31, any);
  assertLUB(any, struct_, any);
  assertLUB(any, array, any);
  assertLUB(any, string, {});
  assertLUB(any, none, any);
  assertLUB(any, noext, {});
  assertLUB(any, nofunc, {});
  assertLUB(any, nocont, {});
  assertLUB(any, defFunc, {});
  assertLUB(any, defCont, {});
  assertLUB(any, defStruct, any);
  assertLUB(any, defArray, any);
  assertLUB(any, sharedAny, {});
  assertLUB(any, sharedEq, {});
  assertLUB(any, sharedI31, {});
  assertLUB(any, sharedStruct, {});
  assertLUB(any, sharedNone, {});
  assertLUB(any, sharedFunc, {});
  assertLUB(any, sharedDefStruct, {});
  assertLUB(any, sharedDefFunc, {});

  assertLUB(eq, eq, eq);
  assertLUB(eq, cont, {});
  assertLUB(eq, i31, eq);
  assertLUB(eq, struct_, eq);
  assertLUB(eq, array, eq);
  assertLUB(eq, string, {});
  assertLUB(eq, none, eq);
  assertLUB(eq, noext, {});
  assertLUB(eq, nofunc, {});
  assertLUB(eq, nocont, {});
  assertLUB(eq, defFunc, {});
  assertLUB(eq, defCont, {});
  assertLUB(eq, defStruct, eq);
  assertLUB(eq, defArray, eq);
  assertLUB(eq, sharedAny, {});
  assertLUB(eq, sharedEq, {});
  assertLUB(eq, sharedI31, {});
  assertLUB(eq, sharedStruct, {});
  assertLUB(eq, sharedNone, {});
  assertLUB(eq, sharedFunc, {});
  assertLUB(eq, sharedDefStruct, {});
  assertLUB(eq, sharedDefFunc, {});

  assertLUB(i31, i31, i31);
  assertLUB(i31, cont, {});
  assertLUB(i31, struct_, eq);
  assertLUB(i31, array, eq);
  assertLUB(i31, string, {});
  assertLUB(i31, none, i31);
  assertLUB(i31, noext, {});
  assertLUB(i31, nofunc, {});
  assertLUB(i31, nocont, {});
  assertLUB(i31, defFunc, {});
  assertLUB(i31, defCont, {});
  assertLUB(i31, defStruct, eq);
  assertLUB(i31, defArray, eq);
  assertLUB(i31, sharedAny, {});
  assertLUB(i31, sharedEq, {});
  assertLUB(i31, sharedI31, {});
  assertLUB(i31, sharedStruct, {});
  assertLUB(i31, sharedNone, {});
  assertLUB(i31, sharedFunc, {});
  assertLUB(i31, sharedDefStruct, {});
  assertLUB(i31, sharedDefFunc, {});

  assertLUB(struct_, struct_, struct_);
  assertLUB(struct_, cont, {});
  assertLUB(struct_, array, eq);
  assertLUB(struct_, string, {});
  assertLUB(struct_, none, struct_);
  assertLUB(struct_, noext, {});
  assertLUB(struct_, nofunc, {});
  assertLUB(struct_, nocont, {});
  assertLUB(struct_, defFunc, {});
  assertLUB(struct_, defCont, {});
  assertLUB(struct_, defStruct, struct_);
  assertLUB(struct_, defArray, eq);
  assertLUB(struct_, sharedAny, {});
  assertLUB(struct_, sharedEq, {});
  assertLUB(struct_, sharedI31, {});
  assertLUB(struct_, sharedStruct, {});
  assertLUB(struct_, sharedNone, {});
  assertLUB(struct_, sharedFunc, {});
  assertLUB(struct_, sharedDefStruct, {});
  assertLUB(struct_, sharedDefFunc, {});

  assertLUB(array, array, array);
  assertLUB(array, cont, {});
  assertLUB(array, string, {});
  assertLUB(array, none, array);
  assertLUB(array, noext, {});
  assertLUB(array, nofunc, {});
  assertLUB(array, nocont, {});
  assertLUB(array, defFunc, {});
  assertLUB(array, defCont, {});
  assertLUB(array, defStruct, eq);
  assertLUB(array, defArray, array);
  assertLUB(array, sharedAny, {});
  assertLUB(array, sharedEq, {});
  assertLUB(array, sharedI31, {});
  assertLUB(array, sharedStruct, {});
  assertLUB(array, sharedNone, {});
  assertLUB(array, sharedFunc, {});
  assertLUB(array, sharedDefStruct, {});
  assertLUB(array, sharedDefFunc, {});

  assertLUB(string, string, string);
  assertLUB(string, cont, {});
  assertLUB(string, none, {});
  assertLUB(string, noext, string);
  assertLUB(string, nofunc, {});
  assertLUB(string, nocont, {});
  assertLUB(string, defFunc, {});
  assertLUB(string, defCont, {});
  assertLUB(string, defStruct, {});
  assertLUB(string, defArray, {});
  assertLUB(string, sharedAny, {});
  assertLUB(string, sharedEq, {});
  assertLUB(string, sharedI31, {});
  assertLUB(string, sharedStruct, {});
  assertLUB(string, sharedNone, {});
  assertLUB(string, sharedFunc, {});
  assertLUB(string, sharedDefStruct, {});
  assertLUB(string, sharedDefFunc, {});

  assertLUB(none, none, none);
  assertLUB(none, noext, {});
  assertLUB(none, nofunc, {});
  assertLUB(none, nocont, {});
  assertLUB(none, defFunc, {});
  assertLUB(none, defCont, {});
  assertLUB(none, defStruct, defStruct);
  assertLUB(none, defArray, defArray);
  assertLUB(none, sharedAny, {});
  assertLUB(none, sharedEq, {});
  assertLUB(none, sharedI31, {});
  assertLUB(none, sharedStruct, {});
  assertLUB(none, sharedNone, {});
  assertLUB(none, sharedFunc, {});
  assertLUB(none, sharedDefStruct, {});
  assertLUB(none, sharedDefFunc, {});

  assertLUB(noext, noext, noext);
  assertLUB(noext, nofunc, {});
  assertLUB(noext, nocont, {});
  assertLUB(noext, defFunc, {});
  assertLUB(noext, defCont, {});
  assertLUB(noext, defStruct, {});
  assertLUB(noext, defArray, {});
  assertLUB(noext, sharedAny, {});
  assertLUB(noext, sharedEq, {});
  assertLUB(noext, sharedI31, {});
  assertLUB(noext, sharedStruct, {});
  assertLUB(noext, sharedNone, {});
  assertLUB(noext, sharedFunc, {});
  assertLUB(noext, sharedDefStruct, {});
  assertLUB(noext, sharedDefFunc, {});

  assertLUB(nofunc, nofunc, nofunc);
  assertLUB(nofunc, nocont, {});
  assertLUB(nofunc, defFunc, defFunc);
  assertLUB(nofunc, defCont, {});
  assertLUB(nofunc, defStruct, {});
  assertLUB(nofunc, defArray, {});
  assertLUB(nofunc, sharedAny, {});
  assertLUB(nofunc, sharedEq, {});
  assertLUB(nofunc, sharedI31, {});
  assertLUB(nofunc, sharedStruct, {});
  assertLUB(nofunc, sharedNone, {});
  assertLUB(nofunc, sharedFunc, {});
  assertLUB(nofunc, sharedDefStruct, {});
  assertLUB(nofunc, sharedDefFunc, {});

  assertLUB(nocont, nocont, nocont);
  assertLUB(nocont, func, {});
  assertLUB(nocont, cont, cont);
  assertLUB(nocont, nofunc, {});
  assertLUB(nocont, defFunc, {});
  assertLUB(nocont, defCont, defCont);
  assertLUB(nocont, defStruct, {});
  assertLUB(nocont, defArray, {});
  assertLUB(nocont, sharedAny, {});
  assertLUB(nocont, sharedEq, {});
  assertLUB(nocont, sharedI31, {});
  assertLUB(nocont, sharedStruct, {});
  assertLUB(nocont, sharedNone, {});
  assertLUB(nocont, sharedFunc, {});
  assertLUB(nocont, sharedDefStruct, {});
  assertLUB(nocont, sharedDefFunc, {});

  assertLUB(defFunc, defFunc, defFunc);
  assertLUB(defFunc, defCont, {});
  assertLUB(defFunc, defStruct, {});
  assertLUB(defFunc, defArray, {});
  assertLUB(defFunc, sharedAny, {});
  assertLUB(defFunc, sharedEq, {});
  assertLUB(defFunc, sharedI31, {});
  assertLUB(defFunc, sharedStruct, {});
  assertLUB(defFunc, sharedNone, {});
  assertLUB(defFunc, sharedFunc, {});
  assertLUB(defFunc, sharedDefStruct, {});
  assertLUB(defFunc, sharedDefFunc, {});

  assertLUB(defCont, defCont, defCont);
  assertLUB(defCont, defFunc, {});
  assertLUB(defCont, defStruct, {});
  assertLUB(defCont, defArray, {});
  assertLUB(defCont, sharedAny, {});
  assertLUB(defCont, sharedEq, {});
  assertLUB(defCont, sharedI31, {});
  assertLUB(defCont, sharedStruct, {});
  assertLUB(defCont, sharedNone, {});
  assertLUB(defCont, sharedFunc, {});
  assertLUB(defCont, sharedDefStruct, {});
  assertLUB(defCont, sharedDefFunc, {});

  assertLUB(defStruct, defStruct, defStruct);
  assertLUB(defStruct, defArray, eq);
  assertLUB(defStruct, sharedAny, {});
  assertLUB(defStruct, sharedEq, {});
  assertLUB(defStruct, sharedI31, {});
  assertLUB(defStruct, sharedStruct, {});
  assertLUB(defStruct, sharedNone, {});
  assertLUB(defStruct, sharedFunc, {});
  assertLUB(defStruct, sharedDefStruct, {});
  assertLUB(defStruct, sharedDefFunc, {});

  assertLUB(defArray, defArray, defArray);
  assertLUB(defArray, sharedAny, {});
  assertLUB(defArray, sharedEq, {});
  assertLUB(defArray, sharedI31, {});
  assertLUB(defArray, sharedStruct, {});
  assertLUB(defArray, sharedNone, {});
  assertLUB(defArray, sharedFunc, {});
  assertLUB(defArray, sharedDefStruct, {});
  assertLUB(defArray, sharedDefFunc, {});

  assertLUB(sharedAny, sharedAny, sharedAny);
  assertLUB(sharedAny, sharedEq, sharedAny);
  assertLUB(sharedAny, sharedI31, sharedAny);
  assertLUB(sharedAny, sharedStruct, sharedAny);
  assertLUB(sharedAny, sharedNone, sharedAny);
  assertLUB(sharedAny, sharedFunc, {});
  assertLUB(sharedAny, sharedDefStruct, sharedAny);
  assertLUB(sharedAny, sharedDefFunc, {});

  assertLUB(sharedEq, sharedEq, sharedEq);
  assertLUB(sharedEq, sharedI31, sharedEq);
  assertLUB(sharedEq, sharedStruct, sharedEq);
  assertLUB(sharedEq, sharedNone, sharedEq);
  assertLUB(sharedEq, sharedFunc, {});
  assertLUB(sharedEq, sharedDefStruct, sharedEq);
  assertLUB(sharedEq, sharedDefFunc, {});

  assertLUB(sharedI31, sharedI31, sharedI31);
  assertLUB(sharedI31, sharedStruct, sharedEq);
  assertLUB(sharedI31, sharedNone, sharedI31);
  assertLUB(sharedI31, sharedFunc, {});
  assertLUB(sharedI31, sharedDefStruct, sharedEq);
  assertLUB(sharedI31, sharedDefFunc, {});

  assertLUB(sharedStruct, sharedStruct, sharedStruct);
  assertLUB(sharedStruct, sharedNone, sharedStruct);
  assertLUB(sharedStruct, sharedFunc, {});
  assertLUB(sharedStruct, sharedDefStruct, sharedStruct);
  assertLUB(sharedStruct, sharedDefFunc, {});

  assertLUB(sharedNone, sharedNone, sharedNone);
  assertLUB(sharedNone, sharedFunc, {});
  assertLUB(sharedNone, sharedDefStruct, sharedDefStruct);
  assertLUB(sharedNone, sharedDefFunc, {});

  assertLUB(sharedFunc, sharedFunc, sharedFunc);
  assertLUB(sharedFunc, sharedDefStruct, {});
  assertLUB(sharedFunc, sharedDefFunc, sharedFunc);

  assertLUB(sharedDefStruct, sharedDefStruct, sharedDefStruct);
  assertLUB(sharedDefStruct, sharedDefFunc, {});

  assertLUB(sharedDefFunc, sharedDefFunc, sharedDefFunc);

  Type anyref = Type(any, Nullable);
  Type eqref = Type(eq, Nullable);

  {
    // Nullable and non-nullable references.
    Type nonNullable(any, NonNullable);
    EXPECT_TRUE(Type::isSubType(nonNullable, anyref));
    EXPECT_FALSE(Type::isSubType(anyref, nonNullable));
    EXPECT_TRUE(Type::hasLeastUpperBound(anyref, nonNullable));
    EXPECT_EQ(Type::getLeastUpperBound(anyref, nonNullable), anyref);
  }

  {
    // Immutable array fields are covariant.
    TypeBuilder builder(2);
    builder[0].setOpen() = Array(Field(anyref, Immutable));
    builder[1].setOpen().subTypeOf(builder[0]) = Array(Field(eqref, Immutable));
    auto results = builder.build();
    ASSERT_TRUE(results);
    auto built = *results;
    EXPECT_TRUE(HeapType::isSubType(built[1], built[0]));
  }

  {
    // Depth subtyping
    TypeBuilder builder(2);
    builder[0].setOpen() = Struct({Field(anyref, Immutable)});
    builder[1].setOpen().subTypeOf(builder[0]) =
      Struct({Field(eqref, Immutable)});
    auto results = builder.build();
    ASSERT_TRUE(results);
    auto built = *results;
    EXPECT_TRUE(HeapType::isSubType(built[1], built[0]));
  }

  {
    // Width subtyping
    TypeBuilder builder(2);
    builder[0].setOpen() = Struct({Field(anyref, Immutable)});
    builder[1].setOpen().subTypeOf(builder[0]) =
      Struct({Field(anyref, Immutable), Field(anyref, Immutable)});
    auto results = builder.build();
    ASSERT_TRUE(results);
    auto built = *results;
    EXPECT_TRUE(HeapType::isSubType(built[1], built[0]));
  }

  {
    // Nested structs
    TypeBuilder builder(4);
    auto ref0 = builder.getTempRefType(builder[0], Nullable);
    auto ref1 = builder.getTempRefType(builder[1], Nullable);
    builder[0].setOpen() = Struct({Field(anyref, Immutable)});
    builder[1].setOpen().subTypeOf(builder[0]) =
      Struct({Field(eqref, Immutable)});
    builder[2].setOpen() = Struct({Field(ref0, Immutable)});
    builder[3].setOpen().subTypeOf(builder[2]) =
      Struct({Field(ref1, Immutable)});
    auto results = builder.build();
    ASSERT_TRUE(results);
    auto built = *results;
    EXPECT_TRUE(HeapType::isSubType(built[3], built[2]));
  }

  {
    // Recursive structs
    TypeBuilder builder(2);
    auto ref0 = builder.getTempRefType(builder[0], Nullable);
    auto ref1 = builder.getTempRefType(builder[1], Nullable);
    builder[0].setOpen() = Struct({Field(ref0, Immutable)});
    builder[1].setOpen().subTypeOf(builder[0]) =
      Struct({Field(ref1, Immutable)});
    auto results = builder.build();
    ASSERT_TRUE(results);
    auto built = *results;
    EXPECT_TRUE(HeapType::isSubType(built[1], built[0]));
  }
}

#ifdef FUZZTEST

void TestHeapTypeRelationsFuzz(std::pair<HeapType, HeapType> pair) {
  auto [a, b] = pair;
  auto lub = HeapType::getLeastUpperBound(a, b);
  auto otherLub = HeapType::getLeastUpperBound(b, a);
  EXPECT_EQ(lub, otherLub);
  if (lub) {
    EXPECT_EQ(a.getTop(), b.getTop());
    EXPECT_EQ(a.getBottom(), b.getBottom());
    EXPECT_TRUE(HeapType::isSubType(a, *lub));
    EXPECT_TRUE(HeapType::isSubType(b, *lub));
  } else {
    EXPECT_NE(a.getTop(), b.getTop());
    EXPECT_NE(a.getBottom(), b.getBottom());
  }
  if (a == b) {
    EXPECT_EQ(lub, a);
    EXPECT_EQ(lub, b);
  } else if (lub && *lub == b) {
    EXPECT_TRUE(HeapType::isSubType(a, b));
    EXPECT_FALSE(HeapType::isSubType(b, a));
  } else if (lub && *lub == a) {
    EXPECT_FALSE(HeapType::isSubType(a, b));
    EXPECT_TRUE(HeapType::isSubType(b, a));
  } else if (lub) {
    EXPECT_FALSE(HeapType::isSubType(a, b));
    EXPECT_FALSE(HeapType::isSubType(b, a));
  }
}
FUZZ_TEST(TypeFuzzTest, TestHeapTypeRelationsFuzz)
  .WithDomains(ArbitraryHeapTypePair());

#endif // FUZZTEST

TEST_F(TypeTest, TestTypeRelations) {
  HeapType definedSuper, definedSub;
  {
    TypeBuilder builder(2);
    builder[0].setOpen() = Struct();
    builder[1] = Struct();
    builder[1].subTypeOf(builder[0]);
    auto built = builder.build();
    ASSERT_TRUE(built);
    definedSuper = (*built)[0];
    definedSub = (*built)[1];
  }

  Type any = Type(HeapType::any, NonNullable, Inexact);
  Type nullAny = Type(HeapType::any, Nullable, Inexact);

  Type sup = Type(definedSuper, NonNullable, Inexact);
  Type nullSup = Type(definedSuper, Nullable, Inexact);
  Type exactSup = Type(definedSuper, NonNullable, Exact);
  Type nullExactSup = Type(definedSuper, Nullable, Exact);

  Type sub = Type(definedSub, NonNullable, Inexact);
  Type nullSub = Type(definedSub, Nullable, Inexact);
  Type exactSub = Type(definedSub, NonNullable, Exact);
  Type nullExactSub = Type(definedSub, Nullable, Exact);

  Type none = Type(HeapType::none, NonNullable, Inexact);
  Type nullNone = Type(HeapType::none, Nullable, Inexact);

  Type func = Type(HeapType::func, NonNullable, Inexact);
  Type nullFunc = Type(HeapType::func, Nullable, Inexact);

  Type i32 = Type::i32;
  Type unreachable = Type::unreachable;

  auto assertLUB = [](Type a, Type b, Type lub, Type glb) {
    auto lub1 = Type::getLeastUpperBound(a, b);
    auto lub2 = Type::getLeastUpperBound(b, a);
    EXPECT_EQ(lub, lub1);
    EXPECT_EQ(lub1, lub2);
    if (lub != Type::none) {
      EXPECT_TRUE(Type::isSubType(a, lub));
      EXPECT_TRUE(Type::isSubType(b, lub));
    }
    auto glb1 = Type::getGreatestLowerBound(a, b);
    auto glb2 = Type::getGreatestLowerBound(b, a);
    EXPECT_EQ(glb, glb1);
    EXPECT_EQ(glb, glb2);
    EXPECT_TRUE(Type::isSubType(glb, a));
    EXPECT_TRUE(Type::isSubType(glb, b));
    if (a == b) {
      EXPECT_TRUE(Type::isSubType(a, b));
      EXPECT_TRUE(Type::isSubType(b, a));
      EXPECT_EQ(lub, a);
      EXPECT_EQ(glb, a);
    } else if (lub == b) {
      EXPECT_TRUE(Type::isSubType(a, b));
      EXPECT_FALSE(Type::isSubType(b, a));
      EXPECT_EQ(glb, a);
    } else if (lub == a) {
      EXPECT_FALSE(Type::isSubType(a, b));
      EXPECT_TRUE(Type::isSubType(b, a));
      EXPECT_EQ(glb, b);
    } else if (lub != Type::none) {
      EXPECT_FALSE(Type::isSubType(a, b));
      EXPECT_FALSE(Type::isSubType(b, a));
      EXPECT_NE(glb, a);
      EXPECT_NE(glb, b);
    } else {
      EXPECT_FALSE(Type::isSubType(a, b));
      EXPECT_FALSE(Type::isSubType(b, a));
    }

    if (a.isRef() && b.isRef()) {
      auto htA = a.getHeapType();
      auto htB = b.getHeapType();

      if (lub == Type::none) {
        EXPECT_NE(htA.getTop(), htB.getTop());
        EXPECT_NE(htA.getBottom(), htB.getBottom());
      } else {
        EXPECT_EQ(htA.getTop(), htB.getTop());
        EXPECT_EQ(htA.getBottom(), htB.getBottom());
      }
    }
  };

  assertLUB(any, any, any, any);
  assertLUB(any, nullAny, nullAny, any);
  assertLUB(any, sup, any, sup);
  assertLUB(any, nullSup, nullAny, sup);
  assertLUB(any, exactSup, any, exactSup);
  assertLUB(any, nullExactSup, nullAny, exactSup);
  assertLUB(any, sub, any, sub);
  assertLUB(any, nullSub, nullAny, sub);
  assertLUB(any, exactSub, any, exactSub);
  assertLUB(any, nullExactSub, nullAny, exactSub);
  assertLUB(any, none, any, none);
  assertLUB(any, nullNone, nullAny, none);
  assertLUB(any, func, Type(Type::none), unreachable);
  assertLUB(any, nullFunc, Type(Type::none), unreachable);
  assertLUB(any, i32, Type(Type::none), unreachable);
  assertLUB(any, unreachable, any, unreachable);

  assertLUB(nullAny, nullAny, nullAny, nullAny);
  assertLUB(nullAny, sup, nullAny, sup);
  assertLUB(nullAny, nullSup, nullAny, nullSup);
  assertLUB(nullAny, exactSup, nullAny, exactSup);
  assertLUB(nullAny, nullExactSup, nullAny, nullExactSup);
  assertLUB(nullAny, sub, nullAny, sub);
  assertLUB(nullAny, nullSub, nullAny, nullSub);
  assertLUB(nullAny, exactSub, nullAny, exactSub);
  assertLUB(nullAny, nullExactSub, nullAny, nullExactSub);
  assertLUB(nullAny, none, nullAny, none);
  assertLUB(nullAny, nullNone, nullAny, nullNone);
  assertLUB(nullAny, func, Type(Type::none), unreachable);
  assertLUB(nullAny, nullFunc, Type(Type::none), unreachable);
  assertLUB(nullAny, i32, Type(Type::none), unreachable);
  assertLUB(nullAny, unreachable, nullAny, unreachable);

  assertLUB(sup, sup, sup, sup);
  assertLUB(sup, nullSup, nullSup, sup);
  assertLUB(sup, exactSup, sup, exactSup);
  assertLUB(sup, nullExactSup, nullSup, exactSup);
  assertLUB(sup, sub, sup, sub);
  assertLUB(sup, nullSub, nullSup, sub);
  assertLUB(sup, exactSub, sup, exactSub);
  assertLUB(sup, nullExactSub, nullSup, exactSub);
  assertLUB(sup, none, sup, none);
  assertLUB(sup, nullNone, nullSup, none);
  assertLUB(sup, func, Type(Type::none), unreachable);
  assertLUB(sup, nullFunc, Type(Type::none), unreachable);
  assertLUB(sup, i32, Type(Type::none), unreachable);
  assertLUB(sup, unreachable, sup, unreachable);

  assertLUB(nullSup, nullSup, nullSup, nullSup);
  assertLUB(nullSup, exactSup, nullSup, exactSup);
  assertLUB(nullSup, nullExactSup, nullSup, nullExactSup);
  assertLUB(nullSup, sub, nullSup, sub);
  assertLUB(nullSup, nullSub, nullSup, nullSub);
  assertLUB(nullSup, exactSub, nullSup, exactSub);
  assertLUB(nullSup, nullExactSub, nullSup, nullExactSub);
  assertLUB(nullSup, none, nullSup, none);
  assertLUB(nullSup, nullNone, nullSup, nullNone);
  assertLUB(nullSup, func, Type(Type::none), unreachable);
  assertLUB(nullSup, nullFunc, Type(Type::none), unreachable);
  assertLUB(nullSup, i32, Type(Type::none), unreachable);
  assertLUB(nullSup, unreachable, nullSup, unreachable);

  assertLUB(exactSup, exactSup, exactSup, exactSup);
  assertLUB(exactSup, nullExactSup, nullExactSup, exactSup);
  assertLUB(exactSup, sub, sup, none);
  assertLUB(exactSup, nullSub, nullSup, none);
  assertLUB(exactSup, exactSub, sup, none);
  assertLUB(exactSup, nullExactSub, nullSup, none);
  assertLUB(exactSup, none, exactSup, none);
  assertLUB(exactSup, nullNone, nullExactSup, none);
  assertLUB(exactSup, func, Type(Type::none), unreachable);
  assertLUB(exactSup, nullFunc, Type(Type::none), unreachable);
  assertLUB(exactSup, i32, Type(Type::none), unreachable);
  assertLUB(exactSup, unreachable, exactSup, unreachable);

  assertLUB(nullExactSup, nullExactSup, nullExactSup, nullExactSup);
  assertLUB(nullExactSup, sub, nullSup, none);
  assertLUB(nullExactSup, nullSub, nullSup, nullNone);
  assertLUB(nullExactSup, exactSub, nullSup, none);
  assertLUB(nullExactSup, nullExactSub, nullSup, nullNone);
  assertLUB(nullExactSup, none, nullExactSup, none);
  assertLUB(nullExactSup, nullNone, nullExactSup, nullNone);
  assertLUB(nullExactSup, func, Type(Type::none), unreachable);
  assertLUB(nullExactSup, nullFunc, Type(Type::none), unreachable);
  assertLUB(nullExactSup, i32, Type(Type::none), unreachable);
  assertLUB(nullExactSup, unreachable, nullExactSup, unreachable);

  assertLUB(sub, sub, sub, sub);
  assertLUB(sub, nullSub, nullSub, sub);
  assertLUB(sub, exactSub, sub, exactSub);
  assertLUB(sub, nullExactSub, nullSub, exactSub);
  assertLUB(sub, none, sub, none);
  assertLUB(sub, nullNone, nullSub, none);
  assertLUB(sub, func, Type(Type::none), unreachable);
  assertLUB(sub, nullFunc, Type(Type::none), unreachable);
  assertLUB(sub, i32, Type(Type::none), unreachable);
  assertLUB(sub, unreachable, sub, unreachable);

  assertLUB(nullSub, nullSub, nullSub, nullSub);
  assertLUB(nullSub, exactSub, nullSub, exactSub);
  assertLUB(nullSub, nullExactSub, nullSub, nullExactSub);
  assertLUB(nullSub, none, nullSub, none);
  assertLUB(nullSub, nullNone, nullSub, nullNone);
  assertLUB(nullSub, func, Type(Type::none), unreachable);
  assertLUB(nullSub, nullFunc, Type(Type::none), unreachable);
  assertLUB(nullSub, i32, Type(Type::none), unreachable);
  assertLUB(nullSub, unreachable, nullSub, unreachable);

  assertLUB(exactSub, exactSub, exactSub, exactSub);
  assertLUB(exactSub, nullExactSub, nullExactSub, exactSub);
  assertLUB(exactSub, none, exactSub, none);
  assertLUB(exactSub, nullNone, nullExactSub, none);
  assertLUB(exactSub, func, Type(Type::none), unreachable);
  assertLUB(exactSub, nullFunc, Type(Type::none), unreachable);
  assertLUB(exactSub, i32, Type(Type::none), unreachable);
  assertLUB(exactSub, unreachable, exactSub, unreachable);

  assertLUB(nullExactSub, nullExactSub, nullExactSub, nullExactSub);
  assertLUB(nullExactSub, none, nullExactSub, none);
  assertLUB(nullExactSub, nullNone, nullExactSub, nullNone);
  assertLUB(nullExactSub, func, Type(Type::none), unreachable);
  assertLUB(nullExactSub, nullFunc, Type(Type::none), unreachable);
  assertLUB(nullExactSub, i32, Type(Type::none), unreachable);
  assertLUB(nullExactSub, unreachable, nullExactSub, unreachable);

  assertLUB(none, none, none, none);
  assertLUB(none, nullNone, nullNone, none);
  assertLUB(none, func, Type(Type::none), unreachable);
  assertLUB(none, nullFunc, Type(Type::none), unreachable);
  assertLUB(none, i32, Type(Type::none), unreachable);
  assertLUB(none, unreachable, none, unreachable);

  assertLUB(nullNone, nullNone, nullNone, nullNone);
  assertLUB(nullNone, func, Type(Type::none), unreachable);
  assertLUB(nullNone, nullFunc, Type(Type::none), unreachable);
  assertLUB(nullNone, i32, Type(Type::none), unreachable);
  assertLUB(nullNone, unreachable, nullNone, unreachable);
}

TEST_F(TypeTest, TestSubtypeErrors) {
  Type anyref = Type(HeapType::any, Nullable);
  Type eqref = Type(HeapType::eq, Nullable);
  Type funcref = Type(HeapType::func, Nullable);

  {
    // Incompatible signatures.
    TypeBuilder builder(2);
    builder[0] = Signature(Type::none, anyref);
    builder[1] = Signature(anyref, Type::none);
    builder[1].subTypeOf(builder[0]);
    EXPECT_FALSE(builder.build());
  }

  {
    // Signatures incompatible in tuple size.
    TypeBuilder builder(2);
    builder[0] = Signature(Type::none, {anyref, anyref});
    builder[1] = Signature(Type::none, {anyref, anyref, anyref});
    builder[1].subTypeOf(builder[0]);
    EXPECT_FALSE(builder.build());
  }

  {
    // Mutable array fields are invariant.
    TypeBuilder builder(2);
    builder[0] = Array(Field(anyref, Mutable));
    builder[1] = Array(Field(eqref, Mutable));
    builder[1].subTypeOf(builder[0]);
    EXPECT_FALSE(builder.build());
  }

  {
    // Incompatible struct prefixes
    TypeBuilder builder(2);
    builder[0] = Struct({Field(anyref, Immutable), Field(anyref, Immutable)});
    builder[1] = Struct({Field(funcref, Immutable), Field(anyref, Immutable)});
    builder[1].subTypeOf(builder[0]);
    EXPECT_FALSE(builder.build());
  }
}

// Test SubTypes utility code.
TEST_F(TypeTest, TestSubTypes) {
  Type anyref = Type(HeapType::any, Nullable);
  Type eqref = Type(HeapType::eq, Nullable);
  Type sharedAnyref = Type(HeapTypes::any.getBasic(Shared), Nullable);
  Type sharedEqref = Type(HeapTypes::eq.getBasic(Shared), Nullable);

  // Build type types, the second of which is a subtype.
  TypeBuilder builder(4);
  builder[0].setOpen() = Struct({Field(anyref, Immutable)});
  builder[1].setOpen() = Struct({Field(eqref, Immutable)});
  // Make shared versions, too.
  builder[2].setOpen().setShared() = Array(Field(sharedAnyref, Immutable));
  builder[3].setOpen().setShared() = Array(Field(sharedEqref, Immutable));
  builder[1].subTypeOf(builder[0]);
  builder[3].subTypeOf(builder[2]);

  auto result = builder.build();
  ASSERT_TRUE(result);
  auto built = *result;

  // Build a tiny wasm module that uses the types, so that we can test the
  // SubTypes utility code.
  Module wasm;
  Builder wasmBuilder(wasm);
  wasm.addFunction(wasmBuilder.makeFunction("func",
                                            Signature(Type::none, Type::none),
                                            {Type(built[0], Nullable),
                                             Type(built[1], Nullable),
                                             Type(built[2], Nullable),
                                             Type(built[3], Nullable)},
                                            wasmBuilder.makeNop()));
  SubTypes subTypes(wasm);
  auto immSubTypes0 = subTypes.getImmediateSubTypes(built[0]);
  ASSERT_EQ(immSubTypes0.size(), 1u);
  EXPECT_EQ(immSubTypes0[0], built[1]);
  auto subTypes0 = subTypes.getSubTypes(built[0]);
  ASSERT_EQ(subTypes0.size(), 2u);
  EXPECT_EQ(subTypes0[0], built[1]);
  EXPECT_EQ(subTypes0[1], built[0]);
  auto immSubTypes1 = subTypes.getImmediateSubTypes(built[1]);
  EXPECT_EQ(immSubTypes1.size(), 0u);

  auto depths = subTypes.getMaxDepths();
  EXPECT_EQ(depths[HeapTypes::any.getBasic(Unshared)], 4u);
  EXPECT_EQ(depths[HeapTypes::any.getBasic(Shared)], 4u);
  EXPECT_EQ(depths[HeapTypes::eq.getBasic(Unshared)], 3u);
  EXPECT_EQ(depths[HeapTypes::eq.getBasic(Shared)], 3u);
  EXPECT_EQ(depths[HeapTypes::struct_.getBasic(Unshared)], 2u);
  EXPECT_EQ(depths[HeapTypes::struct_.getBasic(Shared)], 0u);
  EXPECT_EQ(depths[HeapTypes::array.getBasic(Unshared)], 0u);
  EXPECT_EQ(depths[HeapTypes::array.getBasic(Shared)], 2u);
  EXPECT_EQ(depths[built[0]], 1u);
  EXPECT_EQ(depths[built[1]], 0u);
  EXPECT_EQ(depths[built[2]], 1u);
  EXPECT_EQ(depths[built[3]], 0u);
}

// Test reuse of a previously built type as supertype.
TEST_F(TypeTest, TestExistingSuperType) {
  // Build an initial type A1
  Type A1;
  {
    TypeBuilder builder(1);
    builder[0].setOpen() = Struct();
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    A1 = Type(built[0], Nullable);
  }

  // Build a separate type A2 identical to A1
  Type A2;
  {
    TypeBuilder builder(1);
    builder[0].setOpen() = Struct();
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    A2 = Type(built[0], Nullable);
  }

  // Build a type B1 <: A1 using a new builder
  Type B1;
  {
    TypeBuilder builder(1);
    builder[0].setOpen().subTypeOf(A1.getHeapType()) = Struct();
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    B1 = Type(built[0], Nullable);
  }

  // Build a type B2 <: A2 using a new builder
  Type B2;
  {
    TypeBuilder builder(1);
    builder[0].setOpen().subTypeOf(A2.getHeapType()) = Struct();
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    B2 = Type(built[0], Nullable);
  }

  // Test that A1 == A2 and B1 == B2
  EXPECT_EQ(A1.getHeapType(), A2.getHeapType());
  EXPECT_EQ(B1.getHeapType(), B2.getHeapType());
}

// Test .getMaxDepths() helper.
TEST_F(TypeTest, TestMaxStructDepths) {
  /*
      A
      |
      B
  */
  HeapType A, B;
  {
    TypeBuilder builder(2);
    builder[0].setOpen() = Struct();
    builder[1].setOpen().subTypeOf(builder[0]) = Struct();
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    A = built[0];
    B = built[1];
  }

  SubTypes subTypes({A, B});
  auto maxDepths = subTypes.getMaxDepths();

  EXPECT_EQ(maxDepths[B], Index(0));
  EXPECT_EQ(maxDepths[A], Index(1));
  EXPECT_EQ(maxDepths[HeapType::struct_], Index(2));
  EXPECT_EQ(maxDepths[HeapType::eq], Index(3));
  EXPECT_EQ(maxDepths[HeapType::any], Index(4));
}

TEST_F(TypeTest, TestMaxArrayDepths) {
  HeapType A;
  {
    TypeBuilder builder(1);
    builder[0] = Array(Field(Type::i32, Immutable));
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    A = built[0];
  }

  SubTypes subTypes({A});
  auto maxDepths = subTypes.getMaxDepths();

  EXPECT_EQ(maxDepths[A], Index(0));
  EXPECT_EQ(maxDepths[HeapType::array], Index(1));
  EXPECT_EQ(maxDepths[HeapType::eq], Index(2));
  EXPECT_EQ(maxDepths[HeapType::any], Index(3));
}

// Test .depth() helper.
TEST_F(TypeTest, TestDepth) {
  HeapType A, B, C;
  HeapType sig = HeapType(Signature(Type::none, Type::none));
  {
    TypeBuilder builder(3);
    builder[0].setOpen() = Struct();
    builder[1].setOpen().subTypeOf(builder[0]) = Struct();
    builder[2].setOpen() = Array(Field(Type::i32, Immutable));
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    A = built[0];
    B = built[1];
    C = built[2];
  }

  // any :> eq :> array :> specific array types
  EXPECT_EQ(HeapTypes::any.getDepth(), 0U);
  EXPECT_EQ(HeapTypes::eq.getDepth(), 1U);
  EXPECT_EQ(HeapTypes::array.getDepth(), 2U);
  EXPECT_EQ(HeapTypes::struct_.getDepth(), 2U);
  EXPECT_EQ(A.getDepth(), 3U);
  EXPECT_EQ(B.getDepth(), 4U);
  EXPECT_EQ(C.getDepth(), 3U);

  // Signature types are subtypes of func.
  EXPECT_EQ(HeapTypes::func.getDepth(), 0U);
  EXPECT_EQ(sig.getDepth(), 1U);

  // Continuation types are subtypes of cont.
  EXPECT_EQ(HeapTypes::cont.getDepth(), 0U);
  EXPECT_EQ(HeapType(Continuation(sig)).getDepth(), 1U);

  EXPECT_EQ(HeapTypes::ext.getDepth(), 0U);

  EXPECT_EQ(HeapTypes::i31.getDepth(), 2U);
  EXPECT_EQ(HeapTypes::string.getDepth(), 1U);

  EXPECT_EQ(HeapTypes::none.getDepth(), size_t(-1));
  EXPECT_EQ(HeapTypes::nofunc.getDepth(), size_t(-1));
  EXPECT_EQ(HeapTypes::noext.getDepth(), size_t(-1));
}

// Test .iterSubTypes() helper.
TEST_F(TypeTest, TestIterSubTypes) {
  /*
        A
       / \
      B   C
           \
            D
  */
  HeapType A, B, C, D;
  {
    TypeBuilder builder(4);
    builder[0].setOpen() = Struct();
    builder[1].setOpen().subTypeOf(builder[0]) = Struct();
    builder[2].setOpen().subTypeOf(builder[0]) = Struct();
    builder[3].setOpen().subTypeOf(builder[2]) = Struct();
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    A = built[0];
    B = built[1];
    C = built[2];
    D = built[3];
  }

  SubTypes subTypes({A, B, C, D});

  // Helper for comparing sets of types + their corresponding depth.
  using TypeDepths = std::unordered_set<std::pair<HeapType, Index>>;

  auto getSubTypes = [&](HeapType type, Index depth) {
    TypeDepths ret;
    subTypes.iterSubTypes(type, depth, [&](HeapType subType, Index depth) {
      ret.insert({subType, depth});
    });
    return ret;
  };

  EXPECT_EQ(getSubTypes(A, 0), TypeDepths({{A, 0}}));
  EXPECT_EQ(getSubTypes(A, 1), TypeDepths({{A, 0}, {B, 1}, {C, 1}}));
  EXPECT_EQ(getSubTypes(A, 2), TypeDepths({{A, 0}, {B, 1}, {C, 1}, {D, 2}}));
  EXPECT_EQ(getSubTypes(A, 3), TypeDepths({{A, 0}, {B, 1}, {C, 1}, {D, 2}}));

  EXPECT_EQ(getSubTypes(C, 0), TypeDepths({{C, 0}}));
  EXPECT_EQ(getSubTypes(C, 1), TypeDepths({{C, 0}, {D, 1}}));
  EXPECT_EQ(getSubTypes(C, 2), TypeDepths({{C, 0}, {D, 1}}));
}

// Test supertypes
TEST_F(TypeTest, TestSupertypes) {
  // Basic types: getDeclaredSuperType always returns nothing.
  ASSERT_FALSE(HeapTypes::ext.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::func.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::cont.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::any.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::eq.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::i31.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::struct_.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::array.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::string.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::none.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::noext.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::nofunc.getDeclaredSuperType());
  ASSERT_FALSE(HeapTypes::nocont.getDeclaredSuperType());

  // Basic types: getSuperType does return a super, when there is one.
  ASSERT_FALSE(HeapTypes::ext.getSuperType());
  ASSERT_FALSE(HeapTypes::func.getSuperType());
  ASSERT_FALSE(HeapTypes::cont.getSuperType());
  ASSERT_FALSE(HeapTypes::any.getSuperType());
  ASSERT_EQ(HeapTypes::eq.getSuperType(), HeapType::any);
  ASSERT_EQ(HeapTypes::i31.getSuperType(), HeapType::eq);
  ASSERT_EQ(HeapTypes::struct_.getSuperType(), HeapType::eq);
  ASSERT_EQ(HeapTypes::array.getSuperType(), HeapType::eq);
  ASSERT_EQ(HeapTypes::string.getSuperType(), HeapType::ext);
  ASSERT_FALSE(HeapTypes::none.getSuperType());
  ASSERT_FALSE(HeapTypes::noext.getSuperType());
  ASSERT_FALSE(HeapTypes::nofunc.getSuperType());
  ASSERT_FALSE(HeapTypes::nocont.getSuperType());

  // Non-basic types.
  HeapType struct1, struct2, array1, array2, sig1, sig2;
  {
    TypeBuilder builder(6);
    builder[0].setOpen() = Struct();
    builder[1].setOpen().subTypeOf(builder[0]) = Struct();
    auto array = Array(Field(Type::i32, Immutable));
    builder[2].setOpen() = array;
    builder[3].setOpen().subTypeOf(builder[2]) = array;
    auto sig = Signature(Type::none, Type::none);
    builder[4].setOpen() = sig;
    builder[5].setOpen().subTypeOf(builder[4]) = sig;
    auto result = builder.build();
    ASSERT_TRUE(result);
    auto built = *result;
    struct1 = built[0];
    struct2 = built[1];
    array1 = built[2];
    array2 = built[3];
    sig1 = built[4];
    sig2 = built[5];
  }

  ASSERT_EQ(struct1.getSuperType(), HeapType::struct_);
  ASSERT_EQ(struct2.getSuperType(), struct1);
  ASSERT_EQ(array1.getSuperType(), HeapType::array);
  ASSERT_EQ(array2.getSuperType(), array1);
  ASSERT_EQ(sig1.getSuperType(), HeapType::func);
  ASSERT_EQ(sig2.getSuperType(), sig1);

  // With getDeclaredSuperType we don't get basic supers, only declared ones.
  ASSERT_FALSE(struct1.getDeclaredSuperType());
  ASSERT_EQ(struct2.getDeclaredSuperType(), struct1);
  ASSERT_FALSE(array1.getDeclaredSuperType());
  ASSERT_EQ(array2.getDeclaredSuperType(), array1);
  ASSERT_FALSE(sig1.getDeclaredSuperType());
  ASSERT_EQ(sig2.getDeclaredSuperType(), sig1);
}
