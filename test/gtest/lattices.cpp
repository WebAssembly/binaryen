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

#include "analysis/lattice.h"
#include "analysis/lattices/abstraction.h"
#include "analysis/lattices/array.h"
#include "analysis/lattices/bool.h"
#include "analysis/lattices/conetype.h"
#include "analysis/lattices/flat.h"
#include "analysis/lattices/int.h"
#include "analysis/lattices/inverted.h"
#include "analysis/lattices/lift.h"
#include "analysis/lattices/shared.h"
#include "analysis/lattices/stack.h"
#include "analysis/lattices/tuple.h"
#include "analysis/lattices/valtype.h"
#include "analysis/lattices/vector.h"
#include "ir/subtypes.h"
#include "wasm-type.h"
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

TEST(FlatLattice, MultipleTypes) {
  analysis::Flat<int, std::string> flat;
  testDiamondJoin(
    flat, flat.getBottom(), flat.get(0), flat.get("foo"), flat.getTop());

  auto stringElem = flat.get("foo");

  EXPECT_EQ(stringElem.getVal<0>(), nullptr);
  ASSERT_NE(stringElem.getVal<1>(), nullptr);
  EXPECT_EQ(*stringElem.getVal<1>(), std::string("foo"));

  EXPECT_EQ(stringElem.getVal<int>(), nullptr);
  ASSERT_NE(stringElem.getVal<std::string>(), nullptr);
  EXPECT_EQ(*stringElem.getVal<std::string>(), std::string("foo"));
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
                     {flat.get(0u)},
                     {flat.get(0u), flat.get(1u)},
                     {flat.get(0u), flat.getTop()});
}

TEST(StackLattice, Join) {
  analysis::Stack stack{analysis::Flat<uint32_t>{}};
  auto& flat = stack.lattice;
  testDiamondJoin(stack,
                  {},
                  {flat.get(0u)},
                  {flat.get(0u), flat.get(1u)},
                  {flat.get(0u), flat.getTop()});
}

using OddEvenInt = analysis::Flat<uint32_t>;
using OddEvenBool = analysis::Flat<bool>;
struct OddEvenAbstraction
  : analysis::Abstraction<OddEvenAbstraction, OddEvenInt, OddEvenBool> {
  OddEvenAbstraction()
    : analysis::Abstraction<OddEvenAbstraction, OddEvenInt, OddEvenBool>(
        OddEvenInt{}, OddEvenBool{}) {}

  template<size_t I, typename E1, typename E2> E2 abstract(const E1&) const;

  template<std::size_t I, typename E>
  bool shouldAbstract(const E&, const E&) const;
};

template<>
OddEvenBool::Element
OddEvenAbstraction::abstract<0>(const OddEvenInt::Element& elem) const {
  if (elem.isTop()) {
    return OddEvenBool{}.getTop();
  }
  if (elem.isBottom()) {
    return OddEvenBool{}.getBottom();
  }
  return OddEvenBool{}.get((*elem.getVal() & 1) == 0);
}

template<>
bool OddEvenAbstraction::shouldAbstract<0>(const OddEvenInt::Element&,
                                           const OddEvenInt::Element&) const {
  // Since the elements are not related, they must be different integers.
  // Always abstract them.
  return true;
}

TEST(AbstractionLattice, GetBottom) {
  OddEvenAbstraction abstraction;
  auto expected = OddEvenAbstraction::Element(OddEvenInt{}.getBottom());
  EXPECT_EQ(abstraction.getBottom(), expected);
}

TEST(AbstractionLattice, Join) {
  OddEvenAbstraction abstraction;

  auto expectJoin = [&](const char* file,
                        int line,
                        const auto& joinee,
                        const auto& joiner,
                        const auto& expected) {
    testing::ScopedTrace trace(file, line, "");
    switch (abstraction.compare(joinee, joiner)) {
      case analysis::NO_RELATION:
        EXPECT_NE(joinee, joiner);
        EXPECT_EQ(abstraction.compare(joiner, joinee), analysis::NO_RELATION);
        EXPECT_EQ(abstraction.compare(joinee, expected), analysis::LESS);
        EXPECT_EQ(abstraction.compare(joiner, expected), analysis::LESS);
        break;
      case analysis::EQUAL:
        EXPECT_EQ(joinee, joiner);
        EXPECT_EQ(abstraction.compare(joiner, joinee), analysis::EQUAL);
        EXPECT_EQ(abstraction.compare(joinee, expected), analysis::EQUAL);
        EXPECT_EQ(abstraction.compare(joiner, expected), analysis::EQUAL);
        break;
      case analysis::LESS:
        EXPECT_EQ(joiner, expected);
        EXPECT_EQ(abstraction.compare(joiner, joinee), analysis::GREATER);
        EXPECT_EQ(abstraction.compare(joinee, expected), analysis::LESS);
        EXPECT_EQ(abstraction.compare(joiner, expected), analysis::EQUAL);
        break;
      case analysis::GREATER:
        EXPECT_EQ(joinee, expected);
        EXPECT_EQ(abstraction.compare(joiner, joinee), analysis::LESS);
        EXPECT_EQ(abstraction.compare(joinee, expected), analysis::EQUAL);
        EXPECT_EQ(abstraction.compare(joiner, expected), analysis::LESS);
    }
    {
      auto copy = joinee;
      EXPECT_EQ(abstraction.join(copy, joiner), joinee != expected);
      EXPECT_EQ(copy, expected);
    }
    {
      auto copy = joiner;
      EXPECT_EQ(abstraction.join(copy, joinee), joiner != expected);
      EXPECT_EQ(copy, expected);
    }
  };

#define JOIN(a, b, c) expectJoin(__FILE__, __LINE__, a, b, c)

  auto bot = abstraction.getBottom();
  auto one = OddEvenAbstraction::Element(OddEvenInt{}.get(1u));
  auto two = OddEvenAbstraction::Element(OddEvenInt{}.get(2u));
  auto three = OddEvenAbstraction::Element(OddEvenInt{}.get(3u));
  auto four = OddEvenAbstraction::Element(OddEvenInt{}.get(4u));
  auto even = OddEvenAbstraction::Element(OddEvenBool{}.get(true));
  auto odd = OddEvenAbstraction::Element(OddEvenBool{}.get(false));
  auto top = OddEvenAbstraction::Element(OddEvenBool{}.getTop());

  JOIN(bot, bot, bot);
  JOIN(bot, one, one);
  JOIN(bot, two, two);
  JOIN(bot, even, even);
  JOIN(bot, odd, odd);
  JOIN(bot, top, top);

  JOIN(one, one, one);
  JOIN(one, two, top);
  JOIN(one, three, odd);
  JOIN(one, even, top);
  JOIN(one, odd, odd);

  JOIN(two, two, two);
  JOIN(two, three, top);
  JOIN(two, four, even);
  JOIN(two, even, even);
  JOIN(two, odd, top);
  JOIN(two, top, top);

  JOIN(even, even, even);
  JOIN(even, odd, top);
  JOIN(even, top, top);

  JOIN(odd, odd, odd);
  JOIN(odd, top, top);

#undef JOIN
}

class ConeTypeLatticeTest : public ::testing::Test {
protected:
  HeapType super;
  HeapType sub1;
  HeapType sub2;
  HeapType other;
  analysis::ConeType lattice;

  using Element = analysis::ConeType::Element;
  Element bot;
  Element top;
  Element i32;
  Element i64;

  // The number at the end is the depth of the element.
  Element eqNull3;
  Element eqNonNull3;
  Element structNull2;
  Element structNonNull2;
  Element i31Null;
  Element i31NonNull;
  Element noneNull;
  Element noneNonNull;
  Element superNull1;
  Element superNonNull1;
  Element superNullExact;
  Element superNonNullExact;
  Element sub1Null0;
  Element sub1NonNull0;
  Element sub1NullExact;
  Element sub1NonNullExact;
  Element sub2Null0;
  Element sub2NonNull0;
  Element sub2NullExact;
  Element sub2NonNullExact;
  Element otherNull0;
  Element otherNonNull0;
  Element otherNullExact;
  Element otherNonNullExact;

  // Element created by combining other elements.
  Element eqNull2;
  Element eqNonNull2;
  Element structNull1;
  Element structNonNull1;

  void checkJoin(const Element& a,
                 const Element& b,
                 const Element& join,
                 const char* file,
                 int line) {
    testing::ScopedTrace trace(file, line, "check join");
    Element copy = a;
    EXPECT_EQ(lattice.join(copy, b), a != join);
    EXPECT_EQ(copy, join);
    copy = b;
    EXPECT_EQ(lattice.join(copy, a), b != join);
    EXPECT_EQ(copy, join);
  }
#define CHECK_JOIN(a, b, join) checkJoin(a, b, join, __FILE__, __LINE__)

  void checkMeet(const Element& a,
                 const Element& b,
                 const Element& meet,
                 const char* file,
                 int line) {
    testing::ScopedTrace trace(file, line, "check meet");
    Element copy = a;
    EXPECT_EQ(lattice.meet(copy, b), a != meet);
    EXPECT_EQ(copy, meet);
    copy = b;
    EXPECT_EQ(lattice.meet(copy, a), b != meet);
    EXPECT_EQ(copy, meet);
  }
#define CHECK_MEET(a, b, join) checkMeet(a, b, join, __FILE__, __LINE__)

  void
  checkLess(const Element& a, const Element& b, const char* file, int line) {
    testing::ScopedTrace trace(file, line, "check less");
    EXPECT_EQ(lattice.compare(a, b), analysis::LESS);
    EXPECT_EQ(lattice.compare(b, a), analysis::GREATER);
  }
#define CHECK_LESS(a, b) checkLess(a, b, __FILE__, __LINE__)

  void
  checkGreater(const Element& a, const Element& b, const char* file, int line) {
    testing::ScopedTrace trace(file, line, "check greater");
    EXPECT_EQ(lattice.compare(a, b), analysis::GREATER);
    EXPECT_EQ(lattice.compare(b, a), analysis::LESS);
  }
#define CHECK_GREATER(a, b) checkGreater(a, b, __FILE__, __LINE__)

  void checkUnrelated(const Element& a,
                      const Element& b,
                      const char* file,
                      int line) {
    testing::ScopedTrace trace(file, line, "check unrelated");
    EXPECT_EQ(lattice.compare(a, b), analysis::NO_RELATION);
    EXPECT_EQ(lattice.compare(b, a), analysis::NO_RELATION);
  }
#define CHECK_UNRELATED(a, b) checkUnrelated(a, b, __FILE__, __LINE__)

  void
  checkEqual(const Element& a, const Element& b, const char* file, int line) {
    testing::ScopedTrace trace(file, line, "check equal");
    EXPECT_EQ(lattice.compare(a, b), analysis::EQUAL);
    EXPECT_EQ(lattice.compare(b, a), analysis::EQUAL);
  }
#define CHECK_EQUAL(a, b) checkEqual(a, b, __FILE__, __LINE__)

  void checkPair(const Element& a,
                 const Element& b,
                 const Element& join,
                 const Element& meet,
                 const char* file,
                 int line) {
    testing::ScopedTrace trace(file, line, "check pair");
    CHECK_JOIN(a, b, join);
    CHECK_MEET(a, b, meet);
    switch (lattice.compare(a, b)) {
      case analysis::NO_RELATION:
        // This first check looks redundant, but it's also checking the opposite
        // direction.
        CHECK_UNRELATED(a, b);
        CHECK_LESS(a, join);
        CHECK_LESS(b, join);
        CHECK_GREATER(a, meet);
        CHECK_GREATER(b, meet);
        CHECK_LESS(meet, join);
        break;
      case analysis::EQUAL:
        CHECK_EQUAL(a, b);
        CHECK_EQUAL(a, join);
        CHECK_EQUAL(b, meet);
        break;
      case analysis::LESS:
        CHECK_LESS(a, b);
        CHECK_EQUAL(b, join);
        CHECK_EQUAL(a, meet);
        break;
      case analysis::GREATER:
        CHECK_GREATER(a, b);
        CHECK_EQUAL(a, join);
        CHECK_EQUAL(b, meet);
        break;
    }
  }
#define CHECK_PAIR(a, b, join, meet)                                           \
  checkPair(a, b, join, meet, __FILE__, __LINE__)

public:
  ConeTypeLatticeTest() : lattice(initTypes(this)) {
    bot = lattice.getBottom();
    top = lattice.getTop();
    i32 = lattice.get(Type::i32);
    i64 = lattice.get(Type::i64);
    eqNull3 = lattice.get(Type(HeapType::eq, Nullable));
    eqNonNull3 = lattice.get(Type(HeapType::eq, NonNullable));
    structNull2 = lattice.get(Type(HeapType::struct_, Nullable));
    structNonNull2 = lattice.get(Type(HeapType::struct_, NonNullable));
    i31Null = lattice.get(Type(HeapType::i31, Nullable));
    i31NonNull = lattice.get(Type(HeapType::i31, NonNullable));
    noneNull = lattice.get(Type(HeapType::none, Nullable));
    noneNonNull = lattice.get(Type(HeapType::none, NonNullable));
    superNull1 = lattice.get(Type(super, Nullable));
    superNonNull1 = lattice.get(Type(super, NonNullable));
    superNullExact = lattice.get(Type(super, Nullable, Exact));
    superNonNullExact = lattice.get(Type(super, NonNullable, Exact));
    sub1Null0 = lattice.get(Type(sub1, Nullable));
    sub1NonNull0 = lattice.get(Type(sub1, NonNullable));
    sub1NullExact = lattice.get(Type(sub1, Nullable, Exact));
    sub1NonNullExact = lattice.get(Type(sub1, NonNullable, Exact));
    sub2Null0 = lattice.get(Type(sub2, Nullable));
    sub2NonNull0 = lattice.get(Type(sub2, NonNullable));
    sub2NullExact = lattice.get(Type(sub2, Nullable, Exact));
    sub2NonNullExact = lattice.get(Type(sub2, NonNullable, Exact));
    otherNull0 = lattice.get(Type(other, Nullable));
    otherNonNull0 = lattice.get(Type(other, NonNullable));
    otherNullExact = lattice.get(Type(other, Nullable, Exact));
    otherNonNullExact = lattice.get(Type(other, NonNullable, Exact));

    eqNull2 = Element{eqNull3.type, 2};
    eqNonNull2 = Element{eqNonNull3.type, 2};
    structNull1 = Element{structNull2.type, 1};
    structNonNull1 = Element{structNonNull2.type, 1};
  }

private:
  static std::unordered_map<HeapType, Index>
  initTypes(ConeTypeLatticeTest* self);
};

std::unordered_map<HeapType, Index>
ConeTypeLatticeTest::initTypes(ConeTypeLatticeTest* self) {
  //   0  3
  //  /|
  // 1 2
  TypeBuilder builder(4);
  builder.createRecGroup(0, 4);
  builder[0] = Struct{};
  builder[1] = Struct{};
  builder[2] = Struct{};
  builder[3] = Struct{};
  builder[0].setOpen();
  builder[1].subTypeOf(builder[0]);
  builder[2].subTypeOf(builder[0]);
  auto types = *builder.build();

  self->super = types[0];
  self->sub1 = types[1];
  self->sub2 = types[2];
  self->other = types[3];

  SubTypes subtypes(types);
  return subtypes.getMaxDepths();
}

TEST_F(ConeTypeLatticeTest, GetBottom) {
  EXPECT_TRUE(lattice.getBottom().isBottom());
  EXPECT_EQ(lattice.getBottom().type, Type(Type::unreachable));
  EXPECT_EQ(lattice.getBottom().depth, 0);
}

TEST_F(ConeTypeLatticeTest, GetTop) {
  EXPECT_TRUE(lattice.getTop().isTop());
  EXPECT_EQ(lattice.getTop().type, Type(Type::none));
  EXPECT_EQ(lattice.getTop().depth, 0);
}

TEST_F(ConeTypeLatticeTest, Relations) {
  CHECK_PAIR(bot, bot, bot, bot);
  CHECK_PAIR(bot, top, top, bot);
  CHECK_PAIR(bot, i32, i32, bot);
  CHECK_PAIR(bot, i64, i64, bot);
  CHECK_PAIR(bot, eqNull3, eqNull3, bot);
  CHECK_PAIR(bot, eqNonNull3, eqNonNull3, bot);
  CHECK_PAIR(bot, structNull2, structNull2, bot);
  CHECK_PAIR(bot, structNonNull2, structNonNull2, bot);
  CHECK_PAIR(bot, i31Null, i31Null, bot);
  CHECK_PAIR(bot, i31NonNull, i31NonNull, bot);
  CHECK_PAIR(bot, noneNull, noneNull, bot);
  CHECK_PAIR(bot, noneNonNull, noneNonNull, bot);
  CHECK_PAIR(bot, superNull1, superNull1, bot);
  CHECK_PAIR(bot, superNonNull1, superNonNull1, bot);
  CHECK_PAIR(bot, superNullExact, superNullExact, bot);
  CHECK_PAIR(bot, superNonNullExact, superNonNullExact, bot);

  CHECK_PAIR(top, top, top, top);
  CHECK_PAIR(top, i32, top, i32);
  CHECK_PAIR(top, i64, top, i64);
  CHECK_PAIR(top, eqNull3, top, eqNull3);
  CHECK_PAIR(top, eqNonNull3, top, eqNonNull3);
  CHECK_PAIR(top, structNull2, top, structNull2);
  CHECK_PAIR(top, structNonNull2, top, structNonNull2);
  CHECK_PAIR(top, i31Null, top, i31Null);
  CHECK_PAIR(top, i31NonNull, top, i31NonNull);
  CHECK_PAIR(top, noneNull, top, noneNull);
  CHECK_PAIR(top, noneNonNull, top, noneNonNull);
  CHECK_PAIR(top, superNull1, top, superNull1);
  CHECK_PAIR(top, superNonNull1, top, superNonNull1);
  CHECK_PAIR(top, superNullExact, top, superNullExact);
  CHECK_PAIR(top, superNonNullExact, top, superNonNullExact);

  CHECK_PAIR(i32, i32, i32, i32);
  CHECK_PAIR(i32, i64, top, bot);
  CHECK_PAIR(i32, eqNull3, top, bot);
  CHECK_PAIR(i32, eqNonNull3, top, bot);
  CHECK_PAIR(i32, structNull2, top, bot);
  CHECK_PAIR(i32, structNonNull2, top, bot);
  CHECK_PAIR(i32, i31Null, top, bot);
  CHECK_PAIR(i32, i31NonNull, top, bot);
  CHECK_PAIR(i32, noneNull, top, bot);
  CHECK_PAIR(i32, noneNonNull, top, bot);
  CHECK_PAIR(i32, superNull1, top, bot);
  CHECK_PAIR(i32, superNonNull1, top, bot);
  CHECK_PAIR(i32, superNullExact, top, bot);
  CHECK_PAIR(i32, superNonNullExact, top, bot);

  CHECK_PAIR(eqNull3, eqNull3, eqNull3, eqNull3);
  CHECK_PAIR(eqNull3, eqNonNull3, eqNull3, eqNonNull3);
  CHECK_PAIR(eqNull3, structNull2, eqNull3, structNull2);
  CHECK_PAIR(eqNull3, structNonNull2, eqNull3, structNonNull2);
  CHECK_PAIR(eqNull3, i31Null, eqNull3, i31Null);
  CHECK_PAIR(eqNull3, i31NonNull, eqNull3, i31NonNull);
  CHECK_PAIR(eqNull3, noneNull, eqNull3, noneNull);
  CHECK_PAIR(eqNull3, noneNonNull, eqNull3, noneNonNull);
  CHECK_PAIR(eqNull3, superNull1, eqNull3, superNull1);
  CHECK_PAIR(eqNull3, superNonNull1, eqNull3, superNonNull1);
  CHECK_PAIR(eqNull3, superNullExact, eqNull3, superNullExact);
  CHECK_PAIR(eqNull3, superNonNullExact, eqNull3, superNonNullExact);

  CHECK_PAIR(eqNonNull3, eqNonNull3, eqNonNull3, eqNonNull3);
  CHECK_PAIR(eqNonNull3, structNull2, eqNull3, structNonNull2);
  CHECK_PAIR(eqNonNull3, structNonNull2, eqNonNull3, structNonNull2);
  CHECK_PAIR(eqNonNull3, i31Null, eqNull3, i31NonNull);
  CHECK_PAIR(eqNonNull3, i31NonNull, eqNonNull3, i31NonNull);
  CHECK_PAIR(eqNonNull3, noneNull, eqNull3, noneNonNull);
  CHECK_PAIR(eqNonNull3, noneNonNull, eqNonNull3, noneNonNull);
  CHECK_PAIR(eqNonNull3, superNull1, eqNull3, superNonNull1);
  CHECK_PAIR(eqNonNull3, superNonNull1, eqNonNull3, superNonNull1);
  CHECK_PAIR(eqNonNull3, superNullExact, eqNull3, superNonNullExact);
  CHECK_PAIR(eqNonNull3, superNonNullExact, eqNonNull3, superNonNullExact);

  CHECK_PAIR(structNull2, structNull2, structNull2, structNull2);
  CHECK_PAIR(structNull2, structNonNull2, structNull2, structNonNull2);
  CHECK_PAIR(structNull2, i31Null, eqNull3, noneNull);
  CHECK_PAIR(structNull2, i31NonNull, eqNull3, noneNonNull);
  CHECK_PAIR(structNull2, noneNull, structNull2, noneNull);
  CHECK_PAIR(structNull2, noneNonNull, structNull2, noneNonNull);
  CHECK_PAIR(structNull2, superNull1, structNull2, superNull1);
  CHECK_PAIR(structNull2, superNonNull1, structNull2, superNonNull1);
  CHECK_PAIR(structNull2, superNullExact, structNull2, superNullExact);
  CHECK_PAIR(structNull2, superNonNullExact, structNull2, superNonNullExact);

  CHECK_PAIR(structNonNull2, structNonNull2, structNonNull2, structNonNull2);
  CHECK_PAIR(structNonNull2, i31Null, eqNull3, noneNonNull);
  CHECK_PAIR(structNonNull2, i31NonNull, eqNonNull3, noneNonNull);
  CHECK_PAIR(structNonNull2, noneNull, structNull2, noneNonNull);
  CHECK_PAIR(structNonNull2, noneNonNull, structNonNull2, noneNonNull);
  CHECK_PAIR(structNonNull2, superNull1, structNull2, superNonNull1);
  CHECK_PAIR(structNonNull2, superNonNull1, structNonNull2, superNonNull1);
  CHECK_PAIR(structNonNull2, superNullExact, structNull2, superNonNullExact);
  CHECK_PAIR(
    structNonNull2, superNonNullExact, structNonNull2, superNonNullExact);

  CHECK_PAIR(i31Null, i31Null, i31Null, i31Null);
  CHECK_PAIR(i31Null, i31NonNull, i31Null, i31NonNull);
  CHECK_PAIR(i31Null, noneNull, i31Null, noneNull);
  CHECK_PAIR(i31Null, noneNonNull, i31Null, noneNonNull);
  CHECK_PAIR(i31Null, superNull1, eqNull3, noneNull);
  CHECK_PAIR(i31Null, superNonNull1, eqNull3, noneNonNull);
  CHECK_PAIR(i31Null, superNullExact, eqNull2, noneNull);
  CHECK_PAIR(i31Null, superNonNullExact, eqNull2, noneNonNull);

  CHECK_PAIR(i31NonNull, i31NonNull, i31NonNull, i31NonNull);
  CHECK_PAIR(i31NonNull, noneNull, i31Null, noneNonNull);
  CHECK_PAIR(i31NonNull, noneNonNull, i31NonNull, noneNonNull);
  CHECK_PAIR(i31NonNull, superNull1, eqNull3, noneNonNull);
  CHECK_PAIR(i31NonNull, superNonNull1, eqNonNull3, noneNonNull);
  CHECK_PAIR(i31NonNull, superNullExact, eqNull2, noneNonNull);
  CHECK_PAIR(i31NonNull, superNonNullExact, eqNonNull2, noneNonNull);

  CHECK_PAIR(noneNull, noneNull, noneNull, noneNull);
  CHECK_PAIR(noneNull, noneNonNull, noneNull, noneNonNull);
  CHECK_PAIR(noneNull, superNull1, superNull1, noneNull);
  CHECK_PAIR(noneNull, superNonNull1, superNull1, noneNonNull);
  CHECK_PAIR(noneNull, superNullExact, superNullExact, noneNull);
  CHECK_PAIR(noneNull, superNonNullExact, superNullExact, noneNonNull);

  CHECK_PAIR(noneNonNull, noneNonNull, noneNonNull, noneNonNull);
  CHECK_PAIR(noneNonNull, superNull1, superNull1, noneNonNull);
  CHECK_PAIR(noneNonNull, superNonNull1, superNonNull1, noneNonNull);
  CHECK_PAIR(noneNonNull, superNullExact, superNullExact, noneNonNull);
  CHECK_PAIR(noneNonNull, superNonNullExact, superNonNullExact, noneNonNull);

  CHECK_PAIR(superNull1, superNull1, superNull1, superNull1);
  CHECK_PAIR(superNull1, superNonNull1, superNull1, superNonNull1);
  CHECK_PAIR(superNull1, superNullExact, superNull1, superNullExact);
  CHECK_PAIR(superNull1, superNonNullExact, superNull1, superNonNullExact);
  CHECK_PAIR(superNull1, sub1Null0, superNull1, sub1Null0);
  CHECK_PAIR(superNull1, sub1NonNull0, superNull1, sub1NonNull0);
  CHECK_PAIR(superNull1, sub1NullExact, superNull1, sub1NullExact);
  CHECK_PAIR(superNull1, sub1NonNullExact, superNull1, sub1NonNullExact);
  CHECK_PAIR(superNull1, otherNull0, structNull2, noneNull);
  CHECK_PAIR(superNull1, otherNonNull0, structNull2, noneNonNull);
  CHECK_PAIR(superNull1, otherNullExact, structNull2, noneNull);
  CHECK_PAIR(superNull1, otherNonNullExact, structNull2, noneNonNull);

  CHECK_PAIR(superNonNull1, superNonNull1, superNonNull1, superNonNull1);
  CHECK_PAIR(superNonNull1, superNullExact, superNull1, superNonNullExact);
  CHECK_PAIR(
    superNonNull1, superNonNullExact, superNonNull1, superNonNullExact);
  CHECK_PAIR(superNonNull1, sub1Null0, superNull1, sub1NonNull0);
  CHECK_PAIR(superNonNull1, sub1NonNull0, superNonNull1, sub1NonNull0);
  CHECK_PAIR(superNonNull1, sub1NullExact, superNull1, sub1NonNullExact);
  CHECK_PAIR(superNonNull1, sub1NonNullExact, superNonNull1, sub1NonNullExact);
  CHECK_PAIR(superNonNull1, otherNull0, structNull2, noneNonNull);
  CHECK_PAIR(superNonNull1, otherNonNull0, structNonNull2, noneNonNull);
  CHECK_PAIR(superNonNull1, otherNullExact, structNull2, noneNonNull);
  CHECK_PAIR(superNonNull1, otherNonNullExact, structNonNull2, noneNonNull);

  CHECK_PAIR(superNullExact, superNullExact, superNullExact, superNullExact);
  CHECK_PAIR(
    superNullExact, superNonNullExact, superNullExact, superNonNullExact);
  CHECK_PAIR(superNullExact, sub1Null0, superNull1, noneNull);
  CHECK_PAIR(superNullExact, sub1NonNull0, superNull1, noneNonNull);
  CHECK_PAIR(superNullExact, sub1NullExact, superNull1, noneNull);
  CHECK_PAIR(superNullExact, sub1NonNullExact, superNull1, noneNonNull);
  CHECK_PAIR(superNullExact, otherNull0, structNull1, noneNull);
  CHECK_PAIR(superNullExact, otherNonNull0, structNull1, noneNonNull);
  CHECK_PAIR(superNullExact, otherNullExact, structNull1, noneNull);
  CHECK_PAIR(superNullExact, otherNonNullExact, structNull1, noneNonNull);

  CHECK_PAIR(
    superNonNullExact, superNonNullExact, superNonNullExact, superNonNullExact);
  CHECK_PAIR(superNonNullExact, sub1Null0, superNull1, noneNonNull);
  CHECK_PAIR(superNonNullExact, sub1NonNull0, superNonNull1, noneNonNull);
  CHECK_PAIR(superNonNullExact, sub1NullExact, superNull1, noneNonNull);
  CHECK_PAIR(superNonNullExact, sub1NonNullExact, superNonNull1, noneNonNull);
  CHECK_PAIR(superNonNullExact, otherNull0, structNull1, noneNonNull);
  CHECK_PAIR(superNonNullExact, otherNonNull0, structNonNull1, noneNonNull);
  CHECK_PAIR(superNonNullExact, otherNullExact, structNull1, noneNonNull);
  CHECK_PAIR(superNonNullExact, otherNonNullExact, structNonNull1, noneNonNull);

  CHECK_PAIR(sub1Null0, sub1Null0, sub1Null0, sub1Null0);
  CHECK_PAIR(sub1Null0, sub1NonNull0, sub1Null0, sub1NonNull0);
  CHECK_PAIR(sub1Null0, sub1NullExact, sub1Null0, sub1NullExact);
  CHECK_PAIR(sub1Null0, sub1NonNullExact, sub1Null0, sub1NonNullExact);
  CHECK_PAIR(sub1Null0, sub2Null0, superNull1, noneNull);
  CHECK_PAIR(sub1Null0, sub2NonNull0, superNull1, noneNonNull);
  CHECK_PAIR(sub1Null0, sub2NullExact, superNull1, noneNull);
  CHECK_PAIR(sub1Null0, sub2NonNullExact, superNull1, noneNonNull);
  CHECK_PAIR(sub1Null0, otherNull0, structNull2, noneNull);
  CHECK_PAIR(sub1Null0, otherNonNull0, structNull2, noneNonNull);
  CHECK_PAIR(sub1Null0, otherNullExact, structNull2, noneNull);
  CHECK_PAIR(sub1Null0, otherNonNullExact, structNull2, noneNonNull);

  CHECK_PAIR(sub1NonNull0, sub1NonNull0, sub1NonNull0, sub1NonNull0);
  CHECK_PAIR(sub1NonNull0, sub1NullExact, sub1Null0, sub1NonNullExact);
  CHECK_PAIR(sub1NonNull0, sub1NonNullExact, sub1NonNull0, sub1NonNullExact);
  CHECK_PAIR(sub1NonNull0, sub2Null0, superNull1, noneNonNull);
  CHECK_PAIR(sub1NonNull0, sub2NonNull0, superNonNull1, noneNonNull);
  CHECK_PAIR(sub1NonNull0, sub2NullExact, superNull1, noneNonNull);
  CHECK_PAIR(sub1NonNull0, sub2NonNullExact, superNonNull1, noneNonNull);
  CHECK_PAIR(sub1NonNull0, otherNull0, structNull2, noneNonNull);
  CHECK_PAIR(sub1NonNull0, otherNonNull0, structNonNull2, noneNonNull);
  CHECK_PAIR(sub1NonNull0, otherNullExact, structNull2, noneNonNull);
  CHECK_PAIR(sub1NonNull0, otherNonNullExact, structNonNull2, noneNonNull);

  CHECK_PAIR(sub1NullExact, sub1NullExact, sub1NullExact, sub1NullExact);
  CHECK_PAIR(sub1NullExact, sub1NonNullExact, sub1NullExact, sub1NonNullExact);
  CHECK_PAIR(sub1NullExact, sub2Null0, superNull1, noneNull);
  CHECK_PAIR(sub1NullExact, sub2NonNull0, superNull1, noneNonNull);
  CHECK_PAIR(sub1NullExact, sub2NullExact, superNull1, noneNull);
  CHECK_PAIR(sub1NullExact, sub2NonNullExact, superNull1, noneNonNull);
  CHECK_PAIR(sub1NullExact, otherNull0, structNull2, noneNull);
  CHECK_PAIR(sub1NullExact, otherNonNull0, structNull2, noneNonNull);
  CHECK_PAIR(sub1NullExact, otherNullExact, structNull2, noneNull);
  CHECK_PAIR(sub1NullExact, otherNonNullExact, structNull2, noneNonNull);

  CHECK_PAIR(
    sub1NonNullExact, sub1NonNullExact, sub1NonNullExact, sub1NonNullExact);
  CHECK_PAIR(sub1NonNullExact, sub2Null0, superNull1, noneNonNull);
  CHECK_PAIR(sub1NonNullExact, sub2NonNull0, superNonNull1, noneNonNull);
  CHECK_PAIR(sub1NonNullExact, sub2NullExact, superNull1, noneNonNull);
  CHECK_PAIR(sub1NonNullExact, sub2NonNullExact, superNonNull1, noneNonNull);
  CHECK_PAIR(sub1NonNullExact, otherNull0, structNull2, noneNonNull);
  CHECK_PAIR(sub1NonNullExact, otherNonNull0, structNonNull2, noneNonNull);
  CHECK_PAIR(sub1NonNullExact, otherNullExact, structNull2, noneNonNull);
  CHECK_PAIR(sub1NonNullExact, otherNonNullExact, structNonNull2, noneNonNull);
}

TEST_F(ConeTypeLatticeTest, Depths) {
  TypeBuilder builder(3);
  builder[0].setOpen() = Struct{};
  builder[1].setOpen().subTypeOf(builder[0]) = Struct{};
  builder[2].setOpen().subTypeOf(builder[1]) = Struct{};
  auto built = builder.build();

  HeapType a = (*built)[0];
  HeapType b = (*built)[1];
  HeapType c = (*built)[2];

  Element none{Type(HeapType::none, Nullable), 0};

  Element a0{Type(a, Nullable), 0};
  Element a1{Type(a, Nullable), 1};
  Element a2{Type(a, Nullable), 2};
  Element a3{Type(a, Nullable), 3};

  Element b0{Type(b, Nullable), 0};
  Element b1{Type(b, Nullable), 1};
  Element b2{Type(b, Nullable), 2};

  Element c0{Type(c, Nullable), 0};
  Element c1{Type(c, Nullable), 1};

  CHECK_PAIR(a0, a0, a0, a0);
  CHECK_PAIR(a0, a1, a1, a0);
  CHECK_PAIR(a0, b0, a1, none);
  CHECK_PAIR(a0, b1, a2, none);
  CHECK_PAIR(a0, c0, a2, none);
  CHECK_PAIR(a0, c1, a3, none);

  CHECK_PAIR(a1, a1, a1, a1);
  CHECK_PAIR(a1, b0, a1, b0);
  CHECK_PAIR(a1, b1, a2, b0);
  CHECK_PAIR(a1, c0, a2, none);
  CHECK_PAIR(a1, c1, a3, none);

  CHECK_PAIR(b0, b0, b0, b0);
  CHECK_PAIR(b0, b1, b1, b0);
  CHECK_PAIR(b0, c0, b1, none);
  CHECK_PAIR(b0, c1, b2, none);

  CHECK_PAIR(b1, b1, b1, b1);
  CHECK_PAIR(b1, c0, b1, c0);
  CHECK_PAIR(b1, c1, b2, c0);
}
