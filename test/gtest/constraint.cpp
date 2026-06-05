#include "ir/abstract.h"
#include "ir/constraint.h"
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

  // x == 5 (we use "x" for the name of the thing being compared).
  Constraint c{Eq, Literal(int32_t(5))};

  // We can't infer anything using an empty set.
  EXPECT_EQ(s.check(c), Unknown);

  // If we add it, then things check out.
  s.and_(c);
  EXPECT_EQ(s.size(), 1);
  EXPECT_EQ(s.check(c), True);

  // $0 == 10, a different number: we can infer false.
  Constraint e{Eq, Literal(int32_t(10))};
  EXPECT_EQ(s.check(e), False);
}

#if 0
TEST(ConstraintTest, TestMulti) {
  // Two anded constraints. Both check out.
  AndedConstraintSet s;
  Constraint c{Eq, Index(0), Literal(int32_t(5))};
  Constraint d{Eq, Index(1), Literal(int32_t(10))};
  s.and_(c);
  s.and_(d);
  EXPECT_EQ(s.check(c), True);
  EXPECT_EQ(s.check(d), True);

  // Something unrelated does not.
  Constraint e{Eq, Index(2), Literal(int32_t(15))};
  EXPECT_EQ(s.check(e), Unknown);
}
#endif

