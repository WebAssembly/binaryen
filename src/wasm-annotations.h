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

//
// Support for code annotations.
//

#ifndef wasm_annotations_h
#define wasm_annotations_h

#include "support/name.h"

namespace wasm::Annotations {

extern const Name BranchHint;
extern const Name InlineHint;

} // namespace wasm::Annotations

#endif // wasm_annotations_h
