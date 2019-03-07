/*
 * Copyright 2019 WebAssembly Community Group participants
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

#ifndef wasm_ir_local_utils_h
#define wasm_ir_local_utils_h

#include <ir/effects.h>

namespace wasm {

struct GetLocalCounter : public PostWalker<GetLocalCounter> {
  std::vector<Index> num;

  GetLocalCounter() = default;
  GetLocalCounter(Function* func) {
    analyze(func, func->body);
  }
  GetLocalCounter(Function* func, Expression* ast) {
    analyze(func, ast);
  }

  void analyze(Function* func) {
    analyze(func, func->body);
  }
  void analyze(Function* func, Expression* ast) {
    num.resize(func->getNumLocals());
    std::fill(num.begin(), num.end(), 0);
    walk(ast);
  }

  void visitGetLocal(GetLocal *curr) {
    num[curr->index]++;
  }
};

// Removes trivially unneeded sets: sets for whom there is no possible get, and
// sets of the same value immediately.
struct UnneededSetRemover : public PostWalker<UnneededSetRemover> {
  PassOptions& passOptions;

  GetLocalCounter* getLocalCounter = nullptr;

  UnneededSetRemover(Function* func, PassOptions& passOptions) : passOptions(passOptions) {
    GetLocalCounter counter(func);
    UnneededSetRemover inner(counter, func, passOptions);
    removed = inner.removed;
  }

  UnneededSetRemover(GetLocalCounter& getLocalCounter, Function* func, PassOptions& passOptions) : passOptions(passOptions), getLocalCounter(&getLocalCounter) {
    walk(func->body);
  }

  bool removed = false;

  void visitSetLocal(SetLocal *curr) {
    // If no possible uses, remove.
    if (getLocalCounter->num[curr->index] == 0) {
      remove(curr);
    }
    // If setting the same value as we already have, remove.
    auto* value = curr->value;
    while (true) {
      if (auto* set = value->dynCast<SetLocal>()) {
        if (set->index == curr->index) {
          remove(curr);
        } else {
          // Handle tee chains.
          value = set->value;
          continue;
        }
      } else if (auto* get = value->dynCast<GetLocal>()) {
        if (get->index == curr->index) {
          remove(curr);
        }
      }
      break;
    }
  }

  void remove(SetLocal* set) {
    auto* value = set->value;
    if (set->isTee()) {
      replaceCurrent(value);
    } else if (EffectAnalyzer(passOptions, set->value).hasSideEffects()) {
      Drop* drop = ExpressionManipulator::convert<SetLocal, Drop>(set);
      drop->value = value;
      drop->finalize();
    } else {
      ExpressionManipulator::nop(set);
    }
    removed = true;
  }
};

} // namespace wasm

#endif // wasm_ir_local_utils_h

