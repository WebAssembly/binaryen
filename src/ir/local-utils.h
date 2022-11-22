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
#include <ir/manipulation.h>
#include <ir/utils.h>

namespace wasm {

struct LocalGetCounter : public PostWalker<LocalGetCounter> {
  std::vector<Index> num;

  LocalGetCounter() = default;
  LocalGetCounter(Function* func) { analyze(func, func->body); }
  LocalGetCounter(Function* func, Expression* ast) { analyze(func, ast); }

  void analyze(Function* func) { analyze(func, func->body); }
  void analyze(Function* func, Expression* ast) {
    num.clear();
    num.resize(func->getNumLocals());
    walk(ast);
  }

  void visitLocalGet(LocalGet* curr) { num[curr->index]++; }
};

// Removes trivially unneeded sets: sets for whom there is no possible get, and
// sets of the same value immediately.
struct UnneededSetRemover : public PostWalker<UnneededSetRemover> {
  PassOptions& passOptions;

  LocalGetCounter* localGetCounter = nullptr;
  Module& module;

  UnneededSetRemover(Function* func, PassOptions& passOptions, Module& module)
    : passOptions(passOptions), module(module) {
    LocalGetCounter counter(func);
    UnneededSetRemover inner(counter, func, passOptions, module);
    removed = inner.removed;
  }

  UnneededSetRemover(LocalGetCounter& localGetCounter,
                     Function* func,
                     PassOptions& passOptions,
                     Module& module)
    : passOptions(passOptions), localGetCounter(&localGetCounter),
      module(module) {
    walk(func->body);

    if (refinalize) {
      ReFinalize().walkFunctionInModule(func, &module);
    }
  }

  bool removed = false;
  bool refinalize = false;

  void visitLocalSet(LocalSet* curr) {
    // If no possible uses, remove.
    if (localGetCounter->num[curr->index] == 0) {
      remove(curr);
    }
    // If setting the same value as we already have, remove.
    auto* value = curr->value;
    while (true) {
      if (auto* set = value->dynCast<LocalSet>()) {
        if (set->index == curr->index) {
          remove(curr);
        } else {
          // Handle tee chains.
          value = set->value;
          continue;
        }
      } else if (auto* get = value->dynCast<LocalGet>()) {
        if (get->index == curr->index) {
          remove(curr);
        }
      }
      break;
    }
  }

  void remove(LocalSet* set) {
    auto* value = set->value;
    if (set->isTee()) {
      replaceCurrent(value);
      if (value->type != set->type) {
        // The value is more refined, so we'll need to refinalize.
        refinalize = true;
      }
    } else if (EffectAnalyzer(passOptions, module, set->value)
                 .hasSideEffects()) {
      Drop* drop = ExpressionManipulator::convert<LocalSet, Drop>(set);
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
