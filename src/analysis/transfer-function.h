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
#endif

#include <queue>

#include "cfg.h"
#include "lattice.h"

namespace wasm::analysis {

#if __cplusplus >= 202002L

template<typename T>
concept BasicBlockInputRange =
  std::ranges::input_range<T> &&
  std::is_same<std::ranges::range_value_t<T>, BasicBlock>::value;

template<typename TxFn, typename L>
concept TransferFunctionImpl = requires(TxFn& txfn,
                                        const CFG& cfg,
                                        BasicBlock* bb,
                                        typename L::Element& elem,
                                        std::queue<const BasicBlock*>& bbq) {
  // Apply the transfer function to update a lattice element with information
  // from a basic block.
  { txfn.transfer(bb, elem) } noexcept -> std::same_as<void>;
  // Initializes the worklist of basic blocks, which can affect performance
  // depending on the direction of the analysis. TODO: Unlock performance
  // benefits while exposing fewer implementation details.
  { txfn.enqueueWorklist(cfg, bbq) } noexcept -> std::same_as<void>;
  // Get a range over the basic blocks that depend on the given block.
  { txfn.getDependents(bb) } noexcept -> BasicBlockInputRange;
};

#define TransferFunction TransferFunctionImpl<L>

#else

#define TransferFunction typename

#endif // __cplusplus >= 202002L

} // namespace wasm::analysis

#endif // wasm_analysis_transfer_function_h
