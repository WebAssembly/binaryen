/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_ir_import_names_h
#define wasm_ir_import_names_h

#include <ostream>

#include "support/hash.h"
#include "support/name.h"

namespace wasm {

struct ImportNames {
  Name module;
  Name name;

  bool operator==(const ImportNames& other) const {
    return module == other.module && name == other.name;
  }
};

} // namespace wasm

namespace std {

template<> struct hash<wasm::ImportNames> {
  std::size_t operator()(const wasm::ImportNames& importNames) const noexcept {
    size_t val = hash<wasm::Name>{}(importNames.module);
    wasm::rehash(val, importNames.name);
    return val;
  }
};

} // namespace std

#endif // wasm_ir_import_names_h
