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

#ifndef wasm_tools_wasm_reduce_destructive_reducer_h
#define wasm_tools_wasm_reduce_destructive_reducer_h

#include "reducer.h"

namespace wasm {

struct DestructiveReducer
  : public WalkerPass<
      PostWalker<DestructiveReducer,
                 UnifiedExpressionVisitor<DestructiveReducer>>> {
  Reducer& reducer;
  int& factor;
  size_t reduced = 0;
  Expression* beforeReduction = nullptr;
  Index funcsSeen = 0;

  DestructiveReducer(Reducer& reducer)
    : reducer(reducer), factor(reducer.factor) {}

  void noteReduction(size_t amount = 1);

  std::string getLocation();

  void visitExpression(Expression* curr);

  void visitFunction(Function* curr);

  void visitDataSegment(DataSegment* curr);

  void shrinkElementSegments();

  void visitModule([[maybe_unused]] Module* curr);

  // Reduces entire functions at a time. Returns whether we did a significant
  // amount of reduction that justifies doing even more.
  bool reduceFunctions();

  bool isOkReplacement(Expression* with);

  bool tryToReplaceCurrent(Expression* with);

  bool tryToReplaceChild(Expression*& child, Expression* with);

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
      if (!reducer.shouldTryToReduce(bonus) || isZero(item)) {
        continue;
      }
      auto save = item;
      item = zero;
      if (reducer.writeAndTestReduction()) {
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
      if (justShrank || reducer.shouldTryToReduce(bonus)) {
        auto save = data;
        for (size_t j = 0; j < skip; j++) {
          if (data.empty()) {
            break;
          } else {
            data.pop_back();
          }
        }
        justShrank = reducer.writeAndTestReduction();
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

#endif // wasm_tools_wasm_reduce_destructive_reducer_h