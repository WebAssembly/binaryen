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

#include <string>
#include <vector>

#include "support/js-embedded-module.h"
#include "gtest/gtest.h"

using namespace wasm;

namespace {

std::vector<char> makeBytes(std::initializer_list<uint8_t> list) {
  std::vector<char> result;
  result.reserve(list.size());
  for (uint8_t b : list) {
    result.push_back(static_cast<char>(b));
  }
  return result;
}

} // namespace

TEST(JsEmbeddedModuleTest, HexArrayLiteral) {
  std::string js = R"(
    let bytes = new Uint8Array([
      0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00
    ]);
  )";

  auto modules = findEmbeddedModules(js);
  ASSERT_EQ(modules.size(), 1u);
  EXPECT_EQ(modules[0].bytes,
            makeBytes({0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00}));
  EXPECT_EQ(js[modules[0].start], '[');
  EXPECT_EQ(js[modules[0].end - 1], ']');
}

TEST(JsEmbeddedModuleTest, VariousNumericFormatsAndTrailingComma) {
  std::string js = R"(
    var raw = [
      0, 97, 115, 109,
      0o1, 0b0000_0000, +1, -1, -128, 0Xff,
    ];
  )";

  auto modules = findEmbeddedModules(js);
  ASSERT_EQ(modules.size(), 1u);
  EXPECT_EQ(
    modules[0].bytes,
    makeBytes({0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x01, 0xff, 0x80, 0xff}));
}

TEST(JsEmbeddedModuleTest, InnerCommentsAndWhitespace) {
  std::string js = R"(
    const buf = [
      // Wasm magic
      0x00, 0x61, /* 'a' */ 0x73, 0x6d,
      /* version 1 */
      0x01, 0x00, 0x00, 0x00 // end of header
      /* trailing comment */
    ];
  )";

  auto modules = findEmbeddedModules(js);
  ASSERT_EQ(modules.size(), 1u);
  EXPECT_EQ(modules[0].bytes,
            makeBytes({0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00}));
}

TEST(JsEmbeddedModuleTest, IgnoresStringsAndComments) {
  std::string js = R"(
    // [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x01]
    /*
      [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x02]
    */
    const s1 = "[0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x03]";
    const s2 = 'escaped \' [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x04]';
    const s3 = `multiline template \`
      [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x05]
    `;
    const actual = [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x06];
  )";

  auto modules = findEmbeddedModules(js);
  ASSERT_EQ(modules.size(), 1u);
  EXPECT_EQ(modules[0].bytes,
            makeBytes({0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x06}));
}

TEST(JsEmbeddedModuleTest, EarlyRejectionAndNestedArrays) {
  std::string js = R"(
    let empty = [];
    let tooShort = [0x00, 0x61, 0x73];
    let nonWasm = [1, 2, 3, 4, 5, 6, 7, 8];
    let wrongMagic = [0x00, 0x61, 0x73, 0x6e, 1, 0, 0, 1];
    let outOfRangePos = [0x00, 0x61, 0x73, 0x6d, 256, 0, 0, 2];
    let outOfRangeNeg = [0x00, 0x61, 0x73, 0x6d, -129, 0, 0, 3];
    let nonConstant = [0x00, 0x61, 0x73, 0x6d, foo(), 0, 0, 4];
    let nested = [[0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x05]];
  )";

  auto modules = findEmbeddedModules(js);
  ASSERT_EQ(modules.size(), 1u);
  EXPECT_EQ(modules[0].bytes,
            makeBytes({0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x05}));
  EXPECT_EQ(js.substr(modules[0].start, modules[0].end - modules[0].start),
            "[0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x05]");
}

TEST(JsEmbeddedModuleTest, MultiModuleReverseOrderSplicing) {
  std::string js = R"(
    const m0 = new Uint8Array([0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0a]);
    const m1 = new Uint8Array([0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0b]);
    const m2 = new Uint8Array([0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0c]);
  )";

  auto modules = findEmbeddedModules(js);
  ASSERT_EQ(modules.size(), 3u);
  EXPECT_EQ(static_cast<uint8_t>(modules[0].bytes.back()), 0x0au);
  EXPECT_EQ(static_cast<uint8_t>(modules[1].bytes.back()), 0x0bu);
  EXPECT_EQ(static_cast<uint8_t>(modules[2].bytes.back()), 0x0cu);

  // Replace from last to first without rescanning, verifying earlier offsets do
  // not drift.
  auto reducedBytes =
    makeBytes({0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00});
  std::string formatted = formatByteArray(reducedBytes);

  for (size_t i = modules.size(); i > 0; --i) {
    const auto& mod = modules[i - 1];
    js.replace(mod.start, mod.end - mod.start, formatted);
  }

  auto rescanned = findEmbeddedModules(js);
  ASSERT_EQ(rescanned.size(), 3u);
  for (const auto& mod : rescanned) {
    EXPECT_EQ(mod.bytes, reducedBytes);
  }
}

TEST(JsEmbeddedModuleTest, FormatByteArray) {
  EXPECT_EQ(formatByteArray({}), "[]");

  auto bytes24 = makeBytes({0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00,
                            0x01, 0x04, 0x01, 0x60, 0x00, 0x00, 0x03, 0x02,
                            0x01, 0x00, 0x0a, 0x04, 0x01, 0x02, 0x00, 0x0b});
  std::string expected24 =
    "[\n"
    "  0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x04, 0x01, 0x60, "
    "0x00, 0x00, 0x03, 0x02,\n"
    "  0x01, 0x00, 0x0a, 0x04, 0x01, 0x02, 0x00, 0x0b\n"
    "]";
  EXPECT_EQ(formatByteArray(bytes24), expected24);

  // Round-trip formatted array back through findEmbeddedModules.
  auto parsed = findEmbeddedModules(expected24);
  ASSERT_EQ(parsed.size(), 1u);
  EXPECT_EQ(parsed[0].bytes, bytes24);
}
