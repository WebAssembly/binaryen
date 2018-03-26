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

inline std::string getPathSeparator() {
  // TODO: use c++17's path separator
  //       http://en.cppreference.com/w/cpp/experimental/fs/path
#if defined(WIN32) || defined(_WIN32) 
  return "\\";
#else
  return "/";
#endif
}

inline std::string getBinaryenRoot() {
  auto* envVar = getenv("BINARYEN_ROOT");
  if (envVar) return envVar;
  return ".";
}

inline std::string getBinaryenBinDir() {
  return getBinaryenRoot() + getPathSeparator() + "bin" + getPathSeparator();
}

// Gets the path to a binaryen binary tool, like wasm-opt
inline std::string getBinaryenBinaryTool(std::string name) {
  return getBinaryenBinDir() + name;
}

} // namespace Path

} // namespace wasm

#endif // wasm_support_path_h
