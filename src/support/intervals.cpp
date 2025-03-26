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

  std::vector<std::pair<Interval, int>> intIntervals;
  for (Index i = 0; i < intervals.size(); i++) {
    auto& interval = intervals[i];
    intIntervals.push_back({interval, i});
  }

  std::sort(intIntervals.begin(), intIntervals.end());

  std::vector<std::pair<Interval, int>> kept;
  kept.push_back(intIntervals[0]);
  for (auto& candidate : intIntervals) {
    auto& former = kept.back();
    if (former.first.end <= candidate.first.start) {
      kept.push_back(candidate);
      continue;
    }

    // When two intervals overlap with the same weight, prefer to keep the
    // interval that ends sooner under the presumption that it will overlap with
    // fewer subsequent intervals.
    if (former.first.weight == candidate.first.weight &&
        former.first.end > candidate.first.end) {
      former = candidate;
    } else if (former.first.weight < candidate.first.weight) {
      former = candidate;
    }
  }

  std::vector<int> result;
  for (auto& intPair : kept) {
    result.push_back(intPair.second);
  }

  return result;
}
