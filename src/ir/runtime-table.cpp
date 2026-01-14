#include "ir/runtime-table.h"
#include "interpreter/exception.h"
#include "support/stdckdint.h"
#include "wasm-limits.h"

namespace wasm {

namespace {

[[noreturn]] void trap(std::string_view reason) {
  // Print so lit tests can check this.
  std::cout << "[trap " << reason << "]\n";
  throw TrapException{};
}

} // namespace

void RealRuntimeTable::set(std::size_t i, Literal l) {
  if (i >= table.size()) {
    trap("RuntimeTable::set out of bounds");
    WASM_UNREACHABLE("trapped");
  }

  table[i] = std::move(l);
}

Literal RealRuntimeTable::get(std::size_t i) const {
  if (i >= table.size()) {
    trap("out of bounds table access");
    WASM_UNREACHABLE("trapped");
  }

  return table[i];
}

std::optional<std::size_t> RealRuntimeTable::grow(std::size_t delta,
                                                  Literal fill) {
  std::size_t newSize;
  if (std::ckd_add(&newSize, table.size(), delta)) {
    return std::nullopt;
  }

  if (newSize > WebLimitations::MaxTableSize || newSize > tableMeta_.max) {
    return std::nullopt;
  }

  std::size_t oldSize = table.size();
  table.resize(newSize, fill);
  return oldSize;
}

} // namespace wasm
