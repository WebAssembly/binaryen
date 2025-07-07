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
// A pass to delete branch hints is also provided, which finds instrumentations
// and the IDs in those calls, and deletes branch hints that were provded. For
// example,
//
//  --delete-branch-hints=10,20
//
// would do this transformation:
//
//  @metadata.branch.hint A
//  if (temp = condition; log(10, A, temp); temp) { // 10 matches one of 10,20
//    X
//  }
//  @metadata.branch.hint B
//  if (temp = condition; log(99, B, temp); temp) { // 99 does not match
//    Y
//  }
//
// =>
//
//  // Used to be a branch hint here, but it was deleted.
//  if (temp = condition; log(10, A, temp); temp) {
//    X
//  }
//  @metadata.branch.hint B // this one is unmodified.
//  if (temp = condition; log(99, B, temp); temp) {
//    Y
//  }
//
// A pass to undo the instrumentation is also provided, which does
//
//  if (temp = condition; log(123, A, temp); temp) {
//    X
//  }
//
// =>
//
//  if (condition) {
//    X
//  }
//

#include "ir/eh-utils.h"
#include "ir/names.h"
#include "ir/properties.h"
#include "pass.h"
#include "support/string.h"
#include "wasm-builder.h"
#include "wasm.h"

// Work around a gcc-14 issue
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"

namespace wasm {

namespace {

// The module and base names of our import.
const Name MODULE = "fuzzing-support";
const Name BASE = "log-branch";

// Finds our import, if it exists.
Name getLogBranchImport(Module* module) {
  // Find our import, if we were already run on this module.
  for (auto& func : module->functions) {
    if (func->module == MODULE && func->base == BASE) {
      return func->name;
    }
  }
  return nullptr;
}

// The branch id, which increments as we go.
int branchId = 1;

struct InstrumentBranchHints
  : public WalkerPass<PostWalker<InstrumentBranchHints>> {

  using Super = WalkerPass<PostWalker<InstrumentBranchHints>>;

  // The internal name of our import.
  Name logBranch;

  void visitIf(If* curr) { processCondition(curr); }

  void visitBreak(Break* curr) {
    if (curr->condition) {
      processCondition(curr);
    }
  }

  // TODO: BrOn, but the condition there is not an i32

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
    logBranch = getLogBranchImport(module);
    // If it doesn't exist, add it.
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

// Instrumentation info for a chunk of code that is the result of the
// instrumentation pass.
struct Instrumentation {
  // The condition before the instrumentation.
  Expression* originalCondition;
  // The call to the logging that the instrumentation added.
  Call* call;
};

// Check if an expression's condition is an instrumentation, and return the info
// if so. We are provided the internal name of the logging function.
std::optional<Instrumentation> getInstrumentation(Expression* condition, Name logBranch) {
  // We must identify this pattern:
  //
  //  (block
  //    (local.set $temp (condition))
  //    (call $log (id, prediction, (local.get $temp)))
  //    (local.get $temp)
  //  )
  //
  auto* block = condition->dynCast<Block>();
  if (!block) {
    return {};
  }
  auto& list = block->list;
  if (block->list.size() != 3) {
    return {};
  }
  auto *call = list[1]->dynCast<Call>();
  if (!call || call->target != logBranch) {
    return {};
  }
  // We found the call, so the rest must be in the proper form.
  auto* set = list[0]->cast<LocalSet>();
  return Instrumentation{ set->value, call };
}

struct DeleteBranchHints
  : public WalkerPass<PostWalker<DeleteBranchHints>> {

  using Super = WalkerPass<PostWalker<DeleteBranchHints>>;

  // The internal name of our import.
  Name logBranch;

  // The set of IDs to delete.
  std::unordered_set<Index> idsToDelete;

  void visitIf(If* curr) { processCondition(curr); }

  void visitBreak(Break* curr) {
    if (curr->condition) {
      processCondition(curr);
    }
  }

  // TODO: BrOn, but the condition there is not an i32

  template<typename T> void processCondition(T* curr) {
    if (auto info = getInstrumentation(curr->condition, logBranch)) {
      auto id = info->call->operands[0]->template cast<Const>()->value.geti32();
      if (idsToDelete.count(id)) {
        // Remove the branch hint.
        getFunction()->codeAnnotations[curr].branchLikely = {};
      }
    }
  }

  void doWalkModule(Module* module) {
    logBranch = getLogBranchImport(module);
    if (!logBranch) {
      Fatal() << "No branch hint logging import found. Was this code instrumented?";
    }

    auto arg = getArgument(
      "delete-branch-hints",
      "DeleteBranchHints usage:  wasm-opt --delete-branch-hints=10,20,30");
    for (auto& str : String::Split(arg, String::Split::NewLineOr(","))) {
      idsToDelete.insert(std::stoi(str));
    }

    Super::doWalkModule(module);
  }
};

struct DeInstrumentBranchHints
  : public WalkerPass<PostWalker<DeInstrumentBranchHints>> {

  using Super = WalkerPass<PostWalker<DeInstrumentBranchHints>>;

  // The internal name of our import.
  Name logBranch;

  void visitIf(If* curr) { processCondition(curr); }

  void visitBreak(Break* curr) {
    if (curr->condition) {
      processCondition(curr);
    }
  }

  // TODO: BrOn, but the condition there is not an i32

  template<typename T> void processCondition(T* curr) {
    if (auto info = getInstrumentation(curr->condition, logBranch)) {
      // Replace the instrumentated condition with the original one.
      curr->condition = info->originalCondition;
    }
  }

  void doWalkModule(Module* module) {
    logBranch = getLogBranchImport(module);
    if (!logBranch) {
      Fatal() << "No branch hint logging import found. Was this code instrumented?";
    }

    Super::doWalkModule(module);
  }
};

#pragma GCC diagnostic pop

} // anonymous namespace

Pass* createInstrumentBranchHintsPass() { return new InstrumentBranchHints(); }
Pass* createDeleteBranchHintsPass() { return new DeleteBranchHints(); }
Pass* createDeInstrumentBranchHintsPass() { return new DeInstrumentBranchHints(); }

} // namespace wasm
