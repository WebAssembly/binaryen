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
using EquirecursiveTest = TypeSystemTest<TypeSystem::Equirecursive>;
using NominalTest = TypeSystemTest<TypeSystem::Nominal>;
using IsorecursiveTest = TypeSystemTest<TypeSystem::Isorecursive>;

TEST(TypeBuilder, Growth) {
  TypeBuilder builder;
  EXPECT_EQ(builder.size(), size_t{0});
  builder.grow(3);
  EXPECT_EQ(builder.size(), size_t{3});
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

  std::vector<HeapType> built = builder.build();
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
