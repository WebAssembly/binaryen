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

#include <optional>
#include <vector>

#include "../lattice.h"
#include "bool.h"

namespace wasm::analysis {

// Note that in comments, bottom is left and top is right.

// This lattice models the behavior of a stack of values. The lattice is
// templated on L, which is a lattice which can model some abstract property of
// a value on the stack. The Stack itself can push or pop abstract values
// and access the top of stack.
//
// The goal here is not to operate directly on the stacks. Rather, the
// Stack organizes the L elements in an efficient and natural way which
// reflects the behavior of the Wasm value stack. Transfer functions will
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
// the Stack.
//
// When two control flows are joined together, one with stack [b, a] and another
// with stack [b, a'], we can take the least upper bound to produce a stack [b,
// LUB(a, a')], where LUB(a, a') takes the maximum of the two maximum bit
// values.
template<Lattice L> struct Stack {
  // The materialized stack of values. The infinite items underneath these
  // materialized values are bottom. The element at the base of the materialized
  // stack must not be bottom.
  using Element = std::vector<typename L::Element>;

  L lattice;

  Stack(L&& lattice) : lattice(std::move(lattice)) {}

  void push(Element& elem, typename L::Element&& element) const noexcept {
    if (elem.empty() && element == lattice.getBottom()) {
      // no-op, the stack is already entirely made of bottoms.
      return;
    }
    elem.emplace_back(std::move(element));
  }

  typename L::Element pop(Element& elem) const noexcept {
    if (elem.empty()) {
      // "Pop" and return one of the infinite bottom elements.
      return lattice.getBottom();
    }
    auto popped = elem.back();
    elem.pop_back();
    return popped;
  }

  Element getBottom() const noexcept { return Element{}; }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    auto result = EQUAL;
    // Iterate starting from the end of the vectors to match up the tops of
    // stacks with different sizes.
    for (auto itA = a.rbegin(), itB = b.rbegin();
         itA != a.rend() || itB != b.rend();
         ++itA, ++itB) {
      if (itA == a.rend()) {
        // The rest of A's elements are bottom, but B has a non-bottom element
        // because of our invariant that the base of the materialized stack must
        // not be bottom.
        return LESS;
      }
      if (itB == b.rend()) {
        // The rest of B's elements are bottom, but A has a non-bottom element.
        return GREATER;
      }
      switch (lattice.compare(*itA, *itB)) {
        case NO_RELATION:
          return NO_RELATION;
        case EQUAL:
          continue;
        case LESS:
          if (result == GREATER) {
            // Cannot be both less and greater.
            return NO_RELATION;
          }
          result = LESS;
          continue;
        case GREATER:
          if (result == LESS) {
            // Cannot be both greater and less.
            return NO_RELATION;
          }
          result = GREATER;
          continue;
      }
    }
    return result;
  }

  bool join(Element& joinee, const Element& joiner) const noexcept {
    // If joiner is deeper than joinee, prepend those extra elements to joinee
    // first. They don't need to be explicitly joined with anything because they
    // would be joined with bottom, which wouldn't change them.
    bool result = false;
    size_t extraSize = 0;
    if (joiner.size() > joinee.size()) {
      extraSize = joiner.size() - joinee.size();
      auto extraBegin = joiner.begin();
      auto extraEnd = joiner.begin() + extraSize;
      joinee.insert(joinee.begin(), extraBegin, extraEnd);
      result = true;
    }
    // Join all the elements present in both materialized stacks, starting from
    // the end so the stack tops match up. Stop the iteration when we've
    // processed all of joinee, excluding any extra elements from joiner we just
    // prepended to it, or when we've processed all of joiner.
    auto joineeIt = joinee.rbegin();
    auto joinerIt = joiner.rbegin();
    auto joineeEnd = joinee.rend() - extraSize;
    for (; joineeIt != joineeEnd && joinerIt != joiner.rend();
         ++joineeIt, ++joinerIt) {
      result |= lattice.join(*joineeIt, *joinerIt);
    }
    return result;
  }
};

// Deduction guide.
template<typename L> Stack(L&&) -> Stack<L>;

#if __cplusplus >= 202002L
static_assert(Lattice<Stack<Bool>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_stack_h
