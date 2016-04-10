/*
 * Copyright 2016 WebAssembly Community Group participants
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

#ifndef wasm_support_metrics_h
#define wasm_support_metrics_h

#include <cstdint>
#include <vector>
#include <map>
#include <istream>
#include <ostream>
#include <cassert>
#include <iostream>
#include <iomanip>


namespace wasm {

// Quick and dirty way to collect statistics about data written to a byte stream.
//
// Metrics m;
// m.enter("something to measure", offset);
//   m.enter("something else to measure", offset);
//     ...
//   m.leave(offset);
//   ..
// m.leave(offset);
struct ByteStreamMetrics {
  struct MetricStackEntry {
    const char *name;
    const uint32_t offset;
    MetricStackEntry(const char *name, uint32_t offset = 0) : name(name), offset(offset) {}
  };
  struct Metric {
    uint32_t value;
    uint32_t samples;
    Metric() : value(0), samples(0) {}
  };
  std::vector<MetricStackEntry> stack;
  std::map<const char *, Metric> metrics;
  void enter(const char *name, size_t offset) {
    stack.push_back(MetricStackEntry(name, offset));
  }
  void leave(size_t offset, const char *name = nullptr) {
    MetricStackEntry m = stack.back();
    // If the name is specifed, assert that it matches the top of the stack.
    if (name) assert(name == m.name);
    metrics[m.name].samples ++;
    metrics[m.name].value += offset - m.offset;
    stack.pop_back();
  }
  std::ostream& printByteSize(std::ostream& o, size_t size) {
    const char * sizes[] = {"M", "K", "B"};
    const size_t K = 1024;
    size_t multiplier = K * K;
    for (int i = 0; i < 3; i++, multiplier /= K) {
      if (size < multiplier) {
        continue;
      }
      if (size % multiplier == 0) {
        o << (size / multiplier);
      } else {
        o << ((float)size / multiplier);
      }
      o << sizes[i];
      return o;
    }
    return o;
  }
  void print(std::ostream& o, size_t totalSize) {
    assert(stack.size() == 0);
    std::vector<const char*> keys;
    for (auto i : metrics) {
      keys.push_back(i.first);
    }
    sort(keys.begin(), keys.end(), [this](const char* a, const char* b) -> bool {
        return strcmp(b, a) > 0;
    });
    // Pretty Markdown Tables
    o << "| Name                             |      Count |       Size |    % Total |    Avg. Size |\n";
    o << "|:---------------------------------|-----------:|-----------:|-----------:|-------------:|\n";
    for (auto* key : keys) {
      Metric m = this->metrics[key];
      float percent = ((float)m.value / totalSize) * 100;
      float average = ((float)m.value / m.samples);
      o << "| " << std::setw(32) << std::left << key << std::right;
      o << " | " << std::fixed << std::setw(10) << std::setprecision(3) << m.samples;
      o << " | " << std::fixed << std::setw(9) << std::setprecision(3);
      printByteSize(o, m.value);
      o << " | " << std::fixed << std::setw(10) << std::setprecision(3) << percent
        << " | " << std::fixed << std::setw(12) << std::setprecision(4) << average
        << " |\n";
    }
  }
};

}  // namespace wasm

#endif   // wasm_support_metrics_h
