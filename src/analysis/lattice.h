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

#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#if __cplusplus >= 202002L
#include <concepts>
#endif

namespace wasm::analysis {

enum LatticeComparison { NO_RELATION, EQUAL, LESS, GREATER };

// If parameter "comparison" compares x and y, the function returns the opposite
// direction comparison between y and x.
inline LatticeComparison reverseComparison(LatticeComparison comparison) {
  if (comparison == LatticeComparison::LESS) {
    return LatticeComparison::GREATER;
  } else if (comparison == LatticeComparison::GREATER) {
    return LatticeComparison::LESS;
  } else {
    return comparison;
  }
}

#if __cplusplus >= 202002L

template<typename L>
concept Lattice = requires(const L& lattice,
                           const typename L::Element& constElem,
                           typename L::Element& elem) {
  // Lattices must have elements.
  typename L::Element;
  // We need to be able to get the bottom element.
  { lattice.getBottom() } noexcept -> std::same_as<typename L::Element>;
  // Elements should be comparable. TODO: use <=> and std::three_way_comparable
  // once we support C++20 everywhere.
  {
    lattice.compare(constElem, constElem)
  } noexcept -> std::same_as<LatticeComparison>;
  // We need to be able to get the least upper bound of two elements and know
  // whether any change was made.
  { elem.makeLeastUpperBound(constElem) } noexcept -> std::same_as<bool>;
};

#else

#define Lattice typename

#endif // __cplusplus >= 202002L

} // namespace wasm::analysis

#endif // wasm_analysis_lattice_h
