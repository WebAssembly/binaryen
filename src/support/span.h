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

#include <algorithm>
#include <cassert>
#include <iostream>
#include <limits>

#include "support/inplace_vector.h"

namespace wasm {

// A span of values.
//
// Span{min, max} means [min, max], inclusive of both sides. To represent an
// empty span, we use min > max.
template<typename T> struct Span {
  static constexpr T Min = std::numeric_limits<T>::lowest();
  static constexpr T Max = std::numeric_limits<T>::max();

  T min = Min;
  T max = Max;

  constexpr Span() = default;
  constexpr Span(T min, T max) : min(min), max(max) {}

  // Set a single value as possible.
  void set(T value) { min = max = value; }

  // To represent an empty span, we use min > max, an impossible span.
  void setEmpty() {
    *this = empty();
    assert(isEmpty());
  }

  bool isEmpty() const { return min > max; }

  static Span<T> empty() { return Span{Max, Min}; }

  void setFull() {
    *this = Span();
    assert(isFull());
  }

  bool isFull() const { return min == Min && max == Max; }

  static Span<T> full() { return Span{}; }

  // Intersect this with another span, returning a (possibly empty) span.
  Span<T> intersection(const Span& other) const {
    if (isEmpty() || other.isEmpty()) {
      return empty();
    }
    return Span<T>{std::max(min, other.min), std::min(max, other.max)};
  }

  // Checks whether two spans have any overlap at all.
  bool hasOverlap(const Span& other) const {
    return !intersection(other).isEmpty();
  }

  // Check whether we contain another span (possibly being equal).
  bool contains(const Span& other) const {
    return intersection(other) == other;
  }

  bool operator==(const Span& other) const {
    if (isEmpty()) {
      return other.isEmpty();
    }
    return !other.isEmpty() && min == other.min && max == other.max;
  }
  bool operator!=(const Span& other) const { return !(*this == other); }
};

// A union of spans
template<typename T, size_t N> struct Spans {
  inplace_vector<Span<T>, N> spans;

  static constexpr T Min = std::numeric_limits<T>::lowest();
  static constexpr T Max = std::numeric_limits<T>::max();

  T min = Min;
  T max = Max;

  constexpr Spans() = default;
  Spans(std::initializer_list<Span<T>> init) {
    for (auto& span : init) {
      spans.push_back(span);
    }
  }

  Spans<T, N> intersection(const Spans<T, N>& other) const {
    // (s1 U s2) ^ (s3 U s4) == (s1 ^ (s3 U s4)) U (s2 ^ (s3 U s4)) etc.
    Spans<T, N> ret;
    for (auto& span : *this) {
      // Starting from span, intersect it with other's spans, and unify those.
      // This must end up a single span, as we assume other's spans are
      // disjoint. XXX
      auto curr = Span<T>::empty();
      for (auto& otherSpan : other) {
        curr
    if (isEmpty() || other.isEmpty()) {
      return empty();
    }
    return Span<T>{std::max(min, other.min), std::min(max, other.max)};
  }

  // Checks whether two spans have any overlap at all.
  bool hasOverlap(const Spans<T, N>& other) const {
    return !intersection(other).isEmpty();
  }

  // Check whether we contain another span (possibly being equal).
  bool contains(const Spans<T, N>& other) const {
    return intersection(other) == other;
  }

  bool operator==(const Spans<T, N>& other) const {
    if (isEmpty()) {
      return other.isEmpty();
    }
    return !other.isEmpty() && min == other.min && max == other.max;
  }
  bool operator!=(const Spans<T, N>& other) const { return !(*this == other); }

};

// A useful set of 2 spans that can contain any integer value. 2 spans is enough
// to contain spans for any inequality, signed or unsigned: we represent numbers
// as unsigned internally, and so e.g. signed x < 10 ends up as two disjoint
// spans, [0..10] and [2^32..MAX_INT].
using Spans2 = Spans<uint64_t, 2>;

template<typename T>
inline std::ostream& operator<<(std::ostream& os, const Span<T>& span) {
  if (span.isEmpty()) {
    return os << "[empty]";
  }
  return os << '[' << span.min << ", " << span.max << ']';
}

} // namespace wasm

#endif // wasm_support_span_h
