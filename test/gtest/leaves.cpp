#include "wasm-traversal.h"
#include "wasm.h"

#include "gtest/gtest.h"

using LeavesTest = ::testing::Test;

using namespace wasm;

TEST_F(LeavesTest, Manual) {
  // Verify some interesting cases manually.

  // LocalGet is a leaf.
  EXPECT_TRUE(IsLeaf<LocalGet>::value);
  // GlobalSet is not a leaf due to a child.
  EXPECT_FALSE(IsLeaf<GlobalSet>::value);
  // Return is not a leaf due to an optional child.
  EXPECT_FALSE(IsLeaf<Return>::value);
  // Call is not a leaf due to a vector of children.
  EXPECT_FALSE(IsLeaf<Call>::value);
}

TEST_F(LeavesTest, Automatic) {
  // Verify them all automatically.

  // Count total expression classes and total with children.
  size_t total = 0, totalWithChildren = 0;

#define DELEGATE_FIELD_CASE_START(id)                                          \
  {                                                                            \
    bool hasChildren = false;

#define DELEGATE_FIELD_CHILD(id, field) hasChildren = true;

#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field) hasChildren = true;

#define DELEGATE_FIELD_CHILD_VECTOR(id, field) hasChildren = true;

  // Verify that IsLeaf has the right value.
#define DELEGATE_FIELD_CASE_END(id)                                            \
    EXPECT_EQ(IsLeaf<id>::value, !hasChildren);                                \
    total++;                                                                   \
    if (hasChildren) {                                                         \
      totalWithChildren++;                                                     \
    }                                                                          \
  }

#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_INT_VECTOR(id, field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)

#define DELEGATE_FIELD_MAIN_START
#define DELEGATE_FIELD_MAIN_END

#include "wasm-delegations-fields.def"

  // Not all have children (this just verifies the macros are actually doing
  // something).
  EXPECT_LT(totalWithChildren, total);
  EXPECT_GT(totalWithChildren, 0);
  EXPECT_GT(total, 0);
}
