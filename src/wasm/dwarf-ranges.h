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

#ifndef wasm_dwarf_ranges_h
#define wasm_dwarf_ranges_h

#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <initializer_list>
#include <utility>
#include <vector>

namespace wasm::Debug {

using DwarfRange = std::pair<uint64_t, uint64_t>;

// A set of nonempty, half-open DWARF address ranges. Call normalize before
// querying containment or overlap; adding one set to another normalizes the
// result automatically.
class DwarfRanges {
  std::vector<DwarfRange> ranges;

  void normalizeInPlace() {
    std::sort(ranges.begin(), ranges.end());
    size_t written = 0;
    for (auto range : ranges) {
      if (written && range.first <= ranges[written - 1].second) {
        ranges[written - 1].second =
          std::max(ranges[written - 1].second, range.second);
      } else {
        ranges[written++] = range;
      }
    }
    ranges.resize(written);
  }

public:
  DwarfRanges() = default;
  DwarfRanges(std::initializer_list<DwarfRange> ranges) : ranges(ranges) {}

  bool empty() const { return ranges.empty(); }

  const std::vector<DwarfRange>& get() const { return ranges; }

  void add(uint64_t start, uint64_t end) {
    assert(start < end);
    ranges.emplace_back(start, end);
  }

  // Returns whether normalization changed the range representation.
  bool normalize() {
    auto original = ranges;
    normalizeInPlace();
    return ranges != original;
  }

  // Adds another set and returns whether the resulting union changed this set.
  bool add(const DwarfRanges& other) {
    if (other.empty()) {
      return false;
    }
    auto original = ranges;
    ranges.insert(ranges.end(), other.ranges.begin(), other.ranges.end());
    normalizeInPlace();
    return ranges != original;
  }

  bool contains(const DwarfRanges& other) const {
    size_t index = 0;
    for (auto otherRange : other.ranges) {
      while (index < ranges.size() &&
             ranges[index].second <= otherRange.first) {
        ++index;
      }
      if (index == ranges.size() || ranges[index].first > otherRange.first ||
          ranges[index].second < otherRange.second) {
        return false;
      }
    }
    return true;
  }

  bool overlaps(const DwarfRanges& other) const {
    size_t left = 0, right = 0;
    while (left < ranges.size() && right < other.ranges.size()) {
      auto leftRange = ranges[left];
      auto rightRange = other.ranges[right];
      if (leftRange.first < rightRange.second &&
          rightRange.first < leftRange.second) {
        return true;
      }
      if (leftRange.second <= rightRange.first) {
        ++left;
      } else {
        ++right;
      }
    }
    return false;
  }
};

} // namespace wasm::Debug

#endif // wasm_dwarf_ranges_h
