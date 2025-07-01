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
// The motivation for this pass is to fuzz branch hint updates: given a fuzz
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
// same ID, and consider the predicted and actual values:
//
//  [id,0,0], [id,0,0] - nothing changed: good
//  [id,0,0], [id,0,1] - the actual result changed but not the prediction: bad
//  [id,0,0], [id,1,0] - prediction changed but not actual result: bad
//  [id,0,0], [id,1,1] - actual and predicted both changed: good
//  etc.
//
// To make it easy to pair the results, the ID is negative in subsequent
// instrumentations. That is, we will match an ID of 42 in the first
// instrumentation with an id of -42 in the last (that avoids us matching two
// from the first, if e.g. a branch happens twice in a loop). Thus, the first
// instrumentations adds positive IDs, and the second adds negative, which makes
// it trivial to differentiate them.
//
// Regardless of whether the hint was right or wrong, it should change in tandem
// with the actual result, see script/fuzz_opt.py's BranchHintPreservation.
//

#include "ir/eh-utils.h"
#include "ir/find_all.h"
#include "ir/names.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// The branch id, which increments as we go.
int branchId = 1;

struct InstrumentBranchHints
  : public WalkerPass<PostWalker<InstrumentBranchHints>> {
  // The module and base names of our import.
  Name MODULE = "fuzzing-support";
  Name BASE = "log-branch";

  // The internal name of our import.
  Name LOG_BRANCH;

  // Whether we are the second pass of instrumentation. If so, we only add
  // logic to parallel existing hints (for each such hint, we emit one with a
  // negative ID, so they can be paired, as mentioned above).
  bool secondInstrumentation = false;

  void visitIf(If* curr) { processCondition(curr); }

  void visitBreak(Break* curr) {
    if (curr->condition) {
      processCondition(curr);
    }
  }

  bool added = false;

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
      // In the second instrumentation we find existing calls and add paired
      // ones to them.
      for (auto* call : FindAll<Call>(curr->condition).list) {
        if (call->target == LOG_BRANCH) {
          if (id) {
            // We have seen another before, so give up (it is not worth the
            // effort to figure out what belongs to what).
            return;
          }
          // Use this ID, which must be from the first instrumentation.
          assert(call->operands.size() == 3);
          id = call->operands[0]->cast<Const>()->value.geti32();
          // We will use it negated.
          id = -id;
        }
      }
      if (!id) {
        // No call found.
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
      builder.makeCall(LOG_BRANCH, {idc, guess, get1}, Type::none);
    auto* get2 = builder.makeLocalGet(tempLocal, Type::i32);
    curr->condition = builder.makeBlock({set, logBranch, get2});
    added = true;
  }

  void visitFunction(Function* func) {
    // Our added blocks may have caused nested pops.
    if (added) {
      EHUtils::handleBlockNestedPops(func, *getModule());
      added = false;
    }
  }

  void doWalkModule(Module* module) {
    // Find our import, if we were already run on this module.
    for (auto& func : module->functions) {
      if (func->module == MODULE && func->base == BASE) {
        LOG_BRANCH = func->name;
        // The logging function existed before, so this is the second
        // instrumentation.
        secondInstrumentation = true;
        break;
      }
    }
    if (!LOG_BRANCH) {
      auto* func = module->addFunction(Builder::makeFunction(
        Names::getValidFunctionName(*module, BASE),
        Signature({Type::i32, Type::i32, Type::i32}, Type::none),
        {}));
      func->module = MODULE;
      func->base = BASE;
      LOG_BRANCH = func->name;
    }

    // Walk normally, using logBranch as we go.
    WalkerPass<PostWalker<InstrumentBranchHints>>::doWalkModule(module);
  }
};

} // anonymous namespace

Pass* createInstrumentBranchHintsPass() { return new InstrumentBranchHints(); }

} // namespace wasm
