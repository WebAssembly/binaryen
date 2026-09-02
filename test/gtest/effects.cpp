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
  EXPECT_TRUE(effects.suspends());
  EXPECT_THAT(&effects, Suspends());
  EXPECT_TRUE(effects.getSideEffects() & EffectAnalyzer::SideEffects::Suspends);

  // Decoupled from call graph edges
  EXPECT_FALSE(effects.calls);
  EXPECT_THAT(&effects, Not(Calls()));

  // Clobbers all global mutable state
  EXPECT_TRUE(effects.readsMemory);
  EXPECT_TRUE(effects.writesMemory);
  EXPECT_TRUE(effects.readsSharedMemory);
  EXPECT_TRUE(effects.writesSharedMemory);
  EXPECT_TRUE(effects.readsTable);
  EXPECT_TRUE(effects.writesTable);
  EXPECT_TRUE(effects.readsMutableStruct);
  EXPECT_TRUE(effects.writesStruct);
  EXPECT_TRUE(effects.readsSharedMutableStruct);
  EXPECT_TRUE(effects.writesSharedStruct);
  EXPECT_TRUE(effects.readsMutableArray);
  EXPECT_TRUE(effects.writesArray);
  EXPECT_TRUE(effects.readsSharedMutableArray);
  EXPECT_TRUE(effects.writesSharedArray);
  EXPECT_TRUE(effects.writesGlobalState());
  EXPECT_TRUE(effects.readsMutableGlobalState());

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
  EXPECT_TRUE(effectsWithStackSwitch.suspends());

  // With stack switching disabled, calls do not suspend.
  wasm.features.setStackSwitching(false);
  EffectAnalyzer effectsWithoutStackSwitch(options, wasm, caller->body);
  EXPECT_FALSE(effectsWithoutStackSwitch.suspends());
}

} // anonymous namespace
