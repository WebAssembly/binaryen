#ifndef wasm_analysis_stack_lattice_h
#define wasm_analysis_stack_lattice_h

#include <deque>

#include "lattice.h"

namespace wasm::analysis {

// A lattice for modelling stack-related phenomena. It is templated
// on a lattice representing the contents of each stack frame.
template<typename StackFrameLattice> class StackLattice {
  static_assert(is_lattice<StackFrameLattice>);
  StackFrameLattice& stackFrameLattice;

public:
  StackLattice(StackFrameLattice& stackFrameLattice)
    : stackFrameLattice(stackFrameLattice) {}

  class Element {
    std::deque<typename StackFrameLattice::Element> stackValue;

    // Indicates if the lattice element is the top element, which theoretically
    // would be an infinite-height stack. In practice, if this flag is raised,
    // we ignore the actual stack and treat it like the top element.
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

    // When taking the LUB, we take the LUBs of the frames of the suffixes of
    // each stack. This is because when we have stack1 = [a] and stack2 = [b',
    // a'] which is from a scope which encloses the scope of stack1, we want the
    // result to be [b', LUB(a, a')]. We can alternatively imagine that each
    // stack is of infinite height, with all frames lower than the lowest
    // observble frame being bottom elements.
    bool makeLeastUpperBound(const Element& other) {
      bool modified = false;

      // Merge the shorter height stack with the suffix of the longer height
      // stack. We do this by taking the LUB of each pair of matching frames
      // from both stacks.
      auto otherIterator = other.stackValue.crbegin();
      for (auto thisIterator = stackValue.rbegin();
           thisIterator != stackValue.rend();
           ++thisIterator) {
        // Do nothing if the other stack is shorter and we run out of frames.
        if (otherIterator != other.stackValue.crend()) {
          modified |= (*thisIterator).makeLeastUpperBound(*otherIterator);
          ++otherIterator;
        }
      }

      // If the other stack is higher, append the prefix of it to our current
      // stack.
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

  // Like in computing the LUB, we compare the suffixes of the two stacks.
  // If the left stack is higher, and left suffix >= right suffix, then we say
  // that left stack > right stack. If the left stack is lower an left suffix >=
  // right suffix or if the left stack is higher and the right suffix > left
  // suffix or they are unrelated, then there is no relation. Same applies for
  // the reverse relationship.
  LatticeComparison compare(const Element& left, const Element& right) {
    auto leftIterator = left.stackValue.crbegin();
    auto rightIterator = right.stackValue.crbegin();

    bool hasEqual = false;
    bool hasLess = false;
    bool hasGreater = false;
    bool hasUnrelated = false;

    // Check the suffixes of both stacks. If there is an unrelated pair of
    // frames, or if there is both a > and a <, then the stacks must be
    // unrelated.
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

    // Check cases for when the stacks have unequal or equal heights.
    // As a rule, if a stack is higher, it is greater than the other stack, but
    // if and only if their suffixes have the same greater than or equal
    // relationship.
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