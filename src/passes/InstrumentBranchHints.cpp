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

//
// Instruments branch hints and their targets, adding logging that allows us to
// see if the hints were valid or not. We turn
//
//  @metadata.branch.hint B
//  if (condition) {
//    X
//  } else {
//    Y
//  }
//
// into
//
//  @metadata.branch.hint B
//  ;; log the ID of the condition (123), the prediction (B), and the actual
//  ;; runtime result (temp == condition).
//  if (temp = condition; log(123, B, temp); temp) {
//    X
//  } else {
//    Y
//  }
//
// Concretely, we emit calls to this logging function:
//
//  (import "fuzzing-support" "log-branch"
//    (func $log-branch (param i32 i32 i32)) ;; ID, prediction, actual
//  )
//
// This can be used to verify that branch hints are accurate, by implementing
// the import like this for example:
//
//  imports['fuzzing-support']['log-branch'] = (id, prediction, actual) => {
//    // We only care about truthiness of the expected and actual values.
//    expected = +!!expected;
//    actual = +!!actual;
//    // Throw if the hint said this branch would be taken, but it was not, or
//    // vice versa.
//    if (expected != actual) throw `Bad branch hint! (${id})`;
//  };
//

#include "ir/eh-utils.h"
#include "ir/names.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// The branch id, which increments as we go.
int branchId = 1;

struct InstrumentBranchHints
  : public WalkerPass<PostWalker<InstrumentBranchHints>> {

  using Super = WalkerPass<PostWalker<InstrumentBranchHints>>;

  // The module and base names of our import.
  const Name MODULE = "fuzzing-support";
  const Name BASE = "log-branch";

  // The internal name of our import.
  Name logBranch;

  void visitIf(If* curr) { processCondition(curr); }

  void visitBreak(Break* curr) {
    if (curr->condition) {
      processCondition(curr);
    }
  }

  bool addedInstrumentation = false;

  template<typename T> void processCondition(T* curr) {
    if (curr->condition->type == Type::unreachable) {
      // This branch is not even reached.
      return;
    }

    auto likely = getFunction()->codeAnnotations[curr].branchLikely;
    if (!likely) {
      return;
    }

    Builder builder(*getModule());

    // Pick an ID for this branch.
    int id = branchId++;

    // Instrument the condition.
    auto tempLocal = builder.addVar(getFunction(), Type::i32);
    auto* set = builder.makeLocalSet(tempLocal, curr->condition);
    auto* idConst = builder.makeConst(Literal(int32_t(id)));
    auto* guess = builder.makeConst(Literal(int32_t(*likely)));
    auto* get1 = builder.makeLocalGet(tempLocal, Type::i32);
    auto* log = builder.makeCall(logBranch, {idConst, guess, get1}, Type::none);
    auto* get2 = builder.makeLocalGet(tempLocal, Type::i32);
    curr->condition = builder.makeBlock({set, log, get2});
    addedInstrumentation = true;
  }

  void doWalkFunction(Function* func) {
    Super::doWalkFunction(func);

    // Our added blocks may have caused nested pops.
    if (addedInstrumentation) {
      EHUtils::handleBlockNestedPops(func, *getModule());
      addedInstrumentation = false;
    }
  }

  void doWalkModule(Module* module) {
    // Find our import, if we were already run on this module.
    for (auto& func : module->functions) {
      if (func->module == MODULE && func->base == BASE) {
        logBranch = func->name;
        break;
      }
    }
    // Otherwise, add it.
    if (!logBranch) {
      auto* func = module->addFunction(Builder::makeFunction(
        Names::getValidFunctionName(*module, BASE),
        Signature({Type::i32, Type::i32, Type::i32}, Type::none),
        {}));
      func->module = MODULE;
      func->base = BASE;
      logBranch = func->name;
    }

    // Walk normally, using logBranch as we go.
    Super::doWalkModule(module);
  }
};

} // anonymous namespace

Pass* createInstrumentBranchHintsPass() { return new InstrumentBranchHints(); }

} // namespace wasm
