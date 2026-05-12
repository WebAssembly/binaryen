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

static void
checkOutput(json::Value::Ref ref, std::string expected, bool pretty = false) {
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
  array->push_back(json::Value::make()); // null
  checkOutput(array, "[42,\"1337\",null]");
  checkPrettyOutput(array, R"([
 42,
 "1337",
 null
])");
}

TEST_F(JSONTest, StringifyObject) {
  auto object = json::Value::makeObject();
  object["foo"] = json::Value::make(42);
  object["bar"] = json::Value::make("1337");
  checkOutput(object, "{\"foo\":42,\"bar\":\"1337\"}");
  checkPrettyOutput(object, R"({
 "foo": 42,
 "bar": "1337"
})");
}

TEST_F(JSONTest, StringifyNesting) {
  auto array = json::Value::makeArray();
  auto object = json::Value::makeObject();
  auto array1 = json::Value::makeArray();
  auto object1 = json::Value::makeObject();
  array->push_back(object);
  object["body"] = array1;
  array1->push_back(object1);
  object1["value"] = json::Value::make(42);
  checkPrettyOutput(array, R"([
 {
  "body": [
   {
    "value": 42
   }
  ]
 }
])");
}
