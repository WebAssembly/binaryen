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

#ifndef wasm_ir_table_h
#define wasm_ir_table_h

#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

struct FlatTable {
  std::vector<Name> names;
  bool valid;

  FlatTable(Table& table) {
    valid = true;
    for (auto& segment : table.segments) {
      auto offset = segment.offset;
      if (!offset->is<Const>()) {
        // TODO: handle some non-constant segments
        valid = false;
        return;
      }
      Index start = offset->cast<Const>()->value.geti32();
      Index end = start + segment.data.size();
      if (end > names.size()) {
        names.resize(end);
      }
      for (Index i = 0; i < segment.data.size(); i++) {
        names[start + i] = segment.data[i];
      }
    }
  }
};

} // namespace wasm

#endif // wasm_ir_table_h
