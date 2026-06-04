#include "ir/constraint.h"
#include "gtest/gtest.h"

using namespace wasm;
using namespace wasm::constraint;

TEST(ConstraintTest, TestEmpty) {
  // An empty constraint is invalid.
  Constraint c;
  EXPECT_FALSE(c);
}

