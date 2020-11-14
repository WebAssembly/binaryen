/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Misc optimizations that are useful for and/or are only valid for
// emscripten output.
//

#include <asmjs/shared-constants.h>
#include <ir/module-utils.h>
#include <ir/table-utils.h>
#include <map>
#include <memory>
#include <pass.h>
#include <set>
#include <vector>
#include <wasm.h>

#include "emscripten-optimizer/istring.h"
#include "literal.h"
#include "mixed_arena.h"
#include "support/name.h"
#include "wasm-traversal.h"

#define DEBUG_TYPE "post-emscripten"

namespace wasm {

namespace {

static bool isInvoke(Function* F) {
  return F->imported() && F->module == ENV && F->base.startsWith("invoke_");
}

} // namespace

struct PostEmscripten : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // Optimize exceptions
    optimizeExceptions(runner, module);
  }

  // Optimize exceptions (and setjmp) by removing unnecessary invoke* calls.
  // An invoke is a call to JS with a function pointer; JS does a try-catch
  // and calls the pointer, catching and reporting any error. If we know no
  // exception will be thrown, we can simply skip the invoke.
  void optimizeExceptions(PassRunner* runner, Module* module) {
    // First, check if this code even uses invokes.
    bool hasInvokes = false;
    for (auto& imp : module->functions) {
      if (isInvoke(imp.get())) {
        hasInvokes = true;
      }
    }
    if (!hasInvokes) {
      return;
    }
    // Next, see if the Table is flat, which we need in order to see where
    // invokes go statically. (In dynamic linking, the table is not flat,
    // and we can't do this.)
    TableUtils::FlatTable flatTable(module->table);
    if (!flatTable.valid) {
      return;
    }
    // This code has exceptions. Find functions that definitely cannot throw,
    // and remove invokes to them.
    struct Info
      : public ModuleUtils::CallGraphPropertyAnalysis<Info>::FunctionInfo {
      bool canThrow = false;
    };
    ModuleUtils::CallGraphPropertyAnalysis<Info> analyzer(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          // Assume any import can throw. We may want to reduce this to just
          // longjmp/cxa_throw/etc.
          info.canThrow = true;
        }
      });

    // Assume an indirect call might throw.
    analyzer.propagateBack(
      [](const Info& info) { return info.canThrow; },
      [](const Info& info) { return true; },
      [](Info& info, Function* reason) { info.canThrow = true; },
      analyzer.IndirectCallsHaveProperty);

    // Apply the information.
    struct OptimizeInvokes : public WalkerPass<PostWalker<OptimizeInvokes>> {
      bool isFunctionParallel() override { return true; }

      Pass* create() override { return new OptimizeInvokes(map, flatTable); }

      std::map<Function*, Info>& map;
      TableUtils::FlatTable& flatTable;

      OptimizeInvokes(std::map<Function*, Info>& map,
                      TableUtils::FlatTable& flatTable)
        : map(map), flatTable(flatTable) {}

      void visitCall(Call* curr) {
        auto* target = getModule()->getFunction(curr->target);
        if (isInvoke(target)) {
          // The first operand is the function pointer index, which must be
          // constant if we are to optimize it statically.
          if (auto* index = curr->operands[0]->dynCast<Const>()) {
            auto actualTarget = flatTable.names.at(index->value.geti32());
            if (!map[getModule()->getFunction(actualTarget)].canThrow) {
              // This invoke cannot throw! Make it a direct call.
              curr->target = actualTarget;
              for (Index i = 0; i < curr->operands.size() - 1; i++) {
                curr->operands[i] = curr->operands[i + 1];
              }
              curr->operands.resize(curr->operands.size() - 1);
            }
          }
        }
      }
    };
    OptimizeInvokes(analyzer.map, flatTable).run(runner, module);
  }
};

Pass* createPostEmscriptenPass() { return new PostEmscripten(); }

} // namespace wasm
