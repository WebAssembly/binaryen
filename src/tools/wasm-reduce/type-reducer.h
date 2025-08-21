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

#ifndef wasm_tools_wasm_reduce_type_reducer_h
#define wasm_tools_wasm_reduce_type_reducer_h

#include "ir/subtypes.h"
#include "reducer.h"

namespace wasm {

struct TypeReducer {
  Reducer& reducer;
  Module& wasm;

  struct TypeInfo {
    std::vector<Expression**> allocations;
    // Map field index to vector of accessors of that field index.
    std::vector<std::vector<Expression**>> fieldExpressions;
  };

  using TypeInfoMap = std::unordered_map<HeapType, TypeInfo>;
  using TypeInfoFunctionMap =
    InsertOrderedMap<HeapType, std::unordered_map<Function*, TypeInfo>>;

  // Map fields of types to lists of expressions that would need to be updated
  // if those fields were removed.
  TypeInfoFunctionMap typeInfo;
  Index totalFields = 0;
  SubTypes subtypes;

  // The current index into all the fields.
  Index index;
  // Iterator to the current type information.
  TypeInfoFunctionMap::iterator typeIt;
  // The current field index in the current type.
  Index currField;
  // The number of fields we've processed since the last successful reduction.
  // We're done once this is equal to the total number of fields.
  Index fieldsSinceLastSuccess = 0;

  TypeReducer(Reducer& reducer)
    : reducer(reducer), wasm(reducer.wasm), subtypes({}) {}

  // Entrypoint. Returns (a lower bound on) the number of reduced fields.
  size_t reduce();

  void collectTypeInfo();
  void resetTypeInfo();
  void reloadAndReset();
  void advance();

  // Try reducing a batch of fields. Return the number of reduced fields.
  // Ensures the IR and internal data structures are in a consistent state
  // afterwards whether the reduction succeeds or fails.
  using CandidateFields = std::vector<std::pair<HeapType, Index>>;
  size_t tryReduction(CandidateFields fields);
  size_t tryRemovingFields(const CandidateFields& fields);

  // Destructively modify the IR. Return the new location holding the relevant
  // expression, if any, or nullptr if the expression has been completely
  // removed.
  Expression**
  removeAllocationField(Function* func, Expression** currp, Index index);
  Expression**
  removeAccessorField(Function* func, Expression** currp, Index index);
  void decrementAccessorIndex(Expression* curr);
};

} // namespace wasm

#endif // wasm_tools_wasm_reduce_type_reducer_h