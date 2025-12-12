/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include "ir/glbs.h"
#include "wasm-type.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(GLBsTest, Basics) {
  GLBFinder finder;

  // Nothing noted yet.
  EXPECT_FALSE(finder.noted());
  EXPECT_EQ(finder.getGLB(), Type::unreachable);

  // Note a type.
  Type anyref = Type(HeapType::any, Nullable);
  finder.note(anyref);
  EXPECT_TRUE(finder.noted());
  EXPECT_EQ(finder.getGLB(), anyref);

  // Note another, leaving the more-refined GLB.
  Type refAny = Type(HeapType::any, NonNullable);
  finder.note(refAny);
  EXPECT_TRUE(finder.noted());
  EXPECT_EQ(finder.getGLB(), refAny);

  // Note unreachable, which changes nothing (we ignore unreachable inputs).
  finder.note(Type::unreachable);
  EXPECT_EQ(finder.getGLB(), refAny);
}
