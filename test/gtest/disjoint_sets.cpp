/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "support/disjoint_sets.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(DisjointSetsTest, NewSets) {
  DisjointSets sets;
  auto elem1 = sets.addSet();
  auto elem2 = sets.addSet();
  EXPECT_NE(elem1, elem2);

  auto root1 = sets.getRoot(elem1);
  EXPECT_EQ(elem1, root1);

  auto root2 = sets.getRoot(elem2);
  EXPECT_EQ(elem2, root2);
}

TEST(DisjointSetsTest, Union) {
  DisjointSets sets;
  auto elem1 = sets.addSet();
  auto elem2 = sets.addSet();
  auto root = sets.getUnion(elem1, elem2);
  EXPECT_TRUE(root == elem1 || root == elem2);

  auto root1 = sets.getRoot(elem1);
  auto root2 = sets.getRoot(elem2);
  EXPECT_EQ(root1, root);
  EXPECT_EQ(root2, root);
}

TEST(DisjointSetsTest, TwoUnions) {
  DisjointSets sets;
  auto elem1 = sets.addSet();
  auto elem2 = sets.addSet();
  auto elem3 = sets.addSet();
  auto elem4 = sets.addSet();

  auto rootA = sets.getUnion(elem1, elem3);
  auto rootB = sets.getUnion(elem2, elem4);
  EXPECT_EQ(sets.getRoot(elem1), rootA);
  EXPECT_EQ(sets.getRoot(elem2), rootB);
  EXPECT_EQ(sets.getRoot(elem3), rootA);
  EXPECT_EQ(sets.getRoot(elem4), rootB);
  EXPECT_NE(rootA, rootB);
}

TEST(DisjointSetsTest, UnionList) {
  constexpr size_t count = 16;
  DisjointSets sets;
  size_t elems[count];
  for (size_t i = 0; i < count; ++i) {
    elems[i] = sets.addSet();
  }

  for (size_t i = 1; i < count; ++i) {
    sets.getUnion(elems[i], elems[i - 1]);
  }

  auto root = sets.getRoot(elems[0]);
  for (size_t rep = 0; rep < 2; ++rep) {
    for (size_t i = 0; i < count; ++i) {
      auto currRoot = sets.getRoot(elems[i]);
      EXPECT_EQ(currRoot, root);
    }
  }
}

TEST(DisjointSetsTest, UnionTree) {
  constexpr size_t count = 16;
  DisjointSets sets;
  size_t elems[count];
  for (size_t i = 0; i < count; ++i) {
    elems[i] = sets.addSet();
  }

  for (size_t stride = 2; stride <= count; stride *= 2) {
    for (size_t i = 0; i < count; i += stride) {
      sets.getUnion(elems[i], elems[i + stride / 2]);
    }
  }

  auto root = sets.getRoot(elems[0]);
  for (size_t rep = 0; rep < 2; ++rep) {
    for (size_t i = 0; i < count; ++i) {
      auto currRoot = sets.getRoot(elems[i]);
      EXPECT_EQ(currRoot, root);
    }
  }
}
