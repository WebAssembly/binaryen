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

#if defined(__linux__) || defined(__APPLE__)
# define CAN_HAZ_COLOR 1
# include <unistd.h>
#endif

namespace {
bool colors_disabled = false;
}  // anonymous namespace

void Colors::disable() { colors_disabled = true; }

void Colors::outputColorCode(std::ostream& stream, const char* colorCode) {
#if defined(CAN_HAZ_COLOR)
  const static bool has_color = []() {
    return (getenv("COLORS") && getenv("COLORS")[0] == '1') ||  // forced
           (isatty(STDOUT_FILENO) &&
            (!getenv("COLORS") || getenv("COLORS")[0] != '0'));  // implicit
  }();
  if (has_color && !colors_disabled) stream << colorCode;
#endif
}
