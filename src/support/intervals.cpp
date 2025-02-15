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
#include <iostream>

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

  std::sort(
    intIntervals.begin(), intIntervals.end(), [](const auto& a, const auto& b) {
      return a.first.start < b.first.start;
    });

  std::vector<int> result;
  Index formerInterval = 0;
  // Look for overlapping intervals
  for (Index latterInterval = 1; latterInterval <= intIntervals.size();
       latterInterval++) {
    if (latterInterval == intIntervals.size() ||
        intIntervals[formerInterval].first.end <=
          intIntervals[latterInterval].first.start) {
      result.push_back(intIntervals[formerInterval].second);
      formerInterval = latterInterval;
      continue;
    }

    // Keep the interval with the higher weight
    if (intIntervals[latterInterval].first.weight >
        intIntervals[formerInterval].first.weight) {
      formerInterval = latterInterval;
    }
  }

  return result;
}
