/*
 * Copyright 2026 WebAssembly Community Group participants
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

#include "ir/abstract.h"
#include "gtest/gtest.h"

using namespace wasm;
using namespace wasm::Abstract;

TEST(AbstractTest, NegateRelational) {
  // Equality
  EXPECT_EQ(negateRelational(Eq), Ne);
  EXPECT_EQ(negateRelational(Ne), Eq);

  // Signed inequalities
  EXPECT_EQ(negateRelational(LtS), GeS);
  EXPECT_EQ(negateRelational(LeS), GtS);
  EXPECT_EQ(negateRelational(GtS), LeS);
  EXPECT_EQ(negateRelational(GeS), LtS);

  // Unsigned inequalities
  EXPECT_EQ(negateRelational(LtU), GeU);
  EXPECT_EQ(negateRelational(LeU), GtU);
  EXPECT_EQ(negateRelational(GtU), LeU);
  EXPECT_EQ(negateRelational(GeU), LtU);
}

TEST(AbstractTest, FlipRelational) {
  // Equality (symmetric: flipping sides does not change the operator)
  EXPECT_EQ(flipRelational(Eq), Eq);
  EXPECT_EQ(flipRelational(Ne), Ne);

  // Signed inequalities (antisymmetric: flipping sides reverses comparison)
  EXPECT_EQ(flipRelational(LtS), GtS);
  EXPECT_EQ(flipRelational(LeS), GeS);
  EXPECT_EQ(flipRelational(GtS), LtS);
  EXPECT_EQ(flipRelational(GeS), LeS);

  // Unsigned inequalities (antisymmetric: flipping sides reverses comparison)
  EXPECT_EQ(flipRelational(LtU), GtU);
  EXPECT_EQ(flipRelational(LeU), GeU);
  EXPECT_EQ(flipRelational(GtU), LtU);
  EXPECT_EQ(flipRelational(GeU), LeU);
}

TEST(AbstractTest, RelationalInvolutions) {
  const Op relationalOps[] = {
    Eq, Ne, LtS, LtU, LeS, LeU, GtS, GtU, GeS, GeU,
  };

  for (auto op : relationalOps) {
    // Negating twice returns the original operator.
    EXPECT_EQ(negateRelational(negateRelational(op)), op);

    // Flipping twice returns the original operator.
    EXPECT_EQ(flipRelational(flipRelational(op)), op);
  }
}

TEST(AbstractTest, RelationalSymmetry) {
  const Op symmetricOps[] = {Eq, Ne};
  for (auto op : symmetricOps) {
    EXPECT_TRUE(isRelationalSymmetric(op));
    EXPECT_FALSE(isRelationalAntisymmetric(op));
    // Symmetric operators are invariant under flipping.
    EXPECT_EQ(flipRelational(op), op);
  }

  const Op antisymmetricOps[] = {LtS, LtU, LeS, LeU, GtS, GtU, GeS, GeU};
  for (auto op : antisymmetricOps) {
    EXPECT_FALSE(isRelationalSymmetric(op));
    EXPECT_TRUE(isRelationalAntisymmetric(op));
    // Antisymmetric operators are not invariant under flipping.
    EXPECT_NE(flipRelational(op), op);
  }
}
