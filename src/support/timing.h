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

#ifndef wasm_support_timing_h
#define wasm_support_timing_h

#include <chrono>
#include <utility>

namespace wasm {

// A utility for measuring time between readings as well as total elapsed time.
// The timer starts upon construction, but can be restarted.
class Timer {
  std::chrono::steady_clock::time_point startTime;
  std::chrono::steady_clock::time_point lastTime;

public:
  Timer() { restart(); }

  // Resets the timer's start and last times.
  void restart() {
    auto now = std::chrono::steady_clock::now();
    lastTime = startTime = now;
  }

  // The time since the timer was started.
  double totalElapsed() {
    auto now = std::chrono::steady_clock::now();
    auto sinceStart = std::chrono::duration<double>(now - startTime).count();
    return sinceStart;
  }

  // The time since the last `lastElapsed` measurement, if any, or since the
  // timer started.
  double lastElapsed() {
    auto now = std::chrono::steady_clock::now();
    auto sinceLast = std::chrono::duration<double>(now - lastTime).count();
    lastTime = now;
    return sinceLast;
  }

  // The time elapsed since the last measurement and the total elapsed time.
  std::pair<double, double> elapsed() {
    auto now = std::chrono::steady_clock::now();
    auto sinceLast = std::chrono::duration<double>(now - lastTime).count();
    auto sinceStart = std::chrono::duration<double>(now - startTime).count();
    lastTime = now;
    return {sinceLast, sinceStart};
  }
};

} // namespace wasm

#endif // wasm_support_timing_h
