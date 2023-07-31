#ifndef wasm_analysis_stack_lattice_h
#define wasm_analysis_stack_lattice_h

#include <deque>

#include "lattice.h"

namespace wasm::analysis {

template<typename StackFrameLattice> class StackLattice {
  static_assert(is_lattice<StackFrameLattice>);
  StackFrameLattice& stackFrameLattice;

public:
  StackLattice(StackFrameLattice& stackFrameLattice)
    : stackFrameLattice(stackFrameLattice) {}

  class Element {
    std::deque<typename StackFrameLattice::Element> stackValue;
    bool top = false;

  public:
    Element() = default;

    Element(Element&& source) = default;
    Element(Element& source) = default;

    Element& operator=(Element&& source) = default;
    Element& operator=(const Element& source) = default;

    bool isTop() { return top; }
    void setTop(bool val) { top = val; }
    bool isBottom() { return !isTop && stackValue.empty(); }

    typename StackFrameLattice::Element& stackTop() {
      return stackValue.back();
    }
    void push(typename StackFrameLattice::Element frame) {
      stackValue.push_back(frame);
    }
    void pop() { stackValue.pop_back(); }

    bool makeLeastUpperBound(const Element& other) {
      bool modified = false;
      auto otherIterator = other.stackValue.crbegin();
      for (auto thisIterator = stackValue.rbegin();
           thisIterator != stackValue.rend();
           ++thisIterator) {
        if (otherIterator != other.stackValue.crend()) {
          modified |= (*thisIterator).makeLeastUpperBound(*otherIterator);
          ++otherIterator;
        }
      }

      while (otherIterator != other.stackValue.crend()) {
        stackValue.push_front(*otherIterator);
        modified = true;
        ++otherIterator;
      }

      return modified;
    }

    void print(std::ostream& os) {
      for (auto iter = stackValue.rbegin(); iter != stackValue.rend(); ++iter) {
        (*iter).print(os);
        os << std::endl;
      }
    }

    friend StackLattice;
  };

  LatticeComparison compare(const Element& left, const Element& right) {
    auto leftIterator = left.stackValue.crbegin();
    auto rightIterator = right.stackValue.crbegin();

    bool hasEqual = false;
    bool hasLess = false;
    bool hasGreater = false;
    bool hasUnrelated = false;

    while (leftIterator != left.stackValue.crend() &&
           rightIterator != right.stackValue.crend()) {
      LatticeComparison currComparison =
        stackFrameLattice.compare(*leftIterator, *rightIterator);
      switch (currComparison) {
        case LatticeComparison::EQUAL:
          hasEqual = true;
          break;
        case LatticeComparison::LESS:
          hasLess = true;
          break;
        case LatticeComparison::GREATER:
          hasGreater = true;
          break;
        default:
          hasUnrelated = true;
      }
      ++leftIterator;
      ++rightIterator;
    }

    if (left.stackValue.size() > right.stackValue.size()) {
      if (!hasUnrelated && !hasLess) {
        return LatticeComparison::GREATER;
      } else {
        return LatticeComparison::NO_RELATION;
      }
    } else if (right.stackValue.size() > left.stackValue.size()) {
      if (!hasUnrelated && !hasGreater) {
        return LatticeComparison::LESS;
      } else {
        return LatticeComparison::NO_RELATION;
      }
    } else {
      if (hasUnrelated) {
        return LatticeComparison::NO_RELATION;
      } else if (hasLess && !hasGreater) {
        return LatticeComparison::LESS;
      } else if (hasGreater && !hasLess) {
        return LatticeComparison::GREATER;
      } else if (hasEqual && !hasGreater && !hasLess) {
        return LatticeComparison::EQUAL;
      } else {
        return LatticeComparison::NO_RELATION;
      }
    }
  }

  Element getBottom() {
    Element result;
    return result;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_stack_lattice_h