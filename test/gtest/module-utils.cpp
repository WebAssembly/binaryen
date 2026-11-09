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

#include "ir/module-utils.h"
#include "parser/wat-parser.h"
#include "wasm.h"

using namespace wasm;
using namespace testing;

namespace {

class ModuleUtilsTest : public Test {
protected:
  Module wasm;

  [[nodiscard]] bool parse(std::string_view text) {
    wasm.features = FeatureSet::All;
    auto parsed = WATParser::parseModule(wasm, text);
    if (auto* err = parsed.getErr()) {
      EXPECT_TRUE(false) << "Failed to parse WAT: " << err->msg;
      return false;
    }
    return true;
  }
};

TEST_F(ModuleUtilsTest, GetReferencedFuncs) {
  auto moduleText = R"wasm(
    (module
      (import "env" "imported" (func $imported))

      (table $table 1 funcref)
      (elem (table $table) (i32.const 0) func $table_func)

      (func $table_func)
      (func $ref_func)
      (func $unreferenced)

      (func $exported
        (drop (ref.func $ref_func))
      )
      (export "exported" (func $exported))
    )
  )wasm";

  ASSERT_TRUE(parse(moduleText));

  auto* tableFunc = wasm.getFunction("table_func");
  auto* refFunc = wasm.getFunction("ref_func");
  auto* exported = wasm.getFunction("exported");
  ASSERT_NE(tableFunc, nullptr);
  ASSERT_NE(refFunc, nullptr);
  ASSERT_NE(exported, nullptr);

  EXPECT_THAT(ModuleUtils::getReferencedFuncs(wasm),
              UnorderedElementsAre(tableFunc, refFunc, exported));
}

} // namespace
