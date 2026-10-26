/*
 * Copyright 2026 WebAssembly Community Group participants
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
#include "wasm-type.h"
#include "gtest/gtest.h"

namespace wasm {

using namespace GCTypeUtils;

TEST(GCTypeUtilsTest, IsTriviallyUninhabitable) {
  // Non-nullable bottom types are trivially uninhabitable.
  EXPECT_TRUE(isTriviallyUninhabitable(Type(HeapType::none, NonNullable)));
  EXPECT_TRUE(isTriviallyUninhabitable(Type(HeapType::nofunc, NonNullable)));
  EXPECT_TRUE(isTriviallyUninhabitable(Type(HeapType::noext, NonNullable)));
  EXPECT_TRUE(isTriviallyUninhabitable(Type(HeapType::nocont, NonNullable)));
  EXPECT_TRUE(isTriviallyUninhabitable(Type(HeapType::noexn, NonNullable)));
  EXPECT_TRUE(
    isTriviallyUninhabitable(Type(HeapTypes::sharedNowaitqueue, NonNullable)));

  // Nullable bottom types are inhabitable (via null).
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::none, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::nofunc, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::noext, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::nocont, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::noexn, Nullable)));
  EXPECT_FALSE(
    isTriviallyUninhabitable(Type(HeapTypes::sharedNowaitqueue, Nullable)));

  // Unshared waitqueue and nowaitqueue are uninhabitable regardless of
  // nullability.
  EXPECT_TRUE(isTriviallyUninhabitable(Type(HeapType::waitqueue, Nullable)));
  EXPECT_TRUE(isTriviallyUninhabitable(Type(HeapType::waitqueue, NonNullable)));
  EXPECT_TRUE(isTriviallyUninhabitable(Type(HeapType::nowaitqueue, Nullable)));
  EXPECT_TRUE(
    isTriviallyUninhabitable(Type(HeapType::nowaitqueue, NonNullable)));

  // Shared waitqueue is inhabitable.
  EXPECT_FALSE(
    isTriviallyUninhabitable(Type(HeapTypes::sharedWaitqueue, Nullable)));
  EXPECT_FALSE(
    isTriviallyUninhabitable(Type(HeapTypes::sharedWaitqueue, NonNullable)));

  // Common types are inhabitable.
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::any, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::any, NonNullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::func, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::func, NonNullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::eq, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::eq, NonNullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::i31, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::i31, NonNullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::struct_, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::struct_, NonNullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::array, Nullable)));
  EXPECT_FALSE(isTriviallyUninhabitable(Type(HeapType::array, NonNullable)));

  // Non-reference types and non-values.
  EXPECT_FALSE(isTriviallyUninhabitable(Type::i32));
  EXPECT_FALSE(isTriviallyUninhabitable(Type::i64));
  EXPECT_FALSE(isTriviallyUninhabitable(Type::f32));
  EXPECT_FALSE(isTriviallyUninhabitable(Type::f64));
  EXPECT_FALSE(isTriviallyUninhabitable(Type::v128));
  EXPECT_FALSE(isTriviallyUninhabitable(Type::none));
  EXPECT_TRUE(isTriviallyUninhabitable(Type::unreachable));
}

} // namespace wasm
