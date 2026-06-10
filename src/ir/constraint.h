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

#ifndef wasm_ir_constraint_h
#define wasm_ir_constraint_h

#include "analysis/lattices/bound.h"
#include "analysis/lattices/bounded-conjunction.h"
#include "analysis/lattices/flat.h"
#include "analysis/lattices/int.h"
#include "analysis/lattices/one-of.h"
#include "support/index.h"
#include <compare>

namespace wasm {

// BoundedConstraintsBase defines the underlying lattice type and the total
// order on its elements.
//
// The underlying lattice is a OneOf lattice containing two types of bounds:
// 1. Bound<Int64>: Bounds against 64-bit integer constants (e.g. x < 5).
//    The Int64 lattice is ordered by <.
// 2. Bound<Flat<Index>>: Bounds against other variables, represented by their
//    local/parameter Index (e.g. x < $1). The Flat<Index> lattice has no
//    order between different variable indices.
//
// An element of OneOf can be either a constant bound, a variable bound, Top,
// or Bottom.
struct BoundedConstraintsBase {
  using L = analysis::OneOf<analysis::Bound<analysis::Int64>,
                            analysis::Bound<analysis::Flat<Index>>>;

  // Defines a total order on OneOf elements to be used by BoundedConjunction.
  // It orders constant bounds before variable bounds (so variable bounds are
  // dropped first when the size limit N is exceeded), and otherwise defines
  // a linear extension of the OneOf lattice partial order.
  std::strong_ordering orderElements(const typename L::Element& a,
                                     const typename L::Element& b) const;
};

// BoundedConstraints<N> represents a conjunction of up to N constraints on a
// variable. Each constraint is either a constant bound or a variable bound.
//
// It is implemented as a BoundedConjunction over the OneOf lattice defined
// in BoundedConstraintsBase.
template<std::size_t N>
struct BoundedConstraints
  : BoundedConstraintsBase,
    analysis::BoundedConjunction<BoundedConstraints<N>,
                                 typename BoundedConstraintsBase::L,
                                 N> {
  using Super = analysis::BoundedConjunction<BoundedConstraints<N>,
                                             typename BoundedConstraintsBase::L,
                                             N>;

  BoundedConstraints()
    : BoundedConstraintsBase(),
      Super(typename BoundedConstraintsBase::L(
        analysis::Bound<analysis::Int64>(analysis::Int64{}),
        analysis::Bound<analysis::Flat<Index>>(analysis::Flat<Index>{}))) {}
};

} // namespace wasm

#endif // wasm_ir_constraint_h
