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
#ifndef wasm_analysis_lattices_stack_h
#define wasm_analysis_lattices_stack_h

#include <deque>
#include <optional>

#include "../lattice.h"

namespace wasm::analysis {

// Note that in comments, bottom is left and top is right.

// This lattice models the behavior of a stack of values. The lattice is
// templated on L, which is a lattice which can model some abstract property of
// a value on the stack. The StackLattice itself can push or pop abstract values
// and access the top of stack.
//
// The goal here is not to operate directly on the stacks. Rather, the
// StackLattice organizes the L elements in an efficient and natural way which
// reflects the behavior of the wasm value stack. Transfer functions will
// operate on stack elements individually. The stack itself is an intermediate
// structure.
//
// Comparisons are done elementwise, starting from the top of the stack. For
// instance, to compare the stacks [c,b,a], [b',a'], we first compare a with a',
// then b with b'. Then we make note of the fact that the first stack is higher,
// with an extra c element at the bottom.
//
// Similarly, least upper bounds are done elementwise starting from the top. For
// instance LUB([b, a], [b', a']) = [LUB(b, b'), LUB(a, a')], while LUB([c, b,
// a], [b', a']) = [c, LUB(b, b'), LUB(a, a')].
//
// These are done from the top of the stack because this addresses the problem
// of scopes. For instance, if we have the following program
//
// i32.const 0
// i32.const 0
// if (result i32)
//   i32.const 1
// else
//   i32.const 2
// end
// i32.add
//
// Before the if-else control flow, we have [] -> [i32], and after the if-else
// control flow we have [i32, i32] -> [i32]. However, inside each of the if and
// else conditions, we have [] -> [i32], because they cannot see the stack
// elements pushed by the enclosing scope. In effect in the if and else, we have
// a stack [i32 | i32], where we can't "see" left of the |.
//
// Conceptually, we can also imagine each stack [b, a] as being implicitly an
// infinite stack of the form (bottom) [... BOTTOM, BOTTOM, b, a] (top). This
// makes stacks in different scopes comparable, with only their contents
// different. Stacks in more "inner" scopes simply have more bottom elements in
// the bottom portion.
//
// A common application for this lattice is modeling the Wasm value stack. For
// instance, one could use this to analyze the maximum bit size of values on the
// Wasm value stack. When new actual values are pushed or popped off the Wasm
// value stack by instructions, the same is done to abstract lattice elements in
// the StackLattice.
//
// When two control flows are joined together, one with stack [b, a] and another
// with stack [b, a'], we can take the least upper bound to produce a stack [b,
// LUB(a, a')], where LUB(a, a') takes the maximum of the two maximum bit
// values.

template<Lattice L> class StackLattice {
  L& lattice;

public:
  StackLattice(L& lattice) : lattice(lattice) {}

  class Element {
    // The top lattice can be imagined as an infinitely high stack of top
    // elements, which is unreachable in most cases. In practice, we make the
    // stack an optional, and we represent top with the absence of a stack.
    std::optional<std::deque<typename L::Element>> stackValue =
      std::deque<typename L::Element>();

  public:
    bool isTop() const { return !stackValue.has_value(); }
    bool isBottom() const {
      return stackValue.has_value() && stackValue->empty();
    }
    void setToTop() { stackValue.reset(); }

    typename L::Element& stackTop() { return stackValue->back(); }

    void push(typename L::Element&& element) {
      // We can imagine each stack [b, a] as being implicitly an infinite stack
      // of the form (bottom) [... BOTTOM, BOTTOM, b, a] (top). In that case,
      // adding a bottom element to an empty stack changes nothing, so we don't
      // actually add a bottom.
      if (stackValue.has_value() &&
          (!stackValue->empty() || !element.isBottom())) {
        stackValue->push_back(std::move(element));
      }
    }

    void push(const typename L::Element& element) {
      if (stackValue.has_value() &&
          (!stackValue->empty() || !element.isBottom())) {
        stackValue->push_back(std::move(element));
      }
    }

    typename L::Element pop() {
      typename L::Element value = stackValue->back();
      stackValue->pop_back();
      return value;
    }

    // When taking the LUB, we take the LUBs of the elements of each stack
    // starting from the top of the stack. So, LUB([b, a], [b', a']) is
    // [LUB(b, b'), LUB(a, a')]. If one stack is higher than the other,
    // the bottom of the higher stack will be kept, while the LUB of the
    // corresponding tops of each stack will be taken. For instance,
    // LUB([d, c, b, a], [b', a']) is [d, c, LUB(b, b'), LUB(a, a')].
    //
    // We start at the top because it makes taking the LUB of stacks with
    // different scope easier, as mentioned at the top of the file. It also
    // fits with the conception of the stack starting at the top and having
    // an infinite bottom, which allows stacks of different height and scope
    // to be easily joined.
    bool makeLeastUpperBound(const Element& other) noexcept {
      // Top element cases, since top elements don't actually have the stack
      // value.
      if (isTop()) {
        return false;
      } else if (other.isTop()) {
        stackValue.reset();
        return true;
      }

      bool modified = false;

      // Merge the shorter height stack with the top of the longer height
      // stack. We do this by taking the LUB of each pair of matching elements
      // from both stacks.
      auto otherIt = other.stackValue->crbegin();
      auto thisIt = stackValue->rbegin();
      for (;
           thisIt != stackValue->rend() && otherIt != other.stackValue->crend();
           ++thisIt, ++otherIt) {
        modified |= thisIt->makeLeastUpperBound(*otherIt);
      }

      // If the other stack is higher, append the bottom of it to our current
      // stack.
      for (; otherIt != other.stackValue->crend(); ++otherIt) {
        stackValue->push_front(*otherIt);
        modified = true;
      }

      return modified;
    }

    void print(std::ostream& os) {
      if (isTop()) {
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

  // Like in computing the LUB, we compare the tops of the two stacks, as it
  // handles the case of stacks of different scopes. Comparisons are done by
  // element starting from the top.
  //
  // If the left stack is higher, and left top >= right top, then we say
  // that left stack > right stack. If the left stack is lower and the left top
  // >= right top or if the left stack is higher and the right top > left top or
  // they are unrelated, then there is no relation. Same applies for the reverse
  // relationship.
  LatticeComparison compare(const Element& left,
                            const Element& right) const noexcept {
    // Handle cases where there are top elements.
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

    // Check the tops of both stacks which match (i.e. are within the heights
    // of both stacks). If there is a pair which is not related, the stacks
    // cannot be related.
    for (auto leftIt = left.stackValue->crbegin(),
              rightIt = right.stackValue->crbegin();
         leftIt != left.stackValue->crend() &&
         rightIt != right.stackValue->crend();
         ++leftIt, ++rightIt) {
      LatticeComparison currComparison = lattice.compare(*leftIt, *rightIt);
      switch (currComparison) {
        case LatticeComparison::NO_RELATION:
          return LatticeComparison::NO_RELATION;
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

    // Check cases for when the stacks have unequal. As a rule, if a stack
    // is higher, it is greater than the other stack, but if and only if
    // when comparing their matching top portions the top portion of the
    // higher stack is also >= the top portion of the shorter stack.
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
      // Contradiction, and therefore must be unrelated.
      return LatticeComparison::NO_RELATION;
    } else {
      return LatticeComparison::EQUAL;
    }
  }

  Element getBottom() const noexcept { return Element{}; }
};

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_stack_h
