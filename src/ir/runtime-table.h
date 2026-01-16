#ifndef wasm_ir_runtime_table_h
#define wasm_ir_runtime_table_h

#include <stddef.h>
#include <vector>

#include "literal.h"
#include "wasm.h"

namespace wasm {

// Traps on out of bounds access
class RuntimeTable {
public:
  // TODO: constructor for initial contents?
  RuntimeTable(Table table_, std::function<void(std::string_view s)> trap_)
    : tableMeta_(table_), trap(trap_) {}

  void set(std::size_t i, Literal l);

  Literal get(std::size_t i) const;

  // Returns nullopt if the table grew beyond the max possible size.
  [[nodiscard]] std::optional<std::size_t> grow(std::size_t delta,
                                                Literal fill);

  std::size_t size() const { return table.size(); }

  const Table* tableMeta() const { return &tableMeta_; }

private:
  const Table tableMeta_;
  std::vector<Literal> table;
  std::function<void(std::string_view)> trap;
};

} // namespace wasm

#endif // wasm_ir_runtime_table_h
