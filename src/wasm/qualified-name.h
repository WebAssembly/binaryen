/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef wasm_qualified_name_h
#define wasm_qualified_name_h

#include "support/name.h"
#include <ostream>

namespace wasm {

struct QualifiedName {
  Name module;
  Name name;

  friend std::ostream& operator<<(std::ostream& o, const QualifiedName& qname) {
    return o << qname.module << "." << qname.name;
  }
};

} // namespace wasm

#endif // wasm_qualified_name_h
