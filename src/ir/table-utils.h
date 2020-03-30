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

#include "ir/literal-utils.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace TableUtils {

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

// Ensure one table segment exists. This adds the table if necessary, then
// adds a segment if we need one.
inline Table::Segment& ensureTableWithOneSegment(Table& table, Module& wasm) {
  table.exists = true;
  if (table.segments.size() == 0) {
    table.segments.resize(1);
    table.segments[0].offset = LiteralUtils::makeZero(Type::i32, wasm);
  }
  if (table.segments.size() != 1) {
    Fatal() << "can't ensure 1 segment";
  }
  return table.segments[0];
}

// Appends a name to the table. This assumes the table has 0 or 1 segments,
// as with 2 or more it's ambiguous what we should do (use a hole in the middle
// or not).
// This works on code from wasm-ld, but on arbitrary code it may not be valid
// in the presence of a dynamic linking section. Specifically, we assume the
// module has a single table segment, and that the dylink section indicates
// we can validly append to that segment, see the check below.
inline Index append(Table& table, Name name, Module& wasm) {
  auto& segment = ensureTableWithOneSegment(table, wasm);
  auto tableIndex = segment.data.size();
  if (wasm.dylinkSection) {
    if (segment.data.size() != wasm.dylinkSection->tableSize) {
      Fatal() << "Appending to the table in a module with a dylink section "
                 "that has tableSize which indicates it wants to reserve more "
                 "table space than the actual table elements in the module. "
                 "We don't know how to correctly update the dylink section in "
                 "that case.";
    }
    wasm.dylinkSection->tableSize++;
  }
  segment.data.push_back(name);
  table.initial = table.initial + 1;
  return tableIndex;
}

// Checks if a function is already in the table. Returns that index if so,
// otherwise appends it.
inline Index getOrAppend(Table& table, Name name, Module& wasm) {
  auto& segment = ensureTableWithOneSegment(table, wasm);
  for (Index i = 0; i < segment.data.size(); i++) {
    if (segment.data[i] == name) {
      return i;
    }
  }
  return append(table, name, wasm);
}

} // namespace TableUtils

} // namespace wasm

#endif // wasm_ir_table_h
