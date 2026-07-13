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
#include "ir/type-updating.h"
#include "matchers/effects.h"
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
        (func $f_a (type $A))
        (func $f_b (type $B))
        (func $f_c (type $C))
        (func $f_d (type $D))
      )
    )wasm";

    if (auto err = wasm::WATParser::parseModule(wasm, moduleText).getErr()) {
      Fatal() << err->msg;
    }
  }

  // Helper function to test the updating logic for `indirectCallEffects`. Given
  // that the original module has `indirectCallEffects` given by `oldEffects`,
  // rewrite the module's types using GlobalTypeRewriter::mapTypes according to
  // `typeMap` and return the updated `indirectCallEffects` map.
  std::unordered_map<std::string, std::shared_ptr<const EffectAnalyzer>>
  updateEffects(
    const std::unordered_map<std::string,
                             std::shared_ptr<const EffectAnalyzer>>& oldEffects,
    const std::unordered_map<std::string, std::string>& typeMap) {

    std::unordered_map<std::string, HeapType> types;
    std::unordered_map<HeapType, std::string> typeNames;
    for (const auto& [type, name] : wasm.typeNames) {
      types[name.name.toString()] = type;
      typeNames[type] = name.name.toString();
    }

    // Type that previously didn't exist in the module.
    // This is a new type created by GlobalTypeRewriter.
    {
      TypeBuilder builder(1);
      builder.setHeapType(0, Signature(Type::i32, Type::i32));
      HeapType newType = (*builder.build())[0];
      types["new type"] = newType;
      typeNames[newType] = "new type";
    }

    for (const auto& [name, effects] : oldEffects) {
      wasm.indirectCallEffects[types.at(name)] = effects;
    }

    GlobalTypeRewriter::TypeMap map;
    for (const auto& [oldName, newName] : typeMap) {
      HeapType oldType = types.at(oldName);
      map[oldType] = types.at(newName);
    }

    GlobalTypeRewriter rewriter(wasm, WorldMode::Open);
    rewriter.mapTypes(map);

    std::unordered_map<std::string, std::shared_ptr<const EffectAnalyzer>>
      result;
    for (const auto& [type, effects] : wasm.indirectCallEffects) {
      auto name = typeNames.at(type);
      result[name] = effects;
    }
    return result;
  }
};

} // anonymous namespace

TEST_F(IndirectCallEffectsTest, SrcHasUnknownEffects) {
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;

  auto merged =
    updateEffects(/*oldEffects=*/{{"B", effectsB}}, /*typeMap=*/{{"A", "B"}});

  EXPECT_THAT(merged, IsEmpty());
}

TEST_F(IndirectCallEffectsTest, DestHasUnknownEffects) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;

  auto merged =
    updateEffects(/*oldEffects=*/{{"A", effectsA}}, /*typeMap=*/{{"A", "B"}});

  EXPECT_THAT(merged, IsEmpty());
}

TEST_F(IndirectCallEffectsTest, BothHaveEffects) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;

  auto merged = updateEffects(/*oldEffects=*/{{"A", effectsA}, {"B", effectsB}},
                              /*typeMap=*/{{"A", "B"}});

  EXPECT_THAT(merged,
              UnorderedElementsAre(Pair("B", AllOf(Calls(), WritesMemory()))));
}

TEST_F(IndirectCallEffectsTest, MapToNewType) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;

  auto merged = updateEffects(/*oldEffects=*/{{"A", effectsA}},
                              /*typeMap=*/{{"A", "new type"}});

  // Pointer comparison
  EXPECT_THAT(merged, UnorderedElementsAre(Pair("new type", effectsA)));
}

TEST_F(IndirectCallEffectsTest, MapToNewTypeNoEffects) {
  auto merged = updateEffects(/*oldEffects=*/{},
                              /*typeMap=*/{{"A", "new type"}});

  EXPECT_THAT(merged, IsEmpty());
}

TEST_F(IndirectCallEffectsTest, MergeNewTypeAndExisting) {
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;

  auto merged =
    updateEffects(/*oldEffects=*/{{"B", effectsB}},
                  /*typeMap=*/{{"A", "new type"}, {"B", "new type"}});

  // Type A already had unknown effects, so the new type remains unknown.
  EXPECT_THAT(merged, IsEmpty());
}

TEST_F(IndirectCallEffectsTest, MergeNewTypeAndExistingWithEffects) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;

  auto merged =
    updateEffects(/*oldEffects=*/{{"A", effectsA}, {"B", effectsB}},
                  /*typeMap=*/{{"A", "new type"}, {"B", "new type"}});

  EXPECT_THAT(
    merged,
    UnorderedElementsAre(Pair("new type", AllOf(Calls(), WritesMemory()))));
}
