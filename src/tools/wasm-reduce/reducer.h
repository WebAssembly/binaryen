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
#include "wasm-builder.h"

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

struct Reducer
  : public WalkerPass<PostWalker<Reducer, UnifiedExpressionVisitor<Reducer>>> {
  std::string command, test, working;
  bool binary, deNan, verbose, debugInfo;
  ToolOptions& toolOptions;

  // Destructive reduction state
  size_t reduced;
  Expression* beforeReduction;
  std::unique_ptr<Module> module;
  std::unique_ptr<Builder> builder;
  Index funcsSeen;
  int factor;

  size_t decisionCounter = 0;

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

  bool shouldTryToReduce(size_t bonus = 1);

  // Returns a random number in the range [0, max). This is deterministic given
  // all the previous work done in the reducer.
  size_t deterministicRandom(size_t max);

  bool isOkReplacement(Expression* with);

  bool tryToReplaceCurrent(Expression* with);

  void noteReduction(size_t amount = 1);

  bool tryToReplaceChild(Expression*& child, Expression* with);

  std::string getLocation();

  void visitExpression(Expression* curr);

  void visitFunction(Function* curr);

  void visitDataSegment(DataSegment* curr);

  void shrinkElementSegments();

  void visitModule([[maybe_unused]] Module* curr);

  // Reduces entire functions at a time. Returns whether we did a significant
  // amount of reduction that justifies doing even more.
  bool reduceFunctions();

  // Try to empty out the bodies of some functions.
  bool tryToEmptyFunctions(std::vector<Name> names);

  // Try to actually remove functions. If they are somehow referred to, we will
  // get a validation error and undo it.
  bool tryToRemoveFunctions(std::vector<Name> names);

  // helpers

  // try to replace condition with always true and always false
  void handleCondition(Expression*& condition);

  bool tryToReduceCurrentToNop();

  bool tryToReduceCurrentToConst();

  bool tryToReduceCurrentToUnreachable();

  template<typename T, typename U, typename C>
  void
  reduceByZeroing(T* segment, U zero, C isZero, size_t bonus, bool shrank) {
    for (auto& item : segment->data) {
      if (!shouldTryToReduce(bonus) || isZero(item)) {
        continue;
      }
      auto save = item;
      item = zero;
      if (writeAndTestReduction()) {
        std::cerr << "|      zeroed elem segment\n";
        noteReduction();
      } else {
        item = save;
      }
      if (shrank) {
        // zeroing is fairly inefficient. if we are managing to shrink
        // (which we do exponentially), just zero one per segment at most
        break;
      }
    }
  }

  template<typename T> bool shrinkByReduction(T* segment, size_t bonus) {
    // try to reduce to first function. first, shrink segment elements.
    // while we are shrinking successfully, keep going exponentially.
    bool justShrank = false;

    auto& data = segment->data;
    // when we succeed, try to shrink by more and more, similar to bisection
    size_t skip = 1;
    for (size_t i = 0; i < data.size() && !data.empty(); i++) {
      if (justShrank || shouldTryToReduce(bonus)) {
        auto save = data;
        for (size_t j = 0; j < skip; j++) {
          if (data.empty()) {
            break;
          } else {
            data.pop_back();
          }
        }
        justShrank = writeAndTestReduction();
        if (justShrank) {
          std::cerr << "|      shrank segment from " << save.size() << " => "
                    << data.size() << " (skip: " << skip << ")\n";
          noteReduction();
          skip = std::min(size_t(factor), 2 * skip);
        } else {
          data = std::move(save);
          return false;
        }
      }
    }

    return true;
  }
};

} // namespace wasm

#endif // wasm_tools_wasm_reduce_reducer_h