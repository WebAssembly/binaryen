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

#include "gmock/gmock.h"
#include "gtest/gtest.h"

#include "ir/effects.h"
#include "matchers/effects.h"
#include "parser/wat-parser.h"
#include "wasm.h"

using namespace wasm;
using namespace testing;

namespace {

class EffectAnalyzerTest : public Test {
protected:
  Module wasm;
  PassOptions options;

  void SetUp() override { wasm.features = FeatureSet::All; }
};

TEST_F(EffectAnalyzerTest, Suspend) {
  auto moduleText = R"wasm(
    (module
      (tag $tag)
      (func $test
        (suspend $tag)
      )
    )
  )wasm";

  auto parseResult = WATParser::parseModule(wasm, moduleText);
  ASSERT_FALSE(parseResult.getErr());

  auto* func = wasm.getFunction("test");
  ASSERT_NE(func, nullptr);

  EffectAnalyzer effects(options, wasm, func->body);

  // Suspension detection
  EXPECT_TRUE(effects.suspends);
  EXPECT_THAT(&effects, Suspends());
  EXPECT_TRUE(effects.getSideEffects() & EffectAnalyzer::SideEffects::Suspends);

  // Suspending executes arbitrary other code in the handler before resuming,
  // modeled as a call.
  EXPECT_TRUE(effects.calls);
  EXPECT_THAT(&effects, Calls());

  // Accesses all global mutable state via calls
  EXPECT_TRUE(effects.accessesMemory());
  EXPECT_TRUE(effects.accessesSharedMemory());
  EXPECT_TRUE(effects.accessesTable());
  EXPECT_TRUE(effects.accessesMutableStruct());
  EXPECT_TRUE(effects.accessesSharedMutableStruct());
  EXPECT_TRUE(effects.accessesArray());
  EXPECT_TRUE(effects.accessesSharedArray());
  EXPECT_TRUE(effects.writesGlobalState());
  EXPECT_TRUE(effects.readsMutableGlobalState());
  EXPECT_TRUE(effects.accessesSharedGlobalState());

  // Control flow & side effect queries
  EXPECT_TRUE(effects.transfersControlFlow());
  EXPECT_TRUE(effects.hasNonTrapSideEffects());
  EXPECT_TRUE(effects.hasSideEffects());
  EXPECT_TRUE(effects.hasUnremovableSideEffects());
}

TEST_F(EffectAnalyzerTest, UnknownCall) {
  auto moduleText = R"wasm(
    (module
      (func $callee)
      (func $caller
        (call $callee)
      )
    )
  )wasm";

  auto parseResult = WATParser::parseModule(wasm, moduleText);
  ASSERT_FALSE(parseResult.getErr());

  auto* caller = wasm.getFunction("caller");
  ASSERT_NE(caller, nullptr);

  // With stack switching enabled, unknown calls conservatively assume
  // suspension.
  wasm.features.setStackSwitching(true);
  EffectAnalyzer effectsWithStackSwitch(options, wasm, caller->body);
  EXPECT_TRUE(effectsWithStackSwitch.suspends);

  // With stack switching disabled, calls do not suspend.
  wasm.features.setStackSwitching(false);
  EffectAnalyzer effectsWithoutStackSwitch(options, wasm, caller->body);
  EXPECT_FALSE(effectsWithoutStackSwitch.suspends);
}

TEST_F(EffectAnalyzerTest, MayNotReturnOrdering) {
  auto moduleText = R"wasm(
    (module
      (memory 1 1 shared)
      (global $g (mut i32) (i32.const 0))
      (func $callee)
      (func $test (param $x i32) (param $y i32)
        (loop $l1
          (br_if $l1 (local.get $x))
        )
        (loop $l2
          (br_if $l2 (local.get $y))
        )
        (drop (i32.div_s (i32.const 1) (local.get $y)))
        (call $callee)
        (global.set $g (i32.const 1))
        (local.set $y (i32.const 2))
        (drop (memory.atomic.wait32 (i32.const 0) (i32.const 0) (i64.const -1)))
      )
    )
  )wasm";

  auto parseResult = WATParser::parseModule(wasm, moduleText);
  ASSERT_FALSE(parseResult.getErr());

  auto* func = wasm.getFunction("test");
  ASSERT_NE(func, nullptr);
  auto* block = func->body->cast<Block>();
  ASSERT_EQ(block->list.size(), 7u);

  auto* loop1 = block->list[0];
  auto* loop2 = block->list[1];
  auto* trapExpr = block->list[2];
  auto* callExpr = block->list[3];
  auto* globalSetExpr = block->list[4];
  auto* localSetExpr = block->list[5];
  auto* waitExpr = block->list[6];

  EffectAnalyzer loop1Effects(options, wasm, loop1);
  EffectAnalyzer loop2Effects(options, wasm, loop2);
  EffectAnalyzer trapEffects(options, wasm, trapExpr);
  EffectAnalyzer callEffects(options, wasm, callExpr);
  EffectAnalyzer globalSetEffects(options, wasm, globalSetExpr);
  EffectAnalyzer localSetEffects(options, wasm, localSetExpr);
  EffectAnalyzer waitEffects(options, wasm, waitExpr);

  EXPECT_THAT(&loop1Effects, MayNotReturn());
  EXPECT_FALSE(loop1Effects.transfersControlFlow());
  EXPECT_THAT(&waitEffects, MayNotReturn());

  // Cannot reorder mayNotReturn with traps, calls, or global writes.
  EXPECT_TRUE(loop1Effects.orderedBefore(trapEffects));
  EXPECT_TRUE(trapEffects.orderedBefore(loop1Effects));
  EXPECT_FALSE(EffectAnalyzer::canReorder(options, wasm, loop1, trapExpr));
  EXPECT_FALSE(EffectAnalyzer::canReorder(options, wasm, trapExpr, loop1));

  // Even with trapsNeverHappen, mayNotReturn (including atomic.wait) cannot be
  // reordered with a trap.
  PassOptions tnhOptions = options;
  tnhOptions.trapsNeverHappen = true;
  EXPECT_FALSE(EffectAnalyzer::canReorder(tnhOptions, wasm, loop1, trapExpr));
  EXPECT_FALSE(EffectAnalyzer::canReorder(tnhOptions, wasm, trapExpr, loop1));
  EXPECT_FALSE(
    EffectAnalyzer::canReorder(tnhOptions, wasm, waitExpr, trapExpr));
  EXPECT_FALSE(
    EffectAnalyzer::canReorder(tnhOptions, wasm, trapExpr, waitExpr));

  EXPECT_TRUE(loop1Effects.orderedBefore(callEffects));
  EXPECT_TRUE(callEffects.orderedBefore(loop1Effects));
  EXPECT_FALSE(EffectAnalyzer::canReorder(options, wasm, loop1, callExpr));
  EXPECT_FALSE(EffectAnalyzer::canReorder(options, wasm, callExpr, loop1));

  EXPECT_TRUE(loop1Effects.orderedBefore(globalSetEffects));
  EXPECT_TRUE(globalSetEffects.orderedBefore(loop1Effects));
  EXPECT_FALSE(EffectAnalyzer::canReorder(options, wasm, loop1, globalSetExpr));
  EXPECT_FALSE(EffectAnalyzer::canReorder(options, wasm, globalSetExpr, loop1));

  // Can reorder mayNotReturn with unrelated local writes or another pure
  // mayNotReturn.
  EXPECT_FALSE(loop1Effects.orderedBefore(localSetEffects));
  EXPECT_FALSE(localSetEffects.orderedBefore(loop1Effects));
  EXPECT_TRUE(EffectAnalyzer::canReorder(options, wasm, loop1, localSetExpr));
  EXPECT_TRUE(EffectAnalyzer::canReorder(options, wasm, localSetExpr, loop1));

  EXPECT_FALSE(loop1Effects.orderedBefore(loop2Effects));
  EXPECT_FALSE(loop2Effects.orderedBefore(loop1Effects));
  EXPECT_TRUE(EffectAnalyzer::canReorder(options, wasm, loop1, loop2));
  EXPECT_TRUE(EffectAnalyzer::canReorder(options, wasm, loop2, loop1));
}

} // anonymous namespace
