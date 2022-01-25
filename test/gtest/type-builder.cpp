#include <gtest/gtest.h>
#include <wasm-type.h>

using namespace wasm;

// Helper test fixture for managing the global type system state.
template<TypeSystem system> class TypeSystemTest : public ::testing::Test {
  TypeSystem originalSystem;

protected:
  void SetUp() override {
    originalSystem = getTypeSystem();
    setTypeSystem(system);
  }
  void TearDown() override {
    destroyAllTypesForTestingPurposesOnly();
    setTypeSystem(originalSystem);
  }
};

using TypeTest = TypeSystemTest<TypeSystem::Equirecursive>;
using EquirecursiveTest = TypeSystemTest<TypeSystem::Equirecursive>;
using NominalTest = TypeSystemTest<TypeSystem::Nominal>;
using IsorecursiveTest = TypeSystemTest<TypeSystem::Isorecursive>;

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

TEST_F(EquirecursiveTest, Basics) {
  // (type $sig (func (param (ref $struct)) (result (ref $array) i32)))
  // (type $struct (struct (field (ref null $array) (mut rtt 0 $array))))
  // (type $array (array (mut externref)))
  TypeBuilder builder(3);
  ASSERT_EQ(builder.size(), size_t{3});

  Type refSig = builder.getTempRefType(builder[0], NonNullable);
  Type refStruct = builder.getTempRefType(builder[1], NonNullable);
  Type refArray = builder.getTempRefType(builder[2], NonNullable);
  Type refNullArray = builder.getTempRefType(builder[2], Nullable);
  Type rttArray = builder.getTempRttType(Rtt(0, builder[2]));
  Type refNullExt(HeapType::ext, Nullable);

  Signature sig(refStruct, builder.getTempTupleType({refArray, Type::i32}));
  Struct struct_({Field(refNullArray, Immutable), Field(rttArray, Mutable)});
  Array array(Field(refNullExt, Mutable));

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
  EXPECT_EQ(built[2].getArray(), Array(Field(refNullExt, Mutable)));

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
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::SelfSupertype);
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
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::SelfSupertype);
  EXPECT_EQ(error->index, 0u);
}

TEST_F(NominalTest, IndirectSelfSupertype) { testIndirectSelfSupertype(); }
TEST_F(IsorecursiveTest, IndirectSelfSupertype) { testIndirectSelfSupertype(); }

static void testInvalidSupertype() {
  TypeBuilder builder(2);
  builder.createRecGroup(0, 2);
  builder[0] = Struct{};
  builder[1] = Struct({Field(Type::i32, Immutable)});
  builder[0].subTypeOf(builder[1]);

  auto result = builder.build();
  EXPECT_FALSE(result);

  const auto* error = result.getError();
  ASSERT_TRUE(error);
  EXPECT_EQ(error->reason, TypeBuilder::ErrorReason::InvalidSupertype);
  EXPECT_EQ(error->index, 0u);
}

TEST_F(NominalTest, InvalidSupertype) { testInvalidSupertype(); }
TEST_F(IsorecursiveTest, InvalidSupertype) { testInvalidSupertype(); }
