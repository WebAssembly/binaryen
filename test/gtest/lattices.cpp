/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include "analysis/lattices/bool.h"
#include "analysis/lattices/flat.h"
#include "analysis/lattices/int.h"
#include "analysis/lattices/inverted.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(BoolLattice, GetBottom) {
  analysis::Bool lattice;
  EXPECT_FALSE(lattice.getBottom());
}

TEST(BoolLattice, GetTop) {
  analysis::Bool lattice;
  EXPECT_TRUE(lattice.getTop());
}

TEST(BoolLattice, Compare) {
  analysis::Bool lattice;
  EXPECT_EQ(lattice.compare(false, false), analysis::EQUAL);
  EXPECT_EQ(lattice.compare(false, true), analysis::LESS);
  EXPECT_EQ(lattice.compare(true, false), analysis::GREATER);
  EXPECT_EQ(lattice.compare(true, true), analysis::EQUAL);
}

TEST(BoolLattice, Join) {
  analysis::Bool lattice;
  bool elem = false;

  EXPECT_FALSE(lattice.join(elem, false));
  ASSERT_FALSE(elem);

  EXPECT_TRUE(lattice.join(elem, true));
  ASSERT_TRUE(elem);

  EXPECT_FALSE(lattice.join(elem, false));
  ASSERT_TRUE(elem);

  EXPECT_FALSE(lattice.join(elem, true));
  ASSERT_TRUE(elem);
}

TEST(BoolLattice, Meet) {
  analysis::Bool lattice;
  bool elem = true;

  EXPECT_FALSE(lattice.meet(elem, true));
  ASSERT_TRUE(elem);

  EXPECT_TRUE(lattice.meet(elem, false));
  ASSERT_FALSE(elem);

  EXPECT_FALSE(lattice.meet(elem, true));
  ASSERT_FALSE(elem);

  EXPECT_FALSE(lattice.meet(elem, false));
  ASSERT_FALSE(elem);
}

TEST(IntLattice, GetBottom) {
  analysis::Int32 int32;
  EXPECT_EQ(int32.getBottom(), (int32_t)(1ull << 31));

  analysis::Int64 int64;
  EXPECT_EQ(int64.getBottom(), (int64_t)(1ull << 63));

  analysis::UInt32 uint32;
  EXPECT_EQ(uint32.getBottom(), (uint32_t)0);

  analysis::UInt64 uint64;
  EXPECT_EQ(uint64.getBottom(), (uint64_t)0);
}

TEST(IntLattice, GetTop) {
  analysis::Int32 int32;
  EXPECT_EQ(int32.getTop(), (int32_t)((1ull << 31) - 1));

  analysis::Int64 int64;
  EXPECT_EQ(int64.getTop(), (int64_t)((1ull << 63) - 1));

  analysis::UInt32 uint32;
  EXPECT_EQ(uint32.getTop(), (uint32_t)-1ull);

  analysis::UInt64 uint64;
  EXPECT_EQ(uint64.getTop(), (uint64_t)-1ull);
}

TEST(IntLattice, Compare) {
  analysis::Int32 int32;
  EXPECT_EQ(int32.compare(-5, 42), analysis::LESS);
  EXPECT_EQ(int32.compare(42, -5), analysis::GREATER);
  EXPECT_EQ(int32.compare(42, 42), analysis::EQUAL);
}

TEST(IntLattice, Join) {
  analysis::Int32 int32;
  int elem = 0;

  EXPECT_FALSE(int32.join(elem, -10));
  ASSERT_EQ(elem, 0);

  EXPECT_FALSE(int32.join(elem, 0));
  ASSERT_EQ(elem, 0);

  EXPECT_TRUE(int32.join(elem, 100));
  ASSERT_EQ(elem, 100);
}

TEST(IntLattice, Meet) {
  analysis::Int32 int32;
  int elem = 0;

  EXPECT_FALSE(int32.meet(elem, 10));
  ASSERT_EQ(elem, 0);

  EXPECT_FALSE(int32.meet(elem, 0));
  ASSERT_EQ(elem, 0);

  EXPECT_TRUE(int32.meet(elem, -100));
  ASSERT_EQ(elem, -100);
}

TEST(InvertedLattice, GetBottom) {
  analysis::Inverted inverted(analysis::Bool{});
  EXPECT_TRUE(inverted.getBottom());
}

TEST(InvertedLattice, GetTop) {
  analysis::Inverted inverted(analysis::Bool{});
  EXPECT_FALSE(inverted.getTop());
}

TEST(InvertedLattice, Compare) {
  analysis::Inverted inverted(analysis::Bool{});
  EXPECT_EQ(inverted.compare(false, false), analysis::EQUAL);
  EXPECT_EQ(inverted.compare(false, true), analysis::GREATER);
  EXPECT_EQ(inverted.compare(true, false), analysis::LESS);
  EXPECT_EQ(inverted.compare(true, true), analysis::EQUAL);
}

TEST(InvertedLattice, Join) {
  analysis::Inverted inverted(analysis::Bool{});
  bool elem = true;

  EXPECT_FALSE(inverted.join(elem, true));
  ASSERT_TRUE(elem);

  EXPECT_TRUE(inverted.join(elem, false));
  ASSERT_FALSE(elem);

  EXPECT_FALSE(inverted.join(elem, true));
  ASSERT_FALSE(elem);

  EXPECT_FALSE(inverted.join(elem, false));
  ASSERT_FALSE(elem);
}

TEST(InvertedLattice, Meet) {
  analysis::Inverted inverted(analysis::Bool{});
  bool elem = false;

  EXPECT_FALSE(inverted.meet(elem, false));
  ASSERT_FALSE(elem);

  EXPECT_TRUE(inverted.meet(elem, true));
  ASSERT_TRUE(elem);

  EXPECT_FALSE(inverted.meet(elem, false));
  ASSERT_TRUE(elem);

  EXPECT_FALSE(inverted.meet(elem, true));
  ASSERT_TRUE(elem);
}

TEST(InvertedLattice, DoubleInverted) {
  using DoubleInverted = analysis::Inverted<analysis::Inverted<analysis::Bool>>;
  DoubleInverted identity(analysis::Inverted<analysis::Bool>{analysis::Bool{}});
  EXPECT_FALSE(identity.getBottom());
  EXPECT_TRUE(identity.getTop());
}

TEST(FlatLattice, GetBottom) {
  analysis::Flat<int> flat;
  EXPECT_TRUE(flat.getBottom().isBottom());
  EXPECT_FALSE(flat.getBottom().getVal());
  EXPECT_FALSE(flat.getBottom().isTop());
}

TEST(FlatLattice, GetVal) {
  analysis::Flat<int> flat;
  EXPECT_FALSE(flat.get(10).isBottom());
  ASSERT_TRUE(flat.get(10).getVal());
  EXPECT_FALSE(flat.get(10).isTop());

  auto val = flat.get(10);
  EXPECT_EQ(*val.getVal(), 10);
}

TEST(FlatLattice, GetTop) {
  analysis::Flat<int> flat;
  EXPECT_FALSE(flat.getTop().isBottom());
  EXPECT_FALSE(flat.getTop().getVal());
  EXPECT_TRUE(flat.getTop().isTop());
}

TEST(FlatLattice, Compare) {
  analysis::Flat<int> flat;
  auto bot = flat.getBottom();
  auto a = flat.get(0);
  auto b = flat.get(1);
  auto top = flat.getTop();

  EXPECT_EQ(flat.compare(bot, bot), analysis::EQUAL);
  EXPECT_EQ(flat.compare(bot, a), analysis::LESS);
  EXPECT_EQ(flat.compare(bot, b), analysis::LESS);
  EXPECT_EQ(flat.compare(bot, top), analysis::LESS);

  EXPECT_EQ(flat.compare(a, bot), analysis::GREATER);
  EXPECT_EQ(flat.compare(a, a), analysis::EQUAL);
  EXPECT_EQ(flat.compare(a, b), analysis::NO_RELATION);
  EXPECT_EQ(flat.compare(a, top), analysis::LESS);

  EXPECT_EQ(flat.compare(b, bot), analysis::GREATER);
  EXPECT_EQ(flat.compare(b, a), analysis::NO_RELATION);
  EXPECT_EQ(flat.compare(b, b), analysis::EQUAL);
  EXPECT_EQ(flat.compare(b, top), analysis::LESS);

  EXPECT_EQ(flat.compare(top, bot), analysis::GREATER);
  EXPECT_EQ(flat.compare(top, a), analysis::GREATER);
  EXPECT_EQ(flat.compare(top, b), analysis::GREATER);
  EXPECT_EQ(flat.compare(top, top), analysis::EQUAL);
}

TEST(FlatLattice, Join) {
  analysis::Flat<int> flat;
  auto elem = flat.getBottom();

  // bot u bot = bot
  EXPECT_FALSE(flat.join(elem, flat.getBottom()));
  EXPECT_TRUE(elem.isBottom());

  // bot u top = top
  EXPECT_TRUE(flat.join(elem, flat.getTop()));
  EXPECT_TRUE(elem.isTop());

  // bot u 10 = 10
  elem = flat.getBottom();
  EXPECT_TRUE(flat.join(elem, flat.get(10)));
  ASSERT_TRUE(elem.getVal());
  EXPECT_EQ(*elem.getVal(), 10);

  // 10 u bot = 10
  EXPECT_FALSE(flat.join(elem, flat.getBottom()));
  ASSERT_TRUE(elem.getVal());
  EXPECT_EQ(*elem.getVal(), 10);

  // 10 u 10 = 10
  EXPECT_FALSE(flat.join(elem, flat.get(10)));
  ASSERT_TRUE(elem.getVal());
  EXPECT_EQ(*elem.getVal(), 10);

  // 10 u 999 = top
  EXPECT_TRUE(flat.join(elem, flat.get(999)));
  ASSERT_TRUE(elem.isTop());

  // 10 u top = top
  elem = flat.get(10);
  EXPECT_TRUE(flat.join(elem, flat.getTop()));
  ASSERT_TRUE(elem.isTop());

  // top u bot = top
  EXPECT_FALSE(flat.join(elem, flat.getBottom()));
  EXPECT_TRUE(elem.isTop());

  // top u 10 = top
  EXPECT_FALSE(flat.join(elem, flat.get(10)));
  EXPECT_TRUE(elem.isTop());

  // top u top = top
  EXPECT_FALSE(flat.join(elem, flat.getTop()));
  EXPECT_TRUE(elem.isTop());
}
