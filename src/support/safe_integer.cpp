/*
 * Copyright 2016 WebAssembly Community Group participants
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

#include <cassert>
#include <cmath>
#include <limits>

#include "support/safe_integer.h"

using namespace wasm;

bool wasm::isInteger(double x) { return fmod(x, 1) == 0; }

bool wasm::isUInteger32(double x) {
  return !std::signbit(x) && isInteger(x) &&
         x <= std::numeric_limits<uint32_t>::max();
}

bool wasm::isSInteger32(double x) {
  return isInteger(x) && x >= std::numeric_limits<int32_t>::min() &&
         x <= std::numeric_limits<int32_t>::max();
}

uint32_t wasm::toUInteger32(double x) {
  return std::signbit(x) ? 0 : (x < std::numeric_limits<uint32_t>::max()
                                    ? x
                                    : std::numeric_limits<uint32_t>::max());
}

int32_t wasm::toSInteger32(double x) {
  return (x > std::numeric_limits<int32_t>::min() &&
          x < std::numeric_limits<int32_t>::max())
             ? x
             : (std::signbit(x) ? std::numeric_limits<int32_t>::min()
                                : std::numeric_limits<int32_t>::max());
}

bool wasm::isUInteger64(double x) {
  return !std::signbit(x) && isInteger(x) &&
         x <= std::numeric_limits<uint64_t>::max();
}

bool wasm::isSInteger64(double x) {
  return isInteger(x) && x >= std::numeric_limits<int64_t>::min() &&
         x <= std::numeric_limits<int64_t>::max();
}

uint64_t wasm::toUInteger64(double x) {
  return std::signbit(x) ? 0 : (x < (double)std::numeric_limits<uint64_t>::max()
                                    ? (uint64_t)x
                                    : std::numeric_limits<uint64_t>::max());
}

int64_t wasm::toSInteger64(double x) {
  return (x > (double)std::numeric_limits<int64_t>::min() &&
          x < (double)std::numeric_limits<int64_t>::max())
             ? (int64_t)x
             : (std::signbit(x) ? std::numeric_limits<int64_t>::min()
                                : std::numeric_limits<int64_t>::max());
}
