#include <limits>

#include "ir/constraint.h"
#include "ir/abstract.h"
#include "gtest/gtest.h"

using namespace wasm;
using namespace wasm::Abstract;
using namespace wasm::constraint;

TEST(ConstraintTest, TestEq) {
  // x == 5 (we use "x" for the name of the thing being compared, in these
  // comments).
  Constraint c{Eq, {Literal(int32_t(5))}};

  // Sets start as proving anything, as representing unreachable code.
  AndedConstraintSet s;
  EXPECT_TRUE(s.provesEverything());
  EXPECT_EQ(s.proves(c), True);

  // We can't infer anything if told so.
  s.setProvesNothing();
  EXPECT_EQ(s.proves(c), Unknown);

  // If we add it, then things check out: a thing always proves itself true.
  s.approximateAnd(c);
  EXPECT_EQ(s.size(), 1);
  EXPECT_EQ(s.proves(c), True);

  // Ditto using set();
  s.set(c);
  EXPECT_EQ(s.proves(c), True);

  // x == 10, a different number: we can infer false.
  EXPECT_EQ(s.proves(Constraint{Eq, {Literal(int32_t(10))}}), False);

  // x != 15: we can infer true.
  EXPECT_EQ(s.proves(Constraint{Ne, {Literal(int32_t(15))}}), True);

  // x != 5: we can infer false.
  EXPECT_EQ(s.proves(Constraint{Ne, {Literal(int32_t(5))}}), False);

  // x > y: we can infer nothing.
  EXPECT_EQ(s.proves(Constraint{GtS, {Index(1)}}), Unknown);
}

TEST(ConstraintTest, TestNe) {
  AndedConstraintSet s;
  // x != 5
  Constraint c{Ne, {Literal(int32_t(5))}};
  s.set(c);

  // Checks out versus itself.
  EXPECT_EQ(s.proves(c), True);

  // x == 10: we don't know.
  EXPECT_EQ(s.proves(Constraint{Eq, {Literal(int32_t(10))}}), Unknown);

  // x != 15: we don't know.
  EXPECT_EQ(s.proves(Constraint{Ne, {Literal(int32_t(15))}}), Unknown);

  // x == 5: we can infer false.
  EXPECT_EQ(s.proves(Constraint{Eq, {Literal(int32_t(5))}}), False);
}

TEST(ConstraintTest, TestMulti) {
  AndedConstraintSet s;
  // x != 5 && x != 10
  Constraint c{Ne, {Literal(int32_t(5))}};
  Constraint d{Ne, {Literal(int32_t(10))}};
  s.set(c);
  s.approximateAnd(d);

  // Each checks out versus itself.
  EXPECT_EQ(s.proves(c), True);
  EXPECT_EQ(s.proves(d), True);

  // x == 5: false.
  EXPECT_EQ(s.proves(Constraint{Eq, {Literal(int32_t(5))}}), False);

  // x == 10: false.
  EXPECT_EQ(s.proves(Constraint{Eq, {Literal(int32_t(10))}}), False);

  // x == 15: we don't know.
  EXPECT_EQ(s.proves(Constraint{Eq, {Literal(int32_t(15))}}), Unknown);

  // x != 15: we don't know.
  EXPECT_EQ(s.proves(Constraint{Ne, {Literal(int32_t(15))}}), Unknown);
}

TEST(ConstraintTest, TestSets) {
  // x == 5
  Constraint c{Eq, {Literal(int32_t(5))}};

  AndedConstraintSet s;

  // Any set always proves itself to be true.
  EXPECT_EQ(s.proves(s), True);

  // Ditto after adding something.
  s.set(c);
  EXPECT_EQ(s.proves(s), True);

  // Another set, empty.
  AndedConstraintSet t;

  // Make both sets contain the same stuff.
  t.set(c);
  EXPECT_EQ(s.proves(t), True);

  // Now t has *different* stuff, x == 10, which given s is false.
  t.set(Constraint{Eq, {Literal(int32_t(10))}});
  EXPECT_EQ(s.proves(t), False);

  // Same, with x != 10. Now we know it is true.
  t.set(Constraint{Ne, {Literal(int32_t(10))}});
  EXPECT_EQ(s.proves(t), True);

  // In reverse, we can infer nothing: knowing x != 10 does not say if x == 5.
  EXPECT_EQ(t.proves(s), Unknown);
}

TEST(ConstraintTest, TestSetsUnknown) {
  // x != 5
  // x != 10
  AndedConstraintSet s;
  s.set(Constraint{Ne, {Literal(int32_t(5))}});
  s.approximateAnd(Constraint{Ne, {Literal(int32_t(10))}});

  // x != 20, which is unknown by s.
  AndedConstraintSet t;
  t.set(Constraint{Ne, {Literal(int32_t(20))}});
  EXPECT_EQ(s.proves(t), Unknown);

  // Add x == 10, which is false by s, and so the whole thing is false.
  t.set(Constraint{Eq, {Literal(int32_t(10))}});
  EXPECT_EQ(s.proves(t), False);
}

TEST(ConstraintTest, TestOrTrivial) {
  // { x == 5 }
  AndedConstraintSet s;
  s.set(Constraint{Eq, {Literal(int32_t(5))}});

  // { }
  AndedConstraintSet empty;
  empty.setProvesNothing();

  // Anything ORed with the empty set becomes the empty set: if one side can
  // prove nothing, neither can the result.
  auto t = s;
  t.approximateOr(empty);
  EXPECT_EQ(t, empty);

  // Flipped.
  t = empty;
  t.approximateOr(s);
  EXPECT_EQ(t, empty);

  // ORing with oneself changes nothing
  t = s;
  t.approximateOr(s);
  EXPECT_EQ(t, s);
}

TEST(ConstraintTest, TestOrImplies) {
  // { x == 5 }
  AndedConstraintSet s;
  s.set(Constraint{Eq, {Literal(int32_t(5))}});

  // { x != 10 }
  AndedConstraintSet t;
  t.set(Constraint{Ne, {Literal(int32_t(10))}});

  // ORing these leaves us with x != 10.
  auto u = s;
  u.approximateOr(t);
  EXPECT_EQ(u, t);

  // Flipped.
  u = t;
  u.approximateOr(s);
  EXPECT_EQ(u, t);
}

TEST(ConstraintTest, TestMaxCapacity) {
  EXPECT_EQ(MaxConstraints, 3);

  // Max out with x != 10, 20, 30
  Constraint not10{Ne, {Literal(int32_t(10))}};
  Constraint not20{Ne, {Literal(int32_t(20))}};
  Constraint not30{Ne, {Literal(int32_t(30))}};

  AndedConstraintSet s;
  s.set(not10);
  s.approximateAnd(not20);
  s.approximateAnd(not30);

  // We can prove all those.
  EXPECT_EQ(s.proves(not10), True);
  EXPECT_EQ(s.proves(not20), True);
  EXPECT_EQ(s.proves(not30), True);

  // Add another, exceeding the capacity.
  Constraint not40{Ne, {Literal(int32_t(40))}};
  s.approximateAnd(not40);

  // We can prove the old ones but not the new.
  EXPECT_EQ(s.proves(not10), True);
  EXPECT_EQ(s.proves(not20), True);
  EXPECT_EQ(s.proves(not30), True);
  EXPECT_EQ(s.proves(not40), Unknown);
}

TEST(ConstraintTest, TestDeduplication) {
  Constraint eq10{Eq, {Literal(int32_t(10))}};

  AndedConstraintSet s;
  EXPECT_EQ(s.size(), 0);
  s.set(eq10);
  EXPECT_EQ(s.size(), 1);
  // The size does not increase when we add eq10 again.
  s.approximateAnd(eq10);
  EXPECT_EQ(s.size(), 1);
}

TEST(ConstraintTest, TestDeredundancy) {
  Constraint eq0{Eq, {Literal(int32_t(0))}};
  Constraint ne1{Ne, {Literal(int32_t(1))}};

  // If x == 0, then x != 1 is redundant, and does not need to be added, is it
  // is implied by x == 0.
  AndedConstraintSet s;
  s.set(eq0);
  s.approximateAnd(ne1);
  EXPECT_EQ(s.size(), 1);
  EXPECT_EQ(s[0], eq0);

  // Reverse order, same result, even though we added x == 0 last: we remove
  // x != 1.
  AndedConstraintSet t;
  t.set(ne1);
  t.approximateAnd(eq0);
  EXPECT_EQ(t.size(), 1);
  EXPECT_EQ(t[0], eq0);
}

static void checkOr(const AndedConstraintSet& a,
                    const AndedConstraintSet& b,
                    const AndedConstraintSet& result) {
  auto ored = a;
  ored.approximateOr(b);
  EXPECT_EQ(ored, result);

  ored = b;
  ored.approximateOr(a);
  EXPECT_EQ(ored, result);
}

TEST(ConstraintTest, TestOrInequality) {
  // x == 5 || x >= 0  =>  x >= 0
  AndedConstraintSet eq5{{Eq, {Literal(int32_t(5))}}};
  AndedConstraintSet ge0{{GeU, {Literal(int32_t(0))}}};
  checkOr(eq5, ge0, ge0);

  // x == 5 || x > 5  =>  x >= 5
  AndedConstraintSet gts5{{GtS, {Literal(int32_t(5))}}};
  AndedConstraintSet ges5{{GeS, {Literal(int32_t(5))}}};
  checkOr(eq5, gts5, ges5);

  // x == 5 || x >= 5  =>  x >= 5
  checkOr(eq5, ges5, ges5);

  // x == 5 || x >= 6  =>  x >= 5
  AndedConstraintSet ges6{{GeS, {Literal(int32_t(6))}}};
  checkOr(eq5, ges6, ges5);

  // TODO: x == 5 || x >= 7  =>  x >= 5  TODO
  AndedConstraintSet ges7{{GeS, {Literal(int32_t(7))}}};
  auto empty = AndedConstraintSet::makeProvesNothing();
  checkOr(eq5, ges7, empty);

  // x > 5 and x >= 6 are equivalent, so ORing them does not change either.
  auto ored1 = gts5;
  ored1.approximateOr(ges6);
  EXPECT_EQ(ored1, gts5);

  auto ored2 = ges6;
  ored2.approximateOr(gts5);
  EXPECT_EQ(ored2, ges6);

  // x > 5 || x >= 5  =>  x >= 5
  checkOr(gts5, ges5, ges5);

  // Careful of overflow:
  // x == signed_max || x >= (signed_max + 1 === signed_min) != x >= signed_max
  AndedConstraintSet eqMax{
    {Eq, {Literal(std::numeric_limits<int32_t>::max())}}};
  AndedConstraintSet gesMin{
    {GeS, {Literal(std::numeric_limits<int32_t>::min())}}};
  // TODO: x >= signed_min is always true, so this could be empty
  checkOr(eqMax, gesMin, gesMin);

  // Careful of overflow:
  // x > signed_max || x >= (signed_max + 1 === signed_min) != x > signed_max
  AndedConstraintSet gtsMax{
    {GtS, {Literal(std::numeric_limits<int32_t>::max())}}};
  // x > signed_max is impossible, so it vanishes in the OR.
  checkOr(gtsMax, gesMin, gesMin);
}

TEST(ConstraintTest, TestOrLoop) {
  // Check common loop patterns at the loop top (merging an initial value with
  // an incremented and bounded one):
  // { x == A } || { x > A && x <= B }   ==>   { x >= A && x <= B }

  // { x == 5 } || { x > 5 && x <= 42 }   ==>   { x >= 5 && x <= 42 }
  AndedConstraintSet left{{Eq, {Literal(int32_t(5))}}};
  AndedConstraintSet right(
    {{GtS, {Literal(int32_t(5))}}, {LeS, {Literal(int32_t(42))}}});
  AndedConstraintSet result(
    {{GeS, {Literal(int32_t(5))}}, {LeS, {Literal(int32_t(42))}}});
  checkOr(left, right, result);

  // Changes to constants:

  // Change 5 on the left to 7:
  // { x == 7 } || { x > 5 && x <= 42 }   ==>   { x > 5 && x <= 42}
  AndedConstraintSet left7{{Eq, {Literal(int32_t(7))}}};
  checkOr(left7, right, right);

  // Change 5 on the left to 99:
  // { x == 99 } || { x > 5 && x <= 42 }   ==>   { x > 5 }
  // TODO: we could emit a range (5, 99]
  AndedConstraintSet left99{{Eq, {Literal(int32_t(99))}}};
  AndedConstraintSet rightOnly5{{GtS, {Literal(int32_t(5))}}};
  checkOr(left99, right, rightOnly5);

  // Change 5 on the left to 4:
  // { x == 4 } || { x > 5 && x <= 42 }   ==>   { x <= 42 }
  // TODO: we could emit a range [4, 42]
  AndedConstraintSet left4{{Eq, {Literal(int32_t(4))}}};
  AndedConstraintSet rightOnly42({{LeS, {Literal(int32_t(42))}}});
  checkOr(left4, right, rightOnly42);

  // Change 5 on the right to 6:
  // { x == 5 } || { x > 6 && x <= 42 }   ==>   { x <= 42 }
  AndedConstraintSet right6(
    {{GtS, {Literal(int32_t(6))}}, {LeS, {Literal(int32_t(42))}}});
  checkOr(left, right6, rightOnly42);

  // Changes to operations:

  // Change the Eq on the left to Ne. We fail to find anything for the OR.
  // { x != 5 } || { x > 5 && x <= 42 }   ==>   {}
  // TODO: we could emit x != 5
  AndedConstraintSet leftNe{{Ne, {Literal(int32_t(5))}}};
  auto empty = AndedConstraintSet::makeProvesNothing();
  checkOr(leftNe, right, empty);

  // Change the GtS on the right to GtU:
  // { x == 5 } || { x >U 5 && x <= 42 }   ==>   { x >=U 5 && x <= 42 }
  AndedConstraintSet rightGtU(
    {{GtU, {Literal(int32_t(5))}}, {LeS, {Literal(int32_t(42))}}});
  AndedConstraintSet resultMixed(
    {{GeU, {Literal(int32_t(5))}}, {LeS, {Literal(int32_t(42))}}});
  checkOr(left, rightGtU, resultMixed);

  // Change the LeS on the right to LeU:
  // { x == 5 } || { x > 5 && x <=U 42 }   ==>   { x >= 5 && x <=U 42 }
  AndedConstraintSet rightLeU(
    {{GtS, {Literal(int32_t(5))}}, {LeU, {Literal(int32_t(42))}}});
  AndedConstraintSet rightGesLeU(
    {{GeS, {Literal(int32_t(5))}}, {LeU, {Literal(int32_t(42))}}});
  checkOr(left, rightLeU, rightGesLeU);

  // Add an operation on the right, x != 21:
  // { x == 5 } || { x >  5 && x <= 42 && x != 21 }   ==>
  //               { x >= 5 && x <= 42 && x != 21 }
  AndedConstraintSet rightAdded({{GtS, {Literal(int32_t(5))}},
                                 {LeS, {Literal(int32_t(42))}},
                                 {Ne, {Literal(int32_t(21))}}});
  AndedConstraintSet resultAdded({{GeS, {Literal(int32_t(5))}},
                                  {LeS, {Literal(int32_t(42))}},
                                  {Ne, {Literal(int32_t(21))}}});
  checkOr(left, rightAdded, resultAdded);
}

TEST(ConstraintTest, TestOrLoopUnsigned) {
  // As above, but unsigned.

  // { x == 5 } || { x > 5 && x <= 42 }   ==>   { x >= 5 && x <= 42 }
  AndedConstraintSet left{{Eq, {Literal(int32_t(5))}}};
  AndedConstraintSet right(
    {{GtU, {Literal(int32_t(5))}}, {LeU, {Literal(int32_t(42))}}});
  AndedConstraintSet result(
    {{GeU, {Literal(int32_t(5))}}, {LeU, {Literal(int32_t(42))}}});
  checkOr(left, right, result);

  // Changes to constants:

  // Change 5 on the left to 7:
  // { x == 7 } || { x > 5 && x <= 42 }   ==>   { x > 5 && x <= 42}
  AndedConstraintSet left7{{Eq, {Literal(int32_t(7))}}};
  checkOr(left7, right, right);

  // Change 5 on the left to 99:
  // { x == 99 } || { x > 5 && x <= 42 }   ==>   { x > 5 }
  // TODO: we could emit a range (5, 99]
  AndedConstraintSet left99{{Eq, {Literal(int32_t(99))}}};
  AndedConstraintSet rightOnly5{{GtU, {Literal(int32_t(5))}}};
  checkOr(left99, right, rightOnly5);

  // Change 5 on the left to 4:
  // { x == 4 } || { x > 5 && x <= 42 }   ==>   { x <= 42 }
  // TODO: we could emit a range [4, 42]
  AndedConstraintSet left4{{Eq, {Literal(int32_t(4))}}};
  AndedConstraintSet rightOnly42({{LeU, {Literal(int32_t(42))}}});
  checkOr(left4, right, rightOnly42);

  // Change 5 on the right to 6:
  // { x == 5 } || { x > 6 && x <= 42 }   ==>   { x <= 42 }
  AndedConstraintSet right6(
    {{GtU, {Literal(int32_t(6))}}, {LeU, {Literal(int32_t(42))}}});
  checkOr(left, right6, rightOnly42);

  // Changes to operations:

  // Change the Eq on the left to Ne. We fail to find anything for the OR.
  // { x != 5 } || { x > 5 && x <= 42 }   ==>   {}
  // TODO: we could emit x != 5
  AndedConstraintSet leftNe{{Ne, {Literal(int32_t(5))}}};
  auto empty = AndedConstraintSet::makeProvesNothing();
  checkOr(leftNe, right, empty);

  // Add an operation on the right, x != 21:
  // { x == 5 } || { x >  5 && x <= 42 && x != 21 }   ==>
  //               { x >= 5 && x <= 42 && x != 21 }
  AndedConstraintSet rightAdded({{GtU, {Literal(int32_t(5))}},
                                 {LeU, {Literal(int32_t(42))}},
                                 {Ne, {Literal(int32_t(21))}}});
  AndedConstraintSet resultAdded({{GeU, {Literal(int32_t(5))}},
                                  {LeU, {Literal(int32_t(42))}},
                                  {Ne, {Literal(int32_t(21))}}});
  checkOr(left, rightAdded, resultAdded);
}

static void checkAnd(const AndedConstraintSet& a,
                     const AndedConstraintSet& b,
                     const AndedConstraintSet& result) {
  auto anded = a;
  for (auto& bc : b) {
    anded.approximateAnd(bc);
  }
  EXPECT_EQ(anded, result);

  anded = b;
  for (auto& ac : a) {
    anded.approximateAnd(ac);
  }
  EXPECT_EQ(anded, result);
}

TEST(ConstraintTest, TestAndInequality) {
  // x == 5 && x >= 0  =>  x == 5
  AndedConstraintSet eq5{{Eq, {Literal(int32_t(5))}}};
  AndedConstraintSet ge0{{GeS, {Literal(int32_t(0))}}};
  checkAnd(eq5, ge0, eq5);

  // x == 5 && x >= 5  =>  x == 5
  AndedConstraintSet ge5{{GeS, {Literal(int32_t(5))}}};
  checkAnd(eq5, ge5, eq5);

  // x == 5 && x >= 6  =>  contradiction
  AndedConstraintSet ge6{{GeS, {Literal(int32_t(6))}}};
  AndedConstraintSet contradiction;
  checkAnd(eq5, ge6, contradiction);
}

TEST(ConstraintTest, TestAndLoop) {
  // Check common loop patterns after incrementing and bounds-checking:
  // x <= A && x < A  =>  x < A

  // x <= 5 && x < 5  =>  x < 5
  AndedConstraintSet le5{{LeS, {Literal(int32_t(5))}}};
  AndedConstraintSet lt5{{LtS, {Literal(int32_t(5))}}};
  checkAnd(le5, lt5, lt5);

  // Ditto, but unsigned.
  AndedConstraintSet le5U{{LeU, {Literal(int32_t(5))}}};
  AndedConstraintSet lt5U{{LtU, {Literal(int32_t(5))}}};
  checkAnd(le5U, lt5U, lt5U);

  // Mixing signed and unsigned does not optimize (so we just end up ANDing both
  // inputs).
  checkAnd(le5, lt5U, AndedConstraintSet{le5[0], lt5U[0]});

  // Different constants optimize when one implies the other (x <= 5 and x < 6
  // are equivalent).
  AndedConstraintSet lt6{{LtS, {Literal(int32_t(6))}}};
  auto anded1 = le5;
  anded1.approximateAnd(lt6[0]);
  EXPECT_EQ(anded1, le5);

  auto anded2 = lt6;
  anded2.approximateAnd(le5[0]);
  EXPECT_EQ(anded2, lt6);

  // A non-constant.
  // x <= y && x < y  =>  x < y
  AndedConstraintSet ley{{LeS, {Index(1)}}};
  AndedConstraintSet lty{{LtS, {Index(1)}}};
  checkAnd(ley, lty, lty);

  // A non-constant with extra info.
  // { x <= y && x != 42 } && x < y  =>  x < y && x != 42
  Constraint ne42{Ne, {Literal(int32_t(42))}};
  checkAnd({ley[0], ne42}, lty, {lty[0], ne42});

  // Extra info on the other side, same result.
  // x <= y && { x < y && x != 42 }  =>  x < y && x != 42
  checkAnd(ley, {lty[0], ne42}, {lty[0], ne42});
}

TEST(ConstraintTest, TestBasicBlockConstraintMap) {
  // Maps begin unreachable.
  BasicBlockConstraintMap map;

  EXPECT_TRUE(map.unreachable);
  map.setReachable();
  EXPECT_FALSE(map.unreachable);
}

// Check that a set is equal to a constraint.
static void check(const AndedConstraintSet& s, const Constraint& c) {
  EXPECT_EQ(s.size(), 1);
  EXPECT_EQ(s[0], c);
}

TEST(ConstraintTest, TestBasicBlockConstraintMap_Set) {
  Constraint eq0{Eq, {Literal(int32_t(0))}};
  Constraint eq1{Eq, {Literal(int32_t(1))}};
  Constraint eq2{Eq, {Literal(int32_t(2))}};

  BasicBlockConstraintMap map;
  map.setReachable();

  // Set local 0 to 0. It should read back the same.
  map.set(0, eq0);
  check(map.get(0), eq0);

  // Set another value, replacing the first.
  map.set(0, eq1);
  check(map.get(0), eq1);

  // Set a value using an expression.
  Const c;
  c.value = Literal(int32_t(2));
  c.type = Type::i32;
  map.set(0, &c);
  check(map.get(0), eq2);

  // Set an unfamiliar expression, leading to us knowing nothing.
  Nop nop;
  map.set(0, &nop);
  EXPECT_TRUE(map.get(0).provesNothing());
}

TEST(ConstraintTest, TestIncrement) {
  BasicBlockConstraintMap map;
  map.setReachable();

  // Set up an increment operation, an add which does $0 + 1
  LocalGet get;
  get.index = 0;
  get.type = Type::i32;

  Const c;
  c.value = Literal(int32_t(1));
  c.type = Type::i32;

  Binary add;
  add.op = AddInt32;
  add.type = Type::i32;
  add.left = &get;
  add.right = &c;

  // $0 = 0, $1 = $0 + 1, so $1 = 1 (and $0 is unchanged).
  map.set(0, {Eq, {Literal(int32_t(0))}});
  map.set(1, &add);
  check(map.get(0), {Eq, {Literal(int32_t(0))}});
  check(map.get(1), {Eq, {Literal(int32_t(1))}});

  // $0 = $0 + 1, where $0 was 0, so it is now 1.
  map.set(0, &add);
  check(map.get(0), {Eq, {Literal(int32_t(1))}});

  // $0 >= 5, $0++  =>  nothing, since the ++ might overflow into negative
  map.set(0, {GeS, {Literal(int32_t(5))}});
  map.set(0, &add);
  EXPECT_TRUE(map.get(0).empty());

  // $0 >= 5, $0 < 100, $0++  =>  $0 > 5, $0 <= 100 (signed)
  Constraint lts100{LtS, {Literal(int32_t(100))}};
  Constraint les100{LeS, {Literal(int32_t(100))}};
  map.set(0, {{GeS, {Literal(int32_t(5))}}, lts100});
  map.set(0, &add);
  EXPECT_EQ(map.get(0),
            (AndedConstraintSet{{GtS, {Literal(int32_t(5))}}, les100}));

  // Ditto, unsigned: without an upper bound we can overflow.
  map.set(0, {GeU, {Literal(int32_t(5))}});
  map.set(0, &add);
  EXPECT_TRUE(map.get(0).empty());

  // With an upper bound, we can optimize like before.
  Constraint ltu100{LtU, {Literal(int32_t(100))}};
  Constraint leu100{LeU, {Literal(int32_t(100))}};
  map.set(0, {{GeU, {Literal(int32_t(5))}}, ltu100});
  map.set(0, &add);
  EXPECT_EQ(map.get(0),
            (AndedConstraintSet{{GtU, {Literal(int32_t(5))}}, leu100}));

  // $0 < 5, $0++  =>  $0 <= 5 (signed)
  map.set(0, {LtS, {Literal(int32_t(5))}});
  map.set(0, &add);
  check(map.get(0), {LeS, {Literal(int32_t(5))}});

  // Ditto, unsigned. We also add a lower bound here, as after $0++, $0 > 0
  // (due to no overflow, proven by the upper bound).
  Constraint gtu0{GtU, {Literal(int32_t(0))}};
  map.set(0, {LtU, {Literal(int32_t(5))}});
  map.set(0, &add);
  EXPECT_EQ(map.get(0),
            (AndedConstraintSet{{LeU, {Literal(int32_t(5))}}, gtu0}));

  // $0 <= 5, $0++  =>  $0 <= 6 (signed)
  map.set(0, {LeS, {Literal(int32_t(5))}});
  map.set(0, &add);
  check(map.get(0), {LeS, {Literal(int32_t(6))}});

  // Ditto, unsigned
  map.set(0, {LeU, {Literal(int32_t(5))}});
  map.set(0, &add);
  EXPECT_EQ(map.get(0),
            (AndedConstraintSet{{LeU, {Literal(int32_t(6))}}, gtu0}));

  // $0 <= max_signed, $0++  =>  nothing, because it would overflow
  map.set(0, {LeS, {Literal::makeSignedMax(Type::i32)}});
  map.set(0, &add);
  EXPECT_TRUE(map.get(0).provesNothing());

  // $0 <= max_unsigned, $0++  =>  nothing, because it would overflow
  map.set(0, {LeU, {Literal::makeUnsignedMax(Type::i32)}});
  map.set(0, &add);
  EXPECT_TRUE(map.get(0).provesNothing());

  // However, an unsigned operation on the signed max is fine.
  map.set(0, {LeU, {Literal::makeSignedMax(Type::i32)}});
  map.set(0, &add);
  auto one = Literal::makeFromInt32(1, Type::i32);
  EXPECT_EQ(map.get(0),
            (AndedConstraintSet{
              {LeU, {Literal::makeSignedMax(Type::i32).add(one)}}, gtu0}));

  // Multiple constraints at once:
  // $0 >= 10 && $0 < 20, $0++  =>  $0 > 10 && $0 <= 20
  map.set(0, {GeS, {Literal(int32_t(10))}});
  map.approximateAnd(0, {LtS, {Literal(int32_t(20))}});
  map.set(0, &add);
  EXPECT_EQ(map.get(0),
            (AndedConstraintSet{{GtS, {Literal(int32_t(10))}},
                                {LeS, {Literal(int32_t(20))}}}));

  // $0 >= 10 && $0 <= max_signed, $0++  =>  nothing, as we may overflow.
  map.set(0, {GeS, {Literal(int32_t(10))}});
  map.approximateAnd(0, {LeS, {Literal::makeSignedMax(Type::i32)}});
  map.set(0, &add);
  EXPECT_EQ(map.get(0).size(), 0);

  // Ditto, unsigned.
  map.set(0, {GeU, {Literal(int32_t(10))}});
  map.approximateAnd(0, {LeU, {Literal::makeUnsignedMax(Type::i32)}});
  map.set(0, &add);
  EXPECT_EQ(map.get(0).size(), 0);

  // Ditto, 64-bit signed.
  map.set(0, {GeS, {Literal(int64_t(10))}});
  map.approximateAnd(0, {LeS, {Literal::makeSignedMax(Type::i64)}});
  map.set(0, &add);
  EXPECT_EQ(map.get(0).size(), 0);

  // Ditto, 64-bit unsigned.
  map.set(0, {GeU, {Literal(int64_t(10))}});
  map.approximateAnd(0, {LeU, {Literal::makeUnsignedMax(Type::i64)}});
  map.set(0, &add);
  EXPECT_EQ(map.get(0).size(), 0);

  // $0 >= 5 && $0 < 100 && $0 == $2, $0++  =>  we increment and remove the non-
  // constant term, leaving $0 > 5 && $0 <= 100.
  map.set(0, {{GeS, {Literal(int32_t(5))}}, lts100});
  map.approximateAnd(0, {Eq, {Index(2)}});
  map.set(0, &add);
  EXPECT_EQ(map.get(0),
            (AndedConstraintSet{{GtS, {Literal(int32_t(5))}}, les100}));
}

TEST(ConstraintTest, TestEqConstraints) {
  BasicBlockConstraintMap map;
  map.setReachable();

  // $0 == 42
  map.set(0, {Eq, {Literal(int32_t(42))}});

  // $0 < $1
  map.approximateAnd(0, {LtS, {Index(int32_t(1))}});

  // $1 has $1 > 42: we constant-propagated the value of $0. This is better than
  // having $1 > $0 and needing to look $0 up.
  check(map.get(1), {GtS, {Literal(int32_t(42))}});
}

TEST(ConstraintTest, ComplexOrRegression) {
  // $0 == 0
  BasicBlockConstraintMap left;
  left.setReachable();
  left.set(0, {Eq, {Literal(int32_t(0))}});

  // $0 <= 100, $0 > $1
  BasicBlockConstraintMap right;
  right.setReachable();
  right.set(0, {{LeS, {Literal(int32_t(100))}}, {GtS, {Index(1)}}});

  // $0 == 0 || $0 <= 100  =>  $0 <= 100  (0 is included in <= 100), but the
  // other constraint, $0 > $1, was only on one side, and vanishes.
  right.approximateOr(left);
  check(right.get(0), {LeS, {Literal(int32_t(100))}});
  EXPECT_TRUE(right.get(1).empty());
}

TEST(ConstraintTest, GetSpan) {
  const IU64 minI32(std::numeric_limits<int32_t>::min());
  const IU64 maxI32(std::numeric_limits<int32_t>::max());
  const IU64 maxU32(std::numeric_limits<uint32_t>::max());
  const IU64 minI64(std::numeric_limits<int64_t>::min());
  const IU64 maxI64(std::numeric_limits<int64_t>::max());
  const IU64 maxU64(std::numeric_limits<uint64_t>::max());

  // Non-literal terms have no constant span.
  EXPECT_EQ((Constraint{Eq, {Index(0)}}.getSpan()), std::nullopt);
  EXPECT_EQ((Constraint{LtS, {Index(1)}}.getSpan()), std::nullopt);
  EXPECT_EQ((Constraint{GeU, {Index(2)}}.getSpan()), std::nullopt);

  // Unsupported operations (e.g. Ne) have no constant span.
  EXPECT_EQ((Constraint{Ne, {Literal(int32_t(5))}}.getSpan()), std::nullopt);
  EXPECT_EQ((Constraint{Ne, {Literal(int32_t(0))}}.getSpan()), std::nullopt);

  // Eq (i32): non-negative values up to int32_t max have an unambiguous span.
  EXPECT_EQ((Constraint{Eq, {Literal(int32_t(0))}}.getSpan()),
            (Span<IU64>{0, 0}));
  EXPECT_EQ((Constraint{Eq, {Literal(int32_t(1))}}.getSpan()),
            (Span<IU64>{1, 1}));
  EXPECT_EQ((Constraint{Eq, {Literal(int32_t(42))}}.getSpan()),
            (Span<IU64>{42, 42}));
  EXPECT_EQ(
    (Constraint{Eq, {Literal(std::numeric_limits<int32_t>::max())}}.getSpan()),
    (Span<IU64>{maxI32, maxI32}));

  // Eq (i32) with negative or large unsigned values returns nullopt due to
  // signed/unsigned ambiguity.
  EXPECT_EQ((Constraint{Eq, {Literal(int32_t(-1))}}.getSpan()), std::nullopt);
  EXPECT_EQ((Constraint{Eq, {Literal(int32_t(-42))}}.getSpan()), std::nullopt);
  EXPECT_EQ(
    (Constraint{Eq, {Literal(std::numeric_limits<int32_t>::min())}}.getSpan()),
    std::nullopt);
  EXPECT_EQ((Constraint{Eq, {Literal(uint32_t(0x80000000u))}}.getSpan()),
            std::nullopt);
  EXPECT_EQ(
    (Constraint{Eq, {Literal(std::numeric_limits<uint32_t>::max())}}.getSpan()),
    std::nullopt);

  // Eq (i64): non-negative values up to int64_t max have an unambiguous span.
  EXPECT_EQ((Constraint{Eq, {Literal(int64_t(0))}}.getSpan()),
            (Span<IU64>{0, 0}));
  EXPECT_EQ((Constraint{Eq, {Literal(int64_t(42))}}.getSpan()),
            (Span<IU64>{42, 42}));
  EXPECT_EQ(
    (Constraint{Eq, {Literal(int64_t(std::numeric_limits<int32_t>::max()) + 1)}}
       .getSpan()),
    (Span<IU64>{uint64_t(std::numeric_limits<int32_t>::max()) + 1,
                uint64_t(std::numeric_limits<int32_t>::max()) + 1}));
  EXPECT_EQ(
    (Constraint{Eq, {Literal(std::numeric_limits<int64_t>::max())}}.getSpan()),
    (Span<IU64>{maxI64, maxI64}));

  // Eq (i64) with negative or large unsigned values returns nullopt.
  EXPECT_EQ((Constraint{Eq, {Literal(int64_t(-1))}}.getSpan()), std::nullopt);
  EXPECT_EQ(
    (Constraint{Eq, {Literal(std::numeric_limits<int64_t>::min())}}.getSpan()),
    std::nullopt);
  EXPECT_EQ((Constraint{Eq, {Literal(uint64_t(uint64_t(1) << 63))}}.getSpan()),
            std::nullopt);
  EXPECT_EQ(
    (Constraint{Eq, {Literal(std::numeric_limits<uint64_t>::max())}}.getSpan()),
    std::nullopt);

  // LtS (i32): [minI32, C - 1]
  EXPECT_EQ((Constraint{LtS, {Literal(int32_t(10))}}.getSpan()),
            (Span<IU64>{minI32, IU64(9)}));
  EXPECT_EQ((Constraint{LtS, {Literal(int32_t(0))}}.getSpan()),
            (Span<IU64>{minI32, IU64(-1)}));
  EXPECT_EQ((Constraint{LtS, {Literal(int32_t(-5))}}.getSpan()),
            (Span<IU64>{minI32, IU64(-6)}));
  EXPECT_EQ(
    (Constraint{LtS, {Literal(std::numeric_limits<int32_t>::max())}}.getSpan()),
    (Span<IU64>{minI32, IU64(std::numeric_limits<int32_t>::max() - 1)}));
  // LtS min signed (i32): empty span
  auto ltsMin32 =
    Constraint{LtS, {Literal(std::numeric_limits<int32_t>::min())}}.getSpan();
  ASSERT_TRUE(ltsMin32.has_value());
  EXPECT_TRUE(ltsMin32->isEmpty());
  EXPECT_EQ(ltsMin32, Span<IU64>::empty());

  // LtS (i64): [minI64, C - 1]
  EXPECT_EQ((Constraint{LtS, {Literal(int64_t(100))}}.getSpan()),
            (Span<IU64>{minI64, IU64(99)}));
  EXPECT_EQ((Constraint{LtS, {Literal(int64_t(0))}}.getSpan()),
            (Span<IU64>{minI64, IU64(-1)}));
  EXPECT_EQ(
    (Constraint{LtS, {Literal(std::numeric_limits<int64_t>::max())}}.getSpan()),
    (Span<IU64>{minI64, IU64(std::numeric_limits<int64_t>::max() - 1)}));
  // LtS min signed (i64): empty span
  auto ltsMin64 =
    Constraint{LtS, {Literal(std::numeric_limits<int64_t>::min())}}.getSpan();
  ASSERT_TRUE(ltsMin64.has_value());
  EXPECT_TRUE(ltsMin64->isEmpty());
  EXPECT_EQ(ltsMin64, Span<IU64>::empty());

  // LtU (i32): [0, C - 1]
  EXPECT_EQ((Constraint{LtU, {Literal(uint32_t(10))}}.getSpan()),
            (Span<IU64>{IU64(0), IU64(9)}));
  EXPECT_EQ((Constraint{LtU, {Literal(uint32_t(1))}}.getSpan()),
            (Span<IU64>{IU64(0), IU64(0)}));
  EXPECT_EQ(
    (Constraint{LtU, {Literal(std::numeric_limits<uint32_t>::max())}}
       .getSpan()),
    (Span<IU64>{IU64(0),
                IU64(uint64_t(std::numeric_limits<uint32_t>::max()) - 1)}));
  // LtU 0 (i32): empty span
  auto ltuZero32 = Constraint{LtU, {Literal(uint32_t(0))}}.getSpan();
  ASSERT_TRUE(ltuZero32.has_value());
  EXPECT_TRUE(ltuZero32->isEmpty());
  EXPECT_EQ(ltuZero32, Span<IU64>::empty());

  // LtU (i64): [0, C - 1]
  EXPECT_EQ((Constraint{LtU, {Literal(uint64_t(100))}}.getSpan()),
            (Span<IU64>{IU64(0), IU64(99)}));
  EXPECT_EQ(
    (Constraint{LtU, {Literal(std::numeric_limits<uint64_t>::max())}}
       .getSpan()),
    (Span<IU64>{IU64(0), IU64(std::numeric_limits<uint64_t>::max() - 1)}));
  // LtU 0 (i64): empty span
  auto ltuZero64 = Constraint{LtU, {Literal(uint64_t(0))}}.getSpan();
  ASSERT_TRUE(ltuZero64.has_value());
  EXPECT_TRUE(ltuZero64->isEmpty());
  EXPECT_EQ(ltuZero64, Span<IU64>::empty());

  // LeS (i32): [minI32, C]
  EXPECT_EQ((Constraint{LeS, {Literal(int32_t(10))}}.getSpan()),
            (Span<IU64>{minI32, IU64(10)}));
  EXPECT_EQ((Constraint{LeS, {Literal(int32_t(0))}}.getSpan()),
            (Span<IU64>{minI32, IU64(0)}));
  EXPECT_EQ((Constraint{LeS, {Literal(int32_t(-5))}}.getSpan()),
            (Span<IU64>{minI32, IU64(-5)}));
  EXPECT_EQ(
    (Constraint{LeS, {Literal(std::numeric_limits<int32_t>::min())}}.getSpan()),
    (Span<IU64>{minI32, minI32}));
  EXPECT_EQ(
    (Constraint{LeS, {Literal(std::numeric_limits<int32_t>::max())}}.getSpan()),
    (Span<IU64>{minI32, maxI32}));

  // LeS (i64): [minI64, C]
  EXPECT_EQ((Constraint{LeS, {Literal(int64_t(10))}}.getSpan()),
            (Span<IU64>{minI64, IU64(10)}));
  EXPECT_EQ(
    (Constraint{LeS, {Literal(std::numeric_limits<int64_t>::min())}}.getSpan()),
    (Span<IU64>{minI64, minI64}));
  EXPECT_EQ(
    (Constraint{LeS, {Literal(std::numeric_limits<int64_t>::max())}}.getSpan()),
    (Span<IU64>{minI64, maxI64}));

  // LeU (i32): [0, C]
  EXPECT_EQ((Constraint{LeU, {Literal(uint32_t(0))}}.getSpan()),
            (Span<IU64>{IU64(0), IU64(0)}));
  EXPECT_EQ((Constraint{LeU, {Literal(uint32_t(10))}}.getSpan()),
            (Span<IU64>{IU64(0), IU64(10)}));
  EXPECT_EQ((Constraint{LeU, {Literal(std::numeric_limits<uint32_t>::max())}}
               .getSpan()),
            (Span<IU64>{IU64(0), maxU32}));

  // LeU (i64): [0, C]
  EXPECT_EQ((Constraint{LeU, {Literal(uint64_t(0))}}.getSpan()),
            (Span<IU64>{IU64(0), IU64(0)}));
  EXPECT_EQ((Constraint{LeU, {Literal(uint64_t(10))}}.getSpan()),
            (Span<IU64>{IU64(0), IU64(10)}));
  EXPECT_EQ((Constraint{LeU, {Literal(std::numeric_limits<uint64_t>::max())}}
               .getSpan()),
            (Span<IU64>{IU64(0), maxU64}));

  // GtS (i32): [C + 1, maxI32]
  EXPECT_EQ((Constraint{GtS, {Literal(int32_t(10))}}.getSpan()),
            (Span<IU64>{IU64(11), maxI32}));
  EXPECT_EQ((Constraint{GtS, {Literal(int32_t(0))}}.getSpan()),
            (Span<IU64>{IU64(1), maxI32}));
  EXPECT_EQ((Constraint{GtS, {Literal(int32_t(-5))}}.getSpan()),
            (Span<IU64>{IU64(-4), maxI32}));
  EXPECT_EQ(
    (Constraint{GtS, {Literal(std::numeric_limits<int32_t>::min())}}.getSpan()),
    (Span<IU64>{IU64(std::numeric_limits<int32_t>::min() + 1), maxI32}));
  EXPECT_EQ((Constraint{GtS, {Literal(std::numeric_limits<int32_t>::max() - 1)}}
               .getSpan()),
            (Span<IU64>{maxI32, maxI32}));
  // GtS max signed (i32): empty span
  auto gtsMax32 =
    Constraint{GtS, {Literal(std::numeric_limits<int32_t>::max())}}.getSpan();
  ASSERT_TRUE(gtsMax32.has_value());
  EXPECT_TRUE(gtsMax32->isEmpty());
  EXPECT_EQ(gtsMax32, Span<IU64>::empty());

  // GtS (i64): [C + 1, maxI64]
  EXPECT_EQ((Constraint{GtS, {Literal(int64_t(10))}}.getSpan()),
            (Span<IU64>{IU64(11), maxI64}));
  EXPECT_EQ((Constraint{GtS, {Literal(int64_t(0))}}.getSpan()),
            (Span<IU64>{IU64(1), maxI64}));
  EXPECT_EQ(
    (Constraint{GtS, {Literal(std::numeric_limits<int64_t>::min())}}.getSpan()),
    (Span<IU64>{IU64(std::numeric_limits<int64_t>::min() + 1), maxI64}));
  EXPECT_EQ((Constraint{GtS, {Literal(std::numeric_limits<int64_t>::max() - 1)}}
               .getSpan()),
            (Span<IU64>{maxI64, maxI64}));
  // GtS max signed (i64): empty span
  auto gtsMax64 =
    Constraint{GtS, {Literal(std::numeric_limits<int64_t>::max())}}.getSpan();
  ASSERT_TRUE(gtsMax64.has_value());
  EXPECT_TRUE(gtsMax64->isEmpty());
  EXPECT_EQ(gtsMax64, Span<IU64>::empty());

  // GtU (i32): [C + 1, maxU32]
  EXPECT_EQ((Constraint{GtU, {Literal(uint32_t(0))}}.getSpan()),
            (Span<IU64>{IU64(1), maxU32}));
  EXPECT_EQ((Constraint{GtU, {Literal(uint32_t(10))}}.getSpan()),
            (Span<IU64>{IU64(11), maxU32}));
  EXPECT_EQ(
    (Constraint{GtU, {Literal(std::numeric_limits<uint32_t>::max() - 1)}}
       .getSpan()),
    (Span<IU64>{maxU32, maxU32}));
  // GtU max unsigned (i32): empty span
  auto gtuMax32 =
    Constraint{GtU, {Literal(std::numeric_limits<uint32_t>::max())}}.getSpan();
  ASSERT_TRUE(gtuMax32.has_value());
  EXPECT_TRUE(gtuMax32->isEmpty());
  EXPECT_EQ(gtuMax32, Span<IU64>::empty());

  // GtU (i64): [C + 1, maxU64]
  EXPECT_EQ((Constraint{GtU, {Literal(uint64_t(0))}}.getSpan()),
            (Span<IU64>{IU64(1), maxU64}));
  EXPECT_EQ((Constraint{GtU, {Literal(uint64_t(10))}}.getSpan()),
            (Span<IU64>{IU64(11), maxU64}));
  EXPECT_EQ(
    (Constraint{GtU, {Literal(std::numeric_limits<uint64_t>::max() - 1)}}
       .getSpan()),
    (Span<IU64>{maxU64, maxU64}));
  // GtU max unsigned (i64): empty span
  auto gtuMax64 =
    Constraint{GtU, {Literal(std::numeric_limits<uint64_t>::max())}}.getSpan();
  ASSERT_TRUE(gtuMax64.has_value());
  EXPECT_TRUE(gtuMax64->isEmpty());
  EXPECT_EQ(gtuMax64, Span<IU64>::empty());

  // GeS (i32): [C, maxI32]
  EXPECT_EQ((Constraint{GeS, {Literal(int32_t(10))}}.getSpan()),
            (Span<IU64>{IU64(10), maxI32}));
  EXPECT_EQ((Constraint{GeS, {Literal(int32_t(0))}}.getSpan()),
            (Span<IU64>{IU64(0), maxI32}));
  EXPECT_EQ((Constraint{GeS, {Literal(int32_t(-5))}}.getSpan()),
            (Span<IU64>{IU64(-5), maxI32}));
  EXPECT_EQ(
    (Constraint{GeS, {Literal(std::numeric_limits<int32_t>::min())}}.getSpan()),
    (Span<IU64>{minI32, maxI32}));
  EXPECT_EQ(
    (Constraint{GeS, {Literal(std::numeric_limits<int32_t>::max())}}.getSpan()),
    (Span<IU64>{maxI32, maxI32}));

  // GeS (i64): [C, maxI64]
  EXPECT_EQ((Constraint{GeS, {Literal(int64_t(10))}}.getSpan()),
            (Span<IU64>{IU64(10), maxI64}));
  EXPECT_EQ((Constraint{GeS, {Literal(int64_t(0))}}.getSpan()),
            (Span<IU64>{IU64(0), maxI64}));
  EXPECT_EQ(
    (Constraint{GeS, {Literal(std::numeric_limits<int64_t>::min())}}.getSpan()),
    (Span<IU64>{minI64, maxI64}));
  EXPECT_EQ(
    (Constraint{GeS, {Literal(std::numeric_limits<int64_t>::max())}}.getSpan()),
    (Span<IU64>{maxI64, maxI64}));

  // GeU (i32): [C, maxU32]
  EXPECT_EQ((Constraint{GeU, {Literal(uint32_t(0))}}.getSpan()),
            (Span<IU64>{IU64(0), maxU32}));
  EXPECT_EQ((Constraint{GeU, {Literal(uint32_t(10))}}.getSpan()),
            (Span<IU64>{IU64(10), maxU32}));
  EXPECT_EQ((Constraint{GeU, {Literal(std::numeric_limits<uint32_t>::max())}}
               .getSpan()),
            (Span<IU64>{maxU32, maxU32}));

  // GeU (i64): [C, maxU64]
  EXPECT_EQ((Constraint{GeU, {Literal(uint64_t(0))}}.getSpan()),
            (Span<IU64>{IU64(0), maxU64}));
  EXPECT_EQ((Constraint{GeU, {Literal(uint64_t(10))}}.getSpan()),
            (Span<IU64>{IU64(10), maxU64}));
  EXPECT_EQ((Constraint{GeU, {Literal(std::numeric_limits<uint64_t>::max())}}
               .getSpan()),
            (Span<IU64>{maxU64, maxU64}));
}

TEST(ConstraintTest, GetSpanType) {
  const IU64 minI32(std::numeric_limits<int32_t>::min());
  const IU64 minI32Plus1(std::numeric_limits<int32_t>::min() + 1);

  const IU64 maxI32(std::numeric_limits<int32_t>::max());
  const IU64 maxI32Minus1(std::numeric_limits<int32_t>::max() - 1);

  const IU64 maxU32(std::numeric_limits<uint32_t>::max());
  const IU64 maxU32Minus1(std::numeric_limits<uint32_t>::max() - 1);

  const IU64 minI64(std::numeric_limits<int64_t>::min());
  const IU64 minI64Plus1(std::numeric_limits<int64_t>::min() + 1);

  const IU64 maxI64(std::numeric_limits<int64_t>::max());
  const IU64 maxI64Minus1(std::numeric_limits<int64_t>::max() - 1);

  const IU64 maxU64(std::numeric_limits<uint64_t>::max());
  const IU64 maxU64Minus1(std::numeric_limits<uint64_t>::max() - 1);

  // Providing the type to getSpan() doesn't help with certain things.
  EXPECT_EQ((Constraint{Eq, {Index(0)}}.getSpan(Type::i32)), std::nullopt);
  EXPECT_EQ((Constraint{Ne, {Index(1)}}.getSpan(Type::i64)), std::nullopt);
  EXPECT_EQ((Constraint{GeU, {Index(2)}}.getSpan(Type::i32)), std::nullopt);
  EXPECT_EQ((Constraint{GeS, {Index(0)}}.getSpan(Type::i64)), std::nullopt);
  EXPECT_EQ((Constraint{LeU, {Index(1)}}.getSpan(Type::i64)), std::nullopt);
  EXPECT_EQ((Constraint{LeS, {Index(2)}}.getSpan(Type::i32)), std::nullopt);

  // But it does help with others: x < y means x cannot be MAX_INT, so we can
  // report a *proven* span, if not an exact one.
  EXPECT_EQ((Constraint{LtS, {Index(0)}}.getProvenSpan(Type::i32)),
            (Span<IU64>{minI32, maxI32Minus1}));
  EXPECT_EQ((Constraint{LtS, {Index(1)}}.getProvenSpan(Type::i64)),
            (Span<IU64>{minI64, maxI64Minus1}));

  EXPECT_EQ((Constraint{LtU, {Index(2)}}.getProvenSpan(Type::i32)),
            (Span<IU64>{0, maxU32Minus1}));
  EXPECT_EQ((Constraint{LtU, {Index(0)}}.getProvenSpan(Type::i64)),
            (Span<IU64>{0, maxU64Minus1}));

  EXPECT_EQ((Constraint{GtS, {Index(1)}}.getProvenSpan(Type::i32)),
            (Span<IU64>{minI32Plus1, maxI32}));
  EXPECT_EQ((Constraint{GtS, {Index(2)}}.getProvenSpan(Type::i64)),
            (Span<IU64>{minI64Plus1, maxI64}));

  EXPECT_EQ((Constraint{GtU, {Index(0)}}.getProvenSpan(Type::i32)),
            (Span<IU64>{1, maxU32}));
  EXPECT_EQ((Constraint{GtU, {Index(1)}}.getProvenSpan(Type::i64)),
            (Span<IU64>{1, maxU64}));

  // But all the last things are impossible with an exact span.
  EXPECT_EQ((Constraint{LtS, {Index(0)}}.getSpan(Type::i32)), std::nullopt);
  EXPECT_EQ((Constraint{LtS, {Index(1)}}.getSpan(Type::i64)), std::nullopt);
  EXPECT_EQ((Constraint{LtU, {Index(2)}}.getSpan(Type::i32)), std::nullopt);
  EXPECT_EQ((Constraint{LtU, {Index(0)}}.getSpan(Type::i64)), std::nullopt);
  EXPECT_EQ((Constraint{GtS, {Index(1)}}.getSpan(Type::i32)), std::nullopt);
  EXPECT_EQ((Constraint{GtS, {Index(2)}}.getSpan(Type::i64)), std::nullopt);
  EXPECT_EQ((Constraint{GtU, {Index(0)}}.getSpan(Type::i32)), std::nullopt);
  EXPECT_EQ((Constraint{GtU, {Index(1)}}.getSpan(Type::i64)), std::nullopt);

  // Proven spans are otherwise like normal ones.
  EXPECT_EQ((Constraint{Eq, {Literal(int32_t(42))}}.getProvenSpan()),
            (Span<IU64>{42, 42}));
}

TEST(ConstraintTest, SpanOptimizations) {
  // Using spans, we can optimize things like {x < 100} => {x < 200}.
  Constraint lts100{LtS, {Literal(int32_t(100))}};
  Constraint lts200{LtS, {Literal(int32_t(200))}};
  EXPECT_EQ(AndedConstraintSet{lts100}.proves(lts200), True);

  // Mixing signed and unsigned works fine: x in [0, 100] (x <= 100 unsigned)
  // proves x in [-MIN_INT, 200] (x < 200 signed) is true.
  Constraint leu100{LtU, {Literal(int32_t(100))}};
  EXPECT_EQ(AndedConstraintSet{leu100}.proves(lts200), True);

  // Replacing 100 with 500, we can no longer prove anything.
  Constraint leu500{LtU, {Literal(int32_t(500))}};
  EXPECT_EQ(AndedConstraintSet{leu500}.proves(lts200), Unknown);
}

TEST(ConstraintTest, EmptySpanContradiction) {
  // Impossible constraints produce empty spans.
  Constraint gtsMax32{GtS, {Literal(std::numeric_limits<int32_t>::max())}};
  Constraint ltsMin32{LtS, {Literal(std::numeric_limits<int32_t>::min())}};
  Constraint ltuZero32{LtU, {Literal(uint32_t(0))}};
  Constraint gtuMax32{GtU, {Literal(std::numeric_limits<uint32_t>::max())}};

  Constraint gtsMax64{GtS, {Literal(std::numeric_limits<int64_t>::max())}};
  Constraint ltsMin64{LtS, {Literal(std::numeric_limits<int64_t>::min())}};
  Constraint ltuZero64{LtU, {Literal(uint64_t(0))}};
  Constraint gtuMax64{GtU, {Literal(std::numeric_limits<uint64_t>::max())}};

  Constraint eq5{Eq, {Literal(int32_t(5))}};
  Constraint ge0{GeS, {Literal(int32_t(0))}};
  Constraint eq100_64{Eq, {Literal(int64_t(100))}};

  // An impossible constraint proves anything is True.
  EXPECT_EQ(AndedConstraintSet{gtsMax32}.proves(eq5), True);
  EXPECT_EQ(AndedConstraintSet{ltsMin32}.proves(ge0), True);
  EXPECT_EQ(AndedConstraintSet{ltuZero32}.proves(eq5), True);
  EXPECT_EQ(AndedConstraintSet{gtuMax32}.proves(ge0), True);

  EXPECT_EQ(AndedConstraintSet{gtsMax64}.proves(eq100_64), True);
  EXPECT_EQ(AndedConstraintSet{ltsMin64}.proves(eq100_64), True);
  EXPECT_EQ(AndedConstraintSet{ltuZero64}.proves(eq100_64), True);
  EXPECT_EQ(AndedConstraintSet{gtuMax64}.proves(eq100_64), True);

  // Impossible constraint proves another impossible constraint is True.
  EXPECT_EQ(AndedConstraintSet{gtsMax32}.proves(ltsMin32), True);
  EXPECT_EQ(AndedConstraintSet{ltuZero32}.proves(gtuMax32), True);

  // A normal constraint proves an impossible constraint is False.
  EXPECT_EQ(AndedConstraintSet{eq5}.proves(gtsMax32), False);
  EXPECT_EQ(AndedConstraintSet{eq5}.proves(ltsMin32), False);
  EXPECT_EQ(AndedConstraintSet{eq5}.proves(ltuZero32), False);
  EXPECT_EQ(AndedConstraintSet{eq5}.proves(gtuMax32), False);

  EXPECT_EQ(AndedConstraintSet{eq100_64}.proves(gtsMax64), False);
  EXPECT_EQ(AndedConstraintSet{eq100_64}.proves(ltsMin64), False);
  EXPECT_EQ(AndedConstraintSet{eq100_64}.proves(ltuZero64), False);
  EXPECT_EQ(AndedConstraintSet{eq100_64}.proves(gtuMax64), False);

  // An impossible constraint in a set proves any condition.
  AndedConstraintSet s{gtsMax32};
  EXPECT_EQ(s.proves(eq5), True);
  EXPECT_EQ(s.proves(ge0), True);

  // Adding an impossible constraint to a non-empty set proves False and turns
  // the set into an explicit contradiction (provesEverything() == true).
  AndedConstraintSet s2;
  s2.set(eq5);
  s2.approximateAnd(ltuZero32);
  EXPECT_TRUE(s2.provesEverything());

  // ORing an impossible constraint (which has no models) with a valid set
  // leaves the valid set.
  AndedConstraintSet valid{{Eq, {Literal(int32_t(42))}}};
  AndedConstraintSet impossible{gtsMax32};
  checkOr(valid, impossible, valid);
}

TEST(ConstraintTest, GetSpanFloat) {
  // Non-integer types do not cause errors.
  EXPECT_EQ((Constraint{Eq, {Literal(float(3.14159))}}.getSpan()),
            std::nullopt);
}

TEST(ConstraintTest, GetSpanGC) {
  // Reference types do not cause errors.
  EXPECT_EQ((Constraint{Eq, {Literal::makeNull(HeapType::eq)}}.getSpan()),
            std::nullopt);
}

TEST(ConstraintTest, SignedUnsigned) {
  // x == 5 proves x < 10, signed or unsigned.
  Constraint eq5{Eq, {Literal(int32_t(5))}};
  Constraint lts10{LtS, {Literal(int32_t(10))}};
  Constraint ltu10{LtU, {Literal(int32_t(10))}};
  EXPECT_EQ(AndedConstraintSet{eq5}.proves(lts10), True);
  EXPECT_EQ(AndedConstraintSet{eq5}.proves(ltu10), True);

  // x == 5 proves x < -10 signed is false, but unsigned is true (since -10 is
  // a very large positive number).
  Constraint lts_minus10{LtS, {Literal(int32_t(-10))}};
  Constraint ltu_minus10{LtU, {Literal(int32_t(-10))}};
  EXPECT_EQ(AndedConstraintSet{eq5}.proves(lts_minus10), False);
  EXPECT_EQ(AndedConstraintSet{eq5}.proves(ltu_minus10), True);
}

TEST(ConstraintTest, SignedUnsignedLessMix) {
  // x < 10, signed and the same but unsigned, have some overlap (0 to 10) but
  // the signed version has more possible values.
  Constraint lts10{LtS, {Literal(int32_t(10))}};
  Constraint ltu10{LtU, {Literal(int32_t(10))}};
  // x might be negative, which would not prove x < 10 unsigned.
  EXPECT_EQ(AndedConstraintSet{lts10}.proves(ltu10), Unknown);
  // x is definitely in [0, 10], so x < 10 signed is also true.
  EXPECT_EQ(AndedConstraintSet{ltu10}.proves(lts10), True);

  // Now with -10 instead of 10.
  Constraint lts_minus10{LtS, {Literal(int32_t(-10))}};
  Constraint ltu_minus10{LtU, {Literal(int32_t(-10))}};
  // x < -10 signed means all the numbers with the high/sign bit set, except for
  // -1 to -10 (which are the very highest in unsigned terms), that is,
  // [1, large number] in the unsigned representation of bits. x < -10
  // *un*signed is similar, but *does* include 0, so the unsigned one does not
  // prove the signed.
  EXPECT_EQ(AndedConstraintSet{lts_minus10}.proves(ltu_minus10), True);
  EXPECT_EQ(AndedConstraintSet{ltu_minus10}.proves(lts_minus10), Unknown);

  // x < -10 signed means all numbers with the high bit set, except for the very
  // highest. This rules out x < 10 unsigned.
  EXPECT_EQ(AndedConstraintSet{lts_minus10}.proves(ltu10), False);
  // x < 10 signed means all numbers with the sign bit, and 0..10. This has
  // partial overlap with x < -10 unsigned.
  EXPECT_EQ(AndedConstraintSet{lts10}.proves(ltu_minus10), Unknown);

  // Flip cases of the above pair.
  EXPECT_EQ(AndedConstraintSet{ltu_minus10}.proves(lts10), Unknown);
  EXPECT_EQ(AndedConstraintSet{ltu10}.proves(lts_minus10), False);
}

TEST(ConstraintTest, SignedUnsignedMoreMix) {
  // x > 10, signed and the same but unsigned. The signed version does not
  // include numbers with the highest bit set.
  Constraint gts10{GtS, {Literal(int32_t(10))}};
  Constraint gtu10{GtU, {Literal(int32_t(10))}};
  EXPECT_EQ(AndedConstraintSet{gts10}.proves(gtu10), True);
  EXPECT_EQ(AndedConstraintSet{gtu10}.proves(gts10), Unknown);

  // TODO: add negative cases
}

TEST(ConstraintTest, SignedUnsignedLessAndMoreMix) {
  // Use > and < together.
  Constraint lts10{LtS, {Literal(int32_t(10))}};
  Constraint ltu10{LtU, {Literal(int32_t(10))}};
  Constraint gts10{GtS, {Literal(int32_t(10))}};
  Constraint gtu10{GtU, {Literal(int32_t(10))}};

  EXPECT_EQ(AndedConstraintSet{lts10}.proves(gtu10), Unknown);
  EXPECT_EQ(AndedConstraintSet{ltu10}.proves(gts10), False);
  EXPECT_EQ(AndedConstraintSet{gts10}.proves(ltu10), False);
  EXPECT_EQ(AndedConstraintSet{gtu10}.proves(lts10), Unknown);

  // TODO: add negative cases
}
