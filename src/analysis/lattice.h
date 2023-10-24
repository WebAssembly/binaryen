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
#endif // __cplusplus >= 202002L

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
  requires std::copyable<typename L::Element>;
  // Get the bottom element of this lattice.
  { lattice.getBottom() } noexcept -> std::same_as<typename L::Element>;
  // Compare two elements of this lattice. TODO: use <=> and
  // std::three_way_comparable once we support C++20 everywhere.
  {
    lattice.compare(constElem, constElem)
  } noexcept -> std::same_as<LatticeComparison>;
  // Modify `elem` in-place to be the join (aka least upper bound) of `elem` and
  // `constElem`, returning true iff `elem` was modified, i.e. if it was not
  // already an upper bound of `constElem`.
  { lattice.join(elem, constElem) } noexcept -> std::same_as<bool>;
};

// The analysis framework only uses bottom elements and least upper bounds (i.e.
// joins) directly, so lattices do not necessarily need to implement top
// elements and greatest lower bounds (i.e. meets) to be useable, even though
// they are required for mathematical lattices. Implementing top elements and
// meets does have the benefit of making a lattice generically invertable,
// though. See lattices/inverted.h.
template<typename L>
concept FullLattice =
  Lattice<L> && requires(const L& lattice,
                         const typename L::Element& constElem,
                         typename L::Element& elem) {
    // Get the top element of this lattice.
    { lattice.getTop() } noexcept -> std::same_as<typename L::Element>;
    // Modify `elem` in-place to be the meet (aka greatest lower bound) of
    // `elem` and `constEleme`, returning true iff `elem` was modified, i.e. if
    // it was not already a lower bound of `constElem`.
    { lattice.meet(elem, constElem) } noexcept -> std::same_as<bool>;
  };

#else // __cplusplus >= 202002L

#define Lattice typename
#define FullLattice typename

#endif // __cplusplus >= 202002L

} // namespace wasm::analysis

#endif // wasm_analysis_lattice_h
