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
// Shared utilities for commandline tools
//

#include <string>

namespace wasm {

// Removes a specific suffix if it is present, otherwise no-op
inline std::string removeSpecificSuffix(std::string str, std::string suffix) {
  if (str.size() <= suffix.size()) {
    return str;
  }
  if (str.substr(str.size() - suffix.size()).compare(suffix) == 0) {
    return str.substr(0, str.size() - suffix.size());
  }
  return str;
}

} // namespace wasm

