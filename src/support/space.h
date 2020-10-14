/*
 * Copyright 2020 WebAssembly Community Group participants
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

#ifndef wasm_support_space_h
#define wasm_support_space_h

#include "utilities.h"
#include <wasm.h>

namespace wasm {

// A one-dimensional Binary Space Partitioning Tree, that is, given a line,
// we construct a nested tree structure on it, where we can place objects. An
// object here is a span, a contiguous area [x, y) on the line. The structure
// has the following property:
//
//  * The root is responsible for the entire line.
//  * The root has a left child responsible for that half of the line, and
//    likewise on the right.
//  * That structure recurses.
//  * When adding a span into the BSP, we look for the smallest node that can
//    contain it. That is, if a span overlaps with both the left and right
//    children of a node, it cannot be in one of them, and remains in the
//    parent; otherwise, it goes in the corresponding child.
//
// The benefit of this structure is that typically memory segments so not have
// large amounts of overlap between each other. In that case, checking for
// possible overlaps is logarithmic.
struct BSPNode {
  // The minimum width of a span (so that we don't end up emitting a span per
  // single location or even close to that.
  const Address MinWidth = 100;

  struct Span {
    // Left is included, right is not.
    Address left, right;

    bool hasOverlap(const Span& other) {
      return !(left >= other.right || right <= other.left);
    }
  };

  // The area we are responsible for.
  Span area;

  // All the spans that belong to this node.
  std::vector<Span> mySpans;

  std::unique_ptr<BSPNode> leftChild, rightChild;

  BSPNode(Span area) : area(area) {}

  bool hasOverlap(Span span) {
    std::vector<BSPNode*> stack;
    stack.push_back(this);
    while (!stack.empty()) {
      auto* curr = stack.back();
      stack.pop_back();
      // First compare with existing spans on this node itself, that is, that
      // overlap both the left and right side.
      for (auto& existing : curr->mySpans) {
        if (existing.hasOverlap(span)) {
          return true;
        }
      }
      // Scan the relevant children.
      if (curr->hasLeft() && curr->overlapsWithLeft(span)) {
        stack.push_back(getLeft());
      }
      if (curr->hasRight() && curr->overlapsWithRight(span)) {
        stack.push_back(getRight());
      }
    }
    return false;
  }

  void add(Span span) {
    BSPNode* curr = this;
    while (1) {
      // If this is big enough, then recurse into a smaller child, possibly
      // creating it.
      if (curr->getWidth() > MinWidth) {
        if (curr->entirelyInLeft(span)) {
          curr = getLeft();
          continue;
        }
        if (curr->entirelyInRight(span)) {
          curr = getRight();
          continue;
        }
      }
      // It overlaps with both, or this is already so small we don't want to
      // create any more children, so add it here.
      curr->mySpans.push_back(span);
      return;
    }
  }

private:
  // The middle of the area is the cutoff point. That location is part of the
  // right child, that is,
  //  * left child is responsible for [left, middle)
  //  * right child is responsible for [middle, right)
  Address getMiddle() { return (area.left + area.right) / 2; }

  Address getWidth() {
    return area.right - area.left;
  }

  BSPNode* getLeft() {
    if (!leftChild) {
      leftChild = make_unique<BSPNode>(Span{area.left, getMiddle()});
    }
    return leftChild.get();
  }

  BSPNode* getRight() {
    if (!rightChild) {
      rightChild = make_unique<BSPNode>(Span{getMiddle(), area.right});
    }
    return rightChild.get();
  }

  bool hasLeft() {
    return leftChild.get();
  }

  bool hasRight() {
    return rightChild.get();
  }

  // Returns whether a position is in the left half. It may even be more to the
  // left than the actual left limit; we just check if it's left of the middle.
  bool inLeft(Address x) { return x < getMiddle(); }
  bool inRight(Address x) { return x >= getMiddle(); }

  // Check if a span is entirely on one side.
  bool entirelyInLeft(Span span) { return inLeft(span.right); }
  bool entirelyInRight(Span span) { return inRight(span.left); }

  // Check if a span has some overlap with a side (it may have both).
  bool overlapsWithLeft(Span span) { return inLeft(span.left); }
  bool overlapsWithRight(Span span) { return inRight(span.right); }
};

} // namespace wasm

#endif // wasm_support_space_h

