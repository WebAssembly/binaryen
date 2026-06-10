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

#include "ir/constraint.h"
#include "gtest/gtest.h"

using namespace wasm;
using namespace wasm::analysis;

TEST(ConstraintTest, Basic) {
  BoundedConstraints<2> lattice;

  auto bot = lattice.getBottom();
  BoundedConstraints<2>::Element top{
    inplace_vector<BoundedConstraintsBase::L::Element, 2>{}};

  Bound<Int64> bound_int(Int64{});
  Bound<Flat<Index>> bound_flat(Flat<Index>{});

  auto make_int_bound = [&](BoundRelation rel, int64_t val) {
    return BoundedConstraintsBase::L::Element(std::in_place_index<0>,
                                              bound_int.makeBound(rel, val));
  };

  auto make_var_bound = [&](BoundRelation rel, Index var) {
    return BoundedConstraintsBase::L::Element(
      std::in_place_index<1>,
      bound_flat.makeBound(rel, Flat<Index>{}.get(var)));
  };

  auto make_constraints =
    [&](std::initializer_list<BoundedConstraintsBase::L::Element> elms) {
      inplace_vector<BoundedConstraintsBase::L::Element, 2> vec;
      for (const auto& e : elms) {
        vec.push_back(e);
      }
      return BoundedConstraints<2>::Element{vec};
    };

  auto c_int1 = make_int_bound(BoundRelation::LT, 5); // x < 5
  auto c_int2 = make_int_bound(BoundRelation::GE, 3); // x >= 3
  auto c_var1 = make_var_bound(BoundRelation::LE, 1); // x <= $1
  auto c_var2 = make_var_bound(BoundRelation::GT, 2); // x > $2

  // Test compare
  auto e_int1 = make_constraints({c_int1});
  auto e_int2 = make_constraints({c_int2});
  auto e_var1 = make_constraints({c_var1});

  EXPECT_EQ(lattice.compare(bot, e_int1), LESS);
  EXPECT_EQ(lattice.compare(top, e_int1), GREATER);

  EXPECT_EQ(lattice.compare(e_int1, e_int2), NO_RELATION);
  EXPECT_EQ(lattice.compare(e_int1, e_var1), NO_RELATION);

  // Test boundedMeet (conjunction)
  // Meet {x < 5} and {x >= 3} -> {x < 5, x >= 3}
  {
    auto meetee = e_int1;
    EXPECT_TRUE(lattice.boundedMeet(meetee, e_int2));
    EXPECT_EQ(meetee, make_constraints({c_int1, c_int2}));
  }

  // Meet {x < 5, x >= 3} and {x <= $1} -> exceeds N=2!
  // It should keep constants (c_int1, c_int2) and drop variable (c_var1).
  {
    auto meetee = make_constraints({c_int1, c_int2});
    EXPECT_FALSE(lattice.boundedMeet(meetee, e_var1));
    EXPECT_EQ(meetee, make_constraints({c_int1, c_int2}));
  }

  // Meet {x < 5, x <= $1} and {x > $2} -> exceeds N=2!
  // Sorted: c_int1 (const), c_var1 (LE), c_var2 (GT).
  // LE < GT, so c_var1 is kept, c_var2 is dropped.
  {
    auto meetee = make_constraints({c_int1, c_var1});
    auto meeter = make_constraints({c_var2});
    EXPECT_FALSE(lattice.boundedMeet(meetee, meeter));
    EXPECT_EQ(meetee, make_constraints({c_int1, c_var1}));
  }
}
