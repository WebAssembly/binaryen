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

  // $A had unknown effects since it wasn't present in indirectCallEffects. So
  // $B's effects become unknown too.
  EXPECT_THAT(merged, IsEmpty());
}

TEST_F(IndirectCallEffectsTest, DestHasUnknownEffects) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;

  auto merged =
    updateEffects(/*oldEffects=*/{{"A", effectsA}}, /*typeMap=*/{{"A", "B"}});

  // $B's effects are unknown and $B is not a new type (see the test fixure; $B
  // already existed in the module), so when $A is merged with $B, the result
  // still has unknown effects.
  EXPECT_THAT(merged, IsEmpty());
}

TEST_F(IndirectCallEffectsTest, BothHaveEffects) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;
  auto effectsB = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsB->writesMemory = true;

  auto merged = updateEffects(/*oldEffects=*/{{"A", effectsA}, {"B", effectsB}},
                              /*typeMap=*/{{"A", "B"}});

  // $A is rewritten to $B, so $B gains the effects of $A, and $A no longer has
  // effects.
  EXPECT_THAT(merged,
              UnorderedElementsAre(Pair("B", AllOf(Calls(), WritesMemory()))));
}

TEST_F(IndirectCallEffectsTest, MapToNewType) {
  auto effectsA = std::make_shared<EffectAnalyzer>(options, wasm);
  effectsA->calls = true;

  auto merged = updateEffects(/*oldEffects=*/{{"A", effectsA}},
                              /*typeMap=*/{{"A", "new type"}});

  // $A is rewritten to a new type that didn't previously exist in the module.
  // Because the type is brand new, we do *not* treat its absence in
  // `indirectCallEffects` as 'unknown effects' like in `DestHasUnknownEffects`.
  // Instead $"new type" just gains $A's effects. We do a pointer comparison
  // here since the effects object can be re-used unchanged.
  EXPECT_THAT(merged, UnorderedElementsAre(Pair("new type", effectsA)));
}

TEST_F(IndirectCallEffectsTest, MapToNewTypeUnknownEffects) {
  auto merged = updateEffects(/*oldEffects=*/{},
                              /*typeMap=*/{{"A", "new type"}});

  // Like `MapToNewType`, except the source type $A has unknown effects. Because
  // $A *is* present in the module, its absence in `indirectCallEffects` does
  // mean that its effects are unknown (GlobalEffects never computed it, maybe
  // because $A didn't exist at the time that it ran). As a result $"new type"
  // has unknown effects.
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

  // Like `BothHaveEffects`, except that the two types are both mapped into one
  // new type. The new type inherits the effects of both source types.
  EXPECT_THAT(
    merged,
    UnorderedElementsAre(Pair("new type", AllOf(Calls(), WritesMemory()))));
}
