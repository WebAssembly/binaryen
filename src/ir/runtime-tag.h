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

#ifndef wasm_ir_runtime_tag_h
#define wasm_ir_runtime_tag_h

#include "wasm.h"

namespace wasm {

// Class representing an instantiation of a tag.
// Note that we compare identity of the `tagDefinition` in the case that
// multiple instances instantiate the same tag definition.
class RuntimeTag {
public:
  explicit RuntimeTag(const Tag& tagDefinition) : definition(&tagDefinition) {}

  // Move-only
  RuntimeTag(RuntimeTag&& other) : definition(other.definition) {}

  // todo make an accessor for this?
  const Tag* const definition;

  bool operator==(const RuntimeTag& other) const {
    // pointer comparison
    return definition == other.definition;
  }
};

} // namespace wasm

#endif // wasm_ir_runtime_tag_h