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

#include "parser/wat-parser.h"
#include "print-test.h"
#include "wasm-binary.h"
#include "gtest/gtest.h"

using namespace wasm;

using BinaryReaderTest = PrintTest;

// Check that debug location parsers can handle single-segment mappings.
TEST_F(BinaryReaderTest, SourceMappingSingleSegment) {
  auto moduleText = "(module)";
  Module module;
  parseWast(module, moduleText);

  BufferWithRandomAccess buffer;
  WasmBinaryWriter(&module, buffer, PassOptions());
  auto moduleBytes = buffer.getAsChars();

  // A single-segment mapping starting at offset 0.
  std::string sourceMap = R"(
      {
          "version": 3,
          "sources": [],
          "names": [],
          "mappings": "A"
      }
  )";
  std::stringstream sourceMapStream(sourceMap);

  // Test `readSourceMapHeader` (only check for errors, as there is no mapping
  // to print).
  {
    Module module;
    WasmBinaryReader binaryReader(module, FeatureSet::All, moduleBytes);
    binaryReader.setDebugLocations(&sourceMapStream);
    binaryReader.readSourceMapHeader();
  }

  // Test `readNextDebugLocation`.
  {
    Module module;
    WasmBinaryReader binaryReader(module, FeatureSet::All, moduleBytes);
    binaryReader.setDebugLocations(&sourceMapStream);
    binaryReader.readNextDebugLocation();
  }
}
