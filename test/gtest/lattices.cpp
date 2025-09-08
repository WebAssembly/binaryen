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
#include "analysis/lattices/shared.h"
#include "analysis/lattices/stack.h"
#include "analysis/lattices/tuple.h"
#include "analysis/lattices/valtype.h"
#include "analysis/lattices/vector.h"
#include "gtest/gtest.h"

using namespace wasm;

// Exhaustively test comparison on a subset of a lattice that is arranged like a
// diamond:
//
//   Top
//  /   \.
// A     B
//  \   /
//   Bot
//
template<typename L>
void testDiamondCompare(const L& lattice,
                        const typename L::Element& bot,
                        const typename L::Element& a,
                        const typename L::Element& b,
                        const typename L::Element& top) {
  EXPECT_EQ(lattice.compare(bot, bot), analysis::EQUAL);
  EXPECT_EQ(lattice.compare(bot, a), analysis::LESS);
  EXPECT_EQ(lattice.compare(bot, b), analysis::LESS);
  EXPECT_EQ(lattice.compare(bot, top), analysis::LESS);

  EXPECT_EQ(lattice.compare(a, bot), analysis::GREATER);
  EXPECT_EQ(lattice.compare(a, a), analysis::EQUAL);
  EXPECT_EQ(lattice.compare(a, b), analysis::NO_RELATION);
  EXPECT_EQ(lattice.compare(a, top), analysis::LESS);

  EXPECT_EQ(lattice.compare(b, bot), analysis::GREATER);
  EXPECT_EQ(lattice.compare(b, a), analysis::NO_RELATION);
  EXPECT_EQ(lattice.compare(b, b), analysis::EQUAL);
  EXPECT_EQ(lattice.compare(b, top), analysis::LESS);

  EXPECT_EQ(lattice.compare(top, bot), analysis::GREATER);
  EXPECT_EQ(lattice.compare(top, a), analysis::GREATER);
  EXPECT_EQ(lattice.compare(top, b), analysis::GREATER);
  EXPECT_EQ(lattice.compare(top, top), analysis::EQUAL);
}

// Same as above but for join.
template<typename L>
void testDiamondJoin(const L& lattice,
                     const typename L::Element& bot,
                     const typename L::Element& a,
                     const typename L::Element& b,
                     const typename L::Element& top) {

  auto test =
    [&](const auto& joinee, const auto& joiner, const auto& expected) {
      auto copy = joinee;
      EXPECT_EQ(lattice.join(copy, joiner), joinee != expected);
      EXPECT_EQ(copy, expected);
    };

  test(bot, bot, bot);
  test(bot, a, a);
  test(bot, b, b);
  test(bot, top, top);

  test(a, bot, a);
  test(a, a, a);
  test(a, b, top);
  test(a, top, top);

  test(b, bot, b);
  test(b, a, top);
  test(b, b, b);
  test(b, top, top);

  test(top, bot, top);
  test(top, a, top);
  test(top, b, top);
  test(top, top, top);
}

// Same as above but for meet.
template<typename L>
void testDiamondMeet(const L& lattice,
                     const typename L::Element& bot,
                     const typename L::Element& a,
                     const typename L::Element& b,
                     const typename L::Element& top) {
  auto test =
    [&](const auto& meetee, const auto& meeter, const auto& expected) {
      auto copy = meetee;
      EXPECT_EQ(lattice.meet(copy, meeter), meetee != expected);
      EXPECT_EQ(copy, expected);
    };

  test(bot, bot, bot);
  test(bot, a, bot);
  test(bot, b, bot);
  test(bot, top, bot);

  test(a, bot, bot);
  test(a, a, a);
  test(a, b, bot);
  test(a, top, a);

  test(b, bot, bot);
  test(b, a, bot);
  test(b, b, b);
  test(b, top, b);

  test(top, bot, bot);
  test(top, a, a);
  test(top, b, b);
  test(top, top, top);
}

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
  testDiamondCompare(
    flat, flat.getBottom(), flat.get(0), flat.get(1), flat.getTop());
}

TEST(FlatLattice, Join) {
  analysis::Flat<int> flat;
  testDiamondJoin(
    flat, flat.getBottom(), flat.get(0), flat.get(1), flat.getTop());
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
  testDiamondCompare(
    array, {false, false}, {false, true}, {true, false}, {true, true});
}

TEST(ArrayLattice, Join) {
  analysis::Array<analysis::Bool, 2> array{analysis::Bool{}};
  testDiamondJoin(
    array, {false, false}, {false, true}, {true, false}, {true, true});
}

TEST(ArrayLattice, Meet) {
  analysis::Array<analysis::Bool, 2> array{analysis::Bool{}};
  testDiamondMeet(
    array, {false, false}, {false, true}, {true, false}, {true, true});
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
  testDiamondCompare(
    vector, {false, false}, {false, true}, {true, false}, {true, true});
}

TEST(VectorLattice, Join) {
  analysis::Vector<analysis::Bool> vector{analysis::Bool{}, 2};
  testDiamondJoin(
    vector, {false, false}, {false, true}, {true, false}, {true, true});
}

TEST(VectorLattice, Meet) {
  analysis::Vector<analysis::Bool> vector{analysis::Bool{}, 2};
  testDiamondMeet(
    vector, {false, false}, {false, true}, {true, false}, {true, true});
}

TEST(VectorLattice, JoinSingleton) {
  using Vec = analysis::Vector<analysis::Bool>;
  Vec vector{analysis::Bool{}, 2};
  auto elem = vector.getBottom();

  EXPECT_FALSE(vector.join(elem, Vec::SingletonElement(0, false)));
  EXPECT_EQ(elem, (std::vector{false, false}));

  EXPECT_TRUE(vector.join(elem, Vec::SingletonElement(1, true)));
  EXPECT_EQ(elem, (std::vector{false, true}));
}

TEST(VectorLattice, MeetSingleton) {
  using Vec = analysis::Vector<analysis::Bool>;
  Vec vector{analysis::Bool{}, 2};
  auto elem = vector.getTop();

  EXPECT_FALSE(vector.meet(elem, Vec::SingletonElement(1, true)));
  EXPECT_EQ(elem, (std::vector{true, true}));

  EXPECT_TRUE(vector.meet(elem, Vec::SingletonElement(0, false)));
  EXPECT_EQ(elem, (std::vector{false, true}));
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
  testDiamondCompare(tuple, {false, 0}, {false, 1}, {true, 0}, {true, 1});
}

TEST(TupleLattice, Join) {
  analysis::Tuple<analysis::Bool, analysis::UInt32> tuple{analysis::Bool{},
                                                          analysis::UInt32{}};
  testDiamondJoin(tuple, {false, 0}, {false, 1}, {true, 0}, {true, 1});
}

TEST(TupleLattice, Meet) {
  analysis::Tuple<analysis::Bool, analysis::UInt32> tuple{analysis::Bool{},
                                                          analysis::UInt32{}};
  testDiamondMeet(tuple, {false, 0}, {false, 1}, {true, 0}, {true, 1});
}

TEST(ValTypeLattice, GetBottom) {
  analysis::ValType valtype;
  EXPECT_EQ(valtype.getBottom(), Type::unreachable);
}

TEST(ValTypeLattice, GetTop) {
  analysis::ValType valtype;
  EXPECT_EQ(valtype.getTop(), Type::none);
}

TEST(ValTypeLattice, Compare) {
  analysis::ValType valtype;
  testDiamondCompare(
    valtype, Type::unreachable, Type::i32, Type::f32, Type::none);
  testDiamondCompare(valtype,
                     Type(HeapType::none, NonNullable),
                     Type(HeapType::struct_, NonNullable),
                     Type(HeapType::array, Nullable),
                     Type(HeapType::eq, Nullable));
}

TEST(ValTypeLattice, Join) {
  analysis::ValType valtype;
  testDiamondJoin(valtype, Type::unreachable, Type::i32, Type::f32, Type::none);
  testDiamondJoin(valtype,
                  Type(HeapType::none, NonNullable),
                  Type(HeapType::struct_, NonNullable),
                  Type(HeapType::array, Nullable),
                  Type(HeapType::eq, Nullable));
}

TEST(ValTypeLattice, Meet) {
  analysis::ValType valtype;
  testDiamondMeet(valtype, Type::unreachable, Type::i32, Type::f32, Type::none);
  testDiamondMeet(valtype,
                  Type(HeapType::none, NonNullable),
                  Type(HeapType::struct_, NonNullable),
                  Type(HeapType::array, Nullable),
                  Type(HeapType::eq, Nullable));
}

TEST(SharedLattice, GetBottom) {
  analysis::SharedPath<analysis::UInt32> shared{analysis::UInt32{}};
  EXPECT_EQ(*shared.getBottom(), 0u);
}

TEST(SharedLattice, Compare) {
  analysis::SharedPath<analysis::UInt32> shared{analysis::UInt32{}};

  auto zero = shared.getBottom();

  auto one = shared.getBottom();
  shared.join(one, 1);

  // This join will not change the value.
  auto uno = one;
  shared.join(uno, 1);

  auto two = shared.getBottom();
  shared.join(two, 2);

  EXPECT_EQ(shared.compare(zero, zero), analysis::EQUAL);
  EXPECT_EQ(shared.compare(zero, one), analysis::LESS);
  EXPECT_EQ(shared.compare(zero, uno), analysis::LESS);
  EXPECT_EQ(shared.compare(zero, two), analysis::LESS);

  EXPECT_EQ(shared.compare(one, zero), analysis::GREATER);
  EXPECT_EQ(shared.compare(one, one), analysis::EQUAL);
  EXPECT_EQ(shared.compare(one, uno), analysis::EQUAL);
  EXPECT_EQ(shared.compare(one, two), analysis::LESS);

  EXPECT_EQ(shared.compare(two, zero), analysis::GREATER);
  EXPECT_EQ(shared.compare(two, one), analysis::GREATER);
  EXPECT_EQ(shared.compare(two, uno), analysis::GREATER);
  EXPECT_EQ(shared.compare(two, two), analysis::EQUAL);

  EXPECT_EQ(*zero, 2u);
  EXPECT_EQ(*one, 2u);
  EXPECT_EQ(*uno, 2u);
  EXPECT_EQ(*two, 2u);
}

TEST(SharedLattice, Join) {
  analysis::SharedPath<analysis::UInt32> shared{analysis::UInt32{}};

  auto zero = shared.getBottom();

  auto one = shared.getBottom();
  shared.join(one, 1);

  auto two = shared.getBottom();
  shared.join(two, 2);

  {
    auto elem = zero;
    EXPECT_FALSE(shared.join(elem, zero));
    EXPECT_EQ(elem, zero);
  }

  {
    auto elem = zero;
    EXPECT_TRUE(shared.join(elem, one));
    EXPECT_EQ(elem, one);
  }

  {
    auto elem = zero;
    EXPECT_TRUE(shared.join(elem, two));
    EXPECT_EQ(elem, two);
  }

  {
    auto elem = one;
    EXPECT_FALSE(shared.join(elem, zero));
    EXPECT_EQ(elem, one);
  }

  {
    auto elem = one;
    EXPECT_FALSE(shared.join(elem, one));
    EXPECT_EQ(elem, one);
  }

  {
    auto elem = one;
    EXPECT_TRUE(shared.join(elem, two));
    EXPECT_EQ(elem, two);
  }

  {
    auto elem = two;
    EXPECT_FALSE(shared.join(elem, zero));
    EXPECT_EQ(elem, two);
  }

  {
    auto elem = two;
    EXPECT_FALSE(shared.join(elem, one));
    EXPECT_EQ(elem, two);
  }

  {
    auto elem = two;
    EXPECT_FALSE(shared.join(elem, two));
    EXPECT_EQ(elem, two);
  }
}

TEST(SharedLattice, JoinVecSingleton) {
  using Vec = analysis::Vector<analysis::Bool>;
  analysis::SharedPath<Vec> shared{analysis::Vector{analysis::Bool{}, 2}};

  auto elem = shared.getBottom();
  EXPECT_TRUE(shared.join(elem, Vec::SingletonElement(1, true)));
  EXPECT_EQ(*elem, (std::vector{false, true}));
}

TEST(SharedLattice, JoinInvertedVecSingleton) {
  using Vec = analysis::Vector<analysis::Bool>;
  analysis::SharedPath<analysis::Inverted<Vec>> shared{
    analysis::Inverted{analysis::Vector{analysis::Bool{}, 2}}};

  auto elem = shared.getBottom();
  EXPECT_TRUE(shared.join(elem, Vec::SingletonElement(1, false)));
  EXPECT_EQ(*elem, (std::vector{true, false}));
}

TEST(StackLattice, GetBottom) {
  analysis::Stack stack{analysis::Flat<uint32_t>{}};
  EXPECT_EQ(stack.getBottom().size(), 0u);
}

TEST(StackLattice, Compare) {
  analysis::Stack stack{analysis::Flat<uint32_t>{}};
  auto& flat = stack.lattice;
  testDiamondCompare(stack,
                     {},
                     {flat.get(0)},
                     {flat.get(0), flat.get(1)},
                     {flat.get(0), flat.getTop()});
}

TEST(StackLattice, Join) {
  analysis::Stack stack{analysis::Flat<uint32_t>{}};
  auto& flat = stack.lattice;
  testDiamondJoin(stack,
                  {},
                  {flat.get(0)},
                  {flat.get(0), flat.get(1)},
                  {flat.get(0), flat.getTop()});
}
