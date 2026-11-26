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

#include <algorithm>
#include <string>
#include <vector>

#include "parser/wat-parser.h"
#include "pass.h"
#include "wasm-binary.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

// The field names of a struct must be emitted in increasing field index order.
TEST(NameSectionTest, FieldNamesSorted) {
  auto moduleText = R"wasm(
    (module
      (type $s (struct (field $field_zero i32)
                       (field $field_one i32)
                       (field $field_two i32)
                       (field $field_three i32)))
      (global $g (ref null $s) (ref.null none))
    )
  )wasm";

  Module wasm;
  wasm.features = FeatureSet::All;
  auto parseResult = WATParser::parseModule(wasm, moduleText);
  ASSERT_FALSE(parseResult.getErr());

  BufferWithRandomAccess buffer;
  PassOptions options;
  WasmBinaryWriter writer(&wasm, buffer, options);
  writer.setNamesSection(true);
  writer.write();

  std::string bytes(buffer.begin(), buffer.end());
  std::vector<size_t> positions;
  for (auto* name : {"field_zero", "field_one", "field_two", "field_three"}) {
    auto pos = bytes.find(name);
    ASSERT_NE(pos, std::string::npos) << name;
    positions.push_back(pos);
  }
  EXPECT_TRUE(std::is_sorted(positions.begin(), positions.end()));
}
