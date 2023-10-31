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

#include "analysis/lattices/array.h"
#include "analysis/lattices/bool.h"
#include "analysis/lattices/flat.h"
#include "analysis/lattices/int.h"
#include "analysis/lattices/inverted.h"
#include "analysis/lattices/lift.h"
#include "analysis/lattices/tuple.h"
#include "analysis/lattices/powerset2.h"
#include "analysis/lattices/vector.h"
#include "support/bitset.h"
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

TEST(LiftLattice, GetBottom) {
  analysis::Lift lift{analysis::Bool{}};
  EXPECT_TRUE(lift.getBottom().isBottom());
  EXPECT_FALSE(lift.getBottom().has_value());
}

TEST(LiftLattice, GetVal) {
  analysis::Lift lift{analysis::Bool{}};
  EXPECT_FALSE(lift.get(false).isBottom());
  EXPECT_FALSE(lift.get(true).isBottom());
  EXPECT_FALSE(*lift.get(false));
  EXPECT_TRUE(*lift.get(true));

  analysis::Lift liftInt{analysis::Int32{}};
  EXPECT_FALSE(liftInt.get(10).isBottom());
  EXPECT_EQ(*liftInt.get(0), 0);
  EXPECT_EQ(*liftInt.get(10), 10);
}

TEST(LiftLattice, Compare) {
  analysis::Lift lift{analysis::Flat<bool>{}};
  auto& liftee = lift.lattice;
  auto bot = lift.getBottom();
  auto lifteeBot = lift.get(liftee.getBottom());
  auto a = lift.get(liftee.get(false));
  auto b = lift.get(liftee.get(true));
  auto top = lift.get(liftee.getTop());

  EXPECT_EQ(lift.compare(bot, bot), analysis::EQUAL);
  EXPECT_EQ(lift.compare(bot, lifteeBot), analysis::LESS);
  EXPECT_EQ(lift.compare(bot, a), analysis::LESS);
  EXPECT_EQ(lift.compare(bot, b), analysis::LESS);
  EXPECT_EQ(lift.compare(bot, top), analysis::LESS);

  EXPECT_EQ(lift.compare(lifteeBot, bot), analysis::GREATER);
  EXPECT_EQ(lift.compare(a, bot), analysis::GREATER);
  EXPECT_EQ(lift.compare(b, bot), analysis::GREATER);
  EXPECT_EQ(lift.compare(top, bot), analysis::GREATER);

  EXPECT_EQ(lift.compare(a, b), analysis::NO_RELATION);
  EXPECT_EQ(lift.compare(a, top), analysis::LESS);
  EXPECT_EQ(lift.compare(a, lifteeBot), analysis::GREATER);
}

TEST(LiftLattice, Join) {
  analysis::Lift lift{analysis::Bool{}};
  auto bot = lift.getBottom();
  auto lifteeBot = lift.get(false);
  auto top = lift.get(true);

  // bot u bot = bot
  auto elem = bot;
  EXPECT_FALSE(lift.join(elem, bot));
  EXPECT_EQ(elem, bot);

  // bot u lifteeBot = lifteeBot
  EXPECT_TRUE(lift.join(elem, lifteeBot));
  EXPECT_EQ(elem, lifteeBot);

  // lifteeBot u bot = lifteeBot
  EXPECT_FALSE(lift.join(elem, bot));
  EXPECT_EQ(elem, lifteeBot);

  // lifteeBot u lifteeBot = lifteeBot
  EXPECT_FALSE(lift.join(elem, lifteeBot));
  EXPECT_EQ(elem, lifteeBot);

  // lifteeBot u top = top
  EXPECT_TRUE(lift.join(elem, top));
  EXPECT_EQ(elem, top);

  // top u bot = top
  EXPECT_FALSE(lift.join(elem, bot));
  EXPECT_EQ(elem, top);
}

TEST(ArrayLattice, GetBottom) {
  analysis::Array<analysis::Bool, 2> array{analysis::Bool{}};
  EXPECT_EQ(array.getBottom(), (std::array<bool, 2>{false, false}));
}

TEST(ArrayLattice, GetTop) {
  analysis::Array<analysis::Bool, 2> array{analysis::Bool{}};
  EXPECT_EQ(array.getTop(), (std::array<bool, 2>{true, true}));
}

TEST(ArrayLattice, Compare) {
  analysis::Array<analysis::Bool, 2> array{analysis::Bool{}};
  std::array<bool, 2> ff{false, false};
  std::array<bool, 2> ft{false, true};
  std::array<bool, 2> tf{true, false};
  std::array<bool, 2> tt{true, true};

  EXPECT_EQ(array.compare(ff, ff), analysis::EQUAL);
  EXPECT_EQ(array.compare(ff, ft), analysis::LESS);
  EXPECT_EQ(array.compare(ff, tf), analysis::LESS);
  EXPECT_EQ(array.compare(ff, tt), analysis::LESS);

  EXPECT_EQ(array.compare(ft, ff), analysis::GREATER);
  EXPECT_EQ(array.compare(ft, ft), analysis::EQUAL);
  EXPECT_EQ(array.compare(ft, tf), analysis::NO_RELATION);
  EXPECT_EQ(array.compare(ft, tt), analysis::LESS);

  EXPECT_EQ(array.compare(tf, ff), analysis::GREATER);
  EXPECT_EQ(array.compare(tf, ft), analysis::NO_RELATION);
  EXPECT_EQ(array.compare(tf, tf), analysis::EQUAL);
  EXPECT_EQ(array.compare(tf, tt), analysis::LESS);

  EXPECT_EQ(array.compare(tt, ff), analysis::GREATER);
  EXPECT_EQ(array.compare(tt, ft), analysis::GREATER);
  EXPECT_EQ(array.compare(tt, tf), analysis::GREATER);
  EXPECT_EQ(array.compare(tt, tt), analysis::EQUAL);
}

TEST(ArrayLattice, Join) {
  analysis::Array<analysis::Bool, 2> array{analysis::Bool{}};
  auto ff = []() { return std::array<bool, 2>{false, false}; };
  auto ft = []() { return std::array<bool, 2>{false, true}; };
  auto tf = []() { return std::array<bool, 2>{true, false}; };
  auto tt = []() { return std::array<bool, 2>{true, true}; };

  auto test =
    [&](auto& makeJoinee, auto& makeJoiner, bool modified, auto& makeExpected) {
      auto joinee = makeJoinee();
      EXPECT_EQ(array.join(joinee, makeJoiner()), modified);
      EXPECT_EQ(joinee, makeExpected());
    };

  test(ff, ff, false, ff);
  test(ff, ft, true, ft);
  test(ff, tf, true, tf);
  test(ff, tt, true, tt);

  test(ft, ff, false, ft);
  test(ft, ft, false, ft);
  test(ft, tf, true, tt);
  test(ft, tt, true, tt);

  test(tf, ff, false, tf);
  test(tf, ft, true, tt);
  test(tf, tf, false, tf);
  test(tf, tt, true, tt);

  test(tt, ff, false, tt);
  test(tt, ft, false, tt);
  test(tt, tf, false, tt);
  test(tt, tt, false, tt);
}

TEST(ArrayLattice, Meet) {
  analysis::Array<analysis::Bool, 2> array{analysis::Bool{}};
  auto ff = []() { return std::array<bool, 2>{false, false}; };
  auto ft = []() { return std::array<bool, 2>{false, true}; };
  auto tf = []() { return std::array<bool, 2>{true, false}; };
  auto tt = []() { return std::array<bool, 2>{true, true}; };

  auto test =
    [&](auto& makeMeetee, auto& makeMeeter, bool modified, auto& makeExpected) {
      auto meetee = makeMeetee();
      EXPECT_EQ(array.meet(meetee, makeMeeter()), modified);
      EXPECT_EQ(meetee, makeExpected());
    };

  test(ff, ff, false, ff);
  test(ff, ft, false, ff);
  test(ff, tf, false, ff);
  test(ff, tt, false, ff);

  test(ft, ff, true, ff);
  test(ft, ft, false, ft);
  test(ft, tf, true, ff);
  test(ft, tt, false, ft);

  test(tf, ff, true, ff);
  test(tf, ft, true, ff);
  test(tf, tf, false, tf);
  test(tf, tt, false, tf);

  test(tt, ff, true, ff);
  test(tt, ft, true, ft);
  test(tt, tf, true, tf);
  test(tt, tt, false, tt);
}

TEST(VectorLattice, GetBottom) {
  analysis::Vector<analysis::Bool> vector{analysis::Bool{}, 2};
  EXPECT_EQ(vector.getBottom(), (std::vector<bool>{false, false}));
}

TEST(VectorLattice, GetTop) {
  analysis::Vector<analysis::Bool> vector{analysis::Bool{}, 2};
  EXPECT_EQ(vector.getTop(), (std::vector<bool>{true, true}));
}

TEST(VectorLattice, Compare) {
  analysis::Vector<analysis::Bool> vector{analysis::Bool{}, 2};
  std::vector<bool> ff{false, false};
  std::vector<bool> ft{false, true};
  std::vector<bool> tf{true, false};
  std::vector<bool> tt{true, true};

  EXPECT_EQ(vector.compare(ff, ff), analysis::EQUAL);
  EXPECT_EQ(vector.compare(ff, ft), analysis::LESS);
  EXPECT_EQ(vector.compare(ff, tf), analysis::LESS);
  EXPECT_EQ(vector.compare(ff, tt), analysis::LESS);

  EXPECT_EQ(vector.compare(ft, ff), analysis::GREATER);
  EXPECT_EQ(vector.compare(ft, ft), analysis::EQUAL);
  EXPECT_EQ(vector.compare(ft, tf), analysis::NO_RELATION);
  EXPECT_EQ(vector.compare(ft, tt), analysis::LESS);

  EXPECT_EQ(vector.compare(tf, ff), analysis::GREATER);
  EXPECT_EQ(vector.compare(tf, ft), analysis::NO_RELATION);
  EXPECT_EQ(vector.compare(tf, tf), analysis::EQUAL);
  EXPECT_EQ(vector.compare(tf, tt), analysis::LESS);

  EXPECT_EQ(vector.compare(tt, ff), analysis::GREATER);
  EXPECT_EQ(vector.compare(tt, ft), analysis::GREATER);
  EXPECT_EQ(vector.compare(tt, tf), analysis::GREATER);
  EXPECT_EQ(vector.compare(tt, tt), analysis::EQUAL);
}

TEST(VectorLattice, Join) {
  analysis::Vector<analysis::Bool> vector{analysis::Bool{}, 2};
  auto ff = []() { return std::vector<bool>{false, false}; };
  auto ft = []() { return std::vector<bool>{false, true}; };
  auto tf = []() { return std::vector<bool>{true, false}; };
  auto tt = []() { return std::vector<bool>{true, true}; };

  auto test =
    [&](auto& makeJoinee, auto& makeJoiner, bool modified, auto& makeExpected) {
      auto joinee = makeJoinee();
      EXPECT_EQ(vector.join(joinee, makeJoiner()), modified);
      EXPECT_EQ(joinee, makeExpected());
    };

  test(ff, ff, false, ff);
  test(ff, ft, true, ft);
  test(ff, tf, true, tf);
  test(ff, tt, true, tt);

  test(ft, ff, false, ft);
  test(ft, ft, false, ft);
  test(ft, tf, true, tt);
  test(ft, tt, true, tt);

  test(tf, ff, false, tf);
  test(tf, ft, true, tt);
  test(tf, tf, false, tf);
  test(tf, tt, true, tt);

  test(tt, ff, false, tt);
  test(tt, ft, false, tt);
  test(tt, tf, false, tt);
  test(tt, tt, false, tt);
}

TEST(VectorLattice, Meet) {
  analysis::Vector<analysis::Bool> vector{analysis::Bool{}, 2};
  auto ff = []() { return std::vector<bool>{false, false}; };
  auto ft = []() { return std::vector<bool>{false, true}; };
  auto tf = []() { return std::vector<bool>{true, false}; };
  auto tt = []() { return std::vector<bool>{true, true}; };

  auto test =
    [&](auto& makeMeetee, auto& makeMeeter, bool modified, auto& makeExpected) {
      auto meetee = makeMeetee();
      EXPECT_EQ(vector.meet(meetee, makeMeeter()), modified);
      EXPECT_EQ(meetee, makeExpected());
    };

  test(ff, ff, false, ff);
  test(ff, ft, false, ff);
  test(ff, tf, false, ff);
  test(ff, tt, false, ff);

  test(ft, ff, true, ff);
  test(ft, ft, false, ft);
  test(ft, tf, true, ff);
  test(ft, tt, false, ft);

  test(tf, ff, true, ff);
  test(tf, ft, true, ff);
  test(tf, tf, false, tf);
  test(tf, tt, false, tf);

  test(tt, ff, true, ff);
  test(tt, ft, true, ft);
  test(tt, tf, true, tf);
  test(tt, tt, false, tt);
}

TEST(TupleLattice, GetBottom) {
  analysis::Tuple<analysis::Bool, analysis::UInt32> tuple{analysis::Bool{},
                                                          analysis::UInt32{}};
  EXPECT_EQ(tuple.getBottom(), (std::tuple{false, 0}));
}

TEST(TupleLattice, GetTop) {
  analysis::Tuple<analysis::Bool, analysis::UInt32> tuple{analysis::Bool{},
                                                          analysis::UInt32{}};
  EXPECT_EQ(tuple.getTop(), (std::tuple{true, uint32_t(-1)}));
}

TEST(TupleLattice, Compare) {
  analysis::Tuple<analysis::Bool, analysis::UInt32> tuple{analysis::Bool{},
                                                          analysis::UInt32{}};

  std::tuple<bool, uint32_t> ff{false, 0};
  std::tuple<bool, uint32_t> ft{false, 1};
  std::tuple<bool, uint32_t> tf{true, 0};
  std::tuple<bool, uint32_t> tt{true, 1};

  EXPECT_EQ(tuple.compare(ff, ff), analysis::EQUAL);
  EXPECT_EQ(tuple.compare(ff, ft), analysis::LESS);
  EXPECT_EQ(tuple.compare(ff, tf), analysis::LESS);
  EXPECT_EQ(tuple.compare(ff, tt), analysis::LESS);

  EXPECT_EQ(tuple.compare(ft, ff), analysis::GREATER);
  EXPECT_EQ(tuple.compare(ft, ft), analysis::EQUAL);
  EXPECT_EQ(tuple.compare(ft, tf), analysis::NO_RELATION);
  EXPECT_EQ(tuple.compare(ft, tt), analysis::LESS);

  EXPECT_EQ(tuple.compare(tf, ff), analysis::GREATER);
  EXPECT_EQ(tuple.compare(tf, ft), analysis::NO_RELATION);
  EXPECT_EQ(tuple.compare(tf, tf), analysis::EQUAL);
  EXPECT_EQ(tuple.compare(tf, tt), analysis::LESS);

  EXPECT_EQ(tuple.compare(tt, ff), analysis::GREATER);
  EXPECT_EQ(tuple.compare(tt, ft), analysis::GREATER);
  EXPECT_EQ(tuple.compare(tt, tf), analysis::GREATER);
  EXPECT_EQ(tuple.compare(tt, tt), analysis::EQUAL);
}

TEST(TupleLattice, Join) {
  analysis::Tuple<analysis::Bool, analysis::UInt32> tuple{analysis::Bool{},
                                                          analysis::UInt32{}};

  auto ff = []() { return std::tuple<bool, uint32_t>{false, 0}; };
  auto ft = []() { return std::tuple<bool, uint32_t>{false, 1}; };
  auto tf = []() { return std::tuple<bool, uint32_t>{true, 0}; };
  auto tt = []() { return std::tuple<bool, uint32_t>{true, 1}; };

  auto test =
    [&](auto& makeJoinee, auto& makeJoiner, bool modified, auto& makeExpected) {
      auto joinee = makeJoinee();
      EXPECT_EQ(tuple.join(joinee, makeJoiner()), modified);
      EXPECT_EQ(joinee, makeExpected());
    };

  test(ff, ff, false, ff);
  test(ff, ft, true, ft);
  test(ff, tf, true, tf);
  test(ff, tt, true, tt);

  test(ft, ff, false, ft);
  test(ft, ft, false, ft);
  test(ft, tf, true, tt);
  test(ft, tt, true, tt);

  test(tf, ff, false, tf);
  test(tf, ft, true, tt);
  test(tf, tf, false, tf);
  test(tf, tt, true, tt);

  test(tt, ff, false, tt);
  test(tt, ft, false, tt);
  test(tt, tf, false, tt);
  test(tt, tt, false, tt);
}

TEST(TupleLattice, Meet) {
  analysis::Tuple<analysis::Bool, analysis::UInt32> tuple{analysis::Bool{},
                                                          analysis::UInt32{}};

  auto ff = []() { return std::tuple<bool, uint32_t>{false, 0}; };
  auto ft = []() { return std::tuple<bool, uint32_t>{false, 1}; };
  auto tf = []() { return std::tuple<bool, uint32_t>{true, 0}; };
  auto tt = []() { return std::tuple<bool, uint32_t>{true, 1}; };

  auto test =
    [&](auto& makeMeetee, auto& makeMeeter, bool modified, auto& makeExpected) {
      auto meetee = makeMeetee();
      EXPECT_EQ(tuple.meet(meetee, makeMeeter()), modified);
      EXPECT_EQ(meetee, makeExpected());
    };

  test(ff, ff, false, ff);
  test(ff, ft, false, ff);
  test(ff, tf, false, ff);
  test(ff, tt, false, ff);

  test(ft, ff, true, ff);
  test(ft, ft, false, ft);
  test(ft, tf, true, ff);
  test(ft, tt, false, ft);

  test(tf, ff, true, ff);
  test(tf, ft, true, ff);
  test(tf, tf, false, tf);
  test(tf, tt, false, tf);

  test(tt, ff, true, ff);
  test(tt, ft, true, ft);
  test(tt, tf, true, tf);
  test(tt, tt, false, tt);
}

template<typename Set> void testPowersetGetBottom() {
  analysis::Powerset2<Set> powerset;
  auto bot = powerset.getBottom();
  EXPECT_EQ(bot, Set{});
  EXPECT_TRUE(bot.empty());
}

template<typename Set> void testPowersetGetTop() {
  analysis::FinitePowerset2<Set> powerset{0, 1};
  auto top = powerset.getTop();
  EXPECT_EQ(top, (Set{0, 1}));
}

template<typename Set> void testPowersetCompare() {
  analysis::Powerset2<Set> powerset;
  Set ff{};
  Set ft{0};
  Set tf{1};
  Set tt{0, 1};

  EXPECT_EQ(powerset.compare(ff, ff), analysis::EQUAL);
  EXPECT_EQ(powerset.compare(ff, ft), analysis::LESS);
  EXPECT_EQ(powerset.compare(ff, tf), analysis::LESS);
  EXPECT_EQ(powerset.compare(ff, tt), analysis::LESS);

  EXPECT_EQ(powerset.compare(ft, ff), analysis::GREATER);
  EXPECT_EQ(powerset.compare(ft, ft), analysis::EQUAL);
  EXPECT_EQ(powerset.compare(ft, tf), analysis::NO_RELATION);
  EXPECT_EQ(powerset.compare(ft, tt), analysis::LESS);

  EXPECT_EQ(powerset.compare(tf, ff), analysis::GREATER);
  EXPECT_EQ(powerset.compare(tf, ft), analysis::NO_RELATION);
  EXPECT_EQ(powerset.compare(tf, tf), analysis::EQUAL);
  EXPECT_EQ(powerset.compare(tf, tt), analysis::LESS);

  EXPECT_EQ(powerset.compare(tt, ff), analysis::GREATER);
  EXPECT_EQ(powerset.compare(tt, ft), analysis::GREATER);
  EXPECT_EQ(powerset.compare(tt, tf), analysis::GREATER);
  EXPECT_EQ(powerset.compare(tt, tt), analysis::EQUAL);
}

template<typename Set> void testPowersetJoin() {
  analysis::Powerset2<Set> powerset;
  auto ff = []() { return Set{}; };
  auto ft = []() { return Set{0}; };
  auto tf = []() { return Set{1}; };
  auto tt = []() { return Set{0, 1}; };

  auto test =
    [&](auto& makeJoinee, auto& makeJoiner, bool modified, auto& makeExpected) {
      auto joinee = makeJoinee();
      EXPECT_EQ(powerset.join(joinee, makeJoiner()), modified);
      EXPECT_EQ(joinee, makeExpected());
    };

  test(ff, ff, false, ff);
  test(ff, ft, true, ft);
  test(ff, tf, true, tf);
  test(ff, tt, true, tt);

  test(ft, ff, false, ft);
  test(ft, ft, false, ft);
  test(ft, tf, true, tt);
  test(ft, tt, true, tt);

  test(tf, ff, false, tf);
  test(tf, ft, true, tt);
  test(tf, tf, false, tf);
  test(tf, tt, true, tt);

  test(tt, ff, false, tt);
  test(tt, ft, false, tt);
  test(tt, tf, false, tt);
  test(tt, tt, false, tt);
}

template<typename Set> void testPowersetMeet() {
  analysis::FinitePowerset2<Set> powerset{0, 1};
  auto ff = []() { return Set{}; };
  auto ft = []() { return Set{0}; };
  auto tf = []() { return Set{1}; };
  auto tt = []() { return Set{0, 1}; };

  auto test =
    [&](auto& makeMeetee, auto& makeMeeter, bool modified, auto& makeExpected) {
      auto meetee = makeMeetee();
      EXPECT_EQ(powerset.meet(meetee, makeMeeter()), modified);
      EXPECT_EQ(meetee, makeExpected());
    };

  test(ff, ff, false, ff);
  test(ff, ft, false, ff);
  test(ff, tf, false, ff);
  test(ff, tt, false, ff);

  test(ft, ff, true, ff);
  test(ft, ft, false, ft);
  test(ft, tf, true, ff);
  test(ft, tt, false, ft);

  test(tf, ff, true, ff);
  test(tf, ft, true, ff);
  test(tf, tf, false, tf);
  test(tf, tt, false, tf);

  test(tt, ff, true, ff);
  test(tt, ft, true, ft);
  test(tt, tf, true, tf);
  test(tt, tt, false, tt);
}

TEST(PowersetLattice, GetBottom) {
  testPowersetGetBottom<std::unordered_set<int>>();
}

TEST(PowersetLattice, GetTop) { testPowersetGetTop<std::unordered_set<int>>(); }

TEST(PowersetLattice, Compare) {
  testPowersetCompare<std::unordered_set<int>>();
}

TEST(PowersetLattice, Join) { testPowersetJoin<std::unordered_set<int>>(); }

TEST(PowersetLattice, Meet) { testPowersetMeet<std::unordered_set<int>>(); }

TEST(PowersetBitLattice, GetBottom) { testPowersetGetBottom<BitSet>(); }

TEST(PowersetBitLattice, GetTop) { testPowersetGetTop<BitSet>(); }

TEST(PowersetBitLattice, Compare) { testPowersetCompare<BitSet>(); }

TEST(PowersetBitLattice, Join) { testPowersetJoin<BitSet>(); }

TEST(PowersetBitLattice, Meet) { testPowersetMeet<BitSet>(); }
