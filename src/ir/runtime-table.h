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
  virtual ~RuntimeTable() = default;

  virtual void set(std::size_t i, Literal l) = 0;

  virtual Literal get(std::size_t i) const = 0;

  // Returns nullopt if the table grew beyond the max possible size.
  [[nodiscard]] virtual std::optional<std::size_t> grow(std::size_t delta,
                                                        Literal fill) = 0;

  virtual std::size_t size() const = 0;

  virtual const Table* tableMeta() const = 0;
};

class RealRuntimeTable : public RuntimeTable {
public:
  RealRuntimeTable(Literal initial, Table table_) : tableMeta_(table_) {
    table.resize(tableMeta_.initial, initial);
  }

  RealRuntimeTable(const RealRuntimeTable&) = delete;
  RealRuntimeTable& operator=(const RealRuntimeTable&) = delete;

  void set(std::size_t i, Literal l) override;

  Literal get(std::size_t i) const override;

  std::optional<std::size_t> grow(std::size_t delta, Literal fill) override;

  std::size_t size() const override { return table.size(); }

  const Table* tableMeta() const override { return &tableMeta_; }

private:
  const Table tableMeta_;
  std::vector<Literal> table;
};

} // namespace wasm

#endif // wasm_ir_runtime_table_h
