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

  if (newSize > WebLimitations::MaxTableSize || newSize > tableDefinition.max) {
    return std::nullopt;
  }

  std::size_t oldSize = table.size();
  table.resize(newSize, fill);
  return oldSize;
}

} // namespace wasm
