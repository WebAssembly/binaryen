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
}

