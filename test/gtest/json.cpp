#include "support/json.h"
#include "gtest/gtest.h"

using JSONTest = ::testing::Test;

TEST_F(JSONTest, Stringify) {
  // TODO: change the API to not require a copy
  auto input = "[\"hello\",\"world\"]";
  auto* copy = strdup(input);
  json::Value value;
  value.parse(copy, json::Value::ASCII);
  std::stringstream ss;
  value.stringify(ss);
  EXPECT_EQ(ss.str(), input);
  free(copy);
}
