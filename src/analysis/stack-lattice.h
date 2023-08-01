#ifndef wasm_analysis_stack_lattice_h
#define wasm_analysis_stack_lattice_h

#include <deque>
#include <optional>

#include "lattice.h"

namespace wasm::analysis {

// Models the WASM value stack
// A lattice for modelling stack-related phenomena. It is templated
// on a lattice representing the contents of each stack element.
template<typename StackElementLattice> class StackLattice {
  static_assert(is_lattice<StackElementLattice>);
  StackElementLattice& stackElementLattice;

public:
  StackLattice(StackElementLattice& stackElementLattice)
    : stackElementLattice(stackElementLattice) {}

  class Element {
    // The top lattice is
    std::optional<std::deque<typename StackElementLattice::Element>>
      stackValue = std::deque<typename StackElementLattice::Element>();

    // Indicates if the lattice element is the top element, which theoretically
    // would be an infinite-height stack. In practice, if this flag is raised,
    // we ignore the actual stack and treat it like the top element.

  public:
    bool isTop() const { return !stackValue.has_value(); }
    bool isBottom() const {
      return stackValue.has_value() && stackValue->empty();
    }
    void setToTop() { stackValue.reset(); }

    typename StackElementLattice::Element& stackTop() {
      return stackValue->back();
    }

    void push(typename StackElementLattice::Element&& element) {
      if (stackValue.has_value() &&
          (!stackValue->empty() || !element.isBottom())) {
        stackValue->push_back(std::move(element));
      }
    }

    void push(const typename StackElementLattice::Element& element) {
      if (stackValue.has_value() &&
          (!stackValue->empty() || !element.isBottom())) {
        stackValue->push_back(std::move(element));
      }
    }

    typename StackElementLattice::Element pop() {
      typename StackElementLattice::Element value = stackValue->back();
      stackValue->pop_back();
      return value;
    }

    // When taking the LUB, we take the LUBs of the elements of the suffixes of
    // each stack. This is because when we have stack1 = [a] and stack2 = [b',
    // a'] which is from a scope which encloses the scope of stack1, we want the
    // result to be [b', LUB(a, a')]. We can alternatively imagine that each
    // stack is of infinite height, with all elements lower than the lowest
    // observable element abeing bottom elements.
    bool makeLeastUpperBound(const Element& other) {
      if (!stackValue.has_value()) {
        return false;
      } else if (!other.stackValue.has_value()) {
        stackValue.reset();
        return true;
      }

      bool modified = false;

      // Merge the shorter height stack with the suffix of the longer height
      // stack. We do this by taking the LUB of each pair of matching elements
      // from both stacks.
      auto otherIterator = other.stackValue->crbegin();
      auto thisIterator = stackValue->rbegin();
      for (; thisIterator != stackValue->rend() &&
             otherIterator != other.stackValue->crend();
           ++thisIterator, ++otherIterator) {
        modified |= thisIterator->makeLeastUpperBound(*otherIterator);
      }

      // If the other stack is higher, append the prefix of it to our current
      // stack.
      for (; otherIterator != other.stackValue->crend(); ++otherIterator) {
        stackValue->push_front(*otherIterator);
        modified = true;
      }

      return modified;
    }

    void print(std::ostream& os) {
      if (!stackValue.has_value()) {
        os << "TOP STACK" << std::endl;
        return;
      }

      for (auto iter = stackValue->rbegin(); iter != stackValue->rend();
           ++iter) {
        iter->print(os);
        os << std::endl;
      }
    }

    friend StackLattice;
  };

  // Like in computing the LUB, we compare the suffixes of the two stacks.
  // If the left stack is higher, and left suffix >= right suffix, then we say
  // that left stack > right stack. If the left stack is lower an left suffix >=
  // right suffix or if the left stack is higher and the right suffix > left
  // suffix or they are unrelated, then there is no relation. Same applies for
  // the reverse relationship.
  LatticeComparison compare(const Element& left, const Element& right) {
    if (left.isTop()) {
      if (right.isTop()) {
        return LatticeComparison::EQUAL;
      } else {
        return LatticeComparison::GREATER;
      }
    } else if (right.isTop()) {
      return LatticeComparison::LESS;
    }

    bool hasLess = false;
    bool hasGreater = false;

    // Check the suffixes of both stacks. If there is an unrelated pair of
    // elements, or if there is both a > and a <, then the stacks must be
    // unrelated.
    for (auto leftIterator = left.stackValue->crbegin(),
              rightIterator = right.stackValue->crbegin();
         leftIterator != left.stackValue->crend() &&
         rightIterator != right.stackValue->crend();
         ++leftIterator, ++rightIterator) {
      LatticeComparison currComparison =
        stackElementLattice.compare(*leftIterator, *rightIterator);
      switch (currComparison) {
        case LatticeComparison::NO_RELATION:
          return LatticeComparison::NO_RELATION;
          break;
        case LatticeComparison::LESS:
          hasLess = true;
          break;
        case LatticeComparison::GREATER:
          hasGreater = true;
          break;
        default:
          break;
      }
    }

    // Check cases for when the stacks have unequal or equal heights.
    // As a rule, if a stack is higher, it is greater than the other stack, but
    // if and only if their suffixes have the same greater than or equal
    // relationship.
    if (left.stackValue->size() > right.stackValue->size()) {
      hasGreater = true;
    } else if (right.stackValue->size() > left.stackValue->size()) {
      hasLess = true;
    }

    if (hasLess && !hasGreater) {
      return LatticeComparison::LESS;
    } else if (hasGreater && !hasLess) {
      return LatticeComparison::GREATER;
    } else if (hasLess && hasGreater) {
      return LatticeComparison::NO_RELATION;
    } else {
      return LatticeComparison::EQUAL;
    }
  }

  Element getBottom() {
    Element result;
    return result;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_stack_lattice_h
