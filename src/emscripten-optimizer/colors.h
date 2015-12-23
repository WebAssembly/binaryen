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

#ifndef wasm_color_h
#define wasm_color_h

#include <cstdlib>
#include <ostream>

#if defined(__linux__) || defined(__apple__)
#include <unistd.h>

namespace Colors {
  inline void outputColorCode(std::ostream& stream,const char* colorCode) {
    if((getenv("COLORS") && getenv("COLORS")[0] == '1') || // forced
           (isatty(STDOUT_FILENO) && (!getenv("COLORS") || getenv("COLORS")[0] != '0'))) { // implicit
      stream << colorCode;
    }
  }
#else
namespace Colors {
  inline void outputColorCode(std::ostream& stream,const char* colorCode) {}
#endif

  inline void normal(std::ostream& stream) { outputColorCode(stream,"\033[0m"); }
  inline void red(std::ostream& stream) { outputColorCode(stream,"\033[31m"); }
  inline void magenta(std::ostream& stream) { outputColorCode(stream,"\033[35m"); }
  inline void orange(std::ostream& stream) { outputColorCode(stream,"\033[33m"); }
  inline void grey(std::ostream& stream) { outputColorCode(stream,"\033[37m"); }
  inline void green(std::ostream& stream) { outputColorCode(stream,"\033[32m"); }
  inline void blue(std::ostream& stream) { outputColorCode(stream,"\033[34m"); }
  inline void bold(std::ostream& stream) { outputColorCode(stream,"\033[1m"); }
};

#endif // wasm_color_h
