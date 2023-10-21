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

#include "analysis/lattices/bool.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(BoolLattice, GetBottom) {
  analysis::Bool lattice;
  EXPECT_FALSE(lattice.getBottom());
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
