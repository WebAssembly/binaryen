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

#ifndef wasm_tools_fuzzing_fuzz_stats_h
#define wasm_tools_fuzzing_fuzz_stats_h

#include "wasm-traversal.h"

#include <map>
#include <string>

namespace wasm {

class Module;

namespace FuzzStats {

// Record the outcome of a random decision or event during fuzzing.
// If statistics collection is not enabled (via BINARYEN_FUZZ_STATS), this does
// nothing. Returns `outcome` so it can be used inline in expressions.
int recordEvent(const std::string& name, int outcome);

int recordEvent(const std::string& name,
                const char* file,
                int line,
                int outcome);

// Check whether statistics collection is enabled.
bool isEnabled();

// Save collected statistics to the stats file.
void save(uint64_t numFunctions,
          const std::map<std::string, uint64_t>& occurrences,
          const std::map<std::string, uint64_t>& funcMatches);

// CRTP base class for visitors that collect fuzzing pattern statistics.
template<typename SubType>
struct PatternCollectorBase : public PostWalker<SubType> {
  // Counts within the current function: pattern name -> count
  std::map<std::string, uint64_t> currentFuncCounts;

  // Pattern stats for this module: pattern name -> total occurrences
  std::map<std::string, uint64_t> occurrences;
  // pattern name -> number of functions with >= 1 occurrence
  std::map<std::string, uint64_t> funcMatches;
  uint64_t numFunctions = 0;

  void record(const std::string& name) { currentFuncCounts[name]++; }

  void visitFunction(Function* func) {
    if (func->imported() || !func->body) {
      return;
    }
    numFunctions++;
    for (const auto& [name, count] : currentFuncCounts) {
      if (count > 0) {
        occurrences[name] += count;
        funcMatches[name]++;
      }
    }
    currentFuncCounts.clear();
  }

  // Walk the module and save collected statistics if enabled.
  void collect(Module& wasm) {
    if (!isEnabled()) {
      return;
    }
    for (const auto& func : wasm.functions) {
      if (!func->imported() && func->body) {
        this->walkFunction(func.get());
      }
    }
    save(numFunctions, occurrences, funcMatches);
  }
};

} // namespace FuzzStats

using FuzzStats::recordEvent;

#define RECORD_EVENT(name, outcome)                                            \
  ::wasm::FuzzStats::recordEvent((name), __FILE__, __LINE__, (outcome))

#define RECORD_FUZZ_EVENT(name, outcome) RECORD_EVENT(name, outcome)

} // namespace wasm

#endif // wasm_tools_fuzzing_fuzz_stats_h
