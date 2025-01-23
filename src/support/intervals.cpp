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

#include <assert.h>

#include "intervals.h"
#include "support/index.h"
#include <algorithm>

using namespace wasm;

std::vector<int>
IntervalProcessor::filterOverlaps(std::vector<Interval>& intervals) {
  if (intervals.size() == 0) {
    return std::vector<int>();
  }

  std::vector<std::tuple<Interval, int>> intIntervals;
  for (Index i = 0; i < intervals.size(); i++) {
    auto& interval = intervals[i];
    intIntervals.push_back(std::make_tuple(interval, i));
  }

  std::sort(
    intIntervals.begin(), intIntervals.end(), [](const auto& a, const auto& b) {
      return std::get<0>(a).start < std::get<0>(b).end;
    });

  std::vector<int> result;
  auto& firstInterval = intIntervals[0];
  // Look for overlapping intervals
  for (Index i = 1; i < intervals.size(); i++) {
    auto& nextInterval = intIntervals[i];
    if (std::get<0>(firstInterval).end < std::get<0>(nextInterval).start) {
      result.push_back(std::get<1>(firstInterval));
      firstInterval = nextInterval;
      continue;
    }

    // Keep the interval with the higher weight
    if (std::get<0>(nextInterval).weight > std::get<0>(firstInterval).weight) {
      result.push_back(std::get<1>(nextInterval));
      firstInterval = nextInterval;
    } else {
      result.push_back(std::get<1>(firstInterval));
    }
  }

  return result;
}
