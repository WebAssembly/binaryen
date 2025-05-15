/*
 * Copyright 2025 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "ir/public-type-validator.h"
#include "wasm-type.h"

#include "gtest/gtest.h"

using namespace wasm;

class PublicTypeValidatorTest : public ::testing::Test {
protected:
  HeapType EmptyStruct;
  HeapType RecursiveStruct;
  HeapType InvalidStruct;
  HeapType IndirectlyInvalidStruct;
  HeapType RecursiveInvalidStruct;
  HeapType EmptyStructInGroupWithInvalid;

  void SetUp() override {
    TypeBuilder builder(8);

    // Empty struct
    HeapType empty = builder[0];
    builder[0] = Struct();

    // Recursive struct
    HeapType recursive = builder[1];
    builder[1] = Struct({Field(Type(recursive, Nullable), Mutable)});

    // Invalid struct (when custom descriptors are disabled)
    HeapType invalid = builder[2];
    builder[2] = Struct({Field(Type(empty, Nullable, Exact), Mutable)});

    // Indirectly invalid struct
    builder[3] = Struct({Field(Type(invalid, Nullable), Mutable)});

    // Mutually recursive, indirectly invalid struct
    builder[4] = Struct({Field(Type(builder[5], Nullable), Mutable)});
    builder[5] = Struct({Field(Type(builder[4], Nullable, Exact), Mutable)});
    builder.createRecGroup(4, 2);

    // Empty struct in group with invalid struct
    builder[6] = Struct();
    builder[7] = Struct({Field(Type(invalid, Nullable), Mutable)});
    builder.createRecGroup(6, 2);

    auto result = builder.build();
    auto& built = *result;

    EmptyStruct = built[0];
    RecursiveStruct = built[1];
    InvalidStruct = built[2];
    IndirectlyInvalidStruct = built[3];
    RecursiveInvalidStruct = built[4];
    EmptyStructInGroupWithInvalid = built[6];
  }

  void TearDown() override { wasm::destroyAllTypesForTestingPurposesOnly(); }
};

TEST_F(PublicTypeValidatorTest, CustomDescriptorsEnabled) {
  PublicTypeValidator validator(FeatureSet::CustomDescriptors);

  EXPECT_TRUE(validator.isValidPublicType(EmptyStruct));
  EXPECT_TRUE(validator.isValidPublicType(RecursiveStruct));
  EXPECT_TRUE(validator.isValidPublicType(InvalidStruct));
  EXPECT_TRUE(validator.isValidPublicType(IndirectlyInvalidStruct));
  EXPECT_TRUE(validator.isValidPublicType(RecursiveInvalidStruct));
  EXPECT_TRUE(validator.isValidPublicType(EmptyStructInGroupWithInvalid));
}

TEST_F(PublicTypeValidatorTest, CustomDescriptorsDisabled) {
  PublicTypeValidator validator(FeatureSet::MVP);

  EXPECT_TRUE(validator.isValidPublicType(EmptyStruct));
  EXPECT_TRUE(validator.isValidPublicType(RecursiveStruct));
  EXPECT_FALSE(validator.isValidPublicType(InvalidStruct));
  EXPECT_FALSE(validator.isValidPublicType(IndirectlyInvalidStruct));
  EXPECT_FALSE(validator.isValidPublicType(RecursiveInvalidStruct));
  EXPECT_FALSE(validator.isValidPublicType(EmptyStructInGroupWithInvalid));
}

TEST_F(PublicTypeValidatorTest, CachedResult) {
  PublicTypeValidator validator(FeatureSet::MVP);

  // Check the indirectly invalid type first, then serve the query for the
  // directly invalid type from the cache.
  EXPECT_FALSE(validator.isValidPublicType(IndirectlyInvalidStruct));
  EXPECT_FALSE(validator.isValidPublicType(InvalidStruct));

  // We can serve repeated queries from the cache, too.
  EXPECT_FALSE(validator.isValidPublicType(IndirectlyInvalidStruct));
}

TEST_F(PublicTypeValidatorTest, BasicHeapTypes) {
  PublicTypeValidator validator(FeatureSet::MVP);

  EXPECT_TRUE(validator.isValidPublicType(HeapTypes::any));
  EXPECT_TRUE(validator.isValidPublicType(HeapTypes::eq));
  EXPECT_TRUE(validator.isValidPublicType(HeapTypes::ext));
  EXPECT_TRUE(validator.isValidPublicType(HeapTypes::func));
  EXPECT_TRUE(validator.isValidPublicType(HeapTypes::none));
}

TEST_F(PublicTypeValidatorTest, Types) {
  PublicTypeValidator validator(FeatureSet::MVP);

  EXPECT_TRUE(validator.isValidPublicType(Type::i32));
  EXPECT_TRUE(validator.isValidPublicType(Type::i64));
  EXPECT_TRUE(validator.isValidPublicType(Type::f32));
  EXPECT_TRUE(validator.isValidPublicType(Type::f64));
  EXPECT_TRUE(validator.isValidPublicType(Type::v128));

  EXPECT_TRUE(validator.isValidPublicType(Type(HeapType::any, Nullable)));
  EXPECT_TRUE(validator.isValidPublicType(Type(EmptyStruct, Nullable)));
  EXPECT_FALSE(validator.isValidPublicType(Type(EmptyStruct, Nullable, Exact)));
  EXPECT_FALSE(validator.isValidPublicType(Type(InvalidStruct, Nullable)));
}
