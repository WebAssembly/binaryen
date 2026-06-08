#include "ir/constraint.h"
#include "ir/abstract.h"
#include "gtest/gtest.h"

using namespace wasm;
using namespace wasm::Abstract;
using namespace wasm::constraint;

TEST(ConstraintTest, TestEmpty) {
  // An empty constraint is invalid.
  Constraint c;
  EXPECT_FALSE(c);
}

TEST(ConstraintTest, TestEq) {
  // Sets start empty.
  AndedConstraintSet s;
  EXPECT_TRUE(s.empty());

  // x == 5 (we use "x" for the name of the thing being compared, in these
  // comments).
  Constraint c{Eq, Literal(int32_t(5))};

  // We can't infer anything using an empty set.
  EXPECT_EQ(s.check(c), Unknown);

  // If we add it, then things check out: a thing always proves itself true.
  s.and_(c);
  EXPECT_EQ(s.size(), 1);
  EXPECT_EQ(s.check(c), True);

  // x == 10, a different number: we can infer false.
  EXPECT_EQ(s.check(Constraint{Eq, Literal(int32_t(10))}), False);

  // x != 15: we can infer true.
  EXPECT_EQ(s.check(Constraint{Ne, Literal(int32_t(15))}), True);

  // x != 5: we can infer false.
  EXPECT_EQ(s.check(Constraint{Ne, Literal(int32_t(5))}), False);
}

TEST(ConstraintTest, TestNe) {
  AndedConstraintSet s;
  // x != 5
  Constraint c{Ne, Literal(int32_t(5))};
  s.and_(c);

  // Checks out versus itself.
  EXPECT_EQ(s.check(c), True);

  // x == 10: we don't know.
  EXPECT_EQ(s.check(Constraint{Eq, Literal(int32_t(10))}), Unknown);

  // x != 15: we don't know.
  EXPECT_EQ(s.check(Constraint{Ne, Literal(int32_t(15))}), Unknown);

  // x == 5: we can infer false.
  EXPECT_EQ(s.check(Constraint{Eq, Literal(int32_t(5))}), False);
}

TEST(ConstraintTest, TestMulti) {
  AndedConstraintSet s;
  // x != 5 && x != 10
  Constraint c{Ne, Literal(int32_t(5))};
  Constraint d{Ne, Literal(int32_t(10))};
  s.and_(c);
  s.and_(d);

  // Each checks out versus itself.
  EXPECT_EQ(s.check(c), True);
  EXPECT_EQ(s.check(d), True);

  // x == 5: false.
  EXPECT_EQ(s.check(Constraint{Eq, Literal(int32_t(5))}), False);

  // x == 10: false.
  EXPECT_EQ(s.check(Constraint{Eq, Literal(int32_t(10))}), False);

  // x == 15: we don't know.
  EXPECT_EQ(s.check(Constraint{Eq, Literal(int32_t(15))}), Unknown);

  // x != 15: we don't know.
  EXPECT_EQ(s.check(Constraint{Ne, Literal(int32_t(15))}), Unknown);
}

TEST(ConstraintTest, TestSets) {
  // x == 5
  Constraint c{Eq, Literal(int32_t(5))};

  AndedConstraintSet s;

  // Any set always proves itself to be true.
  EXPECT_EQ(s.check(s), True);

  // Ditto after adding something.
  s.and_(c);
  EXPECT_EQ(s.check(s), True);

  // Another set, empty.
  AndedConstraintSet t;

  // Any set always proves an empty set to be true.
  EXPECT_EQ(s.check(t), True);

  // Make both sets contain the same stuff.
  t.and_(c);
  EXPECT_EQ(s.check(t), True);

  // Now t has *different* stuff, x == 10, which given s is false.
  t.clear();
  t.and_(Constraint{Eq, Literal(int32_t(10))});
  EXPECT_EQ(s.check(t), False);

  // Same, with x != 10. Now we know it is true.
  t.clear();
  t.and_(Constraint{Ne, Literal(int32_t(10))});
  EXPECT_EQ(s.check(t), True);

  // In reverse, we can infer nothing: knowing x != 10 does not say if x == 5.
  EXPECT_EQ(t.check(s), Unknown);
}

TEST(ConstraintTest, TestOrTrivial) {
  // { x == 5 }
  AndedConstraintSet s;
  s.and_(Constraint{Eq, Literal(int32_t(5))});

  // { }
  AndedConstraintSet empty;

  // Anything ORed with the empty set is unchanged.
  auto t = s;
  t.fuzzyOr(empty);
  EXPECT_EQ(t, s);

  // Flipped.
  t = empty;
  t.fuzzyOr(s);
  EXPECT_EQ(t, s);

  // ORing with oneself changes nothing
  t = s;
  t.fuzzyOr(s);
  EXPECT_EQ(t, s);
}

TEST(ConstraintTest, TestOrImplies) {
  // { x == 5 }
  AndedConstraintSet s;
  s.and_(Constraint{Eq, Literal(int32_t(5))});

  // { x != 10 }
  AndedConstraintSet t;
  t.and_(Constraint{Ne, Literal(int32_t(10))});

  // ORing these leaves us with x != 10.
  auto u = s;
  u.fuzzyOr(t);
  EXPECT_EQ(u, t);

  // Flipped.
  u = t;
  u.fuzzyOr(s);
  EXPECT_EQ(u, t);
}

// TODO: test a fuzzyOr of { x = 10 } and { x >= 0 }, once we support
//       inequalities
