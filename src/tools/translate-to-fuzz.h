/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Translate a binary stream of bytes into a valid wasm module, *somehow*.
// This is helpful for fuzzing.
//

namespace wasm {

class TranslateToFuzzReader {
public:
  void read(std::string& filename, Module& wasm) {
    auto input(read_file<std::vector<char>>(filename, Flags::Binary, Flags::Release));
    bytes.swap(input);
    pos = 0;
    finishedInput = false;
    // ensure *some* input to be read
    if (bytes.size() == 0) {
      bytes.push_back(0);
    }
    build();
  }

private:
  std::vector<char> bytes; // the input bytes
  size_t pos; // the position in the input
  bool finishedInput; // whether we already cycled through all the input (if so, we should try to finish things off)

  int8_t get() {
    if (pos == bytes.size()) {
      // we ran out of input, go to the start for more stuff
      finishedInput = true;
      pos = 0;
    }
    return bytes[pos++];
  }

  int16_t get16() {
    return (int16_t(get()) << 8) | int16_t(get());
  }

  int32_t get32() {
    return (int32_t(get16()) << 16) | int32_t(get16());
  }

  int64_t get64() {
    return (int64_t(get32()) << 32) | int64_t(get32());
  }

  float getFloat() {
    return Literal(get32()).reinterpretf32();
  }

  float getDouble() {
    return Literal(get64()).reinterpretf64();
  }

  void build() {
  }
};

} // namespace wasm

