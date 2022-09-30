/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "literal.h"

#include "random.h"

namespace wasm {

Random::Random(std::vector<char>&& bytes_, FeatureSet features)
  : bytes(std::move(bytes_)), features(features) {
  // Ensure there is *some* input to be read.
  if (bytes.empty()) {
    bytes.push_back(0);
  }
}

int8_t Random::get() {
  if (pos == bytes.size()) {
    // We ran out of input; go back to the start for more.
    finishedInput = true;
    pos = 0;
    xorFactor++;
  }
  return bytes[pos++] ^ xorFactor;
}

int16_t Random::get16() {
  auto temp = uint16_t(get()) << 8;
  return temp | uint16_t(get());
}

int32_t Random::get32() {
  auto temp = uint32_t(get16()) << 16;
  return temp | uint32_t(get16());
}

int64_t Random::get64() {
  auto temp = uint64_t(get32()) << 32;
  return temp | uint64_t(get32());
}

float Random::getFloat() { return Literal(get32()).reinterpretf32(); }

double Random::getDouble() { return Literal(get64()).reinterpretf64(); }

uint32_t Random::upTo(uint32_t x) {
  if (x == 0) {
    return 0;
  }
  uint32_t raw;
  if (x <= 255) {
    raw = get();
  } else if (x <= 65535) {
    raw = get16();
  } else {
    raw = get32();
  }
  auto ret = raw % x;
  // use extra bits as "noise" for later
  xorFactor += raw / x;
  return ret;
}

} // namespace wasm
