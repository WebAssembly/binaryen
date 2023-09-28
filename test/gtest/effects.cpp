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

  EXPECT_EQ(a, a);

  // Test that a change to a field causes us to compare not equal.

#define TEST_CHANGE(FIELD, VALUE)                                              \
  {                                                                            \
    auto b = a;                                                                \
    EXPECT_EQ(b, a);                                                           \
    b.FIELD = VALUE;                                                           \
    EXPECT_NE(b, a);                                                           \
  }

  TEST_CHANGE(branchesOut, false);
  TEST_CHANGE(calls, false);
  TEST_CHANGE(readsMemory, false);
  TEST_CHANGE(writesMemory, false);
  TEST_CHANGE(readsTable, false);
  TEST_CHANGE(writesTable, false);
  TEST_CHANGE(readsMutableStruct, false);
  TEST_CHANGE(writesStruct, false);
  TEST_CHANGE(readsArray, false);
  TEST_CHANGE(writesArray, false);
  TEST_CHANGE(trap, false);
  TEST_CHANGE(implicitTrap, false);
  TEST_CHANGE(trapsNeverHappen, false);
  TEST_CHANGE(isAtomic, false);
  TEST_CHANGE(throws_, false);
  TEST_CHANGE(danglingPop, false);
  TEST_CHANGE(localsRead, {54321});
  TEST_CHANGE(localsWritten, {12345});
  TEST_CHANGE(mutableGlobalsRead, {"glob2"});
  TEST_CHANGE(globalsWritten, {"other2"});
  TEST_CHANGE(breakTargets, {"block2"});
  TEST_CHANGE(delegateTargets, {"delegate2"});
}
