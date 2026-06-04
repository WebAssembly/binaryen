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
  EXPECT_EQ(s.check(c), True);
}

