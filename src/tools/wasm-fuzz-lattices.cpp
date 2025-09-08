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

#include <optional>
#include <random>
#include <string>
#include <type_traits>
#include <variant>

#include "analysis/lattice.h"
#include "analysis/lattices/array.h"
#include "analysis/lattices/bool.h"
#include "analysis/lattices/flat.h"
#include "analysis/lattices/int.h"
#include "analysis/lattices/inverted.h"
#include "analysis/lattices/lift.h"
#include "analysis/lattices/shared.h"
#include "analysis/lattices/stack.h"
#include "analysis/lattices/tuple.h"
#include "analysis/lattices/valtype.h"
#include "analysis/lattices/vector.h"
#include "analysis/liveness-transfer-function.h"
#include "analysis/reaching-definitions-transfer-function.h"
#include "analysis/transfer-function.h"

#include "support/command-line.h"
#include "tools/fuzzing.h"
#include "tools/fuzzing/random.h"

namespace wasm {
using RandEngine = std::mt19937_64;
using namespace analysis;

// Helps printing error messages.
std::string LatticeComparisonNames[4] = {
  "No Relation", "Equal", "Less", "Greater"};

uint64_t getSeed() {
  // Return a (truly) random 64-bit value.
  std::random_device rand;
  return std::uniform_int_distribution<uint64_t>{}(rand);
}

// Actually a pointer to `L::ElementImpl`, but we erase the type to avoid
// getting into a situation where `L` satisfying `Lattice` or `FullLattice`
// circularly requires that `L` satisfies `Lattice` or `FullLattice`. C++ does
// not allow concepts to depend on themselves. Also make the pointer copyable to
// satisfy that constraint on lattice elements.
template<typename L>
struct RandomElement : std::unique_ptr<void, void (*)(void*)> {
  RandomElement() = default;

  RandomElement(typename L::ElementImpl&& other)
    : std::unique_ptr<void, void (*)(void*)>(
        new typename L::ElementImpl(std::move(other)),
        [](void* e) { delete static_cast<typename L::ElementImpl*>(e); }) {}

  RandomElement(const RandomElement& other)
    : RandomElement([&]() {
        auto copy = *other;
        return copy;
      }()) {}

  RandomElement(RandomElement&& other) = default;
  RandomElement& operator=(const RandomElement& other) {
    if (this != &other) {
      new (this) RandomElement(other);
    }
    return *this;
  }

  RandomElement& operator=(RandomElement&& other) = default;

  typename L::ElementImpl& operator*() {
    return *static_cast<typename L::ElementImpl*>(get());
  }

  const typename L::ElementImpl& operator*() const {
    return *static_cast<const typename L::ElementImpl*>(get());
  }

  typename L::ElementImpl* operator->() { return &*(*this); }

  const typename L::ElementImpl* operator->() const { return &*(*this); }
};

struct RandomFullLattice {
  // The inner lattice and lattice element types. These must be defined later
  // because they depend on `RandomFullLattice` satisfying `FullLattice`, but
  // that requires the type to be complete.
  struct LatticeImpl;
  struct ElementImpl;
  using Element = RandomElement<RandomFullLattice>;

  Random& rand;

  // Indirect because LatticeImpl recursively contains RandomFullLattice.
  std::unique_ptr<LatticeImpl> lattice;

  RandomFullLattice(Random& rand,
                    size_t depth = 0,
                    std::optional<uint32_t> maybePick = std::nullopt);

  // Make a random element of this lattice.
  Element makeElement() const noexcept;

  Element getBottom() const noexcept;
  Element getTop() const noexcept;
  LatticeComparison compare(const Element& a, const Element& b) const noexcept;
  bool join(Element& a, const Element& b) const noexcept;
  bool meet(Element& a, const Element& b) const noexcept;
};

struct RandomLattice {
  // The inner lattice and lattice element types. These must be defined later
  // because they depend on `RandomLattice` satisfying `Lattice`, but that
  // requires the type to be complete.
  struct LatticeImpl;
  struct ElementImpl;
  using Element = RandomElement<RandomLattice>;

  Random& rand;

  // Indirect because L recursively contains RandomLattice.
  std::unique_ptr<LatticeImpl> lattice;

  RandomLattice(Random& rand, size_t depth = 0);

  // Make a random element of this lattice.
  Element makeElement() const noexcept;

  Element getBottom() const noexcept;
  LatticeComparison compare(const Element& a, const Element& b) const noexcept;
  bool join(Element& a, const Element& b) const noexcept;
};

#if __cplusplus >= 202002L
static_assert(FullLattice<RandomFullLattice>);
static_assert(Lattice<RandomLattice>);
#endif

using ArrayFullLattice = analysis::Array<RandomFullLattice, 2>;
using ArrayLattice = analysis::Array<RandomLattice, 2>;

using TupleFullLattice = analysis::Tuple<RandomFullLattice, RandomFullLattice>;
using TupleLattice = analysis::Tuple<RandomLattice, RandomLattice>;

using FullLatticeVariant = std::variant<Bool,
                                        UInt32,
                                        ValType,
                                        Inverted<RandomFullLattice>,
                                        ArrayFullLattice,
                                        Vector<RandomFullLattice>,
                                        TupleFullLattice>;

struct RandomFullLattice::LatticeImpl : FullLatticeVariant {};

using FullLatticeElementVariant =
  std::variant<typename Bool::Element,
               typename UInt32::Element,
               typename ValType::Element,
               typename Inverted<RandomFullLattice>::Element,
               typename ArrayFullLattice::Element,
               typename Vector<RandomFullLattice>::Element,
               typename TupleFullLattice::Element>;

struct RandomFullLattice::ElementImpl : FullLatticeElementVariant {};

using LatticeVariant = std::variant<RandomFullLattice,
                                    Flat<uint32_t>,
                                    Lift<RandomLattice>,
                                    ArrayLattice,
                                    Vector<RandomLattice>,
                                    TupleLattice,
                                    SharedPath<RandomLattice>>;

struct RandomLattice::LatticeImpl : LatticeVariant {};

using LatticeElementVariant =
  std::variant<typename RandomFullLattice::Element,
               typename Flat<uint32_t>::Element,
               typename Lift<RandomLattice>::Element,
               typename ArrayLattice::Element,
               typename Vector<RandomLattice>::Element,
               typename TupleLattice::Element,
               typename SharedPath<RandomLattice>::Element>;

struct RandomLattice::ElementImpl : LatticeElementVariant {};

constexpr int FullLatticePicks = 7;

RandomFullLattice::RandomFullLattice(Random& rand,
                                     size_t depth,
                                     std::optional<uint32_t> maybePick)
  : rand(rand) {
  // TODO: Limit the depth once we get lattices with more fan-out.
  uint32_t pick = maybePick ? *maybePick : rand.upTo(FullLatticePicks);
  switch (pick) {
    case 0:
      lattice = std::make_unique<LatticeImpl>(LatticeImpl{Bool{}});
      return;
    case 1:
      lattice = std::make_unique<LatticeImpl>(LatticeImpl{UInt32{}});
      return;
    case 2:
      lattice = std::make_unique<LatticeImpl>(LatticeImpl{ValType{}});
      return;
    case 3:
      lattice = std::make_unique<LatticeImpl>(
        LatticeImpl{Inverted{RandomFullLattice{rand, depth + 1}}});
      return;
    case 4:
      lattice = std::make_unique<LatticeImpl>(
        LatticeImpl{ArrayFullLattice{RandomFullLattice{rand, depth + 1}}});
      return;
    case 5:
      lattice = std::make_unique<LatticeImpl>(
        LatticeImpl{Vector{RandomFullLattice{rand, depth + 1}, rand.upTo(4)}});
      return;
    case 6:
      lattice = std::make_unique<LatticeImpl>(
        LatticeImpl{TupleFullLattice{RandomFullLattice{rand, depth + 1},
                                     RandomFullLattice{rand, depth + 1}}});
      return;
  }
  WASM_UNREACHABLE("unexpected pick");
}

RandomLattice::RandomLattice(Random& rand, size_t depth) : rand(rand) {
  // TODO: Limit the depth once we get lattices with more fan-out.
  uint32_t pick = rand.upTo(FullLatticePicks + 6);

  if (pick < FullLatticePicks) {
    lattice = std::make_unique<LatticeImpl>(
      LatticeImpl{RandomFullLattice{rand, depth, pick}});
    return;
  }

  switch (pick) {
    case FullLatticePicks + 0:
      lattice = std::make_unique<LatticeImpl>(LatticeImpl{Flat<uint32_t>{}});
      return;
    case FullLatticePicks + 1:
      lattice = std::make_unique<LatticeImpl>(
        LatticeImpl{Lift{RandomLattice{rand, depth + 1}}});
      return;
    case FullLatticePicks + 2:
      lattice = std::make_unique<LatticeImpl>(
        LatticeImpl{ArrayLattice{RandomLattice{rand, depth + 1}}});
      return;
    case FullLatticePicks + 3:
      lattice = std::make_unique<LatticeImpl>(
        LatticeImpl{Vector{RandomLattice{rand, depth + 1}, rand.upTo(4)}});
      return;
    case FullLatticePicks + 4:
      lattice = std::make_unique<LatticeImpl>(LatticeImpl{TupleLattice{
        RandomLattice{rand, depth + 1}, RandomLattice{rand, depth + 1}}});
      return;
    case FullLatticePicks + 5:
      lattice = std::make_unique<LatticeImpl>(
        LatticeImpl{SharedPath{RandomLattice{rand, depth + 1}}});
      return;
  }
  WASM_UNREACHABLE("unexpected pick");
}

RandomFullLattice::Element RandomFullLattice::makeElement() const noexcept {
  if (std::get_if<Bool>(lattice.get())) {
    return ElementImpl{rand.pick(true, false)};
  }
  if (std::get_if<UInt32>(lattice.get())) {
    return ElementImpl{rand.upToSquared(33)};
  }
  if (std::get_if<ValType>(lattice.get())) {
    Type type;
    // Choose a random type. No need to make all possible types available as
    // long as we cover all the kinds of relationships between types.
    switch (rand.upTo(8)) {
      case 0:
        type = Type::unreachable;
        break;
      case 1:
        type = Type::none;
        break;
      case 2:
        type = Type::i32;
        break;
      case 3:
        type = Type::f32;
        break;
      case 4:
        type = Type(HeapType::any, rand.oneIn(2) ? Nullable : NonNullable);
        break;
      case 5:
        type = Type(HeapType::none, rand.oneIn(2) ? Nullable : NonNullable);
        break;
      case 6:
        type = Type(HeapType::struct_, rand.oneIn(2) ? Nullable : NonNullable);
        break;
      case 7:
        type = Type(HeapType::array, rand.oneIn(2) ? Nullable : NonNullable);
        break;
    }
    return ElementImpl{type};
  }
  if (const auto* l = std::get_if<Inverted<RandomFullLattice>>(lattice.get())) {
    return ElementImpl{l->lattice.makeElement()};
  }
  if (const auto* l = std::get_if<ArrayFullLattice>(lattice.get())) {
    return ElementImpl{typename ArrayFullLattice::Element{
      l->lattice.makeElement(), l->lattice.makeElement()}};
  }
  if (const auto* l = std::get_if<Vector<RandomFullLattice>>(lattice.get())) {
    std::vector<typename RandomFullLattice::Element> elem;
    elem.reserve(l->size);
    for (size_t i = 0; i < l->size; ++i) {
      elem.push_back(l->lattice.makeElement());
    }
    return ElementImpl{std::move(elem)};
  }
  if (const auto* l = std::get_if<TupleFullLattice>(lattice.get())) {
    return ElementImpl{typename TupleFullLattice::Element{
      std::get<0>(l->lattices).makeElement(),
      std::get<1>(l->lattices).makeElement()}};
  }
  WASM_UNREACHABLE("unexpected lattice");
}

RandomLattice::Element RandomLattice::makeElement() const noexcept {
  if (const auto* l = std::get_if<RandomFullLattice>(lattice.get())) {
    return ElementImpl{l->makeElement()};
  }
  if (const auto* l = std::get_if<Flat<uint32_t>>(lattice.get())) {
    auto pick = rand.upTo(6);
    switch (pick) {
      case 4:
        return ElementImpl{l->getBottom()};
      case 5:
        return ElementImpl{l->getTop()};
      default:
        return ElementImpl{l->get(std::move(pick))};
    }
  }
  if (const auto* l = std::get_if<Lift<RandomLattice>>(lattice.get())) {
    return ElementImpl{rand.oneIn(4) ? l->getBottom()
                                     : l->get(l->lattice.makeElement())};
  }
  if (const auto* l = std::get_if<ArrayLattice>(lattice.get())) {
    return ElementImpl{typename ArrayLattice::Element{
      l->lattice.makeElement(), l->lattice.makeElement()}};
  }
  if (const auto* l = std::get_if<Vector<RandomLattice>>(lattice.get())) {
    std::vector<typename RandomLattice::Element> elem;
    elem.reserve(l->size);
    for (size_t i = 0; i < l->size; ++i) {
      elem.push_back(l->lattice.makeElement());
    }
    return ElementImpl{std::move(elem)};
  }
  if (const auto* l = std::get_if<TupleLattice>(lattice.get())) {
    return ElementImpl{
      typename TupleLattice::Element{std::get<0>(l->lattices).makeElement(),
                                     std::get<1>(l->lattices).makeElement()}};
  }
  if (const auto* l = std::get_if<SharedPath<RandomLattice>>(lattice.get())) {
    auto elem = l->getBottom();
    l->join(elem, l->lattice.makeElement());
    return ElementImpl{elem};
  }
  WASM_UNREACHABLE("unexpected lattice");
}

void indent(std::ostream& os, int depth) {
  for (int i = 0; i < depth; ++i) {
    os << "  ";
  }
}

void printFullElement(std::ostream& os,
                      const typename RandomFullLattice::Element& elem,
                      int depth) {
  indent(os, depth);

  if (const auto* e = std::get_if<typename Bool::Element>(&*elem)) {
    os << (*e ? "true" : "false") << "\n";
  } else if (const auto* e = std::get_if<typename UInt32::Element>(&*elem)) {
    os << *e << "\n";
  } else if (const auto* e = std::get_if<typename ValType::Element>(&*elem)) {
    os << *e << "\n";
  } else if (const auto* e =
               std::get_if<typename Inverted<RandomFullLattice>::Element>(
                 &*elem)) {
    os << "Inverted(\n";
    printFullElement(os, *e, depth + 1);
    indent(os, depth);
    os << ")\n";
  } else if (const auto* e =
               std::get_if<typename ArrayFullLattice::Element>(&*elem)) {
    os << "Array[\n";
    printFullElement(os, e->front(), depth + 1);
    printFullElement(os, e->back(), depth + 1);
    indent(os, depth);
    os << "]\n";
  } else if (const auto* vec =
               std::get_if<typename Vector<RandomFullLattice>::Element>(
                 &*elem)) {
    os << "Vector[\n";
    for (const auto& e : *vec) {
      printFullElement(os, e, depth + 1);
    }
    indent(os, depth);
    os << "]\n";
  } else if (const auto* e =
               std::get_if<typename TupleFullLattice::Element>(&*elem)) {
    os << "Tuple(\n";
    const auto& [first, second] = *e;
    printFullElement(os, first, depth + 1);
    printFullElement(os, second, depth + 1);
    indent(os, depth);
    os << ")\n";
  } else {
    WASM_UNREACHABLE("unexpected element");
  }
}

void printElement(std::ostream& os,
                  const typename RandomLattice::Element& elem,
                  int depth = 0) {
  if (const auto* e =
        std::get_if<typename RandomFullLattice::Element>(&*elem)) {
    printFullElement(os, *e, depth);
    return;
  }

  indent(os, depth);

  if (const auto* e = std::get_if<typename Flat<uint32_t>::Element>(&*elem)) {
    if (e->isBottom()) {
      os << "flat bot\n";
    } else if (e->isTop()) {
      os << "flat top\n";
    } else {
      os << "flat " << *e->getVal() << "\n";
    }
  } else if (const auto* e =
               std::get_if<typename Lift<RandomLattice>::Element>(&*elem)) {
    if (e->isBottom()) {
      os << "lift bot\n";
    } else {
      os << "Lifted(\n";
      printElement(os, **e, depth + 1);
      indent(os, depth);
      os << ")\n";
    }
  } else if (const auto* e =
               std::get_if<typename ArrayLattice::Element>(&*elem)) {
    os << "Array[\n";
    printElement(os, e->front(), depth + 1);
    printElement(os, e->back(), depth + 1);
    indent(os, depth);
    os << ")\n";
  } else if (const auto* vec =
               std::get_if<typename Vector<RandomLattice>::Element>(&*elem)) {
    os << "Vector[\n";
    for (const auto& e : *vec) {
      printElement(os, e, depth + 1);
    }
    indent(os, depth);
    os << "]\n";
  } else if (const auto* e =
               std::get_if<typename TupleLattice::Element>(&*elem)) {
    os << "Tuple(\n";
    const auto& [first, second] = *e;
    printElement(os, first, depth + 1);
    printElement(os, second, depth + 1);
    indent(os, depth);
    os << ")\n";
  } else if (const auto* e =
               std::get_if<typename SharedPath<RandomLattice>::Element>(
                 &*elem)) {
    os << "SharedPath(\n";
    printElement(os, **e, depth + 1);
    indent(os, depth);
    os << ")\n";
  } else {
    WASM_UNREACHABLE("unexpected element");
  }
}

std::ostream& operator<<(std::ostream& os,
                         const typename RandomLattice::Element& elem) {
  printElement(os, elem);
  return os;
}

// Check that random lattices have the correct mathematical properties by
// checking the relationships between random elements.
void checkLatticeProperties(Random& rand, bool verbose) {
  RandomLattice lattice(rand);

  // Generate the lattice elements we will perform checks on.
  typename RandomLattice::Element elems[3] = {
    lattice.makeElement(), lattice.makeElement(), lattice.makeElement()};

  if (verbose) {
    std::cout << "Random lattice elements:\n"
              << elems[0] << "\n"
              << elems[1] << "\n"
              << elems[2];
  }

  // Calculate the relations between the generated elements.
  LatticeComparison relation[3][3];
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      relation[i][j] = lattice.compare(elems[i], elems[j]);
    }
  }

  // Reflexivity: x == x
  for (int i = 0; i < 3; ++i) {
    if (lattice.compare(elems[i], elems[i]) != EQUAL) {
      Fatal() << "Lattice element is not reflexive:\n" << elems[i];
    }
  }

  // Anti-symmetry: x < y implies y > x, etc.
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      auto forward = relation[i][j];
      auto reverse = relation[j][i];
      if (reverseComparison(forward) != reverse) {
        Fatal()
          << "Lattice elements are not anti-symmetric.\nFirst element:\n\n"
          << elems[i] << "\nSecond element:\n\n"
          << elems[j]
          << "\nForward relation: " << LatticeComparisonNames[forward]
          << "\nReverse relation: " << LatticeComparisonNames[reverse] << "\n";
      }
    }
  }

  // Transitivity: x < y and y < z imply x < z, etc.
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      for (int k = 0; k < 3; ++k) {
        auto ij = relation[i][j], jk = relation[j][k], ik = relation[i][k];
        if (ij == NO_RELATION || jk == NO_RELATION) {
          continue;
        }
        if ((ij == LESS && jk == GREATER) || (ij == GREATER && jk == LESS)) {
          continue;
        }
        auto expected = ij == EQUAL ? jk : ij;
        if (ik != expected) {
          Fatal() << "Lattice elements are not transitive.\nFrist element:\n\n"
                  << elems[i] << "\nSecond element:\n\n"
                  << elems[j] << "\nThird element:\n\n"
                  << elems[k] << "\nFirst to second relation: "
                  << LatticeComparisonNames[ij]
                  << "\nSecond to third relation: "
                  << LatticeComparisonNames[jk]
                  << "\nFirst to thrid relation: " << LatticeComparisonNames[ik]
                  << "\n";
        }
      }
    }
  }

  // Joins (i.e. least upper bounds)
  for (int i = 0; i < 3; ++i) {
    {
      // Identity: elem u bot = elem
      auto join = elems[i];
      lattice.join(join, lattice.getBottom());
      if (lattice.compare(join, elems[i]) != EQUAL) {
        Fatal()
          << "Join of element and bottom is not equal to element:\nElement:\n\n"
          << elems[i] << "\nJoin:\n\n"
          << join;
      }
    }
    {
      // Identity: bot u elem = elem
      auto join = lattice.getBottom();
      lattice.join(join, elems[i]);
      if (lattice.compare(join, elems[i]) != EQUAL) {
        Fatal()
          << "Join of bottom and element is not equal to element:\nElement:\n\n"
          << elems[i] << "\nJoin:\n\n"
          << join;
      }
    }
    {
      // Identity: elem u elem = elem
      auto join = elems[i];
      lattice.join(join, elems[i]);
      if (lattice.compare(join, elems[i]) != EQUAL) {
        Fatal()
          << "Join of element with itself  equal to element:\nElement:\n\n"
          << elems[i] << "\nJoin:\n\n"
          << join;
      }
    }
    for (int j = 0; j < 3; ++j) {
      // Commutativity: x u y = y u x
      auto ij = elems[i];
      bool ijModified = lattice.join(ij, elems[j]);
      auto ji = elems[j];
      bool jiModified = lattice.join(ji, elems[i]);
      if (lattice.compare(ij, ji) != EQUAL) {
        Fatal() << "Join is not commutative:\nFirst element:\n\n"
                << elems[i] << "\nSecond element:\n\n"
                << elems[j] << "\nJoin(first, second):\n\n"
                << ij << "\nJoin(second, first):\n\n"
                << ji;
      }

      // Identity: x < y implies x u y = y
      if (relation[i][j] == LESS) {
        if (lattice.compare(ij, elems[j]) != EQUAL) {
          Fatal()
            << "Join is not equal to greater element:\nLesser element:\n\n"
            << elems[i] << "\nGreater element:\n\n"
            << elems[j] << "\nJoin:\n\n"
            << ij;
        }
        if (jiModified) {
          Fatal()
            << "Join incorrectly reported modification:\nLesser element:\n\n"
            << elems[i] << "\nGreater element:\n\n"
            << elems[j];
        }
        if (!ijModified) {
          Fatal()
            << "Join should have reported modification:\nLesser element:\n\n"
            << elems[i] << "\nGreater element:\n\n"
            << elems[j];
        }
      }

      for (int k = 0; k < 3; ++k) {
        // *Least* upper bound: x <= z && y <= z implies x u y <= z
        if (relation[i][k] == LESS && relation[j][k] == LESS) {
          auto IJtoK = lattice.compare(ij, elems[k]);
          if (IJtoK != EQUAL && IJtoK != LESS) {
            Fatal() << "Join is not least upper bound:\nFirst element:\n\n"
                    << elems[i] << "\nSecond element:\n\n"
                    << elems[j] << "\nJoin:\n\n"
                    << ij << "\nOther upper bound:\n\n"
                    << elems[k];
          }
        }
      }
    }
  }
}

// Utility class which provides methods to check properties of the transfer
// function and lattice of an analysis.
template<Lattice L, TransferFunction TxFn> struct AnalysisChecker {
  L& lattice;
  TxFn& txfn;
  std::string latticeName;
  std::string txfnName;
  uint64_t latticeElementSeed;
  Name funcName;

  AnalysisChecker(L& lattice,
                  TxFn& txfn,
                  std::string latticeName,
                  std::string txfnName,
                  uint64_t latticeElementSeed,
                  Name funcName)
    : lattice(lattice), txfn(txfn), latticeName(latticeName),
      txfnName(txfnName), latticeElementSeed(latticeElementSeed),
      funcName(funcName) {}

  void printFailureInfo(std::ostream& os) {
    os << "Error for " << txfnName << " and " << latticeName
       << " at lattice element seed " << latticeElementSeed << " and function "
       << funcName << ".\n";
  }

  // Prints information about a particular test case consisting of a randomly
  // generated function and triple of randomly generate lattice elements.
  void printVerboseFunctionCase(std::ostream& os,
                                typename L::Element& x,
                                typename L::Element& y,
                                typename L::Element& z) {
    os << "Using lattice element seed " << latticeElementSeed << "\nGenerated "
       << latticeName << " elements:\n";
    x.print(os);
    os << ",\n";
    y.print(os);
    os << ",\n";
    z.print(os);
    os << "\nfor " << funcName << " to test " << txfnName << ".\n\n";
  }

public:
  // Given two input - output lattice pairs of a transfer function, checks if
  // the transfer function is monotonic. If this is violated, then we print out
  // the CFG block input which caused the transfer function to exhibit
  // non-monotonic behavior.
  void checkMonotonicity(const BasicBlock& bb,
                         typename L::Element& first,
                         typename L::Element& second,
                         typename L::Element& firstResult,
                         typename L::Element& secondResult) {
    LatticeComparison beforeCmp = lattice.compare(first, second);
    LatticeComparison afterCmp = lattice.compare(firstResult, secondResult);

    // Cases in which monotonicity is preserved.
    if (beforeCmp == LatticeComparison::NO_RELATION) {
      // If there is no relation in the first place, we can't expect anything.
      return;
    } else if (beforeCmp == LatticeComparison::LESS &&
               (afterCmp == LatticeComparison::LESS ||
                afterCmp == LatticeComparison::EQUAL)) {
      // x < y and f(x) <= f(y)
      return;
    } else if (beforeCmp == LatticeComparison::GREATER &&
               (afterCmp == LatticeComparison::GREATER ||
                afterCmp == LatticeComparison::EQUAL)) {
      // x > y and f(x) >= f(y)
      return;
    } else if (beforeCmp == LatticeComparison::EQUAL &&
               afterCmp == LatticeComparison::EQUAL) {
      // x = y and f(x) = f(y)
      return;
    }

    std::stringstream ss;
    printFailureInfo(ss);

    ss << "Elements ";
    first.print(ss);
    ss << " -> ";
    firstResult.print(ss);
    ss << " and ";
    second.print(ss);
    ss << " -> ";
    secondResult.print(ss);
    ss << "\n show that the transfer function is not monotone when given the "
          "input:\n";
    bb.print(ss);
    ss << "\n";

    Fatal() << ss.str();
  }

  // Checks transfer function relevant properties given a CFG and three input
  // states. It does this by applying the transfer function on each CFG block
  // using the same three input states each time and then checking properties on
  // the inputs and outputs.
  void checkTransferFunction(CFG& cfg,
                             typename L::Element x,
                             typename L::Element y,
                             typename L::Element z) {
    for (const auto& bb : cfg) {
      // Apply transfer function on each lattice element.
      auto xResult = x;
      txfn.transfer(bb, xResult);
      auto yResult = y;
      txfn.transfer(bb, yResult);
      auto zResult = z;
      txfn.transfer(bb, zResult);

      // Check monotonicity for every pair of transfer function outputs.
      checkMonotonicity(bb, x, y, xResult, yResult);
      checkMonotonicity(bb, x, z, xResult, zResult);
      checkMonotonicity(bb, y, z, yResult, zResult);
    }
  }
};

// Struct to set up and check liveness analysis lattice and transfer function.
struct LivenessChecker {
  LivenessTransferFunction txfn;
  FiniteIntPowersetLattice lattice;
  AnalysisChecker<FiniteIntPowersetLattice, LivenessTransferFunction> checker;
  LivenessChecker(Function* func, uint64_t latticeElementSeed, Name funcName)
    : lattice(func->getNumLocals()), checker(lattice,
                                             txfn,
                                             "FiniteIntPowersetLattice",
                                             "LivenessTransferFunction",
                                             latticeElementSeed,
                                             funcName) {}

  FiniteIntPowersetLattice::Element getRandomElement(Random& rand) {
    FiniteIntPowersetLattice::Element result = lattice.getBottom();

    // Uses rand to randomly select which members are to be included (i. e. flip
    // bits in the bitvector).
    for (size_t i = 0; i < lattice.getSetSize(); ++i) {
      result.set(i, rand.oneIn(2));
    }
    return result;
  }

  // Runs all checks for liveness analysis.
  void runChecks(CFG& cfg, Random& rand, bool verbose) {
    FiniteIntPowersetLattice::Element x = getRandomElement(rand);
    FiniteIntPowersetLattice::Element y = getRandomElement(rand);
    FiniteIntPowersetLattice::Element z = getRandomElement(rand);

    if (verbose) {
      checker.printVerboseFunctionCase(std::cout, x, y, z);
    }

    checker.checkTransferFunction(cfg, x, y, z);
  }
};

// Struct to set up and check reaching definitions analysis lattice and transfer
// function.
struct ReachingDefinitionsChecker {
  LocalGraph::GetSetsMap getSetsMap;
  LocalGraph::Locations locations;
  ReachingDefinitionsTransferFunction txfn;
  AnalysisChecker<FinitePowersetLattice<LocalSet*>,
                  ReachingDefinitionsTransferFunction>
    checker;
  ReachingDefinitionsChecker(Function* func,
                             uint64_t latticeElementSeed,
                             Name funcName)
    : txfn(func, getSetsMap, locations),
      checker(txfn.lattice,
              txfn,
              "FinitePowersetLattice<LocalSet*>",
              "ReachingDefinitionsTransferFunction",
              latticeElementSeed,
              funcName) {}

  FinitePowersetLattice<LocalSet*>::Element getRandomElement(Random& rand) {
    FinitePowersetLattice<LocalSet*>::Element result = txfn.lattice.getBottom();

    // Uses rand to randomly select which members are to be included (i. e. flip
    // bits in the bitvector).
    for (size_t i = 0; i < txfn.lattice.getSetSize(); ++i) {
      result.set(i, rand.oneIn(2));
    }
    return result;
  }

  // Runs all checks for reaching definitions analysis.
  void runChecks(CFG& cfg, Random& rand, bool verbose) {
    FinitePowersetLattice<LocalSet*>::Element x = getRandomElement(rand);
    FinitePowersetLattice<LocalSet*>::Element y = getRandomElement(rand);
    FinitePowersetLattice<LocalSet*>::Element z = getRandomElement(rand);

    if (verbose) {
      checker.printVerboseFunctionCase(std::cout, x, y, z);
    }

    checker.checkTransferFunction(cfg, x, y, z);
  }
};

// Uninteresting implementation details for RandomFullLattice and RandomLattice.

RandomFullLattice::Element RandomFullLattice::getBottom() const noexcept {
  return std::visit(
    [](const auto& l) -> Element { return ElementImpl{l.getBottom()}; },
    (const FullLatticeVariant&)*lattice);
}

RandomFullLattice::Element RandomFullLattice::getTop() const noexcept {
  return std::visit(
    [](const auto& l) -> Element { return ElementImpl{l.getTop()}; },
    (const FullLatticeVariant&)*lattice);
}

// TODO: use std::remove_cvref_t from C++20 instead.
template<typename T> using bare = std::remove_cv_t<std::remove_reference_t<T>>;

LatticeComparison RandomFullLattice::compare(const Element& a,
                                             const Element& b) const noexcept {
  return std::visit(
    [](const auto& l,
       const auto& elemA,
       const auto& elemB) -> LatticeComparison {
      using ElemT = typename bare<decltype(l)>::Element;
      using A = bare<decltype(elemA)>;
      using B = bare<decltype(elemB)>;
      if constexpr (std::is_same_v<ElemT, A> && std::is_same_v<ElemT, B>) {
        return l.compare(elemA, elemB);
      }
      WASM_UNREACHABLE("unexpected element types");
    },
    (const FullLatticeVariant&)*lattice,
    (const FullLatticeElementVariant&)*a,
    (const FullLatticeElementVariant&)*b);
}

bool RandomFullLattice::join(Element& a, const Element& b) const noexcept {
  return std::visit(
    [](const auto& l, auto& elemA, const auto& elemB) -> bool {
      using ElemT = typename bare<decltype(l)>::Element;
      using A = bare<decltype(elemA)>;
      using B = bare<decltype(elemB)>;
      if constexpr (std::is_same_v<ElemT, A> && std::is_same_v<ElemT, B>) {
        return l.join(elemA, elemB);
      }
      WASM_UNREACHABLE("unexpected element types");
    },
    (const FullLatticeVariant&)*lattice,
    (FullLatticeElementVariant&)*a,
    (const FullLatticeElementVariant&)*b);
}

bool RandomFullLattice::meet(Element& a, const Element& b) const noexcept {
  return std::visit(
    [](const auto& l, auto& elemA, const auto& elemB) -> bool {
      using ElemT = typename bare<decltype(l)>::Element;
      using A = bare<decltype(elemA)>;
      using B = bare<decltype(elemB)>;
      if constexpr (std::is_same_v<ElemT, A> && std::is_same_v<ElemT, B>) {
        return l.meet(elemA, elemB);
      }
      WASM_UNREACHABLE("unexpected element types");
    },
    (const FullLatticeVariant&)*lattice,
    (FullLatticeElementVariant&)*a,
    (const FullLatticeElementVariant&)*b);
}

RandomLattice::Element RandomLattice::getBottom() const noexcept {
  return std::visit(
    [](const auto& l) -> Element { return ElementImpl{l.getBottom()}; },
    (const LatticeVariant&)*lattice);
}

LatticeComparison RandomLattice::compare(const Element& a,
                                         const Element& b) const noexcept {
  return std::visit(
    [](const auto& l,
       const auto& elemA,
       const auto& elemB) -> LatticeComparison {
      using ElemT = typename bare<decltype(l)>::Element;
      using A = bare<decltype(elemA)>;
      using B = bare<decltype(elemB)>;
      if constexpr (std::is_same_v<ElemT, A> && std::is_same_v<ElemT, B>) {
        return l.compare(elemA, elemB);
      }
      WASM_UNREACHABLE("unexpected element types");
    },
    (const LatticeVariant&)*lattice,
    (const LatticeElementVariant&)*a,
    (const LatticeElementVariant&)*b);
}

bool RandomLattice::join(Element& a, const Element& b) const noexcept {
  return std::visit(
    [](const auto& l, auto& elemA, const auto& elemB) -> bool {
      using ElemT = typename bare<decltype(l)>::Element;
      using A = bare<decltype(elemA)>;
      using B = bare<decltype(elemB)>;
      if constexpr (std::is_same_v<ElemT, A> && std::is_same_v<ElemT, B>) {
        return l.join(elemA, elemB);
      }
      WASM_UNREACHABLE("unexpected element types");
    },
    (const LatticeVariant&)*lattice,
    (LatticeElementVariant&)*a,
    (const LatticeElementVariant&)*b);
}

// The main entry point.
struct Fuzzer {
  bool verbose;

  Fuzzer(bool verbose) : verbose(verbose) {}

  // Helper function to run per-function tests. latticeElementSeed is used to
  // generate three lattice elements randomly. It is also used to select which
  // analysis is to be tested for the function.
  void runOnFunction(Function* func, uint64_t latticeElementSeed) {
    RandEngine getFuncRand(latticeElementSeed);

    // Fewer bytes are needed to generate three random lattices.
    std::vector<char> funcBytes(128);
    for (size_t i = 0; i < funcBytes.size(); i += sizeof(uint64_t)) {
      *(uint64_t*)(funcBytes.data() + i) = getFuncRand();
    }

    Random rand(std::move(funcBytes));
    checkLatticeProperties(rand, verbose);

    CFG cfg = CFG::fromFunction(func);

    switch (rand.upTo(2)) {
      case 0: {
        LivenessChecker livenessChecker(func, latticeElementSeed, func->name);
        livenessChecker.runChecks(cfg, rand, verbose);
        break;
      }
      case 1: {
        ReachingDefinitionsChecker reachingDefinitionsChecker(
          func, latticeElementSeed, func->name);
        reachingDefinitionsChecker.runChecks(cfg, rand, verbose);
        break;
      }
    }
  }

  // Generates a module. The module is used as an input to fuzz transfer
  // functions as well as randomly generated lattice element states. Lattice
  // properties are also fuzzed from the randomly generated states.
  void run(uint64_t seed,
           uint64_t* latticeElementSeed = nullptr,
           std::string* funcName = nullptr) {
    RandEngine getRand(seed);
    std::cout << "Running with seed " << seed << "\n";

    // 4kb of random bytes should be enough for anyone!
    std::vector<char> bytes(4096);
    for (size_t i = 0; i < bytes.size(); i += sizeof(uint64_t)) {
      *(uint64_t*)(bytes.data() + i) = getRand();
    }

    Module testModule;
    TranslateToFuzzReader reader(testModule, std::move(bytes));
    reader.build();

    if (verbose) {
      std::cout << "Generated test module: \n";
      std::cout << testModule;
      std::cout << "\n";
    }

    // If a specific function and lattice element seed is specified, only run
    // that.
    if (latticeElementSeed && funcName) {
      runOnFunction(testModule.getFunction(*funcName), *latticeElementSeed);
      return;
    }

    ModuleUtils::iterDefinedFunctions(testModule, [&](Function* func) {
      uint64_t funcSeed = getRand();
      runOnFunction(func, funcSeed);
    });
  }
};

} // namespace wasm

int main(int argc, const char* argv[]) {
  using namespace wasm;

  const std::string WasmFuzzTypesOption = "wasm-fuzz-lattices options";

  Options options("wasm-fuzz-lattices",
                  "Fuzz lattices for reflexivity, transitivity, and "
                  "anti-symmetry, and tranfer functions for monotonicity.");

  std::optional<uint64_t> seed;
  options.add("--seed",
              "",
              "Run a single workload generated by the given seed",
              WasmFuzzTypesOption,
              Options::Arguments::One,
              [&](Options*, const std::string& arg) {
                seed = uint64_t(std::stoull(arg));
              });

  std::optional<uint64_t> latticeElementSeed;
  options.add("--lattice-element-seed",
              "",
              "Seed which generated the lattice elements to be checked.",
              WasmFuzzTypesOption,
              Options::Arguments::One,
              [&](Options*, const std::string& arg) {
                latticeElementSeed = uint64_t(std::stoull(arg));
              });

  std::optional<std::string> functionName;
  options.add(
    "--function-name",
    "",
    "Name of the function in the module generated by --seed to be checked.",
    WasmFuzzTypesOption,
    Options::Arguments::One,
    [&](Options*, const std::string& arg) { functionName = arg; });

  bool verbose = false;
  options.add("--verbose",
              "-v",
              "Print extra information",
              WasmFuzzTypesOption,
              Options::Arguments::Zero,
              [&](Options*, const std::string& arg) { verbose = true; });

  options.parse(argc, argv);

  Fuzzer fuzzer{verbose};
  if (seed) {
    if (latticeElementSeed && functionName) {
      // Run test a single function and lattice element seed.
      fuzzer.run(*seed, &(*latticeElementSeed), &(*functionName));
    } else {
      // Run just a single workload with the given seed.
      fuzzer.run(*seed);
    }
  } else {
    // Continuously run workloads with new randomly generated seeds.
    size_t i = 0;
    RandEngine nextSeed(getSeed());
    while (true) {
      std::cout << "Iteration " << ++i << "\n";
      fuzzer.run(nextSeed());
    }
  }
  return 0;
}
