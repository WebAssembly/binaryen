/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "gtest/gtest.h"

#include "ir/effects.h"
#include "ir/type-updating.h"
#include "parser/wat-parser.h"
#include "support/result.h"
#include "wasm.h"

using namespace wasm;
using namespace testing;

namespace {

class IndirectCallEffectsTest : public Test {
protected:
  Module wasm;
  PassOptions options;

  void SetUp() override {
    auto moduleText = R"wasm(
      (module
        (rec
          (type $A (func))
          (type $B (func))
          (type $C (func))
          (type $D (func))
        )
      )
    )wasm";

    if (auto err = wasm::WATParser::parseModule(wasm, moduleText).getErr()) {
      Fatal() << err->msg;
    }
  }

  std::unordered_map<std::string, std::shared_ptr<const EffectAnalyzer>>
  updateEffects(
    const std::unordered_map<std::string,
                             std::shared_ptr<const EffectAnalyzer>>& oldEffects,
    const std::unordered_map<std::string, std::string>& typeMap) {

    std::unordered_map<Name, HeapType> types;
    for (const auto& [type, name] : wasm.typeNames) {
      types[name.name] = type;
    }

    for (const auto& [name, effects] : oldEffects) {
      wasm.indirectCallEffects[types.at(name)] = effects;
    }

    GlobalTypeRewriter::TypeMap map;
    for (const auto& [oldName, newName] : typeMap) {
      map[types.at(oldName)] = types.at(newName);
    }

    GlobalTypeRewriter rewriter(wasm, WorldMode::Open);
    rewriter.mapTypes(map);

    std::unordered_map<std::string, std::shared_ptr<const EffectAnalyzer>>
      result;
    for (const auto& [type, effects] : wasm.indirectCallEffects) {
      auto name = wasm.typeNames.at(type).name.toString();
      result[name] = effects;
    }
    return result;
  }
};

} // anonymous namespace

TEST_F(IndirectCallEffectsTest, SrcHasNoEffects) {
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;

  auto merged =
    updateEffects(/*oldEffects=*/{{"B", effectsB}}, /*typeMap=*/{{"A", "B"}});

  EXPECT_FALSE(merged.contains("A"));
  ASSERT_TRUE(merged.contains("B"));

  // Pointer comparison
  EXPECT_EQ(merged.at("B"), effectsB);
}

TEST_F(IndirectCallEffectsTest, DestHasNoEffects) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;

  auto merged =
    updateEffects(/*oldEffects=*/{{"A", effectsA}}, /*typeMap=*/{{"A", "B"}});

  EXPECT_FALSE(merged.contains("A"));
  ASSERT_TRUE(merged.contains("B"));

  // Pointer comparison
  EXPECT_EQ(merged.at("B"), effectsA);
}

TEST_F(IndirectCallEffectsTest, BothHaveNoEffects) {
  auto merged = updateEffects(/*oldEffects=*/{}, /*typeMap=*/{{"A", "B"}});

  EXPECT_FALSE(merged.contains("A"));
  EXPECT_FALSE(merged.contains("B"));
}

TEST_F(IndirectCallEffectsTest, BothHaveEffects) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;

  auto merged = updateEffects(/*oldEffects=*/{{"A", effectsA}, {"B", effectsB}},
                              /*typeMap=*/{{"A", "B"}});

  EXPECT_FALSE(merged.contains("A"));
  ASSERT_TRUE(merged.contains("B"));
  EXPECT_TRUE(merged.at("B")->calls);
  EXPECT_TRUE(merged.at("B")->writesMemory);
}

TEST_F(IndirectCallEffectsTest, SrcHasNullptrEffects) {
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;

  auto merged = updateEffects(/*oldEffects=*/{{"A", nullptr}, {"B", effectsB}},
                              /*typeMap=*/{{"A", "B"}});

  EXPECT_FALSE(merged.contains("A"));
  ASSERT_TRUE(merged.contains("B"));
  EXPECT_EQ(merged.at("B"), nullptr);
}

TEST_F(IndirectCallEffectsTest, DestHasNullptrEffects) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;

  auto merged = updateEffects(/*oldEffects=*/{{"A", effectsA}, {"B", nullptr}},
                              /*typeMap=*/{{"A", "B"}});

  EXPECT_FALSE(merged.contains("A"));
  ASSERT_TRUE(merged.contains("B"));
  EXPECT_EQ(merged.at("B"), nullptr);
}

TEST_F(IndirectCallEffectsTest, MergeThreeTypes) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;
  auto effectsC = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsC->throws_ = true;

  auto merged = updateEffects(
    /*oldEffects=*/{{"A", effectsA}, {"B", effectsB}, {"C", effectsC}},
    /*typeMap=*/{{"A", "D"}, {"B", "D"}, {"C", "D"}});

  EXPECT_FALSE(merged.contains("A"));
  EXPECT_FALSE(merged.contains("B"));
  EXPECT_FALSE(merged.contains("C"));
  ASSERT_TRUE(merged.contains("D"));
  EXPECT_TRUE(merged.at("D")->calls);
  EXPECT_TRUE(merged.at("D")->writesMemory);
  EXPECT_TRUE(merged.at("D")->throws_);
}
