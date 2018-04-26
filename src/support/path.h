/*
 * Copyright 2015 WebAssembly Community Group participants
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

//
// Command line helpers.
//

#ifndef wasm_support_path_h
#define wasm_support_path_h

#include <cstdlib>
#include <string>

namespace wasm {

namespace Path {

std::string getPathSeparator();

// Get the binaryen root dor.
std::string getBinaryenRoot();

// Get the binaryen bin dir.
std::string getBinaryenBinDir();

// Set the binaryen bin dir (allows tools to change it based on user input).
void setBinaryenBinDir(std::string dir);

// Gets the path to a binaryen binary tool, like wasm-opt.
std::string getBinaryenBinaryTool(std::string name);

} // namespace Path

} // namespace wasm

#endif // wasm_support_path_h
