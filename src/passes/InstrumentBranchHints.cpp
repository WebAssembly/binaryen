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
// and the IDs in those calls, and deletes branch hints that were listed. For
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

#include "ir/drop.h"
#include "ir/eh-utils.h"
#include "ir/find_all.h"
#include "ir/local-graph.h"
#include "ir/names.h"
#include "ir/parents.h"
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
    if (auto existing = getLogBranchImport(module)) {
      // This file already has our import. We nop it out, as whatever the
      // current code does may be dangerous (it may log incorrect hints).
      auto* func = module->getFunction(existing);
      func->body = Builder(*module).makeNop();
      func->module = func->base = Name();
      func->type = func->type.with(Exact);
    }

    // Add our import.
    auto* func = module->addFunction(Builder::makeFunction(
      Names::getValidFunctionName(*module, BASE),
      Type(Signature({Type::i32, Type::i32, Type::i32}, Type::none),
           NonNullable,
           Inexact),
      {}));
    func->module = MODULE;
    func->base = BASE;
    logBranch = func->name;

    // Walk normally, using logBranch as we go.
    Super::doWalkModule(module);

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

  // A LocalGraph, so we can identify the pattern.
  std::unique_ptr<LocalGraph> localGraph;

  // A map of expressions to their parents, so we can identify the pattern.
  std::unique_ptr<Parents> parents;

  Sub* self() { return static_cast<Sub*>(this); }

  void visitIf(If* curr) { self()->processCondition(curr); }

  void visitBreak(Break* curr) {
    if (curr->condition) {
      self()->processCondition(curr);
    }
  }

  // TODO: BrOn, but the condition there is not an i32

  void doWalkFunction(Function* func) {
    localGraph = std::make_unique<LocalGraph>(func, this->getModule());
    localGraph->computeSetInfluences();

    parents = std::make_unique<Parents>(func->body);

    Super::doWalkFunction(func);
  }

  void doWalkModule(Module* module) {
    logBranch = getLogBranchImport(module);
    if (!logBranch) {
      Fatal()
        << "No branch hint logging import found. Was this code instrumented?";
    }

    Super::doWalkModule(module);
  }

  // Helpers

  // Instrumentation info for a chunk of code that is the result of the
  // instrumentation pass.
  struct Instrumentation {
    // The condition before the instrumentation (a pointer to it, so we can
    // replace it).
    Expression** originalCondition;
    // The call to the logging that the instrumentation added.
    Call* call;
  };

  // Check if an expression's condition is an instrumentation, and return the
  // info if so.
  std::optional<Instrumentation> getInstrumentation(Expression* condition) {
    // We must identify this pattern:
    //
    //  (br_if
    //    (block
    //      (local.set $temp (condition))
    //      (call $log (id, prediction, (local.get $temp)))
    //      (local.get $temp)
    //    )
    //
    // The block may vanish during roundtrip though, so we just follow back from
    // the last local.get, which appears in the condition:
    //
    //  (local.set $temp (condition))
    //  (call $log (id, prediction, (local.get $temp)))
    //  (br_if
    //    (local.get $temp)
    //
    auto* fallthrough = Properties::getFallthrough(
      condition, this->getPassOptions(), *this->getModule());
    auto* get = fallthrough->template dynCast<LocalGet>();
    if (!get) {
      return {};
    }
    auto& sets = localGraph->getSets(get);
    if (sets.size() != 1) {
      return {};
    }
    auto* set = *sets.begin();
    if (!set) {
      return {};
    }
    auto& gets = localGraph->getSetInfluences(set);
    if (gets.size() != 2) {
      return {};
    }
    // The set has two gets: the get in the condition we began at, and
    // another.
    LocalGet* otherGet = nullptr;
    for (auto* get2 : gets) {
      if (get2 != get) {
        otherGet = get2;
      }
    }
    assert(otherGet);
    // See if that other get is used in a logging. The parent should be a
    // logging call.
    auto* call = parents->getParent(otherGet)->template dynCast<Call>();
    if (!call || call->target != logBranch) {
      return {};
    }
    // Great, this is indeed a prior instrumentation.
    return Instrumentation{&set->value, call};
  }
};

struct DeleteBranchHints : public InstrumentationProcessor<DeleteBranchHints> {
  using Super = InstrumentationProcessor<DeleteBranchHints>;

  // The set of IDs to delete.
  std::unordered_set<Index> idsToDelete;

  template<typename T> void processCondition(T* curr) {
    if (auto info = getInstrumentation(curr->condition)) {
      if (auto* c = info->call->operands[0]->template dynCast<Const>()) {
        auto id = c->value.geti32();
        if (idsToDelete.count(id)) {
          // Remove the branch hint.
          getFunction()->codeAnnotations[curr].branchLikely = {};
        }
      }
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
  : public InstrumentationProcessor<DeInstrumentBranchHints> {

  template<typename T> void processCondition(T* curr) {
    if (auto info = getInstrumentation(curr->condition)) {
      // Replace the instrumented condition with the original one (swap so that
      // the IR remains valid: we cannot use the same expression twice in our
      // IR, and the original condition is still used in another place, until
      // we remove the logging calls; since we will remove the calls anyhow, we
      // just need some valid IR there).
      std::swap(curr->condition, *info->originalCondition);
    }
  }

  void visitFunction(Function* func) {
    if (func->imported()) {
      return;
    }
    // At the very end, remove all logging calls (we use them during the main
    // walk to identify instrumentation).
    for (auto** callp : FindAllPointers<Call>(func->body).list) {
      auto* call = (*callp)->cast<Call>();
      if (call->target == logBranch) {
        Builder builder(*getModule());
        Expression* last;
        if (call->type == Type::none) {
          last = builder.makeNop();
        } else {
          last = builder.makeUnreachable();
        }
        *callp = getDroppedChildrenAndAppend(call,
                                             *getModule(),
                                             getPassOptions(),
                                             last,
                                             // We know the call is removable.
                                             DropMode::IgnoreParentEffects);
      }
    }
  }
};

} // anonymous namespace

Pass* createInstrumentBranchHintsPass() { return new InstrumentBranchHints(); }
Pass* createDeleteBranchHintsPass() { return new DeleteBranchHints(); }
Pass* createDeInstrumentBranchHintsPass() {
  return new DeInstrumentBranchHints();
}

} // namespace wasm
