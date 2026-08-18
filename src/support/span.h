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

#ifndef wasm_support_span_h
#define wasm_support_span_h

#include "src/support/i65.h"

namespace wasm {

// A span of  values.
//
// Span{min, max} means [min, max], inclusive of both sides. To represent an
// empty span, we use min > max.
template<typename T>
struct Span {
  T min, max;

  // Set a single value as possible.
  void set(T value) {
    min = max = value;
  }

  // To represent an empty span, we use min > max, an impossible span.
  void setEmpty() {
    min = 1;
    max = 0;
  }

  bool isEmpty() const { return min > max; }

  static Span<T> empty() {
    Span<T> ret;
    ret.setEmpty();
    return ret;
  }

  void setFull() {
    *this = Span();
    assert(isFull());
  }

  bool isFull() const { return min == Min && max == Max; }

  static Span<T> full() {
    Span<T> ret;
    ret.setFull();
    return ret;
  }

  // Intersect this with another span, returning a (possibly empty) span.
  Span<T> intersection(const Span& other) const {
    if (isEmpty() || other.isEmpty()) {
      return empty();
    }
    return Span<T>{std::max(min, other.min), std::min(max, other.max)};
  }

  // Checks whether two spans have any overlap at all.
  bool hasOverlap(const Span& other) {
    return !intersection(other).isEmpty();
  }

  // Check whether we contain another span (possibly being equal).
  bool contains(const Span& other) const {
    return intersection(other) == other;
  }
};

} // namespace wasm

#endif // wasm_support_span_h
