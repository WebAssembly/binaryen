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

#include "support/colors.h"

#include <cstdlib>
#include <ostream>

namespace {
bool colors_enabled = true;
} // anonymous namespace

void Colors::setEnabled(bool enabled) { colors_enabled = enabled; }
bool Colors::isEnabled() { return colors_enabled; }

#if defined(__linux__) || defined(__APPLE__)
#include <unistd.h>

void Colors::outputColorCode(std::ostream& stream, const char* colorCode) {
  const static bool has_color = []() {
    return (getenv("COLORS") && getenv("COLORS")[0] == '1') || // forced
           (isatty(STDOUT_FILENO) &&
            (!getenv("COLORS") || getenv("COLORS")[0] != '0')); // implicit
  }();
  if (has_color && colors_enabled) {
    stream << colorCode;
  }
}
#elif defined(_WIN32)
#include <io.h>
#include <iostream>
#include <windows.h>

void Colors::outputColorCode(std::ostream& stream, const WORD& colorCode) {
  const static bool has_color = []() {
    return _isatty(_fileno(stdout)) &&
           (!getenv("COLORS") || getenv("COLORS")[0] != '0'); // implicit
  }();
  static HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);
  static HANDLE hStderr = GetStdHandle(STD_ERROR_HANDLE);
  if (has_color && colors_enabled)
    SetConsoleTextAttribute(&stream == &std::cout ? hStdout : hStderr,
                            colorCode);
}
#endif
