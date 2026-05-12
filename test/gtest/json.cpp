#include "support/json.h"
#include "gtest/gtest.h"

using JSONTest = ::testing::Test;

TEST_F(JSONTest, RoundtripString) {
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

static void checkOutput(json::Value::Ref ref, std::string expected, bool pretty=false) {
  std::stringstream ss;
  ref->stringify(ss, pretty);
  EXPECT_EQ(ss.str(), expected);
}

static void checkPrettyOutput(json::Value::Ref ref, std::string expected) {
  checkOutput(ref, expected, true);
}

TEST_F(JSONTest, StringifyArray) {
  auto array = json::Value::makeArray();
  array->push_back(json::Value::make(42));
  array->push_back(json::Value::make("1337"));
  checkOutput(array, "[42,\"1337\"]");
  checkPrettyOutput(array, R"([
 42,
 "1337"
])");
}
