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

#ifndef WIN32
#include <unistd.h>
#include <cstdlib>
#include <ostream>

namespace Colors {
  inline bool use() {
    return (getenv("COLORS") && getenv("COLORS")[0] == '1') || // forced
           (isatty(STDOUT_FILENO) && (!getenv("COLORS") || getenv("COLORS")[0] != '0')); // implicit
  }

  inline void normal(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[0m";
#endif
  }
  inline void red(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[31m";
#endif
  }
  inline void magenta(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[35m";
#endif
  }
  inline void orange(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[33m";
#endif
  }
  inline void grey(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[37m";
#endif
  }
  inline void green(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[32m";
#endif
  }
  inline void blue(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[34m";
#endif
  }
  inline void bold(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[1m";
#endif
  }
};
#else
namespace Colors {
  inline bool use() { return false; }
  inline void normal(std::ostream& stream) {}
  inline void red(std::ostream& stream) {}
  inline void magenta(std::ostream& stream) {}
  inline void orange(std::ostream& stream) {}
  inline void grey(std::ostream& stream) {}
  inline void green(std::ostream& stream) {}
  inline void blue(std::ostream& stream) {}
  inline void bold(std::ostream& stream) {}
};
#endif

#endif // wasm_color_h
