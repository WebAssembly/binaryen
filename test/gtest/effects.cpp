#include <iostream>

#include "ir/effects.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

class EffectsTest : public testing::Test {};

TEST_F(EffectsTest, TestEquality) {
  PassOptions options;
  Module wasm;
  EffectAnalyzer a(options, wasm);

  // Initialize some data.
  a.branchesOut = true;
  a.calls = true;
  a.readsMemory = true;
  a.writesMemory = true;
  a.readsTable = true;
  a.writesTable = true;
  a.readsMutableStruct = true;
  a.writesStruct = true;
  a.readsArray = true;
  a.writesArray = true;
  a.trap = true;
  a.implicitTrap = true;
  a.trapsNeverHappen = true;
  a.isAtomic = true;
  a.throws_ = true;
  a.danglingPop = true;
  a.localsRead = {42};
  a.localsWritten = {99};
  a.mutableGlobalsRead = {"glob"};
  a.globalsWritten = {"other"};
  a.breakTargets = {"block"};
  a.delegateTargets = {"delegate"};

  EXPECT_TRUE(a == a);
  EXPECT_EQ(a, a);
}
