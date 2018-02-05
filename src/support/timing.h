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

//
// Timing helper
//

#ifndef wasm_support_timing_h
#define wasm_support_timing_h

#include <chrono>

namespace wasm {

class Timer {
  std::string name;
  std::chrono::steady_clock::time_point startTime;
  double total = 0;

public:
  Timer(std::string name = "") : name(name) {}

  void start() {
    startTime = std::chrono::steady_clock::now();
  }

  void stop() {
    total += std::chrono::duration<double>(std::chrono::steady_clock::now() - startTime).count();
  }

  double getTotal() {
    return total;
  }

  void dump() {
    std::cerr << "<Timer " << name << ": " << getTotal() << ">\n";
  }
};

} // namespace wasm

#endif  // wasm_support_timing_h
