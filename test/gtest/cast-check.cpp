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

#include "ir/gc-type-utils.h"
#include "type-test.h"
#include "wasm-type.h"
#include "gtest/gtest.h"

namespace wasm {

using namespace GCTypeUtils;

class CastCheckTest : public TypeTest {
protected:
  HeapType super, sub, subFinal;

  void SetUp() override {
    TypeBuilder builder(3);
    builder[0] = Struct();
    builder[0].setOpen();
    builder[1] = Struct();
    builder[1].subTypeOf(builder[0]).setOpen();
    builder[2] = Struct();
    builder[2].subTypeOf(builder[0]);

    auto built = builder.build();
    ASSERT_TRUE(built);

    super = (*built)[0];
    sub = (*built)[1];
    subFinal = (*built)[2];
  }
};

TEST_F(CastCheckTest, CastToSelfNonFinal) {
#define EXPECT_CAST(                                                           \
  srcNullability, srcExactness, castNullability, castExactness, result)        \
  EXPECT_EQ(evaluateCastCheck(Type(super, srcNullability, srcExactness),       \
                              Type(super, castNullability, castExactness)),    \
            result);

  EXPECT_CAST(Nullable, Inexact, Nullable, Inexact, Success);
  EXPECT_CAST(Nullable, Inexact, Nullable, Exact, Unknown);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Inexact, SuccessOnlyIfNonNull);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Exact, Unknown);
  EXPECT_CAST(Nullable, Exact, Nullable, Inexact, Success);
  EXPECT_CAST(Nullable, Exact, Nullable, Exact, Success);
  EXPECT_CAST(Nullable, Exact, NonNullable, Inexact, SuccessOnlyIfNonNull);
  EXPECT_CAST(Nullable, Exact, NonNullable, Exact, SuccessOnlyIfNonNull);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Exact, Unknown);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Exact, Unknown);
  EXPECT_CAST(NonNullable, Exact, Nullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Exact, Nullable, Exact, Success);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Exact, Success);
#undef EXPECT_CAST
}

TEST_F(CastCheckTest, CastToSelfFinal) {
#define EXPECT_CAST(                                                           \
  srcNullability, srcExactness, castNullability, castExactness, result)        \
  EXPECT_EQ(evaluateCastCheck(Type(subFinal, srcNullability, srcExactness),    \
                              Type(subFinal, castNullability, castExactness)), \
            result);

  EXPECT_CAST(Nullable, Inexact, Nullable, Inexact, Success);
  EXPECT_CAST(Nullable, Inexact, Nullable, Exact, Success);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Inexact, SuccessOnlyIfNonNull);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Exact, SuccessOnlyIfNonNull);
  EXPECT_CAST(Nullable, Exact, Nullable, Inexact, Success);
  EXPECT_CAST(Nullable, Exact, Nullable, Exact, Success);
  EXPECT_CAST(Nullable, Exact, NonNullable, Inexact, SuccessOnlyIfNonNull);
  EXPECT_CAST(Nullable, Exact, NonNullable, Exact, SuccessOnlyIfNonNull);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Exact, Success);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Exact, Success);
  EXPECT_CAST(NonNullable, Exact, Nullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Exact, Nullable, Exact, Success);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Exact, Success);
#undef EXPECT_CAST
}

TEST_F(CastCheckTest, CastToSuper) {
#define EXPECT_CAST(                                                           \
  srcNullability, srcExactness, castNullability, castExactness, result)        \
  EXPECT_EQ(evaluateCastCheck(Type(sub, srcNullability, srcExactness),         \
                              Type(super, castNullability, castExactness)),    \
            result);

  EXPECT_CAST(Nullable, Inexact, Nullable, Inexact, Success);
  EXPECT_CAST(Nullable, Inexact, Nullable, Exact, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Inexact, SuccessOnlyIfNonNull);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Exact, Failure);
  EXPECT_CAST(Nullable, Exact, Nullable, Inexact, Success);
  EXPECT_CAST(Nullable, Exact, Nullable, Exact, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Exact, NonNullable, Inexact, SuccessOnlyIfNonNull);
  EXPECT_CAST(Nullable, Exact, NonNullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Exact, Nullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Exact, Nullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Inexact, Success);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Exact, Failure);
#undef EXPECT_CAST
}

TEST_F(CastCheckTest, CastToSub) {
#define EXPECT_CAST(                                                           \
  srcNullability, srcExactness, castNullability, castExactness, result)        \
  EXPECT_EQ(evaluateCastCheck(Type(super, srcNullability, srcExactness),       \
                              Type(sub, castNullability, castExactness)),      \
            result);

  EXPECT_CAST(Nullable, Inexact, Nullable, Inexact, Unknown);
  EXPECT_CAST(Nullable, Inexact, Nullable, Exact, Unknown);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Inexact, Unknown);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Exact, Unknown);
  EXPECT_CAST(Nullable, Exact, Nullable, Inexact, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Exact, Nullable, Exact, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Exact, NonNullable, Inexact, Failure);
  EXPECT_CAST(Nullable, Exact, NonNullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Inexact, Unknown);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Exact, Unknown);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Inexact, Unknown);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Exact, Unknown);
  EXPECT_CAST(NonNullable, Exact, Nullable, Inexact, Failure);
  EXPECT_CAST(NonNullable, Exact, Nullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Inexact, Failure);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Exact, Failure);
#undef EXPECT_CAST
}

TEST_F(CastCheckTest, CastToSibling) {
#define EXPECT_CAST(                                                           \
  srcNullability, srcExactness, castNullability, castExactness, result)        \
  EXPECT_EQ(evaluateCastCheck(Type(sub, srcNullability, srcExactness),         \
                              Type(subFinal, castNullability, castExactness)), \
            result);

  EXPECT_CAST(Nullable, Inexact, Nullable, Inexact, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Inexact, Nullable, Exact, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Inexact, Failure);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Exact, Failure);
  EXPECT_CAST(Nullable, Exact, Nullable, Inexact, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Exact, Nullable, Exact, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Exact, NonNullable, Inexact, Failure);
  EXPECT_CAST(Nullable, Exact, NonNullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Inexact, Failure);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Inexact, Failure);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Exact, Nullable, Inexact, Failure);
  EXPECT_CAST(NonNullable, Exact, Nullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Inexact, Failure);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Exact, Failure);
#undef EXPECT_CAST
}

TEST_F(CastCheckTest, CastToBottom) {
#define EXPECT_CAST(srcNullability, srcExactness, castNullability, result)     \
  EXPECT_EQ(evaluateCastCheck(Type(super, srcNullability, srcExactness),       \
                              Type(HeapType::none, castNullability, Inexact)), \
            result);

  EXPECT_CAST(Nullable, Inexact, Nullable, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Inexact, NonNullable, Failure);
  EXPECT_CAST(Nullable, Exact, Nullable, SuccessOnlyIfNull);
  EXPECT_CAST(Nullable, Exact, NonNullable, Failure);
  EXPECT_CAST(NonNullable, Inexact, Nullable, Failure);
  EXPECT_CAST(NonNullable, Inexact, NonNullable, Failure);
  EXPECT_CAST(NonNullable, Exact, Nullable, Failure);
  EXPECT_CAST(NonNullable, Exact, NonNullable, Failure);
#undef EXPECT_CAST
}

TEST_F(CastCheckTest, CastFromBottom) {
#define EXPECT_CAST(srcNullability, castNullability, castExactness, result)    \
  EXPECT_EQ(evaluateCastCheck(Type(HeapType::none, srcNullability, Inexact),   \
                              Type(super, castNullability, castExactness)),    \
            result);

  EXPECT_CAST(Nullable, Nullable, Inexact, Success);
  EXPECT_CAST(Nullable, Nullable, Exact, Success);
  EXPECT_CAST(Nullable, NonNullable, Inexact, Failure);
  EXPECT_CAST(Nullable, NonNullable, Exact, Failure);
  EXPECT_CAST(NonNullable, Nullable, Inexact, GCTypeUtils::Unreachable);
  EXPECT_CAST(NonNullable, Nullable, Exact, GCTypeUtils::Unreachable);
  EXPECT_CAST(NonNullable, NonNullable, Inexact, GCTypeUtils::Unreachable);
  EXPECT_CAST(NonNullable, NonNullable, Exact, GCTypeUtils::Unreachable);
#undef EXPECT_CAST
}

} // namespace wasm
