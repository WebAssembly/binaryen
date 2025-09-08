/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "source-map.h"
#include "print-test.h"
#include "gmock/gmock-matchers.h"
#include "gtest/gtest.h"

using namespace wasm;

class SourceMapTest : public PrintTest {
  std::vector<char> buffer;

protected:
  Module wasm;
  std::unique_ptr<SourceMapReader> reader;

  void SetUp() override {
    PrintTest::SetUp();
    reader.reset();
    parseWast(wasm, "(module)");
  }

  void parseMap(std::string& sourceMap) {
    buffer = {sourceMap.begin(), sourceMap.end()};
    reader.reset(new SourceMapReader(buffer));
    reader->parse(wasm);
  }

  void ExpectDbgLocEq(size_t location,
                      BinaryLocation file,
                      BinaryLocation line,
                      BinaryLocation col,
                      std::optional<BinaryLocation> sym) {
    auto loc_str = std::stringstream() << "location: " << location;
    SCOPED_TRACE(loc_str.str());
    auto loc = reader->readDebugLocationAt(location);
    ASSERT_TRUE(loc.has_value());
    EXPECT_EQ(loc->fileIndex, file);
    EXPECT_EQ(loc->lineNumber, line);
    EXPECT_EQ(loc->columnNumber, col);
    EXPECT_EQ(loc->symbolNameIndex, sym);
  }

  void ExpectParseError(std::string& mapString, const char* expectedError) {
    SCOPED_TRACE(mapString);
    EXPECT_THROW(parseMap(mapString), MapParseException);
    try {
      parseMap(mapString);
    } catch (MapParseException ex) {
      EXPECT_THAT(ex.errorText, ::testing::HasSubstr(expectedError));
    }
  }
};

// Check that debug location parsers can handle single-segment mappings.
TEST_F(SourceMapTest, SourceMappingSingleSegment) {
  // A single-segment mapping starting at offset 0.
  std::string sourceMap = R"(
      {
          "version": 3,
          "sources": [],
          "sourcesContent": [],
          "names": [],
          "mappings": "A"
      }
  )";
  parseMap(sourceMap);

  auto loc = reader->readDebugLocationAt(0);
  EXPECT_FALSE(loc.has_value());
}

TEST_F(SourceMapTest, BadSourceMaps) {
  // Test that a malformed JSON string throws rather than asserting.
  std::string sourceMap = R"(
    {
      "version": 3,
      "sources": ["foo.c"],
      "mappings": ""
    malformed
    }
  )";
  ExpectParseError(sourceMap, "malformed value in JSON object");

  // Valid JSON, but missing the version field.
  sourceMap = R"(
    {
      "sources": [],
      "names": [],
      "mappings": "A"
    }
  )";
  ExpectParseError(sourceMap, "Source map version missing");

  // Valid JSON, but a bad "sources" field.
  sourceMap = R"(
    {
      "version": 3,
      "sources": 123,
      "mappings": ""
    }
  )";
  ExpectParseError(sourceMap, "Source map sources missing or not an array");

  sourceMap = R"(
    {
      "version": 3,
      "sources": ["foo.c"],
      "mappings": "C;A"
    }
  )";
  parseMap(sourceMap);
  // Mapping strings are parsed incrementally, so errors don't show up until a
  // sufficiently far-advanced location is requested to reach the problem.
  EXPECT_THROW(reader->readDebugLocationAt(1), MapParseException);
}

TEST_F(SourceMapTest, SourcesAndNames) {
  std::string sourceMap = R"(
    {
      "version": 3,
      "sources": ["foo.c", "bar.c"],
      "names": ["foo", "bar"],
      "mappings": ""
    }
  )";
  parseMap(sourceMap);

  EXPECT_EQ(wasm.debugInfoFileNames.size(), 2);
  EXPECT_EQ(wasm.debugInfoFileNames[0], "foo.c");
  EXPECT_EQ(wasm.debugInfoFileNames[1], "bar.c");
  EXPECT_EQ(wasm.debugInfoSymbolNames.size(), 2);
  EXPECT_EQ(wasm.debugInfoSymbolNames[0], "foo");
  EXPECT_EQ(wasm.debugInfoSymbolNames[1], "bar");
}

TEST_F(SourceMapTest, OptionalFields) {
  // The "names" field is optional.
  std::string sourceMap = R"(
    {
      "version": 3,
      "sources": [],
      "mappings": "A"
    }
  )";
  parseMap(sourceMap);
}

// This map is taken from test/fib-dbg.wasm
TEST_F(SourceMapTest, Fibonacci) {
  // Test mapping parsing and debug locs
  std::string sourceMap = R"(
    {
      "version":3,
      "sources":["fib.c"],
      "names":[],
      "mappings": "moBAEA,4BAKA,QAJA,OADA,OAAA,uCAKA"
    }
  )";
  parseMap(sourceMap);

  // Location before the first record has no value
  auto loc = reader->readDebugLocationAt(642);
  EXPECT_FALSE(loc.has_value());

  // TODO: These column numbers show as 0 but emsymbolizer.py prints them as 1.
  // Figure out which is right.
  // First location
  ExpectDbgLocEq(643, 0, 3, 0, std::nullopt);
  // locations in between records have the same value as the previous one.
  for (size_t l = 644; l < 671; l++) {
    ExpectDbgLocEq(l, 0, 3, 0, std::nullopt);
  }
  // Subsequent ones are on record boundaries
  ExpectDbgLocEq(671, 0, 8, 0, std::nullopt);
  ExpectDbgLocEq(679, 0, 4, 0, std::nullopt);
  ExpectDbgLocEq(686, 0, 3, 0, std::nullopt);
  ExpectDbgLocEq(693, 0, 3, 0, std::nullopt);
  ExpectDbgLocEq(732, 0, 8, 0, std::nullopt);
  // Entries after the last record have the same value as the last one.
  ExpectDbgLocEq(733, 0, 8, 0, std::nullopt);
  // Should we return empty values for locations that are past the end of the
  // program?
  ExpectDbgLocEq(9999, 0, 8, 0, std::nullopt);
}

TEST_F(SourceMapTest, SourceMapSourceRootFile) {
  std::string sourceMap = R"(
    {
      "version":3,
      "file": "foo.wasm",
      "sources":[],
      "names":[],
      "mappings": "",
      "sourceRoot": "/foo/bar"
    }
  )";
  parseMap(sourceMap);
  EXPECT_EQ(wasm.debugInfoSourceRoot, "/foo/bar");
  EXPECT_EQ(wasm.debugInfoFile, "foo.wasm");
}

TEST_F(SourceMapTest, SourcesContent) {
  // The backslash escapes appear in the JSON encoding, and are preserved in
  // the internal representation. The string values are uninterpreted in
  // Binaryen, and they are written directly back out without re-encoding.
  std::string sourceMap = R"(
   {
     "version": 3,
     "sources": ["foo.c"],
     "sourcesContent": ["#include <stdio.h> int main()\n{ printf(\"Gr\u00fc\u00df Gott, Welt!\"); return 0;}"],
     "mappings" : ""
   }
  )";
  parseMap(sourceMap);
  ASSERT_EQ(wasm.debugInfoSourcesContent.size(), 1);
  EXPECT_EQ(wasm.debugInfoSourcesContent[0],
            "#include <stdio.h> int main()\\n{ printf(\\\"Gr\\u00fc\\u00df "
            "Gott, Welt!\\\"); return 0;}");
}
