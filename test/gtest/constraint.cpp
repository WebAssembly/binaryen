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

// TODO: test an approximateOr of { x = 10 } and { x >= 0 }, once we support
//       inequalities
