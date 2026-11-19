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
#include "ir/module-utils.h"
#include "pass.h"
#include "print-test.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
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
    ASSERT_FALSE(loc.empty());
    EXPECT_EQ(loc[0].fileIndex, file);
    EXPECT_EQ(loc[0].lineNumber, line);
    EXPECT_EQ(loc[0].columnNumber, col);
    EXPECT_EQ(loc[0].symbolNameIndex, sym);
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
  EXPECT_TRUE(loc.empty());
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

  // VLQ with too many continuation digits. 7 continuation characters ('g')
  // push the shift to 35, exceeding the uint32_t width. This is a malformed
  // VLQ that should be rejected rather than causing undefined behavior.
  sourceMap = R"(
    {
      "version": 3,
      "sources": ["foo.c"],
      "mappings": "gggggggA"
    }
  )";
  ExpectParseError(sourceMap, "VLQ value too large");
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
  EXPECT_TRUE(loc.empty());

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

// Regression test: updateSymbol calls for prologLocation/epilogLocation were
// inside the debugLocations loop instead of outside. When debugLocations is
// empty, the loop never executes and the locations are not updated.
TEST(SourceMapCopyTest, UpdateSymbolOutsideLoop) {
  Module srcModule;
  Module dstModule;
  Builder builder(srcModule);

  auto func = builder.makeFunction(
    "test", {}, Signature(Type::none, Type::none), {}, builder.makeNop());

  // Set prologLocation and epilogLocation with symbolNameIndex values,
  // but leave debugLocations empty.
  func->prologLocation = {
    Function::DebugLocation{0, 1, 1, std::optional<BinaryLocation>(0)}};
  func->epilogLocation = {
    Function::DebugLocation{0, 2, 1, std::optional<BinaryLocation>(1)}};

  // Symbol name index map: 0->10, 1->11.
  std::vector<Index> symbolNameIndexMap = {10, 11};

  auto copied = ModuleUtils::copyFunctionWithoutAdd(
    func.get(), dstModule, Name(), std::nullopt, symbolNameIndexMap);

  ASSERT_FALSE(copied->prologLocation.empty());
  ASSERT_TRUE(copied->prologLocation[0].symbolNameIndex.has_value());
  EXPECT_EQ(*copied->prologLocation[0].symbolNameIndex, 10u);

  ASSERT_FALSE(copied->epilogLocation.empty());
  ASSERT_TRUE(copied->epilogLocation[0].symbolNameIndex.has_value());
  EXPECT_EQ(*copied->epilogLocation[0].symbolNameIndex, 11u);
}

// When debugLocations has multiple entries, updateSymbol should only run once
// per location, not once per loop iteration (which would double-remap).
TEST(SourceMapCopyTest, UpdateSymbolNotDoubleRemapped) {
  Module srcModule;
  Module dstModule;
  Builder builder(srcModule);

  auto func = builder.makeFunction(
    "test", {}, Signature(Type::none, Type::none), {}, builder.makeNop());

  func->prologLocation = {
    Function::DebugLocation{0, 1, 1, std::optional<BinaryLocation>(0)}};

  // Add multiple debug locations so the loop runs multiple times.
  auto* nop1 = srcModule.allocator.alloc<Nop>();
  auto* nop2 = srcModule.allocator.alloc<Nop>();
  func->debugLocations[nop1] = {
    Function::DebugLocation{0, 10, 1, std::optional<BinaryLocation>(0)}};
  func->debugLocations[nop2] = {
    Function::DebugLocation{0, 11, 1, std::optional<BinaryLocation>(1)}};

  // Map: 0->5, 1->6.
  std::vector<Index> symbolNameIndexMap = {5, 6};

  auto copied = ModuleUtils::copyFunctionWithoutAdd(
    func.get(), dstModule, Name(), std::nullopt, symbolNameIndexMap);

  // Should be remapped exactly once: 0 -> 5.
  ASSERT_FALSE(copied->prologLocation.empty());
  ASSERT_TRUE(copied->prologLocation[0].symbolNameIndex.has_value());
  EXPECT_EQ(*copied->prologLocation[0].symbolNameIndex, 5u);
}

TEST_F(SourceMapTest, ScopesAndRangesParsing) {
  // names:
  //   0: "outerFunc"
  //   1: "function"
  //   2: "x"
  //   3: "y"
  //   4: "inlinedFunc"
  //   5: "a"
  //   6: "local_x"
  //   7: "local_y"
  //   8: "local_a"
  //
  // scopes[0] (for "main.dart"):
  //   Scope 0 (outerFunc):
  //     B: flags=7 (name|kind|stackFrame), line=0 (+0 -> line 1), col=0,
  //        nameIdx=0 (+0), kindIdx=1 (+1 -> 'C')
  //     D: vars=[2 (+2 -> 'E'), 3 (+1 -> 'C')]
  //     C: endLine=20 (+20 -> 'U'), endCol=0 ('A')
  //   Scope 1 (inlinedFunc):
  //     B: flags=5 (name|stackFrame), line=30 (+10 -> 'K'), col=2 ('C'),
  //        nameIdx=4 (+4 -> 'I')
  //     D: vars=[5 (+2 -> 'E')]
  //     C: endLine=40 (+10 -> 'K'), endCol=0 ('A')
  //
  // ranges:
  //   Outer range [10, 50) referencing source 0, scope 0:
  //     E: flags=6 (def|stackFrame -> 'G'), col=10 ('K'), srcDiff=0 ('A'),
  //        scpDiff=0 ('A')
  //     G: bindings for [x, y] -> [local_x (6+1=7 -> 'H'), unavail (0 -> 'A')]
  //     H: sub-range binding for var 1 (y): at offset 10+15=25 ('AA' + 'P'),
  //        becomes local_y (7+1=8 -> 'I')
  //     Child inlined range [20, 35) referencing source 0, scope 1:
  //       E: flags=2 (def -> 'C'), colDiff=10 (10+10=20 -> 'K'),
  //          srcDiff=0 ('A'), scpDiff=+1 ('C')
  //       G: bindings for [a] -> [local_a (8+1=9 -> 'J')]
  //       I: callSite in source 0 ('A'), line 9 (0-based -> 10 in 1-based,
  //          'J'), col 4 ('E')
  //       F: end at 20+15=35 ('P')
  //     F: end at 35+15=50 ('P')
  //
  // mappings:
  //   at offset 10 ('U'): file=0 ('A'), line=1+4=5 ('I'), col=2 ('E')
  //   at offset 20 ('U'): file=0 ('A'), line=5+27=32 ('2B'), col=4 ('E')
  //   at offset 30 ('U'): 1-element unmapped segment
  //   at offset 35 ('K'): file=0 ('A'), line=32-20=12 ('pB'), col=6 ('E')
  std::string sourceMap = R"(
    {
      "version": 3,
      "sources": ["main.dart", "other.dart"],
      "names": ["outerFunc", "function", "x", "y", "inlinedFunc", "a", "local_x", "local_y", "local_a"],
      "mappings": "UAIE,UA2BE,U,KApBE",
      "scopes": ["BHAAAC,DEC,CUA,BFKCI,DE,CKA", null],
      "ranges": ["EGKAA,GHA,HBAPI,ECKAC,GJ,IAJE,FP,FP"]
    }
  )";
  parseMap(sourceMap);

  // At offset 10: inside outer range only; symbol resolved from outerFunc
  // scope.
  auto loc10 = reader->readDebugLocationAt(10);
  ASSERT_EQ(loc10.size(), 1u);
  EXPECT_EQ(loc10[0].fileIndex, 0u);
  EXPECT_EQ(loc10[0].lineNumber, 5u);
  EXPECT_EQ(loc10[0].columnNumber, 2u);
  EXPECT_EQ(loc10[0].symbolNameIndex, std::optional<BinaryLocation>(0));

  // At offset 20: inside outer range AND inlined child range.
  auto loc20 = reader->readDebugLocationAt(20);
  ASSERT_EQ(loc20.size(), 2u);
  // Outer frame holds callsite position (file 0, line 10, col 4) and outerFunc.
  EXPECT_EQ(loc20[0].fileIndex, 0u);
  EXPECT_EQ(loc20[0].lineNumber, 10u);
  EXPECT_EQ(loc20[0].columnNumber, 4u);
  EXPECT_EQ(loc20[0].symbolNameIndex, std::optional<BinaryLocation>(0));
  // Inner frame holds inlined instruction position (file 0, line 32, col 4) and
  // inlinedFunc.
  EXPECT_EQ(loc20[1].fileIndex, 0u);
  EXPECT_EQ(loc20[1].lineNumber, 32u);
  EXPECT_EQ(loc20[1].columnNumber, 4u);
  EXPECT_EQ(loc20[1].symbolNameIndex, std::optional<BinaryLocation>(4));

  // At offset 30: unmapped 1-element segment.
  auto loc30 = reader->readDebugLocationAt(30);
  EXPECT_TRUE(loc30.empty());

  // At offset 35: back in outer range only.
  auto loc35 = reader->readDebugLocationAt(35);
  ASSERT_EQ(loc35.size(), 1u);
  EXPECT_EQ(loc35[0].fileIndex, 0u);
  EXPECT_EQ(loc35[0].lineNumber, 12u);
  EXPECT_EQ(loc35[0].columnNumber, 6u);
  EXPECT_EQ(loc35[0].symbolNameIndex, std::optional<BinaryLocation>(0));
}

TEST_F(SourceMapTest, RelativeCallSiteParsing) {
  // Test 'J' (GeneratedRangeRelativeCallSite) with 1, 2, and 3 values:
  // Scope 0 in source 0 starts at line 11 (0-based 10 -> 'K'), col 5 ('F').
  // Scope 1 in source 0 starts at line 51 (0-based 50 -> +40 = 'oB'), col 0
  // ('A'). Outer range [10, 40) has definition (source 0, scope 0). Child range
  // 1 [12, 18): J with 1 arg (colOffset=3 -> 'D') => callSite=(0, 11, 8). Child
  // range 2 [20, 26): J with 2 args (lineOffset=4 -> 'E', col=7 -> 'H') =>
  // callSite=(0, 15, 7). Nested grandchild range [21, 25) inside child range 2:
  //   J with 3 args (parentIdx=1 -> 'B', lineOffset=2 -> 'C', col=9 -> 'J')
  //   parentIdx=1 refers to Outer range (scope 0 at line 11, col 5) =>
  //   callSite=(0, 13, 9).
  // mappings: at offset 12 ('Y'), file=0 ('A'), line=1 ('A'), col=0 ('A').
  std::string sourceMap = R"(
    {
      "version": 3,
      "sources": ["rel.dart"],
      "names": ["f0", "f1"],
      "mappings": "YAAA",
      "scopes": ["BFKFA,CKA,BFoBAA,CKA"],
      "ranges": ["EGKAA,ECCAC,JD,FG,ECCAA,JEH,ECBAC,JBCJ,FE,FB,FO"]
    }
  )";
  parseMap(sourceMap);

  auto loc12 = reader->readDebugLocationAt(12);
  ASSERT_EQ(loc12.size(), 2u);
  EXPECT_EQ(loc12[0].fileIndex, 0u);
  EXPECT_EQ(loc12[0].lineNumber, 11u);
  EXPECT_EQ(loc12[0].columnNumber, 8u);
  EXPECT_EQ(loc12[0].symbolNameIndex, std::optional<BinaryLocation>(0));

  auto loc20 = reader->readDebugLocationAt(20);
  ASSERT_EQ(loc20.size(), 2u);
  EXPECT_EQ(loc20[0].fileIndex, 0u);
  EXPECT_EQ(loc20[0].lineNumber, 15u);
  EXPECT_EQ(loc20[0].columnNumber, 7u);
  EXPECT_EQ(loc20[0].symbolNameIndex, std::optional<BinaryLocation>(0));

  auto loc21 = reader->readDebugLocationAt(21);
  ASSERT_EQ(loc21.size(), 3u);
  EXPECT_EQ(loc21[1].fileIndex, 0u);
  EXPECT_EQ(loc21[1].lineNumber, 13u);
  EXPECT_EQ(loc21[1].columnNumber, 9u);
  EXPECT_EQ(loc21[1].symbolNameIndex, std::optional<BinaryLocation>(0));
}

TEST_F(SourceMapTest, ScopesAndRangesBinaryRoundTrip) {
  Module m1;
  m1.debugInfoFileNames = {"app.dart"};
  m1.debugInfoSymbolNames = {"caller", "callee"};

  Builder builder(m1);
  auto* nop1 = builder.makeNop();
  auto* nop2 = builder.makeNop();
  auto* nop3 = builder.makeNop();
  auto* body = builder.makeBlock({nop1, nop2, nop3});
  auto func = builder.makeFunction(
    "main", {}, Signature(Type::none, Type::none), {}, body);

  // nop1: in caller at app.dart:12:4
  func->debugLocations[nop1] = {
    Function::DebugLocation{0, 12, 4, std::optional<BinaryLocation>(0)}};
  // nop2: inlined callee called from app.dart:15:8, body at app.dart:32:6.
  func->debugLocations[nop2] = {
    Function::DebugLocation{0, 15, 8, std::optional<BinaryLocation>(0)},
    Function::DebugLocation{0, 32, 6, std::optional<BinaryLocation>(1)}};
  // nop3: back in caller at app.dart:16:4
  func->debugLocations[nop3] = {
    Function::DebugLocation{0, 16, 4, std::optional<BinaryLocation>(0)}};

  m1.addFunction(std::move(func));

  BufferWithRandomAccess wasmBuf;
  std::stringstream mapStream;
  PassOptions options;
  WasmBinaryWriter writer(&m1, wasmBuf, options);
  writer.setNamesSection(true);
  writer.setSourceMap(&mapStream, "out.map");
  writer.write();

  std::vector<char> wasmBytes(wasmBuf.begin(), wasmBuf.end());
  std::string mapStr = mapStream.str();
  std::vector<char> mapBytes(mapStr.begin(), mapStr.end());

  Module m2;
  WasmBinaryReader binaryReader(m2, FeatureSet::MVP, wasmBytes, mapBytes);
  binaryReader.read();

  ASSERT_EQ(m2.functions.size(), 1u);
  auto* f2 = m2.functions[0].get();
  auto* block2 = f2->body->cast<Block>();
  ASSERT_EQ(block2->list.size(), 3u);

  const auto& dl1 = f2->debugLocations.at(block2->list[0]);
  ASSERT_EQ(dl1.size(), 1u);
  EXPECT_EQ(dl1[0].lineNumber, 12u);
  EXPECT_EQ(dl1[0].columnNumber, 4u);
  EXPECT_EQ(dl1[0].symbolNameIndex, std::optional<BinaryLocation>(0));

  const auto& dl2 = f2->debugLocations.at(block2->list[1]);
  ASSERT_EQ(dl2.size(), 2u);
  EXPECT_EQ(dl2[0].lineNumber, 15u);
  EXPECT_EQ(dl2[0].columnNumber, 8u);
  EXPECT_EQ(dl2[0].symbolNameIndex, std::optional<BinaryLocation>(0));
  EXPECT_EQ(dl2[1].lineNumber, 32u);
  EXPECT_EQ(dl2[1].columnNumber, 6u);
  EXPECT_EQ(dl2[1].symbolNameIndex, std::optional<BinaryLocation>(1));

  const auto& dl3 = f2->debugLocations.at(block2->list[2]);
  ASSERT_EQ(dl3.size(), 1u);
  EXPECT_EQ(dl3[0].lineNumber, 16u);
  EXPECT_EQ(dl3[0].columnNumber, 4u);
  EXPECT_EQ(dl3[0].symbolNameIndex, std::optional<BinaryLocation>(0));
}

TEST(SourceMapCopyTest, RemapInlinedStackLocations) {
  Module srcModule;
  Module dstModule;
  Builder builder(srcModule);

  auto* nop = builder.makeNop();
  auto func = builder.makeFunction(
    "test", {}, Signature(Type::none, Type::none), {}, nop);

  func->debugLocations[nop] = {
    Function::DebugLocation{0, 10, 5, std::optional<BinaryLocation>(0)},
    Function::DebugLocation{1, 20, 3, std::optional<BinaryLocation>(1)}};

  std::vector<Index> fileIndexMap = {3, 5};
  std::vector<Index> symbolNameIndexMap = {7, 9};

  auto copied = ModuleUtils::copyFunctionWithoutAdd(
    func.get(), dstModule, Name(), fileIndexMap, symbolNameIndexMap);

  const auto& locs = copied->debugLocations.at(copied->body);
  ASSERT_EQ(locs.size(), 2u);
  EXPECT_EQ(locs[0].fileIndex, 3u);
  EXPECT_EQ(locs[0].symbolNameIndex, std::optional<BinaryLocation>(7));
  EXPECT_EQ(locs[1].fileIndex, 5u);
  EXPECT_EQ(locs[1].symbolNameIndex, std::optional<BinaryLocation>(9));
}

TEST_F(SourceMapTest, InliningCreatesCallStackScopes) {
  auto text = R"wasm(
    (module
      (func $callee
        ;;@ foo.cpp:10:2:calleeFunc
        (nop)
      )
      (func $caller (export "caller")
        ;;@ foo.cpp:50:4:callerFunc
        (call $callee)
      )
    )
  )wasm";
  Module m1;
  parseWast(m1, text);

  PassRunner runner(&m1);
  runner.add("inlining");
  runner.run();

  auto* caller1 = m1.getFunction("caller");
  auto* block1 = caller1->body->cast<Block>();
  ASSERT_EQ(block1->list.size(), 1u);
  auto* inlinedNop1 = block1->list[0];
  ASSERT_TRUE(caller1->debugLocations.count(inlinedNop1));
  const auto& locs1 = caller1->debugLocations.at(inlinedNop1);
  ASSERT_EQ(locs1.size(), 2u);
  // Outer frame is the call site in callerFunc.
  EXPECT_EQ(locs1[0].lineNumber, 50u);
  EXPECT_EQ(locs1[0].columnNumber, 4u);
  // Inner frame is the inlined instruction in calleeFunc.
  EXPECT_EQ(locs1[1].lineNumber, 10u);
  EXPECT_EQ(locs1[1].columnNumber, 2u);

  // Write binary + source map and read back to verify synthesized scopes/ranges
  // preserve the full inlined call stack.
  BufferWithRandomAccess wasmBuf;
  std::stringstream mapStream;
  PassOptions options;
  WasmBinaryWriter writer(&m1, wasmBuf, options);
  writer.setSourceMap(&mapStream, "out.map");
  writer.write();

  std::vector<char> wasmBytes(wasmBuf.begin(), wasmBuf.end());
  std::string mapStr = mapStream.str();
  std::vector<char> mapBytes(mapStr.begin(), mapStr.end());

  Module m2;
  WasmBinaryReader binaryReader(m2, FeatureSet::MVP, wasmBytes, mapBytes);
  binaryReader.read();

  ASSERT_EQ(m2.functions.size(), 1u);
  auto* caller2 = m2.functions[0].get();
  ASSERT_TRUE(caller2->debugLocations.count(caller2->body));
  const auto& locs2 = caller2->debugLocations.at(caller2->body);
  ASSERT_EQ(locs2.size(), 2u);
  EXPECT_EQ(locs2[0].lineNumber, 50u);
  EXPECT_EQ(locs2[0].columnNumber, 4u);
  ASSERT_TRUE(locs2[0].symbolNameIndex.has_value());
  EXPECT_EQ(m2.debugInfoSymbolNames[*locs2[0].symbolNameIndex], "callerFunc");
  EXPECT_EQ(locs2[1].lineNumber, 10u);
  EXPECT_EQ(locs2[1].columnNumber, 2u);
  ASSERT_TRUE(locs2[1].symbolNameIndex.has_value());
  EXPECT_EQ(m2.debugInfoSymbolNames[*locs2[1].symbolNameIndex], "calleeFunc");
}
