/*
 * Copyright 2019 WebAssembly Community Group participants
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

#ifndef wasm_support_base64_h
#define wasm_support_base64_h

#include <cassert>
#include <string>
#include <vector>

inline std::string base64Encode(std::vector<char>& data) {
  std::string ret;
  size_t i = 0;

  const char* alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                         "abcdefghijklmnopqrstuvwxyz"
                         "0123456789+/";

  while (i + 3 <= data.size()) {
    uint32_t bits = (((uint32_t)(uint8_t)data[i + 0]) << 16) |
                    (((uint32_t)(uint8_t)data[i + 1]) << 8) |
                    (((uint32_t)(uint8_t)data[i + 2]) << 0);
    ret += alphabet[(bits >> 18) & 0x3f];
    ret += alphabet[(bits >> 12) & 0x3f];
    ret += alphabet[(bits >> 6) & 0x3f];
    ret += alphabet[(bits >> 0) & 0x3f];
    i += 3;
  }

  if (i + 2 == data.size()) {
    uint32_t bits = (((uint32_t)(uint8_t)data[i + 0]) << 8) |
                    (((uint32_t)(uint8_t)data[i + 1]) << 0);
    ret += alphabet[(bits >> 10) & 0x3f];
    ret += alphabet[(bits >> 4) & 0x3f];
    ret += alphabet[(bits << 2) & 0x3f];
    ret += '=';
  } else if (i + 1 == data.size()) {
    uint32_t bits = (uint32_t)(uint8_t)data[i + 0];
    ret += alphabet[(bits >> 2) & 0x3f];
    ret += alphabet[(bits << 4) & 0x3f];
    ret += '=';
    ret += '=';
  } else {
    assert(i == data.size());
  }

  return ret;
}

#endif // wasm_support_base64_h
