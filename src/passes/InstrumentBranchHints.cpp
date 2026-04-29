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
//  ;; log the actual runtime result (condition), the prediction (B), and the
//  ;; ID (123), and return that result.
//  if (log(condition, B, 123)) {
//    X
//  } else {
//    Y
//  }
//
// Concretely, we emit calls to this logging function:
//
//  (import "fuzzing-support" "log-branch"
//    (func $log-branch (param i32 i32 i32) (result i32))
//  )
//
// This can be used to verify that branch hints are accurate, by implementing
// the import like this for example:
//
//  imports['fuzzing-support']['log-branch'] = (actual, prediction, id) => {
//    // We only care about truthiness of the expected and actual values.
//    expected = +!!expected;
//    actual = +!!actual;
//    // Throw if the hint said this branch would be taken, but it was not, or
//    // vice versa.
//    if (expected != actual) throw `Bad branch hint! (${id})`;
//    return actual;
//  };
//
// A pass to delete branch hints is also provided, which finds instrumentations
// and the IDs in those calls, and deletes branch hints that were listed. For
// example,
//
//  --delete-branch-hints=10,20
//
// would do this transformation:
//
//  @metadata.branch.hint A
//  if (log(condition, A, 10)) { // 10 matches one of 10,20
//    X
//  }
//  @metadata.branch.hint B
//  if (log(condition, B, 99)) { // 99 does not match
//    Y
//  }
//
// =>
//
//  // Used to be a branch hint here, but it was deleted.
//  if (log(condition, A, 10)) {
//    X
//  }
//  @metadata.branch.hint B // this one is unmodified.
//  if (log(condition, B, 99)) {
//    Y
//  }
//
// A pass to undo the instrumentation is also provided, which does
//
//  if (log(condition, A, 123)) {
//    X
//  }
//
// =>
//
//  if (condition) {
//    X
//  }
//

#include "ir/effects.h"
#include "ir/names.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/string.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// The module and base names of our import.
const Name MODULE = "fuzzing-support";
const Name BASE = "log-branch";

// Finds our import, if it exists.
Name getLogBranchImport(Module* module) {
  for (auto& func : module->functions) {
    if (func->module == MODULE && func->base == BASE) {
      return func->name;
    }
  }
  return Name();
}

// The branch id, which increments as we go.
int branchId = 1;

struct InstrumentBranchHints
  : public WalkerPass<PostWalker<InstrumentBranchHints>> {

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
    auto* idConst = builder.makeConst(Literal(int32_t(id)));
    auto* guess = builder.makeConst(Literal(int32_t(*likely)));

    curr->condition =
      builder.makeCall(logBranch, {curr->condition, guess, idConst}, Type::i32);
  }

  void doWalkModule(Module* module) {
    if (auto existing = getLogBranchImport(module)) {
      // This file already has our import. We nop it out, as whatever the
      // current code does may be dangerous (it may log incorrect hints).
      auto* func = module->getFunction(existing);
      Builder builder(*module);
      if (func->getSig().results == Type::none) {
        func->body = builder.makeNop();
      } else {
        func->body = builder.makeUnreachable();
      }
      func->module = func->base = Name();
      func->type = func->type.with(Exact);
    }

    // Add our import.
    auto* func = module->addFunction(Builder::makeFunction(
      Names::getValidFunctionName(*module, BASE),
      Type(Signature({Type::i32, Type::i32, Type::i32}, Type::i32),
           NonNullable,
           Inexact),
      {}));
    func->module = MODULE;
    func->base = BASE;
    logBranch = func->name;

    // Walk normally, using logBranch as we go.
    PostWalker<InstrumentBranchHints>::doWalkModule(module);

    // Update ref.func type changes.
    ReFinalize().run(getPassRunner(), module);
    ReFinalize().walkModuleCode(module);
  }
};

// Helper class that provides basic utilities for identifying and processing
// instrumentation from InstrumentBranchHints.
template<typename Sub>
struct InstrumentationProcessor : public WalkerPass<PostWalker<Sub>> {

  using Super = WalkerPass<PostWalker<Sub>>;

  // The internal name of our import.
  Name logBranch;

  Sub* self() { return static_cast<Sub*>(this); }

  void visitIf(If* curr) { self()->processCondition(curr); }

  void visitBreak(Break* curr) {
    if (curr->condition) {
      self()->processCondition(curr);
    }
  }

  // TODO: BrOn, but the condition there is not an i32

  void doWalkModule(Module* module) {
    logBranch = getLogBranchImport(module);
    if (!logBranch) {
      Fatal()
        << "No branch hint logging import found. Was this code instrumented?";
    }

    Super::doWalkModule(module);
  }
};

struct DeleteBranchHints : public InstrumentationProcessor<DeleteBranchHints> {
  using Super = InstrumentationProcessor<DeleteBranchHints>;

  // The set of IDs to delete.
  std::unordered_set<Index> idsToDelete;

  std::optional<uint32_t> getBranchID(Expression* condition,
                                      const PassOptions& passOptions,
                                      Module& wasm) {
    auto* call =
      Properties::getFallthrough(condition, getPassOptions(), *getModule())
        ->dynCast<Call>();
    if (!call || call->target != logBranch || call->operands.size() != 3) {
      return std::nullopt;
    }
    auto* c = call->operands[2]->dynCast<Const>();
    if (!c || c->type != Type::i32) {
      return std::nullopt;
    }
    return c->value.geti32();
  }

  template<typename T> void processCondition(T* curr) {
    if (auto id = getBranchID(curr->condition, getPassOptions(), *getModule());
        id && idsToDelete.contains(*id)) {
      // Remove the branch hint.
      getFunction()->codeAnnotations[curr].branchLikely = std::nullopt;
    }
  }

  void doWalkModule(Module* module) {
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

  // The internal name of our import.
  Name logBranch;

  void visitCall(Call* curr) {
    if (curr->target == logBranch) {
      // Replace the call with its first operand (the original condition).
      replaceCurrent(curr->operands[0]);
    }
  }

  void doWalkModule(Module* module) {
    logBranch = getLogBranchImport(module);
    if (!logBranch) {
      Fatal()
        << "No branch hint logging import found. Was this code instrumented?";
    }

    // Mark the log-branch import as having no side effects - we are removing it
    // entirely here, and its effect should not stop us when we compute effects.
    module->getFunction(logBranch)->effects =
      std::make_shared<EffectAnalyzer>(getPassOptions(), *module);

    WalkerPass<PostWalker<DeInstrumentBranchHints>>::doWalkModule(module);
  }
};

} // anonymous namespace

Pass* createInstrumentBranchHintsPass() { return new InstrumentBranchHints(); }
Pass* createDeleteBranchHintsPass() { return new DeleteBranchHints(); }
Pass* createDeInstrumentBranchHintsPass() {
  return new DeInstrumentBranchHints();
}

} // namespace wasm
