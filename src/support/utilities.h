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

#ifndef wasm_support_utilities_h
#define wasm_support_utilities_h

#include <cstring>
#include <type_traits>

namespace wasm {

// Type punning needs to be done through this function to avoid undefined
// behavior: unions and reinterpret_cast aren't valid approaches.
template <class Destination, class Source>
inline Destination bit_cast(const Source& source) {
  static_assert(sizeof(Destination) == sizeof(Source),
                "bit_cast needs to be between types of the same size");
  static_assert(std::is_pod<Destination>::value, "non-POD bit_cast undefined");
  static_assert(std::is_pod<Source>::value, "non-POD bit_cast undefined");
  Destination destination;
  std::memcpy(&destination, &source, sizeof(destination));
  return destination;
}

}  // namespace wasm

#endif   // wasm_support_utilities_h
