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
// Another use case for this pass is to fuzz branch hint updates: given a fuzz
// case, we can instrument it and view the loggings, then optimize the original,
// instrument that, and view those loggings. Imagine, for example, that we flip
// the condition but forget to flip the hint:
//
//  @metadata.branch.hint B
//  if (!(temp = condition; log(123, B, temp); temp)) { ;; added a !
//    Y                                                 ;; this moved
//  } else {
//    X                                                 ;; this moved
//  }
//
// The logging before would be 123,B,C (where C is 0 or 1 - the hint might be
// wrong or right, in a fuzz testcase), and the logging after will remain the
// same, so this did not help us yet (because the ! is not the entire condition,
// not just |condition|). But if we run this instrumentation again, we get this:
//
//  @metadata.branch.hint B
//  if (temp2 = (
//                !(temp = condition; log(123, B, temp); temp)
//              ); log(123, B, temp2); temp2)) {
//    Y
//  } else {
//    X
//  }
//
// Note how the full !-ed condition is nested inside another instrumentation
// with another temp local. Also, we inferred the same ID (123) in both cases,
// by scanning the inside of the condition. Using that, the new logging will be
// 123,B,C followed by 123,B,!C. We can therefore find pairs of loggings with
// the same ID, and consider the predicted and actual values:
//
//  [id,0,0], [id,0,0] - nothing changed: good
//  [id,0,0], [id,0,1] - the actual result changed but not the prediction: bad
//  [id,0,0], [id,1,0] - prediction changed but not actual result: bad
//  [id,0,0], [id,1,1] - actual and predicted both changed: good
//  etc.
//
// To make it easy to pair the results, the ID is negative in subsequent
// instrumentations. That is, we will match an ID of 42 in the first
// instrumentation with an id of -42 in the second (that avoids us matching two
// from the first, if e.g. a branch happens twice in a loop). Thus, the first
// instrumentations adds positive IDs, and the second adds negative, which makes
// it trivial to differentiate them. (See script/fuzz_opt.py's
// BranchHintPreservation for more details.)
//

#include "ir/eh-utils.h"
#include "ir/local-graph.h"
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
  static Name MODULE = "fuzzing-support";
  static Name BASE = "log-branch";

  // The internal name of our import.
  Name logBranch;

  // Whether we are the second pass of instrumentation. If so, we only add
  // logic to parallel existing hints (for each such hint, we emit one with a
  // negative ID, so they can be paired, as mentioned above).
  bool secondInstrumentation = false;

  std::unique_ptr<LocalGraph> localGraph;

  void visitIf(If* curr) { processCondition(curr); }

  void visitBreak(Break* curr) {
    if (curr->condition) {
      processCondition(curr);
    }
  }

  // Track existing calls to our logging, and their gets, so that we can
  // identify them and add the second instrumentation properly. This map stores
  // gets that map to such calls, specifically their actual values (the same
  // value used in the branch, which we want to instrument). We also map tees.
  std::unordered_map<LocalGet*, Call*> getsOfPriorInstrumentation;
  std::unordered_map<LocalSet*, Call*> teesOfPriorInstrumentation;

  void visitCall(Call* curr) {
    if (curr->target != logBranch) {
      return;
    }
    // Our logging has 3 fields: id, expected, actual.
    if (curr->operands.size() == 3) {
      if (auto* get = curr->operands[2]->dynCast<LocalGet>()) {
        getsOfPriorInstrumentation[get] = curr;
      } else if (auto* tee = curr->operands[2]->dynCast<LocalSet>()) {
        teesOfPriorInstrumentation[tee] = curr;
      }
    }
    // Anything else is a pattern we don't recognize (perhaps this is a fuzzer-
    // modified testcase), and we skip.
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
    int id = 0;
    if (!secondInstrumentation) {
      // This is the first instrumentation. We instrument everything, using a
      // new positive ID for each.
      id = branchId++;
    } else {
      // In the second instrumentation we find existing instrumentation and add
      // paired ones to them. To find the existing ones, we look for this
      // condition being a local.get that is used in a call to our import, that
      // is, something like the pattern we emit below:
      //
      //  (local.set $temp ..)
      //  (call logBranch (local.get $temp))  ;; used in logging
      //  (if
      //    (local.get $temp)                  ;; and used in condition
      //
      // We also consider the fallthrough, for the nested case:
      //
      //  (if
      //    (block
      //      (local.set $temp ..)
      //      (call logBranch (local.get $temp))  ;; used in logging
      //      (local.get $temp)                    ;; and used in condition
      //    )
      //
      auto* fallthrough = Properties::getFallthrough(
        curr->condition, getPassOptions(), *getModule());
      auto* get = fallthrough->template dynCast<LocalGet>();
      if (!get) {
        return;
      }
      auto& sets = localGraph->getSets(get);
      if (sets.size() != 1) {
        return;
      }
      auto* set = *sets.begin();
      auto& gets = localGraph->getSetInfluences(set);
      Call* call = nullptr;
      if (gets.size() == 2) {
        // The set has two gets: the get in the condition we began at, and
        // another.
        LocalGet* otherGet = nullptr;
        for (auto* get2 : gets) {
          if (get2 != get) {
            otherGet = get2;
          }
        }
        assert(otherGet);
        // See if that other get is used in a logging.
        auto iter = getsOfPriorInstrumentation.find(otherGet);
        if (iter == getsOfPriorInstrumentation.end()) {
          return;
        }
        // Great, this is indeed a prior instrumentation.
        call = iter->second;
      } else if (gets.size() == 1) {
        // The set has only one get, but it might be a tee that flows into a
        // call:
        //
        //  (call logBranch (local.tee $temp (..)))  ;; used in logging
        //  (if
        //    (local.get $temp)                      ;; and used in condition
        //
        auto iter = teesOfPriorInstrumentation.find(set);
        if (iter == teesOfPriorInstrumentation.end()) {
          return;
        }
        // Great, this is indeed a prior instrumentation.
        call = iter->second;
      } else {
        // The get has more uses; give up, as the pattern is not what we
        // expect.
        return;
      }

      // We found a potential call from a prior instrumentation. It should be in
      // the proper form, and have a const ID.
      if (call->operands.size() != 3) {
        return;
      }
      auto* c = call->operands[0]->template dynCast<Const>();
      if (!c) {
        return;
      }
      // Emit logging to pair with it, with negated ID.
      id = -c->value.geti32();
      if (id > 0) {
        // The seen ID was already negated, so we negated it again to be
        // positive. That means the existing instrumentation was a second
        // instrumentation, and we should only operate on positive IDs and emit
        // negative ones.
        return;
      }
    }

    // Instrument the condition.
    auto tempLocal = builder.addVar(getFunction(), Type::i32);
    auto* set = builder.makeLocalSet(tempLocal, curr->condition);
    auto* idc = builder.makeConst(Literal(int32_t(id)));
    auto* guess = builder.makeConst(Literal(int32_t(*likely)));
    auto* get1 = builder.makeLocalGet(tempLocal, Type::i32);
    auto* logBranch =
      builder.makeCall(logBranch, {idc, guess, get1}, Type::none);
    auto* get2 = builder.makeLocalGet(tempLocal, Type::i32);
    curr->condition = builder.makeBlock({set, logBranch, get2});
    addedInstrumentation = true;
  }

  void doWalkFunction(Function* func) {
    if (secondInstrumentation) {
      localGraph = std::make_unique<LocalGraph>(func, getModule());
      localGraph->computeSetInfluences();
    }

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
        // The logging function existed before, so this is the second
        // instrumentation.
        secondInstrumentation = true;
        break;
      }
    }
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
