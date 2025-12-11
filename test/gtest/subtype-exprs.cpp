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

#include "ir/subtype-exprs.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

static Type anyref = Type(HeapType::any, Nullable);

// A BrIf must require of its value to both match the block it targets, and
// also the BrIf itself, as the value flows out.
TEST(SubtypeExprsTest, BrIf) {
  Module wasm;
  Builder builder(wasm);
  // A br_if in a block, whose value is a null.
  auto* null = builder.makeRefNull(HeapType::any);
  auto* c = builder.makeConst(Literal(int32_t(42)));
  auto* brIf = builder.makeBreak("block", null, c);
  auto* block = builder.makeBlock("block", {brIf}, anyref);
  auto* drop = builder.makeDrop(block);
  auto func = builder.makeFunction(
    "func", {}, Signature(Type::none, Type::none), {}, drop);

  // Implement a SubtypingDiscoverer.
  struct Finder
    : public ControlFlowWalker<Finder, SubtypingDiscoverer<Finder>> {
    std::set<Expression*> seen;

    void noteSubtype(Type sub, Type super) {}
    void noteSubtype(HeapType sub, HeapType super) {}
    void noteSubtype(Type sub, Expression* super) {}
    void noteSubtype(Expression* sub, Type super) {}
    void noteSubtype(Expression* sub, Expression* super) {
      if (sub->is<RefNull>()) {
        // The null will be called with two constraints: the block (the null is
        // sent there) and also the break (the null flows out through it).
        seen.insert(super);
      }
    }
    void noteNonFlowSubtype(Expression* sub, Type super) {}
    void noteCast(HeapType src, Type dst) {}
    void noteCast(Expression* src, Type dst) {}
    void noteCast(Expression* src, Expression* dst) {}
  } finder;

  finder.walkFunctionInModule(func.get(), &wasm);

  // We should have seen both things.
  ASSERT_EQ(finder.seen.size(), 2);
  EXPECT_EQ(finder.seen.count(brIf), 1);
  EXPECT_EQ(finder.seen.count(block), 1);

  // Remove the condition from the br. Now it is unreachable and no value
  // flows out.
  brIf->condition = nullptr;
  brIf->type = Type::unreachable;

  // We should now only see the sent value - nothing flows out to the br_if.
  finder.seen.clear();
  finder.walkFunctionInModule(func.get(), &wasm);
  ASSERT_EQ(finder.seen.size(), 1);
  EXPECT_EQ(finder.seen.count(block), 1);
}
