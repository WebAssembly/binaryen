
#include "tools/execution-results.h"
#include "test/gtest/type-test.h"
#include "wasm-type.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

struct ExecutionResultsTest : public TypeTest {
  Module wasm;
};

TEST_F(ExecutionResultsTest, PublicVsPrivate) {
  TypeBuilder builder(2);
  // Public struct
  builder[0] = Struct({Field(Type::i32, Mutable)});
  // Private struct
  builder[1] = Struct({Field(Type::f64, Mutable)});
  auto result = builder.build();
  ASSERT_TRUE(result);
  auto& types = *result;
  HeapType publicHT = types[0];
  HeapType privateHT = types[1];

  ExecutionResults results;
  results.publicTypes.insert(publicHT);

  auto data42 = std::make_shared<GCData>(Literals{Literal(int32_t(42))});
  auto data43 = std::make_shared<GCData>(Literals{Literal(int32_t(43))});

  auto dataF42 = std::make_shared<GCData>(Literals{Literal(double(42.0))});
  auto dataF43 = std::make_shared<GCData>(Literals{Literal(double(43.0))});

  Literal public42(data42, publicHT);
  // Same data pointer
  Literal public42_2(data42, publicHT);
  // Same content, different pointer
  Literal public42_3(std::make_shared<GCData>(Literals{Literal(int32_t(42))}),
                     publicHT);
  Literal public43(data43, publicHT);

  Literal private42(dataF42, privateHT);
  Literal private43(dataF43, privateHT);

  // Public types are compared by content
  EXPECT_TRUE(results.areEqual(public42, public42_2));
  EXPECT_TRUE(results.areEqual(public42, public42_3));
  EXPECT_FALSE(results.areEqual(public42, public43));

  // Private types are always equal
  EXPECT_TRUE(results.areEqual(private42, private43));

  // Public and private are different
  EXPECT_FALSE(results.areEqual(public42, private42));
}

TEST_F(ExecutionResultsTest, RecursivePublic) {
  TypeBuilder builder(1);
  builder[0] =
    Struct({Field(builder.getTempRefType(builder[0], Nullable), Mutable)});
  auto result = builder.build();
  ASSERT_TRUE(result);
  auto& types = *result;
  HeapType ht = types[0];

  ExecutionResults results;
  results.publicTypes.insert(ht);

  // Create recursive data: A -> A
  auto dataA = std::make_shared<GCData>(Literals{Literal::makeNull(ht)});
  Literal litA(dataA, ht);
  dataA->values[0] = litA;

  // Create another identical recursive data: B -> B
  auto dataB = std::make_shared<GCData>(Literals{Literal::makeNull(ht)});
  Literal litB(dataB, ht);
  dataB->values[0] = litB;

  EXPECT_TRUE(results.areEqual(litA, litB));

  // Create a different recursive data: C -> D -> C
  auto dataC = std::make_shared<GCData>(Literals{Literal::makeNull(ht)});
  auto dataD = std::make_shared<GCData>(Literals{Literal::makeNull(ht)});
  Literal litC(dataC, ht);
  Literal litD(dataD, ht);
  dataC->values[0] = litD;
  dataD->values[0] = litC;

  // They are actually all equivalent as infinite structures of just this one
  // type.
  EXPECT_TRUE(results.areEqual(litA, litC));
}

TEST_F(ExecutionResultsTest, SubtypeOfPublic) {
  TypeBuilder builder(2);
  // Public supertype
  builder[0] = Struct({Field(Type::i32, Mutable)});
  builder[0].setOpen();
  // Subtype with extra field
  builder[1] = Struct({Field(Type::i32, Mutable), Field(Type::f64, Mutable)});
  builder[1].subTypeOf(builder[0]);
  auto result = builder.build();
  ASSERT_TRUE(result);
  auto& types = *result;
  HeapType superHT = types[0];
  HeapType subHT = types[1];

  ExecutionResults results;
  results.publicTypes.insert(superHT);

  // sub42_0 and sub42_1 have the same public field but different private
  // fields.
  auto data42_0 = std::make_shared<GCData>(
    Literals{Literal(int32_t(42)), Literal(double(0.0))});
  auto data42_1 = std::make_shared<GCData>(
    Literals{Literal(int32_t(42)), Literal(double(1.0))});
  auto data43_0 = std::make_shared<GCData>(
    Literals{Literal(int32_t(43)), Literal(double(0.0))});

  Literal sub42_0(data42_0, subHT);
  Literal sub42_1(data42_1, subHT);
  Literal sub43_0(data43_0, subHT);

  auto data42_super = std::make_shared<GCData>(Literals{Literal(int32_t(42))});
  Literal super42(data42_super, superHT);

  // Subtype of public type should be compared by content (of the public
  // ancestor) Extra fields in the subtype should be ignored.
  EXPECT_TRUE(results.areEqual(sub42_0, sub42_1));
  EXPECT_TRUE(results.areEqual(sub42_0, super42));
  EXPECT_FALSE(results.areEqual(sub42_0, sub43_0));
}

TEST_F(ExecutionResultsTest, PrivateTypes) {
  TypeBuilder builder(1);
  builder[0] = Struct({Field(Type::i32, Mutable)});
  auto result = builder.build();
  ASSERT_TRUE(result);
  auto& types = *result;
  HeapType ht = types[0];

  // publicTypes is empty
  ExecutionResults results;

  auto data42 = std::make_shared<GCData>(Literals{Literal(int32_t(42))});
  auto data43 = std::make_shared<GCData>(Literals{Literal(int32_t(43))});

  Literal lit42(data42, ht);
  Literal lit43(data43, ht);

  // This should not crash and should return true.
  EXPECT_TRUE(results.areEqual(lit42, lit43));
}
