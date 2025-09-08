/*
 * Copyright 2023 WebAssembly Community Group participants
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

#ifndef wasm_analysis_transfer_function_h
#define wasm_analysis_transfer_function_h

#if __cplusplus >= 202002L

#include <concepts>
#include <iterator>
#include <ranges>

#include "cfg.h"
#include "lattice.h"
#include "support/unique_deferring_queue.h"

namespace wasm::analysis {

template<typename T>
concept BasicBlockInputRange =
  std::ranges::input_range<T> &&
  std::is_same<std::ranges::range_value_t<T>, const BasicBlock*>::value;

template<typename TxFn, typename L>
concept TransferFunctionImpl = requires(
  TxFn& txfn, const CFG& cfg, const BasicBlock& bb, typename L::Element& elem) {
  // Apply the transfer function to update a lattice element with information
  // from a basic block. Return an object that can be iterated over to get the
  // basic blocks that may need to be re-analyzed.
  { txfn.transfer(bb, elem) } noexcept -> BasicBlockInputRange;
};

#define TransferFunction TransferFunctionImpl<L>

} // namespace wasm::analysis

#else // __cplusplus >= 202002L

#define TransferFunction typename

#endif // __cplusplus >= 202002L

#endif // wasm_analysis_transfer_function_h
