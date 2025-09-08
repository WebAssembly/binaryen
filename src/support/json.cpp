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

#include "support/json.h"
#include "support/string.h"

namespace json {

void Value::stringify(std::ostream& os, bool pretty) {
  if (isString()) {
    std::stringstream wtf16;
    [[maybe_unused]] bool valid =
      wasm::String::convertWTF8ToWTF16(wtf16, getIString().str);
    assert(valid);
    // TODO: Use wtf16.view() once we have C++20.
    wasm::String::printEscapedJSON(os, wtf16.str());
  } else if (isArray()) {
    os << '[';
    auto first = true;
    for (auto& item : getArray()) {
      if (first) {
        first = false;
      } else {
        // TODO pretty whitespace
        os << ',';
      }
      item->stringify(os, pretty);
    }
    os << ']';
  } else {
    WASM_UNREACHABLE("TODO: stringify all of JSON");
  }
}

} // namespace json
