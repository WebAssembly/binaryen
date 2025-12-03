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

#include "ir/element-utils.h"
#include "ir/literal-utils.h"
#include "ir/module-utils.h"
#include "support/stdckdint.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm::TableUtils {

struct FlatTable {
  std::vector<Name> names;
  bool valid;

  FlatTable(Module& wasm, Table& table) {
    valid = true;
    ModuleUtils::iterTableSegments(
      wasm, table.name, [&](ElementSegment* segment) {
        auto offset = segment->offset;
        if (!offset->is<Const>() || !segment->type.isFunction()) {
          // TODO: handle some non-constant segments
          valid = false;
          return;
        }
        Index start = offset->cast<Const>()->value.getInteger();
        Index size = segment->data.size();
        Index end;
        if (std::ckd_add(&end, start, size) || end > table.initial) {
          // Overflow.
          valid = false;
          return;
        }
        if (end > names.size()) {
          names.resize(end);
        }
        ElementUtils::iterElementSegmentFunctionNames(
          segment, [&](Name entry, Index i) { names[start + i] = entry; });
      });
  }
};

inline ElementSegment* getSingletonSegment(Table& table, Module& wasm) {
  std::vector<ElementSegment*> tableSegments;
  ModuleUtils::iterTableSegments(
    wasm, table.name, [&](ElementSegment* segment) {
      tableSegments.push_back(segment);
    });
  if (tableSegments.size() != 1) {
    Fatal() << "Table doesn't have a singleton segment.";
  }
  return tableSegments[0];
}

// Appends a name to the table. This assumes the table has 0 or 1 segments,
// as with 2 or more it's ambiguous what we should do (use a hole in the middle
// or not).
// This works on code from wasm-ld, but on arbitrary code it may not be valid
// in the presence of a dynamic linking section. Specifically, we assume the
// module has a single table segment, and that the dylink section indicates
// we can validly append to that segment, see the check below.
inline Index append(Table& table, Name name, Module& wasm) {
  auto* segment = getSingletonSegment(table, wasm);
  auto tableIndex = segment->data.size();
  if (wasm.dylinkSection) {
    if (segment->data.size() != wasm.dylinkSection->tableSize) {
      Fatal() << "Appending to the table in a module with a dylink section "
                 "that has tableSize which indicates it wants to reserve more "
                 "table space than the actual table elements in the module. "
                 "We don't know how to correctly update the dylink section in "
                 "that case.";
    }
    wasm.dylinkSection->tableSize++;
  }

  assert(wasm.getFunctionOrNull(name) != nullptr &&
         "Cannot append non-existing function to a table.");
  segment->data.push_back(Builder(wasm).makeRefFunc(name));
  table.initial++;
  return tableIndex;
}

// Checks if a function is already in the table. Returns that index if so,
// otherwise appends it.
inline Index getOrAppend(Table& table, Name name, Module& wasm) {
  auto segment = getSingletonSegment(table, wasm);
  for (Index i = 0; i < segment->data.size(); i++) {
    if (auto* get = segment->data[i]->dynCast<RefFunc>()) {
      if (get->func == name) {
        return i;
      }
    }
  }
  return append(table, name, wasm);
}

// Functions that we take a reference to, but are not in a Table, but get an
// "elem declare" mention in the text and binary formats.
std::set<Name> getFunctionsNeedingElemDeclare(Module& wasm);

// Returns whether a segment uses arbitrary wasm expressions, as opposed to the
// original tables from the MVP that use function indices. (Some post-MVP tables
// do so, and some do not, depending on their type and use.)
bool usesExpressions(ElementSegment* curr, Module* module);

// Information about a table's optimizability.
struct TableInfo {
  // Whether the table may be modifed at runtime, either because it is imported
  // or exported, or table.set operations exist for it in the code.
  bool mayBeModified = false;

  // Whether we can assume that the initial contents are immutable. See the
  // toplevel comment.
  bool initialContentsImmutable = false;

  std::unique_ptr<TableUtils::FlatTable> flatTable;

  // Whether we can optimize using this table's data, that is, we know something
  // useful about the data there at compile time. The specifics about what we
  // know are in the above fields.
  bool canOptimize() const {
    // We can optimize if:
    //  * Either the table can't be modified at all, or it can be modified but
    //    the initial contents are immutable (so we can optimize those
    //    contents, even if other things might be appended later).
    //  * The table is flat (so we can see what is in it).
    return (!mayBeModified || initialContentsImmutable) && flatTable->valid;
  }
};

// A map of tables to their info.
using TableInfoMap = std::unordered_map<Name, TableInfo>;

// Compute a map with table optimizability info. We can be told that the initial
// contents of the tables are immutable (that is, existing data is not
// overwritten, but new things may be appended).
TableInfoMap computeTableInfo(Module& wasm,
                              bool initialContentsImmutable = false);

} // namespace wasm::TableUtils

#endif // wasm_ir_table_h
