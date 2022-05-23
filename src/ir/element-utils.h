/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_ir_element_h
#define wasm_ir_element_h

#include "wasm-builder.h"
#include "wasm.h"

namespace wasm::ElementUtils {

// iterate over functions referenced in an element segment
template<typename T>
inline void iterElementSegmentFunctionNames(ElementSegment* segment,
                                            T visitor) {
  if (!segment->type.isFunction()) {
    return;
  }

  for (Index i = 0; i < segment->data.size(); i++) {
    if (auto* get = segment->data[i]->dynCast<RefFunc>()) {
      visitor(get->func, i);
    }
  }
}

// iterate over functions referenced in all element segments of a module
template<typename T>
inline void iterAllElementFunctionNames(const Module* wasm, T visitor) {
  for (auto& segment : wasm->elementSegments) {
    iterElementSegmentFunctionNames(
      segment.get(), [&](Name& name, Index i) { visitor(name); });
  }
}

} // namespace wasm::ElementUtils

#endif // wasm_ir_element_h
