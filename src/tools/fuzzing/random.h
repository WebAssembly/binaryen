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

#ifndef wasm_tools_fuzzing_random_h
#define wasm_tools_fuzzing_random_h

#include <cstdint>
#include <vector>

namespace wasm {

class Random {
  // The input seed bytes.
  std::vector<char> bytes;
  // The current position in `bytes`.
  size_t pos = 0;
  // Whether we already cycled through all the input (which might mean we should
  // try to finish things off).
  bool finishedInput = false;
  // After we finish the input, we start going through it again, but xoring
  // so it's not identical.
  int xorFactor = 0;

public:
  Random(std::vector<char>&& bytes);

  // Methods for getting random data.
  int8_t get();
  int16_t get16();
  int32_t get32();
  int64_t get64();
  float getFloat();
  double getDouble();

  // Choose an integer value in [0, x). This doesn't use a perfectly uniform
  // distribution, but it's fast and reasonable.
  uint32_t upTo(uint32_t x);
  bool oneIn(uint32_t x) { return upTo(x) == 0; }

  // Apply upTo twice, generating a skewed distribution towards
  // low values.
  uint32_t upToSquared(uint32_t x) { return upTo(upTo(x)); }

  bool finished() { return finishedInput; }
};

} // namespace wasm

#endif // wasm_tools_fuzzing_random_h
