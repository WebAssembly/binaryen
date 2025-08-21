/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef wasm_tools_wasm_reduce_reducer_h
#define wasm_tools_wasm_reduce_reducer_h

#include <string>

#include "tools/tool-options.h"

namespace wasm {

struct ProgramResult {
  int code;
  std::string output;
  double time;

  ProgramResult() = default;
  ProgramResult(std::string command) { getFromExecution(command); }

  void getFromExecution(std::string command);

  bool operator==(ProgramResult& other) {
    return code == other.code && output == other.output;
  }
  bool operator!=(ProgramResult& other) { return !(*this == other); }

  bool failed() { return code != 0; }

  void dump(std::ostream& o) {
    o << "[ProgramResult] code: " << code << " stdout: \n"
      << output << "[====]\nin " << time << " seconds\n[/ProgramResult]\n";
  }
};

} // namespace wasm

namespace std {

inline std::ostream& operator<<(std::ostream& o, wasm::ProgramResult& result) {
  result.dump(o);
  return o;
}

} // namespace std

namespace wasm {

// A timeout on every execution of the command.
extern size_t timeout;

// Whether to save all intermediate working files as we go.
extern bool saveAllWorkingFiles;

// A string of feature flags and other things to pass while reducing. The
// default of enabling all features should work in most cases.
extern std::string extraFlags;

extern ProgramResult expected;

// Removing functions is extremely beneficial and efficient. We aggressively
// try to remove functions, unless we've seen they can't be removed, in which
// case we may try again but much later.
extern std::unordered_set<Name> functionsWeTriedToRemove;

// The index of the working file we save, when saveAllWorkingFiles. We must
// store this globally so that the difference instances of Reducer do not
// overlap.

extern size_t workingFileIndex;

struct Reducer {
  Module wasm;
  std::string command, test, working;
  bool binary, deNan, verbose, debugInfo;
  ToolOptions& toolOptions;

  size_t decisionCounter = 0;
  int factor;

  // test is the file we write to that the command will operate on
  // working is the current temporary state, the reduction so far
  Reducer(std::string command,
          std::string test,
          std::string working,
          bool binary,
          bool deNan,
          bool verbose,
          bool debugInfo,
          ToolOptions& toolOptions)
    : command(command), test(test), working(working), binary(binary),
      deNan(deNan), verbose(verbose), debugInfo(debugInfo),
      toolOptions(toolOptions) {}

  void reduceUsingPasses();
  void applyTestToWorking();

  // does one pass of slow and destructive reduction. returns whether it
  // succeeded or not
  // the criterion here is a logical change in the program. this may actually
  // increase wasm size in some cases, but it should allow more reduction later.
  // @param factor how much to ignore. starting with a high factor skips through
  //               most of the file, which is often faster than going one by one
  //               from the start
  size_t reduceDestructively(int factor_);

  bool writeAndTestReduction();
  bool writeAndTestReduction(ProgramResult& out);

  void loadWorking();

  // Returns a random number in the range [0, max). This is deterministic given
  // all the previous work done in the reducer.
  size_t deterministicRandom(size_t max);

  bool shouldTryToReduce(size_t bonus = 1);
};

} // namespace wasm

#endif // wasm_tools_wasm_reduce_reducer_h