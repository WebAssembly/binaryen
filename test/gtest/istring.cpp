// Copyright 2026 WebAssembly Community Group participants
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "support/istring.h"
#include "gtest/gtest.h"

using namespace wasm;

using IStringTest = ::testing::Test;

TEST_F(IStringTest, Empty) {
  // Null and empty strings differ.
  auto null = IString();
  auto empty = IString("");
  EXPECT_NE(null, empty);

  EXPECT_FALSE(null.is());
  EXPECT_TRUE(empty.is());

  // But they are equal to themselves.
  EXPECT_EQ(null, null);
  EXPECT_EQ(empty, empty);

  // A default string_view is the empty string, and has data == nullptr.
  auto stdViewDefault1 = std::string_view();
  EXPECT_EQ(stdViewDefault1.data(), nullptr);
  auto stdViewDefault2 = std::string_view{};
  EXPECT_EQ(stdViewDefault2.data(), nullptr);

  EXPECT_EQ(empty, stdViewDefault1);
  EXPECT_EQ(empty, stdViewDefault2);

  // The same when going through the IString constructor.
  EXPECT_EQ(empty, IString(std::string_view{}));

  // An empty string_view is equal to those, even though its data != nullptr.
  auto stdViewEmpty = std::string_view("");
  EXPECT_NE(stdViewEmpty.data(), nullptr);
  EXPECT_EQ(empty, stdViewEmpty);
}

TEST_F(IStringTest, Interning) {
  // The same string interned twice is equal.
  auto foo1 = IString("foo");
  auto foo2 = IString("foo");
  EXPECT_EQ(foo1, foo2);

  // The internal pointers are equal too.
  EXPECT_EQ(foo1.str.data(), foo2.str.data());

  // Other things are different.
  auto bar = IString("bar");
  EXPECT_NE(foo1, bar);
  EXPECT_NE(foo2, bar);

  // Things are equal to themselves.
  EXPECT_EQ(foo1, foo1);
  EXPECT_EQ(foo2, foo2);
  EXPECT_EQ(bar, bar);
}

TEST_F(IStringTest, StartsWith) {
  auto foo = IString("foo");
  EXPECT_TRUE(foo.startsWith("f"));
  EXPECT_TRUE(foo.startsWith("fo"));
  EXPECT_TRUE(foo.startsWith("foo"));

  EXPECT_FALSE(foo.startsWith("oo"));
  EXPECT_FALSE(foo.startsWith("o"));

  EXPECT_FALSE(foo.startsWith("foobar"));
  EXPECT_FALSE(foo.startsWith("bar"));
}

TEST_F(IStringTest, EndsWith) {
  auto foo = IString("foo");
  EXPECT_TRUE(foo.endsWith("o"));
  EXPECT_TRUE(foo.endsWith("oo"));
  EXPECT_TRUE(foo.endsWith("foo"));

  EXPECT_FALSE(foo.endsWith("f"));
  EXPECT_FALSE(foo.endsWith("fo"));

  EXPECT_FALSE(foo.endsWith("foobar"));
  EXPECT_FALSE(foo.endsWith("bar"));
}
