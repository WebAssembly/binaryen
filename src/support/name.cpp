/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include <algorithm>
#include <array>

#include "support/name.h"
#include "support/string.h"

namespace wasm {

// TODO: Use unicode rather than char.
bool Name::isIDChar(char c) {
  if ('0' <= c && c <= '9') {
    return true;
  }
  if ('A' <= c && c <= 'Z') {
    return true;
  }
  if ('a' <= c && c <= 'z') {
    return true;
  }
  static std::array<char, 23> otherIDChars = {
    {'!', '#', '$', '%', '&', '\'', '*', '+', '-', '.', '/', ':',
     '<', '=', '>', '?', '@', '\\', '^', '_', '`', '|', '~'}};
  return std::find(otherIDChars.begin(), otherIDChars.end(), c) !=
         otherIDChars.end();
}

std::ostream& Name::print(std::ostream& o) const {
  assert(*this && "Cannot print an empty name");
  // We need to quote names if they have tricky chars.
  // TODO: This is not spec-compliant since the spec does not yet support
  // quoted identifiers and has a limited set of valid idchars.
  o << '$';
  if (std::all_of(str.begin(), str.end(), isIDChar)) {
    return o << str;
  } else {
    return String::printEscaped(o, str);
  }
}

} // namespace wasm
