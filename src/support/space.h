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

struct DisjointSpans {
  // A span of form [a, b), i.e., that does not include the end point.
  struct Span {
    Address left, right;

    bool checkOverlap(const Span& other) const {
      return !(left >= other.right || right <= other.left);
    }
  };

  struct SortByLeft {
    bool operator()(const Span& left, const Span& right) const {
      return left.left < right.left ||
             (left.left == right.left && left.right < right.right);
    }
  };

  // The spans seen so far. Guaranteed to be disjoint.
  std::set<Span, SortByLeft> spans;

  // Adds an item and checks overlap while doing so, returning true if such
  // overlap exists.
  bool addAndCheckOverlap(Span span) {
    // Insert the new span. We can then find its predecessor and successor.
    // They are disjoint by assumption, so the question is then does the new
    // span overlap with them, or not.
    auto [iter, inserted] = spans.insert(span);
    if (!inserted) {
      // This exact span was already there, so there is definite overlap.
      return true;
    }
    // Check predecessor and successor, if they exist.
    if (iter != spans.begin() && std::prev(iter)->checkOverlap(span)) {
      return true;
    }
    if (std::next(iter) != spans.end() && std::next(iter)->checkOverlap(span)) {
      return true;
    }
    return false;
  }

  // Inefficient - mostly for testing.
  void add(Span span) { addAndCheckOverlap(span); }

  // Inefficient - mostly for testing.
  bool checkOverlap(Span span) {
    bool existsBefore = spans.find(span) != spans.end();
    auto hasOverlap = addAndCheckOverlap(span);
    if (!existsBefore) {
      spans.erase(span);
    }
    return hasOverlap;
  }
};

} // namespace wasm

#endif // wasm_support_space_h
