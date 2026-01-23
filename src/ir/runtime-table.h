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

#ifndef wasm_ir_runtime_table_h
#define wasm_ir_runtime_table_h

#include <stddef.h>
#include <vector>

#include "literal.h"
#include "wasm.h"

namespace wasm {

// Runtime representation of a table for interpreting use cases e.g.
// wasm-interpreter.h. Effectively a vector of Literal. Throws TrapException on
// out-of-bounds access.
class RuntimeTable {
public:
  RuntimeTable(Table table) : tableDefinition(table) {}
  virtual ~RuntimeTable() = default;

  virtual void set(std::size_t i, Literal l) = 0;

  virtual Literal get(std::size_t i) const = 0;

  // Returns nullopt if the table grew beyond the max possible size.
  [[nodiscard]] virtual std::optional<std::size_t> grow(std::size_t delta,
                                                        Literal fill) = 0;

  virtual std::size_t size() const = 0;

  // True iff this is a subtype of the definition `other`. i.e. This table can
  // be imported with the definition of `other`
  virtual bool isSubType(const Table& other) {
    return tableDefinition.addressType == other.addressType &&
           Type::isSubType(tableDefinition.type, other.type) &&
           size() >= other.initial && tableDefinition.max <= other.max;
  }

  const Table* getDefinition() const { return &tableDefinition; }

protected:
  const Table tableDefinition;
};

class RealRuntimeTable : public RuntimeTable {
public:
  RealRuntimeTable(Literal initial, Table table_) : RuntimeTable(table_) {
    table.resize(tableDefinition.initial, initial);
  }

  RealRuntimeTable(const RealRuntimeTable&) = delete;
  RealRuntimeTable& operator=(const RealRuntimeTable&) = delete;

  void set(std::size_t i, Literal l) override;

  Literal get(std::size_t i) const override;

  std::optional<std::size_t> grow(std::size_t delta, Literal fill) override;

  std::size_t size() const override { return table.size(); }

private:
  std::vector<Literal> table;
};

} // namespace wasm

#endif // wasm_ir_runtime_table_h
