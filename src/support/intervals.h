/*
 * Copyright 2024 WebAssembly Community Group participants
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

// Helpers for handling a generic range of values

#ifndef wasm_support_intervals_h
#define wasm_support_intervals_h

#include <set>
#include <vector>

namespace wasm {

struct Interval {
  unsigned start;
  unsigned end;
  // The weight is used to determine which interval to keep when two overlap,
  // higher is better
  unsigned weight;
  Interval(unsigned start, unsigned end, unsigned weight)
    : start(start), end(end), weight(weight) {}

  bool operator<(const Interval& other) const {
    return start != other.start     ? start < other.start
           : weight != other.weight ? weight < other.weight
                                    : end < other.end;
  }

  bool operator==(const Interval& other) const {
    return start == other.start && end == other.end && weight == other.weight;
  }
};

struct IntervalProcessor {
  // Given a vector of Interval, returns a vector of the indices that, mapping
  // back to the original input vector, do not overlap with each other, i.e. the
  // interval indexes with overlapping interval indexes already removed.
  static std::vector<int> filterOverlaps(std::vector<Interval>&);
};

} // namespace wasm

#endif // wasm_suport_intervals
