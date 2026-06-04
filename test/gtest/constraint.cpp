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

TEST(ConstraintTest, TestSet) {
  // Sets start empty.
  AndedConstraintSet s;
  EXPECT_TRUE(s.empty());

  // $0 == 5
  Constraint c{Eq, Index(0), Literal(int32_t(5))};

  // We can't infer anything using an empty set.
  EXPECT_EQ(s.check(c), Unknown);

  // If we add it, then things check out.
  s.and_(c);
  EXPECT_EQ(s.size(), 1);
  EXPECT_EQ(s.check(c), True);

  // $1 == 5, a different local: we can't infer anything.
  Constraint c2{Eq, Index(1), Literal(int32_t(5))};
  EXPECT_EQ(s.check(c2), Unknown);

  // $0 == 10, a different number: we could infer False here TODO.
  Constraint c3{Eq, Index(0) Literal(int32_t(10))};
  EXPECT_EQ(s.check(c3), Unknown);
}

